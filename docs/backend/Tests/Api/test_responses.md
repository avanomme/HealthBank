# Response Submission API Tests (`test_responses.py`)

Test suite for the Response Submission API implemented in `app/api/v1/responses.py`.

These tests validate:

- `POST /api/v1/responses/` for submitting survey responses
- Authentication and role gating (participant-only, with admin bypass behavior)
- Business rules and validation:
  - Survey must be published
  - Participant must be assigned to the survey
  - Submitted questions must belong to the survey
  - Submitted values must match the question response type
  - Choice values must be validated against available options

## Overview

The Response Submission API accepts a `survey_id` plus a list of responses. Each response includes:

- `question_id`
- `response_value`

The endpoint is primarily a participant-only route, but the tests also assert that an admin role may bypass `require_role()` restrictions (system admin override), allowing the endpoint to execute business logic.

The suite uses a combination of:

- Real FastAPI request handling via `TestClient(app)`
- Mocking DB access for both authentication and endpoint logic

## Architecture / Design

### Test Client and Dependency Override Management

- The tests use the main FastAPI application: `from app.main import app`
- A `client` fixture returns `TestClient(app)`

An `autouse` fixture ensures the test suite is not affected by any global auth override (e.g., from `conftest.py`):

- `app.dependency_overrides.pop(get_current_user, None)`

This allows the tests to exercise real authentication/dependency logic, while still mocking DB access underneath.

### Authentication Mocking

Authentication is controlled by patching:

- `app.api.deps.get_db_connection`

Two helper functions return mocked DB connections that simulate the session lookup used by `get_current_user`:

- `_mock_participant_auth()`
  - Returns a session/user row with:
    - `RoleID = 1` (participant)
    - `ViewingAsUserID = None`

- `_mock_researcher_auth()`
  - Returns a session/user row with:
    - `RoleID = 2` (researcher)

Both helpers simulate a single DB connection flow where:

- `get_current_user` fetches `RoleID` and `ViewingAsUserID`
- `require_role` reuses this information without needing a second connection (no impersonation/view-as path)

### Endpoint DB Mocking

Business logic DB access for the responses endpoint is patched separately:

- `app.api.v1.responses.get_db_connection`

The tests configure cursor behaviors to simulate:

- Survey publication status checks
- Survey assignment checks
- Survey question list lookup (question map: `QuestionID` → `ResponseType`)
- Options lookup for `single_choice` questions
- Commit behavior on success (`resp_conn.commit` called)

### Canonical Request Body Used in Tests

`VALID_BODY` is the baseline payload used across multiple tests:

```json
{
  "survey_id": 1,
  "responses": [
    { "question_id": 1, "response_value": "yes" }
  ]
}