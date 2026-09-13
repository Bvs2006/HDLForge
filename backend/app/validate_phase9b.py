"""
Phase 9B — Validation Script for HDLForge.

Runs reference and broken implementations against all testbenches.
Requires Verilator to be installed and available in PATH.

Usage:
    python -m app.validate_phase9b
"""

import logging
import os
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

from app.db.database import SessionLocal
from app.db.models import Problem, TestCase, TestVisibility
from app.seed_phase9b import REFERENCE_IMPLEMENTATIONS, BROKEN_IMPLEMENTATIONS

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)


@dataclass
class ValidationResult:
    problem_slug: str
    testbench_name: str
    visibility: str
    implementation_type: str  # "reference" or "broken"
    compile_ok: bool
    tests_passed: int
    tests_total: int
    score: float
    output: str = ""


@dataclass
class ValidationReport:
    results: list[ValidationResult] = field(default_factory=list)
    total_testbenches: int = 0
    reference_passes: int = 0
    reference_fails: int = 0
    broken_passes: int = 0
    broken_fails: int = 0


def check_docker() -> bool:
    """Check if Docker is available."""
    try:
        proc = subprocess.run(
            ["docker", "info"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        if proc.returncode == 0:
            logger.info("Docker is available.")
            return True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    logger.error("Docker not found. Please start Docker Desktop.")
    return False


DOCKER_IMAGE = "hdlforge-sandbox:latest"


def run_testbench(
    submission_code: str,
    testbench_code: str,
    workspace: Path,
    timeout: int = 15,
) -> tuple[bool, str, float]:
    """
    Run a testbench against a submission using Docker sandbox.
    Returns (compile_ok, output, score).
    Uses docker create/cp/start to avoid Windows mount issues.
    """
    import uuid
    container_name = f"hdlforge-validate-{uuid.uuid4().hex[:8]}"

    try:
        # Create container with a writable workspace
        create_cmd = [
            "docker", "create",
            "--name", container_name,
            "--network", "none",
            "--read-only",
            "--tmpfs", "/tmp:rw,noexec,nosuid,size=64m",
            "--cpus", "1",
            "--memory", "256m",
            "--pids-limit", "64",
            "--security-opt", "no-new-privileges",
            "--cap-drop", "ALL",
            "-w", "/workspace",
            DOCKER_IMAGE,
            "bash", "-c",
            (
                "verilator --cc --exe --build --top-module testbench "
                "-Wall -Wno-DECLFILENAME -o Vtestbench "
                "-Mdir /workspace/obj_dir "
                "/workspace/testbench.sv /workspace/submission.sv "
                "&& /workspace/obj_dir/Vtestbench"
            ),
        ]
        subprocess.run(create_cmd, capture_output=True, text=True, timeout=10)

        # Copy files into container
        submission_path = workspace / "submission.sv"
        testbench_path = workspace / "testbench.sv"
        submission_path.write_text(submission_code)
        testbench_path.write_text(testbench_code)

        subprocess.run(
            ["docker", "cp", str(submission_path), f"{container_name}:/workspace/submission.sv"],
            capture_output=True, text=True, timeout=10,
        )
        subprocess.run(
            ["docker", "cp", str(testbench_path), f"{container_name}:/workspace/testbench.sv"],
            capture_output=True, text=True, timeout=10,
        )

        # Start and wait for completion
        subprocess.run(["docker", "start", container_name], capture_output=True, text=True, timeout=10)

        # Wait for container to finish (with timeout)
        wait_result = subprocess.run(
            ["docker", "wait", container_name],
            capture_output=True, text=True, timeout=timeout,
        )

        # Get logs
        logs_result = subprocess.run(
            ["docker", "logs", container_name],
            capture_output=True, text=True, timeout=10,
        )

        exit_code = int(wait_result.stdout.strip()) if wait_result.stdout.strip() else -1
        output = logs_result.stdout
        stderr = logs_result.stderr

        # Check for compilation errors
        if exit_code != 0 and not output.strip():
            if "syntax error" in stderr.lower() or "error" in stderr.lower():
                return False, output + "\n" + stderr, 0.0
            return False, output + "\n" + stderr, 0.0

        # Parse score
        score = 0.0
        for line in output.split("\n"):
            if line.startswith("HDLFORGE_SCORE:"):
                try:
                    score = float(line.split(":")[1].strip())
                except ValueError:
                    pass
                break

        return True, output, score

    except subprocess.TimeoutExpired:
        return False, "Execution timed out.", 0.0
    except Exception as e:
        return False, f"Docker error: {e}", 0.0
    finally:
        # Cleanup container
        subprocess.run(
            ["docker", "rm", "-f", container_name],
            capture_output=True, text=True, timeout=5,
        )


def validate_problem(
    problem: Problem,
    test_cases: list[TestCase],
    reference_code: str,
    report: ValidationReport,
) -> None:
    """Validate all testbenches for a problem against reference and broken implementations."""
    logger.info("\n=== %s ===", problem.title)

    with tempfile.TemporaryDirectory() as tmpdir:
        workspace = Path(tmpdir)

        for tc in test_cases:
            logger.info("  Testing: %s (%s)", tc.name, tc.visibility.value)

            # Test reference implementation
            compile_ok, output, score = run_testbench(
                reference_code, tc.testbench, workspace
            )

            result = ValidationResult(
                problem_slug=problem.slug,
                testbench_name=tc.name,
                visibility=tc.visibility.value,
                implementation_type="reference",
                compile_ok=compile_ok,
                tests_passed=int(score / 100 * 10) if compile_ok else 0,
                tests_total=10 if "vectors 1-10" in tc.name else 3,
                score=score,
                output=output[:500] if not compile_ok else "",
            )
            report.results.append(result)
            report.total_testbenches += 1

            if compile_ok and score >= 100:
                report.reference_passes += 1
                logger.info("    PASS (reference: %.0f%%)", score)
            else:
                report.reference_fails += 1
                logger.info("    FAIL (reference: %.0f%%, compile=%s)", score, compile_ok)

            # Test broken implementations
            for broken_name, broken_code in BROKEN_IMPLEMENTATIONS.items():
                if broken_name.split("_")[0] not in problem.slug.replace("-", "_"):
                    continue

                compile_ok_b, output_b, score_b = run_testbench(
                    broken_code, tc.testbench, workspace
                )

                result_b = ValidationResult(
                    problem_slug=problem.slug,
                    testbench_name=tc.name,
                    visibility=tc.visibility.value,
                    implementation_type=f"broken_{broken_name}",
                    compile_ok=compile_ok_b,
                    tests_passed=int(score_b / 100 * 10) if compile_ok_b else 0,
                    tests_total=10 if "vectors 1-10" in tc.name else 3,
                    score=score_b,
                    output=output_b[:500] if not compile_ok_b else "",
                )
                report.results.append(result_b)

                if compile_ok_b and score_b < 100:
                    report.broken_fails += 1
                elif compile_ok_b and score_b >= 100:
                    report.broken_passes += 1
                    logger.warning(
                        "    WARNING: broken impl '%s' passed with %.0f%%",
                        broken_name,
                        score_b,
                    )


def print_report(report: ValidationReport) -> None:
    """Print the validation report."""
    print("\n" + "=" * 70)
    print("PHASE 9B VALIDATION REPORT")
    print("=" * 70)
    print(f"Total testbenches tested: {report.total_testbenches}")
    print(f"Reference passes:         {report.reference_passes}")
    print(f"Reference fails:          {report.reference_fails}")
    print(f"Broken impl passes:       {report.broken_passes} (should be 0)")
    print(f"Broken impl fails:        {report.broken_fails} (should match broken impls)")
    print("=" * 70)

    if report.reference_fails > 0:
        print("\nFAILED REFERENCE TESTS:")
        for r in report.results:
            if r.implementation_type == "reference" and r.score < 100:
                print(f"  {r.problem_slug}: {r.testbench_name} ({r.score:.0f}%)")
                if r.output:
                    print(f"    Output: {r.output[:200]}")

    if report.broken_passes > 0:
        print("\nBROKEN IMPLICATIONS THAT PASSED (SHOULD NOT HAPPEN):")
        for r in report.results:
            if r.implementation_type.startswith("broken_") and r.score >= 100:
                print(f"  {r.problem_slug}: {r.testbench_name} - {r.implementation_type}")

    print("\n" + "=" * 70)


def main() -> int:
    """Run Phase 9B validation."""
    if not check_docker():
        return 1

    db = SessionLocal()
    try:
        problems = db.query(Problem).all()
        report = ValidationReport()

        for problem in problems:
            test_cases = problem.test_cases_list
            reference_code = REFERENCE_IMPLEMENTATIONS.get(
                problem.slug.replace("-", "_"), ""
            )
            if not reference_code:
                logger.warning("No reference implementation for %s", problem.slug)
                continue

            validate_problem(problem, test_cases, reference_code, report)

        print_report(report)

        # Return exit code
        if report.reference_fails > 0 or report.broken_passes > 0:
            return 1
        return 0

    finally:
        db.close()


if __name__ == "__main__":
    sys.exit(main())
