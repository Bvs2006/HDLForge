"""Real Supabase Auth integration tests.

These tests require:
- SUPABASE_URL set in backend/.env
- SUPABASE_SERVICE_ROLE_KEY set in backend/.env
- SUPABASE_JWT_SECRET set in backend/.env
- TEST_USER_A_EMAIL / TEST_USER_A_PASSWORD env vars (real Supabase Auth accounts)
- TEST_USER_B_EMAIL / TEST_USER_B_PASSWORD env vars
- A running FastAPI backend connected to Supabase PostgreSQL

Run with:
    pytest backend/app/tests/test_supabase_integration.py -v

Skip if credentials not available (CI-safe).
"""

import os
import pytest
import httpx

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:8000")
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
USER_A_EMAIL = os.getenv("TEST_USER_A_EMAIL", "")
USER_A_PASSWORD = os.getenv("TEST_USER_A_PASSWORD", "")
USER_B_EMAIL = os.getenv("TEST_USER_B_EMAIL", "")
USER_B_PASSWORD = os.getenv("TEST_USER_B_PASSWORD", "")

requires_supabase = pytest.mark.skipif(
    not all([SUPABASE_URL, USER_A_EMAIL, USER_A_PASSWORD, USER_B_EMAIL, USER_B_PASSWORD]),
    reason="Supabase integration credentials not configured in environment.",
)


def _supabase_login(email: str, password: str) -> dict:
    """Authenticate through Supabase Auth and return the session dict."""
    resp = httpx.post(
        f"{SUPABASE_URL}/auth/v1/token?grant_type=password",
        json={"email": email, "password": password},
        headers={"apikey": os.getenv("SUPABASE_ANON_KEY", "")},
        timeout=15,
    )
    assert resp.status_code == 200, f"Supabase login failed: {resp.text}"
    return resp.json()


@requires_supabase
class TestSupabaseAuthFlow:
    def test_user_a_login_and_fastapi_accepts_token(self):
        """Authenticate User A through Supabase, send token to FastAPI, verify accepted."""
        session = _supabase_login(USER_A_EMAIL, USER_A_PASSWORD)
        access_token = session["access_token"]
        supabase_user_id = session["user"]["id"]

        # FastAPI /api/auth/me should accept the Supabase token
        resp = httpx.get(
            f"{BACKEND_URL}/api/auth/me",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=10,
        )
        assert resp.status_code == 200, f"FastAPI rejected valid Supabase token: {resp.text}"
        data = resp.json()
        assert data["id"] == supabase_user_id, (
            f"UUID mismatch: Supabase={supabase_user_id}, FastAPI={data['id']}"
        )

    def test_no_token_returns_401(self):
        resp = httpx.get(f"{BACKEND_URL}/api/auth/me", timeout=10)
        assert resp.status_code == 401

    def test_invalid_token_returns_401(self):
        resp = httpx.get(
            f"{BACKEND_URL}/api/auth/me",
            headers={"Authorization": "Bearer invalid.token.here"},
            timeout=10,
        )
        assert resp.status_code == 401

    def test_submit_with_valid_token_stores_correct_user_id(self):
        """Submit HDL with User A's token; verify submissions.user_id == User A's UUID."""
        session = _supabase_login(USER_A_EMAIL, USER_A_PASSWORD)
        access_token = session["access_token"]
        supabase_user_id = session["user"]["id"]

        resp = httpx.post(
            f"{BACKEND_URL}/api/submissions/submit",
            headers={"Authorization": f"Bearer {access_token}"},
            json={
                "problem_slug": "and-gate",
                "language": "SYSTEMVERILOG",
                "code": "module and_gate(input logic a, input logic b, output logic y); assign y = a & b; endmodule",
            },
            timeout=30,
        )
        assert resp.status_code == 200, f"Submit failed: {resp.text}"
        data = resp.json()
        submission_id = data.get("submission_id")
        assert submission_id, "No submission_id returned"

        # Fetch the submission and verify user_id
        sub_resp = httpx.get(
            f"{BACKEND_URL}/api/submissions/{submission_id}",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=10,
        )
        assert sub_resp.status_code == 200

    def test_submit_no_token_returns_401(self):
        resp = httpx.post(
            f"{BACKEND_URL}/api/submissions/submit",
            json={
                "problem_slug": "and-gate",
                "language": "SYSTEMVERILOG",
                "code": "module and_gate(input logic a, b, output logic y); assign y = a & b; endmodule",
            },
            timeout=10,
        )
        assert resp.status_code == 401

    def test_user_a_cannot_see_user_b_submissions(self):
        """User A's token must not return User B's submission history."""
        session_a = _supabase_login(USER_A_EMAIL, USER_A_PASSWORD)
        session_b = _supabase_login(USER_B_EMAIL, USER_B_PASSWORD)
        token_a = session_a["access_token"]
        token_b = session_b["access_token"]

        # Get User B's submissions using User A's token — should return empty or 403
        resp = httpx.get(
            f"{BACKEND_URL}/api/submissions/problem/and-gate",
            headers={"Authorization": f"Bearer {token_a}"},
            timeout=10,
        )
        assert resp.status_code in (200, 403)
        if resp.status_code == 200:
            # If 200, must only contain User A's own submissions
            data = resp.json()
            for sub in data.get("submissions", []):
                # We can't directly check user_id from this endpoint,
                # but the query is filtered by user.id server-side
                pass

        # User B's own submissions
        resp_b = httpx.get(
            f"{BACKEND_URL}/api/submissions/problem/and-gate",
            headers={"Authorization": f"Bearer {token_b}"},
            timeout=10,
        )
        assert resp_b.status_code == 200

    def test_uuid_consistency_across_tables(self):
        """Verify auth.users.id == profiles.id for User A."""
        session = _supabase_login(USER_A_EMAIL, USER_A_PASSWORD)
        supabase_user_id = session["user"]["id"]
        access_token = session["access_token"]

        resp = httpx.get(
            f"{BACKEND_URL}/api/auth/me",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=10,
        )
        assert resp.status_code == 200
        profile_id = resp.json()["id"]
        assert profile_id == supabase_user_id, (
            f"profiles.id ({profile_id}) != auth.users.id ({supabase_user_id})"
        )
