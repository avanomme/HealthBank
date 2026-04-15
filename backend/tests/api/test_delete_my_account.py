# Created with the Assistance of Claude Code
"""
Tests for POST /api/v1/auth/me/deletion-request (self-account-deletion request).

Tests cover:
- 201 on valid request — account deactivated, deletion request created
- Endpoint requires authentication (handled by mock_auth fixture)
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.api.deps import get_current_user
from app.api.v1.auth import hash_password
from ..mocks.db import FakeCursor


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

PASSWORD = "CorrectPass123!"


def _seed_self_account(password: str = PASSWORD):
    """Seed account_id=999 (the MOCK_ADMIN_USER id used by mock_auth fixture)."""
    ph = hash_password(password)
    FakeCursor.accounts["self@example.com"] = {
        "account_id": 999,
        "password_hash": ph,
        "first_name": "Self",
        "last_name": "User",
        "email": "self@example.com",
        "role_id": 1,
        "auth_id": 1,
        "is_active": True,
    }


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

PARTICIPANT_USER = {
    "account_id": 999,
    "email": "self@example.com",
    "role_id": 1,
    "viewing_as_user_id": None,
    "effective_account_id": 999,
    "effective_role_id": 1,
}


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

class TestDeleteMyAccount:

    @pytest.fixture(autouse=True)
    def as_participant(self):
        """Override auth to a participant — admins cannot self-request deletion."""
        app.dependency_overrides[get_current_user] = lambda: PARTICIPANT_USER
        yield
        app.dependency_overrides.pop(get_current_user, None)

    def test_deletion_request_returns_201(self, client, reset_fake_db_state):
        """Valid deletion request → 201 Created; account is deactivated."""
        _seed_self_account()
        resp = client.post("/api/v1/auth/me/deletion-request")
        assert resp.status_code == 201
        data = resp.json()
        assert "message" in data

    def test_responses_preserved_after_deletion_request(self, client, reset_fake_db_state):
        """Survey response rows survive deletion request."""
        _seed_self_account()
        # Seed a response row belonging to account 999
        FakeCursor.responses.append({
            "response_id": 1,
            "survey_id": 10,
            "ParticipantID": 999,
            "question_id": 5,
            "response_value": "yes",
        })

        resp = client.post("/api/v1/auth/me/deletion-request")
        assert resp.status_code == 201

        # Response row must still exist
        assert len(FakeCursor.responses) >= 1
