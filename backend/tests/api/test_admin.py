# Created with the Assistance of Claude Code
"""
Comprehensive test suite for Admin API endpoints.

Tests cover:
- Helper functions: generate_temp_password
- POST /api/v1/admin/users - Create user with temp password
- POST /api/v1/admin/users/{user_id}/reset-password - Reset user password
- POST /api/v1/admin/users/{user_id}/send-reset-email - Send password reset email
- GET  /api/v1/admin/tables - List database tables
- GET  /api/v1/admin/tables/{name} - Get table schema and data
- GET  /api/v1/admin/tables/{name}/data - Get table data only
- GET /api/v1/admin/audit-logs
- GET /api/v1/admin/audit-logs/actions
- GET /api/v1/admin/audit-logs/resource-types
- DELETE /api/v1/admin/users/{user_id}/purge
"""

from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta

from app.api.v1.admin import generate_temp_password


# ============================================================================
# HELPER FUNCTION TESTS
# ============================================================================

class TestGenerateTempPassword:
    """Test the generate_temp_password helper function"""

    def test_generates_password_with_default_length(self):
        """Should generate 16-character password by default"""
        password = generate_temp_password()
        assert len(password) == 16

    def test_generates_password_with_custom_length(self):
        """Should generate password with specified length"""
        password = generate_temp_password(length=20)
        assert len(password) == 20

    def test_enforces_minimum_length(self):
        """Should enforce minimum length of 12 characters"""
        password = generate_temp_password(length=8)
        assert len(password) == 12

    def test_password_contains_required_character_types(self):
        """Should contain at least one uppercase, lowercase, digit, and special char"""
        # Run multiple times to account for randomness
        for _ in range(10):
            password = generate_temp_password()

            has_upper = any(c.isupper() for c in password)
            has_lower = any(c.islower() for c in password)
            has_digit = any(c.isdigit() for c in password)
            has_special = any(c in "!@#$%^&*" for c in password)

            assert has_upper, "Password should contain uppercase letter"
            assert has_lower, "Password should contain lowercase letter"
            assert has_digit, "Password should contain digit"
            assert has_special, "Password should contain special character"

    def test_generates_different_passwords(self):
        """Should generate unique passwords on each call (cryptographic randomness)"""
        passwords = [generate_temp_password() for _ in range(10)]
        # All passwords should be unique
        assert len(set(passwords)) == 10


# ============================================================================
# POST /api/v1/admin/users TESTS - Create User with Temp Password
# ============================================================================

class TestCreateUserWithTempPassword:
    """Tests for POST /api/v1/admin/users endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_password")
    def test_create_user_success(self, mock_hash, mock_db, client):
        """Should create new user with temporary password"""
        mock_hash.return_value = "hashed_password_12345"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None  # Email doesn't exist
        mock_cursor.lastrowid = 5

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        user_data = {
            "email": "alice@example.com",
            "first_name": "Alice",
            "last_name": "Johnson",
            "role_id": 1
        }

        response = client.post("/api/v1/admin/users", json=user_data)

        assert response.status_code == 201
        data = response.json()
        assert "User created successfully" in data["message"]
        assert data["email"] == "alice@example.com"
        assert data["first_name"] == "Alice"
        assert data["last_name"] == "Johnson"
        assert "temp_password" not in data  # password sent via email, not in response
        assert data["user_id"] == 5
        assert mock_conn.commit.called

    @patch("app.api.v1.admin.get_db_connection")
    def test_create_user_duplicate_email(self, mock_db, client):
        """Should return 409 when email already exists"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (1,)  # Email exists

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        user_data = {
            "email": "existing@example.com",
            "first_name": "Alice",
            "last_name": "Johnson",
            "role_id": 1
        }

        response = client.post("/api/v1/admin/users", json=user_data)

        assert response.status_code == 409
        data = response.json()
        assert "already registered" in data["detail"].lower()

    def test_create_user_invalid_email(self, client):
        """Should return 422 for invalid email format"""
        user_data = {
            "email": "not-an-email",
            "first_name": "Alice",
            "last_name": "Johnson",
            "role_id": 1
        }

        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 422

    def test_create_user_missing_required_fields(self, client):
        """Should return 422 when required fields are missing"""
        response = client.post("/api/v1/admin/users", json={"email": "test@example.com"})
        assert response.status_code == 422

    def test_create_user_empty_name_fields(self, client):
        """Should return 422 for empty name fields"""
        user_data = {
            "email": "alice@example.com",
            "first_name": "",
            "last_name": "Johnson",
            "role_id": 1
        }

        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 422

    def test_create_user_invalid_role_id(self, client):
        """Should return 422 for invalid role_id"""
        user_data = {
            "email": "alice@example.com",
            "first_name": "Alice",
            "last_name": "Johnson",
            "role_id": 10  # Invalid - must be 1-4
        }

        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 422

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_password")
    def test_create_user_default_role(self, mock_hash, mock_db, client):
        """Should use role_id=1 (participant) as default"""
        mock_hash.return_value = "hashed_password"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None
        mock_cursor.lastrowid = 5

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        user_data = {
            "email": "alice@example.com",
            "first_name": "Alice",
            "last_name": "Johnson"
            # role_id not provided - should default to 1
        }

        response = client.post("/api/v1/admin/users", json=user_data)

        assert response.status_code == 201
        data = response.json()
        assert data["role_id"] == 1

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_password")
    def test_create_user_with_birthdate_and_gender(self, mock_hash, mock_db, client):
        """Should accept optional birthdate and gender for participant accounts"""
        mock_hash.return_value = "hashed_password"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None
        mock_cursor.lastrowid = 7
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        user_data = {
            "email": "participant@example.com",
            "first_name": "Pat",
            "last_name": "Jones",
            "role_id": 1,
            "birthdate": "1990-05-15",
            "gender": "Female",
        }
        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 201
        # Confirm birthdate and gender were passed to the INSERT
        insert_call_args = mock_cursor.execute.call_args_list
        insert_sql = next(
            (str(c) for c in insert_call_args if "INSERT INTO AccountData" in str(c)),
            None,
        )
        assert insert_sql is not None
        assert "1990-05-15" in insert_sql
        assert "Female" in insert_sql

    def test_create_user_invalid_birthdate_format(self, client):
        """Should return 422 for birthdate not in YYYY-MM-DD format"""
        user_data = {
            "email": "p@example.com",
            "first_name": "P",
            "last_name": "Q",
            "role_id": 1,
            "birthdate": "15/05/1990",  # wrong format
        }
        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 422

    def test_create_user_invalid_gender(self, client):
        """Should return 422 for unrecognised gender value"""
        user_data = {
            "email": "p@example.com",
            "first_name": "P",
            "last_name": "Q",
            "role_id": 1,
            "gender": "NotAGender",
        }
        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 422

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_password")
    def test_create_user_birthdate_gender_optional(self, mock_hash, mock_db, client):
        """Should succeed when birthdate and gender are omitted"""
        mock_hash.return_value = "hashed_password"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None
        mock_cursor.lastrowid = 8
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        user_data = {
            "email": "noextra@example.com",
            "first_name": "No",
            "last_name": "Extra",
            "role_id": 1,
        }
        response = client.post("/api/v1/admin/users", json=user_data)
        assert response.status_code == 201


# ============================================================================
# POST /api/v1/admin/users/{user_id}/reset-password TESTS
# ============================================================================

class TestResetPassword:
    """Tests for POST /api/v1/admin/users/{user_id}/reset-password endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_password")
    def test_reset_password_success(self, mock_hash, mock_db, client):
        """Should reset password successfully"""
        mock_hash.return_value = "new_hashed_password"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (5,)  # AuthID

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/1/reset-password",
            json={"new_password": "NewSecurePassword123!"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "Password reset successfully"
        assert data["user_id"] == 1
        assert mock_conn.commit.called

    @patch("app.api.v1.admin.get_db_connection")
    def test_reset_password_user_not_found(self, mock_db, client):
        """Should return 404 when user doesn't exist"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/999/reset-password",
            json={"new_password": "NewSecurePassword123!"}
        )

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    def test_reset_password_too_short(self, client):
        """Should return 422 when password is too short"""
        response = client.post(
            "/api/v1/admin/users/1/reset-password",
            json={"new_password": "short"}
        )

        assert response.status_code == 422


# ============================================================================
# POST /api/v1/admin/users/{user_id}/send-reset-email TESTS
# ============================================================================

class TestSendResetEmail:
    """Tests for POST /api/v1/admin/users/{user_id}/send-reset-email endpoint"""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_send_reset_email_success(self, mock_db, mock_email_svc, client):
        """Should send password reset email successfully"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = ("John", "john@example.com")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        mock_email_svc.send_admin_password_reset_email.return_value = True

        response = client.post(
            "/api/v1/admin/users/1/send-reset-email",
            json={"temporary_password": "TempPass123!"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "Password reset email sent successfully"
        assert data["sent_to"] == "john@example.com"
        assert data["user_id"] == 1

    @patch("app.api.v1.admin.get_db_connection")
    def test_send_reset_email_user_not_found(self, mock_db, client):
        """Should return 404 when user doesn't exist"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/999/send-reset-email",
            json={"temporary_password": "TempPass123!"}
        )

        assert response.status_code == 404

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_send_reset_email_with_override(self, mock_db, mock_email_svc, client):
        """Should send to override email when provided"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = ("John", "john@example.com")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        mock_email_svc.send_admin_password_reset_email.return_value = True

        response = client.post(
            "/api/v1/admin/users/1/send-reset-email",
            json={
                "temporary_password": "TempPass123!",
                "email_override": "alternate@example.com"
            }
        )

        assert response.status_code == 200
        data = response.json()
        assert data["sent_to"] == "alternate@example.com"


# ============================================================================
# GET /api/v1/admin/tables TESTS
# ============================================================================

class TestListTables:
    """Tests for GET /api/v1/admin/tables endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_tables_success(self, mock_db, client):
        """Should return list of tables with schema info"""
        mock_cursor = MagicMock()

        # Mock column info query
        mock_cursor.fetchall.side_effect = [
            # Columns for first table
            [("AccountID", "int(11)", "PRI", "NO", "auto_increment"),
             ("Email", "varchar(255)", "", "NO", "")],
            # FK info
            [],
            # Columns for second iteration, etc.
        ]
        mock_cursor.fetchone.return_value = (10,)  # Row count

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables")

        assert response.status_code == 200
        data = response.json()
        assert "tables" in data


# ============================================================================
# GET /api/v1/admin/tables/{table_name} TESTS
# ============================================================================

class TestGetTable:
    """Tests for GET /api/v1/admin/tables/{table_name} endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_success(self, mock_db, client):
        """Should return table schema and data"""
        mock_cursor = MagicMock()

        # Mock for get_table_schema
        mock_cursor.fetchall.side_effect = [
            # Column info
            [("RoleID", "int(11)", "PRI", "NO", "auto_increment"),
             ("RoleName", "varchar(50)", "", "NO", "")],
            # FK info
            [],
            # Column names for data query
            [("RoleID",), ("RoleName",)],
            # Actual data
            [(1, "participant"), (2, "researcher"), (3, "admin")],
        ]
        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists check → table found
            (3,),  # Row count for schema
            (3,),  # Total count for data
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/Roles")

        assert response.status_code == 200
        data = response.json()
        assert "schema_info" in data
        assert "data" in data

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_not_allowed(self, mock_db, client):
        """Should return 404 for tables that do not exist in the database"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (0,)  # table_exists → not found

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/SensitiveTable")

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()


# ============================================================================
# GET /api/v1/admin/tables/{table_name}/data TESTS
# ============================================================================

class TestGetTableData:
    """Tests for GET /api/v1/admin/tables/{table_name}/data endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_success(self, mock_db, client):
        """Should return table data only"""
        mock_cursor = MagicMock()

        mock_cursor.fetchall.side_effect = [
            # Column names
            [("RoleID",), ("RoleName",)],
            # Data rows
            [(1, "participant"), (2, "researcher")],
        ]
        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists check → table found
            (2,),  # Total count
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/Roles/data")

        assert response.status_code == 200
        data = response.json()
        assert "columns" in data
        assert "rows" in data
        assert "total" in data

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_with_pagination(self, mock_db, client):
        """Should support limit and offset parameters"""
        mock_cursor = MagicMock()

        mock_cursor.fetchall.side_effect = [
            [("RoleID",), ("RoleName",)],
            [(2, "researcher")],
        ]
        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists check → table found
            (4,),  # Total count
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/Roles/data?limit=1&offset=1")

        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 4
        assert len(data["rows"]) == 1


# ============================================================================
class TestStartViewingAs:
    """Tests for POST /api/v1/admin/users/{user_id}/view-as endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_view_as_success(self, mock_hash_token, mock_db, client):
        """Should update session with ViewingAsUserID for system admin"""
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        # First call: get admin session
        # Second call: get target user
        mock_cursor.fetchone.side_effect = [
            {
                "SessionID": 1,
                "AccountID": 100,
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ViewingAsUserID": None,
                "RoleID": 4,  # System Admin
                "RoleName": "admin"
            },
            {
                "AccountID": 5,
                "FirstName": "John",
                "LastName": "Doe",
                "Email": "john@example.com",
                "IsActive": True,
                "RoleID": 1,
                "RoleName": "participant"
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/5/view-as",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "Now viewing as user"
        assert data["is_viewing_as"] is True
        assert data["viewed_user"]["user_id"] == 5
        assert data["viewed_user"]["role"] == "participant"
        assert mock_conn.commit.called

    def test_view_as_requires_auth(self, client):
        """Should return 401 when not authenticated"""
        response = client.post("/api/v1/admin/users/5/view-as")

        assert response.status_code == 401
        assert "authentication required" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_view_as_requires_system_admin(self, mock_hash_token, mock_db, client):
        """Should return 403 when user is not system admin"""
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1,
            "AccountID": 100,
            "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
            "ViewingAsUserID": None,
            "RoleID": 3,  # HCP, not system admin
            "RoleName": "hcp"
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/5/view-as",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 403
        assert "system administrator" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_cannot_view_as_self(self, mock_hash_token, mock_db, client):
        """Should return 400 when trying to view as yourself"""
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1,
            "AccountID": 5,  # Same as target
            "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
            "ViewingAsUserID": None,
            "RoleID": 4,
            "RoleName": "admin"
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/5/view-as",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 400
        assert "yourself" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_cannot_view_as_inactive_user(self, mock_hash_token, mock_db, client):
        """Should return 400 when trying to view as inactive user"""
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {
                "SessionID": 1,
                "AccountID": 100,
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ViewingAsUserID": None,
                "RoleID": 4,
                "RoleName": "admin"
            },
            {
                "AccountID": 5,
                "FirstName": "John",
                "LastName": "Doe",
                "Email": "john@example.com",
                "IsActive": False,  # Inactive user
                "RoleID": 1,
                "RoleName": "participant"
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/5/view-as",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 400
        assert "inactive" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_view_as_user_not_found(self, mock_hash_token, mock_db, client):
        """Should return 404 when target user doesn't exist"""
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {
                "SessionID": 1,
                "AccountID": 100,
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ViewingAsUserID": None,
                "RoleID": 4,
                "RoleName": "admin"
            },
            None  # User not found
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/999/view-as",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()


# ============================================================================
# POST /api/v1/admin/view-as/end TESTS (New Approach)
# ============================================================================

class TestEndViewingAs:
    """Tests for POST /api/v1/admin/view-as/end endpoint"""

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_end_view_as_success(self, mock_hash, mock_db, client):
        """Should clear ViewingAsUserID from session"""
        mock_hash.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1,
            "AccountID": 100,
            "ViewingAsUserID": 5,  # Currently viewing as user 5
            "ExpiresAt": datetime.utcnow() + timedelta(hours=1)
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/view-as/end",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "Returned to admin view"
        assert mock_conn.commit.called

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    def test_end_view_as_not_viewing(self, mock_hash, mock_db, client):
        """Should return 400 when not currently viewing as another user"""
        mock_hash.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1,
            "AccountID": 100,
            "ViewingAsUserID": None,  # Not viewing as anyone
            "ExpiresAt": datetime.utcnow() + timedelta(hours=1)
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/view-as/end",
            cookies={"session_token": "admin_token"}
        )

        assert response.status_code == 400
        assert "not currently viewing" in response.json()["detail"].lower()

    def test_end_view_as_requires_auth(self, client):
        """Should return 401 when not authenticated"""
        response = client.post("/api/v1/admin/view-as/end")

        assert response.status_code == 401


# ============================================================================
# GET /api/v1/admin/audit-logs TESTS
# ============================================================================

class TestGetAuditLogs:
    """Tests for GET /api/v1/admin/audit-logs endpoint"""
    @patch("app.api.v1.admin.get_db_connection")
    def test_get_audit_logs_success(self, mock_db, client):
        """Should return audit logs with correct fields"""
        mock_cursor = MagicMock()
        # Simulate two audit events
        mock_cursor.fetchone.side_effect = [
            {"total": 2},  # total count
        ]
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 1,
                "CreatedAt": datetime(2023, 1, 1, 12, 0, 0),
                "RequestID": "req-1",
                "ActorType": "admin",
                "ActorAccountID": 10,
                "IpAddress": b"\x7f\x00\x00\x01",
                "UserAgent": "test-agent",
                "HttpMethod": "GET",
                "Path": "/api/v1/resource",
                "Action": "view",
                "ResourceType": "User",
                "ResourceID": "5",
                "Status": "success",
                "HttpStatusCode": 200,
                "ErrorCode": None,
                "MetadataJSON": '{"foo": "bar"}',
                "ActorEmail": "admin@example.com",
                "ActorFirstName": "Alice",
                "ActorLastName": "Admin",
            },
            {
                "AuditEventID": 2,
                "CreatedAt": datetime(2023, 1, 2, 13, 0, 0),
                "RequestID": "req-2",
                "ActorType": "user",
                "ActorAccountID": 20,
                "IpAddress": b"\x7f\x00\x00\x02",
                "UserAgent": "test-agent-2",
                "HttpMethod": "POST",
                "Path": "/api/v1/resource",
                "Action": "edit",
                "ResourceType": "User",
                "ResourceID": "6",
                "Status": "failure",
                "HttpStatusCode": 400,
                "ErrorCode": "E123",
                "MetadataJSON": None,
                "ActorEmail": "user@example.com",
                "ActorFirstName": "Bob",
                "ActorLastName": "User",
            },
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 2
        assert data["limit"] == 50
        assert data["offset"] == 0
        assert len(data["events"]) == 2
        event1 = data["events"][0]
        assert event1["audit_event_id"] == 1
        assert event1["actor_email"] == "admin@example.com"
        assert event1["actor_name"] == "Alice Admin"
        assert event1["ip_address"] == "127.0.0.1"
        assert event1["metadata"] == {"foo": "bar"}
        event2 = data["events"][1]
        assert event2["audit_event_id"] == 2
        assert event2["actor_email"] == "user@example.com"
        assert event2["actor_name"] == "Bob User"
        assert event2["ip_address"] == "127.0.0.2"
        assert event2["metadata"] is None

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_audit_logs_with_filters(self, mock_db, client):
        """Should apply filters and pagination"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"total": 1},
        ]
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 3,
                "CreatedAt": datetime(2023, 2, 1, 10, 0, 0),
                "RequestID": "req-3",
                "ActorType": "admin",
                "ActorAccountID": 30,
                "IpAddress": b"\x7f\x00\x00\x03",
                "UserAgent": "agent-3",
                "HttpMethod": "DELETE",
                "Path": "/api/v1/delete",
                "Action": "delete",
                "ResourceType": "Survey",
                "ResourceID": "7",
                "Status": "success",
                "HttpStatusCode": 204,
                "ErrorCode": None,
                "MetadataJSON": None,
                "ActorEmail": "admin2@example.com",
                "ActorFirstName": "Carol",
                "ActorLastName": "Admin",
            },
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        params = {
            "action": "delete",
            "status": "success",
            "actor_account_id": 30,
            "resource_type": "Survey",
            "http_method": "DELETE",
            "search": "delete",
            "start_date": "2023-01-01",
            "end_date": "2023-12-31",
            "limit": 1,
            "offset": 0,
        }
        response = client.get("/api/v1/admin/audit-logs", params=params)
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 1
        assert data["limit"] == 1
        assert data["offset"] == 0
        assert len(data["events"]) == 1
        event = data["events"][0]
        assert event["action"] == "delete"
        assert event["status"] == "success"
        assert event["actor_account_id"] == 30
        assert event["resource_type"] == "Survey"
        assert event["http_method"] == "DELETE"

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_audit_logs_empty(self, mock_db, client):
        """Should return empty events list if no logs"""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"total": 0},
        ]
        mock_cursor.fetchall.return_value = []
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 0
        assert data["events"] == []

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_audit_logs_db_error(self, mock_db, client):
        """Should return 500 if database error occurs"""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB error")
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 500
        assert "database error" in response.json()["detail"].lower()


# ============================================================================
# GET /api/v1/admin/audit-logs/actions TESTS
# ============================================================================

class TestGetAuditLogActions:
    """Tests for GET /api/v1/admin/audit-logs/actions endpoint"""
    
    @patch("app.api.v1.admin.get_db_connection")
    def test_get_actions_success(self, mock_db, client):
        """Should return list of action types"""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = [
            ("view",),
            ("edit",),
            ("delete",),
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/actions")
        assert response.status_code == 200
        assert response.json() == ["view", "edit", "delete"]

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_actions_empty(self, mock_db, client):
        """Should return empty list if no actions"""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = []
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/actions")
        assert response.status_code == 200
        assert response.json() == []

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_actions_db_error(self, mock_db, client):
        """Should return 500 if database error occurs"""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.fetchall.side_effect = mysql.connector.Error("DB error")
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/actions")
        assert response.status_code == 500


# ============================================================================
# GET /api/v1/admin/audit-logs/resource-types TESTS
# ============================================================================

class TestGetAuditLogResourceTypes:
    """Tests for GET /api/v1/admin/audit-logs/resource-types endpoint"""
    @patch("app.api.v1.admin.get_db_connection")
    def test_get_resource_types_success(self, mock_db, client):
        """Should return list of resource types"""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = [
            ("User",),
            ("Survey",),
            ("AccountData",),
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/resource-types")
        assert response.status_code == 200
        assert response.json() == ["User", "Survey", "AccountData"]

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_resource_types_empty(self, mock_db, client):
        """Should return empty list if no resource types"""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = []
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/resource-types")
        assert response.status_code == 200
        assert response.json() == []

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_resource_types_db_error(self, mock_db, client):
        """Should return 500 if database error occurs"""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.fetchall.side_effect = mysql.connector.Error("DB error")
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs/resource-types")
        assert response.status_code == 500


# ============================================================================
# DELETE /api/v1/admin/users/{user_id}/purge TESTS
# ============================================================================

class TestPurgeUser:
    """Tests for DELETE /api/v1/admin/users/{user_id}/purge endpoint"""
    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_success(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should delete user and all related data for system admin"""
        mock_get_token.return_value = "admin_token"
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        
        # Session: valid, system admin
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            {"AccountID": 5, "AuthID": 10},  # Target user
        ]
        
        # Simulate rowcount for each delete
        def execute_side_effect(query, params=None):
            if "DELETE FROM Sessions" in query:
                mock_cursor.rowcount = 2
            elif "DELETE FROM Responses" in query:
                mock_cursor.rowcount = 3
            elif "DELETE FROM SurveyAssignment" in query:
                mock_cursor.rowcount = 1
            elif "DELETE FROM Account2FA" in query:
                mock_cursor.rowcount = 1
            elif "UPDATE AuditEvent" in query:
                mock_cursor.rowcount = 1
            elif "DELETE FROM AccountData" in query:
                mock_cursor.rowcount = 1
            elif "DELETE FROM Auth" in query:
                mock_cursor.rowcount = 1
            else:
                mock_cursor.rowcount = 0
        
        mock_cursor.execute.side_effect = execute_side_effect

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.delete("/api/v1/admin/users/5/purge", cookies={"session_token": "admin_token"})
        assert response.status_code == 200
        data = response.json()
        assert data["purged_user_id"] == 5
        assert data["deleted"]["Sessions"] == 2
        assert data["deleted"]["Responses"] == 3
        assert data["deleted"]["SurveyAssignment"] == 1
        assert data["deleted"]["Account2FA"] == 1
        assert data["deleted"]["AuditEventScrubbed"] == 1
        assert data["deleted"]["AccountData"] == 1
        assert data["deleted"]["Auth"] == 1
        assert mock_conn.commit.called

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_requires_auth(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should return 401 if not authenticated"""
        mock_get_token.return_value = None
        response = client.delete("/api/v1/admin/users/5/purge")
        assert response.status_code == 401
        assert "authentication required" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_requires_system_admin(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should return 403 if not system admin"""
        mock_get_token.return_value = "user_token"
        mock_hash_token.return_value = "hashed_token"
        mock_cursor = MagicMock()
        
        # Session: valid, not system admin
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 101, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 2},
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn
        response = client.delete("/api/v1/admin/users/5/purge", cookies={"session_token": "user_token"})
        assert response.status_code == 403
        assert "system administrator" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_not_found(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should return 404 if user does not exist"""
        mock_get_token.return_value = "admin_token"
        mock_hash_token.return_value = "hashed_token"
        mock_cursor = MagicMock()
        
        # Session: valid, system admin
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            None,  # Target user not found
        ]
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn
        response = client.delete("/api/v1/admin/users/999/purge", cookies={"session_token": "admin_token"})
        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_no_audit_scrub(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should not scrub audit metadata if scrub_audit_metadata is False"""
        mock_get_token.return_value = "admin_token"
        mock_hash_token.return_value = "hashed_token"
        
        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            {"AccountID": 5, "AuthID": 10},
        ]
        def execute_side_effect(query, params=None):
            if "UPDATE AuditEvent" in query:
                mock_cursor.rowcount = 0  # Should not be called
            else:
                mock_cursor.rowcount = 1
            
        mock_cursor.execute.side_effect = execute_side_effect
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn
        response = client.delete("/api/v1/admin/users/5/purge?scrub_audit_metadata=false", cookies={"session_token": "admin_token"})
        assert response.status_code == 200
        data = response.json()
        assert "AuditEventScrubbed" not in data["deleted"] or data["deleted"]["AuditEventScrubbed"] == 0

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_scrubs_audit_by_default(self, mock_get_token, mock_hash_token, mock_db, client):
        """Should scrub audit metadata by default when scrub_audit_metadata is not set to false"""
        mock_get_token.return_value = "admin_token"
        mock_hash_token.return_value = "hashed_token"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            {"AccountID": 5, "AuthID": 10},
        ]
        def execute_side_effect(query, params=None):
            if "UPDATE AuditEvent" in query:
                mock_cursor.rowcount = 2  # Simulate 2 audit events scrubbed
            else:
                mock_cursor.rowcount = 1

        mock_cursor.execute.side_effect = execute_side_effect
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn
        response = client.delete("/api/v1/admin/users/5/purge", cookies={"session_token": "admin_token"})
        assert response.status_code == 200
        data = response.json()
        assert data["deleted"].get("AuditEventScrubbed") == 2


# ============================================================================
# ADDITIONAL COVERAGE TESTS — table schema / data edge cases
# ============================================================================

class TestTableSchemaEdgeCases:
    """Cover lines 192 (sensitive col skip), 227 (no safe columns),
    247/250 (datetime/bytes in table data), 273 (get_table_schema in list_tables),
    302 (db error in get_table), 320/323-324 (get_table_data_only 404 + db error)."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_schema_skips_sensitive_columns(self, mock_db, client):
        """Line 192: sensitive columns are excluded from table schema."""
        mock_cursor = MagicMock()

        # table_exists check
        mock_cursor.fetchone.side_effect = [
            (1,),   # table_exists → True
            (5,),   # row_count for schema
            (10,),  # total count for data
        ]
        # columns_data for schema, fk_info, data columns, data rows
        mock_cursor.fetchall.side_effect = [
            # get_table_schema: COLUMNS query
            [("AuthID", "int", "PRI", "NO"), ("PasswordHash", "varchar", "", "NO")],
            # get_table_schema: FK query
            [],
            # get_table_data: COLUMNS query
            [("AuthID",), ("PasswordHash",)],
            # get_table_data: data rows
            [],
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/Auth")
        assert response.status_code == 200
        data = response.json()
        col_names = [c["name"] for c in data["schema_info"]["columns"]]
        assert "PasswordHash" not in col_names

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_no_safe_columns(self, mock_db, client):
        """Line 227: returns empty TableData when all columns are sensitive."""
        mock_cursor = MagicMock()

        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists
            (0,),  # row_count for schema
        ]
        mock_cursor.fetchall.side_effect = [
            # get_table_schema: COLUMNS query — only sensitive cols
            [("PasswordHash", "varchar", "", "NO")],
            # FK query
            [],
            # get_table_data: COLUMNS query — only sensitive cols
            [("PasswordHash",)],
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/Auth")
        assert response.status_code == 200
        data = response.json()
        assert data["data"]["columns"] == []
        assert data["data"]["rows"] == []

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_converts_datetime_and_bytes(self, mock_db, client):
        """Lines 247, 250: datetime → isoformat, bytes → hex."""
        mock_cursor = MagicMock()

        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists
            (1,),  # row_count for schema
            (1,),  # total count for data
        ]
        mock_cursor.fetchall.side_effect = [
            # schema COLUMNS
            [("EventID", "int", "PRI", "NO"), ("CreatedAt", "datetime", "", "YES"), ("IpAddr", "varbinary", "", "YES")],
            # FK
            [],
            # data COLUMNS
            [("EventID",), ("CreatedAt",), ("IpAddr",)],
            # data rows
            [(1, datetime(2026, 1, 15, 12, 0, 0), b'\x7f\x00\x00\x01')],
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/AuditEvent")
        assert response.status_code == 200
        rows = response.json()["data"]["rows"]
        assert rows[0]["CreatedAt"] == "2026-01-15T12:00:00"
        assert rows[0]["IpAddr"] == "7f000001"

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_db_error(self, mock_db, client):
        """Line 302: mysql.connector.Error in get_table → 500."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            (1,),  # table_exists
        ]
        import mysql.connector
        mock_cursor.fetchall.side_effect = mysql.connector.Error("fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/SomeTable")
        assert response.status_code == 500

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_only_not_found(self, mock_db, client):
        """Line 320: table not found in data-only endpoint → 404."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (0,)  # table_exists → False

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/NonExistent/data")
        assert response.status_code == 404

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_table_data_only_db_error(self, mock_db, client):
        """Lines 323-324: mysql.connector.Error in data-only → 500."""
        mock_cursor = MagicMock()
        import mysql.connector
        mock_cursor.fetchone.side_effect = mysql.connector.Error("fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables/SomeTable/data")
        assert response.status_code == 500

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_tables_includes_schemas(self, mock_db, client):
        """Line 273: get_table_schema called for each table in list_tables."""
        mock_cursor = MagicMock()

        # get_all_table_names
        call_count = [0]
        def fetchall_side(*a, **kw):
            call_count[0] += 1
            if call_count[0] == 1:
                return [("TableA",)]
            elif call_count[0] == 2:
                # COLUMNS for schema
                return [("ColA", "int", "PRI", "NO")]
            elif call_count[0] == 3:
                return []  # FK
            return []

        mock_cursor.fetchall.side_effect = fetchall_side
        mock_cursor.fetchone.return_value = (5,)  # row_count

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/tables")
        assert response.status_code == 200
        assert len(response.json()["tables"]) == 1


# ============================================================================
# CREATE USER ERROR PATHS — lines 481-482, 496-498
# ============================================================================

class TestCreateUserErrorPaths:
    """Cover email failure after commit (481-482) and DB error (496-498)."""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.hash_password")
    @patch("app.api.v1.admin.get_db_connection")
    def test_create_user_email_failure_still_succeeds(self, mock_db, mock_hash, mock_email_svc, client):
        """Lines 481-482: email failure after commit does not block account creation."""
        mock_hash.return_value = "hashed"
        mock_email_svc.send_account_created_email.side_effect = Exception("SMTP down")

        mock_cursor = MagicMock()
        # Check email not in use → None, insert Auth → lastrowid 1,
        # Check email again (for AccountData) → None
        mock_cursor.fetchone.return_value = None
        mock_cursor.lastrowid = 1

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/users", json={
            "email": "newuser@example.com",
            "first_name": "Test",
            "last_name": "User",
            "role_id": 1,
        })
        assert response.status_code == 201
        assert "created" in response.json()["message"].lower()

    @patch("app.api.v1.admin.hash_password")
    @patch("app.api.v1.admin.get_db_connection")
    def test_create_user_db_error(self, mock_db, mock_hash, client):
        """Lines 496-498: mysql.connector.Error → 500."""
        mock_hash.return_value = "hashed"

        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None  # email not in use
        mock_cursor.execute.side_effect = [
            None,  # check email
            mysql.connector.Error("db fail"),
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/users", json={
            "email": "newuser@example.com",
            "first_name": "Test",
            "last_name": "User",
            "role_id": 1,
        })
        assert response.status_code == 500


# ============================================================================
# PASSWORD RESET ERROR PATHS — lines 519, 589-590, 689
# ============================================================================

class TestPasswordResetErrorPaths:
    """Cover DB error paths in reset password and send reset email."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_reset_password_db_error(self, mock_db, client):
        """Lines 589-590: mysql.connector.Error in reset-password → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/1/reset-password",
            json={"new_password": "SecurePassword123!"},
        )
        assert response.status_code == 500

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_send_reset_email_db_error(self, mock_db, mock_email_svc, client):
        """Line 689: mysql.connector.Error in send-reset-email → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/users/1/send-reset-email",
            json={"temporary_password": "TempPass123!"},
        )
        assert response.status_code == 500


# ============================================================================
# VIEW-AS ERROR PATHS — lines 1127, 1133, 1212-1213
# ============================================================================

class TestViewAsErrorPaths:
    """Cover error paths in start_viewing_as."""

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_view_as_invalid_session(self, mock_db, mock_get_token, mock_hash, client):
        """Line 1127: invalid session → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/users/5/view-as")
        assert response.status_code == 401

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_view_as_expired_session(self, mock_db, mock_get_token, mock_hash, client):
        """Line 1133: expired session → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1, "AccountID": 999, "ExpiresAt": datetime.utcnow() - timedelta(hours=1),
            "ViewingAsUserID": None, "RoleID": 4, "RoleName": "admin",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/users/5/view-as")
        assert response.status_code == 401

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_view_as_db_error(self, mock_db, mock_get_token, mock_hash, client):
        """Lines 1212-1213: mysql.connector.Error → 500."""
        import mysql.connector
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/users/5/view-as")
        assert response.status_code == 500


# ============================================================================
# AUDIT LOG ERROR PATHS — lines 1369-1372, 1380-1381
# ============================================================================

class TestAuditLogEdgeCases:
    """Cover IPv4/IPv6 conversion and metadata JSON parsing edge cases."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_audit_log_ipv4_conversion(self, mock_db, client):
        """Line 1369: 4-byte IP → IPv4 string."""
        import socket
        mock_cursor = MagicMock()
        # count query
        mock_cursor.fetchone.return_value = {"total": 1}
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 1,
                "CreatedAt": datetime(2026, 1, 1),
                "RequestID": None,
                "ActorType": "user",
                "ActorAccountID": 1,
                "ActorEmail": "test@example.com",
                "ActorFirstName": "Test",
                "ActorLastName": "User",
                "IpAddress": socket.inet_pton(socket.AF_INET, "127.0.0.1"),
                "UserAgent": "Mozilla",
                "HttpMethod": "GET",
                "Path": "/test",
                "Action": "login",
                "ResourceType": "session",
                "ResourceID": "1",
                "Status": "success",
                "HttpStatusCode": 200,
                "ErrorCode": None,
                "MetadataJSON": None,
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        events = response.json()["events"]
        assert events[0]["ip_address"] == "127.0.0.1"

    @patch("app.api.v1.admin.get_db_connection")
    def test_audit_log_ipv6_conversion(self, mock_db, client):
        """Lines 1369-1370: 16-byte IP → IPv6 string."""
        import socket
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {"total": 1}
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 2,
                "CreatedAt": datetime(2026, 1, 1),
                "RequestID": None,
                "ActorType": "user",
                "ActorAccountID": 1,
                "ActorEmail": None,
                "ActorFirstName": None,
                "ActorLastName": None,
                "IpAddress": socket.inet_pton(socket.AF_INET6, "::1"),
                "UserAgent": None,
                "HttpMethod": "GET",
                "Path": "/test",
                "Action": "login",
                "ResourceType": "session",
                "ResourceID": None,
                "Status": "success",
                "HttpStatusCode": 200,
                "ErrorCode": None,
                "MetadataJSON": None,
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        events = response.json()["events"]
        assert events[0]["ip_address"] == "::1"

    @patch("app.api.v1.admin.get_db_connection")
    def test_audit_log_ip_conversion_error(self, mock_db, client):
        """Lines 1371-1372: exception in IP parsing → str fallback."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {"total": 1}
        # Use an integer for IpAddress — truthy, but len() raises TypeError,
        # triggering the except branch which does str(row["IpAddress"]).
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 3,
                "CreatedAt": datetime(2026, 1, 1),
                "RequestID": None,
                "ActorType": "user",
                "ActorAccountID": 1,
                "ActorEmail": None,
                "ActorFirstName": None,
                "ActorLastName": None,
                "IpAddress": 12345,  # not bytes — causes len() to raise
                "UserAgent": None,
                "HttpMethod": "GET",
                "Path": "/test",
                "Action": "login",
                "ResourceType": "session",
                "ResourceID": None,
                "Status": "success",
                "HttpStatusCode": 200,
                "ErrorCode": None,
                "MetadataJSON": None,
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        events = response.json()["events"]
        assert events[0]["ip_address"] == "12345"  # str fallback

    @patch("app.api.v1.admin.get_db_connection")
    def test_audit_log_bad_metadata_json(self, mock_db, client):
        """Lines 1380-1381: invalid metadata JSON → None."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {"total": 1}
        mock_cursor.fetchall.return_value = [
            {
                "AuditEventID": 4,
                "CreatedAt": datetime(2026, 1, 1),
                "RequestID": None,
                "ActorType": "user",
                "ActorAccountID": 1,
                "ActorEmail": None,
                "ActorFirstName": None,
                "ActorLastName": None,
                "IpAddress": None,
                "UserAgent": None,
                "HttpMethod": "GET",
                "Path": "/test",
                "Action": "login",
                "ResourceType": "session",
                "ResourceID": None,
                "Status": "success",
                "HttpStatusCode": 200,
                "ErrorCode": None,
                "MetadataJSON": "{{not valid json",
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        events = response.json()["events"]
        assert events[0]["metadata"] is None


# ============================================================================
# END VIEW-AS ERROR PATHS — lines 1510, 1516, 1554-1555
# ============================================================================

class TestEndViewAsErrorPaths:
    """Cover error paths in end_viewing_as."""

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_end_view_as_invalid_session(self, mock_db, mock_get_token, mock_hash, client):
        """Line 1510: session not found → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/view-as/end")
        assert response.status_code == 401

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_end_view_as_expired_session(self, mock_db, mock_get_token, mock_hash, client):
        """Line 1516: expired session → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1, "AccountID": 999, "ViewingAsUserID": 5,
            "ExpiresAt": datetime.utcnow() - timedelta(hours=1),
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/view-as/end")
        assert response.status_code == 401

    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    @patch("app.api.v1.admin.get_db_connection")
    def test_end_view_as_db_error(self, mock_db, mock_get_token, mock_hash, client):
        """Lines 1554-1555: mysql.connector.Error → 500."""
        import mysql.connector
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/view-as/end")
        assert response.status_code == 500


# ============================================================================
# PURGE USER ADDITIONAL — lines 1608, 1610, 1673, 1686-1688
# ============================================================================

class TestPurgeUserAdditional:
    """Cover additional purge-user edge cases."""

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_invalid_session(self, mock_get_token, mock_hash, mock_db, client):
        """Line 1608: invalid session token → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.delete("/api/v1/admin/users/5/purge")
        assert response.status_code == 401

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_expired_session(self, mock_get_token, mock_hash, mock_db, client):
        """Line 1610: expired session → 401."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "SessionID": 1, "AccountID": 100,
            "ExpiresAt": datetime.utcnow() - timedelta(hours=1), "RoleID": 4,
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.delete("/api/v1/admin/users/5/purge")
        assert response.status_code == 401

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_null_auth_id(self, mock_get_token, mock_hash, mock_db, client):
        """Line 1673: AuthID is None → Auth deleted count is 0."""
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            {"AccountID": 5, "AuthID": None},  # no auth
        ]
        mock_cursor.rowcount = 0

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.delete("/api/v1/admin/users/5/purge")
        assert response.status_code == 200
        assert response.json()["deleted"]["Auth"] == 0

    @patch("app.api.v1.admin.get_db_connection")
    @patch("app.api.v1.admin.hash_token")
    @patch("app.api.v1.admin.get_token")
    def test_purge_user_db_error(self, mock_get_token, mock_hash, mock_db, client):
        """Lines 1686-1688: mysql.connector.Error → 500, rollback called."""
        import mysql.connector
        mock_get_token.return_value = "token"
        mock_hash.return_value = "hashed"

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"SessionID": 1, "AccountID": 100, "ExpiresAt": datetime.utcnow() + timedelta(hours=1), "RoleID": 4},
            {"AccountID": 5, "AuthID": 10},
        ]
        # First execute is the session query (OK), then delete fails
        call_count = [0]
        def execute_side(*args, **kwargs):
            call_count[0] += 1
            if call_count[0] > 2:  # after the two SELECT queries
                raise mysql.connector.Error("DB fail")
        mock_cursor.execute.side_effect = execute_side

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.delete("/api/v1/admin/users/5/purge")
        assert response.status_code == 500
        assert mock_conn.rollback.called


# ============================================================================
# ACCOUNT REQUEST MANAGEMENT — lines 1741, 1786-1789, 1806-1807, 1845,
#     1907-1909, 1935, 1964-1966, 1973-1975
# ============================================================================

class TestListAccountRequests:
    """Tests for GET /api/v1/admin/account-requests."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_account_requests_success(self, mock_db, client):
        """Happy path: returns list of pending requests."""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = [
            {
                "RequestID": 1, "FirstName": "Jane", "LastName": "Doe",
                "Email": "jane@example.com", "RoleID": 1, "RoleName": "participant",
                "Birthdate": None, "Gender": "Female", "GenderOther": None,
                "Status": "pending", "AdminNotes": None,
                "ReviewedBy": None, "CreatedAt": datetime(2026, 1, 1),
                "ReviewedAt": None,
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/account-requests")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["email"] == "jane@example.com"

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_account_requests_invalid_status(self, mock_db, client):
        """Line 1741: invalid status param → 400."""
        response = client.get("/api/v1/admin/account-requests?status=bogus")
        assert response.status_code == 400

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_account_requests_db_error(self, mock_db, client):
        """Lines 1786-1789: mysql.connector.Error → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/account-requests")
        assert response.status_code == 500


class TestAccountRequestCount:
    """Tests for GET /api/v1/admin/account-requests/count."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_count_success(self, mock_db, client):
        """Happy path: returns count."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (3,)

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/account-requests/count")
        assert response.status_code == 200
        assert response.json()["count"] == 3

    @patch("app.api.v1.admin.get_db_connection")
    def test_count_db_error(self, mock_db, client):
        """Lines 1806-1807: mysql.connector.Error → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/account-requests/count")
        assert response.status_code == 500


class TestApproveAccountRequest:
    """Tests for POST /api/v1/admin/account-requests/{id}/approve."""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.hash_password")
    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_success(self, mock_db, mock_hash, mock_email_svc, client):
        """Happy path: approve a pending request."""
        mock_hash.return_value = "hashed"
        mock_email_svc.send_account_created_email.return_value = True

        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            # Account request
            {"RequestID": 1, "FirstName": "Jane", "LastName": "Doe",
             "Email": "jane@example.com", "RoleID": 1, "Birthdate": None,
             "Gender": "Female", "Status": "pending"},
            # Email not in use
            None,
        ]
        mock_cursor.lastrowid = 10

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/approve")
        assert response.status_code == 200
        data = response.json()
        assert "approved" in data["message"].lower()
        assert data["email"] == "jane@example.com"

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_not_found(self, mock_db, client):
        """Request not found → 404."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/999/approve")
        assert response.status_code == 404

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_already_approved(self, mock_db, client):
        """Already processed → 400."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "FirstName": "Jane", "LastName": "Doe",
            "Email": "j@example.com", "RoleID": 1, "Birthdate": None,
            "Gender": None, "Status": "approved",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/approve")
        assert response.status_code == 400

    @patch("app.api.v1.admin.hash_password")
    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_email_already_in_use(self, mock_db, mock_hash, client):
        """Line 1845: email already in AccountData → 409."""
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.fetchone.side_effect = [
            {"RequestID": 1, "FirstName": "Jane", "LastName": "Doe",
             "Email": "jane@example.com", "RoleID": 1, "Birthdate": None,
             "Gender": None, "Status": "pending"},
            (1,),  # email already in use
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/approve")
        assert response.status_code == 409

    @patch("app.api.v1.admin.hash_password")
    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_db_error(self, mock_db, mock_hash, client):
        """Lines 1907-1909: mysql.connector.Error → 500."""
        import mysql.connector
        mock_hash.return_value = "hashed"
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/approve")
        assert response.status_code == 500


class TestRejectAccountRequest:
    """Tests for POST /api/v1/admin/account-requests/{id}/reject."""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_success(self, mock_db, mock_email_svc, client):
        """Happy path: reject a pending request."""
        mock_email_svc.send_account_rejected_email.return_value = True

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "FirstName": "Jane", "Email": "jane@example.com",
            "Status": "pending",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/account-requests/1/reject",
            json={"admin_notes": "Reason"},
        )
        assert response.status_code == 200
        assert "rejected" in response.json()["message"].lower()

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_not_found(self, mock_db, client):
        """Not found → 404."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/999/reject")
        assert response.status_code == 404

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_already_processed(self, mock_db, client):
        """Line 1935: already processed → 400."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "FirstName": "Jane", "Email": "j@example.com",
            "Status": "rejected",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/reject")
        assert response.status_code == 400

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_email_failure_still_succeeds(self, mock_db, mock_email_svc, client):
        """Lines 1964-1966: email failure doesn't affect rejection."""
        mock_email_svc.send_account_rejected_email.side_effect = Exception("SMTP down")

        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "FirstName": "Jane", "Email": "jane@example.com",
            "Status": "pending",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/reject")
        assert response.status_code == 200

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_db_error(self, mock_db, client):
        """Lines 1973-1975: mysql.connector.Error → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/account-requests/1/reject")
        assert response.status_code == 500


# ============================================================================
# CONSENT RECORD — lines 2002-2048
# ============================================================================

class TestGetUserConsentRecord:
    """Tests for GET /api/v1/admin/users/{user_id}/consent."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_consent_record_success(self, mock_db, client):
        """Happy path: returns consent record with IPv4 conversion."""
        import socket
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "ConsentRecordID": 1,
            "AccountID": 5,
            "RoleID": 1,
            "ConsentVersion": "1.0",
            "DocumentLanguage": "en",
            "DocumentText": "I consent...",
            "SignatureName": "Jane Doe",
            "SignedAt": datetime(2026, 1, 15, 12, 0, 0),
            "IpAddress": socket.inet_pton(socket.AF_INET, "192.168.1.1"),
            "UserAgent": "Mozilla/5.0",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/users/5/consent")
        assert response.status_code == 200
        data = response.json()
        assert data["consent_record_id"] == 1
        assert data["ip_address"] == "192.168.1.1"
        assert data["signature_name"] == "Jane Doe"

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_consent_record_ipv6(self, mock_db, client):
        """IPv6 conversion in consent record."""
        import socket
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "ConsentRecordID": 2,
            "AccountID": 5,
            "RoleID": 1,
            "ConsentVersion": "1.0",
            "DocumentLanguage": "fr",
            "DocumentText": "Je consens...",
            "SignatureName": None,
            "SignedAt": datetime(2026, 2, 1),
            "IpAddress": socket.inet_pton(socket.AF_INET6, "::1"),
            "UserAgent": None,
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/users/5/consent")
        assert response.status_code == 200
        assert response.json()["ip_address"] == "::1"

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_consent_record_not_found(self, mock_db, client):
        """No consent record → null response."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/users/999/consent")
        assert response.status_code == 200
        assert response.json() is None

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_consent_record_no_ip(self, mock_db, client):
        """No IP address in consent record."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "ConsentRecordID": 3,
            "AccountID": 5,
            "RoleID": 1,
            "ConsentVersion": "1.0",
            "DocumentLanguage": "en",
            "DocumentText": "I consent...",
            "SignatureName": None,
            "SignedAt": datetime(2026, 1, 1),
            "IpAddress": None,
            "UserAgent": None,
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/users/5/consent")
        assert response.status_code == 200
        assert response.json()["ip_address"] is None

    @patch("app.api.v1.admin.get_db_connection")
    def test_get_consent_record_bad_ip_bytes(self, mock_db, client):
        """Bad IP bytes → ip_address is None (exception caught)."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "ConsentRecordID": 4,
            "AccountID": 5,
            "RoleID": 1,
            "ConsentVersion": "1.0",
            "DocumentLanguage": "en",
            "DocumentText": "I consent...",
            "SignatureName": None,
            "SignedAt": datetime(2026, 1, 1),
            "IpAddress": b'\x01\x02\x03',  # 3 bytes — invalid
            "UserAgent": None,
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/users/5/consent")
        assert response.status_code == 200
        assert response.json()["ip_address"] is None


# ============================================================================
# DELETION REQUESTS — lines 2074, 2082-2120, 2126-2136, 2149-2209, 2219-2259
# ============================================================================

class TestListDeletionRequests:
    """Tests for GET /api/v1/admin/deletion-requests."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_deletion_requests_success(self, mock_db, client):
        """Happy path: returns list of pending deletion requests."""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = [
            {
                "RequestID": 1, "AccountID": 5, "FirstName": "Jane",
                "LastName": "Doe", "Email": "jane@example.com",
                "Status": "pending", "AdminNotes": None,
                "ReviewedBy": None, "RequestedAt": datetime(2026, 3, 1),
                "ReviewedAt": None,
            }
        ]

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/deletion-requests")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["account_id"] == 5

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_deletion_requests_invalid_status(self, mock_db, client):
        """Line 2084: invalid status → 400."""
        response = client.get("/api/v1/admin/deletion-requests?status=bogus")
        assert response.status_code == 400

    @patch("app.api.v1.admin.get_db_connection")
    def test_list_deletion_requests_empty(self, mock_db, client):
        """Empty list when no requests."""
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = []

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/deletion-requests")
        assert response.status_code == 200
        assert response.json() == []


class TestDeletionRequestCount:
    """Tests for GET /api/v1/admin/deletion-requests/count."""

    @patch("app.api.v1.admin.get_db_connection")
    def test_count_success(self, mock_db, client):
        """Happy path."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = (2,)

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.get("/api/v1/admin/deletion-requests/count")
        assert response.status_code == 200
        assert response.json()["count"] == 2


class TestApproveDeletionRequest:
    """Tests for POST /api/v1/admin/deletion-requests/{id}/approve."""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_success(self, mock_db, mock_email, client):
        """Happy path: deletes account data and sends deletion email."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "AccountID": 5, "Status": "pending", "AuthID": 10,
            "FirstName": "Jane", "LastName": "Doe", "Email": "jane@example.com",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/deletion-requests/1/approve")
        assert response.status_code == 200
        data = response.json()
        assert data["account_id"] == 5
        assert mock_conn.commit.called
        mock_email.send_account_deletion_approved_email.assert_called_once_with(
            user_name="Jane", user_email="jane@example.com"
        )

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_not_found(self, mock_db, client):
        """Request not found → 404."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/deletion-requests/999/approve")
        assert response.status_code == 404

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_already_processed(self, mock_db, client):
        """Already approved → 409."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "AccountID": 5, "Status": "approved", "AuthID": 10,
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/deletion-requests/1/approve")
        assert response.status_code == 409

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_db_error(self, mock_db, client):
        """Lines 2204-2206: mysql.connector.Error → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/deletion-requests/1/approve")
        assert response.status_code == 500

    @patch("app.api.v1.admin.get_db_connection")
    def test_approve_deletes_all_deletion_requests_before_account(self, mock_db, client):
        """AccountDeletionRequest rows (including prior rejected ones) are deleted
        before AccountData to avoid FK constraint violations."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 2, "AccountID": 7, "Status": "pending", "AuthID": 15,
            "FirstName": "Bob", "LastName": "Smith", "Email": "bob@example.com",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post("/api/v1/admin/deletion-requests/2/approve")
        assert response.status_code == 200

        # Collect every SQL statement executed
        executed_sql = [call.args[0].strip() for call in mock_cursor.execute.call_args_list]

        # Find positions of the critical DELETE statements
        def find_stmt(fragment):
            for i, sql in enumerate(executed_sql):
                if fragment in sql:
                    return i
            return -1

        del_requests_idx = find_stmt("DELETE FROM AccountDeletionRequest")
        del_account_idx = find_stmt("DELETE FROM AccountData")

        assert del_requests_idx != -1, "DELETE FROM AccountDeletionRequest not executed"
        assert del_account_idx != -1, "DELETE FROM AccountData not executed"
        assert del_requests_idx < del_account_idx, (
            "AccountDeletionRequest must be deleted before AccountData "
            "to avoid FK constraint violation from prior rejected requests"
        )


class TestRejectDeletionRequest:
    """Tests for POST /api/v1/admin/deletion-requests/{id}/reject."""

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_success(self, mock_db, mock_email, client):
        """Happy path: reactivates account and sends rejection email with notes."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "AccountID": 5, "Status": "pending",
            "FirstName": "Jane", "Email": "jane@example.com",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/deletion-requests/1/reject",
            json={"admin_notes": "We need you"},
        )
        assert response.status_code == 200
        assert "rejected" in response.json()["message"].lower()
        assert mock_conn.commit.called
        mock_email.send_account_deletion_rejected_email.assert_called_once_with(
            user_name="Jane", user_email="jane@example.com", admin_notes="We need you"
        )

    @patch("app.api.v1.admin._email_service")
    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_success_no_notes(self, mock_db, mock_email, client):
        """Rejection without admin notes sends standard email (admin_notes=None)."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 2, "AccountID": 6, "Status": "pending",
            "FirstName": "Bob", "Email": "bob@example.com",
        }
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/deletion-requests/2/reject",
            json={},
        )
        assert response.status_code == 200
        mock_email.send_account_deletion_rejected_email.assert_called_once_with(
            user_name="Bob", user_email="bob@example.com", admin_notes=None
        )

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_not_found(self, mock_db, client):
        """Not found → 404."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = None

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/deletion-requests/999/reject",
            json={"admin_notes": "no"},
        )
        assert response.status_code == 404

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_already_processed(self, mock_db, client):
        """Already processed → 409."""
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = {
            "RequestID": 1, "AccountID": 5, "Status": "approved",
        }

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/deletion-requests/1/reject",
            json={"admin_notes": "nope"},
        )
        assert response.status_code == 409

    @patch("app.api.v1.admin.get_db_connection")
    def test_reject_db_error(self, mock_db, client):
        """Lines 2254-2256: mysql.connector.Error → 500."""
        import mysql.connector
        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("DB fail")

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = client.post(
            "/api/v1/admin/deletion-requests/1/reject",
            json={"admin_notes": "nope"},
        )
        assert response.status_code == 500


# =============================================================================
# Backup Endpoint Tests
# =============================================================================

class TestBackupEndpoints:
    """Tests for /api/v1/admin/backups endpoints."""

    def test_list_backups_empty(self, client, tmp_path, monkeypatch):
        """Should return empty list when no backup directories exist."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        response = client.get("/api/v1/admin/backups")
        assert response.status_code == 200
        assert response.json() == []

    def test_list_backups_with_files(self, client, tmp_path, monkeypatch):
        """Should return metadata for all .sql.gz files found."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        daily = tmp_path / "daily"
        daily.mkdir()
        (daily / "healthdatabase_2026-03-31_020000.sql.gz").write_bytes(b"x" * 1024)

        response = client.get("/api/v1/admin/backups")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["backup_type"] == "daily"
        assert data[0]["size_bytes"] == 1024
        assert "healthdatabase_2026-03-31_020000.sql.gz" in data[0]["filename"]

    def test_download_backup_success(self, client, tmp_path, monkeypatch):
        """Should serve the file with correct content-disposition header."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        manual = tmp_path / "manual"
        manual.mkdir()
        test_file = manual / "healthdatabase_2026-03-31_120000.sql.gz"
        test_file.write_bytes(b"fake-gzip-data")

        response = client.get(
            "/api/v1/admin/backups/manual/healthdatabase_2026-03-31_120000.sql.gz/download"
        )
        assert response.status_code == 200
        assert b"fake-gzip-data" in response.content
        assert "attachment" in response.headers.get("content-disposition", "")

    def test_download_backup_not_found(self, client, tmp_path, monkeypatch):
        """Should return 404 for a filename that does not exist."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        (tmp_path / "daily").mkdir()
        response = client.get(
            "/api/v1/admin/backups/daily/nonexistent.sql.gz/download"
        )
        assert response.status_code == 404

    def test_download_backup_invalid_type(self, client, tmp_path, monkeypatch):
        """Should return 400 for an unknown backup type."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        response = client.get(
            "/api/v1/admin/backups/badtype/file.sql.gz/download"
        )
        assert response.status_code == 400

    def test_download_backup_path_traversal(self, client, tmp_path, monkeypatch):
        """Should block path traversal attempts."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        response = client.get(
            "/api/v1/admin/backups/daily/../../../etc/passwd/download"
        )
        assert response.status_code in (400, 404)

    def test_trigger_backup_success(self, client, tmp_path, monkeypatch):
        """Should create a .sql.gz file and return 201 with BackupInfo."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        from unittest.mock import patch, MagicMock
        import gzip

        fake_sql = b"-- MySQL dump\nCREATE TABLE foo (id INT);"
        mock_proc = MagicMock()
        mock_proc.stdout = fake_sql

        with patch("app.api.v1.admin.subprocess.run", return_value=mock_proc):
            response = client.post("/api/v1/admin/backups/trigger")

        assert response.status_code == 201
        data = response.json()
        assert data["backup_type"] == "manual"
        assert data["filename"].startswith("manual/")
        assert data["size_bytes"] > 0

        # Verify the file actually exists and is valid gzip
        fname = data["filename"].split("/")[1]
        file_path = tmp_path / "manual" / fname
        assert file_path.exists()
        with gzip.open(file_path) as gz:
            assert gz.read() == fake_sql

    def test_trigger_backup_mysqldump_failure(self, client, tmp_path, monkeypatch):
        """Should return 500 when mysqldump exits non-zero."""
        monkeypatch.setattr("app.api.v1.admin._BACKUPS_ROOT", tmp_path)
        from unittest.mock import patch
        import subprocess

        with patch(
            "app.api.v1.admin.subprocess.run",
            side_effect=subprocess.CalledProcessError(1, "mysqldump", stderr=b"access denied"),
        ):
            response = client.post("/api/v1/admin/backups/trigger")

        assert response.status_code == 500
        assert "mysqldump" in response.json()["detail"].lower() or "backup" in response.json()["detail"].lower()
