from datetime import datetime

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import Achievement, Profile, UserAchievement, UserProblemProgress, ProgressStatus, Problem
from app.api.routes.auth import get_current_user, require_user
from app.services.achievement_service import calculate_streak

router = APIRouter(prefix="/achievements", tags=["achievements"])


class AchievementResponse(BaseModel):
    slug: str
    name: str
    description: str
    icon: str
    xp_reward: int
    unlocked: bool
    unlocked_at: datetime | None = None
    progress_current: int = 0
    progress_target: int = 0


class UserAchievementsResponse(BaseModel):
    achievements: list[AchievementResponse]
    total_unlocked: int
    total_available: int


class AllAchievementsResponse(BaseModel):
    achievements: list[AchievementResponse]


@router.get("", response_model=AllAchievementsResponse)
def list_achievements(db: Session = Depends(get_db)):
    achievements = db.query(Achievement).order_by(Achievement.id).all()

    result = []
    for ach in achievements:
        result.append(AchievementResponse(
            slug=ach.slug,
            name=ach.name,
            description=ach.description,
            icon=ach.icon,
            xp_reward=ach.xp_reward,
            unlocked=False,
            progress_current=0,
            progress_target=ach.condition_value,
        ))

    return AllAchievementsResponse(achievements=result)


@router.get("/me", response_model=UserAchievementsResponse)
def get_my_achievements(
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    achievements = db.query(Achievement).order_by(Achievement.id).all()
    unlocked_map = {
        ua.achievement_id: ua.unlocked_at
        for ua in db.query(UserAchievement)
        .filter(UserAchievement.user_id == user.id)
        .all()
    }

    progress_records = (
        db.query(UserProblemProgress)
        .filter(UserProblemProgress.user_id == user.id)
        .all()
    )

    solved_count = sum(1 for p in progress_records if p.status == ProgressStatus.SOLVED)
    solved_problem_ids = [p.problem_id for p in progress_records if p.status == ProgressStatus.SOLVED]
    streak = calculate_streak(db, user.id)

    category_counts: dict[str, int] = {}
    for pid in solved_problem_ids:
        problem = db.query(Problem).filter(Problem.id == pid).first()
        if problem:
            cat = problem.category.lower()
            category_counts[cat] = category_counts.get(cat, 0) + 1

    perfect_count = sum(
        1 for p in progress_records
        if p.status == ProgressStatus.SOLVED and p.best_score >= 100
    )

    result = []
    total_unlocked = 0

    for ach in achievements:
        is_unlocked = ach.id in unlocked_map
        if is_unlocked:
            total_unlocked += 1

        progress_current = 0

        if ach.condition_type == "problems_solved":
            progress_current = min(solved_count, ach.condition_value)
        elif ach.condition_type == "category_solved":
            if ach.slug == "combinational-master":
                progress_current = min(category_counts.get("combinational logic", 0), ach.condition_value)
            elif ach.slug == "sequential-master":
                progress_current = min(category_counts.get("sequential logic", 0), ach.condition_value)
            elif ach.slug == "fsm-master":
                progress_current = min(category_counts.get("fsm", 0), ach.condition_value)
        elif ach.condition_type == "perfect_score":
            progress_current = min(perfect_count, ach.condition_value)
        elif ach.condition_type == "streak":
            progress_current = min(streak, ach.condition_value)

        result.append(AchievementResponse(
            slug=ach.slug,
            name=ach.name,
            description=ach.description,
            icon=ach.icon,
            xp_reward=ach.xp_reward,
            unlocked=is_unlocked,
            unlocked_at=unlocked_map.get(ach.id),
            progress_current=progress_current,
            progress_target=ach.condition_value,
        ))

    return UserAchievementsResponse(
        achievements=result,
        total_unlocked=total_unlocked,
        total_available=len(achievements),
    )
