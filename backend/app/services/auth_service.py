"""Authentication service.

JWT verification strategy:
- Supabase issues ES256 tokens signed with an EC private key.
- We verify using the public key fetched from the Supabase JWKS endpoint.
- The JWKS public key is cached in-process after the first fetch.
- The legacy SUPABASE_JWT_SECRET (HS256) is kept for the local /auth/register+login
  flow used in unit tests only.
- Signature verification is ALWAYS performed. No unsigned tokens are accepted.
"""

import json
import threading
from datetime import datetime, timedelta, timezone
from typing import Optional

import bcrypt
import httpx
import jwt
from fastapi import HTTPException
from jwt.algorithms import ECAlgorithm, RSAAlgorithm
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.models import Profile

# ── JWKS public key cache ─────────────────────────────────────────────────────
_jwks_lock = threading.Lock()
_jwks_keys: list[dict] = []          # raw JWK dicts
_jwks_public_keys: dict[str, object] = {}  # kid -> public key object


def _fetch_jwks() -> None:
    """Fetch and cache the Supabase JWKS public keys."""
    global _jwks_keys, _jwks_public_keys
    url = settings.SUPABASE_URL.rstrip("/") + "/auth/v1/.well-known/jwks.json"
    try:
        r = httpx.get(url, timeout=10)
        r.raise_for_status()
        keys = r.json().get("keys", [])
        pub_keys = {}
        for k in keys:
            kid = k.get("kid", "default")
            kty = k.get("kty", "")
            if kty == "EC":
                pub_keys[kid] = ECAlgorithm.from_jwk(json.dumps(k))
            elif kty == "RSA":
                pub_keys[kid] = RSAAlgorithm.from_jwk(json.dumps(k))
        with _jwks_lock:
            _jwks_keys = keys
            _jwks_public_keys = pub_keys
    except Exception as exc:
        raise RuntimeError(f"Failed to fetch Supabase JWKS: {exc}") from exc


def _get_public_key(kid: Optional[str]) -> object:
    """Return the cached public key for the given kid, fetching if needed."""
    with _jwks_lock:
        keys = dict(_jwks_public_keys)

    if not keys:
        _fetch_jwks()
        with _jwks_lock:
            keys = dict(_jwks_public_keys)

    if not keys:
        raise HTTPException(status_code=500, detail="No JWKS public keys available.")

    if kid and kid in keys:
        return keys[kid]
    # Fall back to first key if kid not matched
    return next(iter(keys.values()))


# ── Supabase JWT verification ─────────────────────────────────────────────────

def verify_supabase_jwt(token: str) -> str:
    """Verify a Supabase-issued JWT and return the authenticated user UUID.

    Supports ES256/RS256 via JWKS (production) and HS256 legacy path.
    Signature is always verified. Expiry is always checked.
    Raises HTTPException(401) for any invalid/expired/malformed/missing token.
    """
    # Decode header to get kid and alg without verifying (safe — we verify below)
    try:
        unverified_header = jwt.get_unverified_header(token)
    except jwt.exceptions.DecodeError as exc:
        raise HTTPException(status_code=401, detail=f"Malformed token: {exc}")

    alg = unverified_header.get("alg", "")
    kid = unverified_header.get("kid")

    if alg in ("ES256", "RS256") and settings.SUPABASE_URL:
        # Asymmetric: verify with JWKS public key
        try:
            public_key = _get_public_key(kid)
        except RuntimeError as exc:
            raise HTTPException(status_code=500, detail=str(exc))

        try:
            payload = jwt.decode(
                token,
                public_key,
                algorithms=[alg],
                options={"verify_aud": False},
            )
        except jwt.ExpiredSignatureError:
            raise HTTPException(status_code=401, detail="Token has expired.")
        except jwt.InvalidTokenError as exc:
            raise HTTPException(status_code=401, detail=f"Invalid token: {exc}")

    elif alg == "HS256" and settings.SUPABASE_JWT_SECRET:
        # HS256 path: legacy Supabase projects or unit-test local JWT
        try:
            payload = jwt.decode(
                token,
                settings.SUPABASE_JWT_SECRET,
                algorithms=["HS256"],
                options={"verify_aud": False},
            )
        except jwt.ExpiredSignatureError:
            raise HTTPException(status_code=401, detail="Token has expired.")
        except jwt.InvalidTokenError as exc:
            raise HTTPException(status_code=401, detail=f"Invalid token: {exc}")

    else:
        raise HTTPException(status_code=401, detail=f"Unsupported token algorithm: {alg}")

    sub = payload.get("sub")
    if not sub:
        raise HTTPException(status_code=401, detail="Token missing sub claim.")

    return str(sub)


# ── Local JWT (unit-test / legacy register+login flow only) ───────────────────

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode(), hashed.encode())


def create_access_token(user_id: str) -> str:
    """Create a local HS256 JWT for the legacy /auth/register+login flow."""
    payload = {
        "sub": str(user_id),
        "exp": datetime.now(timezone.utc) + timedelta(hours=settings.JWT_EXPIRY_HOURS),
        "iat": datetime.now(timezone.utc),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm="HS256")


def decode_access_token(token: str) -> str | None:
    """Decode a local HS256 JWT. Returns user_id or None on any failure."""
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
        return str(payload["sub"])
    except (jwt.ExpiredSignatureError, jwt.InvalidTokenError, KeyError, ValueError):
        return None


# ── Profile lookup ────────────────────────────────────────────────────────────

def get_user_by_id(db: Session, user_id: str) -> Profile | None:
    return db.query(Profile).filter(Profile.id == user_id).first()


def get_user_by_username(db: Session, username: str) -> Profile | None:
    return db.query(Profile).filter(Profile.username == username).first()


def get_user_from_token(db: Session, token: str) -> Profile | None:
    """Resolve a Bearer token to a Profile.

    1. Try Supabase JWT (ES256/RS256 via JWKS, or HS256 legacy).
    2. Fall back to local HS256 JWT for the unit-test register/login flow.
    Returns None if the token is invalid or the profile does not exist.
    """
    # 1. Try Supabase JWT
    if settings.SUPABASE_URL:
        try:
            user_id = verify_supabase_jwt(token)
            return get_user_by_id(db, user_id)
        except HTTPException:
            pass

    # 2. Try local JWT
    user_id = decode_access_token(token)
    if user_id:
        return get_user_by_id(db, user_id)

    return None


# ── Legacy local auth (unit tests only) ──────────────────────────────────────

# In-memory email registry for the local register/login flow (unit tests only).
# Maps email -> (profile_id, password_hash). Not used in production.
_local_email_registry: dict[str, tuple[str, str]] = {}
_local_email_lock = threading.Lock()


def get_user_by_email(db: Session, email: str) -> Profile | None:
    """Look up a profile by email using the in-memory registry (unit tests only)."""
    with _local_email_lock:
        entry = _local_email_registry.get(email)
    if not entry:
        return None
    profile_id, _ = entry
    return get_user_by_id(db, profile_id)


def create_user(
    db: Session,
    email: str,
    username: str,
    password: str,
    display_name: str | None = None,
) -> Profile:
    """Create a local profile for unit tests."""
    user = Profile(
        username=username,
        display_name=display_name or username,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    with _local_email_lock:
        _local_email_registry[email] = (user.id, hash_password(password))
    return user


def authenticate_user(db: Session, email: str, password: str) -> Profile | None:
    """Authenticate via local password hash (unit tests only)."""
    with _local_email_lock:
        entry = _local_email_registry.get(email)
    if not entry:
        return None
    profile_id, stored_hash = entry
    if not verify_password(password, stored_hash):
        return None
    user = get_user_by_id(db, profile_id)
    if user:
        user.last_login_at = datetime.now(timezone.utc)
        db.commit()
    return user
