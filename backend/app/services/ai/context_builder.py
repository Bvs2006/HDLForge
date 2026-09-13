from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any


def _truncate(text: str, max_len: int) -> str:
    if len(text) <= max_len:
        return text
    return text[: max_len - 20] + "\n... [truncated]"


def _sanitize_compiler_output(output: str) -> str:
    output = re.sub(r"docker[^\n]*", "[sandbox]", output, flags=re.IGNORECASE)
    output = re.sub(r"/[a-zA-Z]:[/\\][^\s:\n]+", "[path]", output)
    output = re.sub(r"/(?:home|var|opt|usr|tmp|etc|root|lib)/[^\s:\n]*", "[path]", output)
    output = re.sub(r"secret[^\n]*", "[redacted]", output, flags=re.IGNORECASE)
    return output


def _extract_safe_test_summary(
    public_tests: list[dict],
    hidden_passed: int,
    hidden_total: int,
) -> dict:
    safe_public = []
    for t in public_tests:
        safe_public.append({
            "name": t.get("name", "unnamed"),
            "passed": t.get("passed", False),
            "message": _truncate(t.get("message", ""), 200),
        })
    return {
        "public_tests": safe_public,
        "hidden_summary": f"{hidden_passed}/{hidden_total} hidden tests passed",
    }


@dataclass
class AIContext:
    task: str
    language: str = "systemverilog"
    problem_title: str = ""
    problem_description: str = ""
    problem_constraints: str = ""
    user_rtl: str = ""
    compiler_error: str = ""
    public_test_results: list[dict] = field(default_factory=list)
    hidden_tests_passed: int = 0
    hidden_tests_total: int = 0
    submission_status: str = ""
    waveform_summary: dict = field(default_factory=dict)
    learning_context: dict = field(default_factory=dict)
    user_question: str = ""
    concept_tags: list[str] = field(default_factory=list)
    hint_level: int = 1

    def to_dict(self) -> dict:
        d: dict[str, Any] = {"task": self.task, "language": self.language}
        if self.problem_title:
            d["problem"] = {
                "title": self.problem_title,
                "description": _truncate(self.problem_description, 2000),
                "constraints": _truncate(self.problem_constraints, 500),
                "concept_tags": self.concept_tags,
            }
        if self.user_rtl:
            d["user_rtl"] = _truncate(self.user_rtl, settings_max_source())
        if self.compiler_error:
            d["compiler_error"] = _sanitize_compiler_output(
                _truncate(self.compiler_error, 2000)
            )
        if self.public_test_results or self.hidden_tests_total > 0:
            d["test_results"] = _extract_safe_test_summary(
                self.public_test_results, self.hidden_tests_passed, self.hidden_tests_total
            )
        if self.submission_status:
            d["submission_status"] = self.submission_status
        if self.waveform_summary:
            d["waveform_summary"] = self.waveform_summary
        if self.learning_context:
            d["learning_context"] = self.learning_context
        if self.user_question:
            d["user_question"] = self.user_question
        if self.hint_level > 1:
            d["hint_level"] = self.hint_level
        return d


def settings_max_source() -> int:
    try:
        from app.core.config import settings
        return settings.HDL_MAX_SOURCE_SIZE
    except Exception:
        return 50000
