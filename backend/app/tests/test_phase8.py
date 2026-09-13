"""Tests for Phase 8: Learning system."""

import json
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.database import Base, get_db
from app.db.models import (
    Concept,
    Difficulty,
    Language,
    Lesson,
    LessonPrerequisite,
    LearningModule,
    LearningPath,
    Problem,
    ProblemConcept,
    Quiz,
    QuizQuestion,
    User,
)
from app.main import app
from app.services.auth_service import create_access_token, hash_password
from app.services.learning_service import (
    are_prerequisites_met,
    complete_lesson,
    get_lesson_status,
    start_lesson,
    submit_quiz,
)


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
def curriculum(db_session):
    path = LearningPath(
        slug="test-path",
        title="Test Path",
        description="A test learning path",
        difficulty=Difficulty.EASY,
        estimated_hours=10,
    )
    db_session.add(path)
    db_session.flush()

    module = LearningModule(
        learning_path_id=path.id,
        slug="test-module",
        title="Test Module",
        description="A test module",
        order_index=0,
    )
    db_session.add(module)
    db_session.flush()

    lesson1 = Lesson(
        module_id=module.id,
        slug="lesson-1",
        title="Lesson 1",
        description="First lesson",
        content="Lesson 1 content",
        order_index=0,
        difficulty=Difficulty.EASY,
    )
    db_session.add(lesson1)
    db_session.flush()

    lesson2 = Lesson(
        module_id=module.id,
        slug="lesson-2",
        title="Lesson 2",
        description="Second lesson",
        content="Lesson 2 content",
        order_index=1,
        difficulty=Difficulty.EASY,
    )
    db_session.add(lesson2)
    db_session.flush()

    lesson3 = Lesson(
        module_id=module.id,
        slug="lesson-3",
        title="Lesson 3",
        description="Third lesson with prerequisite",
        content="Lesson 3 content",
        order_index=2,
        difficulty=Difficulty.MEDIUM,
    )
    db_session.add(lesson3)
    db_session.flush()

    db_session.add(LessonPrerequisite(lesson_id=lesson3.id, prerequisite_lesson_id=lesson1.id))
    db_session.flush()

    quiz = Quiz(lesson_id=lesson1.id, title="Quiz 1")
    db_session.add(quiz)
    db_session.flush()

    db_session.add(QuizQuestion(
        quiz_id=quiz.id,
        question="What is 1+1?",
        question_type="multiple_choice",
        options=json.dumps(["1", "2", "3", "4"]),
        correct_answer="2",
        explanation="1+1 equals 2",
        order_index=0,
    ))
    db_session.add(QuizQuestion(
        quiz_id=quiz.id,
        question="What is 2+2?",
        question_type="multiple_choice",
        options=json.dumps(["2", "3", "4", "5"]),
        correct_answer="4",
        explanation="2+2 equals 4",
        order_index=1,
    ))
    db_session.flush()

    concept = Concept(slug="test-concept", name="Test Concept", category="test")
    db_session.add(concept)
    db_session.flush()

    problem = db_session.query(Problem).filter(Problem.slug == "and-gate").first()
    if problem:
        db_session.add(ProblemConcept(problem_id=problem.id, concept_id=concept.id))

    db_session.commit()

    return {
        "path": path,
        "module": module,
        "lesson1": lesson1,
        "lesson2": lesson2,
        "lesson3": lesson3,
        "quiz": quiz,
        "concept": concept,
    }


class TestLearningPathsEndpoint:
    def test_list_paths_empty(self, client):
        resp = client.get("/api/learning/paths")
        assert resp.status_code == 200
        data = resp.json()
        assert data["paths"] == []

    def test_list_paths_with_data(self, client, curriculum):
        resp = client.get("/api/learning/paths")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["paths"]) == 1
        assert data["paths"][0]["slug"] == "test-path"

    def test_get_path_detail(self, client, curriculum):
        resp = client.get("/api/learning/paths/test-path")
        assert resp.status_code == 200
        data = resp.json()
        assert data["title"] == "Test Path"
        assert len(data["modules"]) == 1
        assert len(data["modules"][0]["lessons"]) == 3

    def test_get_path_not_found(self, client):
        resp = client.get("/api/learning/paths/nonexistent")
        assert resp.status_code == 404


class TestLessonEndpoint:
    def test_get_lesson(self, client, curriculum):
        resp = client.get("/api/learning/lessons/lesson-1")
        assert resp.status_code == 200
        data = resp.json()
        assert data["title"] == "Lesson 1"
        assert data["content"] == "Lesson 1 content"
        assert data["status"] == "NOT_STARTED"

    def test_get_lesson_not_found(self, client):
        resp = client.get("/api/learning/lessons/nonexistent")
        assert resp.status_code == 404

    def test_get_lesson_with_prerequisites(self, client, curriculum):
        resp = client.get("/api/learning/lessons/lesson-3")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["prerequisites"]) == 1
        assert data["prerequisites"][0]["slug"] == "lesson-1"


class TestLessonProgress:
    def test_start_lesson(self, client, curriculum, auth_headers):
        resp = client.post("/api/learning/lessons/lesson-1/start", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "IN_PROGRESS"

    def test_start_lesson_unauthenticated(self, client, curriculum):
        resp = client.post("/api/learning/lessons/lesson-1/start")
        assert resp.status_code == 401

    def test_complete_lesson(self, client, curriculum, auth_headers, test_user):
        client.post("/api/learning/lessons/lesson-1/start", headers=auth_headers)
        resp = client.post("/api/learning/lessons/lesson-1/complete", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["xp_earned"] == 5

    def test_complete_lesson_idempotent(self, client, curriculum, auth_headers, test_user):
        client.post("/api/learning/lessons/lesson-1/start", headers=auth_headers)
        resp1 = client.post("/api/learning/lessons/lesson-1/complete", headers=auth_headers)
        resp2 = client.post("/api/learning/lessons/lesson-1/complete", headers=auth_headers)
        assert resp1.json()["xp_earned"] == 5
        assert resp2.json()["xp_earned"] == 0


class TestPrerequisites:
    def test_prerequisites_not_met(self, client, curriculum, test_user, auth_headers):
        resp = client.get("/api/learning/lessons/lesson-3", headers=auth_headers)
        data = resp.json()
        assert data["prerequisites_met"] is False

    def test_prerequisites_met_after_completion(self, client, curriculum, test_user, auth_headers):
        client.post("/api/learning/lessons/lesson-1/start", headers=auth_headers)
        client.post("/api/learning/lessons/lesson-1/complete", headers=auth_headers)

        resp = client.get("/api/learning/lessons/lesson-3", headers=auth_headers)
        data = resp.json()
        assert data["prerequisites_met"] is True


class TestQuizEndpoint:
    def test_get_quiz(self, client, curriculum):
        resp = client.get("/api/learning/quizzes/lesson-1")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["questions"]) == 2

    def test_get_quiz_not_found(self, client, curriculum):
        resp = client.get("/api/learning/quizzes/lesson-2")
        assert resp.status_code == 404

    def test_submit_quiz_pass(self, client, curriculum, auth_headers):
        quiz_resp = client.get("/api/learning/quizzes/lesson-1")
        quiz_id = quiz_resp.json()["id"]

        resp = client.post(
            f"/api/learning/quizzes/{quiz_id}/attempt",
            json={"answers": ["2", "4"]},
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["score"] == 100.0
        assert data["passed"] is True
        assert data["xp_earned"] == 5

    def test_submit_quiz_fail(self, client, curriculum, auth_headers):
        quiz_resp = client.get("/api/learning/quizzes/lesson-1")
        quiz_id = quiz_resp.json()["id"]

        resp = client.post(
            f"/api/learning/quizzes/{quiz_id}/attempt",
            json={"answers": ["1", "3"]},
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["score"] == 0.0
        assert data["passed"] is False
        assert data["xp_earned"] == 0

    def test_submit_quiz_partial(self, client, curriculum, auth_headers):
        quiz_resp = client.get("/api/learning/quizzes/lesson-1")
        quiz_id = quiz_resp.json()["id"]

        resp = client.post(
            f"/api/learning/quizzes/{quiz_id}/attempt",
            json={"answers": ["2", "3"]},
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["score"] == 50.0
        assert data["passed"] is False


class TestLearningProgress:
    def test_get_progress(self, client, curriculum, auth_headers):
        resp = client.get("/api/learning/progress", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["total_lessons"] == 3
        assert data["completed_lessons"] == 0

    def test_get_progress_after_completion(self, client, curriculum, auth_headers):
        client.post("/api/learning/lessons/lesson-1/start", headers=auth_headers)
        client.post("/api/learning/lessons/lesson-1/complete", headers=auth_headers)

        resp = client.get("/api/learning/progress", headers=auth_headers)
        data = resp.json()
        assert data["completed_lessons"] == 1


class TestConceptMastery:
    def test_concept_mastery_empty(self, client, curriculum, auth_headers):
        resp = client.get("/api/learning/concepts/mastery", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["concepts"]) > 0

    def test_list_concepts(self, client, curriculum):
        resp = client.get("/api/learning/concepts")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["concepts"]) >= 1


class TestRecommendations:
    def test_recommendations(self, client, curriculum, auth_headers):
        resp = client.get("/api/learning/recommendations", headers=auth_headers)
        assert resp.status_code == 200
        data = resp.json()
        assert data["next_lesson"] is not None
        assert data["reason"] != ""


class TestRelatedProblems:
    def test_related_problems(self, client, curriculum):
        resp = client.get("/api/learning/practice/lesson-1")
        assert resp.status_code == 200
        data = resp.json()
        assert isinstance(data["problems"], list)
