from __future__ import annotations

from app.services.ai.context_builder import AIContext
from app.services.ai.providers.base import AIMessage

SYSTEM_PROMPT = """You are an expert digital design and SystemVerilog tutor for HDLForge, a learning platform for hardware description languages.

Core principles:
- Be technically accurate about SystemVerilog, Verilog, and digital design.
- Explain concepts clearly rather than blindly solving problems.
- Use evidence from compiler output, test results, and waveform data when available.
- Do not invent simulator results, test outcomes, or waveform transitions.
- Clearly label uncertainty with confidence levels (HIGH, MEDIUM, LOW).
- Never reveal hidden test information, internal paths, or infrastructure details.
- Never claim to have executed code — you are analyzing submitted code.
- Never override authoritative judge results.
- Prefer concise educational explanations over verbose ones.
- Use correct SystemVerilog terminology.
- When debugging, provide diagnosis, evidence, and debugging steps rather than the answer.
- Progressively hint rather than immediately revealing the solution."""


def _build_system_message() -> AIMessage:
    return AIMessage(role="system", content=SYSTEM_PROMPT)


def build_explain_code_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]
    prompt = f"""Analyze the following SystemVerilog code for the problem "{ctx.problem_title}".

Problem description:
{ctx.problem_description}

Profile's RTL code:
```systemverilog
{ctx.user_rtl}
```

Explain:
1. Module structure (inputs, outputs, internal signals)
2. Logic behavior and what the code does
3. Important constructs used
4. Potential issues or style suggestions
5. Whether the code appears correct for the problem requirements

Distinguish between:
- Correct behavior
- Potential issue
- Style suggestion
- Actual bug

Do not claim code is incorrect unless there is clear evidence of a mismatch with requirements."""
    messages.append(AIMessage(role="user", content=prompt))
    return messages


def build_explain_error_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]
    prompt = f"""Explain the following compilation error for the problem "{ctx.problem_title}".

Compiler output:
```
{ctx.compiler_error}
```

Profile's RTL code:
```systemverilog
{ctx.user_rtl}
```

Provide:
1. What the error means
2. Which line caused it
3. Why it happened
4. The relevant HDL concept involved
5. How to fix it"""
    messages.append(AIMessage(role="user", content=prompt))
    return messages


def build_debug_submission_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]

    test_summary_lines = []
    for t in ctx.public_test_results:
        status = "PASSED" if t.get("passed") else "FAILED"
        test_summary_lines.append(f"- {t.get('name', 'unnamed')}: {status}")
        if t.get("message"):
            test_summary_lines.append(f"  Message: {t['message'][:200]}")
    test_summary = "\n".join(test_summary_lines) if test_summary_lines else "No public test details available."

    hidden_info = ""
    if ctx.hidden_tests_total > 0:
        hidden_info = f"\nHidden tests: {ctx.hidden_tests_passed}/{ctx.hidden_tests_total} passed"

    waveform_info = ""
    if ctx.waveform_summary:
        signals = ctx.waveform_summary.get("signals", [])
        if signals:
            waveform_info = "\nWaveform signals observed: " + ", ".join(signals[:10])

    prompt = f"""Debug the following failed submission for "{ctx.problem_title}".

Submission status: {ctx.submission_status}

Profile's RTL code:
```systemverilog
{ctx.user_rtl}
```

Public test results:
{test_summary}
{hidden_info}
{waveform_info}

Provide your response in this structure:

### Diagnosis
Likely cause of failure.

### Evidence
What observed behavior supports the diagnosis.

### Debugging Steps
A small sequence of things the learner should inspect.

### Hint
A concise hint that guides without giving the full answer.

### Concept
The HDL concept involved.

Confidence level: HIGH / MEDIUM / LOW"""

    messages.append(AIMessage(role="user", content=prompt))
    return messages


def build_hint_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]
    level_descriptions = {
        1: "Provide only a high-level conceptual direction. Do not mention specific RTL constructs.",
        2: "Point toward the likely RTL construct or approach without showing code.",
        3: "Explain the relevant logic and suggest what to look for in the code.",
        4: "Provide a more concrete debugging direction with specific suggestions.",
    }
    level_desc = level_descriptions.get(ctx.hint_level, level_descriptions[4])

    prompt = f"""Give a progressive hint (level {ctx.hint_level}) for the problem "{ctx.problem_title}".

Problem description:
{ctx.problem_description}

Profile's current RTL:
```systemverilog
{ctx.user_rtl}
```

{level_desc}

Keep the hint concise and educational. Do not provide the full solution unless hint level is 4 and even then, only provide a debugging direction, not working code."""

    messages.append(AIMessage(role="user", content=prompt))
    return messages


def build_explain_waveform_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]
    waveform_desc = ""
    if ctx.waveform_summary:
        signals = ctx.waveform_summary.get("signals", [])
        transitions = ctx.waveform_summary.get("key_transitions", [])
        waveform_desc = f"Signals: {', '.join(signals[:15])}\n"
        if transitions:
            waveform_desc += "Key transitions:\n"
            for tr in transitions[:20]:
                waveform_desc += f"  t={tr.get('time')}: {tr.get('signal')} = {tr.get('value')}\n"

    prompt = f"""Explain the waveform behavior for the problem "{ctx.problem_title}".

{waveform_desc}

Profile's RTL:
```systemverilog
{ctx.user_rtl}
```

{f"Expected behavior from problem: {ctx.problem_description[:500]}" if ctx.problem_description else ""}

Explain:
1. What the signals are doing
2. Whether the behavior matches expectations
3. What might be going wrong if the submission failed

Clearly distinguish observed facts from likely diagnoses."""

    messages.append(AIMessage(role="user", content=prompt))
    return messages


def build_ask_question_prompt(ctx: AIContext) -> list[AIMessage]:
    messages = [_build_system_message()]
    context_parts = []
    if ctx.problem_title:
        context_parts.append(f"Current problem: {ctx.problem_title}")
    if ctx.learning_context:
        lesson = ctx.learning_context.get("lesson_title", "")
        if lesson:
            context_parts.append(f"Current lesson: {lesson}")
        concepts = ctx.learning_context.get("concepts", [])
        if concepts:
            context_parts.append(f"Related concepts: {', '.join(concepts)}")

    context_str = "\n".join(context_parts) if context_parts else "General HDL question."

    prompt = f"""{context_str}

Profile question: {ctx.user_question}

Answer the question clearly and concisely. Use SystemVerilog examples where helpful. If the question relates to the current problem or lesson, provide context-aware answers."""

    messages.append(AIMessage(role="user", content=prompt))
    return messages


PROMPT_BUILDERS = {
    "explain_code": build_explain_code_prompt,
    "explain_error": build_explain_error_prompt,
    "debug_submission": build_debug_submission_prompt,
    "hint": build_hint_prompt,
    "explain_waveform": build_explain_waveform_prompt,
    "ask": build_ask_question_prompt,
}
