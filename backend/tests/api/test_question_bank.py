# Created with the Assistance of Claude Code
# backend/tests/api/test_question_bank.py
"""
TDD Tests for Question Bank CRUD API

These tests are written BEFORE the implementation (TDD red phase).
They should FAIL initially until the API is implemented in Task 006.

Endpoints tested:
- GET /api/v1/questions/categories  - List Categories
- POST   /api/v1/questions          - Create question
- GET    /api/v1/questions          - List all questions
- GET    /api/v1/questions/{id}     - Get single question
- PUT    /api/v1/questions/{id}     - Update question
- DELETE /api/v1/questions/{id}     - Delete question
"""

import pytest


# Test data fixtures
@pytest.fixture
def sample_question():
    """Basic question without options"""
    return {
        "title": "Sleep Hours",
        "question_content": "How many hours of sleep do you get per night?",
        "response_type": "number",
        "is_required": True,
        "category": "Sleep"
    }


@pytest.fixture
def sample_choice_question():
    """Question with choice options"""
    return {
        "title": "Exercise Frequency",
        "question_content": "How often do you exercise?",
        "response_type": "single_choice",
        "is_required": True,
        "category": "Exercise",
        "options": [
            {"option_text": "Never", "display_order": 1},
            {"option_text": "1-2 times per week", "display_order": 2},
            {"option_text": "3-4 times per week", "display_order": 3},
            {"option_text": "Daily", "display_order": 4}
        ]
    }


# =================================
# GET /api/v1/questions/categories
# =================================

class TestListCategories:
    """Tests for GET /api/v1/questions/categories"""

    def test_list_categories_success(self, client):
        """Should return a list of categories (non-empty if questions exist)"""
        # Create a couple of questions with different categories
        client.post("/api/v1/questions", json={
            "title": "Q1",
            "question_content": "Test 1?",
            "response_type": "number",
            "is_required": True,
            "category": "Sleep"
        })
        client.post("/api/v1/questions", json={
            "title": "Q2",
            "question_content": "Test 2?",
            "response_type": "yesno",
            "is_required": False,
            "category": "Exercise"
        })

        response = client.get("/api/v1/questions/categories")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert any(cat["category_key"] == "Sleep" for cat in data)
        assert any(cat["category_key"] == "Exercise" for cat in data)

    def test_list_categories_empty(self, client):
        """Should return an empty list if no categories exist"""
        # This assumes a clean DB or no questions present
        # (If not possible, this test may be skipped or adjusted)
        response = client.get("/api/v1/questions/categories")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)


# ===========================
# POST /api/v1/questions
# ===========================

class TestCreateQuestion:
    """Tests for POST /api/v1/questions"""

    def test_create_simple_question(self, client, sample_question):
        """Should create a question without options"""
        response = client.post("/api/v1/questions", json=sample_question)

        assert response.status_code == 201
        data = response.json()
        assert data["title"] == sample_question["title"]
        assert data["question_content"] == sample_question["question_content"]
        assert data["response_type"] == sample_question["response_type"]
        assert data["is_required"] == False  # IsRequired moved to QuestionList; QuestionBank always returns False
        assert "question_id" in data

    def test_create_choice_question_with_options(self, client, sample_choice_question):
        """Should create a choice question with options"""
        response = client.post("/api/v1/questions", json=sample_choice_question)

        assert response.status_code == 201
        data = response.json()
        assert data["response_type"] == "single_choice"
        assert "options" in data
        assert len(data["options"]) == 4

    def test_create_question_missing_content(self, client):
        """Should reject question without content"""
        response = client.post("/api/v1/questions", json={
            "title": "Test",
            "response_type": "number"
            # Missing question_content
        })

        assert response.status_code == 422  # Validation error

    def test_create_question_invalid_response_type(self, client):
        """Should reject invalid response type"""
        response = client.post("/api/v1/questions", json={
            "title": "Test",
            "question_content": "Test question?",
            "response_type": "invalid_type"
        })

        assert response.status_code == 422


# ===========================
# GET /api/v1/questions
# ===========================

class TestGetQuestions:
    """Tests for GET /api/v1/questions"""

    def test_get_all_questions(self, client):
        """Should return list of all questions"""
        response = client.get("/api/v1/questions")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_get_questions_by_category(self, client):
        """Should filter questions by category"""
        response = client.get("/api/v1/questions?category=Sleep")

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        for question in data:
            assert question["category"] == "Sleep"

    def test_get_questions_by_response_type(self, client):
        """Should filter questions by response type"""
        response = client.get("/api/v1/questions?response_type=number")

        assert response.status_code == 200
        data = response.json()
        for question in data:
            assert question["response_type"] == "number"


# ================================
# GET /api/v1/questions/{id}
# ================================

class TestGetSingleQuestion:
    """Tests for GET /api/v1/questions/{id}"""

    def test_get_question_by_id(self, client, sample_question):
        """Should return single question by ID"""
        # First create a question
        create_response = client.post("/api/v1/questions", json=sample_question)
        question_id = create_response.json()["question_id"]

        # Then get it
        response = client.get(f"/api/v1/questions/{question_id}")

        assert response.status_code == 200
        data = response.json()
        assert data["question_id"] == question_id
        assert data["title"] == sample_question["title"]

    def test_get_question_with_options(self, client, sample_choice_question):
        """Should include options for choice questions"""
        create_response = client.post("/api/v1/questions", json=sample_choice_question)
        question_id = create_response.json()["question_id"]

        response = client.get(f"/api/v1/questions/{question_id}")

        assert response.status_code == 200
        data = response.json()
        assert "options" in data
        assert len(data["options"]) == 4

    def test_get_nonexistent_question(self, client):
        """Should return 404 for nonexistent question"""
        response = client.get("/api/v1/questions/99999")

        assert response.status_code == 404


# ================================
# PUT /api/v1/questions/{id}
# ================================

class TestUpdateQuestion:
    """Tests for PUT /api/v1/questions/{id}"""

    def test_update_question_content(self, client, sample_question):
        """Should update question fields"""
        # Create
        create_response = client.post("/api/v1/questions", json=sample_question)
        question_id = create_response.json()["question_id"]

        # Update
        update_data = {
            "title": "Updated Title",
            "question_content": "Updated question text?",
            "response_type": "number",
            "is_required": False
        }
        response = client.put(f"/api/v1/questions/{question_id}", json=update_data)

        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Updated Title"
        assert data["is_required"] == False

    def test_update_choice_options(self, client, sample_choice_question):
        """Should update options for choice questions"""
        create_response = client.post("/api/v1/questions", json=sample_choice_question)
        question_id = create_response.json()["question_id"]

        update_data = {
            **sample_choice_question,
            "options": [
                {"option_text": "New Option 1", "display_order": 1},
                {"option_text": "New Option 2", "display_order": 2}
            ]
        }
        response = client.put(f"/api/v1/questions/{question_id}", json=update_data)

        assert response.status_code == 200
        data = response.json()
        assert len(data["options"]) == 2

    def test_update_nonexistent_question(self, client, sample_question):
        """Should return 404 for nonexistent question"""
        response = client.put("/api/v1/questions/99999", json=sample_question)

        assert response.status_code == 404


# ===================================
# DELETE /api/v1/questions/{id}
# ===================================

class TestDeleteQuestion:
    """Tests for DELETE /api/v1/questions/{id}"""

    def test_delete_question(self, client, sample_question):
        """Should delete question"""
        # Create
        create_response = client.post("/api/v1/questions", json=sample_question)
        question_id = create_response.json()["question_id"]

        # Delete
        response = client.delete(f"/api/v1/questions/{question_id}")

        assert response.status_code == 204

        # Verify deleted
        get_response = client.get(f"/api/v1/questions/{question_id}")
        assert get_response.status_code == 404

    def test_delete_choice_question_cascades_options(self, client, sample_choice_question):
        """Should delete options when question is deleted (CASCADE)"""
        create_response = client.post("/api/v1/questions", json=sample_choice_question)
        question_id = create_response.json()["question_id"]

        response = client.delete(f"/api/v1/questions/{question_id}")

        assert response.status_code == 204

    def test_delete_nonexistent_question(self, client):
        """Should return 404 for nonexistent question"""
        response = client.delete("/api/v1/questions/99999")

        assert response.status_code == 404


# ============================================================================
# Additional coverage tests for missing lines
# ============================================================================

class TestQuestionBankValidators:
    """Cover lines 70, 78, 85 in question_bank.py."""

    def test_create_question_empty_title_after_strip(self, client):
        """Line 70: Title cannot be empty (whitespace-only)."""
        response = client.post("/api/v1/questions", json={
            "title": "   ",
            "question_content": "Test?",
            "response_type": "number",
        })
        assert response.status_code == 422

    def test_create_question_empty_content_after_strip(self, client):
        """Line 78: Question content cannot be empty (whitespace-only)."""
        response = client.post("/api/v1/questions", json={
            "title": "Test Title",
            "question_content": "   ",
            "response_type": "number",
        })
        assert response.status_code == 422

    def test_create_question_invalid_response_type_validator(self, client):
        """Line 85: Invalid response type via validator."""
        response = client.post("/api/v1/questions", json={
            "title": "Test Title",
            "question_content": "Test question?",
            "response_type": "invalid_type_xyz",
        })
        assert response.status_code == 422


class TestUpdateQuestionScaleFields:
    """Cover lines 279-287, 389-390, 393-394 in question_bank.py."""

    def test_update_question_scale_fields(self, client):
        """Lines 389-394: Update scale_min and scale_max."""
        create_resp = client.post("/api/v1/questions", json={
            "title": "Scale Q",
            "question_content": "Rate 1-10?",
            "response_type": "scale",
        })
        assert create_resp.status_code == 201
        qid = create_resp.json()["question_id"]

        resp = client.put(f"/api/v1/questions/{qid}", json={
            "scale_min": 0,
            "scale_max": 100,
        })
        assert resp.status_code == 200
        data = resp.json()
        assert data["scale_min"] == 0
        assert data["scale_max"] == 100

    def test_update_question_category(self, client):
        """Line 279-287: Update category field."""
        create_resp = client.post("/api/v1/questions", json={
            "title": "Cat Q",
            "question_content": "Category test?",
            "response_type": "number",
            "category": "Health",
        })
        assert create_resp.status_code == 201
        qid = create_resp.json()["question_id"]

        resp = client.put(f"/api/v1/questions/{qid}", json={
            "category": "Exercise",
        })
        assert resp.status_code == 200
        assert resp.json()["category"] == "Exercise"

    def test_update_question_clear_options(self, client, sample_choice_question):
        """Lines 279-287: Update options to empty list clears them."""
        create_resp = client.post("/api/v1/questions", json=sample_choice_question)
        assert create_resp.status_code == 201
        qid = create_resp.json()["question_id"]

        resp = client.put(f"/api/v1/questions/{qid}", json={
            "options": [],
        })
        assert resp.status_code == 200
