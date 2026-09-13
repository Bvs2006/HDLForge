from datetime import datetime, timedelta, timezone

from pydantic import BaseModel
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import (
    Achievement,
    Concept,
    Difficulty,
    LessonProgress,
    LessonProgressStatus,
    LearningModule,
    LearningPath,
    Problem,
    ProgressStatus,
    Submission,
    SubmissionStatus,
    User,
    UserAchievement,
    UserConceptProgress,
    UserProblemProgress,
)
from app.api.routes.auth import require_user
from app.services.achievement_service import (
    calculate_level,
    calculate_streak,
    get_user_rank,
    xp_for_current_level,
    xp_for_next_level,
)
from fastapi import APIRouter, Depends

router = APIRouter(prefix="/me", tags=["dashboard"])

DIFFICULTY_XP = {
    Difficulty.EASY: 10,
    Difficulty.MEDIUM: 20,
    Difficulty.HARD: 40,
}


class ProblemProgress(BaseModel):
    problem_id: int
    slug: str
    title: str
    difficulty: str
    status: str
    best_score: float
    attempts: int


class CategoryProgress(BaseModel):
    category: str
    solved: int
    total: int


class LanguageProgress(BaseModel):
    language: str
    solved: int
    total: int


class DifficultyStats(BaseModel):
    difficulty: str
    solved: int
    total: int
    xp: int


class RecentAchievement(BaseModel):
    slug: str
    name: str
    description: str
    icon: str
    xp_reward: int
    unlocked_at: str


class PersonalBests(BaseModel):
    best_score: float
    fastest_accepted: float | None
    most_difficult: str | None
    longest_streak: int


class DashboardResponse:
    problems_solved: int
    problems_attempted: int
    current_streak: int
    xp: int
    level: int
    xp_in_current_level: int
    xp_for_next: int
    rank: int
    total_submissions: int
    success_rate: float
    difficulty_stats: list[DifficultyStats]
    recent_submissions: list[dict]
    category_progress: list[CategoryProgress]
    language_progress: list[LanguageProgress]
    problem_progress: list[ProblemProgress]
    recent_achievements: list[RecentAchievement]
    personal_bests: PersonalBests


class DashboardResponseModel(BaseModel):
    problems_solved: int
    problems_attempted: int
    current_streak: int
    xp: int
    level: int
    xp_in_current_level: int
    xp_for_next: int
    rank: int
    total_submissions: int
    success_rate: float
    difficulty_stats: list[DifficultyStats]
    recent_submissions: list[dict]
    category_progress: list[CategoryProgress]
    language_progress: list[LanguageProgress]
    problem_progress: list[ProblemProgress]
    recent_achievements: list[RecentAchievement]
    personal_bests: PersonalBests


def _get_learning_progress(db: Session, user_id: int) -> dict:
    paths = db.query(LearningPath).filter(LearningPath.published == True).all()

    total_lessons = 0
    completed_lessons = 0
    in_progress_lessons = 0

    for path in paths:
        modules = (
            db.query(LearningModule)
            .filter(LearningModule.learning_path_id == path.id)
            .order_by(LearningModule.order_index)
            .all()
        )
        for module in modules:
            from app.db.models import Lesson
            lessons = (
                db.query(Lesson)
                .filter(Lesson.module_id == module.id, Lesson.published == True)
                .all()
            )
            total_lessons += len(lessons)
            for lesson in lessons:
                progress = (
                    db.query(LessonProgress)
                    .filter(
                        LessonProgress.user_id == user_id,
                        LessonProgress.lesson_id == lesson.id,
                    )
                    .first()
                )
                if progress:
                    if progress.status == LessonProgressStatus.COMPLETED:
                        completed_lessons += 1
                    elif progress.status == LessonProgressStatus.IN_PROGRESS:
                        in_progress_lessons += 1

    concept_progress = (
        db.query(UserConceptProgress)
        .filter(UserConceptProgress.user_id == user_id)
        .all()
    )
    concepts_mastered = sum(1 for c in concept_progress if c.mastery_score >= 80)
    concepts_in_progress = sum(1 for c in concept_progress if 0 < c.mastery_score < 80)

    recent_lessons = (
        db.query(LessonProgress)
        .filter(
            LessonProgress.user_id == user_id,
            LessonProgress.status == LessonProgressStatus.COMPLETED,
        )
        .order_by(LessonProgress.completed_at.desc())
        .limit(3)
        .all()
    )
    recent_lesson_data = []
    for lp in recent_lessons:
        lesson = db.query(Lesson).filter(Lesson.id == lp.lesson_id).first()
        if lesson:
            recent_lesson_data.append({
                "slug": lesson.slug,
                "title": lesson.title,
                "completed_at": lp.completed_at.isoformat() if lp.completed_at else "",
            })

    return {
        "total_lessons": total_lessons,
        "completed_lessons": completed_lessons,
        "in_progress_lessons": in_progress_lessons,
        "progress_percent": round((completed_lessons / total_lessons * 100) if total_lessons > 0 else 0, 1),
        "concepts_mastered": concepts_mastered,
        "concepts_in_progress": concepts_in_progress,
        "recent_lessons": recent_lesson_data,
    }


def get_dashboard(db: Session, user_id: int) -> dict:
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        return {}

    total_problems = db.query(func.count(Problem.id)).scalar() or 0

    progress_records = (
        db.query(UserProblemProgress)
        .filter(UserProblemProgress.user_id == user_id)
        .all()
    )

    solved = sum(1 for p in progress_records if p.status == ProgressStatus.SOLVED)
    attempted = sum(1 for p in progress_records if p.status != ProgressStatus.NOT_STARTED)

    total_attempts = sum(p.attempts for p in progress_records)
    total_solved_attempts = sum(
        p.attempts for p in progress_records if p.status == ProgressStatus.SOLVED
    )
    success_rate = (total_solved_attempts / total_attempts * 100) if total_attempts > 0 else 0.0

    streak = calculate_streak(db, user_id)
    rank = get_user_rank(db, user_id)

    solved_problem_ids = [p.problem_id for p in progress_records if p.status == ProgressStatus.SOLVED]

    difficulty_stats = []
    for diff in [Difficulty.EASY, Difficulty.MEDIUM, Difficulty.HARD]:
        diff_total = db.query(func.count(Problem.id)).filter(Problem.difficulty == diff).scalar() or 0
        diff_solved = 0
        diff_xp = 0
        for pid in solved_problem_ids:
            problem = db.query(Problem).filter(Problem.id == pid).first()
            if problem and problem.difficulty == diff:
                diff_solved += 1
                diff_xp += DIFFICULTY_XP.get(diff, 10)
        difficulty_stats.append(DifficultyStats(
            difficulty=diff.value.lower(),
            solved=diff_solved,
            total=diff_total,
            xp=diff_xp,
        ))

    recent_subs = (
        db.query(Submission)
        .filter(
            Submission.user_id == user_id
        )
        .order_by(Submission.created_at.desc())
        .limit(10)
        .all()
    )

    recent_submissions = []
    for sub in recent_subs:
        problem = db.query(Problem).filter(Problem.id == sub.problem_id).first()
        recent_submissions.append({
            "id": sub.id,
            "problem_slug": problem.slug if problem else "",
            "problem_title": problem.title if problem else "",
            "difficulty": problem.difficulty.value.lower() if problem else "",
            "score": sub.score,
            "status": sub.status.value,
            "created_at": sub.created_at.isoformat() if sub.created_at else "",
        })

    categories = db.query(Problem.category).distinct().all()
    category_progress = []
    for (cat,) in categories:
        cat_total = db.query(func.count(Problem.id)).filter(Problem.category == cat).scalar() or 0
        cat_solved = 0
        for pid in solved_problem_ids:
            problem = db.query(Problem).filter(Problem.id == pid, Problem.category == cat).first()
            if problem:
                cat_solved += 1
        category_progress.append(CategoryProgress(category=cat, solved=cat_solved, total=cat_total))

    languages = db.query(Problem.language).distinct().all()
    language_progress = []
    for (lang,) in languages:
        lang_total = db.query(func.count(Problem.id)).filter(Problem.language == lang).scalar() or 0
        lang_solved = 0
        for pid in solved_problem_ids:
            problem = db.query(Problem).filter(Problem.id == pid, Problem.language == lang).first()
            if problem:
                lang_solved += 1
        language_progress.append(
            LanguageProgress(language=lang.value.lower(), solved=lang_solved, total=lang_total)
        )

    problem_progress = []
    for p in progress_records:
        problem = db.query(Problem).filter(Problem.id == p.problem_id).first()
        if problem:
            problem_progress.append(
                ProblemProgress(
                    problem_id=p.problem_id,
                    slug=problem.slug,
                    title=problem.title,
                    difficulty=problem.difficulty.value.lower(),
                    status=p.status.value,
                    best_score=p.best_score,
                    attempts=p.attempts,
                )
            )

    recent_ach_records = (
        db.query(UserAchievement)
        .filter(UserAchievement.user_id == user_id)
        .order_by(UserAchievement.unlocked_at.desc())
        .limit(5)
        .all()
    )
    recent_achievements = []
    for ua in recent_ach_records:
        ach = db.query(Achievement).filter(Achievement.id == ua.achievement_id).first()
        if ach:
            recent_achievements.append(RecentAchievement(
                slug=ach.slug,
                name=ach.name,
                description=ach.description,
                icon=ach.icon,
                xp_reward=ach.xp_reward,
                unlocked_at=ua.unlocked_at.isoformat() if ua.unlocked_at else "",
            ))

    best_score = max((p.best_score for p in progress_records), default=0.0)

    fastest_accepted = None
    fastest_sub = (
        db.query(Submission)
        .filter(
            Submission.problem_id.in_(solved_problem_ids),
            Submission.status == SubmissionStatus.PASSED,
        )
        .order_by(Submission.execution_time.asc())
        .first()
    )
    if fastest_sub:
        fastest_accepted = fastest_sub.execution_time

    most_difficult = None
    if solved_problem_ids:
        hardest = (
            db.query(Problem)
            .filter(Problem.id.in_(solved_problem_ids))
            .order_by(
                Problem.difficulty.desc().nullslast(),
            )
            .first()
        )
        if hardest:
            most_difficult = hardest.difficulty.value.lower()

    personal_bests = PersonalBests(
        best_score=best_score,
        fastest_accepted=fastest_accepted,
        most_difficult=most_difficult,
        longest_streak=streak,
    )

    learning_progress = _get_learning_progress(db, user_id)

    return {
        "problems_solved": solved,
        "problems_attempted": attempted,
        "current_streak": streak,
        "xp": user.xp,
        "level": user.level,
        "xp_in_current_level": user.xp - xp_for_current_level(user.level),
        "xp_for_next": xp_for_next_level(user.level) - xp_for_current_level(user.level),
        "rank": rank,
        "total_submissions": user.total_submissions,
        "success_rate": round(success_rate, 1),
        "difficulty_stats": difficulty_stats,
        "recent_submissions": recent_submissions,
        "category_progress": category_progress,
        "language_progress": language_progress,
        "problem_progress": problem_progress,
        "recent_achievements": recent_achievements,
        "personal_bests": personal_bests,
        "learning_progress": learning_progress,
    }


@router.get("/dashboard")
def dashboard(user=Depends(require_user), db: Session = Depends(get_db)):
    return get_dashboard(db, user.id)


@router.get("/submissions")
def user_submissions(user=Depends(require_user), db: Session = Depends(get_db)):
    submissions = (
        db.query(Submission)
        .filter(Submission.user_id == user.id)
        .order_by(Submission.created_at.desc())
        .limit(100)
        .all()
    )

    result = []
    for sub in submissions:
        problem = db.query(Problem).filter(Problem.id == sub.problem_id).first()
        result.append({
            "id": sub.id,
            "problem_slug": problem.slug if problem else "",
            "problem_title": problem.title if problem else "",
            "difficulty": problem.difficulty.value.lower() if problem else "",
            "score": sub.score,
            "status": sub.status.value,
            "language": sub.language.value.lower(),
            "execution_time": sub.execution_time,
            "tests_passed": sub.tests_passed,
            "tests_total": sub.tests_total,
            "created_at": sub.created_at.isoformat() if sub.created_at else "",
        })

    return {"submissions": result}
