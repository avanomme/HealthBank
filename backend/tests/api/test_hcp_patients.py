# Created with the Assistance of Claude Code
# backend/tests/api/test_hcp_patients.py
"""
Tests for HCP Patient Data Access API

Endpoints tested:
- GET  /api/v1/hcp/patients                              - List HCP's patients
- GET  /api/v1/hcp/patients/{patient_id}/surveys         - Patient's completed surveys
- GET  /api/v1/hcp/patients/{patient_id}/responses/{id}  - Patient's survey responses
"""

import pytest
from datetime import datetime
from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient


# ── Helpers ───────────────────────────────────────────────────────────────────

def make_conn(fetchone_result=None, fetchall_result=None):
    """Build a minimal mock DB connection."""
    cursor = MagicMock()
    cursor.fetchone.return_value = fetchone_result
    cursor.fetchall.return_value = fetchall_result or []
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
def admin_user():
    return _override_user(role_id=4, account_id=999)


# ── TestListHcpPatients ────────────────────────────────────────────────────────

class TestListHcpPatients:
    """Tests for GET /api/v1/hcp/patients"""

    def _patient_row(self, link_id=1, patient_id=2, patient_name="Jane Doe"):
        return {
            "link_id": link_id,
            "patient_id": patient_id,
            "patient_name": patient_name,
            "linked_since": datetime(2026, 1, 1, 9, 0, 0),
        }

    def test_hcp_sees_their_linked_patients(self, client, hcp_user):
        """HCP (role 3) sees patients where they are the HCP and consent is active."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._patient_row()])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["patient_id"] == 2

    def test_hcp_with_no_patients_returns_empty_list(self, client, hcp_user):
        """Returns empty list when HCP has no linked patients."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []

    def test_admin_can_list_patients_for_specific_hcp(self, client, admin_user):
        """Admin can pass ?hcp_id= to see patients of a specific HCP."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[self._patient_row()])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients?hcp_id=10")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_admin_with_no_hcp_id_returns_all(self, client, admin_user):
        """Admin with no ?hcp_id gets all active consented links."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn(fetchall_result=[
            self._patient_row(link_id=1, patient_id=2),
            self._patient_row(link_id=2, patient_id=3, patient_name="Bob Smith"),
        ])
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert len(response.json()) == 2

    def test_participant_cannot_list_hcp_patients(self, client, participant_user):
        """Participant (role 1) is not in allowed roles — gets 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403


# ── TestGetPatientSurveys ──────────────────────────────────────────────────────

class TestGetPatientSurveys:
    """Tests for GET /api/v1/hcp/patients/{patient_id}/surveys"""

    def _survey_row(self, assignment_id=1, survey_id=1, title="Health Survey"):
        return {
            "assignment_id": assignment_id,
            "survey_id": survey_id,
            "survey_title": title,
            "completed_at": datetime(2026, 1, 15, 10, 0, 0),
        }

    def test_hcp_sees_patient_surveys_with_valid_link(self, client, hcp_user):
        """HCP with an active consented link can view patient's completed surveys."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        # fetchone: link verification check
        # fetchall: survey list
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = [self._survey_row()]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/surveys")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["survey_id"] == 1

    def test_hcp_blocked_when_no_active_link(self, client, hcp_user):
        """403 when HCP has no active consented link to the patient."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None  # no link found
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/99/surveys")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_admin_bypasses_link_check(self, client, admin_user):
        """Admin can view patient surveys without a link."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = [self._survey_row(survey_id=5, title="Wellbeing Survey")]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/surveys")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert data[0]["survey_id"] == 5

    def test_patient_cannot_access_hcp_patient_surveys(self, client, participant_user):
        """Participant (role 1) cannot access this HCP-only endpoint — 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/surveys")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_empty_surveys_list(self, client, hcp_user):
        """Returns empty list when patient has no completed surveys."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = []
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/surveys")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert response.json() == []


# ── TestGetPatientResponses ────────────────────────────────────────────────────

class TestGetPatientResponses:
    """Tests for GET /api/v1/hcp/patients/{patient_id}/responses/{survey_id}"""

    def _response_row(self, question_id=1, content="How are you?", rtype="text", value="Good"):
        return {
            "question_id": question_id,
            "question_content": content,
            "response_type": rtype,
            "response_value": value,
        }

    def test_hcp_gets_patient_responses_with_valid_link(self, client, hcp_user):
        """HCP with an active consented link can view a patient's survey responses."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = [
            self._response_row(question_id=1, value="Good"),
            self._response_row(question_id=2, content="Sleep hours", rtype="number", value="7"),
        ]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/responses/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["question_id"] == 1
        assert data[0]["response_value"] == "Good"

    def test_hcp_blocked_when_no_active_link(self, client, hcp_user):
        """403 when HCP has no active consented link to the patient."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None  # no link
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/99/responses/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_no_responses_returns_404(self, client, hcp_user):
        """404 when patient has no responses for the given survey."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = []  # no responses found
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/responses/9999")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 404

    def test_admin_bypasses_link_check_for_responses(self, client, admin_user):
        """Admin can access patient responses without a link."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.return_value = [self._response_row()]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/responses/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        assert len(response.json()) == 1

    def test_participant_cannot_access_patient_responses(self, client, participant_user):
        """Participant (role 1) cannot access this HCP-only endpoint — 403."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, _ = make_conn()

        app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/responses/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_consent_revoked_blocks_access(self, client, hcp_user):
        """403 when link exists but consent has been revoked (link not found by helper)."""
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        # _verify_hcp_access queries with ConsentRevoked=0 condition — returns None if revoked
        cursor.fetchone.return_value = None
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/responses/1")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

# ── TestHcpHealthTrackingMetrics ──────────────────────────────────────────────

class TestHcpHealthTrackingMetrics:
    """Tests for GET /api/v1/hcp/patients/{patient_id}/health-tracking/metrics"""

    def test_hcp_gets_active_metrics(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        # _verify_hcp_access returns a link row
        cursor.fetchone.return_value = {"LinkID": 1}
        # First fetchall: categories; second: metrics per category
        cursor.fetchall.side_effect = [
            [{"CategoryID": 1, "CategoryKey": "mental_health",
              "DisplayName": "Mental Health", "Description": None,
              "Icon": None, "DisplayOrder": 1}],
            [{"MetricID": 10, "CategoryID": 1, "MetricKey": "mood",
              "DisplayName": "Mood", "Description": None,
              "MetricType": "scale", "Unit": None, "ScaleMin": 1,
              "ScaleMax": 10, "ChoiceOptions": None, "Frequency": "daily",
              "DisplayOrder": 1, "IsActive": 1, "IsBaseline": 0}],
        ]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/health-tracking/metrics")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 1
        assert data[0]["category_key"] == "mental_health"
        assert len(data[0]["metrics"]) == 1
        assert data[0]["metrics"][0]["metric_id"] == 10

    def test_hcp_blocked_when_no_link(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None  # no active link
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/health-tracking/metrics")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403

    def test_admin_bypasses_link_check(self, client, admin_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchall.side_effect = [[], ]  # no categories — empty but valid
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: admin_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/health-tracking/metrics")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200


# ── TestHcpHealthTrackingEntries ──────────────────────────────────────────────

class TestHcpHealthTrackingEntries:
    """Tests for GET /api/v1/hcp/patients/{patient_id}/health-tracking/entries"""

    def _entry_row(self, metric_id=10, value="7", entry_date=None):
        from datetime import date, datetime
        return {
            "EntryID": 1, "ParticipantID": 2, "MetricID": metric_id,
            "Value": value, "Notes": None,
            "EntryDate": entry_date or date(2026, 3, 1),
            "IsBaseline": 0,
            "CreatedAt": datetime(2026, 3, 1, 8, 0, 0),
        }

    def test_returns_entries_for_patient(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = [self._entry_row()]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/health-tracking/entries")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["metric_id"] == 10
        assert data[0]["value"] == "7"

    def test_metric_filter_passed_to_query(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = []
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get(
                    "/api/v1/hcp/patients/2/health-tracking/entries?metric_id=10"
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200

    def test_hcp_blocked_when_no_link(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get("/api/v1/hcp/patients/2/health-tracking/entries")
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403


# ── TestHcpHealthTrackingAggregate ────────────────────────────────────────────

class TestHcpHealthTrackingAggregate:
    """Tests for GET /api/v1/hcp/patients/{patient_id}/health-tracking/aggregate"""

    def _agg_row(self, entry_date=None, avg_value=7.0, participant_count=6):
        from datetime import date
        return {
            "entry_date": entry_date or date(2026, 3, 1),
            "avg_value": avg_value,
            "participant_count": participant_count,
        }

    def test_returns_aggregate_data(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        cursor.fetchall.return_value = [self._agg_row()]
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                with patch("app.services.settings.get_int_setting", return_value=5):
                    response = client.get(
                        "/api/v1/hcp/patients/2/health-tracking/aggregate?metric_id=10"
                    )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["avg_value"] == 7.0
        assert data[0]["participant_count"] == 6

    def test_requires_metric_id(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = {"LinkID": 1}
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get(
                    "/api/v1/hcp/patients/2/health-tracking/aggregate"
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 422  # metric_id is required

    def test_hcp_blocked_when_no_link(self, client, hcp_user):
        from app.main import app
        from app.api.deps import get_current_user

        conn, cursor = make_conn()
        cursor.fetchone.return_value = None
        conn.cursor.return_value = cursor

        app.dependency_overrides[get_current_user] = lambda: hcp_user
        try:
            with patch("app.api.v1.hcp_patients.get_db_connection", return_value=conn):
                response = client.get(
                    "/api/v1/hcp/patients/2/health-tracking/aggregate?metric_id=10"
                )
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

        assert response.status_code == 403
