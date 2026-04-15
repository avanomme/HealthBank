# Created with the Assistance of Claude Code
# backend/tests/api/test_hcp_links.py
"""
Tests for HCP-Patient Linking API

Endpoints tested:
- POST   /api/v1/hcp-links/request            - Request a link
- GET    /api/v1/hcp-links/                   - List my links
- PUT    /api/v1/hcp-links/{id}/respond       - Accept or reject a link
- DELETE /api/v1/hcp-links/{id}               - Remove a link
"""

import pytest
from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient


# ── Helpers ───────────────────────────────────────────────────────────────────

def make_conn(fetchone_result=None, fetchall_result=None, lastrowid=1):
    """Build a minimal mock DB connection whose cursor returns given data."""
    cursor = MagicMock()
    cursor.fetchone.return_value = fetchone_result
    cursor.fetchall.return_value = fetchall_result or []
    cursor.lastrowid = lastrowid
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn, cursor


def _override_user(role_id: int, account_id: int = 999):
    """Return a mock user dict for a given role."""
    return {
        "account_id": account_id,
        "email": "test@example.com",
        "tos_accepted_at": "2026-01-01",
        "tos_version": "1.0",
        "role_id": role_id,
        "viewing_as_user_id": None,
        "effective_account_id": account_id,
        "effective_role_id": role_id,
    }


# ── Fixtures ──────────────────────────────────────────────────────────────────

@pytest.fixture
def client():
    from app.main import app
    return TestClient(app)


@pytest.fixture
def hcp_user():
    return _override_user(role_id=3, account_id=10)


@pytest.fixture
def participant_user():
    return _override_user(role_id=1, account_id=2)


@pytest.fixture
def researcher_user():
    return _override_user(role_id=2, account_id=50)


# ── TestRequestLink ────────────────────────────────────────────────────────────

class TestRequestLink:
    """Tests for POST /api/v1/hcp-links/request"""

    def test_hcp_requests_link_by_email(self, client, hcp_user):
        """HCP can request a link to a participant by email — 202 silent."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(lastrowid=42)
        # fetchall returns one participant match; fetchone = no existing link
        cursor.fetchall.return_value = [(2,)]
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "patient@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert response.json()["detail"] == "Link request sent."

    def test_hcp_requests_link_by_name_silently_ignored(self, client, hcp_user):
        """Non-email query returns 202 silently (no match, email-only lookup)."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(lastrowid=43)
        # Email-only lookup will find no results for a name string
        cursor.fetchall.return_value = []
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "John Smith"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_participant_requests_link_to_hcp_by_email(self, client, participant_user):
        """Participant can request a link to an HCP by email — 202 silent."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(lastrowid=55)
        cursor.fetchall.return_value = [(10,)]
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "dr.williams@healthbank.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_target_not_found_returns_202_silently(self, client, hcp_user):
        """No match returns 202 (silent — participant privacy preserved)."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = []  # no match

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "unknown@nobody.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_ambiguous_name_returns_202_silently(self, client, hcp_user):
        """Multiple name matches returns 202 silently — HCP should use email."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = [(2,), (13,)]  # two people named "John"

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "John"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_duplicate_link_returns_202_silently(self, client, hcp_user):
        """Duplicate pending/active link returns 202 silently."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = [(2,)]
        cursor.fetchone.return_value = (7, "pending")

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "patient@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_rejected_link_can_be_re_requested(self, client, hcp_user):
        """A rejected link can be re-requested — updates to pending, returns 202."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = [(2,)]
        cursor.fetchone.return_value = (7, "rejected")

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "patient@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        # Verify the UPDATE was called (re-activate the link)
        execute_calls = [str(c) for c in cursor.execute.call_args_list]
        assert any("UPDATE" in c and "HcpPatientLink" in c for c in execute_calls)

    def test_email_lookup_uses_exact_match(self, client, hcp_user):
        """Email query (contains @) uses exact Email= match, not LIKE."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = []

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "patient@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        sql = cursor.execute.call_args[0][0]
        assert "Email" in sql
        assert "LIKE" not in sql

    def test_all_queries_use_email_lookup(self, client, hcp_user):
        """All queries (email or plain text) use exact Email= match — no LIKE."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = []

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "John Smith"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        sql = cursor.execute.call_args[0][0]
        assert "Email" in sql
        assert "LIKE" not in sql

    def test_researcher_cannot_create_link(self, client, researcher_user):
        """403 for researchers (not in allowed roles)."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "someone@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403


# ── TestListLinks ──────────────────────────────────────────────────────────────

class TestListLinks:
    """Tests for GET /api/v1/hcp-links/"""

    def _link_row(self, link_id=1, hcp_id=10, patient_id=2, status="active"):
        from datetime import datetime
        return {
            "link_id": link_id,
            "hcp_id": hcp_id,
            "patient_id": patient_id,
            "hcp_name": "Dr. Robert Williams",
            "patient_name": "Participant User",
            "status": status,
            "requested_by": "hcp",
            "requested_at": datetime(2026, 1, 1, 9, 0, 0),
            "updated_at": datetime(2026, 1, 2, 9, 0, 0),
        }

    def test_hcp_sees_their_patients(self, client, hcp_user):
        """HCP sees links where they are the HCP."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._link_row()])
        conn.cursor.return_value = cursor  # dict cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp-links/")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["hcp_id"] == 10

    def test_participant_sees_their_hcps(self, client, participant_user):
        """Participant sees links where they are the patient."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._link_row()])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp-links/")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_status_filter_passes_parameter(self, client, hcp_user):
        """Status filter query param is accepted."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._link_row(status="pending")])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp-links/?status=pending")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200

    def test_empty_list_when_no_links(self, client, hcp_user):
        """Returns empty list when there are no links."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp-links/")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []


# ── TestRespondToLink ──────────────────────────────────────────────────────────

class TestRespondToLink:
    """Tests for PUT /api/v1/hcp-links/{id}/respond"""

    def test_patient_accepts_hcp_request(self, client, participant_user):
        """Patient accepts a link that an HCP requested."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        link = {"LinkID": 1, "HcpID": 10, "PatientID": 2, "Status": "pending", "RequestedBy": "hcp"}
        # fetchone sequence: link, conversation check, patient email, hcp email
        cursor.fetchone.side_effect = [
            link,
            link,  # conversation exists (truthy) — skip creation
            {"Email": "patient@hb.com"},
            {"Email": "hcp@hb.com"},
        ]

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["status"] == "active"

    def test_patient_rejects_hcp_request(self, client, participant_user):
        """Patient rejects a link that an HCP requested."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
            "Status": "pending",
            "RequestedBy": "hcp",
        }

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "reject"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["status"] == "rejected"

    def test_hcp_accepts_patient_request(self, client, hcp_user):
        """HCP accepts a link that a patient requested."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        link = {"LinkID": 2, "HcpID": 10, "PatientID": 2, "Status": "pending", "RequestedBy": "patient"}
        cursor.fetchone.side_effect = [
            link,
            link,  # conversation exists (truthy) — skip creation
            {"Email": "patient@hb.com"},
            {"Email": "hcp@hb.com"},
        ]

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/2/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["status"] == "active"

    def test_requester_cannot_respond_to_own_request(self, client, hcp_user):
        """The HCP who requested cannot accept/reject the link themselves."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
            "Status": "pending",
            "RequestedBy": "hcp",  # HCP requested, so HCP cannot respond
        }

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_respond_to_missing_link_returns_404(self, client, participant_user):
        """404 when link doesn't exist."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/9999/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_respond_to_non_pending_link_returns_400(self, client, participant_user):
        """400 when link is already active (not pending)."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
            "Status": "active",
            "RequestedBy": "hcp",
        }

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 400

    def test_invalid_action_returns_400(self, client, participant_user):
        """400 for an action value other than accept/reject."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "banana"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 400


# ── TestRemoveLink ─────────────────────────────────────────────────────────────

class TestRemoveLink:
    """Tests for DELETE /api/v1/hcp-links/{id}"""

    def test_hcp_can_remove_their_link(self, client, hcp_user):
        """HCP can remove a link they are part of."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,   # matches hcp_user account_id
            "PatientID": 2,
        }

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/hcp-links/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 204

    def test_patient_can_remove_their_link(self, client, participant_user):
        """Participant can remove a link they are part of."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,   # matches participant_user account_id
        }

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/hcp-links/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 204

    def test_admin_can_remove_any_link(self, client):
        """Admin (role 4) can remove any link regardless of parties."""
        from app.main import app
        from app.api.deps import get_current_user

        admin_user = _override_user(role_id=4, account_id=1)
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
        }

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/hcp-links/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 204

    def test_remove_missing_link_returns_404(self, client, hcp_user):
        """404 when link does not exist."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/hcp-links/9999")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_unrelated_user_cannot_remove_link(self, client):
        """403 when caller is not a party to the link (and not admin)."""
        from app.main import app
        from app.api.deps import get_current_user

        unrelated_hcp = _override_user(role_id=3, account_id=99)  # not HcpID=10
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
        }

        app.dependency_overrides[get_current_user] = lambda: unrelated_hcp
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/hcp-links/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403


# ── TestRevokeConsent ──────────────────────────────────────────────────────────

class TestRevokeConsent:
    """Tests for POST /api/v1/hcp-links/{id}/revoke-consent"""

    def test_patient_can_revoke_consent(self, client, participant_user):
        """Patient can revoke consent for their own link."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "PatientID": 2,  # matches participant_user account_id
        }

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/revoke-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data["link_id"] == 1
        assert data["consent_revoked"] is True

    def test_admin_can_revoke_consent(self, client):
        """Admin can revoke consent on any link."""
        from app.main import app
        from app.api.deps import get_current_user

        admin_user = _override_user(role_id=4, account_id=999)
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 5,
            "PatientID": 2,
        }

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/5/revoke-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["consent_revoked"] is True

    def test_hcp_cannot_revoke_consent(self, client, hcp_user):
        """HCP (role 3) is not in allowed roles — gets 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/revoke-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_wrong_patient_cannot_revoke_consent(self, client):
        """Participant who is NOT the patient of the link gets 403."""
        from app.main import app
        from app.api.deps import get_current_user

        other_patient = _override_user(role_id=1, account_id=77)  # PatientID in DB is 2
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "PatientID": 2,  # different from caller (77)
        }

        app.dependency_overrides[get_current_user] = lambda: other_patient
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/revoke-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_revoke_missing_link_returns_404(self, client, participant_user):
        """404 when link does not exist."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/9999/revoke-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404


# ── TestRestoreConsent ─────────────────────────────────────────────────────────

class TestRestoreConsent:
    """Tests for POST /api/v1/hcp-links/{id}/restore-consent"""

    def test_patient_can_restore_consent(self, client, participant_user):
        """Patient can restore consent for their own link."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "PatientID": 2,  # matches participant_user account_id
        }

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/restore-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data["link_id"] == 1
        assert data["consent_revoked"] is False

    def test_admin_can_restore_consent(self, client):
        """Admin can restore consent on any link."""
        from app.main import app
        from app.api.deps import get_current_user

        admin_user = _override_user(role_id=4, account_id=999)
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 3,
            "PatientID": 2,
        }

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/3/restore-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["consent_revoked"] is False

    def test_hcp_cannot_restore_consent(self, client, hcp_user):
        """HCP (role 3) is not in allowed roles — gets 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/restore-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_wrong_patient_cannot_restore_consent(self, client):
        """Participant who is NOT the patient of the link gets 403."""
        from app.main import app
        from app.api.deps import get_current_user

        other_patient = _override_user(role_id=1, account_id=88)
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "PatientID": 2,  # different from caller (88)
        }

        app.dependency_overrides[get_current_user] = lambda: other_patient
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/1/restore-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_restore_missing_link_returns_404(self, client, participant_user):
        """404 when link does not exist."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post("/api/v1/hcp-links/9999/restore-consent")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404


# ── TestAdminRequestLink ─────────────────────────────────────────────────────

class TestAdminRequestLink:
    """Cover line 62: admin caller_role treated as participant for linking."""

    def test_admin_requests_link_to_hcp(self, client):
        """Admin (role 4) is treated as participant and can link to HCP — 202 silent."""
        from app.main import app
        from app.api.deps import get_current_user

        admin_user = _override_user(role_id=4, account_id=999)
        conn, cursor = make_conn(lastrowid=77)
        cursor.fetchall.return_value = [(10,)]  # one HCP found
        cursor.fetchone.return_value = None

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/hcp-links/request",
                    json={"query": "dr.williams@healthbank.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert response.json()["detail"] == "Link request sent."


# ── TestRespondToLinkPatientCantRespondToOwnRequest ──────────────────────────

class TestRespondToLinkExtra:
    """Cover line 213: patient who requested cannot respond to their own request."""

    def test_patient_cannot_respond_to_own_request(self, client):
        """Line 213: patient requested, HCP not is_hcp => 403."""
        from app.main import app
        from app.api.deps import get_current_user

        participant = _override_user(role_id=1, account_id=2)
        conn, cursor = make_conn()
        cursor.fetchone.return_value = {
            "LinkID": 1,
            "HcpID": 10,
            "PatientID": 2,
            "Status": "pending",
            "RequestedBy": "patient",  # patient requested, so patient cannot respond
        }

        app.dependency_overrides[get_current_user] = lambda: participant
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_accept_creates_conversation(self, client):
        """Lines 240-248: accepting creates a direct conversation."""
        from app.main import app
        from app.api.deps import get_current_user

        participant = _override_user(role_id=1, account_id=2)
        conn, cursor = make_conn()
        # fetchone sequence: link lookup, conversation check (None → create), patient email, hcp email
        cursor.fetchone.side_effect = [
            {
                "LinkID": 1,
                "HcpID": 10,
                "PatientID": 2,
                "Status": "pending",
                "RequestedBy": "hcp",
            },
            None,  # no existing conversation → triggers creation
            {"Email": "patient@hb.com"},
            {"Email": "hcp@hb.com"},
        ]
        cursor.lastrowid = 42

        app.dependency_overrides[get_current_user] = lambda: participant
        try:
            with patch("app.api.v1.hcp_links.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/hcp-links/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["status"] == "active"
        # Verify conversation was created (INSERT INTO Conversations called)
        execute_calls = [str(c) for c in cursor.execute.call_args_list]
        assert any("Conversations" in c for c in execute_calls)
