import pytest
from unittest.mock import patch, MagicMock
from pathlib import Path

from app.execution.limits import ExecutionLimits
from app.execution.workspace import ExecutionWorkspace
from app.execution.runner import ExecutionRunner, ExecutionJob
from app.simulator.result_parser import ResultParser
from app.simulator.base import SimulationStatus


class TestExecutionLimits:
    def test_default_limits(self):
        limits = ExecutionLimits()
        assert limits.timeout_seconds == 5
        assert limits.memory_mb == 256
        assert limits.max_source_size == 50000

    def test_from_env(self):
        limits = ExecutionLimits.from_env()
        assert limits.timeout_seconds >= 1
        assert limits.memory_mb >= 64


class TestExecutionWorkspace:
    def test_create_and_cleanup(self):
        workspace = ExecutionWorkspace()
        workspace.create()
        assert workspace.workspace_path.exists()
        workspace.cleanup()
        assert not workspace.workspace_path.exists()

    def test_context_manager(self):
        with ExecutionWorkspace() as workspace:
            assert workspace.workspace_path.exists()
        assert not workspace.workspace_path.exists()

    def test_write_files(self):
        with ExecutionWorkspace() as workspace:
            sub_path = workspace.write_submission("module test; endmodule")
            assert sub_path.exists()
            assert sub_path.read_text() == "module test; endmodule"

            tb_path = workspace.write_testbench("module tb; endmodule")
            assert tb_path.exists()

            custom_path = workspace.write_file("custom.sv", "content")
            assert custom_path.exists()


class TestResultParser:
    def setup_method(self):
        self.parser = ResultParser()

    def test_parse_passing_tests(self):
        stdout = (
            "HDLFORGE_TEST_NAME:test 1\n"
            "HDLFORGE_TEST_PASS\n"
            "HDLFORGE_TEST_NAME:test 2\n"
            "HDLFORGE_TEST_PASS\n"
            "HDLFORGE_SCORE:100\n"
        )
        result = self.parser.parse(stdout)
        assert result.status == SimulationStatus.PASSED
        assert result.score == 100
        assert len(result.tests) == 2
        assert all(t.passed for t in result.tests)

    def test_parse_failing_tests(self):
        stdout = (
            "HDLFORGE_TEST_NAME:test 1\n"
            "HDLFORGE_TEST_PASS\n"
            "HDLFORGE_TEST_NAME:test 2\n"
            "HDLFORGE_EXPECTED:0\n"
            "HDLFORGE_RECEIVED:1\n"
            "HDLFORGE_TEST_FAIL\n"
            "HDLFORGE_SCORE:50\n"
        )
        result = self.parser.parse(stdout)
        assert result.status == SimulationStatus.FAILED
        assert result.score == 50
        assert len(result.tests) == 2
        assert result.tests[0].passed is True
        assert result.tests[1].passed is False
        assert result.tests[1].expected == "0"
        assert result.tests[1].received == "1"

    def test_parse_no_tests(self):
        result = self.parser.parse("")
        assert result.status == SimulationStatus.RUNTIME_ERROR
        assert "No test results" in result.message

    def test_parse_partial_results(self):
        stdout = (
            "HDLFORGE_TEST_NAME:test 1\n"
            "HDLFORGE_TEST_PASS\n"
            "HDLFORGE_TEST_NAME:test 2\n"
        )
        result = self.parser.parse(stdout)
        assert len(result.tests) == 2
        assert result.tests[0].passed is True
        assert result.tests[1].passed is False


class TestExecutionRunner:
    def test_build_response_passed(self):
        from app.simulator.base import SimulationResult, TestResult as SimTestResult

        runner = ExecutionRunner(use_docker=False)
        sim_result = SimulationResult(
            status=SimulationStatus.PASSED,
            score=100,
            message="2/2 tests passed.",
            tests=[
                SimTestResult(name="test 1", passed=True),
                SimTestResult(name="test 2", passed=True),
            ],
        )
        response = runner._build_response(sim_result, elapsed=1.5)
        assert response.status == "PASSED"
        assert response.score == 100
        assert response.tests_passed == 2
        assert response.tests_total == 2
        assert response.execution_time == 1.5

    def test_build_response_compilation_error(self):
        from app.simulator.base import SimulationResult

        runner = ExecutionRunner(use_docker=False)
        sim_result = SimulationResult(
            status=SimulationStatus.COMPILATION_ERROR,
            message="Compilation failed.",
            compilation_output="Error: syntax error",
        )
        response = runner._build_response(sim_result, elapsed=0.5)
        assert response.status == "COMPILATION_ERROR"
        assert "syntax error" in (response.compilation_message or "")
