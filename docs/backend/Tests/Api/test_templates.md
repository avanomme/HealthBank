# Survey Templates CRUD API Tests (`test_templates.py`)

TDD (red-phase) test suite for the Survey Templates CRUD API. These tests are written before the templates endpoints exist and are expected to fail until the Templates API is implemented (referenced as “Task 013” in comments).

Endpoints under test:

- `POST   /api/v1/templates` — Create template
- `GET    /api/v1/templates` — List templates (with optional filtering)
- `GET    /api/v1/templates/{id}` — Get a single template (including questions)
- `PUT    /api/v1/templates/{id}` — Update template (fields, visibility, and questions)
- `DELETE /api/v1/templates/{id}` — Delete template (preserving bank questions)
- `POST   /api/v1/templates/{id}/duplicate` — Duplicate template (copy, including questions)

This test module assumes integration with the Question Bank API (`/api/v1/questions`) for creating and attaching question IDs.

## Overview

A Template is a reusable definition of a survey-like structure that references Question Bank items. Templates support:

- Public/private visibility (`is_public`)
- Attaching questions via `question_ids`
- Preserving question display order as supplied by `question_ids`
- Returning question details when fetching a template
- Returning question counts when listing templates
- Duplicating an existing template into a new one, including question associations

Deletion of a template should remove only the template and its link rows, not the underlying question bank entries.

## Architecture / Design

### Test Organization

The module is grouped by endpoint behavior:

- `TestCreateTemplate`
- `TestGetTemplates`
- `TestGetSingleTemplate`
- `TestUpdateTemplate`
- `TestDeleteTemplate`
- `TestDuplicateTemplate`

This structure supports incremental development where each endpoint can be implemented and verified independently.

### Fixtures

Two request-body fixtures define the expected shapes:

- `sample_template()`: a basic template without questions
  - `title: str`
  - `description: str`
  - `is_public: bool`

- `sample_template_with_questions(client)`: creates questions first via `/api/v1/questions` then returns a template payload including:
  - `question_ids: list[int]`

A `client()` fixture returns a `fastapi.testclient.TestClient` bound to `app.main.app`.

Implementation note (in code): the client fixture may need updating once the templates router is added to `main.py` in Task 013.

### Assumed Data Model (Inferred From Tests)

Responses imply the API returns normalized fields:

- **Template**
  - `template_id: int` (server-generated)
  - `title: str`
  - `description: str | None`
  - `is_public: bool`
  - `questions: list[Question]` (included for create/get/update/duplicate in tests)
  - `question_count: int` (included in list responses)

- **Question (embedded)**
  - Must include at least:
    - `question_id: int`
    - `question_content: str` (asserted in get-single template test)

### Ordering Semantics

The `test_create_template_with_question_order` test requires that question order in the response matches the input `question_ids` order:

- If `question_ids = [q2, q1]`, then:
  - `questions[0].question_id == q2`
  - `questions[1].question_id == q1`

This implies the template-question link table (or equivalent) must preserve display order, and the API must return questions sorted by that order.

## Configuration

Run all tests:

```bash
pytest -q