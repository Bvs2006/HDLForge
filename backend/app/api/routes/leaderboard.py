from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import Problem, Profile, UserAchievement, UserProblemProgress, ProgressStatus
from app.api.routes.auth import require_user
from app.services.achievement_service import calculate_streak, get_user_rank

router = APIRouter(prefix="/leaderboard", tags=["leaderboard"])


class LeaderboardEntry(BaseModel):
    rank: int
    user_id: str
    username: str
    display_name: str | None
    xp: int
    level: int
    solved_count: int
    progress: float
    streak: int
    achievements: int


class LeaderboardResponse(BaseModel):
    entries: list[LeaderboardEntry]
    total_users: int
    page: int
    limit: int
    total_pages: int


class CurrentUserRankResponse(BaseModel):
    rank: int
    xp: int
    level: int
    solved_count: int
    progress: float
    streak: int
    achievements: int


@router.get("", response_model=LeaderboardResponse)
def get_leaderboard(
    page: int = Query(1, ge=1),
    limit: int = Query(50, ge=1, le=100),
    search: str | None = Query(None, max_length=50),
    db: Session = Depends(get_db),
):
    total_problems = db.query(func.count(Problem.id)).scalar() or 1

    query = db.query(Profile)

    if search:
        search_term = f"%{search}%"
        query = query.filter(
            (Profile.username.ilike(search_term)) | (Profile.display_name.ilike(search_term))
        )

    total_users = query.count()

    entries = (
        query
        .order_by(Profile.xp.desc(), Profile.solved_count.desc(), Profile.created_at.asc())
        .offset((page - 1) * limit)
        .limit(limit)
        .all()
    )

    result = []
    for idx, user in enumerate(entries):
        rank = (page - 1) * limit + idx + 1
        progress = round((user.solved_count / total_problems) * 100, 1) if total_problems > 0 else 0.0
        streak = calculate_streak(db, user.id)
        achievement_count = (
            db.query(func.count(UserAchievement.id))
            .filter(UserAchievement.user_id == user.id)
            .scalar() or 0
        )
        result.append(LeaderboardEntry(
            rank=rank,
            user_id=user.id,
            username=user.username,
            display_name=user.display_name,
            xp=user.xp,
            level=user.level,
            solved_count=user.solved_count,
            progress=progress,
            streak=streak,
            achievements=achievement_count,
        ))

    total_pages = (total_users + limit - 1) // limit

    return LeaderboardResponse(
        entries=result,
        total_users=total_users,
        page=page,
        limit=limit,
        total_pages=total_pages,
    )


@router.get("/me", response_model=CurrentUserRankResponse)
def get_my_rank(
    user: Profile = Depends(require_user),
    db: Session = Depends(get_db),
):
    rank = get_user_rank(db, user.id)
    total_problems = db.query(func.count(Problem.id)).scalar() or 1
    progress = round((user.solved_count / total_problems) * 100, 1) if total_problems > 0 else 0.0
    streak = calculate_streak(db, user.id)
    achievement_count = (
        db.query(func.count(UserAchievement.id))
        .filter(UserAchievement.user_id == user.id)
        .scalar() or 0
    )
    return CurrentUserRankResponse(
        rank=rank,
        xp=user.xp,
        level=user.level,
        solved_count=user.solved_count,
        progress=progress,
        streak=streak,
        achievements=achievement_count,
    )
