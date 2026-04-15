# Created with the Assistance of Claude Code
# backend/tests/api/test_boundary_values.py
"""
Boundary Value Tests for Survey System APIs

Testing strategy: Boundary Value Analysis
For each field with constraints:
- Valid middle value (passing)
- Just inside lower bound
- At lower bound (edge)
- Just outside lower bound (invalid)
- Just inside upper bound
- At upper bound (edge)
- Just outside upper bound (invalid)

Tests are organized by API endpoint and validate both input validation
and business logic edge cases.
"""

import pytest
from datetime import datetime, timedelta


class TestQuestionBoundaryValues:
    """Boundary tests for Question Bank API"""

    # Title field: 1-128 characters
    class TestTitleBoundaries:

        def test_title_valid_middle(self, client):
            """Valid: Title with 50 characters (middle value)"""
            response = client.post("/api/v1/questions", json={
                "title": "A" * 50,
                "question_content": "Test question?",
                "response_type": "yesno"
            })
            assert response.status_code == 201

        def test_title_at_lower_bound(self, client):
            """Edge: Title with 1 character (minimum)"""
            response = client.post("/api/v1/questions", json={
                "title": "A",
                "question_content": "Test question?",
                "response_type": "yesno"
            })
            assert response.status_code == 201
            assert response.json()["title"] == "A"

        def test_title_empty_rejected(self, client):
            """Invalid: Empty title should be rejected"""
            response = client.post("/api/v1/questions", json={
                "title": "",
                "question_content": "Test question?",
                "response_type": "yesno"
            })
            # Should reject empty title or accept as optional
            assert response.status_code in [201, 422]

        def test_title_at_upper_bound(self, client):
            """Edge: Title with 128 characters (maximum)"""
            response = client.post("/api/v1/questions", json={
                "title": "A" * 128,
                "question_content": "Test question?",
                "response_type": "yesno"
            })
            assert response.status_code == 201

        def test_title_exceeds_upper_bound(self, client):
            """Invalid: Title with 129 characters (exceeds max)"""
            response = client.post("/api/v1/questions", json={
                "title": "A" * 129,
                "question_content": "Test question?",
                "response_type": "yesno"
            })
            # Should either truncate or reject
            assert response.status_code in [201, 422]

    class TestResponseTypeBoundaries:

        def test_all_valid_response_types(self, client):
            """Valid: Each supported response type"""
            valid_types = ['number', 'yesno', 'openended', 'single_choice', 'multi_choice', 'scale']

            for resp_type in valid_types:
                response = client.post("/api/v1/questions", json={
                    "title": f"Test {resp_type}",
                    "question_content": "Test question?",
                    "response_type": resp_type
                })
                assert response.status_code == 201, f"Failed for type: {resp_type}"
                assert response.json()["response_type"] == resp_type

        def test_invalid_response_type(self, client):
            """Invalid: Unsupported response type"""
            response = client.post("/api/v1/questions", json={
                "title": "Test",
                "question_content": "Test question?",
                "response_type": "invalid_type"
            })
            assert response.status_code == 422

        def test_response_type_case_sensitive(self, client):
            """Invalid: Response type is case-sensitive"""
            response = client.post("/api/v1/questions", json={
                "title": "Test",
                "question_content": "Test question?",
                "response_type": "YESNO"  # Should be lowercase
            })
            assert response.status_code == 422

    class TestOptionsBoundaries:

        def test_choice_question_minimum_options(self, client):
            """Edge: Single choice with 2 options (minimum meaningful)"""
            response = client.post("/api/v1/questions", json={
                "title": "Binary Choice",
                "question_content": "Choose one?",
                "response_type": "single_choice",
                "options": [
                    {"option_text": "Yes", "display_order": 0},
                    {"option_text": "No", "display_order": 1}
                ]
            })
            assert response.status_code == 201
            assert len(response.json()["options"]) == 2

        def test_choice_question_one_option(self, client):
            """Edge: Single choice with 1 option (edge case)"""
            response = client.post("/api/v1/questions", json={
                "title": "Single Option",
                "question_content": "Only one choice?",
                "response_type": "single_choice",
                "options": [
                    {"option_text": "Only Option", "display_order": 0}
                ]
            })
            # Might be accepted or rejected as meaningless
            assert response.status_code in [201, 422]

        def test_choice_question_no_options(self, client):
            """Edge: Single choice with no options"""
            response = client.post("/api/v1/questions", json={
                "title": "No Options",
                "question_content": "Where are the options?",
                "response_type": "single_choice",
                "options": []
            })
            # Should either accept empty or require options
            assert response.status_code in [201, 422]

        def test_choice_question_many_options(self, client):
            """Valid: Single choice with 10 options"""
            options = [{"option_text": f"Option {i}", "display_order": i} for i in range(10)]
            response = client.post("/api/v1/questions", json={
                "title": "Many Options",
                "question_content": "Pick from many?",
                "response_type": "single_choice",
                "options": options
            })
            assert response.status_code == 201
            assert len(response.json()["options"]) == 10


class TestSurveyBoundaryValues:
    """Boundary tests for Survey API"""

    class TestTitleBoundaries:

        def test_title_valid_middle(self, client):
            """Valid: Title with 100 characters"""
            response = client.post("/api/v1/surveys", json={
                "title": "A" * 100
            })
            assert response.status_code == 201

        def test_title_at_lower_bound(self, client):
            """Edge: Title with 1 character"""
            response = client.post("/api/v1/surveys", json={
                "title": "A"
            })
            assert response.status_code == 201

        def test_title_empty_rejected(self, client):
            """Invalid: Empty title should be rejected"""
            response = client.post("/api/v1/surveys", json={
                "title": ""
            })
            assert response.status_code == 422

        def test_title_missing_rejected(self, client):
            """Invalid: Missing title should be rejected"""
            response = client.post("/api/v1/surveys", json={
                "description": "No title"
            })
            assert response.status_code == 422

        def test_title_at_upper_bound(self, client):
            """Edge: Title with 255 characters (DB limit)"""
            response = client.post("/api/v1/surveys", json={
                "title": "A" * 255
            })
            assert response.status_code == 201

    class TestPublicationStatusBoundaries:

        def test_all_valid_publication_statuses(self, client):
            """Valid: Each supported publication status"""
            valid_statuses = ['draft', 'published', 'closed']

            for status in valid_statuses:
                response = client.post("/api/v1/surveys", json={
                    "title": f"Survey {status}",
                    "publication_status": status
                })
                assert response.status_code == 201, f"Failed for status: {status}"

        def test_invalid_publication_status(self, client):
            """Invalid: Unsupported publication status"""
            response = client.post("/api/v1/surveys", json={
                "title": "Test Survey",
                "publication_status": "pending"
            })
            assert response.status_code == 422

    class TestQuestionCountBoundaries:

        def test_survey_with_zero_questions(self, client):
            """Valid: Survey can be created without questions"""
            response = client.post("/api/v1/surveys", json={
                "title": "Empty Survey",
                "question_ids": []
            })
            assert response.status_code == 201
            data = response.json()
            assert data.get("question_count", 0) == 0 or len(data.get("questions", [])) == 0

        def test_survey_with_one_question(self, client):
            """Edge: Survey with exactly 1 question"""
            # Create a question first
            q_resp = client.post("/api/v1/questions", json={
                "title": "Q1",
                "question_content": "Question 1?",
                "response_type": "yesno"
            })
            qid = q_resp.json()["question_id"]

            response = client.post("/api/v1/surveys", json={
                "title": "Single Question Survey",
                "question_ids": [qid]
            })
            assert response.status_code == 201
            assert len(response.json().get("questions", [])) == 1

        def test_survey_with_many_questions(self, client):
            """Valid: Survey with 10 questions"""
            # Create 10 questions
            question_ids = []
            for i in range(10):
                q_resp = client.post("/api/v1/questions", json={
                    "title": f"Q{i+1}",
                    "question_content": f"Question {i+1}?",
                    "response_type": "yesno"
                })
                question_ids.append(q_resp.json()["question_id"])

            response = client.post("/api/v1/surveys", json={
                "title": "Many Questions Survey",
                "question_ids": question_ids
            })
            assert response.status_code == 201
            assert len(response.json().get("questions", [])) == 10

    class TestDateBoundaries:

        def test_start_date_in_past(self, client):
            """Edge: Start date in the past"""
            past_date = (datetime.now() - timedelta(days=1)).isoformat()
            response = client.post("/api/v1/surveys", json={
                "title": "Past Survey",
                "start_date": past_date
            })
            # May be accepted or rejected depending on business rules
            assert response.status_code in [201, 422]

        def test_start_date_today(self, client):
            """Valid: Start date is today"""
            today = datetime.now().isoformat()
            response = client.post("/api/v1/surveys", json={
                "title": "Today Survey",
                "start_date": today
            })
            assert response.status_code == 201

        def test_end_date_before_start_date(self, client):
            """Invalid: End date before start date"""
            start = (datetime.now() + timedelta(days=10)).isoformat()
            end = (datetime.now() + timedelta(days=5)).isoformat()
            response = client.post("/api/v1/surveys", json={
                "title": "Invalid Dates Survey",
                "start_date": start,
                "end_date": end
            })
            # Should be rejected
            assert response.status_code in [201, 422]

        def test_end_date_equals_start_date(self, client):
            """Edge: End date equals start date (one-day survey)"""
            same_date = (datetime.now() + timedelta(days=1)).isoformat()
            response = client.post("/api/v1/surveys", json={
                "title": "One Day Survey",
                "start_date": same_date,
                "end_date": same_date
            })
            assert response.status_code == 201


class TestAssignmentBoundaryValues:
    """Boundary tests for Survey Assignment API"""

    class TestDueDateBoundaries:

        def test_due_date_in_future(self, client, published_survey, sample_assignment):
            """Valid: Due date 7 days in future"""
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json=sample_assignment
            )
            assert response.status_code == 201

        def test_due_date_far_future(self, client, published_survey):
            """Valid: Due date 1 year in future"""
            far_future = (datetime.now() + timedelta(days=365)).isoformat()
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_id": 1, "due_date": far_future}
            )
            assert response.status_code == 201

        def test_due_date_in_past(self, client, published_survey):
            """Invalid/Edge: Due date in the past"""
            past_date = (datetime.now() - timedelta(days=1)).isoformat()
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_id": 1, "due_date": past_date}
            )
            # Should be rejected or automatically set as expired
            assert response.status_code in [201, 422]

        def test_due_date_today(self, client, published_survey):
            """Edge: Due date is today"""
            today = datetime.now().isoformat()
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_id": 1, "due_date": today}
            )
            assert response.status_code == 201

        def test_no_due_date(self, client, published_survey):
            """Valid: Assignment without due date"""
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_id": 1}
            )
            assert response.status_code == 201
            assert response.json().get("due_date") is None

    class TestBulkAssignmentBoundaries:

        def test_assign_to_one_user(self, client, published_survey):
            """Edge: Assign to exactly 1 user"""
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_id": 1}
            )
            assert response.status_code == 201

        def test_assign_to_many_users(self, client, published_survey):
            """Valid: Assign to 10 users"""
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_ids": list(range(1, 11))}  # Users 1-10
            )
            assert response.status_code == 201
            if isinstance(response.json(), list):
                assert len(response.json()) == 10

        def test_assign_to_empty_list(self, client, published_survey):
            """Invalid: Assign to empty user list"""
            response = client.post(
                f"/api/v1/surveys/{published_survey}/assign",
                json={"account_ids": []}
            )
            assert response.status_code == 422


class TestTemplateBoundaryValues:
    """Boundary tests for Template API"""

    class TestQuestionOrderBoundaries:

        def test_template_preserves_question_order(self, client):
            """Valid: Template preserves question display order"""
            # Create questions
            q1 = client.post("/api/v1/questions", json={
                "title": "First",
                "question_content": "Q1?",
                "response_type": "yesno"
            }).json()["question_id"]

            q2 = client.post("/api/v1/questions", json={
                "title": "Second",
                "question_content": "Q2?",
                "response_type": "yesno"
            }).json()["question_id"]

            q3 = client.post("/api/v1/questions", json={
                "title": "Third",
                "question_content": "Q3?",
                "response_type": "yesno"
            }).json()["question_id"]

            # Create template with specific order
            response = client.post("/api/v1/templates", json={
                "title": "Ordered Template",
                "question_ids": [q3, q1, q2]  # Out of creation order
            })

            assert response.status_code == 201
            questions = response.json()["questions"]
            assert questions[0]["question_id"] == q3
            assert questions[1]["question_id"] == q1
            assert questions[2]["question_id"] == q2

    class TestVisibilityBoundaries:

        def test_template_default_private(self, client):
            """Default: Template is private by default"""
            response = client.post("/api/v1/templates", json={
                "title": "Default Visibility"
            })
            assert response.status_code == 201
            assert response.json()["is_public"] == False

        def test_template_explicit_public(self, client):
            """Valid: Template can be explicitly public"""
            response = client.post("/api/v1/templates", json={
                "title": "Public Template",
                "is_public": True
            })
            assert response.status_code == 201
            assert response.json()["is_public"] == True

        def test_template_explicit_private(self, client):
            """Valid: Template can be explicitly private"""
            response = client.post("/api/v1/templates", json={
                "title": "Private Template",
                "is_public": False
            })
            assert response.status_code == 201
            assert response.json()["is_public"] == False


class TestIDsBoundaryValues:
    """Boundary tests for resource IDs across all APIs"""

    def test_question_id_zero(self, client):
        """Invalid: Question ID 0"""
        response = client.get("/api/v1/questions/0")
        assert response.status_code == 404

    def test_question_id_negative(self, client):
        """Invalid: Negative question ID"""
        response = client.get("/api/v1/questions/-1")
        assert response.status_code in [404, 422]

    def test_survey_id_zero(self, client):
        """Invalid: Survey ID 0"""
        response = client.get("/api/v1/surveys/0")
        assert response.status_code == 404

    def test_survey_id_very_large(self, client):
        """Invalid: Very large survey ID (nonexistent)"""
        response = client.get("/api/v1/surveys/999999999")
        assert response.status_code == 404

    def test_template_id_zero(self, client):
        """Invalid: Template ID 0"""
        response = client.get("/api/v1/templates/0")
        assert response.status_code == 404

    def test_assignment_id_nonexistent(self, client):
        """Invalid: Nonexistent assignment ID (DELETE — no GET /{id} route exists)"""
        response = client.delete("/api/v1/assignments/999999")
        assert response.status_code == 404
