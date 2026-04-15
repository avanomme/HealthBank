import pytest
from fastapi import status
from app.main import app
from app.api.deps import get_current_user

class TestResponsesRBAC:
	"""
	RBAC tests for /api/v1/responses/ endpoints.
	Only participants (role_id=1) should be allowed to submit responses.
	"""
	@pytest.mark.parametrize("role_id", [1, 2, 3])
	def test_submit_responses_role_restriction(self, client, role_id):
		def fake_user():
			return {
				"account_id": 100,
				"email": f"test{role_id}@example.com",
				"tos_accepted_at": "2026-01-01",
				"tos_version": "1.0",
				"role_id": role_id,
				"viewing_as_user_id": None,
				"effective_account_id": 100,
				"effective_role_id": role_id,
			}
		app.dependency_overrides[get_current_user] = fake_user

		# Minimal valid payload (survey_id and responses must exist in test DB)
		payload = {
			"survey_id": 1,
			"responses": [
				{"question_id": 1, "response_value": "yes"}
			]
		}
		response = client.post("/api/v1/responses/", json=payload)

		if role_id == 1:
			# Participant should be allowed (may get 404/400 if survey doesn't exist, but not 403)
			assert response.status_code != status.HTTP_403_FORBIDDEN, "Participant should have access"
		else:
			# Non-participants should be forbidden
			assert response.status_code == status.HTTP_403_FORBIDDEN, f"Role {role_id} should be forbidden"

		app.dependency_overrides.pop(get_current_user, None)

class TestTemplatesRBAC:
    """
    RBAC tests for /api/v1/templates/ endpoints.
    Only researchers (role_id=2) and admins (role_id=4) should be allowed.
    """
    @pytest.mark.parametrize("method,path,body", [
        ("post", "/api/v1/templates", {"title": "T1", "description": "D1", "is_public": False}),
        ("get", "/api/v1/templates", None),
        ("get", "/api/v1/templates/1", None),
        ("put", "/api/v1/templates/1", {"title": "T2", "description": "D2", "is_public": True}),
        ("delete", "/api/v1/templates/1", None),
        ("post", "/api/v1/templates/1/duplicate", None),
    ])
    @pytest.mark.parametrize("role_id", [1, 2, 3, 4])
    def test_templates_rbac(self, client, method, path, body, role_id):
        def fake_user():
            return {
                "account_id": 100,
                "email": f"test{role_id}@example.com",
                "tos_accepted_at": "2026-01-01",
                "tos_version": "1.0",
                "role_id": role_id,
                "viewing_as_user_id": None,
                "effective_account_id": 100,
                "effective_role_id": role_id,
            }
        app.dependency_overrides[get_current_user] = fake_user

        req = getattr(client, method)
        if body is not None:
            response = req(path, json=body)
        else:
            response = req(path)

        if role_id in (2, 4):
            # Researchers and admins should be allowed (may get 404/400 if resource doesn't exist, but not 403)
            assert response.status_code != status.HTTP_403_FORBIDDEN, f"Role {role_id} should have access to {method.upper()} {path}"
        else:
            assert response.status_code == status.HTTP_403_FORBIDDEN, f"Role {role_id} should be forbidden for {method.upper()} {path}"

        app.dependency_overrides.pop(get_current_user, None)

class TestSurveysRBAC:
    """
    RBAC tests for /api/v1/surveys/ endpoints.
    Only researchers (role_id=2) and admins (role_id=4) should be allowed.
    """
    @pytest.mark.parametrize("method,path,body", [
        ("post", "/api/v1/surveys", {"title": "S1", "description": "D1"}),
        ("post", "/api/v1/surveys/from-template/1", None),
        ("get", "/api/v1/surveys", None),
        ("get", "/api/v1/surveys/1", None),
        ("put", "/api/v1/surveys/1", {"title": "S2", "description": "D2"}),
        ("delete", "/api/v1/surveys/1", None),
        ("patch", "/api/v1/surveys/1/publish", None),
        ("patch", "/api/v1/surveys/1/close", None),
    ])
    @pytest.mark.parametrize("role_id", [1, 2, 3, 4])
    def test_surveys_rbac(self, client, method, path, body, role_id):
        def fake_user():
            return {
                "account_id": 100,
                "email": f"test{role_id}@example.com",
                "tos_accepted_at": "2026-01-01",
                "tos_version": "1.0",
                "role_id": role_id,
                "viewing_as_user_id": None,
                "effective_account_id": 100,
                "effective_role_id": role_id,
            }
        app.dependency_overrides[get_current_user] = fake_user

        req = getattr(client, method)
        if body is not None:
            response = req(path, json=body)
        else:
            response = req(path)

        if role_id in (2, 4):
            # Researchers and admins should be allowed (may get 404/400 if resource doesn't exist, but not 403)
            assert response.status_code != status.HTTP_403_FORBIDDEN, f"Role {role_id} should have access to {method.upper()} {path}"
        else:
            assert response.status_code == status.HTTP_403_FORBIDDEN, f"Role {role_id} should be forbidden for {method.upper()} {path}"

        app.dependency_overrides.pop(get_current_user, None)

class TestUsersRBAC:
    """
    RBAC tests for /api/v1/users/ endpoints.
    Only admins (role_id=4) should be allowed.
    """
    @pytest.mark.parametrize("method,path,body", [
        ("get", "/api/v1/users", None),
        ("get", "/api/v1/users/1", None),
        ("post", "/api/v1/users", {"first_name": "Test", "last_name": "User", "email": "test@example.com", "password": "password123"}),
        ("put", "/api/v1/users/1", {"first_name": "Updated", "last_name": "User"}),
        ("patch", "/api/v1/users/1/status", {"is_active": False}),
        ("delete", "/api/v1/users/1", None),
    ])
    @pytest.mark.parametrize("role_id", [1, 2, 3, 4])
    def test_users_rbac(self, client, method, path, body, role_id):
        def fake_user():
            return {
                "account_id": 100,
                "email": f"test{role_id}@example.com",
                "tos_accepted_at": "2026-01-01",
                "tos_version": "1.0",
                "role_id": role_id,
                "viewing_as_user_id": None,
                "effective_account_id": 100,
                "effective_role_id": role_id,
            }
        app.dependency_overrides[get_current_user] = fake_user

        req = getattr(client, method)
        if body is not None:
            response = req(path, json=body)
        else:
            response = req(path)

        if role_id == 4:
            # Admins should be allowed (may get 404/400 if resource doesn't exist, but not 403)
            assert response.status_code != status.HTTP_403_FORBIDDEN, f"Admin should have access to {method.upper()} {path}"
        else:
            assert response.status_code == status.HTTP_403_FORBIDDEN, f"Role {role_id} should be forbidden for {method.upper()} {path}"

        app.dependency_overrides.pop(get_current_user, None)