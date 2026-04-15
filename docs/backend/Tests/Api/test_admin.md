# Admin API Endpoint Tests (`tests/.../admin` suite)

## Overview

This module is a comprehensive pytest suite for **Admin API** functionality, covering:

- Helper: `generate_temp_password`
- User administration:
  - `POST /api/v1/admin/users` (create user with temp password)
  - `POST /api/v1/admin/users/{user_id}/reset-password`
  - `POST /api/v1/admin/users/{user_id}/send-reset-email`
- Database inspection:
  - `GET /api/v1/admin/tables`
  - `GET /api/v1/admin/tables/{name}`
  - `GET /api/v1/admin/tables/{name}/data`
- Privileged session modes:
  - Impersonation:
    - `POST /api/v1/admin/users/{user_id}/impersonate`
    - `POST /api/v1/admin/impersonate/end`
  - “View-as” (newer approach):
    - `POST /api/v1/admin/users/{user_id}/view-as`
    - `POST /api/v1/admin/view-as/end`

The suite uses FastAPI’s `TestClient` and relies heavily on mocking database connections and external services.

---

## Architecture / Design

### Test organization

The file is partitioned into pytest classes by feature area:

- `TestGenerateTempPassword`
- `TestCreateUserWithTempPassword`
- `TestResetPassword`
- `TestSendResetEmail`
- `TestListTables`
- `TestGetTable`
- `TestGetTableData`
- `TestImpersonateUser`
- `TestEndImpersonation`
- `TestStartViewingAs`
- `TestEndViewingAs`

### Test strategy

- **HTTP-level assertions:** Most tests exercise actual route handlers via `client.get(...)` / `client.post(...)`, asserting status codes and JSON responses.
- **Database isolation:** Routes are tested with `get_db_connection` patched to return mocked connections/cursors.
- **External services isolation:**
  - Email service is patched via `get_email_service` and uses `AsyncMock` for async sending.
  - Token/session utilities are patched where impersonation behavior is tested (`generate_session_token`, `hash_token`).
- **Session/auth simulation:** Admin session token is passed using `cookies={"session_token": "..."}`.

### Fixtures

A module-level `client` fixture constructs a `fastapi.testclient.TestClient` from `app.main.app`.

---

## Configuration

### Required runtime context for tests

- Python dependencies:
  - `pytest`
  - `fastapi`
  - `starlette` (indirect via FastAPI)
- The application must expose:
  - `from app.main import app`
- The admin module under test must expose / reference:
  - `app.api.v1.admin.generate_temp_password`
  - `get_db_connection`
  - `hash_password`
  - `get_email_service`
  - `generate_session_token`
  - `hash_token`
  - `get_admin_account_from_token` (used in some impersonation tests)

### Authentication expectation

Routes that require authentication must read a `session_token` cookie. Tests validate `401` when absent for impersonation/view-as end/start endpoints.

---

## API Reference

### Helper Function

#### `generate_temp_password(length: int = 16) -> str`

Generates a temporary password meeting security requirements.

**Parameters**
- `length: int`  
  Requested password length; tests expect a minimum enforcement.

**Returns**
- `str` password meeting:
  - minimum length of 12
  - contains at least one:
    - uppercase letter
    - lowercase letter
    - digit
    - special character (from `!@#$%^&*` per tests)

**Behavior asserted**
- default length is 16
- custom lengths are respected if >= 12
- lengths < 12 are coerced to 12
- multiple calls generate unique passwords (probabilistic uniqueness asserted via 10 samples)

---

## Endpoint Behaviors

### `POST /api/v1/admin/users`

Creates a new user and returns a temporary password.

**Request JSON fields (as exercised)**
- `email: str` (must be valid email format)
- `first_name: str` (non-empty)
- `last_name: str` (non-empty)
- `role_id: int` (optional; defaults to `1` when omitted)
  - Tests indicate valid range `1–4`

**Responses asserted**
- `201 Created` with JSON keys:
  - `message == "User created successfully"`
  - `email`, `first_name`, `last_name`
  - `role_id` (including default = 1 behavior)
  - `temp_password: str` (length 16 expected in success test)
  - `user_id: int` (from cursor `.lastrowid`)

**Error responses asserted**
- `400 Bad Request` when email already exists (`detail` contains “already registered”)
- `422 Unprocessable Entity` for:
  - invalid email
  - missing required fields
  - empty names
  - invalid `role_id` (e.g., 10)

**Database side effects**
- Success path must `commit()`.

---

### `POST /api/v1/admin/users/{user_id}/reset-password`

Resets a user password to the provided new value.

**Path parameters**
- `user_id: int`

**Request JSON fields**
- `new_password: str` (length/strength validated; tests only cover “too short”)

**Responses asserted**
- `200 OK` with JSON:
  - `message == "Password reset successfully"`
  - `user_id`

**Error responses asserted**
- `404 Not Found` when target user does not exist (`detail` contains “not found”)
- `422 Unprocessable Entity` when `new_password` is too short

**Database side effects**
- Success path must `commit()`.

---

### `POST /api/v1/admin/users/{user_id}/send-reset-email`

Sends a password reset email containing a provided temporary password.

**Path parameters**
- `user_id: int`

**Request JSON fields**
- `temporary_password: str`
- `email_override: str` (optional; if present, email is sent to this address)

**Responses asserted**
- `200 OK` with JSON:
  - `message == "Password reset email sent successfully"`
  - `sent_to: str`
  - `user_id: int`

**Error responses asserted**
- `404 Not Found` when user does not exist

**External calls**
- Uses `get_email_service().send_email(...)` (async) and expects `.success == True` on result.

---

### `GET /api/v1/admin/tables`

Lists allowed database tables with schema information.

**Responses asserted**
- `200 OK` with JSON containing:
  - `tables` key

**Notes**
- The test mocks cursor calls used for:
  - retrieving column info
  - retrieving foreign key info
  - retrieving row counts

---

### `GET /api/v1/admin/tables/{table_name}`

Returns schema and data for an allowed table.

**Path parameters**
- `table_name: str`

**Responses asserted**
- `200 OK` with JSON containing:
  - `schema_info`
  - `data`

**Error responses asserted**
- `404 Not Found` when `table_name` is not in allowed list (`detail` contains “not found”)

---

### `GET /api/v1/admin/tables/{table_name}/data`

Returns data only for an allowed table, with optional pagination.

**Path parameters**
- `table_name: str`

**Query parameters**
- `limit: int` (optional)
- `offset: int` (optional)

**Responses asserted**
- `200 OK` with JSON containing:
  - `columns`
  - `rows`
  - `total`

**Pagination behavior asserted**
- `limit` and `offset` change the returned `rows` while `total` reflects full table count.

---

## Impersonation Mode

### `POST /api/v1/admin/users/{user_id}/impersonate`

Starts an impersonation session for a target user.

**Auth**
- Requires `session_token` cookie.

**Authorization**
- Must be system admin (tests treat `RoleID == 4` as sysadmin).
- Cannot impersonate self.

**Responses asserted**
- `200 OK` with JSON including:
  - `message == "Impersonation session started"`
  - `is_impersonating == True`
  - `impersonated_user.account_id == {user_id}`

**Error responses asserted**
- `401 Unauthorized` if no auth (`detail` contains “authentication required”)
- `403 Forbidden` if not system admin (`detail` contains “system administrator”)
- `400 Bad Request` if impersonating self (`detail` contains “yourself”)

**Implementation dependencies patched**
- `generate_session_token`
- `hash_token`
- `get_db_connection`
- In some tests: `get_admin_account_from_token`

---

### `POST /api/v1/admin/impersonate/end`

Ends an impersonation session.

**Auth**
- Requires `session_token` cookie.

**Responses asserted**
- `200 OK` with JSON:
  - `message == "Impersonation session ended"`
  - `admin_account_id` (the initiating admin)

**Error responses asserted**
- `400 Bad Request` if session is not an impersonation session (`detail` contains “not currently impersonating”)
- `401 Unauthorized` if no auth

**Database side effects**
- Success path must `commit()`.

---

## View-As Mode (New Approach)

This approach appears to avoid issuing a new impersonation session token and instead mutates the current admin session (e.g., via `ViewingAsUserID`).

### `POST /api/v1/admin/users/{user_id}/view-as`

Begins “view-as” mode by setting `ViewingAsUserID` on the current session.

**Auth**
- Requires `session_token` cookie.

**Authorization**
- Must be system admin (`RoleID == 4` in tests).
- Cannot view-as self.
- Cannot view-as an inactive user.
- 404 when target not found.

**Responses asserted**
- `200 OK` with JSON:
  - `message == "Now viewing as user"`
  - `is_viewing_as == True`
  - `viewed_user.user_id == {user_id}`
  - `viewed_user.role` (e.g., `"participant"`)

**Error responses asserted**
- `401 Unauthorized` if no auth
- `403 Forbidden` if not system admin
- `400 Bad Request` for:
  - self
  - inactive user
- `404 Not Found` for missing target user

**Database side effects**
- Success path must `commit()`.

---

### `POST /api/v1/admin/view-as/end`

Ends “view-as” mode by clearing `ViewingAsUserID`.

**Auth**
- Requires `session_token` cookie.

**Responses asserted**
- `200 OK` with JSON:
  - `message == "Returned to admin view"`

**Error responses asserted**
- `400 Bad Request` if not currently viewing as another user (`detail` contains “not currently viewing”)
- `401 Unauthorized` if no auth

**Database side effects**
- Success path must `commit()`.

---

## Parameters and Return Types

### Request payloads
All request bodies are JSON objects, effectively:

- `dict[str, Any]` for create/reset/send-reset-email actions.

### Response payloads

Common patterns asserted:

- Success:
  - `dict[str, Any]` including `message: str` and endpoint-specific fields.
- Validation errors:
  - error JSON includes `detail` (FastAPI/Pydantic style), sometimes a list for 422.
- List endpoint:
  - `dict[str, Any]` with `tables: Any`
- Table data endpoint:
  - `dict[str, Any]` with:
    - `columns: list[str] | list[Any]`
    - `rows: list[list[Any]] | list[tuple[Any, ...]]`
    - `total: int`

---

## Error Handling

The suite validates error handling primarily through HTTP status codes:

- `422` for request validation failures (email format, missing/empty fields, invalid role, short password)
- `400` for business-rule violations (duplicate email, invalid impersonation/view-as transitions, self-targeting)
- `401` for missing authentication cookie
- `403` for insufficient privileges (non-system-admin attempting privileged actions)
- `404` for missing resources (unknown user IDs, non-allowed tables)

The suite also checks selected `detail` message substrings for correctness and user-facing clarity.

---

## Usage Examples

### Run this test module

```bash
pytest path/to/this_test_file.py -q