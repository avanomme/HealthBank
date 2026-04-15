# Auth API TDD Tests (`backend/tests/api/test_auth_*.py`)

## Overview

This module is a TDD (red-phase) test suite for the **Auth API**. The tests are intended to fail until the auth functionality is implemented.

Endpoints covered:

- `POST   /api/v1/auth/create_account`
- `POST   /api/v1/auth/login`
- `DELETE /api/v1/auth/account/{id}`
- `POST   /api/v1/auth/password_reset_request`
- `POST   /api/v1/auth/validate_password_reset`
- `POST   /api/v1/auth/confirm_password_reset`
- `POST   /api/v1/auth/change_password`

Key concerns validated by the suite:

- Correct status codes and response bodies for success/error cases
- Session token is delivered via **HttpOnly cookie** (not in JSON body)
- Password reset requests are **non-enumerable** (same response whether email exists or not)
- Password reset tokens can be validated, confirmed, and must be **single-use**
- Change password requires authentication and verifies old password

---

## Architecture / Design

### Test organization

The file is grouped into test classes by endpoint/feature:

- `TestCreateAccount`
- `TestLogin`
- `TestDeleteAccount`
- `TestPasswordResetRequest`
- `TestValidatePasswordReset`
- `TestConfirmPasswordReset`
- `TestChangePassword`

### Test styles used

Two testing styles are used:

1) **Black-box API behavior** using `TestClient` calls and status assertions:
- account creation validation
- login validation
- delete account status behavior
- password reset request generic response behavior

2) **White-box integration mocking** for flows requiring internal orchestration:
- password reset email sending (`get_email_service`, token generation, DB lookup)
- password reset token validation and confirmation (`get_authid_by_valid_reset_token`, DB update, token clearing)
- change password (`get_current_user`, `verify_password`, DB updates)

Mocking is done with `unittest.mock.patch`, `MagicMock`, and `AsyncMock`.

### Assumed auth/session model

- Login sets a `session_token` as an **HttpOnly cookie**.
- Certain endpoints (e.g., `change_password`) depend on a `get_current_user` dependency that resolves the current user from session state.

---

## Configuration

### Fixtures

#### `sample_account() -> dict[str, str]`

A valid account creation payload:

- `email`
- `password`
- `first_name`
- `last_name`

#### `login_payload(sample_account) -> dict[str, str]`

A valid login payload derived from `sample_account`:

- `email`
- `password`

### Required testing environment

- Pytest
- FastAPI test client fixture named `client` is referenced throughout, but **not defined inside the provided snippet**.
  - This suite assumes a `client` fixture exists elsewhere (commonly defined as:
    `TestClient(app.main.app)`).
  - If not provided, tests will fail during collection.

---

## API Reference

### `POST /api/v1/auth/create_account`

Creates a new user account.

**Request JSON fields (as exercised)**
- `email: str` (must be valid email format)
- `password: str` (required)
- `first_name: str`
- `last_name: str`

**Success response**
- `201 Created`
- JSON must include:
  - `message: str` starting with `"account"` (case-insensitive)
- Some tests later assume the response includes:
  - `account_id: int` (used by delete-account tests)

**Error responses**
- `409 Conflict` on duplicate email
- `422 Unprocessable Entity` on validation errors:
  - missing password
  - invalid email format

---

### `POST /api/v1/auth/login`

Authenticates a user and creates a session.

**Request JSON fields**
- `email: str`
- `password: str`

**Success response**
- `200 OK`
- JSON includes:
  - `expires_at` (presence asserted)
- JSON must **not** include:
  - `session_token` (explicitly asserted)
- Session token is expected to be set as an **HttpOnly cookie**.

**Error responses**
- `401 Unauthorized` for:
  - invalid password
  - nonexistent account
- `422 Unprocessable Entity` for missing required fields

---

### `DELETE /api/v1/auth/account/{id}`

Deletes an account by account ID.

**Path parameters**
- `id: int` — account ID

**Success response**
- `204 No Content`

**Error responses**
- `404 Not Found` when account does not exist

**Notes**
- The success-path test expects that `create_account` returns an `account_id`.

---

## Password Reset Flow

### `POST /api/v1/auth/password_reset_request`

Requests a password reset email (or behaves as if it did).

**Request JSON fields**
- `email: str`

**Success response (always non-enumerating)**
- `202 Accepted`
- JSON includes `message`
- For nonexistent emails, the response must still be `202` and message should not reveal existence.
  - One test asserts the message contains `"If an account exists"`.

**Validation errors**
- `422 Unprocessable Entity` for:
  - missing email field
  - empty email string
  - invalid email format

**Email sending behavior (existing account)**
Tests patch the following implementation hooks:
- `app.api.v1.auth.generate_reset_token_for_email` -> `(token: str, expires_at: datetime)`
- `app.api.v1.auth.get_db_connection` -> DB lookup of user first name by email
- `app.api.v1.auth.get_email_service` -> object with `send_email(...)` async method

Assertions include:
- `send_email` called exactly once for a single request
- the call arguments contain the target email
- email content includes a reset URL containing `"reset-password"` and a `"token"` parameter

**Security behavior**
- Requests for existing and nonexistent emails must return identical messages and status codes.

---

### `POST /api/v1/auth/validate_password_reset`

Validates a reset token without changing state.

**Request JSON fields**
- `token: str`

**Success response**
- `200 OK` with JSON:
  - `valid: true`

**Error response**
- `400 Bad Request` for invalid/expired tokens, with `detail` containing `"invalid"` or `"expired"` (substring check)

**Validation errors**
- `422 Unprocessable Entity` for:
  - missing token
  - empty token
  - token too short (e.g., `"short"`)

**Implementation hook**
- `app.api.v1.auth.get_authid_by_valid_reset_token` returning:
  - `auth_id: int` for valid tokens
  - `None` for invalid/expired tokens

---

### `POST /api/v1/auth/confirm_password_reset`

Consumes a reset token and sets a new password.

**Request JSON fields**
- `token: str`
- `new_password: str`

**Success response**
- `200 OK` with JSON containing `message` indicating reset success

**Error responses**
- `400 Bad Request` for:
  - invalid/expired token
  - database update failure (simulated via `cursor.rowcount == 0`)
  - token reuse after successful reset (second call returns `400`)

**Validation errors**
- `422 Unprocessable Entity` for:
  - missing token
  - missing password
  - empty password
  - password too short (test implies minimum length > 7)

**Implementation hooks patched**
- `get_authid_by_valid_reset_token`
- `hash_password`
- `get_db_connection` (update password)
- `clear_reset_token(token)` must be called on success

---

## Change Password

### `POST /api/v1/auth/change_password`

Changes the authenticated user’s password.

**Request JSON fields**
- `old_password: str`
- `new_password: str`

**Success response**
- `200 OK` with JSON containing `message`

**Error responses**
- `401 Unauthorized` when old password is incorrect, with detail:
  - `"Invalid old password"` (substring asserted)
- `400 Bad Request` when new password equals old password, with detail:
  - `"New password must be different"` (substring asserted)
- `401 Unauthorized` or `403 Forbidden` when unauthenticated (test accepts either)

**Validation errors**
- `422 Unprocessable Entity` when new password is too short

**Implementation hooks patched**
- `get_current_user` (returns dict with `account_id`, `email`)
- `get_db_connection` (fetch auth info and update password)
- `verify_password` (returns True/False)

**Notes on state flags**
This suite does not explicitly assert behavior related to flags such as `must_change_password`, but it does validate password update success paths.

---

## Parameters and Return Types

### Payload types

- Create account:
  - `dict[str, str]`
- Login:
  - `dict[str, str]`
- Password reset request:
  - `dict[str, str]` (`{"email": ...}`)
- Token validation:
  - `dict[str, str]` (`{"token": ...}`)
- Confirm reset:
  - `dict[str, str]` (`{"token": ..., "new_password": ...}`)
- Change password:
  - `dict[str, str]` (`{"old_password": ..., "new_password": ...}`)

### Response types

- Most success responses: `dict[str, Any]`
- Delete success: empty body (204)
- Validation failures: FastAPI-style `422` JSON (commonly `{"detail": ...}`)

---

## Error Handling

The suite encodes intended error semantics:

- `409` for duplicate account creation
- `401` for invalid login or invalid old password on change-password
- `404` for deleting nonexistent accounts
- `202` for password reset requests regardless of account existence (anti-enumeration)
- `400` for invalid/expired reset tokens and for reset confirmation failures
- `422` for request validation problems (missing/invalid fields, too-short values)

The tests emphasize security-oriented handling for password reset:
- responses must not reveal whether a user exists
- tokens must be validated and single-use
- reset flow must clear tokens on success

---

## Usage Examples

### Run only this test module

```bash
pytest backend/tests/api/test_auth.py -q