"""Learning routes - curriculum, lessons, quizzes, progress, recommendations."""

import json
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import (
    Concept,
    Lesson,
    LessonPrerequisite,
    LearningModule,
    LearningPath,
    Quiz,
    QuizQuestion,
    User,
)
from app.api.routes.auth import get_current_user, require_user
from app.services.learning_service import (
    are_prerequisites_met,
    complete_lesson,
    get_concept_mastery,
    get_learning_progress,
    get_lesson_status,
    get_recommendations,
    get_related_problems,
    start_lesson,
    submit_quiz,
    update_concept_mastery_on_solve,
)

router = APIRouter(prefix="/learning", tags=["learning"])


class LessonProgressRequest(BaseModel):
    pass


class QuizSubmitRequest(BaseModel):
    answers: list[str]


class LessonResponse(BaseModel):
    id: int
    slug: str
    title: str
    description: str
    content: str
    difficulty: str
    estimated_minutes: int
    order_index: int
    status: str
    prerequisites_met: bool
    has_quiz: bool
    related_problems: list[dict]


class ModuleResponse(BaseModel):
    id: int
    slug: str
    title: str
    description: str
    order_index: int
    lessons: list[dict]
    completed_lessons: int
    total_lessons: int


class PathResponse(BaseModel):
    id: int
    slug: str
    title: str
    description: str
    difficulty: str
    estimated_hours: int
    modules: list[ModuleResponse]
    completed_lessons: int
    total_lessons: int
    progress_percent: float


class QuizQuestionPublic(BaseModel):
    id: int
    question: str
    question_type: str
    options: str
    order_index: int


class QuizResponse(BaseModel):
    id: int
    title: str
    questions: list[QuizQuestionPublic]


class QuizResultResponse(BaseModel):
    score: float
    passed: bool
    results: list[dict]
    xp_earned: int


class LearningProgressResponse(BaseModel):
    paths: list[dict]
    total_lessons: int
    completed_lessons: int
    progress_percent: float


class ConceptMasteryResponse(BaseModel):
    concepts: list[dict]


class RecommendationsResponse(BaseModel):
    next_lesson: dict | None
    practice_problem: dict | None
    weak_concept: dict | None
    reason: str


@router.get("/paths")
def list_paths(db: Session = Depends(get_db)):
    paths = db.query(LearningPath).filter(LearningPath.published == True).order_by(LearningPath.id).all()
    result = []
    for path in paths:
        module_count = db.query(LearningModule).filter(LearningModule.learning_path_id == path.id).count()
        result.append({
            "id": path.id,
            "slug": path.slug,
            "title": path.title,
            "description": path.description,
            "difficulty": path.difficulty.value.lower(),
            "estimated_hours": path.estimated_hours,
            "module_count": module_count,
        })
    return {"paths": result}


@router.get("/paths/{slug}")
def get_path(slug: str, db: Session = Depends(get_db)):
    path = db.query(LearningPath).filter(LearningPath.slug == slug, LearningPath.published == True).first()
    if not path:
        raise HTTPException(status_code=404, detail="Learning path not found")

    modules = (
        db.query(LearningModule)
        .filter(LearningModule.learning_path_id == path.id)
        .order_by(LearningModule.order_index)
        .all()
    )

    module_data = []
    for module in modules:
        lessons = (
            db.query(Lesson)
            .filter(Lesson.module_id == module.id, Lesson.published == True)
            .order_by(Lesson.order_index)
            .all()
        )
        lesson_data = []
        for lesson in lessons:
            has_quiz = db.query(Quiz).filter(Quiz.lesson_id == lesson.id).first() is not None
            lesson_data.append({
                "id": lesson.id,
                "slug": lesson.slug,
                "title": lesson.title,
                "description": lesson.description,
                "difficulty": lesson.difficulty.value.lower(),
                "estimated_minutes": lesson.estimated_minutes,
                "order_index": lesson.order_index,
                "has_quiz": has_quiz,
            })
        module_data.append({
            "id": module.id,
            "slug": module.slug,
            "title": module.title,
            "description": module.description,
            "order_index": module.order_index,
            "lessons": lesson_data,
        })

    return {
        "id": path.id,
        "slug": path.slug,
        "title": path.title,
        "description": path.description,
        "difficulty": path.difficulty.value.lower(),
        "estimated_hours": path.estimated_hours,
        "modules": module_data,
    }


@router.get("/lessons/{slug}")
def get_lesson(slug: str, user: User | None = Depends(get_current_user), db: Session = Depends(get_db)):
    lesson = db.query(Lesson).filter(Lesson.slug == slug, Lesson.published == True).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    module = db.query(LearningModule).filter(LearningModule.id == lesson.module_id).first()
    path = db.query(LearningPath).filter(LearningPath.id == module.learning_path_id).first() if module else None

    status = get_lesson_status(db, lesson, user.id if user else None)
    prereqs_met = are_prerequisites_met(db, lesson, user.id) if user else True

    has_quiz = db.query(Quiz).filter(Quiz.lesson_id == lesson.id).first() is not None

    related = get_related_problems(db, slug)

    prereq_lessons = []
    prereq_links = (
        db.query(LessonPrerequisite)
        .filter(LessonPrerequisite.lesson_id == lesson.id)
        .all()
    )
    for pl in prereq_links:
        prereq = db.query(Lesson).filter(Lesson.id == pl.prerequisite_lesson_id).first()
        if prereq:
            prereq_lessons.append({
                "slug": prereq.slug,
                "title": prereq.title,
            })

    prev_lesson = None
    next_lesson = None

    if module:
        all_lessons = (
            db.query(Lesson)
            .filter(Lesson.module_id == module.id, Lesson.published == True)
            .order_by(Lesson.order_index)
            .all()
        )
        for i, l in enumerate(all_lessons):
            if l.id == lesson.id:
                if i > 0:
                    prev_lesson = {"slug": all_lessons[i-1].slug, "title": all_lessons[i-1].title}
                if i < len(all_lessons) - 1:
                    next_lesson = {"slug": all_lessons[i+1].slug, "title": all_lessons[i+1].title}
                break

    if not next_lesson and module:
        all_modules = (
            db.query(LearningModule)
            .filter(LearningModule.learning_path_id == module.learning_path_id)
            .order_by(LearningModule.order_index)
            .all()
        )
        for i, m in enumerate(all_modules):
            if m.id == module.id and i < len(all_modules) - 1:
                next_mod = all_modules[i + 1]
                first_lesson = (
                    db.query(Lesson)
                    .filter(Lesson.module_id == next_mod.id, Lesson.published == True)
                    .order_by(Lesson.order_index)
                    .first()
                )
                if first_lesson:
                    next_lesson = {"slug": first_lesson.slug, "title": first_lesson.title}
                break

    return {
        "id": lesson.id,
        "slug": lesson.slug,
        "title": lesson.title,
        "description": lesson.description,
        "content": lesson.content,
        "difficulty": lesson.difficulty.value.lower(),
        "estimated_minutes": lesson.estimated_minutes,
        "order_index": lesson.order_index,
        "status": status,
        "prerequisites_met": prereqs_met,
        "prerequisites": prereq_lessons,
        "has_quiz": has_quiz,
        "related_problems": related,
        "prev_lesson": prev_lesson,
        "next_lesson": next_lesson,
        "module": {
            "slug": module.slug,
            "title": module.title,
        } if module else None,
        "path": {
            "slug": path.slug,
            "title": path.title,
        } if path else None,
    }


@router.post("/lessons/{slug}/start")
def start_lesson_endpoint(slug: str, user: User = Depends(require_user), db: Session = Depends(get_db)):
    lesson = db.query(Lesson).filter(Lesson.slug == slug, Lesson.published == True).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    if not are_prerequisites_met(db, lesson, user.id):
        raise HTTPException(status_code=403, detail="Prerequisites not met")

    progress = start_lesson(db, user.id, lesson.id)
    return {"status": progress.status.value}


@router.post("/lessons/{slug}/complete")
def complete_lesson_endpoint(slug: str, user: User = Depends(require_user), db: Session = Depends(get_db)):
    lesson = db.query(Lesson).filter(Lesson.slug == slug, Lesson.published == True).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    if not are_prerequisites_met(db, lesson, user.id):
        raise HTTPException(status_code=403, detail="Prerequisites not met")

    xp_earned, _ = complete_lesson(db, user.id, lesson.id)
    return {"xp_earned": xp_earned}


@router.get("/quizzes/{lesson_slug}")
def get_quiz(lesson_slug: str, db: Session = Depends(get_db)):
    lesson = db.query(Lesson).filter(Lesson.slug == lesson_slug).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    quiz = db.query(Quiz).filter(Quiz.lesson_id == lesson.id).first()
    if not quiz:
        raise HTTPException(status_code=404, detail="No quiz for this lesson")

    questions = (
        db.query(QuizQuestion)
        .filter(QuizQuestion.quiz_id == quiz.id)
        .order_by(QuizQuestion.order_index)
        .all()
    )

    return {
        "id": quiz.id,
        "title": quiz.title,
        "questions": [
            {
                "id": q.id,
                "question": q.question,
                "question_type": q.question_type,
                "options": q.options,
                "order_index": q.order_index,
            }
            for q in questions
        ],
    }


@router.post("/quizzes/{quiz_id}/attempt")
def attempt_quiz(quiz_id: int, req: QuizSubmitRequest, user: User = Depends(require_user), db: Session = Depends(get_db)):
    quiz = db.query(Quiz).filter(Quiz.id == quiz_id).first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    score, passed, results = submit_quiz(db, user.id, quiz_id, req.answers)

    xp_earned = 5 if passed else 0

    return {
        "score": score,
        "passed": passed,
        "results": results,
        "xp_earned": xp_earned,
    }


@router.get("/progress")
def learning_progress(user: User = Depends(require_user), db: Session = Depends(get_db)):
    return get_learning_progress(db, user.id)


@router.get("/concepts")
def list_concepts(db: Session = Depends(get_db)):
    concepts = db.query(Concept).order_by(Concept.category, Concept.name).all()
    return {
        "concepts": [
            {
                "slug": c.slug,
                "name": c.name,
                "description": c.description,
                "category": c.category,
            }
            for c in concepts
        ]
    }


@router.get("/concepts/mastery")
def concept_mastery(user: User = Depends(require_user), db: Session = Depends(get_db)):
    concepts = get_concept_mastery(db, user.id)
    return {"concepts": concepts}


@router.get("/recommendations")
def recommendations(user: User = Depends(require_user), db: Session = Depends(get_db)):
    return get_recommendations(db, user.id)


@router.get("/practice/{lesson_slug}")
def practice_problems(lesson_slug: str, db: Session = Depends(get_db)):
    problems = get_related_problems(db, lesson_slug)
    return {"problems": problems}
