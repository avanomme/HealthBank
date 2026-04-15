# Account Request API Tests (`backend/tests/api/test_account_requests.py`)

## Overview

This test module validates the **Account Request** feature end-to-end at the API layer, covering:

- Public account request submission (`POST /api/v1/auth/request_account`)
- Admin workflows for viewing/approving/rejecting requests
- Enforcement of role and field validation rules
- Duplicate-email conflict behavior
- Login response behavior for `must_change_password`

The tests use a fake database layer (`FakeCursor`) and mock external email sending where needed.

---

## Architecture / Design

### Test structure

The file is organized into three pytest test classes:

- `TestRequestAccount`: Public request submission behavior and validation.
- `TestAdminAccountRequests`: Admin management endpoints (list/count/approve/reject).
- `TestLoginMustChangePassword`: Login response includes `must_change_password` flag.

### Shared test dependencies

- `client` fixture: HTTP test client (likely FastAPI/Starlette style) used for API calls.
- `FakeCursor` (from `tests.mocks.db`): in-memory fake DB storage used by the API layer.
  - `FakeCursor.account_requests` is asserted against for request creation/status updates.
  - `FakeCursor.accounts` is used to simulate `must_change_password`.

### External integration mocking

- Email sending is mocked via `@patch("app.api.v1.admin.get_email_service")`
  - The mock returns an object with `send_email(...)` returning an object with `.success == True`
  - Ensures approval flow can be tested without actual email infrastructure.

---

## Configuration

### Required fixtures / environment (test harness)

This test file expects:

- A pytest fixture named `client` capable of:
  - `client.post(path, json=...)`
  - `client.get(path)`
  - returning responses with:
    - `status_code`
    - `json()` method

- The application under test must be wired to use `tests.mocks.db.FakeCursor` during tests (directly or via dependency injection).

No per-test configuration is declared in this file beyond inline request payloads.

---

## API Reference

This file targets the following HTTP endpoints and behaviors.

### Public Auth Endpoints

#### `POST /api/v1/auth/request_account`

Submits an account request.

**Request JSON fields (as exercised by tests)**

- Required (typical):
  - `first_name: str`
  - `last_name: str`
  - `email: str` (must be valid email format)
  - `role_id: int` (must be within allowed range; tests imply 1–3)

- Conditional / role-specific:
  - For some roles, additional fields may be required:
    - `birthdate: str` (ISO date string, e.g. `"1990-05-15"`)
    - `gender: str` (must be in an allowed set; `"Female"` and `"Other"` are accepted in tests)
    - `gender_other: str` (required/used when `gender == "Other"`)

**Responses asserted**
- `201 Created` on success, with JSON including:
  - `message == "Request submitted successfully"`

**Validation / error responses asserted**
- `422 Unprocessable Entity` for:
  - invalid role (e.g., role_id = 4)
  - invalid gender value
  - missing required fields (e.g., missing `first_name`)
  - invalid email format

**Conflict responses asserted**
- `409 Conflict` if:
  - email already exists in account table (`/create_account` seeded)
  - email already has a pending request

---

#### `POST /api/v1/auth/create_account` (used for seeding)

Used in tests to create an account and validate duplicate-email behavior in requests.

**Request fields used**
- `first_name: str`
- `last_name: str`
- `email: str`
- `password: str`

**Behavior**
- Successful creation is assumed; status code is not asserted in this file.

---

#### `POST /api/v1/auth/login`

Validates login response includes `must_change_password`.

**Request fields used**
- `email: str`
- `password: str`

**Response asserted**
- `200 OK` with JSON containing:
  - `must_change_password: bool`

---

### Admin Endpoints

#### `GET /api/v1/admin/account-requests`

Lists pending account requests.

**Responses asserted**
- `200 OK`
- Returns `[]` when none exist
- Returns a list of objects where elements include:
  - `email`
  - `status` (expected `"pending"` for new requests)

---

#### `GET /api/v1/admin/account-requests/count`

Returns pending request count.

**Responses asserted**
- `200 OK` with JSON:
  - `count: int`

---

#### `POST /api/v1/admin/account-requests/{request_id}/approve`

Approves a request, creates an account, and triggers an email send.

**Path parameters**
- `request_id: int`

**Responses asserted**
- `200 OK` with JSON including:
  - `message == "Account request approved and account created"`
  - `email`
  - `account_id` (presence checked)

**Error responses asserted**
- `404 Not Found` if request does not exist
- `400 Bad Request` if request is already approved

**Side effects asserted**
- `FakeCursor.account_requests[request_id]["Status"] == "approved"`

**External calls**
- Email service is mocked; tests assume send_email succeeds.

---

#### `POST /api/v1/admin/account-requests/{request_id}/reject`

Rejects a request (optionally with admin notes).

**Path parameters**
- `request_id: int`

**Request body**
- Optional JSON:
  - `admin_notes: str`

**Responses asserted**
- `200 OK` for rejection (with or without notes)
- `404 Not Found` if request does not exist

**Side effects asserted**
- `FakeCursor.account_requests[request_id]["Status"] == "rejected"`

---

## Parameters and Return Types

### Request payloads (Python typing perspective)

- Account request payloads: `dict[str, Any]` sent as JSON
- Admin reject payload: `dict[str, str]` with optional `"admin_notes"`

### Response payloads

- Success responses:
  - `dict[str, Any]` with keys asserted per endpoint
- List endpoint:
  - `list[dict[str, Any]]`
- Count endpoint:
  - `dict[str, int]` with `"count"`

---

## Error Handling

This test module expects the API layer to handle errors via HTTP status codes:

- `422` for validation errors (invalid role, gender, email format, missing fields)
- `409` for conflicts (duplicate existing account email, duplicate pending request)
- `404` for non-existent account request IDs on approve/reject
- `400` for invalid state transition (approving an already-approved request)

The tests do not assert error response schemas beyond checking `detail` strings for some cases:
- duplicate existing account: `"already exists"` substring in `detail`
- duplicate pending request: `"pending"` substring in `detail`
- already approved: `"already"` substring in `detail`

---

## Usage Examples

### Running these tests

From repository root (typical):

```bash
pytest backend/tests/api/test_account_requests.py -q