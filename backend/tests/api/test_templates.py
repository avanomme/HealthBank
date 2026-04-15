# Created with the Assistance of Claude Code
# backend/tests/api/test_templates.py
"""
TDD Tests for Survey Templates CRUD API

These tests are written BEFORE the implementation (TDD red phase).
They should FAIL initially until the API is implemented in Task 013.

Endpoints tested:
- POST   /api/v1/templates      - Create template
- GET    /api/v1/templates      - List all templates
- GET    /api/v1/templates/{id} - Get single template
- PUT    /api/v1/templates/{id} - Update template
- DELETE /api/v1/templates/{id} - Delete template
"""

import pytest
from fastapi.testclient import TestClient


# Test data fixtures
@pytest.fixture
def sample_template():
    """Basic template without questions"""
    return {
        "title": "Health Assessment Template",
        "description": "A reusable template for health assessments",
        "is_public": False
        # TODO: Add creator_id when auth is implemented
    }


@pytest.fixture
def sample_template_with_questions(client):
    """Template with question IDs to attach"""
    # Create questions first
    q1 = client.post("/api/v1/questions", json={
        "title": "Sleep Hours",
        "question_content": "How many hours of sleep do you get?",
        "response_type": "number"
    }).json()["question_id"]

    q2 = client.post("/api/v1/questions", json={
        "title": "Exercise",
        "question_content": "Do you exercise regularly?",
        "response_type": "yesno"
    }).json()["question_id"]

    return {
        "title": "Sleep Quality Template",
        "description": "Track sleep patterns",
        "is_public": True,
        "question_ids": [q1, q2]
    }


class TestCreateTemplate:
    """Tests for POST /api/v1/templates"""

    def test_create_template(self, client, sample_template):
        """Should create a template"""
        response = client.post("/api/v1/templates", json=sample_template)

        assert response.status_code == 201
        data = response.json()
        assert data["title"] == sample_template["title"]
        assert data["description"] == sample_template["description"]
        assert data["is_public"] == False
        assert "template_id" in data

    def test_create_template_with_questions(self, client, sample_template_with_questions):
        """Should create a template with attached questions"""
        response = client.post("/api/v1/templates", json=sample_template_with_questions)

        assert response.status_code == 201
        data = response.json()
        assert "questions" in data
        assert len(data["questions"]) == 2

    def test_create_template_with_question_order(self, client):
        """Should preserve question display order"""
        # Create questions
        q1 = client.post("/api/v1/questions", json={
            "title": "Q1",
            "question_content": "First?",
            "response_type": "yesno"
        }).json()["question_id"]

        q2 = client.post("/api/v1/questions", json={
            "title": "Q2",
            "question_content": "Second?",
            "response_type": "yesno"
        }).json()["question_id"]

        # Create template with ordered questions
        response = client.post("/api/v1/templates", json={
            "title": "Ordered Template",
            "question_ids": [q2, q1]  # q2 first, then q1
        })

        assert response.status_code == 201
        data = response.json()
        # First question in list should be q2
        assert data["questions"][0]["question_id"] == q2
        assert data["questions"][1]["question_id"] == q1

    def test_create_template_missing_title(self, client):
        """Should reject template without title"""
        response = client.post("/api/v1/templates", json={
            "description": "No title template"
        })

        assert response.status_code == 422  # Validation error

    def test_create_public_template(self, client, sample_template):
        """Should create a public template"""
        template_data = {**sample_template, "is_public": True}
        response = client.post("/api/v1/templates", json=template_data)

        assert response.status_code == 201
        data = response.json()
        assert data["is_public"] == True


class TestGetTemplates:
    """Tests for GET /api/v1/templates"""

    def test_get_all_templates(self, client):
        """Should return list of all templates"""
        response = client.get("/api/v1/templates")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_get_public_templates(self, client, sample_template):
        """Should filter to only public templates"""
        # Create a public template
        client.post("/api/v1/templates", json={
            **sample_template,
            "is_public": True
        })

        response = client.get("/api/v1/templates?is_public=true")

        assert response.status_code == 200
        data = response.json()
        for template in data:
            assert template["is_public"] == True

    def test_get_templates_with_question_count(self, client, sample_template_with_questions):
        """Should include question count in list"""
        client.post("/api/v1/templates", json=sample_template_with_questions)

        response = client.get("/api/v1/templates")

        assert response.status_code == 200
        data = response.json()
        assert len(data) > 0
        assert "question_count" in data[0]


class TestGetSingleTemplate:
    """Tests for GET /api/v1/templates/{id}"""

    def test_get_template_by_id(self, client, sample_template):
        """Should return single template by ID"""
        # First create a template
        create_response = client.post("/api/v1/templates", json=sample_template)
        template_id = create_response.json()["template_id"]

        # Then get it
        response = client.get(f"/api/v1/templates/{template_id}")

        assert response.status_code == 200
        data = response.json()
        assert data["template_id"] == template_id
        assert data["title"] == sample_template["title"]

    def test_get_template_with_questions(self, client, sample_template_with_questions):
        """Should include questions when fetching template"""
        # Create template with questions
        create_response = client.post("/api/v1/templates", json=sample_template_with_questions)
        template_id = create_response.json()["template_id"]

        # Get template
        response = client.get(f"/api/v1/templates/{template_id}")

        assert response.status_code == 200
        data = response.json()
        assert "questions" in data
        assert len(data["questions"]) == 2
        # Questions should include full details
        assert "question_content" in data["questions"][0]

    def test_get_nonexistent_template(self, client):
        """Should return 404 for nonexistent template"""
        response = client.get("/api/v1/templates/99999")

        assert response.status_code == 404


class TestUpdateTemplate:
    """Tests for PUT /api/v1/templates/{id}"""

    def test_update_template_title(self, client, sample_template):
        """Should update template fields"""
        # Create
        create_response = client.post("/api/v1/templates", json=sample_template)
        template_id = create_response.json()["template_id"]

        # Update
        update_data = {
            "title": "Updated Template Title",
            "description": "Updated description"
        }
        response = client.put(f"/api/v1/templates/{template_id}", json=update_data)

        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Updated Template Title"
        assert data["description"] == "Updated description"

    def test_update_template_questions(self, client, sample_template):
        """Should update questions attached to template"""
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

        # Create template with first question
        create_response = client.post("/api/v1/templates", json={
            **sample_template,
            "question_ids": [q1]
        })
        template_id = create_response.json()["template_id"]

        # Update to have both questions
        response = client.put(f"/api/v1/templates/{template_id}", json={
            "question_ids": [q1, q2]
        })

        assert response.status_code == 200
        data = response.json()
        assert len(data["questions"]) == 2

    def test_update_template_visibility(self, client, sample_template):
        """Should update template public/private status"""
        # Create private template
        create_response = client.post("/api/v1/templates", json=sample_template)
        template_id = create_response.json()["template_id"]

        # Make public
        response = client.put(f"/api/v1/templates/{template_id}", json={
            "is_public": True
        })

        assert response.status_code == 200
        data = response.json()
        assert data["is_public"] == True

    def test_update_nonexistent_template(self, client, sample_template):
        """Should return 404 for nonexistent template"""
        response = client.put("/api/v1/templates/99999", json=sample_template)

        assert response.status_code == 404


class TestDeleteTemplate:
    """Tests for DELETE /api/v1/templates/{id}"""

    def test_delete_template(self, client, sample_template):
        """Should delete a template"""
        # Create
        create_response = client.post("/api/v1/templates", json=sample_template)
        template_id = create_response.json()["template_id"]

        # Delete
        response = client.delete(f"/api/v1/templates/{template_id}")

        assert response.status_code == 204

        # Verify deleted
        get_response = client.get(f"/api/v1/templates/{template_id}")
        assert get_response.status_code == 404

    def test_delete_template_preserves_questions(self, client, sample_template_with_questions):
        """Should preserve questions in bank when template is deleted"""
        # Create template with questions
        create_response = client.post("/api/v1/templates", json=sample_template_with_questions)
        template_id = create_response.json()["template_id"]
        question_ids = [q["question_id"] for q in create_response.json()["questions"]]

        # Delete template
        client.delete(f"/api/v1/templates/{template_id}")

        # Questions should still exist
        for qid in question_ids:
            q_response = client.get(f"/api/v1/questions/{qid}")
            assert q_response.status_code == 200

    def test_delete_nonexistent_template(self, client):
        """Should return 404 for nonexistent template"""
        response = client.delete("/api/v1/templates/99999")

        assert response.status_code == 404


class TestDuplicateTemplate:
    """Tests for POST /api/v1/templates/{id}/duplicate"""

    def test_duplicate_template(self, client, sample_template_with_questions):
        """Should create a copy of a template"""
        # Create original
        create_response = client.post("/api/v1/templates", json=sample_template_with_questions)
        original_id = create_response.json()["template_id"]

        # Duplicate
        response = client.post(f"/api/v1/templates/{original_id}/duplicate")

        assert response.status_code == 201
        data = response.json()
        assert data["template_id"] != original_id
        assert data["title"].startswith(sample_template_with_questions["title"])
        assert len(data["questions"]) == len(sample_template_with_questions["question_ids"])

    def test_duplicate_nonexistent_template(self, client):
        """Should return 404 for nonexistent template"""
        response = client.post("/api/v1/templates/99999/duplicate")

        assert response.status_code == 404


# Pytest fixture for test client
@pytest.fixture
def client():
    """
    Create test client for the FastAPI app.

    Note: This fixture will need the templates router added to main.py
    in Task 013.
    """
    from app.main import app
    return TestClient(app)


# ============================================================================
# Additional coverage tests for missing lines
# ============================================================================

class TestTemplateValidators:
    """Cover line 60: Title cannot be empty after strip."""

    def test_create_template_empty_title(self, client):
        """Line 60: whitespace-only title raises 422."""
        response = client.post("/api/v1/templates", json={
            "title": "   ",
            "description": "Test desc",
        })
        assert response.status_code == 422


class TestTemplateWithChoiceQuestions:
    """Cover lines 111-115: get_template_questions fetches options for choice questions."""

    def test_template_with_choice_question_includes_options(self, client):
        """Lines 111-115: choice questions in template include options."""
        q_resp = client.post("/api/v1/questions", json={
            "title": "Color Choice",
            "question_content": "Favorite color?",
            "response_type": "single_choice",
            "options": [
                {"option_text": "Red", "display_order": 1},
                {"option_text": "Blue", "display_order": 2},
            ],
        })
        assert q_resp.status_code == 201
        qid = q_resp.json()["question_id"]

        t_resp = client.post("/api/v1/templates", json={
            "title": "Choice Template",
            "question_ids": [qid],
        })
        assert t_resp.status_code == 201
        tid = t_resp.json()["template_id"]

        resp = client.get(f"/api/v1/templates/{tid}")
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["questions"]) == 1
        assert data["questions"][0]["options"] is not None
        assert len(data["questions"][0]["options"]) == 2


class TestTemplateListCreatorFilter:
    """Cover lines 200-201: creator_id filter in list templates."""

    def test_list_templates_by_creator_id(self, client, sample_template):
        """Lines 200-201: creator_id query param filters templates."""
        client.post("/api/v1/templates", json=sample_template)

        response = client.get("/api/v1/templates?creator_id=999")
        assert response.status_code == 200

    def test_list_templates_by_creator_id_accepted(self, client, sample_template):
        """Creator filter parameter is accepted without error."""
        client.post("/api/v1/templates", json=sample_template)

        response = client.get("/api/v1/templates?creator_id=12345")
        assert response.status_code == 200
        assert isinstance(response.json(), list)
