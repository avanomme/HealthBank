# Created with the assistance of GitHub Co-Pilot
"""
Tests for User API endpoints in app/api/v1/users.py.

Tests cover:
- POST /api/v1/users              - Create user
- PUT /api/v1/users/{id}          - Update user
- GET /api/v1/users               - List users
- GET /api/v1/users/{id}          - Get single user
- PATCH /api/v1/users/{id}/status - Toggle user active status
- DELETE /api/v1/users/{id}       - Delete user
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app
from ..mocks.db import FakeCursor

# ==================================
# POST /api/v1/users
# ==================================

class TestCreateUser:

	def test_create_user_success(self, client, reset_fake_db_state):
		"""Should create a user successfully with valid data"""
		user_data = {
			"first_name": "Alice",
			"last_name": "Smith",
			"email": "alice@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 201
		data = resp.json()
		assert data["first_name"] == "Alice"
		assert data["last_name"] == "Smith"
		assert data["email"] == "alice@example.com"
		assert data["role"] == "participant"
		assert data["is_active"] is True
		assert "account_id" in data

	def test_create_user_duplicate_email(self, client, reset_fake_db_state):
		"""Should return 400 if email already exists"""
		user_data = {
			"first_name": "Bob",
			"last_name": "Jones",
			"email": "bob@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		resp1 = client.post("/api/v1/users", json=user_data)
		assert resp1.status_code == 201
		resp2 = client.post("/api/v1/users", json=user_data)
		assert resp2.status_code == 409
		assert "already registered" in resp2.json()["detail"].lower()

	@pytest.mark.parametrize(
		"user_data,missing_field",
		[
			({"last_name": "Smith", "email": "a@example.com", "password": "StrongPass123!"}, "first_name"),
			({"first_name": "Alice", "email": "a@example.com", "password": "StrongPass123!"}, "last_name"),
			({"first_name": "Alice", "last_name": "Smith", "password": "StrongPass123!"}, "email"),
			({"first_name": "Alice", "last_name": "Smith", "email": "a@example.com"}, "password"),
		]
	)
	def test_create_user_missing_required(self, client, user_data, missing_field):
		"""Should return 422 if required field is missing"""
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 422
		assert missing_field in resp.text

	def test_create_user_invalid_email(self, client):
		"""Should return 422 for invalid email format"""
		user_data = {
			"first_name": "Alice",
			"last_name": "Smith",
			"email": "not-an-email",
			"password": "StrongPass123!"
		}
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 422
		assert "email" in resp.text.lower()

	def test_create_user_short_password(self, client):
		"""Should return 422 for password too short"""
		user_data = {
			"first_name": "Alice",
			"last_name": "Smith",
			"email": "alice2@example.com",
			"password": "short"
		}
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 422
		assert "password" in resp.text.lower()

	def test_create_user_defaults(self, client, reset_fake_db_state):
		"""Should default role to participant and is_active to True if not provided"""
		user_data = {
			"first_name": "Eve",
			"last_name": "Doe",
			"email": "eve@example.com",
			"password": "StrongPass123!"
		}
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 201
		data = resp.json()
		assert data["role"] == "participant"
		assert data["is_active"] is True

	def test_create_user_no_password_without_send_email_fails(self, client):
		"""Should return 422 when password is missing and send_setup_email is false"""
		user_data = {
			"first_name": "Alice",
			"last_name": "Smith",
			"email": "alice3@example.com",
			"send_setup_email": False,
		}
		resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 422

	def test_create_user_send_setup_email_no_password_required(
		self, client, reset_fake_db_state
	):
		"""Should create user without password when send_setup_email is True"""
		from unittest.mock import patch, MagicMock
		with patch(
			"app.api.v1.users._email_service"
		) as mock_svc:
			mock_svc.send_account_created_email.return_value = True
			user_data = {
				"first_name": "Carol",
				"last_name": "White",
				"email": "carol@example.com",
				"send_setup_email": True,
			}
			resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 201
		data = resp.json()
		assert data["email"] == "carol@example.com"

	def test_create_user_send_setup_email_calls_email_service(
		self, client, reset_fake_db_state
	):
		"""Should call email service when send_setup_email is True"""
		from unittest.mock import patch, MagicMock
		with patch(
			"app.api.v1.users._email_service"
		) as mock_svc:
			mock_svc.send_account_created_email.return_value = True
			user_data = {
				"first_name": "Dave",
				"last_name": "Brown",
				"email": "dave@example.com",
				"send_setup_email": True,
			}
			resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 201
		mock_svc.send_account_created_email.assert_called_once()
		call_kwargs = mock_svc.send_account_created_email.call_args
		assert call_kwargs.kwargs.get("user_email") == "dave@example.com"

	def test_create_user_email_failure_does_not_rollback(
		self, client, reset_fake_db_state
	):
		"""Account should still be created even if email service raises an exception"""
		from unittest.mock import patch, MagicMock
		with patch(
			"app.api.v1.users._email_service"
		) as mock_svc:
			mock_svc.send_account_created_email.side_effect = Exception("SMTP error")
			user_data = {
				"first_name": "Eve",
				"last_name": "Green",
				"email": "eve2@example.com",
				"send_setup_email": True,
			}
			resp = client.post("/api/v1/users", json=user_data)
		# Account created despite email failure
		assert resp.status_code == 201

	def test_create_user_no_email_sent_when_send_setup_email_false(
		self, client, reset_fake_db_state
	):
		"""Should NOT call email service when send_setup_email is False"""
		from unittest.mock import patch, MagicMock
		with patch(
			"app.api.v1.users._email_service"
		) as mock_svc:
			mock_svc.send_account_created_email.return_value = True
			user_data = {
				"first_name": "Frank",
				"last_name": "Black",
				"email": "frank@example.com",
				"password": "StrongPass123!",
				"send_setup_email": False,
			}
			resp = client.post("/api/v1/users", json=user_data)
		assert resp.status_code == 201
		mock_svc.send_account_created_email.assert_not_called()

# ==================================
# PUT /api/v1/users/{user_id} Tests
# ==================================

class TestUpdateUser:
	"""Tests for PUT /api/v1/users/{user_id} endpoint"""
	def test_update_user_success(self, client, mock_db, reset_fake_db_state):
		"""Should update user successfully when valid data is provided (using in-memory mock DB)"""
		# Arrange: create a user in the mock DB
		user_data = {
			"first_name": "Alice",
			"last_name": "Johnson",
			"email": "alice@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		# Print all account info before update
		print('All accounts before update:', dict(FakeCursor.accounts))

		# Act: update the user's last name and role
		update_data = {
			"last_name": "Smith",
			"role": "researcher"
		}
		resp = client.put(f"/api/v1/users/{user_id}", json=update_data)

		# Print all account info after update
		print('All accounts after update:', dict(FakeCursor.accounts))

		assert resp.status_code == 200
		updated = resp.json()
		assert updated["last_name"] == "Smith"
		assert updated["role"] == "researcher"

	def test_update_user_not_found(self, client):
		"""Should return 404 if user does not exist (negative control: use real user, should fail)"""
		# Create a user to get a real user_id
		user_data = {
			"first_name": "Test",
			"last_name": "User",
			"email": "testuser404@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]
		update_data = {"last_name": "Smith"}
		
        # Change the user ID so it tries to update a user that doesn't exist
		resp = client.put(f"/api/v1/users/{user_id+1}", json=update_data)

		assert resp.status_code == 404
		assert "not found" in resp.json()["detail"].lower()

	def test_update_user_email_already_in_use(self, client):
		"""Should return 400 if email is already in use by another user"""
		# Arrange: create two users
		user1 = {
			"first_name": "Bob",
			"last_name": "Jones",
			"email": "bob@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		user2 = {
			"first_name": "Carol",
			"last_name": "White",
			"email": "carol@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		resp1 = client.post("/api/v1/users", json=user1)
		resp2 = client.post("/api/v1/users", json=user2)
		assert resp1.status_code == 201
		assert resp2.status_code == 201
		user1_id = resp1.json()["account_id"]
		user2_id = resp2.json()["account_id"]

		# Act: try to update user2's email to user1's email
		update_data = {"email": "bob@example.com"}
		resp = client.put(f"/api/v1/users/{user2_id}", json=update_data)
		assert resp.status_code == 400
		assert "already in use" in resp.json()["detail"].lower()

# ==================
# GET /api/v1/users
# ==================

class TestUserList:

	def test_get_users(self, mock_db):
		"""
		Tests the GET /api/v1/users endpoint to ensure it returns a list of users with correct structure and data.
		Sets up multiple fake users in the mock database, sends a GET request, and asserts:
		- The response status code is 200.
		- The response contains a "users" key with a list of users.
		- The list contains all users with expected emails.
		- The response contains a "total" key with the correct count.
		"""
		FakeCursor.accounts = {
			"testuser@example.com": {
				"account_id": 1,
				"first_name": "Test",
				"last_name": "User",
				"email": "testuser@example.com",
				"role_id": 1,
				"is_active": True
			},
			"seconduser@example.com": {
				"account_id": 2,
				"first_name": "Second",
				"last_name": "User",
				"email": "seconduser@example.com",
				"role_id": 2,
				"is_active": False
			},
			"thirduser@example.com": {
				"account_id": 3,
				"first_name": "Third",
				"last_name": "User",
				"email": "thirduser@example.com",
				"role_id": 1,
				"is_active": True
			}
		}
		client = TestClient(app)
		response = client.get("/api/v1/users")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		assert len(data["users"]) == 3
		emails = {u["email"] for u in data["users"]}
		assert "testuser@example.com" in emails
		assert "seconduser@example.com" in emails
		assert "thirduser@example.com" in emails
		assert "total" in data
		assert data["total"] == 3

	@pytest.mark.parametrize(
		"role,expected_emails,expected_total",
		[
			("participant", ["participant1@example.com", "participant2@example.com"], 2),
			("researcher", ["researcher1@example.com"], 1),
			("admin", ["admin1@example.com"], 1),
		]
	)
	def test_role_filter(self, mock_db, role, expected_emails, expected_total):
		"""
		Parameterized test for GET /api/v1/users?role=... returns only users with the specified role.
		Sets up multiple users with different roles and asserts only users with the given role are returned.
		"""
		FakeCursor.accounts = {
			"participant1@example.com": {
				"account_id": 1,
				"first_name": "Alice",
				"last_name": "Participant",
				"email": "participant1@example.com",
				"role_id": 1,
				"is_active": True
			},
			"researcher1@example.com": {
				"account_id": 2,
				"first_name": "Bob",
				"last_name": "Researcher",
				"email": "researcher1@example.com",
				"role_id": 2,
				"is_active": True
			},
			"participant2@example.com": {
				"account_id": 3,
				"first_name": "Carol",
				"last_name": "Participant",
				"email": "participant2@example.com",
				"role_id": 1,
				"is_active": False
			},
			"admin1@example.com": {
				"account_id": 4,
				"first_name": "Dave",
				"last_name": "Admin",
				"email": "admin1@example.com",
				"role_id": 4,
				"is_active": True
			}
		}
		client = TestClient(app)
		response = client.get(f"/api/v1/users?role={role}")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		emails = {u["email"] for u in data["users"]}
		for email in expected_emails:
			assert email in emails
		# Ensure only expected emails are present
		assert set(emails) == set(expected_emails)
		assert "total" in data
		assert data["total"] == expected_total

	@pytest.mark.parametrize(
		"is_active,expected_emails,expected_total",
		[
			(True, ["active1@example.com", "active2@example.com"], 2),
			(False, ["inactive1@example.com"], 1),
		]
	)
	def test_is_active_filter(self, mock_db, is_active, expected_emails, expected_total):
		"""
		Parameterized test for GET /api/v1/users?is_active=... returns only users with the specified active status.
		Sets up multiple users with different is_active values and asserts only users with the given status are returned.
		"""
		FakeCursor.accounts = {
			"active1@example.com": {
				"account_id": 1,
				"first_name": "Active",
				"last_name": "One",
				"email": "active1@example.com",
				"role_id": 1,
				"is_active": True
			},
			"inactive1@example.com": {
				"account_id": 2,
				"first_name": "Inactive",
				"last_name": "One",
				"email": "inactive1@example.com",
				"role_id": 2,
				"is_active": False
			},
			"active2@example.com": {
				"account_id": 3,
				"first_name": "Active",
				"last_name": "Two",
				"email": "active2@example.com",
				"role_id": 1,
				"is_active": True
			}
		}
		client = TestClient(app)
		response = client.get(f"/api/v1/users?is_active={str(is_active).lower()}")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		emails = {u["email"] for u in data["users"]}
		for email in expected_emails:
			assert email in emails
		# Ensure only expected emails are present
		assert set(emails) == set(expected_emails)
		assert "total" in data
		assert data["total"] == expected_total

	@pytest.mark.parametrize(
		"search,expected_emails,expected_total",
		[
			("Alice", ["alice@example.com"], 1),
			("Bob", ["bob@example.com"], 1),
			("example.com", ["alice@example.com", "bob@example.com", "carol@example.com"], 3),
			("Carol", ["carol@example.com"], 1),
			("Nonexistent", [], 0),
		]
	)
	def test_search_filter(self, mock_db, search, expected_emails, expected_total):
		"""
		Parameterized test for GET /api/v1/users?search=... returns only users matching the search term in name or email.
		"""
		FakeCursor.accounts = {
			"alice@example.com": {
				"account_id": 1,
				"first_name": "Alice",
				"last_name": "Smith",
				"email": "alice@example.com",
				"role_id": 1,
				"is_active": True
			},
			"bob@example.com": {
				"account_id": 2,
				"first_name": "Bob",
				"last_name": "Jones",
				"email": "bob@example.com",
				"role_id": 2,
				"is_active": True
			},
			"carol@example.com": {
				"account_id": 3,
				"first_name": "Carol",
				"last_name": "White",
				"email": "carol@example.com",
				"role_id": 1,
				"is_active": False
			}
		}
		client = TestClient(app)
		response = client.get(f"/api/v1/users?search={search}")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		emails = {u["email"] for u in data["users"]}
		for email in expected_emails:
			assert email in emails
		assert set(emails) == set(expected_emails)
		assert "total" in data
		assert data["total"] == expected_total

	@pytest.mark.parametrize(
		"limit,expected_count",
		[
			(1, 1),
			(2, 2),
			(500, 3),  # Only 3 users in mock, so max returns all
		]
	)
	def test_limit_filter(self, mock_db, limit, expected_count):
		"""
		Test GET /api/v1/users?limit=... returns at most 'limit' users, respecting min/max bounds.
		"""
		FakeCursor.accounts = {
			f"user{i}@example.com": {
				"account_id": i,
				"first_name": f"User{i}",
				"last_name": f"Test{i}",
				"email": f"user{i}@example.com",
				"role_id": 1,
				"is_active": True
			} for i in range(1, 4)
		}
		client = TestClient(app)
		response = client.get(f"/api/v1/users?limit={limit}")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		# Should return at most 'limit' users, but not more than available
		assert len(data["users"]) == expected_count

	@pytest.mark.parametrize("invalid_limit", [-5, 0, 501, 1000])
	def test_invalid_limit(self, mock_db, invalid_limit):
		"""
		Test GET /api/v1/users?limit=... returns 422 for invalid limits (less than 1 or greater than 500).
		"""
		FakeCursor.accounts = {
			f"user{i}@example.com": {
				"account_id": i,
				"first_name": f"User{i}",
				"last_name": f"Test{i}",
				"email": f"user{i}@example.com",
				"role_id": 1,
				"is_active": True
			} for i in range(1, 4)
		}
		client = TestClient(app)
		response = client.get(f"/api/v1/users?limit={invalid_limit}")
		assert response.status_code == 422

	def test_offset(self, mock_db):
		"""
		Test GET /api/v1/users?offset=... returns users starting from the specified offset.
		"""
		FakeCursor.accounts = {
			f"user{i}@example.com": {
				"account_id": i,
				"first_name": f"User{i}",
				"last_name": f"Test{i}",
				"email": f"user{i}@example.com",
				"role_id": 1,
				"is_active": True
			} for i in range(1, 6)
		}
		client = TestClient(app)
		# Offset 0: all users
		response = client.get("/api/v1/users?offset=0")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		assert len(data["users"]) == 5
		# Offset 2: should skip first 2 users
		response = client.get("/api/v1/users?offset=2")
		assert response.status_code == 200
		data = response.json()
		assert len(data["users"]) == 3
		emails = [u["email"] for u in data["users"]]
		assert emails == [f"user{i}@example.com" for i in range(3, 6)]
		# Offset 4: should return last user only
		response = client.get("/api/v1/users?offset=4")
		assert response.status_code == 200
		data = response.json()
		assert len(data["users"]) == 1
		assert data["users"][0]["email"] == "user5@example.com"
		# Offset >= total: should return empty list
		response = client.get("/api/v1/users?offset=5")
		assert response.status_code == 200
		data = response.json()
		assert len(data["users"]) == 0

	def test_combined_filters(self, mock_db):
		"""
		Test GET /api/v1/users with combination of role, is_active, and search filters.
		Should return only users matching all criteria.
		"""
		FakeCursor.accounts = {
			"alice@example.com": {
				"account_id": 1,
				"first_name": "Alice",
				"last_name": "Smith",
				"email": "alice@example.com",
				"role_id": 1,
				"is_active": True
			},
			"bob@example.com": {
				"account_id": 2,
				"first_name": "Bob",
				"last_name": "Jones",
				"email": "bob@example.com",
				"role_id": 2,
				"is_active": True
			},
			"carol@example.com": {
				"account_id": 3,
				"first_name": "Carol",
				"last_name": "White",
				"email": "carol@example.com",
				"role_id": 1,
				"is_active": False
			},
			"dave@example.com": {
				"account_id": 4,
				"first_name": "Dave",
				"last_name": "Smith",
				"email": "dave@example.com",
				"role_id": 1,
				"is_active": True
			}
		}
		client = TestClient(app)
		# role=participant, is_active=true, search="Smith" should return Alice and Dave
		response = client.get("/api/v1/users?role=participant&is_active=true&search=Smith")
		assert response.status_code == 200
		data = response.json()
		assert "users" in data
		assert isinstance(data["users"], list)
		emails = {u["email"] for u in data["users"]}
		assert emails == {"alice@example.com", "dave@example.com"}
		assert "total" in data
		assert data["total"] == 2

# ==================================
# GET /api/v1/users/{id}
# ==================================

class TestSingleUser:

	def test_get_single_user_success(self, client, reset_fake_db_state):
		"""Should return user data for a valid user ID"""
		user_data = {
			"first_name": "Alice",
			"last_name": "Smith",
			"email": "alice@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		resp = client.get(f"/api/v1/users/{user_id}")
		assert resp.status_code == 200
		data = resp.json()
		assert data["account_id"] == user_id
		assert data["first_name"] == "Alice"
		assert data["last_name"] == "Smith"
		assert data["email"] == "alice@example.com"
		assert data["role"] == "participant"
		assert data["is_active"] is True

	def test_get_single_user_not_found(self, client, reset_fake_db_state):
		"""Should return 404 if user does not exist"""
		resp = client.get("/api/v1/users/9999")
		assert resp.status_code == 404
		assert "not found" in resp.json()["detail"].lower()

# ==================================
# PATCH /api/v1/users/{id}/status
# ==================================

class TestToggleUserStatus:

	def test_toggle_user_status_activate(self, client, reset_fake_db_state):
		"""Should activate a user (set is_active=True)"""
		user_data = {
			"first_name": "Bob",
			"last_name": "Inactive",
			"email": "bobinactive@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": False
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		resp = client.patch(f"/api/v1/users/{user_id}/status?is_active=true")
		assert resp.status_code == 200
		data = resp.json()
		assert data["account_id"] == user_id
		assert data["is_active"] is True

	def test_toggle_user_status_deactivate(self, client, reset_fake_db_state):
		"""Should deactivate a user (set is_active=False)"""
		user_data = {
			"first_name": "Carol",
			"last_name": "Active",
			"email": "carolactive@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		resp = client.patch(f"/api/v1/users/{user_id}/status?is_active=false")
		assert resp.status_code == 200
		data = resp.json()
		assert data["account_id"] == user_id
		assert data["is_active"] is False

	def test_toggle_user_status_user_not_found(self, client, reset_fake_db_state):
		"""Should return 404 if user does not exist"""
		resp = client.patch("/api/v1/users/9999/status?is_active=true")
		assert resp.status_code == 404
		assert "not found" in resp.json()["detail"].lower()

	def test_cannot_deactivate_own_account(self, client, reset_fake_db_state):
		"""Admin cannot deactivate their own account — mock user is account_id=999."""
		resp = client.patch("/api/v1/users/999/status?is_active=false")
		assert resp.status_code == 400
		assert "deactivate your own account" in resp.json()["detail"].lower()

	def test_can_activate_own_account(self, client, reset_fake_db_state):
		"""Activating own account is allowed (no harm in re-activating yourself)."""
		FakeCursor.accounts["self@example.com"] = {
			"account_id": 999,
			"first_name": "Self",
			"last_name": "Admin",
			"email": "self@example.com",
			"role_id": 4,
			"auth_id": 1,
			"is_active": True,
		}
		resp = client.patch("/api/v1/users/999/status?is_active=true")
		assert resp.status_code == 200

# ==================================
# DELETE /api/v1/users/{id}
# ==================================

class TestDeleteUser:

	def test_delete_user_success(self, client, reset_fake_db_state):
		"""Should delete a user successfully and return 204"""
		user_data = {
			"first_name": "Eve",
			"last_name": "Doe",
			"email": "eve@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		resp = client.delete(f"/api/v1/users/{user_id}")
		assert resp.status_code == 204

		# Confirm user is deleted
		get_resp = client.get(f"/api/v1/users/{user_id}")
		assert get_resp.status_code == 404

	def test_delete_user_not_found(self, client, reset_fake_db_state):
		"""Should return 404 if user does not exist"""
		resp = client.delete("/api/v1/users/9999")
		assert resp.status_code == 404
		assert "not found" in resp.json()["detail"].lower()

	def test_delete_own_account_forbidden(self, client, reset_fake_db_state):
		"""Should return 400 if trying to delete own account (admin self-delete forbidden)"""
		# The mock auth user has account_id=999 (see conftest.py)
		# Create a user with account_id=999
		FakeCursor.accounts["admin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "admin@example.com",
			"role_id": 4,
			"is_active": True
		}
		resp = client.delete("/api/v1/users/999")
		assert resp.status_code == 400
		assert "cannot delete your own account" in resp.json()["detail"].lower()


# ==================================
# DELETE /api/v1/users/{id} — data-preservation guarantees
# ==================================

class TestDeleteUserPreservesData:

	def test_response_data_anonymised_not_deleted(self, client, reset_fake_db_state):
		"""Survey responses must survive deletion with ParticipantID set to NULL."""
		# Create a participant
		create_resp = client.post("/api/v1/users", json={
			"first_name": "Test",
			"last_name": "Subject",
			"email": "subject@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True,
		})
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		# Seed a mock response row linked to this participant
		FakeCursor.responses.append({
			"ResponseID": 1,
			"SurveyID": 10,
			"QuestionID": 5,
			"ParticipantID": user_id,
			"ResponseValue": "42",
		})

		resp = client.delete(f"/api/v1/users/{user_id}")
		assert resp.status_code == 204

		# Response row must still exist but ParticipantID must be NULL
		assert len(FakeCursor.responses) == 1
		assert FakeCursor.responses[0]["ParticipantID"] is None
		assert FakeCursor.responses[0]["ResponseValue"] == "42"

	def test_account_removed_after_deletion(self, client, reset_fake_db_state):
		"""AccountData row must be gone after deletion."""
		create_resp = client.post("/api/v1/users", json={
			"first_name": "Gone",
			"last_name": "User",
			"email": "gone@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True,
		})
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		client.delete(f"/api/v1/users/{user_id}")

		get_resp = client.get(f"/api/v1/users/{user_id}")
		assert get_resp.status_code == 404

	def test_survey_creator_nullified_not_deleted(self, client, reset_fake_db_state):
		"""Survey rows created by the deleted user must survive with CreatorID = NULL."""
		create_resp = client.post("/api/v1/users", json={
			"first_name": "Creator",
			"last_name": "User",
			"email": "creator@example.com",
			"password": "StrongPass123!",
			"role": "researcher",
			"is_active": True,
		})
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		# Seed a mock survey owned by this user
		FakeCursor.surveys[99] = {
			"SurveyID": 99,
			"Title": "My Survey",
			"CreatorID": user_id,
		}

		resp = client.delete(f"/api/v1/users/{user_id}")
		assert resp.status_code == 204

		# Survey still exists with nullified creator
		assert 99 in FakeCursor.surveys
		assert FakeCursor.surveys[99]["CreatorID"] is None


# ==================================
# PUT /api/v1/users/me — self-update
# ==================================

class TestUpdateCurrentUser:

	def test_update_me_first_name(self, client, reset_fake_db_state):
		"""PUT /api/v1/users/me should update the authenticated user's first name."""
		# Seed the mock admin account so the DB lookup finds it
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}

		resp = client.put("/api/v1/users/me", json={"first_name": "NewFirst"})
		assert resp.status_code == 200
		data = resp.json()
		assert data["first_name"] == "NewFirst"

	def test_update_me_email_change(self, client, reset_fake_db_state):
		"""PUT /api/v1/users/me with email change succeeds if email is available."""
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}

		resp = client.put("/api/v1/users/me", json={"email": "newemail@example.com"})
		assert resp.status_code == 200

	def test_update_me_email_conflict(self, client, reset_fake_db_state):
		"""PUT /api/v1/users/me should return 400 if email is taken by another user."""
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}
		FakeCursor.accounts["taken@example.com"] = {
			"account_id": 888,
			"first_name": "Other",
			"last_name": "User",
			"email": "taken@example.com",
			"role_id": 1,
			"is_active": True,
		}

		resp = client.put("/api/v1/users/me", json={"email": "taken@example.com"})
		assert resp.status_code == 400
		assert "already in use" in resp.json()["detail"].lower()

	def test_update_me_user_not_found(self, client, reset_fake_db_state):
		"""PUT /api/v1/users/me should return 404 if user record missing."""
		# Don't seed account 999
		resp = client.put("/api/v1/users/me", json={"first_name": "Ghost"})
		assert resp.status_code == 404

	def test_update_me_birthdate_and_gender(self, client, reset_fake_db_state):
		"""PUT /api/v1/users/me can update birthdate and gender."""
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}

		resp = client.put("/api/v1/users/me", json={
			"birthdate": "1990-05-15",
			"gender": "female",
		})
		assert resp.status_code == 200


# ==================================
# PUT /api/v1/users/{id} — admin update (additional coverage)
# ==================================

class TestAdminUpdateUserExtra:

	def test_admin_update_user_role_and_active(self, client, reset_fake_db_state):
		"""Admin updating role and is_active fields (lines 425-446)."""
		user_data = {
			"first_name": "Target",
			"last_name": "User",
			"email": "target@example.com",
			"password": "StrongPass123!",
			"role": "participant",
			"is_active": True,
		}
		create_resp = client.post("/api/v1/users", json=user_data)
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		resp = client.put(f"/api/v1/users/{user_id}", json={
			"role": "researcher",
			"is_active": False,
		})
		assert resp.status_code == 200
		data = resp.json()
		assert data["role"] == "researcher"
		assert data["is_active"] is False

	def test_admin_update_email_conflict(self, client, reset_fake_db_state):
		"""Admin update should return 400 when email already taken (line 419)."""
		u1 = client.post("/api/v1/users", json={
			"first_name": "A", "last_name": "B",
			"email": "a@test.com", "password": "StrongPass123!",
		})
		u2 = client.post("/api/v1/users", json={
			"first_name": "C", "last_name": "D",
			"email": "c@test.com", "password": "StrongPass123!",
		})
		assert u1.status_code == 201
		assert u2.status_code == 201

		uid2 = u2.json()["account_id"]
		resp = client.put(f"/api/v1/users/{uid2}", json={"email": "a@test.com"})
		assert resp.status_code == 400
		assert "already in use" in resp.json()["detail"].lower()


# ==================================
# DELETE /api/v1/users/{id} — DB error branch (lines 599-600)
# ==================================

class TestDeleteUserDbError:

	def test_delete_user_db_error(self, client, reset_fake_db_state):
		"""When a mysql.connector.Error occurs during delete, should return 500 (lines 598-600)."""
		import mysql.connector
		from unittest.mock import patch as _patch, MagicMock as _MagicMock

		# Create user first
		create_resp = client.post("/api/v1/users", json={
			"first_name": "ErrUser",
			"last_name": "Test",
			"email": "erruser@test.com",
			"password": "StrongPass123!",
		})
		assert create_resp.status_code == 201
		user_id = create_resp.json()["account_id"]

		# Patch get_db_connection to return a cursor that errors on the
		# session nullification step (mid-transaction)
		mock_conn = _MagicMock()
		mock_cursor = _MagicMock()
		# First call: SELECT AccountID, AuthID (success)
		# Second call: UPDATE Sessions SET ImpersonatedBy (raise)
		mock_cursor.fetchone.return_value = (user_id, 1)
		call_count = [0]
		def side_effect_execute(query, params=None):
			call_count[0] += 1
			if call_count[0] == 1:
				return  # SELECT succeeds
			raise mysql.connector.Error("db error during delete")
		mock_cursor.execute = side_effect_execute
		mock_conn.cursor.return_value = mock_cursor

		with _patch("app.api.v1.users.get_db_connection", return_value=mock_conn):
			resp = client.delete(f"/api/v1/users/{user_id}")
		assert resp.status_code == 500


# ==================================
# Additional coverage tests for missing lines
# ==================================

class TestUserCreateValidators:

	def test_create_user_empty_name_after_strip(self, client):
		"""Line 58: Name cannot be empty (whitespace-only)."""
		resp = client.post("/api/v1/users", json={
			"first_name": "   ",
			"last_name": "User",
			"email": "empty@example.com",
			"password": "StrongPass123!",
		})
		assert resp.status_code == 422


class TestAsUtcHelper:

	def test_as_utc_naive_datetime(self):
		"""Line 111: _as_utc marks naive datetime as UTC."""
		from app.api.v1.users import _as_utc
		from datetime import datetime, timezone
		dt = datetime(2026, 1, 1, 12, 0, 0)
		result = _as_utc(dt)
		assert result.tzinfo == timezone.utc

	def test_as_utc_none(self):
		"""_as_utc returns None for None."""
		from app.api.v1.users import _as_utc
		assert _as_utc(None) is None

	def test_as_utc_aware_datetime(self):
		"""_as_utc leaves aware datetime unchanged."""
		from app.api.v1.users import _as_utc
		from datetime import datetime, timezone
		dt = datetime(2026, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
		result = _as_utc(dt)
		assert result is dt


class TestUpdateCurrentUserExtra:

	def test_update_me_no_fields(self, client, reset_fake_db_state):
		"""Line 378: Empty update body with no fields to update."""
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}
		resp = client.put("/api/v1/users/me", json={})
		assert resp.status_code == 200

	def test_update_me_last_name(self, client, reset_fake_db_state):
		"""Lines 363-364: Update last_name via PUT /users/me."""
		FakeCursor.accounts["testadmin@example.com"] = {
			"account_id": 999,
			"first_name": "Admin",
			"last_name": "User",
			"email": "testadmin@example.com",
			"role_id": 4,
			"is_active": True,
		}
		resp = client.put("/api/v1/users/me", json={"last_name": "NewLast"})
		assert resp.status_code == 200
		assert resp.json()["last_name"] == "NewLast"


class TestAdminUpdateRoleOnly:

	def test_update_user_role_only(self, client, reset_fake_db_state):
		"""Lines 426-427: Update only the role field."""
		create_resp = client.post("/api/v1/users", json={
			"first_name": "RoleTest",
			"last_name": "User",
			"email": "roletest@example.com",
			"password": "StrongPass123!",
			"role": "participant",
		})
		assert create_resp.status_code == 201
		uid = create_resp.json()["account_id"]

		resp = client.put(f"/api/v1/users/{uid}", json={"role": "admin"})
		assert resp.status_code == 200
		assert resp.json()["role"] == "admin"

	def test_update_user_is_active_only(self, client, reset_fake_db_state):
		"""Lines 444-446: Update only is_active."""
		create_resp = client.post("/api/v1/users", json={
			"first_name": "ActiveTest",
			"last_name": "User",
			"email": "activetest@example.com",
			"password": "StrongPass123!",
		})
		assert create_resp.status_code == 201
		uid = create_resp.json()["account_id"]

		resp = client.put(f"/api/v1/users/{uid}", json={"is_active": False})
		assert resp.status_code == 200
		assert resp.json()["is_active"] is False


class TestFetchUserByIdNotFound:

	def test_fetch_user_by_id_not_found(self):
		"""Line 632: fetch_user_by_id raises 404 for missing user."""
		from app.api.v1.users import fetch_user_by_id
		from fastapi import HTTPException
		import pytest

		with pytest.raises(HTTPException) as exc_info:
			fetch_user_by_id(999999)
		assert exc_info.value.status_code == 404