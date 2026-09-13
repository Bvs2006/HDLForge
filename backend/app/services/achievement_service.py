"""Achievement service - evaluates achievements, manages XP, levels, and prevents duplicates."""

from datetime import datetime, timedelta, timezone
from dataclasses import dataclass

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.db.models import (
    Achievement,
    Difficulty,
    Problem,
    ProgressStatus,
    Submission,
    User,
    UserAchievement,
    UserProblemProgress,
)

DIFFICULTY_XP = {
    Difficulty.EASY: 10,
    Difficulty.MEDIUM: 20,
    Difficulty.HARD: 40,
}

LEVEL_THRESHOLDS = [
    0, 100, 250, 500, 1000, 1500, 2500, 3500, 5000, 7000,
    10000, 13000, 16000, 20000, 25000, 30000, 36000, 42000,
    50000, 60000, 70000, 80000, 90000, 100000,
]


@dataclass
class AchievementUnlock:
    slug: str
    name: str
    description: str
    icon: str
    xp_reward: int


def calculate_level(xp: int) -> int:
    level = 1
    for i, threshold in enumerate(LEVEL_THRESHOLDS):
        if xp >= threshold:
            level = i + 1
        else:
            break
    return level


def xp_for_next_level(level: int) -> int:
    if level < len(LEVEL_THRESHOLDS):
        return LEVEL_THRESHOLDS[level]
    return LEVEL_THRESHOLDS[-1]


def xp_for_current_level(level: int) -> int:
    if level - 1 < len(LEVEL_THRESHOLDS):
        return LEVEL_THRESHOLDS[level - 1]
    return LEVEL_THRESHOLDS[-1]


def award_solve_xp(user: User, problem: Problem) -> int:
    """Award XP for solving a problem. Returns XP earned (0 if already solved)."""
    return DIFFICULTY_XP.get(problem.difficulty, 10)


def get_user_rank(db: Session, user_id: int) -> int:
    """Get the user's rank by XP (descending), tie-break by solved_count (descending)."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        return 0

    rank = (
        db.query(func.count(User.id))
        .filter(
            (User.xp > user.xp) | ((User.xp == user.xp) & (User.solved_count > user.solved_count))
        )
        .scalar()
    )
    return (rank or 0) + 1


def calculate_streak(db: Session, user_id: int) -> int:
    """Calculate consecutive days with submissions."""
    today = datetime.now(timezone.utc).date()
    streak = 0
    current_date = today

    problem_ids = [
        p.problem_id for p in
        db.query(UserProblemProgress.problem_id)
        .filter(UserProblemProgress.user_id == user_id)
        .all()
    ]

    if not problem_ids:
        return 0

    while True:
        day_start = datetime(current_date.year, current_date.month, current_date.day, tzinfo=timezone.utc)
        day_end = day_start + timedelta(days=1)

        has_submission = (
            db.query(Submission)
            .filter(
                Submission.problem_id.in_(problem_ids),
                Submission.created_at >= day_start,
                Submission.created_at < day_end,
            )
            .first()
        )

        if has_submission:
            streak += 1
            current_date -= timedelta(days=1)
        else:
            break

    return streak


def evaluate_achievements(db: Session, user: User) -> list[AchievementUnlock]:
    """Evaluate all achievements for a user and unlock newly eligible ones. Returns newly unlocked."""
    achievements = db.query(Achievement).all()
    unlocked_ids = {
        ua.achievement_id for ua in
        db.query(UserAchievement.achievement_id)
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

    newly_unlocked: list[AchievementUnlock] = []

    for ach in achievements:
        if ach.id in unlocked_ids:
            continue

        eligible = False

        if ach.condition_type == "problems_solved":
            eligible = solved_count >= ach.condition_value

        elif ach.condition_type == "category_solved":
            category_counts: dict[str, int] = {}
            for pid in solved_problem_ids:
                problem = db.query(Problem).filter(Problem.id == pid).first()
                if problem:
                    cat = problem.category.lower()
                    category_counts[cat] = category_counts.get(cat, 0) + 1

            if ach.slug == "combinational-master":
                eligible = category_counts.get("combinational logic", 0) >= ach.condition_value
            elif ach.slug == "sequential-master":
                eligible = category_counts.get("sequential logic", 0) >= ach.condition_value
            elif ach.slug == "fsm-master":
                eligible = category_counts.get("fsm", 0) >= ach.condition_value

        elif ach.condition_type == "perfect_score":
            perfect_count = sum(
                1 for p in progress_records
                if p.status == ProgressStatus.SOLVED and p.best_score >= 100
            )
            eligible = perfect_count >= ach.condition_value

        elif ach.condition_type == "streak":
            eligible = streak >= ach.condition_value

        if eligible:
            user_achievement = UserAchievement(
                user_id=user.id,
                achievement_id=ach.id,
            )
            db.add(user_achievement)
            user.xp += ach.xp_reward
            user.level = calculate_level(user.xp)
            newly_unlocked.append(AchievementUnlock(
                slug=ach.slug,
                name=ach.name,
                description=ach.description,
                icon=ach.icon,
                xp_reward=ach.xp_reward,
            ))

    return newly_unlocked
