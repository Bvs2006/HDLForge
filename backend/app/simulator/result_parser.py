import re

from app.simulator.base import SimulationResult, SimulationStatus, TestResult


class ResultParser:
    """Parses structured test output from HDL testbenches."""

    PASS_MARKER = "HDLFORGE_TEST_PASS"
    FAIL_MARKER = "HDLFORGE_TEST_FAIL"
    SCORE_MARKER = "HDLFORGE_SCORE:"
    TEST_NAME_MARKER = "HDLFORGE_TEST_NAME:"
    EXPECTED_MARKER = "HDLFORGE_EXPECTED:"
    RECEIVED_MARKER = "HDLFORGE_RECEIVED:"

    def parse(self, stdout: str, stderr: str = "") -> SimulationResult:
        tests: list[TestResult] = []
        score = 0
        current_test: str | None = None
        current_expected: str = ""
        current_received: str = ""

        for line in stdout.split("\n"):
            line = line.strip()

            if line.startswith(self.TEST_NAME_MARKER):
                if current_test is not None:
                    tests.append(
                        TestResult(
                            name=current_test,
                            passed=False,
                            expected=current_expected,
                            received=current_received,
                        )
                    )
                current_test = line[len(self.TEST_NAME_MARKER) :].strip()
                current_expected = ""
                current_received = ""

            elif line.startswith(self.EXPECTED_MARKER):
                current_expected = line[len(self.EXPECTED_MARKER) :].strip()

            elif line.startswith(self.RECEIVED_MARKER):
                current_received = line[len(self.RECEIVED_MARKER) :].strip()

            elif line.startswith(self.PASS_MARKER):
                if current_test is not None:
                    tests.append(
                        TestResult(name=current_test, passed=True, message="PASSED")
                    )
                    current_test = None
                    current_expected = ""
                    current_received = ""

            elif line.startswith(self.FAIL_MARKER):
                if current_test is not None:
                    tests.append(
                        TestResult(
                            name=current_test,
                            passed=False,
                            expected=current_expected,
                            received=current_received,
                            message="FAILED",
                        )
                    )
                    current_test = None
                    current_expected = ""
                    current_received = ""

            elif line.startswith(self.SCORE_MARKER):
                try:
                    score = int(line[len(self.SCORE_MARKER) :].strip())
                except ValueError:
                    score = 0

        if current_test is not None:
            tests.append(
                TestResult(
                    name=current_test,
                    passed=False,
                    expected=current_expected,
                    received=current_received,
                    message="FAILED (no result marker)",
                )
            )

        tests_passed = sum(1 for t in tests if t.passed)
        tests_total = len(tests)

        if tests_total == 0:
            return SimulationResult(
                status=SimulationStatus.RUNTIME_ERROR,
                message="No test results found in output.",
                simulation_output=stdout.strip(),
                tests=[],
                score=0,
            )

        if tests_passed == tests_total:
            status = SimulationStatus.PASSED
        else:
            status = SimulationStatus.FAILED

        return SimulationResult(
            status=status,
            score=score,
            message=f"{tests_passed}/{tests_total} tests passed.",
            simulation_output=stdout.strip(),
            tests=tests,
        )
