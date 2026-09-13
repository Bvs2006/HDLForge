from pydantic import BaseModel, Field

from app.db.models import Language


class SubmissionRequest(BaseModel):
    problem_slug: str = Field(..., max_length=100)
    language: Language
    code: str = Field(..., max_length=50000)
    testbench_code: str | None = Field(None, max_length=50000)


class TestResult(BaseModel):
    name: str
    passed: bool | None = None
    expected: str = ""
    received: str = ""
    message: str = ""


class AchievementInfo(BaseModel):
    slug: str
    name: str
    description: str
    icon: str
    xp_reward: int


class SubmissionResponse(BaseModel):
    status: str
    message: str
    compilation_message: str | None = None
    tests: list[TestResult] = []
    score: int = 0
    tests_passed: int = 0
    tests_total: int = 0
    execution_time: float = 0.0
    submission_id: int = 0
    waveform_id: str | None = None
    xp_earned: int = 0
    xp_total: int = 0
    level: int = 1
    progress_status: str | None = None
    achievements_unlocked: list[AchievementInfo] = []
    submitted_by: str | None = None
    submitted_by_display: str | None = None
