"""
Phase 9B — Quick Syntax Validation for Testbenches.

Validates testbench structure and output format without Verilator.
Checks for required HDLFORGE markers and valid SystemVerilog syntax.
"""

import re
import sys
from app.db.database import SessionLocal
from app.db.models import Problem, TestCase, TestVisibility


REQUIRED_MARKERS = [
    "module testbench",
    "endmodule",
    "HDLFORGE_TEST_NAME:",
    "HDLFORGE_TEST_PASS",
    "HDLFORGE_SCORE:",
]

FORBIDDEN_MARKERS_IN_FAIL = [
    "HDLFORGE_TEST_FAIL",
]


def validate_testbench(tc: TestCase) -> list[str]:
    """Validate a single testbench. Returns list of errors."""
    errors = []
    tb = tc.testbench

    # Check required markers
    for marker in REQUIRED_MARKERS:
        if marker not in tb:
            errors.append(f"Missing required marker: {marker}")

    # Check module/endmodule pairing
    module_count = len(re.findall(r"\bmodule\b", tb))
    endmodule_count = len(re.findall(r"\bendmodule\b", tb))
    if module_count != endmodule_count:
        errors.append(f"Module/endmodule mismatch: {module_count} vs {endmodule_count}")

    # Check for proper HDLFORGE markers format
    test_name_lines = re.findall(r'HDLFORGE_TEST_NAME:', tb)
    if not test_name_lines:
        errors.append("No HDLFORGE_TEST_NAME markers found")

    score_lines = re.findall(r'HDLFORGE_SCORE:', tb)
    if not score_lines:
        errors.append("No HDLFORGE_SCORE marker found")
    elif len(score_lines) > 1:
        errors.append(f"Multiple HDLFORGE_SCORE markers: {len(score_lines)}")

    # Check for basic SystemVerilog syntax
    if "logic" not in tb and "wire" not in tb and "reg" not in tb:
        errors.append("No signal declarations found (logic/wire/reg)")

    # Check for test vector assignments
    assign_lines = re.findall(r"\w+\s*=\s*\d+'[bd]\d+|\w+\s*=\s*\d+", tb)
    if len(assign_lines) < 3:
        errors.append(f"Too few test vector assignments: {len(assign_lines)}")

    return errors


def main() -> int:
    """Run syntax validation on all testbenches."""
    db = SessionLocal()
    try:
        problems = db.query(Problem).all()
        total = 0
        passed = 0
        failed = 0
        errors_by_problem = {}

        for problem in problems:
            test_cases = problem.test_cases_list
            problem_errors = []

            for tc in test_cases:
                total += 1
                errors = validate_testbench(tc)

                if errors:
                    failed += 1
                    problem_errors.append((tc.name, tc.visibility.value, errors))
                else:
                    passed += 1

            if problem_errors:
                errors_by_problem[problem.slug] = problem_errors

        # Print report
        print("=" * 70)
        print("PHASE 9B SYNTAX VALIDATION REPORT")
        print("=" * 70)
        print(f"Total testbenches: {total}")
        print(f"Passed:            {passed}")
        print(f"Failed:            {failed}")
        print("=" * 70)

        if errors_by_problem:
            print("\nTESTBENCHES WITH ERRORS:")
            for slug, errors in errors_by_problem.items():
                print(f"\n  {slug}:")
                for name, vis, errs in errors:
                    print(f"    {name} ({vis}):")
                    for err in errs:
                        print(f"      - {err}")
        else:
            print("\nAll testbenches passed syntax validation!")

        # Check weight distribution
        print("\nWEIGHT DISTRIBUTION:")
        for problem in problems:
            test_cases = problem.test_cases_list
            total_weight = sum(tc.weight for tc in test_cases)
            public_count = sum(1 for tc in test_cases if tc.visibility == TestVisibility.PUBLIC)
            hidden_count = sum(1 for tc in test_cases if tc.visibility == TestVisibility.HIDDEN)
            print(
                f"  {problem.slug}: {len(test_cases)} tests "
                f"({public_count} public + {hidden_count} hidden), "
                f"total weight: {total_weight:.2f}"
            )

        print("=" * 70)
        return 0 if failed == 0 else 1

    finally:
        db.close()


if __name__ == "__main__":
    sys.exit(main())
