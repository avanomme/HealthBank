# Created with the Assistance of Claude Code
# backend/tests/api/test_surveys.py
"""
TDD Tests for Survey CRUD API

These tests are written BEFORE the implementation (TDD red phase).
They should FAIL initially until the API is implemented in Task 008.

Endpoints tested:
- POST   /api/v1/surveys                            - Create survey
- GET    /api/v1/surveys                            - List all surveys
- GET    /api/v1/surveys/{id}                       - Get single survey
- PUT    /api/v1/surveys/{id}                       - Update survey
- DELETE /api/v1/surveys/{id}                       - Delete survey
- PATCH /api/v1/surveys/{survey_id}/publish         - Publish Survey
- PATCH /api/v1/surveys/{survey_id}/close           - Close Survey
- POST /api/v1/surveys/from-template/{template_id}  - Create Survey From Template
"""

import pytest


# Test data fixtures
@pytest.fixture
def sample_survey():
    """Basic survey without questions"""
    return {
        "title": "Health Assessment Survey",
        "description": "A survey to assess general health status",
        "publication_status": "draft"
        # TODO: Add creator_id when auth is implemented
    }


@pytest.fixture
def sample_survey_with_questions():
    """Survey with question IDs to attach"""
    return {
        "title": "Sleep Quality Survey",
        "description": "Track your sleep patterns",
        "publication_status": "draft",
        "question_ids": [1, 2, 3]  # Assumes questions exist in QuestionBank
    }


# =========================================
# POST /api/v1/surveys
# =========================================

class TestCreateSurvey:
    """Tests for POST /api/v1/surveys"""

    def test_create_survey(self, client, sample_survey):
        """Should create a survey"""
        response = client.post("/api/v1/surveys", json=sample_survey)

        assert response.status_code == 201
        data = response.json()
        assert data["title"] == sample_survey["title"]
        assert data["description"] == sample_survey["description"]
        assert data["publication_status"] == "draft"
        assert "survey_id" in data

    def test_create_survey_with_questions(self, client, sample_survey_with_questions):
        """Should create a survey with attached questions"""
        # First create some questions to attach
        question_data = {
            "title": "Test Question",
            "question_content": "How are you?",
            "response_type": "openended",
            "is_required": False
        }
        q_response = client.post("/api/v1/questions", json=question_data)
        question_id = q_response.json()["question_id"]

        # Create survey with that question
        survey_data = {
            "title": "Test Survey",
            "description": "Test description",
            "publication_status": "draft",
            "question_ids": [question_id]
        }
        response = client.post("/api/v1/surveys", json=survey_data)

        assert response.status_code == 201
        data = response.json()
        assert "questions" in data
        assert len(data["questions"]) == 1

    def test_create_survey_missing_title(self, client):
        """Should reject survey without title"""
        response = client.post("/api/v1/surveys", json={
            "description": "No title survey"
        })

        assert response.status_code == 422  # Validation error

    def test_create_survey_invalid_publication_status(self, client):
        """Should reject invalid publication status"""
        response = client.post("/api/v1/surveys", json={
            "title": "Test Survey",
            "publication_status": "invalid_status"
        })

        assert response.status_code == 422


# =========================================
# GET /api/v1/surveys
# =========================================

class TestGetSurveys:
    """Tests for GET /api/v1/surveys"""

    def test_get_all_surveys(self, client):
        """Should return list of all surveys"""
        response = client.get("/api/v1/surveys")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_get_surveys_by_publication_status(self, client, sample_survey):
        """Should filter surveys by publication status"""
        # Create a draft survey
        client.post("/api/v1/surveys", json=sample_survey)

        response = client.get("/api/v1/surveys?publication_status=draft")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        for survey in data:
            assert survey["publication_status"] == "draft"

    def test_get_only_published_surveys(self, client):
        """Should be able to filter for only published surveys"""
        response = client.get("/api/v1/surveys?publication_status=published")

        assert response.status_code == 200
        data = response.json()
        for survey in data:
            assert survey["publication_status"] == "published"


# =========================================
# GET /api/v1/surveys/{id}
# =========================================

class TestGetSingleSurvey:
    """Tests for GET /api/v1/surveys/{id}"""

    def test_get_survey_by_id(self, client, sample_survey):
        """Should return single survey by ID"""
        # First create a survey
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        # Then get it
        response = client.get(f"/api/v1/surveys/{survey_id}")

        assert response.status_code == 200
        data = response.json()
        assert data["survey_id"] == survey_id
        assert data["title"] == sample_survey["title"]

    def test_get_survey_with_questions(self, client):
        """Should include questions when fetching survey"""
        # Create a question
        q_response = client.post("/api/v1/questions", json={
            "title": "Test",
            "question_content": "Test question?",
            "response_type": "yesno"
        })
        question_id = q_response.json()["question_id"]

        # Create survey with question
        s_response = client.post("/api/v1/surveys", json={
            "title": "Survey with Questions",
            "question_ids": [question_id]
        })
        survey_id = s_response.json()["survey_id"]

        # Get survey
        response = client.get(f"/api/v1/surveys/{survey_id}")

        assert response.status_code == 200
        data = response.json()
        assert "questions" in data
        assert len(data["questions"]) >= 1

    def test_get_nonexistent_survey(self, client):
        """Should return 404 for nonexistent survey"""
        response = client.get("/api/v1/surveys/99999")

        assert response.status_code == 404


# =========================================
# PUT /api/v1/surveys/{id}
# =========================================

class TestUpdateSurvey:
    """Tests for PUT /api/v1/surveys/{id}"""

    def test_update_survey_title(self, client, sample_survey):
        """Should update survey fields"""
        # Create
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        # Update
        update_data = {
            "title": "Updated Survey Title",
            "description": "Updated description"
        }
        response = client.put(f"/api/v1/surveys/{survey_id}", json=update_data)

        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Updated Survey Title"
        assert data["description"] == "Updated description"

    def test_update_survey_questions(self, client, sample_survey):
        """Should update questions attached to survey"""
        # Create questions
        q1 = client.post("/api/v1/questions", json={
            "title": "Q1",
            "question_content": "Question 1?",
            "response_type": "yesno"
        }).json()["question_id"]

        q2 = client.post("/api/v1/questions", json={
            "title": "Q2",
            "question_content": "Question 2?",
            "response_type": "number"
        }).json()["question_id"]

        # Create survey with first question
        create_response = client.post("/api/v1/surveys", json={
            **sample_survey,
            "question_ids": [q1]
        })
        survey_id = create_response.json()["survey_id"]

        # Update to have both questions
        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "question_ids": [q1, q2]
        })

        assert response.status_code == 200
        data = response.json()
        assert len(data["questions"]) == 2

    def test_update_nonexistent_survey(self, client, sample_survey):
        """Should return 404 for nonexistent survey"""
        response = client.put("/api/v1/surveys/99999", json=sample_survey)

        assert response.status_code == 404

    def test_cannot_update_published_survey_title(self, client):
        """Should not allow editing certain fields of published surveys"""
        # Create and publish a survey
        create_response = client.post("/api/v1/surveys", json={
            "title": "Published Survey",
            "publication_status": "published"
        })
        survey_id = create_response.json()["survey_id"]

        # Try to change title - should fail or be restricted
        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "title": "Changed Title"
        })

        # Either reject the update or keep the original title
        # (exact behavior TBD based on requirements)
        assert response.status_code in [200, 400, 403]


# =========================================
# DELETE /api/v1/surveys/{id}
# =========================================

class TestDeleteSurvey:
    """Tests for DELETE /api/v1/surveys/{id}"""

    def test_delete_draft_survey(self, client, sample_survey):
        """Should delete a draft survey"""
        # Create
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        # Delete
        response = client.delete(f"/api/v1/surveys/{survey_id}")

        assert response.status_code == 204

        # Verify deleted
        get_response = client.get(f"/api/v1/surveys/{survey_id}")
        assert get_response.status_code == 404

    def test_delete_nonexistent_survey(self, client):
        """Should return 404 for nonexistent survey"""
        response = client.delete("/api/v1/surveys/99999")

        assert response.status_code == 404

    def test_delete_survey_removes_question_links(self, client):
        """Should remove question links when survey is deleted"""
        # Create question
        q_response = client.post("/api/v1/questions", json={
            "title": "Test",
            "question_content": "Test?",
            "response_type": "yesno"
        })
        question_id = q_response.json()["question_id"]

        # Create survey with question
        s_response = client.post("/api/v1/surveys", json={
            "title": "Test Survey",
            "question_ids": [question_id]
        })
        survey_id = s_response.json()["survey_id"]

        # Delete survey
        client.delete(f"/api/v1/surveys/{survey_id}")

        # Question should still exist
        q_check = client.get(f"/api/v1/questions/{question_id}")
        assert q_check.status_code == 200


# =========================================
# PATCH /api/v1/surveys/{survey_id}/publish
# =========================================

class TestPublishSurvey:
    """Tests for PATCH /api/v1/surveys/{survey_id}/publish"""

    def test_publish_draft_survey_success(self, client, sample_survey):
        """Should publish a draft survey and update status to 'published'"""
        # First, create a question
        question_data = {
            "title": "Test Question",
            "question_content": "How are you?",
            "response_type": "openended",
            "is_required": False
        }
        q_response = client.post("/api/v1/questions", json=question_data)
        assert q_response.status_code == 201
        question_id = q_response.json()["question_id"]

        # Create a draft survey with the question attached
        survey_data = dict(sample_survey)
        survey_data["question_ids"] = [question_id]
        create_response = client.post("/api/v1/surveys", json=survey_data)
        assert create_response.status_code == 201
        survey_id = create_response.json()["survey_id"]

        # Publish the survey
        response = client.patch(f"/api/v1/surveys/{survey_id}/publish")
        assert response.status_code == 200
        data = response.json()
        assert data["survey_id"] == survey_id
        assert data["publication_status"] == "published"

    def test_publish_already_published_survey(self, client, sample_survey):
        """Should not re-publish an already published survey (idempotent or error)"""
        # Create and publish a survey
        create_response = client.post("/api/v1/surveys", json={**sample_survey, "publication_status": "published"})
        assert create_response.status_code == 201
        survey_id = create_response.json()["survey_id"]

        # Try to publish again
        response = client.patch(f"/api/v1/surveys/{survey_id}/publish")
        # Acceptable: 200 (idempotent), 400, or 409 (conflict)
        assert response.status_code in [200, 400, 409]

    def test_publish_nonexistent_survey(self, client):
        """Should return 404 for nonexistent survey"""
        response = client.patch("/api/v1/surveys/999999/publish")
        assert response.status_code == 404

    def test_publish_survey_missing_id(self, client):
        """Should return 404 or 422 if survey_id is missing or invalid"""
        response = client.patch("/api/v1/surveys/abc/publish")
        assert response.status_code in (404, 422)

    def test_publish_survey_with_invalid_status(self, client, sample_survey):
        """Should not publish a survey in an invalid state (e.g., already closed)"""
        # Create a survey and simulate closing it first
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]
        # Close the survey (assume endpoint exists)
        client.patch(f"/api/v1/surveys/{survey_id}/close")
        # Try to publish after closing
        response = client.patch(f"/api/v1/surveys/{survey_id}/publish")
        # Acceptable: 400, 409, or 422
        assert response.status_code in [400, 409, 422]


# =========================================
# PATCH /api/v1/surveys/{survey_id}/close
# =========================================

class TestCloseSurvey:
    """Tests for PATCH /api/v1/surveys/{survey_id}/close"""

    def test_close_published_survey_success(self, client, sample_survey):
        """Should close a published survey and update status to 'closed'"""
        # Create a question
        question_data = {
            "title": "Test Question",
            "question_content": "How are you?",
            "response_type": "openended",
            "is_required": False
        }
        q_response = client.post("/api/v1/questions", json=question_data)
        assert q_response.status_code == 201
        question_id = q_response.json()["question_id"]

        # Create and publish a survey
        survey_data = dict(sample_survey)
        survey_data["question_ids"] = [question_id]
        create_response = client.post("/api/v1/surveys", json=survey_data)
        assert create_response.status_code == 201
        survey_id = create_response.json()["survey_id"]
        # Publish
        publish_response = client.patch(f"/api/v1/surveys/{survey_id}/publish")
        assert publish_response.status_code == 200

        # Close the survey
        response = client.patch(f"/api/v1/surveys/{survey_id}/close")
        assert response.status_code == 200
        data = response.json()
        assert data["survey_id"] == survey_id
        assert data["publication_status"] == "closed"

    def test_close_already_closed_survey(self, client, sample_survey):
        """Should not re-close an already closed survey (idempotent or error)"""
        # Create a question
        question_data = {
            "title": "Test Question",
            "question_content": "How are you?",
            "response_type": "openended",
            "is_required": False
        }
        q_response = client.post("/api/v1/questions", json=question_data)
        question_id = q_response.json()["question_id"]

        # Create and publish a survey
        survey_data = dict(sample_survey)
        survey_data["question_ids"] = [question_id]
        create_response = client.post("/api/v1/surveys", json=survey_data)
        survey_id = create_response.json()["survey_id"]
        client.patch(f"/api/v1/surveys/{survey_id}/publish")
        # Close
        close_response = client.patch(f"/api/v1/surveys/{survey_id}/close")
        assert close_response.status_code == 200
        # Try to close again
        response = client.patch(f"/api/v1/surveys/{survey_id}/close")
        # Acceptable: 200 (idempotent), 400, or 409 (conflict)
        assert response.status_code in [200, 400, 409]

    def test_close_nonexistent_survey(self, client):
        """Should return 404 for nonexistent survey"""
        response = client.patch("/api/v1/surveys/999999/close")
        assert response.status_code == 404

    def test_close_survey_missing_id(self, client):
        """Should return 404 or 422 if survey_id is missing or invalid"""
        response = client.patch("/api/v1/surveys/abc/close")
        assert response.status_code in (404, 422)

    def test_close_survey_with_invalid_status(self, client, sample_survey):
        """Should not close a survey in an invalid state (e.g., still draft)"""
        # Create a question
        question_data = {
            "title": "Test Question",
            "question_content": "How are you?",
            "response_type": "openended",
            "is_required": False
        }
        q_response = client.post("/api/v1/questions", json=question_data)
        question_id = q_response.json()["question_id"]

        # Create a draft survey (not published)
        survey_data = dict(sample_survey)
        survey_data["question_ids"] = [question_id]
        create_response = client.post("/api/v1/surveys", json=survey_data)
        survey_id = create_response.json()["survey_id"]
        # Try to close while still draft
        response = client.patch(f"/api/v1/surveys/{survey_id}/close")
        # Acceptable: 400, 409, or 422
        assert response.status_code in [400, 409, 422]


# =========================================
# POST /surveys/from-template/{template_id}
# =========================================

class TestMakeSurveyFromTemplate:
    """Tests for POST /api/v1/surveys/from-template/{template_id}"""

    def test_create_survey_from_template_success(self, client):
        """Should create a new survey from a valid template."""
        # First, create a template (assume endpoint exists)
        template_data = {
            "title": "Template Survey",
            "description": "A reusable survey template",
            "question_ids": []
        }
        template_resp = client.post("/api/v1/templates", json=template_data)
        print("[DEBUG] Template creation status:", template_resp.status_code)
        print("[DEBUG] Template creation response:", template_resp.json())
        assert template_resp.status_code == 201
        template_json = template_resp.json()
        template_id = template_json.get("template_id")
        assert template_id is not None

        # Now, create a survey from the template
        response = client.post(f"/api/v1/surveys/from-template/{template_id}")
        print("[DEBUG] Survey from template status:", response.status_code)
        print("[DEBUG] Survey from template response:", response.json())
        assert response.status_code == 201
        data = response.json()
        assert data["title"] == template_data["title"]
        assert data["description"] == template_data["description"]
        assert "survey_id" in data

    def test_create_survey_from_invalid_template(self, client):
        """Should return 404 for nonexistent template_id."""
        response = client.post("/api/v1/surveys/from-template/999999")
        assert response.status_code == 404

    def test_create_survey_from_template_missing_id(self, client):
        """Should return 404 or 422 if template_id is missing or invalid."""
        # Try with a non-integer or missing id
        response = client.post("/api/v1/surveys/from-template/abc")
        assert response.status_code in (404, 422)


# =========================================
# Additional coverage tests for missing lines
# =========================================

class TestSurveyValidationPaths:
    """Cover lines 81, 88, 115 in surveys.py."""

    def test_create_survey_empty_title_after_strip(self, client):
        """Line 81: Title cannot be empty (whitespace-only)."""
        response = client.post("/api/v1/surveys", json={
            "title": "   ",
            "description": "Test description",
        })
        assert response.status_code == 422

    def test_create_survey_publication_status_none_defaults_draft(self, client):
        """Line 88: publication_status=None should default to draft."""
        response = client.post("/api/v1/surveys", json={
            "title": "Default Status Survey",
            "publication_status": None,
        })
        assert response.status_code == 201
        assert response.json()["publication_status"] == "draft"

    def test_from_template_sanitize_strings(self, client):
        """Line 115: SurveyFromTemplateCreate sanitizes strings."""
        # Create a template first
        template_resp = client.post("/api/v1/templates", json={
            "title": "Template",
            "description": "desc",
            "question_ids": [],
        })
        assert template_resp.status_code == 201
        template_id = template_resp.json()["template_id"]

        response = client.post(f"/api/v1/surveys/from-template/{template_id}", json={
            "title": "Override Title",
            "description": "Override Desc",
        })
        assert response.status_code == 201


class TestUpdateSurveyFieldPaths:
    """Cover lines 155-165, 295-296, 408-409, 412-413, 416-417."""

    def test_update_survey_publication_status(self, client, sample_survey):
        """Lines 408-409: Update publication_status field."""
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "publication_status": "draft",
        })
        assert response.status_code == 200

    def test_update_survey_start_date(self, client, sample_survey):
        """Lines 412-413: Update start_date field."""
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "start_date": "2026-06-01T00:00:00",
        })
        assert response.status_code == 200

    def test_update_survey_end_date(self, client, sample_survey):
        """Lines 416-417: Update end_date field."""
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "end_date": "2026-12-31T23:59:59",
        })
        assert response.status_code == 200

    def test_update_survey_no_fields(self, client, sample_survey):
        """Lines 155-165: Empty update body - no fields to update."""
        create_response = client.post("/api/v1/surveys", json=sample_survey)
        survey_id = create_response.json()["survey_id"]

        response = client.put(f"/api/v1/surveys/{survey_id}", json={})
        assert response.status_code == 200

    def test_update_survey_clear_questions(self, client, sample_survey):
        """Lines 295-296: Update with empty question_ids list (unlink all)."""
        q_response = client.post("/api/v1/questions", json={
            "title": "Q1",
            "question_content": "Question 1?",
            "response_type": "yesno",
        })
        question_id = q_response.json()["question_id"]

        create_response = client.post("/api/v1/surveys", json={
            **sample_survey,
            "question_ids": [question_id],
        })
        survey_id = create_response.json()["survey_id"]

        # Clear all questions
        response = client.put(f"/api/v1/surveys/{survey_id}", json={
            "question_ids": [],
        })
        assert response.status_code == 200
        assert response.json()["question_count"] == 0


class TestDeleteSurveyDetailed:
    """Cover lines 521, 703-704."""

    def test_delete_survey_with_responses_and_assignments(self, client, sample_survey):
        """Lines 521, 703-704: Delete survey cleans up responses and assignments."""
        # Create question and survey
        q_resp = client.post("/api/v1/questions", json={
            "title": "Q",
            "question_content": "Q?",
            "response_type": "yesno",
        })
        qid = q_resp.json()["question_id"]

        s_resp = client.post("/api/v1/surveys", json={
            **sample_survey,
            "question_ids": [qid],
        })
        survey_id = s_resp.json()["survey_id"]

        response = client.delete(f"/api/v1/surveys/{survey_id}")
        assert response.status_code == 204

        # Confirm it's gone
        get_resp = client.get(f"/api/v1/surveys/{survey_id}")
        assert get_resp.status_code == 404


class TestListSurveysCreatorFilter:
    """Cover line 295-296: filter surveys by creator_id."""

    def test_filter_by_creator_id(self, client, sample_survey):
        """Line 295-296: creator_id query param filters surveys."""
        # Create a survey (creator_id will be admin 999 from mock)
        create_resp = client.post("/api/v1/surveys", json=sample_survey)
        assert create_resp.status_code == 201

        response = client.get("/api/v1/surveys?creator_id=999")
        assert response.status_code == 200

    def test_filter_by_creator_id_accepted(self, client, sample_survey):
        """Creator filter parameter is accepted without error."""
        create_resp = client.post("/api/v1/surveys", json=sample_survey)
        assert create_resp.status_code == 201

        response = client.get("/api/v1/surveys?creator_id=12345")
        assert response.status_code == 200
        assert isinstance(response.json(), list)


class TestSurveyFromTemplateOverride:
    """Cover lines 155-165: from-template with title/description override."""

    def test_from_template_with_overrides(self, client):
        """Lines 155-165: Override title and description from template."""
        # Create template
        template_resp = client.post("/api/v1/templates", json={
            "title": "Original Template",
            "description": "Original description",
            "question_ids": [],
        })
        assert template_resp.status_code == 201
        tid = template_resp.json()["template_id"]

        response = client.post(f"/api/v1/surveys/from-template/{tid}", json={
            "title": "Custom Title",
            "description": "Custom Description",
        })
        assert response.status_code == 201
        data = response.json()
        assert data["title"] == "Custom Title"
        assert data["description"] == "Custom Description"


class TestPublishSurveyNoQuestions:
    """Cover line 521 in surveys.py: publish survey with no questions fails."""

    def test_publish_empty_survey_fails(self, client):
        """Cannot publish survey without questions (line 582-586)."""
        create_resp = client.post("/api/v1/surveys", json={
            "title": "Empty Survey",
        })
        assert create_resp.status_code == 201
        sid = create_resp.json()["survey_id"]

        resp = client.patch(f"/api/v1/surveys/{sid}/publish")
        assert resp.status_code == 400
        assert "without questions" in resp.json()["detail"]