# Cookie-Based Session Management Tests (`backend/tests/api/test_sessions_cookies.py`)

## Overview

This module tests **cookie-based session management** behavior for the authentication/session layer. It verifies:

- Login sets a `session_token` cookie
- The session token is **not** exposed in the response JSON body
- Subsequent requests can validate the session using the stored cookie automatically

Endpoints covered:

- `POST /api/v1/auth/create_account` (setup)
- `POST /api/v1/auth/login`
- `POST /api/v1/sessions/validate`

---

## Architecture / Design

### Test style

- Uses a `client` fixture (FastAPI `TestClient`) assumed to be provided externally.
- Uses pytest fixtures for reusable payloads.
- Relies on `TestClient` cookie persistence: cookies set by a response are automatically sent on later requests made with the same client instance.

### Test flow

1) Create an account
2) Login to establish a cookie-based session
3) Validate the session via a separate endpoint without manually injecting cookies

---

## Configuration

### Fixtures

#### `sample_account() -> dict[str, str]`

Account creation payload:

- `email`
- `password`
- `first_name`
- `last_name`

#### `login_payload(sample_account) -> dict[str, str]`

Login payload derived from `sample_account`:

- `email`
- `password`

### External dependencies

- `client` fixture must exist and should return a `TestClient` bound to the app under test.

---

## API Reference

### `POST /api/v1/auth/login`

Authenticates the user and establishes a session.

**Request JSON fields**
- `email: str`
- `password: str`

**Success behavior asserted**
- Status code: `200 OK`
- A cookie named `session_token` is set:
  - `session_token` must exist in `response.cookies`
  - cookie value must be non-empty
- The response JSON must **not** include a `session_token` field

**Notes**
- This suite assumes the token is stored exclusively as an HttpOnly cookie (the HttpOnly attribute itself is not asserted here, only presence).

---

### `POST /api/v1/sessions/validate`

Validates whether the current request has a valid session cookie.

**Request body**
- None

**Success behavior asserted**
- Status code: `200 OK`
- JSON includes:
  - `valid: bool` and must be `True` when a valid session cookie is present

**Session behavior**
- Cookie is expected to be included automatically by the test client after login.

---

## Parameters and Return Types

### `test_login_sets_cookie`

**Inputs**
- `client`
- `sample_account: dict[str, str]`
- `login_payload: dict[str, str]`

**Asserts**
- `response.cookies["session_token"]` exists and is non-empty
- `session_token` is not present in `response.json()`

### `test_validate_with_cookie`

**Inputs**
- `client`
- `sample_account: dict[str, str]`
- `login_payload: dict[str, str]`

**Asserts**
- `POST /api/v1/sessions/validate` returns `{"valid": True}` with `200`

---

## Error Handling

This module does not test invalid-session scenarios. Expected complementary cases (not included here) would typically cover:

- validate without cookie returns `401` or `200` with `valid: False`
- validate with expired cookie returns `401` or `200` with `valid: False`

---

## Usage Examples

### Run only this test module

```bash
pytest backend/tests/api/test_sessions_cookies.py -q