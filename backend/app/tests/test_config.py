"""Config unit tests.

We pass _env_file=None to every Settings() constructor so the real
backend/.env is not loaded, giving monkeypatch full control over env vars.
Production behavior is unchanged — only test isolation is affected.
"""

import pytest
from app.core.config import Settings


def _fresh(**env_overrides) -> Settings:
    """Create a Settings instance with no .env file, using only the supplied values."""
    return Settings(_env_file=None, **env_overrides)


def test_get_database_url_uses_explicit_database_url():
    s = _fresh(DATABASE_URL="postgresql://user:pass@host:5432/db")
    assert s.get_database_url() == "postgresql://user:pass@host:5432/db"


def test_get_database_url_constructs_postgres_from_parts():
    s = _fresh(
        DATABASE_URL="",
        POSTGRES_USER="user",
        POSTGRES_PASSWORD="pass",
        POSTGRES_HOST="dbhost",
        POSTGRES_PORT=5432,
        POSTGRES_DB="mydb",
    )
    assert s.get_database_url() == "postgresql://user:pass@dbhost:5432/mydb"


def test_get_database_url_raises_when_no_config():
    s = _fresh(DATABASE_URL="", POSTGRES_HOST="")
    with pytest.raises(RuntimeError, match="DATABASE_URL or POSTGRES_HOST must be set"):
        s.get_database_url()


def test_no_sqlite_fallback():
    """SQLite must never be returned under any circumstances."""
    s = _fresh(DATABASE_URL="", POSTGRES_HOST="")
    try:
        url = s.get_database_url()
        assert not url.startswith("sqlite"), f"SQLite fallback must not exist, got: {url}"
    except RuntimeError:
        pass  # Expected — no config means RuntimeError, not SQLite


def test_explicit_database_url_takes_priority_over_postgres_parts():
    """DATABASE_URL must win even when POSTGRES_* vars are also set."""
    s = _fresh(
        DATABASE_URL="postgresql://explicit:url@explicit-host:5432/explicit",
        POSTGRES_USER="other",
        POSTGRES_HOST="other-host",
    )
    assert s.get_database_url() == "postgresql://explicit:url@explicit-host:5432/explicit"
