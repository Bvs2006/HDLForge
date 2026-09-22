from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import auth, dashboard, problems, submissions, waveforms, leaderboard, achievements, learning, ai
from app.core.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    import logging
    logger = logging.getLogger(__name__)

    # 1. Automatically create tables if not present (crucial for fresh DB on Render/Supabase)
    try:
        from app.db.database import engine
        from app.db.models import Base
        Base.metadata.create_all(bind=engine)
    except Exception as e:
        logger.warning("Base.metadata.create_all error: %s", e)

    # 2. Seed base problems if empty
    try:
        from app.seed import seed_problems
        seed_problems()
    except Exception as e:
        logger.warning("seed_problems error: %s", e)

    # 3. Seed expanded problems (21 problems + tags)
    try:
        from app.seed_expand import seed_new_problems
        seed_new_problems()
    except Exception as e:
        logger.warning("seed_expand error: %s", e)

    # 4. Seed learning content if present
    try:
        from app.seed_learning import seed_learning_content
        seed_learning_content()
    except Exception as e:
        logger.warning("seed_learning error: %s", e)

    yield


app = FastAPI(
    title=settings.PROJECT_NAME,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_origin_regex=settings.CORS_ORIGIN_REGEX if hasattr(settings, "CORS_ORIGIN_REGEX") else None,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(problems.router, prefix=settings.API_V1_PREFIX)
app.include_router(submissions.router, prefix=settings.API_V1_PREFIX)
app.include_router(waveforms.router, prefix=settings.API_V1_PREFIX)
app.include_router(auth.router, prefix=settings.API_V1_PREFIX)
app.include_router(dashboard.router, prefix=settings.API_V1_PREFIX)
app.include_router(leaderboard.router, prefix=settings.API_V1_PREFIX)
app.include_router(achievements.router, prefix=settings.API_V1_PREFIX)
app.include_router(learning.router, prefix=settings.API_V1_PREFIX)
app.include_router(ai.router, prefix=settings.API_V1_PREFIX)


@app.get("/api/health")
def health_check():
    return {"status": "ok"}
