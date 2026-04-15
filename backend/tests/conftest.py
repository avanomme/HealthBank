# Created with the Assistance of Claude Code
# backend/tests/conftest.py
"""
Shared pytest fixtures for backend API tests.

This conftest.py provides common fixtures used across all test files,
ensuring consistent test setup and avoiding duplicate code.

IMPORTANT: mock_db patches get_db_connection at EVERY import site,
not just app.utils.utils. Python's `from X import Y` creates a local
name binding, so patching the source alone does not affect modules
that already imported it.
"""

import pytest
from fastapi.testclient import TestClient
from datetime import datetime, timedelta
from unittest.mock import patch
from tests.mocks.db import FakeConnection, FakeCursor


# Every module that does `from ...utils.utils import get_db_connection`
# gets its own local reference. We must patch ALL of them.
_DB_IMPORT_SITES = [
    "app.utils.utils.get_db_connection",
    "app.api.v1.auth.get_db_connection",
    "app.api.v1.sessions.get_db_connection",
    "app.api.deps.get_db_connection",
    "app.api.v1.admin.get_db_connection",
    "app.api.v1.responses.get_db_connection",
    "app.api.v1.surveys.get_db_connection",
    "app.api.v1.templates.get_db_connection",
    "app.api.v1.question_bank.get_db_connection",
    "app.api.v1.assignments.get_db_connection",
    "app.api.v1.users.get_db_connection",
    "app.api.v1.research.get_db_connection",
    "app.api.v1.two_factor.get_db_connection",
    "app.api.v1.tos.get_db_connection",
    "app.api.v1.participants.get_db_connection",
    "app.services.aggregation.get_db_connection",
    "app.middleware.audit_to_auditevent.get_db_connection",
    "app.audit.logger.get_db_connection",
    "app.utils.password_reset_tokens.get_db_connection",
    "app.api.v1.consent.get_db_connection",
    "app.api.v1.hcp_links.get_db_connection",
    "app.api.v1.hcp_patients.get_db_connection",
    "app.api.v1.messaging.get_db_connection",
    "app.api.v1.health_tracking.get_db_connection",
]


# Default mock admin user returned by the auth override.
# All test endpoints pass require_role() because RoleID=4 (admin).
MOCK_ADMIN_USER = {
    "account_id": 999,
    "email": "testadmin@example.com",
    "tos_accepted_at": "2026-01-01",
    "tos_version": "1.0",
    "role_id": 4,
    "viewing_as_user_id": None,
    "effective_account_id": 999,
    "effective_role_id": 4,
}


@pytest.fixture(autouse=True)
def mock_db():
    """Patch get_db_connection at every import site so no test hits real MySQL."""
    patches = []
    for target in _DB_IMPORT_SITES:
        try:
            p = patch(target, return_value=FakeConnection())
            p.start()
            patches.append(p)
        except (ModuleNotFoundError, AttributeError):
            pass  # Module may not exist yet
    yield
    for p in patches:
        p.stop()


@pytest.fixture(autouse=True)
def mock_auth():
    """Override get_current_user on the main app so all router-level
    require_role() guards pass automatically.

    Tests that verify auth behaviour should clear this override in their
    own autouse fixture:

        @pytest.fixture(autouse=True)
        def clear_auth_override():
            from app.main import app
            from app.api.deps import get_current_user
            app.dependency_overrides.pop(get_current_user, None)
            yield
    """
    from app.main import app
    from app.api.deps import get_current_user

    def _fake_current_user():
        return MOCK_ADMIN_USER

    app.dependency_overrides[get_current_user] = _fake_current_user
    yield
    app.dependency_overrides.pop(get_current_user, None)


@pytest.fixture(autouse=True)
def reset_rate_limit():
    """Clear rate-limit buckets between tests."""
    from app.api.deps import _BUCKETS
    _BUCKETS.clear()
    yield
    _BUCKETS.clear()


@pytest.fixture(autouse=True)
def reset_settings_cache():
    """Clear the settings service cache between tests so stale values don't bleed through."""
    import app.services.settings as settings_svc
    settings_svc._cache = {}
    settings_svc._cache_at = 0.0
    yield
    settings_svc._cache = {}
    settings_svc._cache_at = 0.0


@pytest.fixture(autouse=True)
def reset_fake_db_state():
    """Clear ALL in-memory table data between tests."""
    # Auth / Account tables
    FakeCursor.used_emails.clear()
    FakeCursor.accounts.clear()
    FakeCursor.users.clear()
    FakeCursor.sessions.clear()
    FakeCursor.next_auth_id = 1
    FakeCursor.next_account_id = 1

    # Account requests
    FakeCursor.account_requests.clear()
    FakeCursor.next_request_id = 1

    # Generic tables
    FakeCursor.questions.clear()
    FakeCursor.options.clear()
    FakeCursor.surveys.clear()
    FakeCursor.question_list.clear()
    FakeCursor.templates.clear()
    FakeCursor.template_questions.clear()
    FakeCursor.assignments.clear()
    FakeCursor.responses.clear()
    FakeCursor.next_question_id = 1
    FakeCursor.next_option_id = 1
    FakeCursor.next_survey_id = 1
    FakeCursor.next_template_id = 1
    FakeCursor.next_assignment_id = 1

    yield

@pytest.fixture
def client():
    """
    Create test client for the FastAPI app.

    This is the primary fixture for all API tests.
    The client connects to the running FastAPI application.
    """
    from app.main import app
    return TestClient(app)


@pytest.fixture
def sample_question():
    """Basic question without options for testing"""
    return {
        "title": "Sleep Hours",
        "question_content": "How many hours of sleep do you get per night?",
        "response_type": "number",
        "is_required": True,
        "category": "Sleep"
    }


@pytest.fixture
def sample_choice_question():
    """Question with choice options for testing"""
    return {
        "title": "Exercise Frequency",
        "question_content": "How often do you exercise?",
        "response_type": "single_choice",
        "is_required": True,
        "category": "Exercise",
        "options": [
            {"option_text": "Never", "display_order": 1},
            {"option_text": "1-2 times per week", "display_order": 2},
            {"option_text": "3-4 times per week", "display_order": 3},
            {"option_text": "Daily", "display_order": 4}
        ]
    }


@pytest.fixture
def sample_survey():
    """Basic survey without questions for testing"""
    return {
        "title": "Health Assessment Survey",
        "description": "A survey to assess general health status",
        "publication_status": "draft"
    }


@pytest.fixture
def sample_template():
    """Basic template without questions for testing"""
    return {
        "title": "Health Assessment Template",
        "description": "A reusable template for health assessments",
        "is_public": False
    }


@pytest.fixture
def sample_assignment():
    """Basic assignment data for testing"""
    return {
        "account_id": 1,
        "due_date": (datetime.now() + timedelta(days=7)).isoformat()
    }


@pytest.fixture
def bulk_assignment():
    """Multiple user assignment data for testing"""
    return {
        "account_ids": [1, 2, 3],
        "due_date": (datetime.now() + timedelta(days=14)).isoformat()
    }


@pytest.fixture
def created_question(client, sample_question):
    """Create a question and return its data"""
    response = client.post("/api/v1/questions", json=sample_question)
    return response.json()


@pytest.fixture
def created_survey(client, sample_survey):
    """Create a survey and return its data"""
    response = client.post("/api/v1/surveys", json=sample_survey)
    return response.json()


@pytest.fixture
def published_survey(client):
    """Create a published survey for assignment testing"""
    # Create a question first
    q_response = client.post("/api/v1/questions", json={
        "title": "Test Question",
        "question_content": "Test question for assignment?",
        "response_type": "yesno"
    })
    question_id = q_response.json()["question_id"]

    # Create survey with question
    s_response = client.post("/api/v1/surveys", json={
        "title": "Assignment Test Survey",
        "description": "Survey for testing assignments",
        "question_ids": [question_id]
    })
    survey_id = s_response.json()["survey_id"]

    # Publish it
    client.patch(f"/api/v1/surveys/{survey_id}/publish")

    return survey_id


@pytest.fixture
def created_template(client, sample_template):
    """Create a template and return its data"""
    response = client.post("/api/v1/templates", json=sample_template)
    return response.json()
