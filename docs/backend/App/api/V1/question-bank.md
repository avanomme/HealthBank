<!-- Created with the Assistance of Claude Code -->
# Question Bank API

The Question Bank API provides CRUD operations for managing reusable survey questions.

## Base URL

```
/api/v1/questions
```

## Endpoints

### Create Question

**POST** `/api/v1/questions`

Create a new question in the question bank.

**Request Body:**
```json
{
  "title": "Sleep Hours",
  "question_content": "How many hours of sleep do you get per night?",
  "response_type": "number",
  "is_required": true,
  "category": "Sleep"
}
```

**Response Types:**
- `number` - Numeric input
- `yesno` - Yes/No toggle
- `openended` - Free text response
- `single_choice` - Select one option
- `multi_choice` - Select multiple options
- `scale` - Rating scale (1-10)

**For Choice Questions (single_choice, multi_choice):**
```json
{
  "title": "Exercise Frequency",
  "question_content": "How often do you exercise?",
  "response_type": "single_choice",
  "is_required": true,
  "category": "Exercise",
  "options": [
    {"option_text": "Never", "display_order": 1},
    {"option_text": "1-2 times per week", "display_order": 2},
    {"option_text": "3-4 times per week", "display_order": 3},
    {"option_text": "Daily", "display_order": 4}
  ]
}
```

**Response:** `201 Created`
```json
{
  "question_id": 1,
  "title": "Sleep Hours",
  "question_content": "How many hours of sleep do you get per night?",
  "response_type": "number",
  "is_required": true,
  "category": "Sleep",
  "created_at": "2026-01-22T12:00:00Z"
}
```

---

### List Questions

**GET** `/api/v1/questions`

Get all questions from the question bank.

**Query Parameters:**
- `category` (optional) - Filter by category
- `response_type` (optional) - Filter by response type

**Examples:**
```
GET /api/v1/questions
GET /api/v1/questions?category=Sleep
GET /api/v1/questions?response_type=number
```

**Response:** `200 OK`
```json
[
  {
    "question_id": 1,
    "title": "Sleep Hours",
    "question_content": "How many hours of sleep do you get per night?",
    "response_type": "number",
    "is_required": true,
    "category": "Sleep"
  },
  {
    "question_id": 2,
    "title": "Exercise Frequency",
    "question_content": "How often do you exercise?",
    "response_type": "single_choice",
    "is_required": true,
    "category": "Exercise",
    "options": [...]
  }
]
```

---

### Get Single Question

**GET** `/api/v1/questions/{question_id}`

Get a specific question by ID, including options for choice questions.

**Response:** `200 OK`
```json
{
  "question_id": 2,
  "title": "Exercise Frequency",
  "question_content": "How often do you exercise?",
  "response_type": "single_choice",
  "is_required": true,
  "category": "Exercise",
  "options": [
    {"option_id": 1, "option_text": "Never", "display_order": 1},
    {"option_id": 2, "option_text": "1-2 times per week", "display_order": 2},
    {"option_id": 3, "option_text": "3-4 times per week", "display_order": 3},
    {"option_id": 4, "option_text": "Daily", "display_order": 4}
  ],
  "created_at": "2026-01-22T12:00:00Z",
  "updated_at": "2026-01-22T12:00:00Z"
}
```

**Error Response:** `404 Not Found`
```json
{
  "detail": "Question not found"
}
```

---

### Update Question

**PUT** `/api/v1/questions/{question_id}`

Update an existing question. For choice questions, options are replaced entirely.

**Request Body:**
```json
{
  "title": "Updated Title",
  "question_content": "Updated question text?",
  "response_type": "number",
  "is_required": false,
  "category": "General"
}
```

**Response:** `200 OK`
```json
{
  "question_id": 1,
  "title": "Updated Title",
  "question_content": "Updated question text?",
  "response_type": "number",
  "is_required": false,
  "category": "General",
  "updated_at": "2026-01-22T14:00:00Z"
}
```

---

### Delete Question

**DELETE** `/api/v1/questions/{question_id}`

Delete a question. Options are deleted automatically (CASCADE).

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

---

## Error Responses

### Validation Error (422)
```json
{
  "detail": [
    {
      "loc": ["body", "question_content"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

### Not Found (404)
```json
{
  "detail": "Question not found"
}
```

---

## Database Tables

Questions are stored in `QuestionBank` with options in `QuestionOptions`.

See [Database Schema](../database/schema.md) for table definitions.

---

## Security

**CRITICAL:** All database queries MUST use parameterized queries.

```python
# CORRECT
cursor.execute(
    "SELECT * FROM QuestionBank WHERE QuestionID = %s",
    (question_id,)
)

# WRONG - SQL Injection vulnerable
cursor.execute(f"SELECT * FROM QuestionBank WHERE QuestionID = {question_id}")
```

---

## Implementation Status

- [x] POST /api/v1/questions (Task 006)
- [x] GET /api/v1/questions (Task 006)
- [x] GET /api/v1/questions/{id} (Task 006)
- [x] PUT /api/v1/questions/{id} (Task 006)
- [x] DELETE /api/v1/questions/{id} (Task 006)
