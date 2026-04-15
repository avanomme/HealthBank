"""
Tests for cookie-based session management
"""

import pytest
from tests.mocks.db import FakeCursor
import hashlib


@pytest.fixture
def sample_account():
    """Valid account creation payload"""
    return {
        "email": "cookietest@example.com",
        "password": "StrongPassword123!",
        "first_name": "Cookie",
        "last_name": "Test"
    }


@pytest.fixture
def login_payload(sample_account):
    """Valid login payload"""
    return {
        "email": sample_account["email"],
        "password": sample_account["password"]
    }


def test_login_sets_cookie(client, sample_account, login_payload):
    """Should set session cookie on login and NOT expose token in response body"""
    client.post("/api/v1/auth/create_account", json=sample_account)

    response = client.post("/api/v1/auth/login", json=login_payload)

    assert response.status_code == 200
    assert "session_token" in response.cookies
    cookie = response.cookies.get("session_token")
    assert cookie is not None
    assert len(cookie) > 0
    # Token must not be exposed in the response body
    assert "session_token" not in response.json()


# ==============================
# GET /api/v1/sessions/validate
# ==============================

class TestValidateSession:
    def test_validate_with_valid_cookie(self, client, sample_account, login_payload):
        """Should validate session using a valid cookie set by login."""
        # Setup
        client.post("/api/v1/auth/create_account", json=sample_account)
        login_response = client.post("/api/v1/auth/login", json=login_payload)
        assert login_response.status_code == 200
        session_token = client.cookies.get("session_token")

        validate_response_explicit = client.post(
            "/api/v1/sessions/validate",
            cookies={"session_token": session_token}
        )
        assert validate_response_explicit.status_code == 200
        assert validate_response_explicit.json()["valid"] is True

    def test_validate_with_missing_cookie(self, client):
        """Should return 401 if no session cookie or token is provided."""
        response = client.post("/api/v1/sessions/validate")
        assert response.status_code == 401

    def test_validate_with_invalid_cookie(self, client, sample_account, login_payload):
        """Should return 401 if session cookie is invalid."""
        client.post("/api/v1/auth/create_account", json=sample_account)
        client.post("/api/v1/auth/login", json=login_payload)
        # Overwrite the session_token cookie with an invalid value
        client.cookies.set("session_token", "invalid-token")
        response = client.post("/api/v1/sessions/validate")
        assert response.status_code == 401