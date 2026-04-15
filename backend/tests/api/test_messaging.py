# Created with the Assistance of Claude Code
# backend/tests/api/test_messaging.py
"""
Tests for Messaging System API

Endpoints tested:
- POST /api/v1/messages/conversations              - Start/retrieve conversation
- GET  /api/v1/messages/conversations              - List conversations
- GET  /api/v1/messages/conversations/{id}/messages  - Get messages in conversation
- POST /api/v1/messages/conversations/{id}/messages  - Send message
- POST /api/v1/messages/friend-request             - Send friend request (privacy-preserving)
- GET  /api/v1/messages/friends                    - List accepted friends
- GET  /api/v1/messages/researchers/search         - Search researchers by name
- GET  /api/v1/messages/friend-requests/incoming   - Incoming pending requests
- PUT  /api/v1/messages/friend-requests/{id}/respond - Accept/reject friend request
"""

import pytest
from datetime import datetime
from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient


# ── Helpers ───────────────────────────────────────────────────────────────────

def make_conn(fetchone_result=None, fetchall_result=None):
    """Build a minimal mock DB connection whose cursor returns preset results."""
    cursor = MagicMock()
    cursor.fetchone.return_value = fetchone_result
    cursor.fetchall.return_value = fetchall_result or []
    cursor.lastrowid = 1
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
def admin_user():
    return _override_user(role_id=4, account_id=999)


@pytest.fixture
def hcp_user():
    return _override_user(role_id=3, account_id=10)


@pytest.fixture
def participant_user():
    return _override_user(role_id=1, account_id=2)


@pytest.fixture
def researcher_user():
    return _override_user(role_id=2, account_id=4)


@pytest.fixture
def researcher_user2():
    return _override_user(role_id=2, account_id=5)


# ── TestCreateConversation ─────────────────────────────────────────────────────

class TestCreateConversation:
    """Tests for POST /api/v1/messages/conversations"""

    def test_admin_can_start_conversation_with_anyone(self, client, admin_user):
        """Admin can start a conversation with any active account."""
        from app.main import app
        from app.api.deps import get_current_user

        # Two fetchone calls: target existence check, then _can_message returns True (admin)
        # Plus _get_or_create_conversation (no existing conv)
        cursor = MagicMock()
        cursor.lastrowid = 42
        # Call sequence: exists check -> (1,) ; existing conv -> None
        cursor.fetchone.side_effect = [(1,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 2},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201
        data = response.json()
        assert "conv_id" in data
        assert "created" in data

    def test_hcp_can_message_linked_consented_patient(self, client, hcp_user):
        """HCP with an active, non-revoked link can start a conversation with patient."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.lastrowid = 7
        # target exists, link exists, no existing conv
        cursor.fetchone.side_effect = [(2,), (1,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 2},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201

    def test_hcp_cannot_message_unlinked_patient(self, client, hcp_user):
        """403 when HCP tries to message a patient with no active link."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # target exists, no link found
        cursor.fetchone.side_effect = [(99,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 99},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_participant_can_message_their_hcp(self, client, participant_user):
        """Participant can message their HCP via an active, consented link."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.lastrowid = 8
        # target exists, link (patient→hcp) exists, no existing conv
        cursor.fetchone.side_effect = [(10,), (1,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 10},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201

    def test_participant_cannot_message_unrelated_user(self, client, participant_user):
        """403 when participant tries to message someone they have no link or friendship with."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # target exists, no hcp link, no friend request
        cursor.fetchone.side_effect = [(50,), None, None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 50},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_researcher_can_message_another_researcher(self, client, researcher_user):
        """Researcher can message another researcher."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.lastrowid = 9
        # target exists (any), researcher check finds researcher, no existing conv
        cursor.fetchone.side_effect = [(5,), (5,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 5},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201

    def test_researcher_cannot_message_participant(self, client, researcher_user):
        """403 when researcher tries to message a participant."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # target exists (participant), researcher check returns None (not a researcher)
        cursor.fetchone.side_effect = [(2,), None]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 2},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_returns_existing_conv_id_when_conversation_already_exists(self, client, admin_user):
        """When a conversation already exists, returns existing conv_id with created=False."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # target exists, existing conv found
        cursor.fetchone.side_effect = [(1,), (5,)]  # 5 is existing conv_id
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 2},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201
        data = response.json()
        assert data["conv_id"] == 5
        assert data["created"] is False

    def test_404_if_target_does_not_exist(self, client, admin_user):
        """404 when target account does not exist or is inactive."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = None  # target not found
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 9999},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_400_if_target_is_self(self, client, admin_user):
        """400 when caller tries to start a conversation with themselves."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_account_id": 999},  # same as admin_user account_id
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 400

    def test_create_conversation_by_email(self, client, admin_user):
        """Admin can create a conversation by supplying target_email."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        # First fetchone: email lookup → returns account 42
        # Second fetchone: existing conversation check → no existing conv
        cursor.fetchone.side_effect = [(42,), None]
        cursor.fetchall.return_value = []
        cursor.lastrowid = 50

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_email": "patient@example.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201

    def test_create_conversation_email_not_found(self, client, admin_user):
        """404 when target_email does not match any active account."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None  # email lookup fails

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations",
                    json={"target_email": "nobody@example.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_400_if_neither_id_nor_email(self, client, admin_user):
        """400 when neither target_account_id nor target_email is provided."""
        from app.main import app
        from app.api.deps import get_current_user

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            response = client.post(
                "/api/v1/messages/conversations",
                json={},
            )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 400


# ── TestListConversations ──────────────────────────────────────────────────────

class TestListConversations:
    """Tests for GET /api/v1/messages/conversations"""

    def _conv_row(self, conv_id=1, other_id=10, other_name="Dr. Williams",
                  last_message="Hello", last_message_at=None):
        return {
            "conv_id": conv_id,
            "other_participant_id": other_id,
            "other_participant_name": other_name,
            "last_message": last_message,
            "last_message_at": last_message_at or datetime(2026, 1, 1, 9, 0, 0),
        }

    def test_returns_conversations_for_current_user(self, client, participant_user):
        """Returns list of conversations the caller participates in."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._conv_row()])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["conv_id"] == 1
        assert data[0]["other_participant_id"] == 10

    def test_includes_last_message_preview(self, client, participant_user):
        """Each conversation row includes last_message and last_message_at."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[
            self._conv_row(last_message="See you tomorrow")
        ])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data[0]["last_message"] == "See you tomorrow"

    def test_empty_list_if_no_conversations(self, client, participant_user):
        """Returns empty list when caller has no conversations."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_401_without_auth(self, client):
        """Unauthenticated requests return 401."""
        from app.main import app
        from app.api.deps import get_current_user

        # Remove auth override so real auth runs
        app.dependency_overrides.pop(get_current_user, None)
        try:
            response = client.get("/api/v1/messages/conversations")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 401


# ── TestGetMessages ────────────────────────────────────────────────────────────

class TestGetMessages:
    """Tests for GET /api/v1/messages/conversations/{conv_id}/messages"""

    def _msg_row(self, message_id=1, sender_id=10, sender_name="Dr. Williams",
                 body="Hello", sent_at=None):
        return {
            "message_id": message_id,
            "sender_id": sender_id,
            "sender_name": sender_name,
            "body": body,
            "sent_at": sent_at or datetime(2026, 1, 1, 9, 0, 0),
        }

    def test_returns_messages_in_conversation_for_participant(self, client, participant_user):
        """Caller who is a participant gets the messages."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # participant check -> row found; messages -> list
        cursor.fetchone.return_value = {"ConvID": 1}
        cursor.fetchall.return_value = [
            self._msg_row(message_id=1, body="Hello"),
            self._msg_row(message_id=2, sender_id=2, sender_name="Participant User",
                          body="Thank you"),
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations/1/messages")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 2

    def test_403_if_caller_not_in_conversation(self, client, participant_user):
        """403 when caller is not a participant of the conversation."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = None  # not a participant
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations/99/messages")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_empty_list_if_no_messages(self, client, participant_user):
        """Returns empty list when conversation has no messages yet."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = {"ConvID": 1}
        cursor.fetchall.return_value = []
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations/1/messages")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_messages_have_required_fields(self, client, participant_user):
        """Each message has message_id, sender_id, sender_name, body, sent_at."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = {"ConvID": 1}
        cursor.fetchall.return_value = [self._msg_row()]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/conversations/1/messages")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        msg = response.json()[0]
        assert "message_id" in msg
        assert "sender_id" in msg
        assert "sender_name" in msg
        assert "body" in msg
        assert "sent_at" in msg


# ── TestSendMessage ────────────────────────────────────────────────────────────

class TestSendMessage:
    """Tests for POST /api/v1/messages/conversations/{conv_id}/messages"""

    def test_participant_in_conversation_can_send_message(self, client, participant_user):
        """Participant who is in the conversation can send a message."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.lastrowid = 99
        cursor.fetchone.side_effect = [
            {"ConvID": 1},                  # participant check
            (datetime(2026, 1, 1, 10, 0),), # SentAt fetch
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations/1/messages",
                    json={"body": "Hello Doctor!"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201
        data = response.json()
        assert "message_id" in data
        assert "sent_at" in data

    def test_403_if_caller_not_in_conversation(self, client, participant_user):
        """403 when caller tries to send a message to a conversation they are not in."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = None  # not a participant
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations/99/messages",
                    json={"body": "sneaky message"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_body_is_sanitized(self, client, participant_user):
        """Message body is sanitized — control characters and null bytes are removed.

        Note: sanitized_string() removes control chars / null bytes for DB safety.
        It does not strip HTML tags (that is a separate responsibility).
        Confirms that the body reaches the INSERT call after passing through
        the sanitizer (valid string passes through unchanged).
        """
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.lastrowid = 100
        cursor.fetchone.side_effect = [
            {"ConvID": 1},
            (datetime(2026, 1, 1, 10, 0),),
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                # Body with a null byte — sanitizer must strip it
                response = client.post(
                    "/api/v1/messages/conversations/1/messages",
                    json={"body": "Hello\x00Doctor"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        # Should succeed — sanitizer passes valid-enough string through
        assert response.status_code == 201
        # Verify the cursor.execute was called and body reached INSERT
        call_args = cursor.execute.call_args_list
        insert_call = next(
            (c for c in call_args if "INSERT INTO Messages" in str(c)),
            None,
        )
        assert insert_call is not None
        body_passed = insert_call[0][1][2]  # third param is the body
        # Null byte must have been removed by sanitizer
        assert "\x00" not in body_passed

    def test_returns_message_id_and_sent_at(self, client, participant_user):
        """Response includes message_id and sent_at."""
        from app.main import app
        from app.api.deps import get_current_user

        sent_time = datetime(2026, 2, 24, 14, 30, 0)
        cursor = MagicMock()
        cursor.lastrowid = 55
        cursor.fetchone.side_effect = [
            {"ConvID": 1},
            (sent_time,),
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/conversations/1/messages",
                    json={"body": "Test message"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 201
        data = response.json()
        assert data["message_id"] == 55


# ── TestFriendRequest ──────────────────────────────────────────────────────────

class TestFriendRequest:
    """Tests for POST /api/v1/messages/friend-request"""

    _EXPECTED_MSG = "If this user exists, a contact request will be sent."

    def test_always_returns_202_for_existing_email(self, client, participant_user):
        """Returns 202 with standard message when target email exists."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = (13,)  # target found
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request",
                    json={"email": "john.smith@email.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert response.json()["detail"] == self._EXPECTED_MSG

    def test_always_returns_202_for_nonexistent_email(self, client, participant_user):
        """Returns 202 with same message when target email does NOT exist."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = None  # no match
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request",
                    json={"email": "nobody@nowhere.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert response.json()["detail"] == self._EXPECTED_MSG

    def test_always_returns_202_for_self_request(self, client, participant_user):
        """Returns same 202 when requester sends to their own email (silently skipped)."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # Returns the caller's own account_id (2 == participant_user.account_id)
        cursor.fetchone.return_value = (2,)
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request",
                    json={"email": "part@hb.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert response.json()["detail"] == self._EXPECTED_MSG

    def test_401_without_auth(self, client):
        """Unauthenticated request returns 401."""
        from app.main import app
        from app.api.deps import get_current_user

        app.dependency_overrides.pop(get_current_user, None)
        try:
            response = client.post(
                "/api/v1/messages/friend-request",
                json={"email": "test@example.com"},
            )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 401

    def test_researcher_can_send_contact_request(self, client, researcher_user):
        """Researcher (role 2) can send contact requests — 202 silent response."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchone_result=None)
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request",
                    json={"email": "someone@example.com"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202


# ── TestFriendsList ────────────────────────────────────────────────────────────

class TestFriendsList:
    """Tests for GET /api/v1/messages/friends"""

    def _friend_row(self, account_id=13, display_name="John Smith"):
        return {"account_id": account_id, "display_name": display_name}

    def test_returns_accepted_friends(self, client, participant_user):
        """Returns list of accepted friends."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._friend_row()])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["account_id"] == 13

    def test_empty_list_if_no_friends(self, client, participant_user):
        """Returns empty list when caller has no accepted friends."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_pending_requests_not_in_list(self, client, participant_user):
        """Pending friend requests do not appear in the friends list."""
        from app.main import app
        from app.api.deps import get_current_user

        # DB only returns rows with Status='accepted', so pending requests won't appear
        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_researcher_contacts_use_friend_requests(self, client, researcher_user):
        """Researcher contacts come from FriendRequests — not auto-listing all researchers."""
        from app.main import app
        from app.api.deps import get_current_user

        rows = [
            {"account_id": 10, "display_name": "Alice Lab", "role_name": "Researcher", "email": "alice@hb.com"},
            {"account_id": 11, "display_name": "Bob Research", "role_name": "Researcher", "email": "bob@hb.com"},
        ]
        conn, cursor = make_conn(fetchall_result=rows)
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["account_id"] == 10
        assert data[1]["display_name"] == "Bob Research"

        # Verify it uses FriendRequests join (not auto-list by RoleID)
        sql = cursor.execute.call_args[0][0]
        assert "FriendRequests" in sql
        assert "RoleID = 2" not in sql

    def test_friends_list_passes_caller_id_four_times(self, client, researcher_user):
        """Unified FriendRequests query passes caller_id four times as parameters."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        # Caller ID (4) passed four times for the bidirectional FriendRequests query
        params = cursor.execute.call_args[0][1]
        assert params == (4, 4, 4, 4)

    def test_hcp_gets_empty_contacts(self, client, hcp_user):
        """HCP caller with no FriendRequests gets empty contact list."""
        from app.main import app
        from app.api.deps import get_current_user

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            response = client.get("/api/v1/messages/friends")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []


# ── TestResearcherSearch ───────────────────────────────────────────────────────

class TestResearcherSearch:
    """Tests for GET /api/v1/messages/researchers/search"""

    def _researcher_row(self, account_id=5, display_name="Sarah Chen"):
        return {"account_id": account_id, "display_name": display_name}

    def test_researcher_can_search_other_researchers(self, client, researcher_user):
        """Researcher can search by name and see results."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._researcher_row()])
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers/search?q=Sa")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert data[0]["account_id"] == 5

    def test_returns_display_name_not_email(self, client, researcher_user):
        """Search results include display_name but no email field."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._researcher_row()])
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers/search?q=Sa")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        result = response.json()[0]
        assert "display_name" in result
        assert "email" not in result

    def test_participant_cannot_search(self, client, participant_user):
        """Participant (role 1) cannot access researcher search — 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers/search?q=Sa")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_returns_empty_list_for_no_matches(self, client, researcher_user):
        """Returns empty list when no researchers match the query."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers/search?q=zz")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_requires_min_2_chars(self, client, researcher_user):
        """Query string shorter than 2 characters returns a 422 validation error."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers/search?q=a")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 422


# ── TestIncomingFriendRequests ─────────────────────────────────────────────────

class TestIncomingFriendRequests:
    """Tests for GET /api/v1/messages/friend-requests/incoming"""

    def _request_row(self, request_id=1, requester_id=13, requester_name="John Smith"):
        return {
            "request_id": request_id,
            "requester_id": requester_id,
            "requester_name": requester_name,
            "requested_at": datetime(2026, 2, 1, 9, 0, 0),
        }

    def test_returns_pending_incoming_requests(self, client, participant_user):
        """Returns pending requests where the caller is the target."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._request_row()])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friend-requests/incoming")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["requester_id"] == 13

    def test_returns_empty_list_if_none(self, client, participant_user):
        """Returns empty list when no pending incoming requests exist."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/friend-requests/incoming")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []


# ── TestFriendRequestRespond ───────────────────────────────────────────────────

class TestFriendRequestRespond:
    """Tests for PUT /api/v1/messages/friend-requests/{request_id}/respond"""

    def test_target_can_accept_friend_request(self, client, participant_user):
        """TargetAccountID can accept a pending friend request."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # Row: (RequestID, TargetAccountID, Status)
        cursor.fetchone.return_value = (1, 2, "pending")  # TargetAccountID=2 == participant_user
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "accepted"

    def test_target_can_reject_friend_request(self, client, participant_user):
        """TargetAccountID can reject a pending friend request."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = (1, 2, "pending")
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/1/respond",
                    json={"action": "reject"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "rejected"

    def test_non_target_cannot_respond(self, client, participant_user):
        """403 when someone who is not the TargetAccountID tries to respond."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # TargetAccountID=50 != participant_user account_id(2)
        cursor.fetchone.return_value = (1, 50, "pending")
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_404_for_missing_request(self, client, participant_user):
        """404 when the friend request does not exist."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        cursor.fetchone.return_value = None
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/9999/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_400_for_invalid_action(self, client, participant_user):
        """400 when action is not 'accept' or 'reject'."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/1/respond",
                    json={"action": "maybe"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 400

    def test_admin_can_respond_on_behalf_of_target(self, client, admin_user):
        """Admin can accept/reject a friend request regardless of TargetAccountID."""
        from app.main import app
        from app.api.deps import get_current_user

        cursor = MagicMock()
        # TargetAccountID=50 (not admin), but admin bypasses check
        cursor.fetchone.return_value = (1, 50, "pending")
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.put(
                    "/api/v1/messages/friend-requests/1/respond",
                    json={"action": "accept"},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["status"] == "accepted"


# ── TestCanMessageFallback ─────────────────────────────────────────────────

class TestCanMessageFallback:
    """Cover line 112: _can_message returns False for unknown role."""

    def test_can_message_unknown_role_returns_false(self):
        """Line 112: role not in (1,2,3,4) returns False."""
        from app.api.v1.messaging import _can_message
        cursor = MagicMock()
        result = _can_message(1, 99, 2, cursor)
        assert result is False


# ── TestIncomingFriendRequestsHcp ─────────────────────────────────────────

class TestIncomingFriendRequestsNonParticipant:
    """Cover line 490: HCP/researcher gets empty list for incoming friend requests."""

    def test_hcp_gets_empty_friend_requests(self, client):
        """Line 490: HCP (role 3) returns [] for incoming friend requests."""
        from app.main import app
        from app.api.deps import get_current_user

        hcp_user = _override_user(role_id=3, account_id=10)
        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            response = client.get("/api/v1/messages/friend-requests/incoming")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []


# ── TestRespondFriendRequestNotPending ────────────────────────────────────

class TestRespondFriendRequestNotPending:
    """Cover line 551: responding to non-pending request returns 400."""

    @patch("app.api.v1.messaging.get_db_connection")
    def test_respond_to_non_pending_returns_400(self, mock_db, client):
        """Line 551: request not in pending status returns 400."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        # Return a request that's already accepted
        cursor.fetchone.return_value = (1, 999, "accepted")
        mock_db.return_value = conn

        response = client.put(
            "/api/v1/messages/friend-requests/1/respond",
            json={"action": "accept"},
        )

        assert response.status_code == 400
        assert "not pending" in response.json()["detail"].lower()


# ── TestDeleteMessage ──────────────────────────────────────────────────────────

class TestDeleteMessage:
    """Tests for DELETE /api/v1/messages/conversations/{conv_id}/messages/{message_id}"""

    def test_sender_can_delete_own_message(self, client, participant_user):
        """Message sender (role 1) can delete their own message."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = {"MessageID": 1, "SenderID": 2}  # matches participant_user
        cursor2 = MagicMock()
        conn = MagicMock()
        conn.cursor.side_effect = [cursor, cursor2]

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/messages/conversations/1/messages/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["deleted"] == 1

    def test_cannot_delete_others_message(self, client, participant_user):
        """Non-admin cannot delete a message sent by someone else — 403."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = {"MessageID": 5, "SenderID": 99}  # different sender
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/messages/conversations/1/messages/5")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_message_not_found_returns_404(self, client, participant_user):
        """Returns 404 when message does not exist in the conversation."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = None
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/messages/conversations/1/messages/999")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404


# ── TestDeleteContact ──────────────────────────────────────────────────────────

class TestDeleteContact:
    """Tests for DELETE /api/v1/messages/contacts/{contact_id}"""

    def test_participant_can_delete_contact(self, client, participant_user):
        """Any authenticated user can remove a contact."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.delete("/api/v1/messages/contacts/10")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json()["deleted"] == 10

    def test_delete_contact_passes_correct_params(self, client, participant_user):
        """Bidirectional delete passes caller_id and contact_id in correct order."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                client.delete("/api/v1/messages/contacts/10")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        params = cursor.execute.call_args[0][1]
        # caller=2 (participant_user), contact=10
        assert params == (2, 10, 10, 2)


# ── TestDirectFriendRequest ───────────────────────────────────────────────────

class TestDirectFriendRequest:
    """Tests for POST /api/v1/messages/friend-request/direct (researcher/admin only)."""

    def test_researcher_can_send_direct_request(self, client, researcher_user):
        """Researcher can send a direct request to an existing active user."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = {"Email": "target@example.com"}
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request/direct",
                    json={"target_account_id": 99},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        assert "contact request" in response.json()["detail"].lower()

    def test_admin_can_send_direct_request(self, client, admin_user):
        """Admin can also send a direct friend request."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = {"Email": "someone@example.com"}
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request/direct",
                    json={"target_account_id": 50},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_participant_is_denied(self, client, participant_user):
        """Participant (role 1) cannot use the direct request endpoint."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        conn = MagicMock()
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request/direct",
                    json={"target_account_id": 10},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_self_request_returns_silent_202(self, client, researcher_user):
        """Sending a request to yourself returns 202 silently (no DB hit)."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        conn = MagicMock()
        conn.cursor.return_value = MagicMock()

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request/direct",
                    json={"target_account_id": researcher_user["account_id"]},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202

    def test_nonexistent_target_returns_silent_202(self, client, researcher_user):
        """Target not found in DB still returns 202 (privacy-preserving)."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchone.return_value = None  # target does not exist
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.post(
                    "/api/v1/messages/friend-request/direct",
                    json={"target_account_id": 9999},
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 202
        # No INSERT executed when target not found
        insert_calls = [
            c for c in cursor.execute.call_args_list
            if "INSERT" in str(c)
        ]
        assert len(insert_calls) == 0


# ── TestListResearchers ───────────────────────────────────────────────────────

class TestListResearchers:
    """Tests for GET /api/v1/messages/researchers (list with optional name filter)."""

    def test_returns_researcher_list(self, client, researcher_user):
        """Researcher gets list of other active researchers."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchall.return_value = [
            {"account_id": 10, "display_name": "Alice Smith"},
            {"account_id": 11, "display_name": "Bob Jones"},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["display_name"] == "Alice Smith"

    def test_filter_by_name(self, client, researcher_user):
        """Optional ?q= filter is applied when provided."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchall.return_value = [{"account_id": 10, "display_name": "Alice Smith"}]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers?q=Alice")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        # Confirm LIKE query was used (has 3 params: caller_id, like, like)
        call_args = cursor.execute.call_args[0]
        assert "LIKE" in call_args[0]
        assert "%Alice%" in call_args[1]

    def test_empty_result_returns_empty_list(self, client, researcher_user):
        """Returns empty list when no researchers match."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchall.return_value = []
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: researcher_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_participant_is_denied(self, client, participant_user):
        """Participant (role 1) cannot list researchers."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        conn = MagicMock()
        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_admin_can_list_researchers(self, client, admin_user):
        """Admin (role 4) can also list researchers."""
        from app.main import app
        from app.api.deps import get_current_user
        from unittest.mock import MagicMock

        cursor = MagicMock()
        cursor.fetchall.return_value = [{"account_id": 5, "display_name": "Dr. Test"}]
        conn = MagicMock()
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.messaging.get_db_connection", return_value=conn):
                response = client.get("/api/v1/messages/researchers")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
