<!-- Created with the Assistance of Claude Code -->
# Survey Templates API

The Templates API provides CRUD operations for managing reusable survey templates.

## Base URL

```
/api/v1/templates
```

## Overview

Survey templates are reusable collections of questions that can be used to quickly create new surveys. Templates can be public (shared) or private (creator only).

---

## Endpoints

### Create Template

**POST** `/api/v1/templates`

Create a new survey template.

**Request Body:**
```json
{
  "title": "Health Assessment Template",
  "description": "A reusable template for health assessments",
  "is_public": false,
  "question_ids": [1, 2, 3]
}
```

**Fields:**
- `title` (required) - Template title
- `description` (optional) - Detailed description
- `is_public` (optional) - Whether template is publicly visible (default: false)
- `question_ids` (optional) - Array of QuestionBank IDs to include (order is preserved)

**Response:** `201 Created`
```json
{
  "template_id": 1,
  "title": "Health Assessment Template",
  "description": "A reusable template for health assessments",
  "is_public": false,
  "questions": [
    {
      "question_id": 1,
      "title": "Sleep Hours",
      "question_content": "How many hours...?",
      "response_type": "number",
      "display_order": 0
    }
  ],
  "question_count": 3,
  "created_at": "2026-01-22T12:00:00Z"
}
```

---

### List Templates

**GET** `/api/v1/templates`

Get all templates accessible to the current user.

**Query Parameters:**
- `is_public` (optional) - Filter by visibility: "true" or "false"
- `creator_id` (optional) - Filter by creator (when auth is implemented)

**Examples:**
```
GET /api/v1/templates
GET /api/v1/templates?is_public=true
```

**Response:** `200 OK`
```json
[
  {
    "template_id": 1,
    "title": "Health Assessment Template",
    "description": "A reusable template for health assessments",
    "is_public": true,
    "question_count": 5,
    "created_at": "2026-01-22T12:00:00Z"
  }
]
```

---

### Get Single Template

**GET** `/api/v1/templates/{template_id}`

Get a specific template by ID, including all questions.

**Response:** `200 OK`
```json
{
  "template_id": 1,
  "title": "Health Assessment Template",
  "description": "A reusable template for health assessments",
  "is_public": false,
  "questions": [
    {
      "question_id": 1,
      "title": "Sleep Hours",
      "question_content": "How many hours of sleep do you get?",
      "response_type": "number",
      "is_required": true,
      "display_order": 0,
      "options": null
    },
    {
      "question_id": 2,
      "title": "Exercise Frequency",
      "question_content": "How often do you exercise?",
      "response_type": "single_choice",
      "is_required": true,
      "display_order": 1,
      "options": [
        {"option_id": 1, "option_text": "Never", "display_order": 1},
        {"option_id": 2, "option_text": "Weekly", "display_order": 2}
      ]
    }
  ],
  "question_count": 2,
  "created_at": "2026-01-22T12:00:00Z",
  "updated_at": "2026-01-22T12:00:00Z"
}
```

**Error Response:** `404 Not Found`
```json
{
  "detail": "Template not found"
}
```

---

### Update Template

**PUT** `/api/v1/templates/{template_id}`

Update an existing template.

**Request Body:**
```json
{
  "title": "Updated Template Title",
  "description": "Updated description",
  "is_public": true,
  "question_ids": [1, 2, 4, 5]
}
```

**Response:** `200 OK`

**Notes:**
- Updating `question_ids` replaces all existing question links
- Question order is preserved based on array order

---

### Delete Template

**DELETE** `/api/v1/templates/{template_id}`

Delete a template. Questions remain in QuestionBank.

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

---

### Duplicate Template

**POST** `/api/v1/templates/{template_id}/duplicate`

Create a copy of an existing template with all its questions.

**Response:** `201 Created`
```json
{
  "template_id": 2,
  "title": "Health Assessment Template (Copy)",
  "description": "A reusable template for health assessments",
  "is_public": false,
  "questions": [...],
  "created_at": "2026-01-22T14:00:00Z"
}
```

**Notes:**
- New template is always private (is_public: false)
- Title is appended with " (Copy)"

---

## Database Tables

Templates use these tables:
- `SurveyTemplate` - Template metadata
- `TemplateQuestions` - Links templates to questions (many-to-many with order)
- `QuestionBank` - Question definitions

### SurveyTemplate Schema
```sql
CREATE TABLE SurveyTemplate (
  TemplateID INT PRIMARY KEY AUTO_INCREMENT,
  Title VARCHAR(255) NOT NULL,
  Description TEXT,
  CreatorID INT,
  IsPublic BOOLEAN DEFAULT FALSE,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### TemplateQuestions Schema
```sql
CREATE TABLE TemplateQuestions (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  TemplateID INT NOT NULL,
  QuestionID INT NOT NULL,
  DisplayOrder INT DEFAULT 0,
  UNIQUE KEY unique_template_question (TemplateID, QuestionID)
);
```

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
  "detail": "Template not found"
}
```

---

## Security

**CRITICAL:** All database queries MUST use parameterized queries.

```python
# CORRECT
cursor.execute(
    "SELECT * FROM SurveyTemplate WHERE TemplateID = %s",
    (template_id,)
)

# WRONG - SQL Injection vulnerable
cursor.execute(f"SELECT * FROM SurveyTemplate WHERE TemplateID = {template_id}")
```

---

## Implementation Status

- [x] POST /api/v1/templates (Task 013)
- [x] GET /api/v1/templates (Task 013)
- [x] GET /api/v1/templates/{id} (Task 013)
- [x] PUT /api/v1/templates/{id} (Task 013)
- [x] DELETE /api/v1/templates/{id} (Task 013)
- [x] POST /api/v1/templates/{id}/duplicate (Task 013)
