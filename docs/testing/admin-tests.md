# Admin API Tests

Documentation for admin API unit tests.

## Overview

Admin API tests cover:
- Password reset functionality
- Email sending
- User impersonation
- Session management

## Test Files

| File | Description |
|------|-------------|
| `test_admin_password_reset.py` | Password reset endpoint tests |
| `test_admin_impersonation.py` | Impersonation endpoint tests |
| `test_require_role.py` | require_role() auth dependency tests |
| `test_aggregation.py` | Aggregation service k-anonymity tests |
| `test_research.py` | Research API endpoint tests |
| `test_responses.py` | Response submission endpoint tests |

## Running Tests

```bash
cd backend

# Run all admin tests
pytest tests/test_admin_*.py -v

# Run specific test file
pytest tests/test_admin_password_reset.py -v

# Run with coverage
pytest tests/test_admin_*.py --cov=app.api.v1.admin -v
```

## Test Structure

### Fixtures

Common fixtures are defined in `conftest.py`:

```python
@pytest.fixture
def test_client():
    """Create test client with mocked database."""
    from app.main import app
    return TestClient(app)

@pytest.fixture
def mock_user_data():
    """Sample user data for testing."""
    return {
        "AccountID": 42,
        "FirstName": "John",
        ...
    }
```

### Mocking Strategy

Tests use `unittest.mock.patch` to mock:

1. **Database Connection** - `app.api.v1.admin.get_db_connection`
2. **Email Service** - `app.api.v1.admin.get_email_service`
3. **Token Hashing** - `app.api.v1.admin.hash_token`
4. **Auth Validation** - `app.api.v1.admin.get_admin_account_from_token`

Example:

```python
def test_reset_password_success(self, test_client, mock_user_data):
    with patch("app.api.v1.admin.get_db_connection") as mock_db:
        mock_cursor = MagicMock()
        mock_cursor.fetchone.return_value = mock_user_data

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_db.return_value = mock_conn

        response = test_client.post(
            "/api/v1/admin/users/42/reset-password",
            json={"new_password": "NewSecurePass123!"}
        )

        assert response.status_code == 200
```

## Password Reset Tests

### Test Cases

| Test | Description | Expected |
|------|-------------|----------|
| `test_reset_password_success` | Valid password reset | 200 OK |
| `test_reset_password_user_not_found` | Non-existent user | 404 |
| `test_reset_password_short_password` | Password < 8 chars | 400 |
| `test_reset_password_empty_password` | Empty password | 400 |

### Email Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_send_email_success` | Send to user email | 200 OK |
| `test_send_email_override_address` | Send to alternate email | 200 OK |
| `test_send_email_user_not_found` | Non-existent user | 404 |
| `test_send_email_service_not_configured` | No SMTP config | 503 |
| `test_send_email_failure` | SMTP error | 500 |

## Impersonation Tests

### Start Impersonation

| Test | Description | Expected |
|------|-------------|----------|
| `test_impersonate_success_as_system_admin` | System admin impersonates | 200 OK |
| `test_impersonate_forbidden_for_non_system_admin` | Non-admin tries | 403 |
| `test_impersonate_user_not_found` | Target doesn't exist | 404 |
| `test_impersonate_inactive_user_fails` | Target is inactive | 400 |
| `test_impersonate_self_fails` | Impersonate self | 400 |
| `test_impersonate_requires_authentication` | No session token | 401 |

### End Impersonation

| Test | Description | Expected |
|------|-------------|----------|
| `test_end_impersonation_success` | End active impersonation | 200 OK |
| `test_end_impersonation_not_impersonating` | No active impersonation | 400 |
| `test_end_impersonation_requires_authentication` | No session token | 401 |

### Session Info

| Test | Description | Expected |
|------|-------------|----------|
| `test_session_info_normal_session` | Regular session | `is_impersonating: false` |
| `test_session_info_impersonating` | Impersonation session | `is_impersonating: true` |

## require_role() Dependency Tests

File: `backend/tests/api/test_require_role.py`

Tests the `require_role()` factory in `app/api/deps.py` which provides role-based access control with admin impersonation support.

### Mocking Strategy

`require_role` involves two DB connections (one for `get_current_user`, one for the role check). Tests patch `app.api.deps.get_db_connection` with `side_effect` returning two separate mock connections. A `_mock_auth_and_role()` helper configures both.

### Role Access Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_researcher_allowed` | RoleID=2 on require_role(2, 4) | 200 |
| `test_admin_allowed` | RoleID=4 on require_role(2, 4) | 200 |
| `test_participant_denied` | RoleID=1 on require_role(2, 4) | 403 |
| `test_hcp_denied` | RoleID=3 on require_role(2, 4) | 403 |

### Impersonation Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_admin_impersonating_researcher_allowed` | ViewingAsUserID → researcher | 200, effective_role_id=2 |
| `test_admin_impersonating_participant_denied` | ViewingAsUserID → participant | 403 |

### Error Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_missing_token_returns_401` | No Authorization header | 401 |
| `test_invalid_token_returns_401` | Expired/invalid token | 401 |
| `test_db_error_in_role_check_returns_500` | mysql.connector.Error raised | 500 |

### Return Value Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_returns_effective_fields` | Verify enriched dict | effective_account_id, effective_role_id present |

```bash
# Run require_role tests
cd backend
pytest tests/api/test_require_role.py -v
```

## Response Submission Tests

File: `backend/tests/api/test_responses.py`

Tests the POST /api/v1/responses/ endpoint for participant survey response submission.

### Mocking Strategy

Tests patch both `app.api.deps.get_db_connection` (for auth) and `app.api.v1.responses.get_db_connection` (for endpoint logic). A `_mock_participant_auth()` helper sets up two mock connections for get_current_user + require_role(1).

### Auth Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_no_token_returns_401` | No Authorization header | 401 |
| `test_researcher_returns_403` | RoleID=2 on participant-only endpoint | 403 |
| `test_admin_returns_403` | RoleID=4 on participant-only endpoint | 403 |

### Success Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_valid_submission_returns_201` | Valid survey responses | 201, commit called |

### Validation Tests

| Test | Description | Expected |
|------|-------------|----------|
| `test_unpublished_survey_returns_400` | Draft survey | 400, "not published" |
| `test_unassigned_participant_returns_403` | Not assigned to survey | 403, "not assigned" |
| `test_question_not_in_survey_returns_400` | Question not in QuestionList | 400, "not in this survey" |
| `test_non_numeric_for_number_type_returns_422` | "abc" for number type | 422, "numeric" |
| `test_invalid_yesno_returns_422` | "maybe" for yesno type | 422, "yes/no" |
| `test_valid_single_choice_accepted` | Valid option from QuestionOptions | 201 |
| `test_invalid_single_choice_returns_422` | Option not in QuestionOptions | 422, "not a valid option" |

```bash
# Run response submission tests
cd backend
pytest tests/api/test_responses.py -v
```

## Adding New Tests

1. Create test class:

```python
class TestNewFeature:
    """Tests for new feature endpoint."""

    def test_success_case(self, test_client):
        with patch("app.api.v1.admin.get_db_connection") as mock_db:
            # Setup mocks
            # Make request
            # Assert response
```

2. Use descriptive test names:
   - `test_<action>_<condition>` format
   - e.g., `test_reset_password_user_not_found`

3. Test both success and failure paths

4. Mock all external dependencies

## Coverage Goals

Target coverage for admin module: **80%+**

Key areas to cover:
- All API endpoints
- Error handling paths
- Authorization checks
- Input validation
