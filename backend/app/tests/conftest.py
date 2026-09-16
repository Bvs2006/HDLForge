"""pytest configuration for the backend test suite."""
import pytest


@pytest.fixture(autouse=True)
def clear_local_email_registry():
    """Clear the in-memory email registry before each test to ensure isolation."""
    from app.services import auth_service
    with auth_service._local_email_lock:
        auth_service._local_email_registry.clear()
    yield
    with auth_service._local_email_lock:
        auth_service._local_email_registry.clear()
