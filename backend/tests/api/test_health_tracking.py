# Created with the Assistance of Claude Code
# backend/tests/api/test_health_tracking.py
"""
Tests for the Health Tracking API in app/api/v1/health_tracking.py.

Tests cover:
- Participant endpoints: GET /metrics, POST /entries, GET /entries,
  GET /history/{id}, GET /baseline
- Admin endpoints: GET/POST/PUT categories, GET/POST/PUT/PATCH/PUT metrics
- Researcher endpoints: GET /research/aggregate, GET /research/export

Auth note: conftest mock_auth overrides get_current_user with admin (RoleID=4)
by default.  Tests that verify real role enforcement must clear that override
via the module-level clear_auth_override fixture defined below.
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient

from app.main import app
from app.api.deps import get_current_user


# ---------------------------------------------------------------------------
# Module-level auth override management
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def _restore_admin_override(mock_auth):  # noqa: F811 – mock_auth from conftest
    """Ensure the admin override is present for every test in this module.

    Individual tests that need a different user inject their own override
    inside the test body, then restore admin at teardown via this fixture's
    yield / cleanup phase.
    """
    yield
    # conftest mock_auth already handles cleanup, so nothing extra needed.


@pytest.fixture
def client():
    return TestClient(app)


# ---------------------------------------------------------------------------
# Auth helpers (match test_responses.py exactly)
# ---------------------------------------------------------------------------

def _mock_participant_auth():
    """Single DB connection returning a participant (RoleID=1)."""
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = {
        "AccountID": 42,
        "Email": "participant@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 1,
        "ViewingAsUserID": None,
    }
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor
    return [auth_conn]


def _mock_researcher_auth():
    """Single DB connection returning a researcher (RoleID=2)."""
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = {
        "AccountID": 10,
        "Email": "researcher@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 2,
        "ViewingAsUserID": None,
    }
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor
    return [auth_conn]


def _make_ht_conn(cursor):
    """Wrap a cursor mock in a connection mock."""
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn


# ---------------------------------------------------------------------------
# Helpers: canonical DB row shapes
# ---------------------------------------------------------------------------

def _cat_row(category_id=1):
    return {
        "CategoryID": category_id,
        "CategoryKey": "fitness",
        "DisplayName": "Fitness",
        "Description": "Physical fitness metrics",
        "Icon": "dumbbell",
        "DisplayOrder": 1,
        "IsActive": 1,
        "IsDeleted": 0,
    }


def _metric_row(metric_id=1, category_id=1):
    return {
        "MetricID": metric_id,
        "CategoryID": category_id,
        "MetricKey": "steps",
        "DisplayName": "Steps",
        "Description": "Daily step count",
        "MetricType": "number",
        "Unit": "steps",
        "ScaleMin": 1,
        "ScaleMax": 10,
        "ChoiceOptions": None,
        "Frequency": "daily",
        "DisplayOrder": 1,
        "IsActive": 1,
        "IsBaseline": 0,
        "IsDeleted": 0,
    }


def _entry_row(entry_id=1, participant_id=999, metric_id=1):
    return {
        "EntryID": entry_id,
        "ParticipantID": participant_id,
        "MetricID": metric_id,
        "Value": "8000",
        "Notes": None,
        "EntryDate": "2026-04-01",
        "IsBaseline": 0,
        "CreatedAt": "2026-04-01 10:00:00",
    }


# ===========================================================================
# 1. Participant — GET /metrics returns categories with nested metrics
# ===========================================================================

class TestGetMetrics:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_metrics_returns_categories_with_metrics(self, mock_ht_db, client):
        """Mock returns 1 category + 2 metrics; assert JSON structure."""
        cursor = MagicMock()
        cursor.fetchall.side_effect = [
            [_cat_row(1)],                         # categories query
            [_metric_row(1, 1), _metric_row(2, 1)],  # metrics for cat 1
        ]
        cursor.fetchone.return_value = None  # no translation
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/metrics")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        cat = data[0]
        assert cat["category_id"] == 1
        assert cat["category_key"] == "fitness"
        assert len(cat["metrics"]) == 2
        assert cat["metrics"][0]["metric_id"] == 1
        assert cat["metrics"][1]["metric_id"] == 2

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_metrics_with_lang_param(self, mock_ht_db, client):
        """Translation table lookup returns French name; assert translated name used."""
        cursor = MagicMock()
        cursor.fetchall.side_effect = [
            [_cat_row(1)],         # categories
            [_metric_row(1, 1)],   # metrics
        ]
        # fetchone calls: category translation, metric translation
        cursor.fetchone.side_effect = [
            {"DisplayName": "Forme physique", "Description": "Métriques"},  # cat trans
            {"DisplayName": "Pas", "Description": "Nombre de pas"},          # metric trans
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/metrics?lang=fr")

        assert response.status_code == 200
        data = response.json()
        assert data[0]["display_name"] == "Forme physique"
        assert data[0]["metrics"][0]["display_name"] == "Pas"


# ===========================================================================
# 2. Participant — POST /entries
# ===========================================================================

class TestPostEntries:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_post_entries_success(self, mock_ht_db, client):
        """Valid batch of 3 entries (scale, yesno, number); assert 201 + count=3."""
        cursor = MagicMock()
        # Each entry: fetchone for metric lookup
        cursor.fetchone.side_effect = [
            {"MetricID": 1, "MetricType": "scale", "ScaleMin": 1, "ScaleMax": 10,
             "ChoiceOptions": None, "IsActive": 1},
            {"MetricID": 2, "MetricType": "yesno",  "ScaleMin": 1, "ScaleMax": 10,
             "ChoiceOptions": None, "IsActive": 1},
            {"MetricID": 3, "MetricType": "number", "ScaleMin": 1, "ScaleMax": 10,
             "ChoiceOptions": None, "IsActive": 1},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "entries": [
                {"metric_id": 1, "value": "7"},
                {"metric_id": 2, "value": "yes"},
                {"metric_id": 3, "value": "8000"},
            ],
            "is_baseline": False,
        }
        response = client.post("/api/v1/health-tracking/entries", json=body)

        assert response.status_code == 201
        assert response.json()["entries_saved"] == 3

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_post_entries_upsert(self, mock_ht_db, client):
        """Same metric_id + entry_date twice; confirm ON DUPLICATE KEY path runs for both."""
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            {"MetricID": 1, "MetricType": "number", "ScaleMin": 1, "ScaleMax": 10,
             "ChoiceOptions": None, "IsActive": 1},
            {"MetricID": 1, "MetricType": "number", "ScaleMin": 1, "ScaleMax": 10,
             "ChoiceOptions": None, "IsActive": 1},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "entries": [
                {"metric_id": 1, "value": "5000", "entry_date": "2026-04-01"},
                {"metric_id": 1, "value": "6000", "entry_date": "2026-04-01"},  # same date — upsert
            ],
        }
        response = client.post("/api/v1/health-tracking/entries", json=body)

        assert response.status_code == 201
        assert response.json()["entries_saved"] == 2
        # Both entries hit the INSERT … ON DUPLICATE KEY path
        assert cursor.execute.call_count == 4  # 2× metric SELECT + 2× INSERT

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_post_entries_invalid_metric(self, mock_ht_db, client):
        """metric_id doesn't exist → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None  # metric not found
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {"entries": [{"metric_id": 9999, "value": "5"}]}
        response = client.post("/api/v1/health-tracking/entries", json=body)

        assert response.status_code == 404
        assert "9999" in response.json()["detail"]

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_post_entries_invalid_value_scale(self, mock_ht_db, client):
        """Value '15' for scale min=1 max=10 → 422."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {
            "MetricID": 1, "MetricType": "scale", "ScaleMin": 1, "ScaleMax": 10,
            "ChoiceOptions": None, "IsActive": 1,
        }
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {"entries": [{"metric_id": 1, "value": "15"}]}
        response = client.post("/api/v1/health-tracking/entries", json=body)

        assert response.status_code == 422
        assert "1" in response.json()["detail"]  # mentions scale range

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_post_entries_invalid_value_yesno(self, mock_ht_db, client):
        """Value 'maybe' for yesno → 422."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {
            "MetricID": 2, "MetricType": "yesno", "ScaleMin": 1, "ScaleMax": 10,
            "ChoiceOptions": None, "IsActive": 1,
        }
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {"entries": [{"metric_id": 2, "value": "maybe"}]}
        response = client.post("/api/v1/health-tracking/entries", json=body)

        assert response.status_code == 422
        assert "yes/no" in response.json()["detail"].lower()

    def test_post_entries_requires_participant(self, client):
        """Researcher (RoleID=2) receives 403 on participant-only endpoint.

        We temporarily override get_current_user with a researcher identity.
        """
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 10,
            "email": "researcher@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 2,
            "viewing_as_user_id": None,
            "effective_account_id": 10,
            "effective_role_id": 2,
        }
        try:
            body = {"entries": [{"metric_id": 1, "value": "5"}]}
            response = client.post("/api/v1/health-tracking/entries", json=body)
            assert response.status_code == 403
        finally:
            # Restore admin override so other tests are unaffected
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# 3. Participant — GET /entries
# ===========================================================================

class TestGetEntries:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_entries_returns_filtered_list(self, mock_ht_db, client):
        """Mock returns 3 entries; assert list length and field names."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            _entry_row(1, 999, 1),
            _entry_row(2, 999, 2),
            _entry_row(3, 999, 3),
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/entries")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 3
        assert data[0]["entry_id"] == 1
        assert "value" in data[0]
        assert "entry_date" in data[0]


# ===========================================================================
# 4. Participant — GET /history/{metric_id}
# ===========================================================================

class TestGetHistory:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_history_returns_time_series(self, mock_ht_db, client):
        """metric_id=1, mock returns 5 entries; assert list length and sorted by date."""
        rows = [
            _entry_row(i, 999, 1) | {"EntryDate": f"2026-03-0{i}"}
            for i in range(1, 6)
        ]
        cursor = MagicMock()
        cursor.fetchall.return_value = rows
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/history/1")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 5
        # Dates should come back oldest-first (ORDER BY EntryDate ASC in endpoint)
        assert data[0]["entry_date"] == "2026-03-01"
        assert data[4]["entry_date"] == "2026-03-05"


# ===========================================================================
# 5. Admin — GET /admin/categories
# ===========================================================================

class TestAdminCategories:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_get_categories_returns_all(self, mock_ht_db, client):
        """Mock returns 2 categories with MetricCount; assert shape."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            _cat_row(1) | {"MetricCount": 3},
            _cat_row(2) | {"CategoryID": 2, "CategoryKey": "sleep",
                           "DisplayName": "Sleep", "MetricCount": 2},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/admin/categories")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["metric_count"] == 3
        assert data[1]["category_key"] == "sleep"

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_create_category_success(self, mock_ht_db, client):
        """POST valid category; assert 201 and returned body."""
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            None,                     # uniqueness check — key not taken
            {                         # SELECT after INSERT
                "CategoryID": 5,
                "CategoryKey": "nutrition",
                "DisplayName": "Nutrition",
                "Description": "Dietary metrics",
                "Icon": "apple",
                "DisplayOrder": 2,
                "IsActive": 1,
            },
        ]
        cursor.lastrowid = 5
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "category_key": "nutrition",
            "display_name": "Nutrition",
            "description": "Dietary metrics",
            "icon": "apple",
            "display_order": 2,
        }
        response = client.post("/api/v1/health-tracking/admin/categories", json=body)

        assert response.status_code == 201
        data = response.json()
        assert data["category_id"] == 5
        assert data["category_key"] == "nutrition"

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_create_category_duplicate_key(self, mock_ht_db, client):
        """SELECT finds existing row for key → 409 Conflict."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"CategoryID": 1}  # key already exists
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "category_key": "fitness",
            "display_name": "Fitness",
            "display_order": 1,
        }
        response = client.post("/api/v1/health-tracking/admin/categories", json=body)

        assert response.status_code == 409
        assert "already exists" in response.json()["detail"]


# ===========================================================================
# 6. Admin — POST /admin/metrics
# ===========================================================================

class TestAdminMetrics:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_create_metric_success(self, mock_ht_db, client):
        """POST valid metric with choice_options JSON; assert 201."""
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            {"CategoryID": 1},   # category exists
            {                    # SELECT after INSERT
                "MetricID": 10,
                "CategoryID": 1,
                "MetricKey": "mood",
                "DisplayName": "Mood",
                "Description": "Daily mood",
                "MetricType": "single_choice",
                "Unit": None,
                "ScaleMin": 1,
                "ScaleMax": 10,
                "ChoiceOptions": '["Great", "Good", "Okay", "Bad"]',
                "Frequency": "daily",
                "DisplayOrder": 3,
                "IsActive": 1,
                "IsBaseline": 0,
            },
        ]
        cursor.lastrowid = 10
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "category_id": 1,
            "metric_key": "mood",
            "display_name": "Mood",
            "description": "Daily mood",
            "metric_type": "single_choice",
            "choice_options": ["Great", "Good", "Okay", "Bad"],
            "frequency": "daily",
            "display_order": 3,
        }
        response = client.post("/api/v1/health-tracking/admin/metrics", json=body)

        assert response.status_code == 201
        data = response.json()
        assert data["metric_id"] == 10
        assert data["choice_options"] == ["Great", "Good", "Okay", "Bad"]

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_toggle_metric(self, mock_ht_db, client):
        """PATCH toggle; mock returns IsActive=1; assert response flips to False."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"MetricID": 1, "IsActive": 1}
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch("/api/v1/health-tracking/admin/metrics/1/toggle")

        assert response.status_code == 200
        data = response.json()
        assert data["metric_id"] == 1
        assert data["is_active"] is False  # flipped from 1 → 0

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_reorder_metrics(self, mock_ht_db, client):
        """PUT reorder list of [{metric_id, display_order}]; assert updated count."""
        cursor = MagicMock()
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = [
            {"metric_id": 1, "display_order": 3},
            {"metric_id": 2, "display_order": 1},
            {"metric_id": 3, "display_order": 2},
        ]
        response = client.put("/api/v1/health-tracking/admin/metrics/reorder", json=body)

        assert response.status_code == 200
        assert response.json()["updated"] == 3
        # One UPDATE per item
        assert cursor.execute.call_count == 3

    def test_admin_requires_admin_role(self, client):
        """Participant (RoleID=1) on an admin endpoint gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.get("/api/v1/health-tracking/admin/categories")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# 7. Researcher — /research endpoints
# ===========================================================================

class TestResearchEndpoints:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_research_aggregate_respects_k_anonymity(self, mock_ht_db, client):
        """
        The endpoint pushes k-anonymity filtering to the SQL HAVING clause.
        The mock only returns rows that survived the HAVING filter.
        Verify: a group with count=6 is returned; a group with count=3 is absent
        (simulated by only returning the count=6 group from the mock).
        """
        cursor = MagicMock()
        # SQL HAVING already filters; mock simulates DB returning only the row
        # with sufficient participant count.
        cursor.fetchall.return_value = [
            {"EntryDate": "2026-04-01", "participant_count": 6, "avg_value": 7500.0},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/research/aggregate?metric_id=1")

        assert response.status_code == 200
        data = response.json()
        # Only the group with count=6 appears (count=3 was filtered by HAVING)
        assert len(data) == 1
        assert data[0]["participant_count"] == 6
        assert data[0]["avg_value"] == pytest.approx(7500.0)

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_research_export_returns_csv(self, mock_ht_db, client):
        """Assert Content-Type text/csv and that participant IDs are hashed."""
        import hashlib

        cursor = MagicMock()
        cursor.fetchall.return_value = [
            {
                "ParticipantID": 42,
                "CategoryKey": "fitness",
                "MetricKey": "steps",
                "EntryDate": "2026-04-01",
                "Value": "8000",
                "Frequency": "daily",
            }
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/research/export")

        assert response.status_code == 200
        assert "text/csv" in response.headers["content-type"]

        content = response.text
        # Header row
        assert "hashed_participant_id" in content
        assert "category_key" in content
        # Participant ID must be SHA-256 hashed, NOT raw numeric
        assert "42" not in content
        expected_hash = hashlib.sha256(b"42").hexdigest()
        assert expected_hash in content

    def test_researcher_requires_researcher_role(self, client):
        """Participant (RoleID=1) on a researcher endpoint gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.get("/api/v1/health-tracking/research/aggregate?metric_id=1")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# 8. Admin — DELETE /admin/categories and DELETE /admin/metrics
# ===========================================================================

class TestAdminDeleteEndpoints:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_category_success(self, mock_ht_db, client):
        """Existing category → 204, UPDATE TrackingCategory SET IsActive=0 is called."""
        cursor = MagicMock()
        cursor.fetchone.return_value = _cat_row(1)
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.delete("/api/v1/health-tracking/admin/categories/1")

        assert response.status_code == 204

        # First execute: SELECT to check existence.
        # Second execute: UPDATE TrackingCategory SET IsActive = 0.
        calls = cursor.execute.call_args_list
        assert len(calls) >= 2
        second_call_sql = calls[1][0][0]
        assert "UPDATE" in second_call_sql
        assert "TrackingCategory" in second_call_sql
        assert "IsActive" in second_call_sql

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_category_also_deactivates_metrics(self, mock_ht_db, client):
        """Deleting a category also issues UPDATE TrackingMetric SET IsActive=0."""
        cursor = MagicMock()
        cursor.fetchone.return_value = _cat_row(1)
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.delete("/api/v1/health-tracking/admin/categories/1")

        assert response.status_code == 204

        calls = cursor.execute.call_args_list
        # Three execute calls: SELECT, UPDATE category, UPDATE metrics.
        assert len(calls) >= 3
        third_call_sql = calls[2][0][0]
        assert "UPDATE" in third_call_sql
        assert "TrackingMetric" in third_call_sql
        assert "IsActive" in third_call_sql

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_category_not_found(self, mock_ht_db, client):
        """category_id not in DB → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.delete("/api/v1/health-tracking/admin/categories/9999")

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    def test_delete_category_requires_admin(self, client):
        """Participant (role_id=1) on DELETE /admin/categories gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.delete("/api/v1/health-tracking/admin/categories/1")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_metric_success(self, mock_ht_db, client):
        """Existing metric → 204, UPDATE TrackingMetric SET IsActive=0 is called."""
        cursor = MagicMock()
        cursor.fetchone.return_value = _metric_row(1, 1)
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.delete("/api/v1/health-tracking/admin/metrics/1")

        assert response.status_code == 204

        calls = cursor.execute.call_args_list
        assert len(calls) >= 2
        second_call_sql = calls[1][0][0]
        assert "UPDATE" in second_call_sql
        assert "TrackingMetric" in second_call_sql
        assert "IsActive" in second_call_sql

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_metric_not_found(self, mock_ht_db, client):
        """metric_id not in DB → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.delete("/api/v1/health-tracking/admin/metrics/9999")

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    def test_delete_metric_requires_admin(self, client):
        """Participant (role_id=1) on DELETE /admin/metrics gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.delete("/api/v1/health-tracking/admin/metrics/1")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_delete_does_not_remove_entries(self, mock_ht_db, client):
        """After soft-deleting a metric, GET /entries still returns existing entries.

        The DELETE only sets IsActive=0; existing TrackingEntry rows are untouched.
        Verify by soft-deleting metric 1, then confirming the entries endpoint
        still surfaces entry rows referencing that metric.
        """
        cursor = MagicMock()

        # First call: DELETE /admin/metrics/1 — metric found, then deactivated.
        cursor.fetchone.return_value = _metric_row(1, 1)
        mock_ht_db.return_value = _make_ht_conn(cursor)

        delete_response = client.delete("/api/v1/health-tracking/admin/metrics/1")
        assert delete_response.status_code == 204

        # Second call: GET /entries — entries for the soft-deleted metric still exist.
        entries_cursor = MagicMock()
        entries_cursor.fetchall.return_value = [
            _entry_row(entry_id=1, participant_id=999, metric_id=1),
            _entry_row(entry_id=2, participant_id=999, metric_id=1),
        ]
        mock_ht_db.return_value = _make_ht_conn(entries_cursor)

        entries_response = client.get("/api/v1/health-tracking/entries")

        assert entries_response.status_code == 200
        data = entries_response.json()
        assert len(data) == 2
        assert data[0]["metric_id"] == 1
        assert data[1]["metric_id"] == 1


# ===========================================================================
# Admin — Restore endpoints
# ===========================================================================

class TestAdminRestoreEndpoints:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_restore_category_success(self, mock_ht_db, client):
        """Existing inactive category → 200, IsActive set to 1."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"CategoryID": 5}
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch(
            "/api/v1/health-tracking/admin/categories/5/restore"
        )
        assert response.status_code == 200
        data = response.json()
        assert data["category_id"] == 5
        assert data["is_active"] is True

        # Verify UPDATE was called with IsActive = 1
        calls = [str(c) for c in cursor.execute.call_args_list]
        assert any("IsActive = 1" in c and "CategoryID" in c for c in calls)

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_restore_category_not_found(self, mock_ht_db, client):
        """Missing category → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch(
            "/api/v1/health-tracking/admin/categories/999/restore"
        )
        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    def test_restore_category_requires_admin(self, client):
        """Participant (role_id=1) on PATCH /restore gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.patch(
                "/api/v1/health-tracking/admin/categories/1/restore"
            )
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_restore_metric_success(self, mock_ht_db, client):
        """Existing inactive metric → 200, IsActive set to 1."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"MetricID": 7}
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch(
            "/api/v1/health-tracking/admin/metrics/7/restore"
        )
        assert response.status_code == 200
        data = response.json()
        assert data["metric_id"] == 7
        assert data["is_active"] is True

        calls = [str(c) for c in cursor.execute.call_args_list]
        assert any("IsActive = 1" in c and "MetricID" in c for c in calls)

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_restore_metric_not_found(self, mock_ht_db, client):
        """Missing metric → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch(
            "/api/v1/health-tracking/admin/metrics/999/restore"
        )
        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    def test_restore_metric_requires_admin(self, client):
        """Participant (role_id=1) on PATCH /metrics/{id}/restore gets 403."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42,
            "email": "participant@example.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 42,
            "effective_role_id": 1,
        }
        try:
            response = client.patch(
                "/api/v1/health-tracking/admin/metrics/1/restore"
            )
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# Researcher — entry-date-range + aggregate-multi
# ===========================================================================

class TestResearcherExtendedEndpoints:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_entry_date_range_returns_min_max(self, mock_db, client):
        """GET /research/entry-date-range returns min_date and max_date."""
        from datetime import date

        cursor = MagicMock()
        cursor.fetchone.return_value = {
            "min_date": date(2025, 1, 1),
            "max_date": date(2026, 4, 8),
        }
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        response = client.get("/api/v1/health-tracking/research/entry-date-range")
        assert response.status_code == 200
        data = response.json()
        assert data["min_date"] == "2025-01-01"
        assert data["max_date"] == "2026-04-08"

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_entry_date_range_empty_db(self, mock_db, client):
        """GET /research/entry-date-range returns nulls when no entries exist."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"min_date": None, "max_date": None}
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        response = client.get("/api/v1/health-tracking/research/entry-date-range")
        assert response.status_code == 200
        data = response.json()
        assert data["min_date"] is None
        assert data["max_date"] is None

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_aggregate_multi_returns_per_metric_data(self, mock_db, client):
        """GET /research/aggregate-multi returns one result per requested metric."""
        from datetime import date

        cursor = MagicMock()
        cursor.fetchall.side_effect = [
            [
                {"MetricID": 1, "metric_name": "Mood", "category_name": "Mental Health"},
                {"MetricID": 2, "metric_name": "Sleep Hours", "category_name": "Physical Health"},
            ],
            [{"entry_date": date(2026, 4, 1), "avg_value": 7.5, "participant_count": 6}],
            [{"entry_date": date(2026, 4, 1), "avg_value": 6.2, "participant_count": 5}],
        ]
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        response = client.get(
            "/api/v1/health-tracking/research/aggregate-multi"
            "?metric_ids=1,2"
        )
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["metric_id"] == 1
        assert data[0]["metric_name"] == "Mood"
        assert data[0]["category_name"] == "Mental Health"
        assert len(data[0]["data"]) == 1
        assert data[0]["data"][0]["avg_value"] == pytest.approx(7.5)
        assert data[1]["metric_id"] == 2

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_aggregate_multi_no_metric_ids_returns_422(self, mock_db, client):
        """GET /research/aggregate-multi without metric_ids returns 422."""
        conn = MagicMock()
        mock_db.return_value = conn

        response = client.get("/api/v1/health-tracking/research/aggregate-multi")
        assert response.status_code == 422

    def test_entry_date_range_requires_researcher(self, client):
        """Participant cannot access /research/entry-date-range."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42, "email": "p@p.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 1, "viewing_as_user_id": None,
            "effective_account_id": 42, "effective_role_id": 1,
        }
        try:
            response = client.get(
                "/api/v1/health-tracking/research/entry-date-range"
            )
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

# ===========================================================================
# NEW: Participant — GET /baseline
# ===========================================================================

class TestParticipantBaseline:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_baseline_returns_entries(self, mock_ht_db, client):
        """GET /baseline returns entries where IsBaseline=1 for this participant."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            _entry_row(1, 999, 1) | {"IsBaseline": 1},
            _entry_row(2, 999, 2) | {"IsBaseline": 1},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/baseline")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["is_baseline"] is True
        assert data[1]["is_baseline"] is True

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_get_baseline_empty_returns_empty_list(self, mock_ht_db, client):
        """Participant with no baseline entries gets an empty list, not 404."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/baseline")

        assert response.status_code == 200
        assert response.json() == []

    def test_baseline_requires_auth(self, client):
        """Participant (role 1) can access baseline; outsider (role 3) is blocked."""
        # HCP (role 3) has no access to participant endpoints
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 10, "email": "hcp@example.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 3, "viewing_as_user_id": None,
            "effective_account_id": 10, "effective_role_id": 3,
        }
        try:
            response = client.get("/api/v1/health-tracking/baseline")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# NEW: Admin — GET /admin/metrics
# ===========================================================================

class TestAdminListMetrics:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_list_metrics_returns_all(self, mock_ht_db, client):
        """GET /admin/metrics returns both active and inactive/deleted metrics."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            _metric_row(1, 1) | {"CategoryKey": "fitness",
                                  "CategoryName": "Fitness"},
            _metric_row(2, 1) | {"MetricID": 2, "MetricKey": "weight",
                                  "DisplayName": "Weight", "IsActive": 0,
                                  "IsDeleted": 1, "CategoryKey": "fitness",
                                  "CategoryName": "Fitness"},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/admin/metrics")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["metric_id"] == 1
        assert data[0]["is_active"] is True
        assert data[0]["is_deleted"] is False
        assert data[1]["metric_id"] == 2
        assert data[1]["is_active"] is False
        assert data[1]["is_deleted"] is True

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_admin_list_metrics_includes_category_name(self, mock_ht_db, client):
        """Each metric includes category_key and category_name for UI grouping."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            _metric_row(1, 3) | {"CategoryKey": "nutrition",
                                  "CategoryName": "Nutrition & Food"},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/admin/metrics")

        assert response.status_code == 200
        data = response.json()
        assert data[0]["category_key"] == "nutrition"
        assert data[0]["category_name"] == "Nutrition & Food"

    def test_admin_list_metrics_requires_admin(self, client):
        """Researcher (role 2) cannot access GET /admin/metrics."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 10, "email": "r@example.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 2, "viewing_as_user_id": None,
            "effective_account_id": 10, "effective_role_id": 2,
        }
        try:
            response = client.get("/api/v1/health-tracking/admin/metrics")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# NEW: Admin — PUT /admin/categories/{id} (update)
# ===========================================================================

class TestAdminUpdateCategory:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_update_category_success(self, mock_ht_db, client):
        """PUT valid body → 200, returns updated category fields."""
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            {"CategoryID": 1},      # existence check
            {                        # SELECT after UPDATE
                "CategoryID": 1,
                "CategoryKey": "fitness",
                "DisplayName": "Fitness & Exercise",
                "Description": "Updated description",
                "Icon": "dumbbell",
                "DisplayOrder": 2,
                "IsActive": 1,
                "IsDeleted": 0,
            },
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "category_key": "fitness",
            "display_name": "Fitness & Exercise",
            "description": "Updated description",
            "is_active": True,
            "display_order": 2,
        }
        response = client.put("/api/v1/health-tracking/admin/categories/1", json=body)

        assert response.status_code == 200
        data = response.json()
        assert data["category_id"] == 1
        assert data["display_name"] == "Fitness & Exercise"

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_update_category_not_found(self, mock_ht_db, client):
        """PUT on missing category_id → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = {
            "category_key": "missing",
            "display_name": "Missing",
            "is_active": True,
            "display_order": 0,
        }
        response = client.put(
            "/api/v1/health-tracking/admin/categories/9999", json=body
        )

        assert response.status_code == 404


# ===========================================================================
# NEW: Admin — PUT /admin/categories/reorder
# ===========================================================================

class TestAdminCategoryReorder:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_reorder_categories_success(self, mock_ht_db, client):
        """PUT list of [{category_id, display_order}] → 200, updated count matches."""
        cursor = MagicMock()
        mock_ht_db.return_value = _make_ht_conn(cursor)

        body = [
            {"category_id": 1, "display_order": 2},
            {"category_id": 2, "display_order": 0},
            {"category_id": 3, "display_order": 1},
        ]
        response = client.put(
            "/api/v1/health-tracking/admin/categories/reorder", json=body
        )

        assert response.status_code == 200
        assert response.json()["updated"] == 3
        # One UPDATE per item in the list
        assert cursor.execute.call_count == 3

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_reorder_categories_empty_body(self, mock_ht_db, client):
        """Empty list → 200, updated = 0 (no-op)."""
        cursor = MagicMock()
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.put(
            "/api/v1/health-tracking/admin/categories/reorder", json=[]
        )

        assert response.status_code == 200
        assert response.json()["updated"] == 0


# ===========================================================================
# NEW: Admin — PATCH /admin/categories/{id}/toggle
# ===========================================================================

class TestAdminToggleCategory:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_toggle_category_active_to_inactive(self, mock_ht_db, client):
        """Active category (IsActive=1) → toggled to False."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"CategoryID": 1, "IsActive": 1}
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch("/api/v1/health-tracking/admin/categories/1/toggle")

        assert response.status_code == 200
        data = response.json()
        assert data["category_id"] == 1
        assert data["is_active"] is False   # flipped from 1 → 0

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_toggle_category_inactive_to_active(self, mock_ht_db, client):
        """Inactive category (IsActive=0) → toggled to True."""
        cursor = MagicMock()
        cursor.fetchone.return_value = {"CategoryID": 2, "IsActive": 0}
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch("/api/v1/health-tracking/admin/categories/2/toggle")

        assert response.status_code == 200
        assert response.json()["is_active"] is True   # flipped from 0 → 1

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_toggle_category_not_found(self, mock_ht_db, client):
        """Missing category → 404."""
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.patch(
            "/api/v1/health-tracking/admin/categories/9999/toggle"
        )

        assert response.status_code == 404

    def test_toggle_category_requires_admin(self, client):
        """Researcher (role 2) cannot toggle a category."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 10, "email": "r@example.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 2, "viewing_as_user_id": None,
            "effective_account_id": 10, "effective_role_id": 2,
        }
        try:
            response = client.patch(
                "/api/v1/health-tracking/admin/categories/1/toggle"
            )
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# NEW: Researcher — GET /research/categories
# ===========================================================================

class TestResearchCategories:

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_research_categories_returns_summary(self, mock_ht_db, client):
        """GET /research/categories returns per-category aggregate stats."""
        from datetime import date

        cursor = MagicMock()
        cursor.fetchall.return_value = [
            {
                "CategoryID": 1,
                "CategoryKey": "physical_health",
                "DisplayName": "Physical Health",
                "participant_count": 8,
                "total_entries": 120,
                "most_recent_entry": date(2026, 4, 8),
            },
            {
                "CategoryID": 2,
                "CategoryKey": "mental_health",
                "DisplayName": "Mental Health",
                "participant_count": 6,
                "total_entries": 84,
                "most_recent_entry": date(2026, 4, 7),
            },
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/research/categories")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["category_key"] == "physical_health"
        assert data[0]["participant_count"] == 8
        assert data[0]["total_entries"] == 120
        assert data[1]["category_key"] == "mental_health"

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_research_categories_empty_returns_list(self, mock_ht_db, client):
        """No entries in DB → empty list, not error."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/research/categories")

        assert response.status_code == 200
        assert response.json() == []

    def test_research_categories_requires_researcher(self, client):
        """Participant (role 1) cannot access /research/categories."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 42, "email": "p@p.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 1, "viewing_as_user_id": None,
            "effective_account_id": 42, "effective_role_id": 1,
        }
        try:
            response = client.get(
                "/api/v1/health-tracking/research/categories"
            )
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER


# ===========================================================================
# 11. Participant self-service — /participant/aggregate + /participant/export
# ===========================================================================

class TestParticipantSelfServiceEndpoints:
    """Participant aggregate comparison and CSV export endpoints."""

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_aggregate_returns_daily_averages(self, mock_ht_db, client):
        """GET /participant/aggregate returns k-anon filtered rows for participants."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            {"EntryDate": "2026-04-01", "participant_count": 3, "avg_value": 6.5},
            {"EntryDate": "2026-04-02", "participant_count": 4, "avg_value": 7.0},
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/participant/aggregate?metric_id=5")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["avg_value"] == pytest.approx(6.5)
        assert data[1]["participant_count"] == 4

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_aggregate_date_filter(self, mock_ht_db, client):
        """Date range params are forwarded to DB query."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get(
            "/api/v1/health-tracking/participant/aggregate"
            "?metric_id=1&start_date=2026-01-01&end_date=2026-03-31"
        )
        assert response.status_code == 200

        # Verify date params appear in the SQL call
        sql_call = cursor.execute.call_args[0][0]
        params = cursor.execute.call_args[0][1]
        assert "EntryDate >= %s" in sql_call
        assert "EntryDate <= %s" in sql_call
        import datetime
        assert datetime.date(2026, 1, 1) in params
        assert datetime.date(2026, 3, 31) in params

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_aggregate_requires_participant_role(self, mock_ht_db, client):
        """Researcher (role 2) cannot access /participant/aggregate — only role 1 & 4."""
        app.dependency_overrides[get_current_user] = lambda: {
            "account_id": 10, "email": "r@r.com",
            "tos_accepted_at": "2026-01-01", "tos_version": "1.0",
            "role_id": 2, "viewing_as_user_id": None,
            "effective_account_id": 10, "effective_role_id": 2,
        }
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)
        try:
            response = client.get("/api/v1/health-tracking/participant/aggregate?metric_id=1")
            assert response.status_code == 403
        finally:
            from tests.conftest import MOCK_ADMIN_USER
            app.dependency_overrides[get_current_user] = lambda: MOCK_ADMIN_USER

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_export_returns_csv(self, mock_ht_db, client):
        """GET /participant/export returns CSV with correct columns."""
        cursor = MagicMock()
        cursor.fetchall.return_value = [
            {
                "CategoryKey": "mental_health",
                "MetricKey": "mood_score",
                "EntryDate": "2026-04-01",
                "Value": "4",
                "Notes": None,
            }
        ]
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get("/api/v1/health-tracking/participant/export")

        assert response.status_code == 200
        assert "text/csv" in response.headers["content-type"]
        content = response.text
        assert "category_key" in content
        assert "metric_key" in content
        assert "entry_date" in content
        assert "mental_health" in content
        assert "mood_score" in content

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_export_filters_own_data(self, mock_ht_db, client):
        """Export uses effective_account_id to filter entries."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        client.get("/api/v1/health-tracking/participant/export")

        sql_call = cursor.execute.call_args[0][0]
        params = cursor.execute.call_args[0][1]
        assert "ParticipantID = %s" in sql_call
        # Admin mock uses effective_account_id from MOCK_ADMIN_USER (999)
        from tests.conftest import MOCK_ADMIN_USER
        assert MOCK_ADMIN_USER["effective_account_id"] in params

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_export_metric_ids_filter(self, mock_ht_db, client):
        """metric_ids query param is accepted and added to SQL."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get(
            "/api/v1/health-tracking/participant/export?metric_ids=1,2,3"
        )
        assert response.status_code == 200
        sql_call = cursor.execute.call_args[0][0]
        assert "MetricID IN" in sql_call

    @patch("app.api.v1.health_tracking.get_db_connection")
    def test_participant_export_invalid_metric_ids(self, mock_ht_db, client):
        """Non-integer metric_ids return 400."""
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        mock_ht_db.return_value = _make_ht_conn(cursor)

        response = client.get(
            "/api/v1/health-tracking/participant/export?metric_ids=abc,def"
        )
        assert response.status_code == 400
