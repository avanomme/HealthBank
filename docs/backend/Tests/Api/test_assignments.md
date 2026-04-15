# Survey Assignment API Tests (`backend/tests/api/test_assignments.py`)

## Overview

This module contains TDD (red-phase) tests for a **Survey Assignment API**. The tests are intended to be written **before implementation** and should initially fail until the assignment feature is implemented.

Endpoints covered:

- `POST   /api/v1/surveys/{id}/assign` — Assign a survey to one or more users
- `GET    /api/v1/surveys/{id}/assignments` — List assignments for a survey
- `GET    /api/v1/assignments/me` — List assignments for the current user
- `PUT    /api/v1/assignments/{id}` — Update an assignment (due date, status)
- `DELETE /api/v1/assignments/{id}` — Delete/remove an assignment

The tests assume a FastAPI app is available at `app.main.app` and that the routes will be registered (explicitly noted in the `client` fixture docstring).

---

## Architecture / Design

### Test style

- End-to-end API tests via `fastapi.testclient.TestClient`
- Uses real HTTP calls against the application routes (no mocking inside this file)
- Composes prerequisite entities (question → survey → publish) using API calls to set up state

### Setup flow for assignment tests

Many tests depend on a survey being publishable and published:

1. `POST /api/v1/questions` to create a question
2. `POST /api/v1/surveys` to create a survey with `question_ids`
3. `PATCH /api/v1/surveys/{survey_id}/publish` to publish the survey

This setup is encapsulated in the `published_survey` fixture.

### TDD emphasis

The file explicitly states that assignment routes must be added to `main.py` in “Task 011”. If those routes are missing, the tests will fail with `404` responses (as expected during red phase).

---

## Configuration

### Fixtures

#### `client() -> TestClient`

Creates a FastAPI test client:

- Imports `app` from `app.main`
- Requires assignment routes to be registered on the app for tests to pass

#### `sample_assignment() -> dict[str, object]`

A basic single-user assignment payload:

- `account_id: int` (set to `1`)
- `due_date: str` (ISO timestamp; `now + 7 days`)

#### `bulk_assignment() -> dict[str, object]`

A multi-user assignment payload:

- `account_ids: list[int]` (set to `[1, 2, 3]`)
- `due_date: str` (ISO timestamp; `now + 14 days`)

#### `published_survey(client) -> int`

Creates and publishes a survey for testing assignments. Returns `survey_id: int`.

---

## API Reference

This file defines expected request/response behavior for each endpoint.

### `POST /api/v1/surveys/{id}/assign`

Assigns a **published** survey to one or more accounts.

**Path parameters**
- `id: int` — survey ID

**Request body (two supported shapes)**

1) Single assignment:
- `account_id: int`
- `due_date: str | None` (ISO timestamp or `None`)

2) Bulk assignment:
- `account_ids: list[int]`
- `due_date: str | None`

**Success responses**
- `201 Created`

For single assignment, response JSON is expected to include:
- `survey_id: int`
- `account_id: int`
- `status: str` (expected `"pending"`)
- `assignment_id: int`
- `due_date` present (non-null when provided)

For bulk assignment, response JSON is expected to be:
- `list[dict[str, Any]]` with length equal to number of accounts assigned

**Error responses**
- `400 Bad Request` when:
  - assigning a **draft** survey
  - assigning a **closed** survey
- `409 Conflict` when:
  - attempting to assign the same survey to the same user twice (duplicate assignment)
- `404 Not Found` when:
  - survey does not exist

---

### `GET /api/v1/surveys/{id}/assignments`

Lists assignments for a given survey.

**Path parameters**
- `id: int` — survey ID

**Query parameters**
- `status: str | None` (e.g. `pending`) — filter by assignment status

**Success responses**
- `200 OK` with JSON:
  - `list[dict[str, Any]]`

Behavior asserted:
- returns all assignments for the survey
- returns `[]` for a survey with no assignments
- when filtered by `status=pending`, every returned row must have `status == "pending"`

**Error responses**
- `404 Not Found` when survey does not exist

---

### `GET /api/v1/assignments/me`

Returns assignments associated with the current authenticated user.

**Query parameters (as used in tests)**
- `account_id: int | None` (used in one test; may be optional/override behavior)
- `status: str | None` (e.g. `pending`)

**Success responses**
- `200 OK` with JSON:
  - `list[dict[str, Any]]`

Behavior asserted:
- endpoint uses `user["effective_account_id"]` from auth context (tests assume this equals `999`)
- supports filtering to only pending assignments (`status=pending`)

---

### `PUT /api/v1/assignments/{id}`

Updates assignment fields such as due date and status.

**Path parameters**
- `id: int` — assignment ID

**Request body (as used in tests)**
- Update due date:
  - `due_date: str` (ISO timestamp)
- Mark complete:
  - `status: "completed"`

**Success responses**
- `200 OK` with updated assignment JSON

Behavior asserted:
- due date update results in non-null `due_date`
- setting `status="completed"` returns:
  - `status == "completed"`
  - `completed_at` is non-null

**Error responses**
- `404 Not Found` when assignment does not exist

---

### `DELETE /api/v1/assignments/{id}`

Deletes an assignment.

**Path parameters**
- `id: int` — assignment ID

**Success responses**
- `204 No Content`

Behavior asserted:
- after deletion, a subsequent `GET /api/v1/surveys/{survey_id}/assignments` must not include the deleted `assignment_id`

**Error responses**
- `404 Not Found` when assignment does not exist
- `400 Bad Request` when attempting to delete a completed assignment

---

## Parameters and Return Types

### Request payloads

- Single assignment request: `dict[str, int | str | None]`
- Bulk assignment request: `dict[str, list[int] | str | None]`
- Update payload: `dict[str, str]` (either `due_date` or `status`)

### Response payloads (expected)

- Assign single: `dict[str, Any]`
- Assign bulk: `list[dict[str, Any]]`
- List assignments: `list[dict[str, Any]]`
- Update assignment: `dict[str, Any]`
- Delete assignment: empty body (`204`)

---

## Error Handling

The test suite defines the intended error semantics of the API:

- `400` for invalid state transitions or rule violations:
  - assigning draft/closed surveys
  - deleting completed assignments
- `404` for missing resources:
  - nonexistent survey
  - nonexistent assignment
- `409` for conflicts:
  - duplicate assignment for same (survey, account)

Validation errors (e.g., malformed payloads) are not explicitly tested here, but the suite implicitly expects FastAPI-style request validation.

---

## Usage Examples

### Run these tests

```bash
pytest backend/tests/api/test_assignments.py -q