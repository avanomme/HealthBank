# `markdown/participant_surveys.md` — Participant Survey Responses & Comparison API

## Overview

This module defines participant-facing survey endpoints to:

- Submit answers for an assigned, published survey
- List surveys assigned to the current participant (with assignment context)
- List surveys the participant has responded to, including questions and the participant’s answers
- Compare the participant’s responses for a survey against aggregated survey statistics

All endpoints are protected by role-based access control allowing:

- Participant (RoleID = 1)
- System Admin (RoleID = 4)

The module also sanitizes free-text response values before storage.

---

## Architecture / Design Explanation

### Authorization and Identity

- Router is initialized as:
  - `APIRouter(dependencies=[Depends(require_role(1, 4))])`
- Endpoints typically depend on:
  - `current_user=Depends(require_role(1, 4))`
- The effective participant identity is derived from:
  - `participant_id = current_user["effective_account_id"]`
  - This supports “view-as” behavior if implemented via session logic.

### Data Access Pattern

All database operations use `get_db_connection()` and parameterized SQL.

Core tables used:

- `Survey`
- `SurveyAssignment`
- `Responses`
- `QuestionList`
- `QuestionBank`

### Submission Workflow (`POST /surveys/{survey_id}/submit`)

Submission enforces:

1. Survey exists and is `published`
2. Participant is assigned to the survey
3. Assignment is not `completed` or `expired`
4. If assignment has a due date, it must not be past due
   - If past due, assignment is updated to `expired`
5. Participant cannot submit if there are already responses recorded for `(SurveyID, ParticipantID)`

Responses are inserted with an upsert pattern:

- `INSERT ... ON DUPLICATE KEY UPDATE`

Finally, the assignment is marked:

- `Status = 'completed'`
- `CompletedAt = UTC_TIMESTAMP()`

The endpoint commits once at the end.

### Listing Surveys (`GET /surveys`)

Lists surveys from `SurveyAssignment` joined to `Survey`, with optional inclusion filters:

- Include completed assignments
- Include expired assignments

Sorting prioritizes pending assignments, then due date, then most recently assigned.

### Listing Responded Surveys (`GET /surveys/data`)

Returns surveys where the participant has at least one entry in `Responses`, along with:

- Survey metadata
- Assignment metadata (if present)
- All questions for each survey (from `QuestionList` + `QuestionBank`)
- The participant’s stored `ResponseValue` per question

The module groups questions by survey in Python after bulk-fetching.

### Aggregation Comparison (`GET /surveys/{survey_id}/compare`)

This endpoint:

1. Ensures the participant is assigned to the survey (prevents probing arbitrary survey IDs)
2. Loads the participant’s responses for the survey
3. Calls `AggregationService.get_survey_aggregates(...)` to retrieve aggregate statistics
4. Returns both payloads in a combined response model

The aggregation payload is treated as an opaque `dict` shaped like the research aggregation endpoint output.

---

## Configuration (if applicable)

No module-specific environment variables are used.

External dependencies:

- `backend/app/api/deps.py`
  - `require_role`, `sanitized_string`
- `backend/app/utils/utils.py`
  - `get_db_connection`
- `backend/app/services/aggregation.py`
  - `AggregationService` used for survey aggregate comparisons

---

## API Reference

All endpoints below are relative to this router’s mount point (not shown in the snippet). Paths in decorators are:

### `POST /surveys/{survey_id}/submit`

Submit participant answers for an assigned, published survey.

**Path parameters**
- `survey_id: int`

**Request body:** `SurveyParticipantAnswer`

**Returns (inline dict)**
- `survey_id: int`
- `participant_id: int`
- `submitted_count: int`
- `status: str` (`"ok"`)

**Errors**
- `404` Survey not found
- `400` Survey not accepting submissions (not published)
- `403` Not assigned to the survey
- `400` Assignment already completed
- `400` Assignment is expired
- `400` Past due (also sets assignment to expired)
- `400` Survey already submitted (existing responses found)
- `500` Failed to submit survey (unexpected error)

---

### `GET /surveys`

List surveys assigned to the current participant, including assignment context.

**Query parameters**
- `include_completed: bool` (default `True`)
- `include_expired: bool` (default `True`)

**Response model**
- `List[ParticipantSurveyListItem]`

**Errors**
- `500` Failed to load participant surveys

---

### `GET /surveys/data`

List surveys the participant has responded to, including questions and their saved responses.

**Response model**
- `List[ParticipantSurveyWithResponses]`

**Errors**
- `500` Failed to load responded surveys

---

### `GET /surveys/{survey_id}/compare`

Return participant’s responses for a survey and aggregate statistics for comparison.

**Path parameters**
- `survey_id: int`

**Query parameters**
- `category: str | None`
- `response_type: str | None`

**Response model**
- `ParticipantSurveyCompareResponse`

**Errors**
- `403` Not assigned to this survey
- `404` Survey not found (when aggregation returns `None`)
- `500` Failed to load comparison data

---

## Parameters and Return Types

### Request Models

#### `AnswerItem`

- `question_id: int`
- `response_value: str`
  - Sanitized via `sanitized_string` before validation completes.

#### `SurveyParticipantAnswer`

- `question_responses: List[AnswerItem]`

### Response Models

#### `ParticipantSurveyListItem`

- `survey_id: int`
- `title: str`
- `start_date: datetime | None`
- `end_date: datetime | None`
- `assignment_status: str`
- `assigned_at: datetime | None`
- `due_date: datetime | None`
- `completed_at: datetime | None`
- `publication_status: str`

#### `ParticipantQuestionResponse`

- `question_id: int`
- `title: str | None`
- `question_content: str`
- `response_type: str`
- `is_required: bool`
- `category: str | None`
- `response_value: str | None`

#### `ParticipantSurveyWithResponses`

- `survey_id: int`
- `title: str`
- `start_date: datetime | None`
- `end_date: datetime | None`
- `publication_status: str`
- `assignment_status: str | None`
- `assigned_at: datetime | None`
- `due_date: datetime | None`
- `completed_at: datetime | None`
- `questions: List[ParticipantQuestionResponse]`

#### `ParticipantAnswerOut`

- `question_id: int`
- `response_value: str | None`

#### `ParticipantSurveyCompareResponse`

- `survey_id: int`
- `participant_answers: List[ParticipantAnswerOut]`
- `aggregates: dict`
  - Aggregation payload returned by `AggregationService.get_survey_aggregates(...)`.

---

## Error Handling

### Submission Endpoint Transaction Safety

- On `HTTPException`, the code attempts to `conn.rollback()` and re-raises.
- On generic exceptions, it rolls back and returns `500`.

Implementation detail:
- `conn`/`cursor` are created inside the try-block; successful creation is required for rollback/close operations in exception paths.

### Status and Due Date Enforcement

- If due date has passed, the assignment is marked expired before raising `400`.
- Completed/expired assignments reject submissions with `400`.

### Data Integrity Constraints

- Duplicate submission is blocked by explicitly counting existing `Responses` rows for `(SurveyID, ParticipantID)`.
- Individual response upsert assumes a unique key exists on the `Responses` table (commonly `(SurveyID, ParticipantID, QuestionID)`).

---

## Usage Examples (only where helpful)

### Submit answers for a survey

```bash
curl -s -X POST \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "question_responses": [
      { "question_id": 101, "response_value": "Yes" },
      { "question_id": 102, "response_value": "5" }
    ]
  }' \
  http://localhost:8000/<mount-prefix>/surveys/10/submit