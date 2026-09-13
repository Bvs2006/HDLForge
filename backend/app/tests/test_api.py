import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.database import Base, get_db
from app.db.models import Difficulty, Language, Problem
from app.main import app


@pytest.fixture()
def db_engine():
    engine = create_engine(
        "sqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)
    engine.dispose()


@pytest.fixture()
def db_session(db_engine):
    TestingSession = sessionmaker(autocommit=False, autoflush=False, bind=db_engine)
    session = TestingSession()
    yield session
    session.close()


@pytest.fixture()
def client(db_engine):
    TestingSession = sessionmaker(autocommit=False, autoflush=False, bind=db_engine)

    def override_get_db():
        db = TestingSession()
        try:
            yield db
        finally:
            db.close()

    saved_overrides = dict(app.dependency_overrides)
    app.dependency_overrides[get_db] = override_get_db

    with TestClient(app) as c:
        yield c

    app.dependency_overrides.clear()
    app.dependency_overrides.update(saved_overrides)


AND_GATE_TESTBENCH = """\
module testbench;
  logic a, b, y;
  and_gate uut (.a(a), .b(b), .y(y));
  initial begin
    a = 0; b = 0; #1;
    if (y !== 1'b0) begin
      $display("HDLFORGE_TEST_NAME:and gate test");
      $display("HDLFORGE_EXPECTED:0");
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end else begin
      $display("HDLFORGE_TEST_NAME:and gate test");
      $display("HDLFORGE_TEST_PASS");
    end
    $display("HDLFORGE_SCORE:100");
    $finish;
  end
endmodule"""


def seed_test_problems(db):
    problems = [
        Problem(
            slug="and-gate",
            title="AND Gate",
            description="Implement a 2-input AND gate.",
            difficulty=Difficulty.EASY,
            category="Combinational Logic",
            language=Language.SYSTEMVERILOG,
            input_description="a, b",
            output_description="y",
            constraints="Single-bit values.",
            starter_code="module and_gate(input logic a, input logic b, output logic y); endmodule",
            test_cases=AND_GATE_TESTBENCH,
        ),
        Problem(
            slug="4-bit-counter",
            title="4-bit Counter",
            description="Design a synchronous 4-bit counter.",
            difficulty=Difficulty.MEDIUM,
            category="Sequential Logic",
            language=Language.SYSTEMVERILOG,
            input_description="clk, rst",
            output_description="count[3:0]",
            constraints="Synchronous reset.",
            starter_code="module counter(input logic clk, input logic rst, output logic [3:0] count); endmodule",
            test_cases="",
        ),
    ]
    for p in problems:
        db.add(p)
    db.commit()


class TestHealthEndpoint:
    def test_health_check(self, client):
        response = client.get("/api/health")
        assert response.status_code == 200
        assert response.json() == {"status": "ok"}


class TestProblemsEndpoint:
    def test_list_problems_empty(self, client):
        response = client.get("/api/problems")
        assert response.status_code == 200
        data = response.json()
        assert data["problems"] == []
        assert data["total"] == 0

    def test_list_problems_with_data(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 2
        assert len(data["problems"]) == 2

    def test_filter_by_difficulty(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems?difficulty=EASY")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 1
        assert data["problems"][0]["slug"] == "and-gate"

    def test_filter_by_category(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems?category=Sequential+Logic")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 1
        assert data["problems"][0]["slug"] == "4-bit-counter"

    def test_search_problems(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems?search=counter")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 1
        assert data["problems"][0]["slug"] == "4-bit-counter"

    def test_search_no_results(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems?search=nonexistent")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 0


class TestSingleProblemEndpoint:
    def test_get_problem_by_slug(self, client, db_session):
        seed_test_problems(db_session)
        response = client.get("/api/problems/and-gate")
        assert response.status_code == 200
        data = response.json()
        assert data["slug"] == "and-gate"
        assert data["title"] == "AND Gate"
        assert data["difficulty"] == "EASY"

    def test_get_problem_not_found(self, client):
        response = client.get("/api/problems/nonexistent")
        assert response.status_code == 404
        data = response.json()
        assert "not found" in data["detail"].lower()


class TestSubmissionEndpoints:
    def test_run_submission_problem_not_found(self, client):
        response = client.post(
            "/api/submissions/run",
            json={
                "problem_slug": "nonexistent",
                "language": "SYSTEMVERILOG",
                "code": "module test; endmodule",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "error"
        assert "not found" in data["message"].lower()

    def test_run_submission_no_testbench(self, client, db_session):
        seed_test_problems(db_session)
        response = client.post(
            "/api/submissions/run",
            json={
                "problem_slug": "4-bit-counter",
                "language": "SYSTEMVERILOG",
                "code": "module counter(input logic clk, input logic rst, output logic [3:0] count); endmodule",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "error"
        assert "no testbench" in data["message"].lower()

    def test_run_submission_validation_error(self, client):
        response = client.post(
            "/api/submissions/run",
            json={
                "problem_slug": "and-gate",
            },
        )
        assert response.status_code == 422

    def test_submit_solution_problem_not_found(self, client):
        response = client.post(
            "/api/submissions/submit",
            json={
                "problem_slug": "nonexistent",
                "language": "SYSTEMVERILOG",
                "code": "module test; endmodule",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "error"
