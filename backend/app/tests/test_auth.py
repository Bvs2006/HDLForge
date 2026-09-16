import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.database import Base, get_db
from app.db.models import Difficulty, Language, Problem, Profile, UserProblemProgress, ProgressStatus
from app.main import app


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

    saved_overrides = dict(app.dependency_overrides)
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()
    app.dependency_overrides.update(saved_overrides)


class TestRegistration:
    def test_register_success(self, client):
        response = client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "password123",
                "display_name": "Test Profile",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["user"]["username"] == "testuser"
        assert data["user"]["display_name"] == "Test Profile"
        assert "token" in data

    def test_register_duplicate_email(self, client):
        client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "user1",
                "password": "password123",
            },
        )
        response = client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "user2",
                "password": "password123",
            },
        )
        assert response.status_code == 409
        assert "email" in response.json()["detail"].lower()

    def test_register_duplicate_username(self, client):
        client.post(
            "/api/auth/register",
            json={
                "email": "test1@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        response = client.post(
            "/api/auth/register",
            json={
                "email": "test2@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        assert response.status_code == 409
        assert "username" in response.json()["detail"].lower()

    def test_register_short_password(self, client):
        response = client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "12345",
            },
        )
        assert response.status_code == 422

    def test_register_invalid_email(self, client):
        response = client.post(
            "/api/auth/register",
            json={
                "email": "not-an-email",
                "username": "testuser",
                "password": "password123",
            },
        )
        assert response.status_code == 422


class TestLogin:
    def test_login_success(self, client):
        client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        response = client.post(
            "/api/auth/login",
            json={
                "email": "test@example.com",
                "password": "password123",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["user"]["username"] == "testuser"
        assert "token" in data

    def test_login_wrong_password(self, client):
        client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        response = client.post(
            "/api/auth/login",
            json={
                "email": "test@example.com",
                "password": "wrongpassword",
            },
        )
        assert response.status_code == 401

    def test_login_nonexistent_user(self, client):
        response = client.post(
            "/api/auth/login",
            json={
                "email": "nonexistent@example.com",
                "password": "password123",
            },
        )
        assert response.status_code == 401


class TestGetCurrentUser:
    def test_get_me_authenticated(self, client):
        register_response = client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        token = register_response.json()["token"]

        response = client.get(
            "/api/auth/me",
            cookies={"access_token": token},
        )
        assert response.status_code == 200
        assert response.json()["username"] == "testuser"

    def test_get_me_unauthenticated(self, client):
        response = client.get("/api/auth/me")
        assert response.status_code == 401

    def test_get_me_invalid_token(self, client):
        response = client.get(
            "/api/auth/me",
            cookies={"access_token": "invalid-token"},
        )
        assert response.status_code == 401


class TestLogout:
    def test_logout(self, client):
        response = client.post("/api/auth/logout")
        assert response.status_code == 200


class TestDashboard:
    def test_dashboard_authenticated(self, client):
        register_response = client.post(
            "/api/auth/register",
            json={
                "email": "test@example.com",
                "username": "testuser",
                "password": "password123",
            },
        )
        token = register_response.json()["token"]

        response = client.get(
            "/api/me/dashboard",
            cookies={"access_token": token},
        )
        assert response.status_code == 200
        data = response.json()
        assert "problems_solved" in data
        assert "xp" in data
        assert "category_progress" in data

    def test_dashboard_unauthenticated(self, client):
        response = client.get("/api/me/dashboard")
        assert response.status_code == 401
