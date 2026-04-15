<!-- Created with the Assistance of Claude Code -->
# Surveys API

The Surveys API provides CRUD operations for managing surveys.

## Base URL

```
/api/v1/surveys
```

## Endpoints

### Create Survey

**POST** `/api/v1/surveys`

Create a new survey.

**Request Body:**
```json
{
  "title": "Health Assessment Survey",
  "description": "A survey to assess general health status",
  "publication_status": "draft",
  "question_ids": [1, 2, 3]
}
```

**Fields:**
- `title` (required) - Survey title
- `description` (optional) - Detailed description
- `publication_status` (optional) - "draft" (default), "published", or "closed"
- `question_ids` (optional) - Array of QuestionBank IDs to attach

**Response:** `201 Created`
```json
{
  "survey_id": 1,
  "title": "Health Assessment Survey",
  "description": "A survey to assess general health status",
  "publication_status": "draft",
  "status": "not-started",
  "questions": [
    {
      "question_id": 1,
      "title": "Sleep Hours",
      "question_content": "How many hours...?",
      "response_type": "number"
    }
  ],
  "created_at": "2026-01-22T12:00:00Z"
}
```

---

### Create Survey from Template

**POST** `/api/v1/surveys/from-template/{template_id}`

Create a new survey by copying all questions from an existing template.

**Path Parameters:**
- `template_id` (required) - ID of the template to create survey from

**Request Body (optional):**
```json
{
  "title": "Custom Survey Title",
  "description": "Custom description"
}
```

**Fields:**
- `title` (optional) - Override the template's title
- `description` (optional) - Override the template's description

If no body is provided, or fields are omitted, the template's title and description are used.

**Response:** `201 Created`
```json
{
  "survey_id": 2,
  "title": "Health Assessment Template",
  "description": "A reusable template for health assessments",
  "publication_status": "draft",
  "status": "not-started",
  "questions": [
    {
      "question_id": 1,
      "title": "Sleep Hours",
      "question_content": "How many hours of sleep do you get?",
      "response_type": "number",
      "is_required": true
    }
  ],
  "question_count": 3,
  "created_at": "2026-01-22T12:00:00Z"
}
```

**Error Responses:**
- `404 Not Found` - Template does not exist

**Notes:**
- Survey is always created in 'draft' status
- All questions from the template are copied to the survey
- Question order from the template is preserved

---

### List Surveys

**GET** `/api/v1/surveys`

Get all surveys.

**Query Parameters:**
- `publication_status` (optional) - Filter by status: "draft", "published", "closed"
- `creator_id` (optional) - Filter by creator (when auth is implemented)

**Examples:**
```
GET /api/v1/surveys
GET /api/v1/surveys?publication_status=published
GET /api/v1/surveys?publication_status=draft
```

**Response:** `200 OK`
```json
[
  {
    "survey_id": 1,
    "title": "Health Assessment Survey",
    "description": "A survey to assess general health status",
    "publication_status": "draft",
    "status": "not-started",
    "question_count": 5,
    "created_at": "2026-01-22T12:00:00Z"
  }
]
```

---

### Get Single Survey

**GET** `/api/v1/surveys/{survey_id}`

Get a specific survey by ID, including all attached questions.

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Health Assessment Survey",
  "description": "A survey to assess general health status",
  "publication_status": "draft",
  "status": "not-started",
  "start_date": null,
  "end_date": null,
  "questions": [
    {
      "question_id": 1,
      "title": "Sleep Hours",
      "question_content": "How many hours of sleep do you get?",
      "response_type": "number",
      "is_required": true,
      "options": null
    },
    {
      "question_id": 2,
      "title": "Exercise Frequency",
      "question_content": "How often do you exercise?",
      "response_type": "single_choice",
      "is_required": true,
      "options": [
        {"option_id": 1, "option_text": "Never", "display_order": 1},
        {"option_id": 2, "option_text": "Weekly", "display_order": 2}
      ]
    }
  ],
  "created_at": "2026-01-22T12:00:00Z",
  "updated_at": "2026-01-22T12:00:00Z"
}
```

**Error Response:** `404 Not Found`
```json
{
  "detail": "Survey not found"
}
```

---

### Update Survey

**PUT** `/api/v1/surveys/{survey_id}`

Update an existing survey. Questions can be replaced entirely.

**Request Body:**
```json
{
  "title": "Updated Survey Title",
  "description": "Updated description",
  "publication_status": "draft",
  "question_ids": [1, 2, 4, 5]
}
```

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Updated Survey Title",
  "description": "Updated description",
  "publication_status": "draft",
  "questions": [...],
  "updated_at": "2026-01-22T14:00:00Z"
}
```

**Notes:**
- Published surveys may have restrictions on which fields can be edited
- Updating `question_ids` replaces all existing question links

---

### Delete Survey

**DELETE** `/api/v1/surveys/{survey_id}`

Delete a survey. Question links are removed but questions remain in QuestionBank.

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

**Notes:**
- Cannot delete surveys with existing responses (returns 400)
- Question links (QuestionList) are deleted with the survey

---

## Publication Status Workflow

Surveys follow a publication lifecycle:

```
draft → published → closed
```

| Status | Description |
|--------|-------------|
| `draft` | Survey is being created/edited. Not visible to participants. |
| `published` | Survey is live and accepting responses. |
| `closed` | Survey is complete, no longer accepting responses. |

### Publish Survey

**PATCH** `/api/v1/surveys/{survey_id}/publish`

Publish a draft survey, making it available for responses.

**Validation:**
- Survey must exist
- Survey must be in 'draft' status
- Survey must have at least one question attached

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Health Assessment Survey",
  "publication_status": "published",
  "questions": [...],
  "updated_at": "2026-01-22T14:00:00Z"
}
```

**Error Responses:**
- `404 Not Found` - Survey does not exist
- `400 Bad Request` - Survey is not in 'draft' status
- `400 Bad Request` - Survey has no questions

---

### Close Survey

**PATCH** `/api/v1/surveys/{survey_id}/close`

Close a published survey, stopping it from accepting new responses.

**Validation:**
- Survey must exist
- Survey must be in 'published' status

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Health Assessment Survey",
  "publication_status": "closed",
  "questions": [...],
  "updated_at": "2026-01-22T15:00:00Z"
}
```

**Error Responses:**
- `404 Not Found` - Survey does not exist
- `400 Bad Request` - Survey is not in 'published' status

---

## Survey Assignments

Survey assignments allow assigning published surveys to specific users with optional due dates.

### Assign Survey to Users

**POST** `/api/v1/surveys/{survey_id}/assign`

Assign a published survey to one or more users.

**Request Body (single user):**
```json
{
  "account_id": 1,
  "due_date": "2026-02-01T12:00:00Z"
}
```

**Request Body (multiple users):**
```json
{
  "account_ids": [1, 2, 3],
  "due_date": "2026-02-01T12:00:00Z"
}
```

**Response:** `201 Created`
```json
{
  "assignment_id": 1,
  "survey_id": 1,
  "account_id": 1,
  "assigned_at": "2026-01-22T12:00:00Z",
  "due_date": "2026-02-01T12:00:00Z",
  "status": "pending"
}
```

**Validation:**
- Survey must exist and be in 'published' status
- User cannot already have an active assignment for the same survey

**Error Responses:**
- `400 Bad Request` - Survey not published or closed
- `404 Not Found` - Survey or user not found
- `409 Conflict` - Duplicate assignment

---

### List Survey Assignments

**GET** `/api/v1/surveys/{survey_id}/assignments`

Get all assignments for a specific survey.

**Query Parameters:**
- `status` (optional) - Filter by status: "pending", "completed", "expired"

**Response:** `200 OK`
```json
[
  {
    "assignment_id": 1,
    "survey_id": 1,
    "account_id": 1,
    "assigned_at": "2026-01-22T12:00:00Z",
    "due_date": "2026-02-01T12:00:00Z",
    "completed_at": null,
    "status": "pending"
  }
]
```

---

### Get My Assignments

**GET** `/api/v1/assignments/me`

Get all assignments for the current user.

**Query Parameters:**
- `status` (optional) - Filter by status
- `account_id` (temporary) - Until auth is implemented

**Response:** `200 OK`
```json
[
  {
    "assignment_id": 1,
    "survey_id": 1,
    "survey_title": "Health Assessment",
    "assigned_at": "2026-01-22T12:00:00Z",
    "due_date": "2026-02-01T12:00:00Z",
    "status": "pending"
  }
]
```

---

### Update Assignment

**PUT** `/api/v1/assignments/{assignment_id}`

Update an assignment (due date or status).

**Request Body:**
```json
{
  "due_date": "2026-02-15T12:00:00Z",
  "status": "completed"
}
```

**Response:** `200 OK`

**Notes:**
- Setting status to "completed" auto-sets `completed_at` timestamp

---

### Delete Assignment

**DELETE** `/api/v1/assignments/{assignment_id}`

Remove an assignment. Cannot delete completed assignments.

**Response:** `204 No Content`

**Error Responses:**
- `400 Bad Request` - Cannot delete completed assignment
- `404 Not Found` - Assignment not found

---

## Error Responses

### Validation Error (422)
```json
{
  "detail": [
    {
      "loc": ["body", "title"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

### Not Found (404)
```json
{
  "detail": "Survey not found"
}
```

### Bad Request (400)
```json
{
  "detail": "Cannot delete survey with existing responses"
}
```

---

## Database Tables

Surveys use these tables:
- `Survey` - Main survey data
- `QuestionList` - Links surveys to questions (many-to-many)
- `QuestionBank` - Question definitions
- `SurveyAssignment` - Assignment to participants (Task 010-011)

See [Database Schema](../database/schema.md) for table definitions.

---

## Security

**CRITICAL:** All database queries MUST use parameterized queries.

```python
# CORRECT
cursor.execute(
    "SELECT * FROM Survey WHERE SurveyID = %s",
    (survey_id,)
)

# WRONG - SQL Injection vulnerable
cursor.execute(f"SELECT * FROM Survey WHERE SurveyID = {survey_id}")
```

---

## Implementation Status

- [x] POST /api/v1/surveys (Task 008)
- [x] POST /api/v1/surveys/from-template/{id} (Task 014)
- [x] GET /api/v1/surveys (Task 008)
- [x] GET /api/v1/surveys/{id} (Task 008)
- [x] PUT /api/v1/surveys/{id} (Task 008)
- [x] DELETE /api/v1/surveys/{id} (Task 008)
- [x] PATCH /api/v1/surveys/{id}/publish (Task 009)
- [x] PATCH /api/v1/surveys/{id}/close (Task 009)
- [x] POST /api/v1/surveys/{id}/assign (Task 011)
- [x] GET /api/v1/surveys/{id}/assignments (Task 011)
- [x] GET /api/v1/assignments/me (Task 011)
- [x] PUT /api/v1/assignments/{id} (Task 011)
- [x] DELETE /api/v1/assignments/{id} (Task 011)
