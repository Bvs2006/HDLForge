import pytest
from app.core.config import Settings

def test_get_database_url_fallback_to_sqlite(monkeypatch):
    # Ensure DATABASE_URL is empty and POSTGRES_HOST is empty to trigger SQLite fallback
    monkeypatch.setattr(Settings, "DATABASE_URL", "", raising=False)
    settings = Settings()
    settings.POSTGRES_HOST = ""
    url = settings.get_database_url()
    assert url.startswith("sqlite:///"), f"Expected SQLite fallback, got {url}"

def test_get_database_url_returns_postgres_when_configured(monkeypatch):
    monkeypatch.setattr(Settings, "DATABASE_URL", "", raising=False)
    settings = Settings()
    settings.POSTGRES_USER = "user"
    settings.POSTGRES_PASSWORD = "pass"
    settings.POSTGRES_HOST = "dbhost"
    settings.POSTGRES_PORT = 5432
    settings.POSTGRES_DB = "mydb"
    url = settings.get_database_url()
    expected = "postgresql://user:pass@dbhost:5432/mydb"
    assert url == expected
