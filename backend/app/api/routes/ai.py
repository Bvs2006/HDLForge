from __future__ import annotations

import json
from typing import Any

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.api.routes.auth import require_user, get_current_user
from app.core.config import settings
from app.db.database import get_db
from app.db.models import (
    AIFeedback,
    AIMessage,
    AIConversation,
    Problem,
    Submission,
    Profile,
    Waveform,
)
from app.services.ai.ai_service import handle_ai_request, save_conversation

router = APIRouter(prefix="/ai", tags=["ai"])


class AIRequest(BaseModel):
    task: str
    problem_slug: str | None = None
    submission_id: int | None = None
    code: str | None = None
    compiler_error: str | None = None
    waveform_id: str | None = None
    lesson_slug: str | None = None
    user_question: str | None = None
    hint_level: int = 1
    concept_tags: list[str] = Field(default_factory=list)


class AIFeedbackRequest(BaseModel):
    message_id: int | None = None
    rating: str
    comment: str = ""
    task_type: str = ""


def _build_context_from_submission(
    db: Session,
    submission: Submission,
    problem: Problem,
    request: AIRequest,
) -> dict:
    public_tests = []
    hidden_passed = 0
    hidden_total = 0

    for tr in submission.test_results:
        tc = None
        if hasattr(tr, "test_case_id") and tr.test_case_id:
            from app.db.models import TestCase
            tc = db.query(TestCase).filter(TestCase.id == tr.test_case_id).first()

        is_hidden = tc.visibility.value == "HIDDEN" if tc else True

        if is_hidden:
            hidden_total += 1
            if tr.status == "PASSED":
                hidden_passed += 1
        else:
            public_tests.append({
                "name": tr.test_name,
                "passed": tr.status == "PASSED",
                "message": tr.message[:500] if tr.message else "",
            })

    waveform_data = {}
    if request.waveform_id:
        wf = db.query(Waveform).filter(Waveform.waveform_id == request.waveform_id).first()
        if wf:
            waveform_data = {
                "duration": wf.duration,
                "timescale": wf.timescale,
                "signal_count": wf.signal_count,
                "signals": [],
            }
    elif submission.waveform:
        waveform_data = {
            "duration": submission.waveform.duration,
            "timescale": submission.waveform.timescale,
            "signal_count": submission.waveform.signal_count,
            "signals": [],
        }

    return {
        "problem_title": problem.title,
        "problem_description": problem.description,
        "problem_constraints": problem.constraints,
        "user_rtl": submission.code,
        "compiler_error": request.compiler_error or submission.compilation_message,
        "public_test_results": public_tests,
        "hidden_tests_total": hidden_total,
        "submission_status": submission.status.value,
        "waveform_data": waveform_data,
        "language": submission.language.value.lower(),
        "concept_tags": request.concept_tags,
    }


def _build_context_from_problem(
    problem: Problem,
    request: AIRequest,
) -> dict:
    return {
        "problem_title": problem.title,
        "problem_description": problem.description,
        "problem_constraints": problem.constraints,
        "user_rtl": request.code or "",
        "compiler_error": request.compiler_error or "",
        "language": problem.language.value.lower(),
        "concept_tags": request.concept_tags,
    }


def _build_lesson_context(
    db: Session,
    lesson_slug: str,
) -> dict:
    from app.db.models import Lesson, LearningModule
    lesson = db.query(Lesson).filter(Lesson.slug == lesson_slug).first()
    if not lesson:
        return {}
    module = db.query(LearningModule).filter(LearningModule.id == lesson.module_id).first()
    return {
        "lesson_title": lesson.title,
        "lesson_description": lesson.description,
        "module_title": module.title if module else "",
        "concepts": [],
    }


@router.post("/chat")
async def ai_chat(
    request: AIRequest,
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    if not settings.AI_ENABLED:
        raise HTTPException(status_code=503, detail="AI assistant is currently disabled.")

    context: dict[str, Any] = {}

    if request.problem_slug:
        problem = db.query(Problem).filter(Problem.slug == request.problem_slug).first()
        if not problem:
            raise HTTPException(status_code=404, detail="Problem not found")

        if request.submission_id:
            submission = (
                db.query(Submission)
                .filter(
                    Submission.id == request.submission_id,
                    Submission.problem_id == problem.id,
                )
                .first()
            )
            if not submission:
                raise HTTPException(status_code=404, detail="Submission not found")
            context = _build_context_from_submission(db, submission, problem, request)
        else:
            context = _build_context_from_problem(problem, request)

    if request.lesson_slug:
        context["learning_context"] = _build_lesson_context(db, request.lesson_slug)

    if request.user_question:
        context["user_question"] = request.user_question
    if request.hint_level:
        context["hint_level"] = request.hint_level
    if request.code:
        context["user_rtl"] = request.code
    if request.compiler_error:
        context["compiler_error"] = request.compiler_error

    result = await handle_ai_request(db, user.id, request.task, context)

    if "error" in result:
        status_code = 429 if result.get("rate_limited") else 503
        raise HTTPException(status_code=status_code, detail=result["error"])

    problem_id = None
    if request.problem_slug:
        problem = db.query(Problem).filter(Problem.slug == request.problem_slug).first()
        if problem:
            problem_id = problem.id

    lesson_id = None
    if request.lesson_slug:
        from app.db.models import Lesson
        lesson = db.query(Lesson).filter(Lesson.slug == request.lesson_slug).first()
        if lesson:
            lesson_id = lesson.id

    conversation_id = save_conversation(
        db, user.id, request.task, context, result.get("response", ""), problem_id, lesson_id
    )

    return {
        "response": result.get("response", ""),
        "model": result.get("model", ""),
        "tokens_used": result.get("tokens_used", 0),
        "conversation_id": conversation_id,
    }


@router.post("/feedback")
async def ai_feedback(
    request: AIFeedbackRequest,
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    if request.rating not in ("helpful", "not_helpful"):
        raise HTTPException(status_code=400, detail="Rating must be 'helpful' or 'not_helpful'.")

    feedback = AIFeedback(
        user_id=user.id,
        message_id=request.message_id,
        rating=request.rating,
        comment=request.comment[:500],
        task_type=request.task_type,
    )
    db.add(feedback)
    db.commit()

    return {"status": "ok"}


@router.get("/conversations")
async def list_conversations(
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    convs = (
        db.query(AIConversation)
        .filter(AIConversation.user_id == user.id)
        .order_by(AIConversation.created_at.desc())
        .limit(20)
        .all()
    )
    return {
        "conversations": [
            {
                "id": c.id,
                "task_type": c.task_type,
                "problem_id": c.problem_id,
                "lesson_id": c.lesson_id,
                "created_at": c.created_at.isoformat() if c.created_at else "",
            }
            for c in convs
        ]
    }


@router.get("/conversations/{conversation_id}")
async def get_conversation(
    conversation_id: int,
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    conv = (
        db.query(AIConversation)
        .filter(
            AIConversation.id == conversation_id,
            AIConversation.user_id == user.id,
        )
        .first()
    )
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")

    messages = (
        db.query(AIMessage)
        .filter(AIMessage.conversation_id == conv.id)
        .order_by(AIMessage.created_at)
        .all()
    )

    return {
        "id": conv.id,
        "task_type": conv.task_type,
        "messages": [
            {
                "id": m.id,
                "role": m.role,
                "content": m.content,
                "created_at": m.created_at.isoformat() if m.created_at else "",
            }
            for m in messages
        ],
    }
