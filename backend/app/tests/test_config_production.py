"""Production config behavior tests.

These tests verify that the production configuration:
- Never falls back to SQLite under any circumstances
- Raises RuntimeError when neither DATABASE_URL nor POSTGRES_HOST is set
- Uses DATABASE_URL when explicitly provided
- Constructs a PostgreSQL URL from POSTGRES_* parts when DATABASE_URL is absent

We pass _env_file=None to Settings() so the real backend/.env is not loaded.
"""

import pytest
from app.core.config import Settings


def _fresh(**kwargs) -> Settings:
    return Settings(_env_file=None, **kwargs)


def test_no_sqlite_fallback_in_development():
    """Even in DEBUG mode, SQLite must never be returned."""
    s = _fresh(DEBUG=True, DATABASE_URL="", POSTGRES_HOST="")
    try:
        url = s.get_database_url()
        assert not url.startswith("sqlite"), f"SQLite fallback must not exist, got: {url}"
    except RuntimeError:
        pass  # Correct — RuntimeError is the expected outcome, not SQLite


def test_no_config_raises_runtime_error():
    """When neither DATABASE_URL nor POSTGRES_HOST is set, RuntimeError is raised."""
    s = _fresh(DATABASE_URL="", POSTGRES_HOST="")
    with pytest.raises(RuntimeError, match="DATABASE_URL or POSTGRES_HOST must be set"):
        s.get_database_url()


def test_explicit_database_url_takes_precedence():
    """DATABASE_URL always wins over POSTGRES_* parts."""
    explicit_url = "postgresql://user:pass@host:5432/dbname"
    s = _fresh(DATABASE_URL=explicit_url)
    assert s.get_database_url() == explicit_url


def test_postgres_parts_used_when_no_database_url():
    """POSTGRES_* vars are used to construct URL when DATABASE_URL is absent."""
    s = _fresh(
        DATABASE_URL="",
        POSTGRES_USER="u",
        POSTGRES_PASSWORD="p",
        POSTGRES_HOST="h",
        POSTGRES_PORT=5432,
        POSTGRES_DB="d",
    )
    assert s.get_database_url() == "postgresql://u:p@h:5432/d"
