"""Tests for Phase 7: XP, achievements, leaderboard."""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.database import Base, get_db
from app.db.models import (
    Achievement,
    Difficulty,
    Language,
    Problem,
    User,
)
from app.main import app
from app.services.auth_service import create_access_token, hash_password
from app.services.achievement_service import calculate_level, LEVEL_THRESHOLDS


@pytest.fixture
def db_engine():
    engine = create_engine(
        "sqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)


@pytest.fixture
def db_session(db_engine):
    TestSession = sessionmaker(bind=db_engine)
    session = TestSession()
    yield session
    session.close()


@pytest.fixture
def client(db_engine):
    TestSession = sessionmaker(bind=db_engine)

    def override_get_db():
        session = TestSession()
        try:
            yield session
        finally:
            session.close()

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


@pytest.fixture
def test_user(db_session):
    user = User(
        email="test@example.com",
        username="testuser",
        password_hash=hash_password("password123"),
        display_name="Test User",
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture
def auth_headers(test_user):
    token = create_access_token(test_user.id)
    return {"Cookie": f"access_token={token}"}


@pytest.fixture
def test_problems(db_session):
    problems = []
    for i, (slug, title, diff, cat, lang) in enumerate([
        ("and-gate", "AND Gate", Difficulty.EASY, "combinational", Language.VERILOG),
        ("or-gate", "OR Gate", Difficulty.EASY, "combinational", Language.VERILOG),
        ("mux-2to1", "2:1 MUX", Difficulty.MEDIUM, "combinational", Language.VERILOG),
        ("counter", "Counter", Difficulty.MEDIUM, "sequential", Language.VERILOG),
        ("fsm-traffic", "Traffic Light FSM", Difficulty.HARD, "fsm", Language.VERILOG),
    ], start=1):
        p = Problem(
            slug=slug,
            title=title,
            description=f"Description for {title}",
            difficulty=diff,
            category=cat,
            language=lang,
            input_description="Input",
            output_description="Output",
            starter_code=f"module {slug.replace('-', '_')};\nendmodule",
        )
        db_session.add(p)
        problems.append(p)
    db_session.commit()
    return problems


class TestCalculateLevel:
    def test_level_1_at_zero_xp(self):
        assert calculate_level(0) == 1

    def test_level_increases(self):
        assert calculate_level(100) == 2
        assert calculate_level(250) == 3
        assert calculate_level(500) == 4

    def test_level_max(self):
        max_xp = LEVEL_THRESHOLDS[-1]
        level = calculate_level(max_xp + 1000)
        assert level == len(LEVEL_THRESHOLDS)


class TestLeaderboardEndpoint:
    def test_leaderboard_empty(self, client):
        resp = client.get("/api/leaderboard")
        assert resp.status_code == 200
        data = resp.json()
        assert data["entries"] == []
        assert data["total_users"] == 0

    def test_leaderboard_with_users(self, client, db_session):
        users = []
        for i in range(5):
            u = User(
                email=f"user{i}@example.com",
                username=f"user{i}",
                password_hash=hash_password("pass123"),
                xp=(5 - i) * 100,
                level=5 - i,
            )
            db_session.add(u)
            users.append(u)
        db_session.commit()

        resp = client.get("/api/leaderboard")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["entries"]) == 5
        assert data["entries"][0]["xp"] >= data["entries"][1]["xp"]
        assert data["total_users"] == 5

    def test_leaderboard_pagination(self, client, db_session):
        for i in range(25):
            u = User(
                email=f"page{i}@example.com",
                username=f"pageuser{i}",
                password_hash=hash_password("pass123"),
                xp=i * 10,
            )
            db_session.add(u)
        db_session.commit()

        resp = client.get("/api/leaderboard?page=1&limit=10")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["entries"]) == 10
        assert data["total_pages"] == 3

    def test_leaderboard_search(self, client, db_session):
        u1 = User(email="alice@example.com", username="alice", password_hash=hash_password("pass123"), xp=100)
        u2 = User(email="bob@example.com", username="bob", password_hash=hash_password("pass123"), xp=200)
        db_session.add_all([u1, u2])
        db_session.commit()

        resp = client.get("/api/leaderboard?search=ali")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["entries"]) == 1
        assert data["entries"][0]["username"] == "alice"

    def test_my_rank(self, client, test_user, auth_headers):
        resp = client.get("/api/leaderboard/me", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["rank"] == 1
        assert data["xp"] == 0

    def test_my_rank_unauthenticated(self, client):
        resp = client.get("/api/leaderboard/me")
        assert resp.status_code == 401


class TestAchievementsEndpoint:
    def test_list_achievements(self, client, db_session):
        ach = Achievement(
            slug="first-step",
            name="First Step",
            description="Solve your first problem",
            icon="🎯",
            xp_reward=10,
            condition_type="problems_solved",
            condition_value=1,
        )
        db_session.add(ach)
        db_session.commit()

        resp = client.get("/api/achievements")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["achievements"]) == 1
        assert data["achievements"][0]["slug"] == "first-step"
        assert data["achievements"][0]["unlocked"] is False

    def test_my_achievements(self, client, test_user, auth_headers, db_session):
        ach = Achievement(
            slug="first-step",
            name="First Step",
            description="Solve your first problem",
            icon="🎯",
            xp_reward=10,
            condition_type="problems_solved",
            condition_value=1,
        )
        db_session.add(ach)
        db_session.commit()

        resp = client.get("/api/achievements/me", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["total_unlocked"] == 0
        assert data["total_available"] == 1

    def test_my_achievements_unauthenticated(self, client):
        resp = client.get("/api/achievements/me")
        assert resp.status_code in (401, 403)


class TestSubmissionResponseWithXP:
    def test_submission_response_includes_xp_fields(self, client, test_user, auth_headers, db_session):
        problem = Problem(
            slug="test-problem",
            title="Test Problem",
            description="Test",
            difficulty=Difficulty.EASY,
            category="combinational",
            language=Language.VERILOG,
            input_description="Input",
            output_description="Output",
            starter_code="module test(); endmodule",
        )
        db_session.add(problem)
        db_session.commit()

        resp = client.post(
            "/api/submissions/submit",
            json={"problem_slug": "test-problem", "language": "VERILOG", "code": "module test(); endmodule"},
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "xp_earned" in data
        assert "xp_total" in data
        assert "level" in data
        assert "progress_status" in data
        assert "achievements_unlocked" in data


class TestUserModelXP:
    def test_user_default_xp(self, db_session):
        user = User(
            email="new@example.com",
            username="newuser",
            password_hash=hash_password("pass123"),
        )
        db_session.add(user)
        db_session.commit()
        db_session.refresh(user)
        assert user.xp == 0
        assert user.level == 1
        assert user.solved_count == 0
        assert user.total_submissions == 0
