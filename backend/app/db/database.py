from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.core.config import settings

_db_url = settings.get_database_url()

# Never allow SQLite in this application
if _db_url.startswith("sqlite"):
    raise RuntimeError(
        "SQLite is not supported. Set DATABASE_URL to a PostgreSQL connection string."
    )

engine = create_engine(_db_url, echo=settings.DEBUG, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
