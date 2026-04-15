# backend/tests/api/test_account_requests.py
"""
Tests for the Account Request feature:
- Public POST /request_account endpoint
- Admin account request management endpoints
- Login must_change_password flag
- Change password clears the flag
"""
import pytest
from unittest.mock import patch, MagicMock
from tests.mocks.db import FakeCursor


class TestRequestAccount:
    """Tests for the public POST /api/v1/auth/request_account endpoint."""

    def test_submit_request_success(self, client):
        """Submit a valid account request."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Jane",
            "last_name": "Doe",
            "email": "jane@example.com",
            "role_id": 1,
            "birthdate": "1990-05-15",
            "gender": "Female",
        })
        assert resp.status_code == 201
        assert resp.json()["message"] == "Request submitted successfully"
        assert len(FakeCursor.account_requests) == 1

    def test_submit_request_researcher(self, client):
        """Researcher request (no birthdate/gender needed)."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Bob",
            "last_name": "Smith",
            "email": "bob@example.com",
            "role_id": 2,
        })
        assert resp.status_code == 201

    def test_submit_request_invalid_role(self, client):
        """Role must be 1-3 (not admin)."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Hacker",
            "last_name": "McHack",
            "email": "hack@example.com",
            "role_id": 4,
        })
        assert resp.status_code == 422

    def test_submit_request_invalid_gender(self, client):
        """Gender must be from the allowed set."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Test",
            "last_name": "User",
            "email": "test@example.com",
            "role_id": 1,
            "gender": "InvalidGender",
        })
        assert resp.status_code == 422

    def test_submit_request_duplicate_account_email(self, client):
        """Email already in AccountData."""
        # Create an account first
        client.post("/api/v1/auth/create_account", json={
            "first_name": "Existing",
            "last_name": "User",
            "email": "exists@example.com",
            "password": "password123",
        })
        # Try to request with same email
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "New",
            "last_name": "User",
            "email": "exists@example.com",
            "role_id": 1,
        })
        assert resp.status_code == 409
        assert "already exists" in resp.json()["detail"]

    def test_submit_request_duplicate_pending(self, client):
        """Email already has a pending request."""
        # Submit first request
        client.post("/api/v1/auth/request_account", json={
            "first_name": "Jane",
            "last_name": "Doe",
            "email": "jane@example.com",
            "role_id": 1,
        })
        # Try again with same email
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Jane",
            "last_name": "Doe",
            "email": "jane@example.com",
            "role_id": 2,
        })
        assert resp.status_code == 409
        assert "pending" in resp.json()["detail"]

    def test_submit_request_missing_required_fields(self, client):
        """Missing first_name should fail validation."""
        resp = client.post("/api/v1/auth/request_account", json={
            "last_name": "Doe",
            "email": "jane@example.com",
            "role_id": 1,
        })
        assert resp.status_code == 422

    def test_submit_request_invalid_email(self, client):
        """Invalid email format should fail validation."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Jane",
            "last_name": "Doe",
            "email": "not-an-email",
            "role_id": 1,
        })
        assert resp.status_code == 422

    def test_submit_request_gender_other(self, client):
        """Gender 'Other' with custom text."""
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Alex",
            "last_name": "Smith",
            "email": "alex@example.com",
            "role_id": 1,
            "gender": "Other",
            "gender_other": "Genderfluid",
        })
        assert resp.status_code == 201
        req = list(FakeCursor.account_requests.values())[0]
        assert req["Gender"] == "Other"
        assert req["GenderOther"] == "Genderfluid"


class TestAdminAccountRequests:
    """Tests for admin account request management endpoints."""

    def _seed_request(self, client):
        """Submit a request to seed data."""
        client.post("/api/v1/auth/request_account", json={
            "first_name": "Jane",
            "last_name": "Doe",
            "email": "jane@example.com",
            "role_id": 1,
            "gender": "Female",
        })

    def test_list_pending_requests(self, client):
        """List pending account requests."""
        self._seed_request(client)
        resp = client.get("/api/v1/admin/account-requests")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data) == 1
        assert data[0]["email"] == "jane@example.com"
        assert data[0]["status"] == "pending"

    def test_list_empty(self, client):
        """No requests returns empty list."""
        resp = client.get("/api/v1/admin/account-requests")
        assert resp.status_code == 200
        assert resp.json() == []

    def test_count_pending(self, client):
        """Count of pending requests."""
        self._seed_request(client)
        resp = client.get("/api/v1/admin/account-requests/count")
        assert resp.status_code == 200
        assert resp.json()["count"] == 1

    def test_count_zero(self, client):
        """Count is 0 when no pending requests."""
        resp = client.get("/api/v1/admin/account-requests/count")
        assert resp.status_code == 200
        assert resp.json()["count"] == 0

    @patch("app.api.v1.admin._email_service")
    def test_approve_request(self, mock_email_svc, client):
        """Approve creates account and sends email."""
        mock_email_svc.send_account_created_email.return_value = True

        self._seed_request(client)
        request_id = list(FakeCursor.account_requests.keys())[0]

        resp = client.post(f"/api/v1/admin/account-requests/{request_id}/approve")
        assert resp.status_code == 200
        data = resp.json()
        assert data["message"] == "Account request approved and account created."
        assert data["email"] == "jane@example.com"
        assert "account_id" in data

        # Request status updated
        assert FakeCursor.account_requests[request_id]["Status"] == "approved"

    def test_approve_nonexistent(self, client):
        """Approve non-existent request returns 404."""
        resp = client.post("/api/v1/admin/account-requests/9999/approve")
        assert resp.status_code == 404

    @patch("app.api.v1.admin._email_service")
    def test_approve_already_approved(self, mock_email_svc, client):
        """Cannot approve an already-approved request."""
        mock_email_svc.send_account_created_email.return_value = True

        self._seed_request(client)
        request_id = list(FakeCursor.account_requests.keys())[0]

        # Approve first time
        client.post(f"/api/v1/admin/account-requests/{request_id}/approve")

        # Try to approve again
        resp = client.post(f"/api/v1/admin/account-requests/{request_id}/approve")
        assert resp.status_code == 400
        assert "already" in resp.json()["detail"]

    def test_reject_request(self, client):
        """Reject with admin notes."""
        self._seed_request(client)
        request_id = list(FakeCursor.account_requests.keys())[0]

        resp = client.post(
            f"/api/v1/admin/account-requests/{request_id}/reject",
            json={"admin_notes": "Insufficient credentials"},
        )
        assert resp.status_code == 200
        assert FakeCursor.account_requests[request_id]["Status"] == "rejected"

    def test_reject_no_notes(self, client):
        """Reject without notes."""
        self._seed_request(client)
        request_id = list(FakeCursor.account_requests.keys())[0]

        resp = client.post(f"/api/v1/admin/account-requests/{request_id}/reject")
        assert resp.status_code == 200

    def test_reject_nonexistent(self, client):
        """Reject non-existent request returns 404."""
        resp = client.post("/api/v1/admin/account-requests/9999/reject")
        assert resp.status_code == 404


class TestLoginMustChangePassword:
    """Tests for must_change_password flag in login response."""

    def test_login_returns_must_change_false(self, client):
        """Normal login returns must_change_password=false."""
        # Create account
        client.post("/api/v1/auth/create_account", json={
            "first_name": "Test",
            "last_name": "User",
            "email": "test@example.com",
            "password": "password123",
        })
        # Login
        resp = client.post("/api/v1/auth/login", json={
            "email": "test@example.com",
            "password": "password123",
        })
        assert resp.status_code == 200
        assert resp.json()["must_change_password"] is False

    def test_login_returns_must_change_true(self, client):
        """Login with temp password returns must_change_password=true."""
        # Create account and set must_change_password
        client.post("/api/v1/auth/create_account", json={
            "first_name": "Temp",
            "last_name": "User",
            "email": "temp@example.com",
            "password": "temppass123",
        })
        # Manually set the flag
        FakeCursor.accounts["temp@example.com"]["must_change_password"] = True

        resp = client.post("/api/v1/auth/login", json={
            "email": "temp@example.com",
            "password": "temppass123",
        })
        assert resp.status_code == 200
        assert resp.json()["must_change_password"] is True
