"""Learning service - curriculum progress, mastery, recommendations."""

import json
import logging
from datetime import datetime, timezone

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.db.models import (
    Concept,
    Difficulty,
    Lesson,
    LessonPrerequisite,
    LessonProgress,
    LessonProgressStatus,
    LearningModule,
    LearningPath,
    Problem,
    ProblemConcept,
    Quiz,
    QuizAttempt,
    QuizQuestion,
    User,
    UserConceptProgress,
    UserProblemProgress,
    ProgressStatus,
)

logger = logging.getLogger(__name__)

LESSON_XP = 5
QUIZ_PASS_XP = 5

MASTERY_SOLVE_SCORE = 10.0
MASTERY_FAIL_PENALTY = 3.0
MASTERY_QUIZ_PASS_SCORE = 10.0
MASTERY_LESSON_COMPLETE_SCORE = 5.0
MASTERY_REPEAT_BONUS = 2.0
MASTERY_MAX = 100.0
MASTERY_MIN = 0.0

PASSING_THRESHOLD = 0.7


def get_lesson_status(db: Session, lesson: Lesson, user_id: int | None) -> str:
    if not user_id:
        return "NOT_STARTED"
    progress = (
        db.query(LessonProgress)
        .filter(LessonProgress.lesson_id == lesson.id, LessonProgress.user_id == user_id)
        .first()
    )
    if not progress:
        return "NOT_STARTED"
    return progress.status.value


def are_prerequisites_met(db: Session, lesson: Lesson, user_id: int) -> bool:
    prereqs = (
        db.query(LessonPrerequisite)
        .filter(LessonPrerequisite.lesson_id == lesson.id)
        .all()
    )
    if not prereqs:
        return True

    for prereq in prereqs:
        progress = (
            db.query(LessonProgress)
            .filter(
                LessonProgress.lesson_id == prereq.prerequisite_lesson_id,
                LessonProgress.user_id == user_id,
                LessonProgress.status == LessonProgressStatus.COMPLETED,
            )
            .first()
        )
        if not progress:
            return False
    return True


def start_lesson(db: Session, user_id: int, lesson_id: int) -> LessonProgress:
    existing = (
        db.query(LessonProgress)
        .filter(LessonProgress.user_id == user_id, LessonProgress.lesson_id == lesson_id)
        .first()
    )

    now = datetime.now(timezone.utc)

    if existing:
        existing.last_accessed_at = now
        if existing.status == LessonProgressStatus.NOT_STARTED:
            existing.status = LessonProgressStatus.IN_PROGRESS
            existing.started_at = now
        db.commit()
        db.refresh(existing)
        return existing

    progress = LessonProgress(
        user_id=user_id,
        lesson_id=lesson_id,
        status=LessonProgressStatus.IN_PROGRESS,
        started_at=now,
        last_accessed_at=now,
    )
    db.add(progress)
    db.commit()
    db.refresh(progress)
    return progress


def complete_lesson(db: Session, user_id: int, lesson_id: int) -> tuple[int, list[str]]:
    progress = (
        db.query(LessonProgress)
        .filter(LessonProgress.user_id == user_id, LessonProgress.lesson_id == lesson_id)
        .first()
    )

    if not progress:
        progress = start_lesson(db, user_id, lesson_id)

    xp_earned = 0
    achievements_new = []

    if progress.status != LessonProgressStatus.COMPLETED:
        progress.status = LessonProgressStatus.COMPLETED
        progress.completed_at = datetime.now(timezone.utc)
        xp_earned = LESSON_XP

        user = db.query(User).filter(User.id == user_id).first()
        if user:
            user.xp += xp_earned
            from app.services.achievement_service import calculate_level
            user.level = calculate_level(user.xp)

        _update_concept_mastery_on_lesson(db, user_id, lesson_id, completed=True)

    progress.last_accessed_at = datetime.now(timezone.utc)
    db.commit()

    return xp_earned, achievements_new


def submit_quiz(
    db: Session, user_id: int, quiz_id: int, answers: list[str]
) -> tuple[float, bool, list[dict]]:
    quiz = db.query(Quiz).filter(Quiz.id == quiz_id).first()
    if not quiz:
        return 0.0, False, []

    questions = (
        db.query(QuizQuestion)
        .filter(QuizQuestion.quiz_id == quiz_id)
        .order_by(QuizQuestion.order_index)
        .all()
    )

    if not questions:
        return 0.0, False, []

    correct = 0
    results = []
    for q in questions:
        user_answer = answers[q.order_index] if q.order_index < len(answers) else ""
        is_correct = user_answer.strip().lower() == q.correct_answer.strip().lower()
        if is_correct:
            correct += 1
        results.append({
            "question": q.question,
            "correct": is_correct,
            "correct_answer": q.correct_answer,
            "explanation": q.explanation,
        })

    score = round((correct / len(questions)) * 100, 1)
    passed = score >= (PASSING_THRESHOLD * 100)

    attempt = QuizAttempt(
        user_id=user_id,
        quiz_id=quiz_id,
        score=score,
        passed=passed,
        answers=json.dumps(answers),
    )
    db.add(attempt)

    if passed:
        user = db.query(User).filter(User.id == user_id).first()
        if user:
            user.xp += QUIZ_PASS_XP
            from app.services.achievement_service import calculate_level
            user.level = calculate_level(user.xp)

        _update_concept_mastery_on_quiz(db, user_id, quiz.lesson_id, passed=True)

    db.commit()
    return score, passed, results


def update_concept_mastery_on_solve(
    db: Session, user_id: int, problem_id: int, solved: bool
) -> None:
    concept_links = (
        db.query(ProblemConcept)
        .filter(ProblemConcept.problem_id == problem_id)
        .all()
    )

    for link in concept_links:
        progress = (
            db.query(UserConceptProgress)
            .filter(
                UserConceptProgress.user_id == user_id,
                UserConceptProgress.concept_id == link.concept_id,
            )
            .first()
        )

        if not progress:
            progress = UserConceptProgress(
                user_id=user_id,
                concept_id=link.concept_id,
                mastery_score=0.0,
            )
            db.add(progress)

        if solved:
            progress.solved_count += 1
            bonus = MASTERY_REPEAT_BONUS if progress.solved_count > 1 else MASTERY_SOLVE_SCORE
            progress.mastery_score = min(MASTERY_MAX, progress.mastery_score + bonus)
        else:
            progress.failed_count += 1
            progress.mastery_score = max(MASTERY_MIN, progress.mastery_score - MASTERY_FAIL_PENALTY)

        progress.last_practiced_at = datetime.now(timezone.utc)

    db.commit()


def _update_concept_mastery_on_lesson(
    db: Session, user_id: int, lesson_id: int, completed: bool
) -> None:
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        return

    module = db.query(LearningModule).filter(LearningModule.id == lesson.module_id).first()
    if not module:
        return

    path = db.query(LearningPath).filter(LearningPath.id == module.learning_path_id).first()
    if not path:
        return

    concept_slugs = _get_module_concept_slugs(db, module.slug)
    for slug in concept_slugs:
        concept = db.query(Concept).filter(Concept.slug == slug).first()
        if not concept:
            continue

        progress = (
            db.query(UserConceptProgress)
            .filter(
                UserConceptProgress.user_id == user_id,
                UserConceptProgress.concept_id == concept.id,
            )
            .first()
        )

        if not progress:
            progress = UserConceptProgress(
                user_id=user_id,
                concept_id=concept.id,
                mastery_score=0.0,
            )
            db.add(progress)

        if completed:
            progress.mastery_score = min(MASTERY_MAX, progress.mastery_score + MASTERY_LESSON_COMPLETE_SCORE)


def _update_concept_mastery_on_quiz(
    db: Session, user_id: int, lesson_id: int, passed: bool
) -> None:
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        return

    module = db.query(LearningModule).filter(LearningModule.id == lesson.module_id).first()
    if not module:
        return

    concept_slugs = _get_module_concept_slugs(db, module.slug)
    for slug in concept_slugs:
        concept = db.query(Concept).filter(Concept.slug == slug).first()
        if not concept:
            continue

        progress = (
            db.query(UserConceptProgress)
            .filter(
                UserConceptProgress.user_id == user_id,
                UserConceptProgress.concept_id == concept.id,
            )
            .first()
        )

        if not progress:
            progress = UserConceptProgress(
                user_id=user_id,
                concept_id=concept.id,
                mastery_score=0.0,
            )
            db.add(progress)

        if passed:
            progress.mastery_score = min(MASTERY_MAX, progress.mastery_score + MASTERY_QUIZ_PASS_SCORE)


def _get_module_concept_slugs(db: Session, module_slug: str) -> list[str]:
    mapping = {
        "digital-logic-fundamentals": ["and-gate", "or-gate", "not-gate", "nand-nor", "xor-xnor", "truth-tables", "boolean-expressions"],
        "combinational-logic": ["combinational", "continuous-assignment", "always-comb", "mux", "decoder", "encoder", "comparator", "adder"],
        "sequential-logic": ["sequential", "flip-flop", "register", "counter", "clock", "reset", "always-ff"],
        "arithmetic-rtl": ["binary-arithmetic", "signed-unsigned", "alu", "overflow", "parameterized"],
        "fsm-fundamentals": ["fsm", "moore-fsm", "mealy-fsm", "state-encoding", "fsm-patterns"],
    }
    return mapping.get(module_slug, [])


def get_learning_progress(db: Session, user_id: int) -> dict:
    paths = db.query(LearningPath).filter(LearningPath.published == True).all()

    result = []
    total_lessons = 0
    completed_lessons = 0

    for path in paths:
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
            module_completed = 0
            for lesson in lessons:
                status = get_lesson_status(db, lesson, user_id)
                total_lessons += 1
                if status == "COMPLETED":
                    completed_lessons += 1
                    module_completed += 1

                prereqs_met = are_prerequisites_met(db, lesson, user_id)
                lesson_data.append({
                    "id": lesson.id,
                    "slug": lesson.slug,
                    "title": lesson.title,
                    "description": lesson.description,
                    "difficulty": lesson.difficulty.value.lower(),
                    "estimated_minutes": lesson.estimated_minutes,
                    "order_index": lesson.order_index,
                    "status": status,
                    "prerequisites_met": prereqs_met,
                })

            module_data.append({
                "id": module.id,
                "slug": module.slug,
                "title": module.title,
                "description": module.description,
                "order_index": module.order_index,
                "lessons": lesson_data,
                "completed_lessons": module_completed,
                "total_lessons": len(lessons),
            })

        path_completed = sum(m["completed_lessons"] for m in module_data)
        path_total = sum(m["total_lessons"] for m in module_data)

        result.append({
            "id": path.id,
            "slug": path.slug,
            "title": path.title,
            "description": path.description,
            "difficulty": path.difficulty.value.lower(),
            "estimated_hours": path.estimated_hours,
            "modules": module_data,
            "completed_lessons": path_completed,
            "total_lessons": path_total,
            "progress_percent": round((path_completed / path_total * 100) if path_total > 0 else 0, 1),
        })

    return {
        "paths": result,
        "total_lessons": total_lessons,
        "completed_lessons": completed_lessons,
        "progress_percent": round((completed_lessons / total_lessons * 100) if total_lessons > 0 else 0, 1),
    }


def get_recommendations(db: Session, user_id: int) -> dict:
    paths = db.query(LearningPath).filter(LearningPath.published == True).all()

    next_lesson = None
    continue_path = None
    continue_module = None

    for path in paths:
        modules = (
            db.query(LearningModule)
            .filter(LearningModule.learning_path_id == path.id)
            .order_by(LearningModule.order_index)
            .all()
        )

        for module in modules:
            lessons = (
                db.query(Lesson)
                .filter(Lesson.module_id == module.id, Lesson.published == True)
                .order_by(Lesson.order_index)
                .all()
            )

            for lesson in lessons:
                status = get_lesson_status(db, lesson, user_id)
                prereqs_met = are_prerequisites_met(db, lesson, user_id)

                if status == "IN_PROGRESS" and prereqs_met:
                    next_lesson = lesson
                    continue_path = path
                    continue_module = module
                    break

                if status == "NOT_STARTED" and prereqs_met:
                    if not next_lesson:
                        next_lesson = lesson
                        continue_path = path
                        continue_module = module

            if next_lesson:
                break
        if next_lesson:
            break

    practice_problem = None
    weak_concept = None

    concept_progress = (
        db.query(UserConceptProgress)
        .filter(UserConceptProgress.user_id == user_id)
        .order_by(UserConceptProgress.mastery_score.asc())
        .limit(5)
        .all()
    )

    if concept_progress:
        weakest = concept_progress[0]
        if weakest.mastery_score < 30:
            concept = db.query(Concept).filter(Concept.id == weakest.concept_id).first()
            if concept:
                weak_concept = {
                    "slug": concept.slug,
                    "name": concept.name,
                    "mastery_score": weakest.mastery_score,
                }

                problem_link = (
                    db.query(ProblemConcept)
                    .filter(ProblemConcept.concept_id == concept.id)
                    .first()
                )
                if problem_link:
                    problem = db.query(Problem).filter(Problem.id == problem_link.problem_id).first()
                    if problem:
                        practice_problem = {
                            "slug": problem.slug,
                            "title": problem.title,
                            "difficulty": problem.difficulty.value.lower(),
                        }

    if not practice_problem and next_lesson:
        module = db.query(LearningModule).filter(LearningModule.id == next_lesson.module_id).first()
        if module:
            concept_slugs = _get_module_concept_slugs(db, module.slug)
            for cs in concept_slugs:
                concept = db.query(Concept).filter(Concept.slug == cs).first()
                if concept:
                    link = (
                        db.query(ProblemConcept)
                        .filter(ProblemConcept.concept_id == concept.id)
                        .first()
                    )
                    if link:
                        problem = db.query(Problem).filter(Problem.id == link.problem_id).first()
                        if problem:
                            user_progress = (
                                db.query(UserProblemProgress)
                                .filter(
                                    UserProblemProgress.user_id == user_id,
                                    UserProblemProgress.problem_id == problem.id,
                                )
                                .first()
                            )
                            if not user_progress or user_progress.status != ProgressStatus.SOLVED:
                                practice_problem = {
                                    "slug": problem.slug,
                                    "title": problem.title,
                                    "difficulty": problem.difficulty.value.lower(),
                                }
                                break

    recommendation_reason = ""
    if next_lesson:
        if continue_path and continue_module:
            recommendation_reason = f"Continue with \"{next_lesson.title}\" in {continue_module.title}"
        else:
            recommendation_reason = f"Start learning with \"{next_lesson.title}\""
    elif not next_lesson:
        recommendation_reason = "You've completed all available lessons! Great job."

    return {
        "next_lesson": {
            "slug": next_lesson.slug if next_lesson else None,
            "title": next_lesson.title if next_lesson else None,
            "module_slug": continue_module.slug if continue_module else None,
            "module_title": continue_module.title if continue_module else None,
            "path_slug": continue_path.slug if continue_path else None,
            "path_title": continue_path.title if continue_path else None,
        } if next_lesson else None,
        "practice_problem": practice_problem,
        "weak_concept": weak_concept,
        "reason": recommendation_reason,
    }


def get_concept_mastery(db: Session, user_id: int) -> list[dict]:
    concepts = db.query(Concept).order_by(Concept.category, Concept.name).all()

    result = []
    for concept in concepts:
        progress = (
            db.query(UserConceptProgress)
            .filter(
                UserConceptProgress.user_id == user_id,
                UserConceptProgress.concept_id == concept.id,
            )
            .first()
        )

        mastery = progress.mastery_score if progress else 0.0
        level = "beginner"
        if mastery >= 80:
            level = "mastered"
        elif mastery >= 60:
            level = "proficient"
        elif mastery >= 30:
            level = "developing"

        result.append({
            "slug": concept.slug,
            "name": concept.name,
            "category": concept.category,
            "mastery_score": mastery,
            "level": level,
            "solved_count": progress.solved_count if progress else 0,
            "failed_count": progress.failed_count if progress else 0,
        })

    return result


def get_related_problems(db: Session, lesson_slug: str) -> list[dict]:
    lesson = db.query(Lesson).filter(Lesson.slug == lesson_slug).first()
    if not lesson:
        return []

    module = db.query(LearningModule).filter(LearningModule.id == lesson.module_id).first()
    if not module:
        return []

    concept_slugs = _get_module_concept_slugs(db, module.slug)
    problem_ids = set()

    for cs in concept_slugs:
        concept = db.query(Concept).filter(Concept.slug == cs).first()
        if concept:
            links = (
                db.query(ProblemConcept)
                .filter(ProblemConcept.concept_id == concept.id)
                .all()
            )
            for link in links:
                problem_ids.add(link.problem_id)

    if not problem_ids:
        return []

    problems = db.query(Problem).filter(Problem.id.in_(problem_ids)).all()

    result = []
    for p in problems:
        result.append({
            "slug": p.slug,
            "title": p.title,
            "difficulty": p.difficulty.value.lower(),
            "category": p.category,
        })

    return result
