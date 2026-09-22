from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import auth, dashboard, problems, submissions, waveforms, leaderboard, achievements, learning, ai
from app.core.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Seed new problems on startup (idempotent)
    try:
        from app.seed_expand import seed_new_problems
        seed_new_problems()
    except Exception as e:
        import logging
        logging.getLogger(__name__).warning("seed_expand failed: %s", e)
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
