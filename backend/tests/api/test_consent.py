# Created with the Assistance of Claude Code
# backend/tests/api/test_consent.py
"""
Unit Tests for Consent API

Tests for /api/v1/consent/status and /api/v1/consent/submit endpoints.
"""
import pytest
from unittest.mock import patch, MagicMock
from fastapi import HTTPException


# =========================================================================
# GET /api/v1/consent/status
# =========================================================================

class TestConsentStatus:
    """Tests for GET /api/v1/consent/status"""

    def test_admin_always_has_consent(self, client):
        """Admin (RoleID=4) should always show has_signed_consent=True."""
        response = client.get("/api/v1/consent/status")
        assert response.status_code == 200
        data = response.json()
        assert data["has_signed_consent"] is True
        assert data["needs_consent"] is False

    def test_participant_no_consent_yet(self, client):
        """Participant without consent should show needs_consent=True."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_cursor.fetchone.return_value = {
                "ConsentSignedAt": None,
                "ConsentVersion": None,
            }

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                data = response.json()
                assert data["has_signed_consent"] is False
                assert data["needs_consent"] is True
                assert data["consent_version"] is None
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_participant_with_current_consent(self, client):
        """Participant with current consent version should show has_signed=True."""
        from app.api.deps import get_current_user
        from app.main import app
        from datetime import datetime

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_cursor.fetchone.return_value = {
                "ConsentSignedAt": datetime(2026, 2, 10, 12, 0, 0),
                "ConsentVersion": "1.0",
            }

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                data = response.json()
                assert data["has_signed_consent"] is True
                assert data["needs_consent"] is False
                assert data["consent_version"] == "1.0"
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_participant_with_old_version(self, client):
        """Participant with old consent version should show needs_consent=True."""
        from app.api.deps import get_current_user
        from app.main import app
        from datetime import datetime

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_cursor.fetchone.return_value = {
                "ConsentSignedAt": datetime(2026, 1, 1, 12, 0, 0),
                "ConsentVersion": "0.9",
            }

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                data = response.json()
                assert data["has_signed_consent"] is False
                assert data["needs_consent"] is True
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_status_unauthenticated(self, client):
        """Unauthenticated request should return 401."""
        from app.api.deps import get_current_user
        from app.main import app

        def raise_401():
            raise HTTPException(status_code=401, detail="Not authenticated")

        app.dependency_overrides[get_current_user] = raise_401
        try:
            response = client.get("/api/v1/consent/status")
            assert response.status_code == 401
        finally:
            app.dependency_overrides.pop(get_current_user, None)


# =========================================================================
# POST /api/v1/consent/submit
# =========================================================================

class TestConsentSubmit:
    """Tests for POST /api/v1/consent/submit"""

    def test_submit_consent_success(self, client):
        """Should create consent record and update AccountData."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.lastrowid = 42
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.post(
                    "/api/v1/consent/submit",
                    json={
                        "document_text": "I consent to participate in this study. " * 10,
                        "document_language": "en",
                        "signature_name": "Test User",
                    },
                )
                assert response.status_code == 201
                data = response.json()
                assert data["accepted"] is True
                assert data["consent_record_id"] == 42
                assert data["version"] == "1.0"
                # Verify two execute calls: INSERT + UPDATE
                assert mock_cursor.execute.call_count == 2
                mock_conn.commit.assert_called_once()
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_admin_cannot_submit_consent(self, client):
        """Admin should get 400 when trying to submit consent."""
        response = client.post(
            "/api/v1/consent/submit",
            json={
                "document_text": "Some text that is long enough for validation",
                "document_language": "en",
                "signature_name": "Admin User",
            },
        )
        assert response.status_code == 400
        assert "Admin" in response.json()["detail"]

    def test_submit_consent_french(self, client):
        """Should accept French language code."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "researcher@test.com",
            "role_id": 2,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.lastrowid = 43
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.post(
                    "/api/v1/consent/submit",
                    json={
                        "document_text": "Je consens à participer à cette étude. " * 10,
                        "document_language": "fr",
                        "signature_name": "Utilisateur Test",
                    },
                )
                assert response.status_code == 201
                data = response.json()
                assert data["accepted"] is True
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_submit_consent_invalid_language(self, client):
        """Should reject invalid language code."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        app.dependency_overrides[get_current_user] = lambda: mock_user
        try:
            response = client.post(
                "/api/v1/consent/submit",
                json={
                    "document_text": "Some text that is long enough for validation",
                    "document_language": "de",
                    "signature_name": "Test User",
                },
            )
            assert response.status_code == 422
        finally:
            app.dependency_overrides.pop(get_current_user, None)

    def test_submit_consent_empty_text(self, client):
        """Should reject document text that is too short."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        app.dependency_overrides[get_current_user] = lambda: mock_user
        try:
            response = client.post(
                "/api/v1/consent/submit",
                json={
                    "document_text": "short",
                    "document_language": "en",
                    "signature_name": "Test User",
                },
            )
            assert response.status_code == 422
        finally:
            app.dependency_overrides.pop(get_current_user, None)

    def test_submit_unauthenticated(self, client):
        """Should reject unauthenticated users."""
        from app.api.deps import get_current_user
        from app.main import app

        def raise_401():
            raise HTTPException(status_code=401, detail="Not authenticated")

        app.dependency_overrides[get_current_user] = raise_401
        try:
            response = client.post(
                "/api/v1/consent/submit",
                json={
                    "document_text": "Some long text for consent document",
                    "document_language": "en",
                    "signature_name": "Test User",
                },
            )
            assert response.status_code == 401
        finally:
            app.dependency_overrides.pop(get_current_user, None)

    def test_submit_captures_ip(self, client):
        """Should pass IP address from x-forwarded-for header."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "hcp@test.com",
            "role_id": 3,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.lastrowid = 44
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.post(
                    "/api/v1/consent/submit",
                    json={
                        "document_text": "I agree to the HCP confidentiality terms. " * 10,
                        "document_language": "en",
                        "signature_name": "Dr. Test HCP",
                    },
                    headers={"x-forwarded-for": "192.168.1.100"},
                )
                assert response.status_code == 201

                # Verify the INSERT call includes IP binary
                insert_call = mock_cursor.execute.call_args_list[0]
                insert_params = insert_call[0][1]
                # IP should be packed bytes for 192.168.1.100
                import ipaddress
                expected_ip = ipaddress.ip_address("192.168.1.100").packed
                assert insert_params[6] == expected_ip
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_submit_stores_document_text(self, client):
        """Should store the full document text in the INSERT."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        document_text = ("Full legal consent document text for audit purposes. " * 20).strip()

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.lastrowid = 45
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.post(
                    "/api/v1/consent/submit",
                    json={
                        "document_text": document_text,
                        "document_language": "en",
                        "signature_name": "Test Participant",
                    },
                )
                assert response.status_code == 201

                # Verify the INSERT call includes the full document text
                insert_call = mock_cursor.execute.call_args_list[0]
                insert_params = insert_call[0][1]
                assert insert_params[4] == document_text
            finally:
                app.dependency_overrides.pop(get_current_user, None)


# =========================================================================
# Additional coverage tests for missing lines
# =========================================================================

class TestConsentErrorPaths:
    """Cover lines 29, 164-166 in consent.py."""

    def test_ip_to_varbinary_invalid_ip(self):
        """Line 29: ip_to_varbinary returns None for invalid IP."""
        from app.api.v1.consent import ip_to_varbinary

        assert ip_to_varbinary(None) is None
        assert ip_to_varbinary("") is None
        assert ip_to_varbinary("not-an-ip") is None

    def test_submit_consent_mysql_error(self, client):
        """Lines 164-166: mysql.connector.Error -> 500 with rollback."""
        from app.api.deps import get_current_user
        from app.main import app
        import mysql.connector

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "tos_accepted_at": None,
            "tos_version": None,
        }

        with patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.execute.side_effect = mysql.connector.Error(msg="DB down")
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.post(
                    "/api/v1/consent/submit",
                    json={
                        "document_text": "I consent to participate in this study. " * 10,
                        "document_language": "en",
                        "signature_name": "Test User",
                    },
                )
                assert response.status_code == 500
                assert response.json()["detail"] == "Failed to record consent"
                mock_conn.rollback.assert_called_once()
            finally:
                app.dependency_overrides.pop(get_current_user, None)


# =========================================================================
# Consent Required Toggle tests
# =========================================================================

class TestConsentRequiredToggle:
    """Tests for the consent_required system setting effect on GET /consent/status."""

    _PARTICIPANT = {
        "account_id": 10,
        "email": "participant@test.com",
        "role_id": 1,
        "viewing_as_user_id": None,
        "tos_accepted_at": None,
        "tos_version": None,
    }

    def test_consent_not_required_unsigned_user_gets_no_consent_needed(self, client):
        """When consent_required=false, a participant who has never signed
        should get needs_consent=False without hitting the DB."""
        from app.api.deps import get_current_user
        from app.main import app

        with patch("app.api.v1.consent.get_bool_setting", return_value=False):
            app.dependency_overrides[get_current_user] = lambda: self._PARTICIPANT
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                data = response.json()
                assert data["needs_consent"] is False
                assert data["has_signed_consent"] is True
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_consent_not_required_does_not_open_db_connection(self, client):
        """When consent_required=false the DB should not be queried for consent."""
        from app.api.deps import get_current_user
        from app.main import app

        with patch("app.api.v1.consent.get_bool_setting", return_value=False), \
             patch("app.api.v1.consent.get_db_connection") as mock_db:
            app.dependency_overrides[get_current_user] = lambda: self._PARTICIPANT
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                mock_db.assert_not_called()
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_admin_still_exempt_when_consent_not_required(self, client):
        """Admin exemption runs before the setting check — admin path unchanged."""
        # mock_auth autouse fixture sets role_id=4 (admin) — consent_required=false
        # should not change the fact that admin returns needs_consent=False
        with patch("app.api.v1.consent.get_bool_setting", return_value=False):
            response = client.get("/api/v1/consent/status")
        assert response.status_code == 200
        data = response.json()
        assert data["needs_consent"] is False
        assert data["has_signed_consent"] is True

    def test_consent_required_true_preserves_existing_behaviour(self, client):
        """When consent_required=true (default), unsigned participant still needs consent."""
        from app.api.deps import get_current_user
        from app.main import app

        with patch("app.api.v1.consent.get_bool_setting", return_value=True), \
             patch("app.api.v1.consent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_cursor.fetchone.return_value = {"ConsentSignedAt": None, "ConsentVersion": None}

            app.dependency_overrides[get_current_user] = lambda: self._PARTICIPANT
            try:
                response = client.get("/api/v1/consent/status")
                assert response.status_code == 200
                data = response.json()
                assert data["needs_consent"] is True
                assert data["has_signed_consent"] is False
            finally:
                app.dependency_overrides.pop(get_current_user, None)
