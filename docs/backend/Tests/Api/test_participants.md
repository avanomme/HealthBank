# Participant Data API Tests (`backend/tests/api/test_participants.py`)

## Overview

This test module validates the **Participant Data API** implemented in `app/api/v1/participants.py`.

It covers two participant-facing features:

- **Personal data view**
  - `GET /api/v1/participants/surveys/data`
  - Lists surveys the participant has responded to, including questions and the participant’s response values.
  - Ensures the endpoint uses `effective_account_id` (supports admin “view-as” behavior).

- **Survey submission**
  - `POST /api/v1/participants/surveys/{survey_id}/submit`
  - Allows a participant to submit answers for an assigned, published survey.
  - Enforces assignment status rules (pending/completed/expired), due-date behavior, and prevents double submission.
  - Ensures assignment is updated to `completed` upon successful submission.

It also tests authorization behavior:

- `401` when unauthenticated (no `Authorization` header)
- `403` for researchers (RoleID=2), since only participants/admin are allowed

---

## Architecture / Design

### Dependency override behavior

The module includes an `autouse=True` fixture `clear_auth_override` that removes any global `get_current_user` override (commonly set in `conftest.py`) so that tests can validate the API’s auth behavior more realistically.

### Auth mocking strategy

The tests mock `app.api.deps.get_db_connection` to simulate how `get_current_user` is resolved from an `Authorization: Bearer ...` token.

Helper functions:

- `_make_auth_conn(user_dict)` returns a mock DB connection whose cursor returns `user_dict` from `.fetchone()`.
- `_participant_user()`, `_researcher_user()`, `_admin_viewing_as_participant()` return representative user rows with `RoleID` and `ViewingAsUserID`.

### Participant data DB mocking

For participant endpoints, the tests mock:

- `app.api.v1.participants.get_db_connection`

They then configure `.fetchall()` and `.fetchone()` sequences to match expected query order.

### Effective account ID

The tests assume the system supports an “effective account” concept:

- Participants: effective account is their own `AccountID`
- Admin viewing as participant: effective account becomes `ViewingAsUserID`

The suite validates that SQL parameters include the effective account ID during data queries.

---

## Configuration

### Fixtures

- `client() -> TestClient`
  - Instantiated directly from `app.main.app`.

- `clear_auth_override()` (autouse)
  - Ensures `app.dependency_overrides[get_current_user]` is cleared for each test.

### Helper utilities

- `_make_auth_conn(user_dict)`
- `_participant_user()`
- `_researcher_user()`
- `_admin_viewing_as_participant()`

---

## API Reference

### GET `/api/v1/participants/surveys/data`

Personal data view for participants/admin.

**Auth**
- Requires `Authorization: Bearer <token>`
- Allowed roles:
  - Participant (`RoleID=1`)
  - Admin/System Admin (`RoleID=4`) when viewing-as (effective role resolved to participant)

**Response (success)**
- `200 OK`
- JSON array of surveys; each survey contains:
  - `survey_id: int`
  - `title: str`
  - `questions: list[object]`

Each question item includes:
- `question_id: int`
- `question_content: str | None`
- `response_type: str`
- `category: str | None`
- `response_value: str | None`

**Behavior asserted**
- Empty list returned when no survey responses exist
- Returns surveys with question metadata and response values
- Supports multiple surveys
- Uses `effective_account_id` for query parameters (admin view-as)

**Auth errors**
- `401` without token
- `403` for researcher role

---

### POST `/api/v1/participants/surveys/{survey_id}/submit`

Submit participant responses for a survey.

**Auth**
- Requires `Authorization: Bearer <token>`
- Allowed roles: participant/admin (researchers denied)

**Request body**
```json
{
  "question_responses": [
    { "question_id": 10, "response_value": "yes" }
  ]
}