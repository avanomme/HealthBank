# `markdown/assignments.md` — Survey Assignment API (`backend/app/api/v1/assignments.py`)

## Overview

`backend/app/api/v1/assignments.py` provides endpoints to manage assigning surveys to users and tracking completion status.

It includes two routers:

- **Survey-scoped router** (`survey_router`): endpoints mounted under `/api/v1/surveys` for assigning and listing assignments for a specific survey.
- **Assignment router** (`router`): endpoints mounted under `/api/v1/assignments` for the current user’s assignments and for updating/deleting assignments.

All database access uses parameterized SQL queries.

---

## Architecture / Design Explanation

### Routers and Authorization

- `router = APIRouter(dependencies=[Depends(require_role(1, 2, 4))])`
  - Protects assignment endpoints for participants (1), researchers (2), and system admins (4).
- `survey_router = APIRouter(dependencies=[Depends(require_role(2, 4))])`
  - Restricts survey assignment actions to researchers (2) and system admins (4).

Role enforcement relies on `require_role` and its `effective_account_id` behavior (including view-as mode).

### Data Model Assumptions

This module assumes the presence of these tables/fields:

- `Survey(SurveyID, Title, PublicationStatus, ...)`
- `SurveyAssignment(AssignmentID, SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status, ...)`

### Status Handling

Assignment status is represented by `AssignmentStatus`:

- `pending`
- `completed`
- `expired`

The module stores status values as strings in the DB (e.g., `'pending'`, `'completed'`).

When an assignment is updated to `completed`, the code sets `CompletedAt` to `datetime.now()`.

---

## Configuration (if applicable)

No module-specific environment configuration.

This module depends on shared infrastructure:

- Database connection: `get_db_connection()` from `backend/app/utils/utils.py`
- Authorization dependency: `require_role()` from `backend/app/api/deps.py`

---

## API Reference

There are two route groups, mounted under different prefixes.

### Survey-Scoped Endpoints (mounted under `/api/v1/surveys`)

#### `POST /api/v1/surveys/{survey_id}/assign`

Assigns a **published** survey to one or more accounts.

- Requires role: Researcher (2) or System Admin (4)
- Rejects assignment if survey is not found or not published
- Rejects duplicate assignments per `(SurveyID, AccountID)`

**Path parameters**
- `survey_id: int`

**Request body:** `AssignmentCreate`

**Returns**
- A single `AssignmentResponse` if assigning to one account
- A list of `AssignmentResponse` if assigning to multiple accounts

**Errors**
- `404` Survey not found
- `400` Survey not published
- `422` Must provide `account_id` or `account_ids`
- `409` Duplicate assignment for a user

---

#### `GET /api/v1/surveys/{survey_id}/assignments`

Lists assignments for a specific survey, optionally filtered by status.

- Requires role: Researcher (2) or System Admin (4)

**Path parameters**
- `survey_id: int`

**Query parameters**
- `status: str | None` (optional)

**Returns**
- `List[AssignmentResponse]`

**Errors**
- `404` Survey not found

---

### Assignment Endpoints (mounted under `/api/v1/assignments`)

#### `GET /api/v1/assignments/me`

Lists assignments for the current user (based on auth context).

- Requires role: Participant (1), Researcher (2), or System Admin (4)
- Uses `user["effective_account_id"]` (supports view-as)

**Query parameters**
- `status: str | None` (optional)

**Returns**
- `List[MyAssignmentResponse]`

---

#### `PUT /api/v1/assignments/{assignment_id}`

Updates an assignment’s due date and/or status.

- Requires role: Participant (1), Researcher (2), or System Admin (4)

**Path parameters**
- `assignment_id: int`

**Request body:** `AssignmentUpdate`

**Behavior**
- If `status` set to `completed`, sets:
  - `Status = 'completed'`
  - `CompletedAt = datetime.now()`

**Returns**
- `AssignmentResponse` (latest assignment row)

**Errors**
- `404` Assignment not found

---

#### `DELETE /api/v1/assignments/{assignment_id}`

Deletes an assignment unless it is already completed.

- Requires role: Participant (1), Researcher (2), or System Admin (4)

**Path parameters**
- `assignment_id: int`

**Returns**
- `204 No Content`

**Errors**
- `404` Assignment not found
- `400` Cannot delete completed assignment

---

## Parameters and Return Types

### Enums

#### `AssignmentStatus`

- `pending: "pending"`
- `completed: "completed"`
- `expired: "expired"`

### Request Models

#### `AssignmentCreate`

- `account_id: int | None`
- `account_ids: List[int] | None`
- `due_date: datetime | None`

Rules:
- Must provide exactly one of:
  - `account_id`, or
  - `account_ids`
- `due_date` is optional.

#### `AssignmentUpdate`

- `due_date: datetime | None`
- `status: AssignmentStatus | None`

### Response Models

#### `AssignmentResponse`

- `assignment_id: int`
- `survey_id: int`
- `account_id: int`
- `assigned_at: datetime | None`
- `due_date: datetime | None`
- `completed_at: datetime | None`
- `status: str`

#### `MyAssignmentResponse`

- `assignment_id: int`
- `survey_id: int`
- `survey_title: str`
- `assigned_at: datetime | None`
- `due_date: datetime | None`
- `completed_at: datetime | None`
- `status: str`

---

## Error Handling

This module raises `fastapi.HTTPException` for expected failure modes:

- `404` for missing `Survey` or `SurveyAssignment` rows.
- `400` for invalid state transitions (e.g., assigning an unpublished survey, deleting completed assignment).
- `409` for duplicate assignments (same survey and account).
- `422` when assignment input omits both `account_id` and `account_ids`.

Database exceptions are not explicitly caught here; unexpected DB errors will generally propagate as `500` responses via FastAPI defaults or any global exception handlers.

---

## Usage Examples (only where helpful)

### Assign a survey to one user

```bash
curl -s -X POST \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"account_id": 123, "due_date": "2026-03-15T00:00:00"}' \
  http://localhost:8000/api/v1/surveys/10/assign