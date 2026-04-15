# Created with the Assistance of Claude Code
# backend/tests/api/test_assignments.py
"""
TDD Tests for Survey Assignment API

These tests are written BEFORE the implementation (TDD red phase).
They should FAIL initially until the API is implemented in Task 011.

Endpoints tested:
- POST   /api/v1/surveys/{id}/assign           - Assign survey to user(s)
- GET    /api/v1/surveys/{id}/assignments      - List assignments for a survey
- GET    /api/v1/assignments/me                - Get my assignments (current user)
- PUT    /api/v1/assignments/{id}              - Update assignment (due date, status)
- DELETE /api/v1/assignments/{id}              - Remove assignment
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
from datetime import datetime, timedelta


# Test data fixtures
@pytest.fixture
def sample_assignment():
    """Basic assignment data"""
    return {
        "account_id": 1,
        "due_date": (datetime.now() + timedelta(days=7)).isoformat()
    }


@pytest.fixture
def bulk_assignment():
    """Multiple user assignment data"""
    return {
        "account_ids": [1, 2, 3],
        "due_date": (datetime.now() + timedelta(days=14)).isoformat()
    }


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


class TestAssignSurvey:
    """Tests for POST /api/v1/surveys/{id}/assign"""

    def test_assign_survey_to_single_user(self, client, published_survey, sample_assignment):
        """Should assign a published survey to a single user"""
        response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        assert response.status_code == 201
        data = response.json()
        assert data["survey_id"] == published_survey
        assert data["account_id"] == sample_assignment["account_id"]
        assert data["status"] == "pending"
        assert "assignment_id" in data

    def test_assign_survey_to_multiple_users(self, client, published_survey, bulk_assignment):
        """Should assign a survey to multiple users at once"""
        response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=bulk_assignment
        )

        assert response.status_code == 201
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 3  # 3 users assigned

    def test_assign_survey_with_due_date(self, client, published_survey, sample_assignment):
        """Should set due date on assignment"""
        response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        assert response.status_code == 201
        data = response.json()
        assert data["due_date"] is not None

    def test_cannot_assign_draft_survey(self, client, sample_assignment):
        """Should not allow assigning a draft survey"""
        # Create a draft survey (not published)
        s_response = client.post("/api/v1/surveys", json={
            "title": "Draft Survey",
            "publication_status": "draft"
        })
        survey_id = s_response.json()["survey_id"]

        response = client.post(
            f"/api/v1/surveys/{survey_id}/assign",
            json=sample_assignment
        )

        assert response.status_code == 400

    def test_cannot_assign_closed_survey(self, client, published_survey, sample_assignment):
        """Should not allow assigning a closed survey"""
        # Close the survey
        client.patch(f"/api/v1/surveys/{published_survey}/close")

        response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        assert response.status_code == 400

    def test_cannot_duplicate_assignment(self, client, published_survey, sample_assignment):
        """Should not allow duplicate assignment to same user"""
        # First assignment
        client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        # Try duplicate
        response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        assert response.status_code == 409  # Conflict

    def test_assign_nonexistent_survey(self, client, sample_assignment):
        """Should return 404 for nonexistent survey"""
        response = client.post(
            "/api/v1/surveys/99999/assign",
            json=sample_assignment
        )

        assert response.status_code == 404


class TestGetSurveyAssignments:
    """Tests for GET /api/v1/surveys/{id}/assignments"""

    def test_get_survey_assignments(self, client, published_survey, bulk_assignment):
        """Should return all assignments for a survey"""
        # Create assignments
        client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=bulk_assignment
        )

        response = client.get(f"/api/v1/surveys/{published_survey}/assignments")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 3

    def test_get_assignments_filter_by_status(self, client, published_survey, sample_assignment):
        """Should filter assignments by status"""
        # Create assignment
        client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        response = client.get(
            f"/api/v1/surveys/{published_survey}/assignments?status=pending"
        )

        assert response.status_code == 200
        data = response.json()
        for assignment in data:
            assert assignment["status"] == "pending"

    def test_get_assignments_empty_survey(self, client, published_survey):
        """Should return empty list for survey with no assignments"""
        response = client.get(f"/api/v1/surveys/{published_survey}/assignments")

        assert response.status_code == 200
        data = response.json()
        assert data == []

    def test_get_assignments_nonexistent_survey(self, client):
        """Should return 404 for nonexistent survey"""
        response = client.get("/api/v1/surveys/99999/assignments")

        assert response.status_code == 404


class TestGetMyAssignments:
    """Tests for GET /api/v1/assignments/me"""

    def test_get_my_assignments(self, client, published_survey):
        """Should return assignments for current user"""
        # Create assignment for mock admin user (effective_account_id=999)
        client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json={"account_id": 999, "due_date": None}
        )

        # /me uses user["effective_account_id"] from auth (999)
        response = client.get("/api/v1/assignments/me")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) >= 1

    def test_get_my_pending_assignments(self, client, published_survey, sample_assignment):
        """Should filter to only pending assignments"""
        # Create assignment
        client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )

        response = client.get("/api/v1/assignments/me?account_id=1&status=pending")

        assert response.status_code == 200
        data = response.json()
        for assignment in data:
            assert assignment["status"] == "pending"


class TestUpdateAssignment:
    """Tests for PUT /api/v1/assignments/{id}"""

    def test_update_assignment_due_date(self, client, published_survey, sample_assignment):
        """Should update assignment due date"""
        # Create assignment
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        # Update due date
        new_due_date = (datetime.now() + timedelta(days=30)).isoformat()
        response = client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={"due_date": new_due_date}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["due_date"] is not None

    def test_mark_assignment_completed(self, client, published_survey, sample_assignment):
        """Should mark assignment as completed"""
        # Create assignment
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        # Mark complete
        response = client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={"status": "completed"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "completed"
        assert data["completed_at"] is not None

    def test_update_nonexistent_assignment(self, client):
        """Should return 404 for nonexistent assignment"""
        response = client.put(
            "/api/v1/assignments/99999",
            json={"status": "completed"}
        )

        assert response.status_code == 404


class TestDeleteAssignment:
    """Tests for DELETE /api/v1/assignments/{id}"""

    def test_delete_assignment(self, client, published_survey, sample_assignment):
        """Should delete an assignment"""
        # Create assignment
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        # Delete
        response = client.delete(f"/api/v1/assignments/{assignment_id}")

        assert response.status_code == 204

        # Verify deleted - getting survey assignments should not include it
        get_response = client.get(f"/api/v1/surveys/{published_survey}/assignments")
        assignments = get_response.json()
        assert all(a["assignment_id"] != assignment_id for a in assignments)

    def test_delete_nonexistent_assignment(self, client):
        """Should return 404 for nonexistent assignment"""
        response = client.delete("/api/v1/assignments/99999")

        assert response.status_code == 404

    def test_cannot_delete_completed_assignment(self, client, published_survey, sample_assignment):
        """Should not allow deleting a completed assignment"""
        # Create assignment
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        # Mark complete
        client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={"status": "completed"}
        )

        # Try to delete
        response = client.delete(f"/api/v1/assignments/{assignment_id}")

        assert response.status_code == 400


# Pytest fixture for test client
@pytest.fixture
def client():
    """
    Create test client for the FastAPI app.

    Note: This fixture will need the assignment routes added to main.py
    in Task 011.
    """
    from app.main import app
    return TestClient(app)


# ============================================================================
# POST /surveys/{id}/assign — Bulk Assignment with demographic filters
# ============================================================================

class TestBulkAssignment:
    """Tests for bulk assignment path: assign_all + demographic filters.

    Uses MagicMock patching because FakeCursor doesn't handle the
    'SELECT AccountID FROM AccountData WHERE RoleID = %s AND IsActive = %s'
    query used in the bulk path.
    """

    @patch("app.api.v1.assignments.get_db_connection")
    def test_bulk_assign_all(self, mock_db, client):
        """Bulk assign_all creates assignments for active participants."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1, "published"),  # Survey check
            None,              # Dup check for account 101
            None,              # Dup check for account 102
        ]
        # fetchall for the bulk participant query
        cursor.fetchall.return_value = [(101,), (102,)]
        mock_db.return_value = conn

        response = client.post(
            "/api/v1/surveys/1/assign",
            json={"assign_all": True}
        )

        assert response.status_code == 201
        data = response.json()
        assert data["assigned"] == 2
        assert data["skipped"] == 0
        assert data["total_targeted"] == 2

    @patch("app.api.v1.assignments.get_db_connection")
    def test_bulk_assign_with_gender_filter(self, mock_db, client):
        """Bulk assignment with gender filter only assigns matching participants."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1, "published"),  # Survey check
            None,              # Dup check for account 201
        ]
        cursor.fetchall.return_value = [(201,)]
        mock_db.return_value = conn

        response = client.post(
            "/api/v1/surveys/1/assign",
            json={"gender": "Female"}
        )

        assert response.status_code == 201
        data = response.json()
        assert data["assigned"] == 1
        assert data["total_targeted"] == 1

    @patch("app.api.v1.assignments.get_db_connection")
    def test_bulk_assign_with_age_filter(self, mock_db, client):
        """Bulk assignment with age_min/age_max filters."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1, "published"),  # Survey check
            None,              # Dup check
        ]
        cursor.fetchall.return_value = [(301,)]
        mock_db.return_value = conn

        response = client.post(
            "/api/v1/surveys/1/assign",
            json={"age_min": 18, "age_max": 65}
        )

        assert response.status_code == 201
        data = response.json()
        assert data["assigned"] == 1

    @patch("app.api.v1.assignments.get_db_connection")
    def test_bulk_assign_skips_duplicates(self, mock_db, client):
        """Bulk assignment silently skips already-assigned participants."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1, "published"),  # Survey check
            (99,),             # Dup check for 101 — already assigned
            None,              # Dup check for 102 — not assigned
        ]
        cursor.fetchall.return_value = [(101,), (102,)]
        mock_db.return_value = conn

        response = client.post(
            "/api/v1/surveys/1/assign",
            json={"assign_all": True}
        )

        assert response.status_code == 201
        data = response.json()
        assert data["skipped"] == 1
        assert data["assigned"] == 1
        assert data["total_targeted"] == 2

    def test_bulk_assign_unpublished_survey_returns_400(self, client):
        """Bulk assignment on unpublished survey should return 400."""
        # Create draft survey (not published)
        s_response = client.post("/api/v1/surveys", json={
            "title": "Draft Survey",
            "publication_status": "draft"
        })
        survey_id = s_response.json()["survey_id"]

        response = client.post(
            f"/api/v1/surveys/{survey_id}/assign",
            json={"assign_all": True}
        )

        assert response.status_code == 400


# ============================================================================
# PUT /assignments/{id} — Update Assignment
# ============================================================================

class TestUpdateAssignmentExtra:
    """Extra tests for PUT /api/v1/assignments/{id} covering missing lines."""

    def test_update_status_to_expired(self, client, published_survey, sample_assignment):
        """Should update assignment status to expired."""
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        response = client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={"status": "expired"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "expired"

    def test_update_due_date_and_status(self, client, published_survey, sample_assignment):
        """Should update both due_date and status in single request."""
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        new_due_date = (datetime.now() + timedelta(days=60)).isoformat()
        response = client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={"due_date": new_due_date, "status": "completed"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "completed"
        assert data["completed_at"] is not None

    def test_update_no_changes(self, client, published_survey, sample_assignment):
        """Should return 200 even with empty update body (no changes)."""
        create_response = client.post(
            f"/api/v1/surveys/{published_survey}/assign",
            json=sample_assignment
        )
        assignment_id = create_response.json()["assignment_id"]

        response = client.put(
            f"/api/v1/assignments/{assignment_id}",
            json={}
        )

        assert response.status_code == 200


# ============================================================================
# GET /surveys/{id}/assignments/preview-target — lines 243-295
# ============================================================================

class TestPreviewAssignmentTarget:
    """Tests for GET /api/v1/surveys/{id}/assignments/preview-target."""

    @patch("app.api.v1.assignments.get_db_connection")
    def test_preview_target_with_participants(self, mock_db, client):
        """Should return total_targeted, already_assigned, assignable counts."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1,),   # Survey exists check
            (1,),   # COUNT(*) already_assigned = 1
        ]
        cursor.fetchall.return_value = [(101,), (102,), (103,)]
        mock_db.return_value = conn

        response = client.get("/api/v1/surveys/1/assignments/preview-target")

        assert response.status_code == 200
        data = response.json()
        assert data["total_targeted"] == 3
        assert data["already_assigned"] == 1
        assert data["assignable"] == 2

    @patch("app.api.v1.assignments.get_db_connection")
    def test_preview_target_no_participants(self, mock_db, client):
        """Should return zeros when no participants match."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1,),  # Survey exists check
        ]
        cursor.fetchall.return_value = []
        mock_db.return_value = conn

        response = client.get("/api/v1/surveys/1/assignments/preview-target")

        assert response.status_code == 200
        data = response.json()
        assert data["total_targeted"] == 0
        assert data["already_assigned"] == 0
        assert data["assignable"] == 0

    @patch("app.api.v1.assignments.get_db_connection")
    def test_preview_target_nonexistent_survey(self, mock_db, client):
        """Should return 404 for nonexistent survey."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        cursor.fetchone.return_value = None
        mock_db.return_value = conn

        response = client.get("/api/v1/surveys/9999/assignments/preview-target")
        assert response.status_code == 404

    @patch("app.api.v1.assignments.get_db_connection")
    def test_preview_target_with_gender_filter(self, mock_db, client):
        """Should accept gender query parameter."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1,),   # Survey exists
            (0,),   # COUNT already assigned
        ]
        cursor.fetchall.return_value = [(201,)]
        mock_db.return_value = conn

        response = client.get("/api/v1/surveys/1/assignments/preview-target?gender=Female")

        assert response.status_code == 200
        data = response.json()
        assert data["total_targeted"] == 1

    @patch("app.api.v1.assignments.get_db_connection")
    def test_preview_target_with_age_filters(self, mock_db, client):
        """Should accept age_min and age_max query parameters."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchone.side_effect = [
            (1,),   # Survey exists
            (0,),   # COUNT already assigned
        ]
        cursor.fetchall.return_value = [(301,), (302,)]
        mock_db.return_value = conn

        response = client.get("/api/v1/surveys/1/assignments/preview-target?age_min=18&age_max=65")

        assert response.status_code == 200
        data = response.json()
        assert data["total_targeted"] == 2
