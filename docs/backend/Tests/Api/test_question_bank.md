# Question Bank CRUD API Tests (`test_question_bank.py`)

TDD (red-phase) test suite for the Question Bank CRUD API. These tests are intentionally written before the API exists and are expected to fail until the corresponding router/handlers are implemented.

Endpoints under test:

- `POST   /api/v1/questions` — Create question
- `GET    /api/v1/questions` — List questions (with optional filters)
- `GET    /api/v1/questions/{id}` — Get single question
- `PUT    /api/v1/questions/{id}` — Update question (including options)
- `DELETE /api/v1/questions/{id}` — Delete question (including cascade delete of options)

## Overview

This module defines expected behavior for a Question Bank API that supports:

- Creating questions with different `response_type` values (e.g., numeric vs. choice-based).
- Storing optional `options` only for choice-type questions.
- Listing questions with server-side filtering via query parameters.
- Updating questions and (for choice questions) replacing/updating their options.
- Deleting questions and ensuring options are deleted as well (CASCADE semantics).

The tests are structured in a way that models how the API should behave from a client’s perspective, including validation and error codes.

## Architecture / Design

### Test Organization

The file is organized by operation:

- `TestCreateQuestion`
- `TestGetQuestions`
- `TestGetSingleQuestion`
- `TestUpdateQuestion`
- `TestDeleteQuestion`

Each class targets a specific endpoint/behavior area, making it straightforward to implement the API incrementally and watch tests turn green.

### Fixtures

Three pytest fixtures provide reusable test inputs and an HTTP client:

- `client()`
  - Returns `fastapi.testclient.TestClient(app)` created from `app.main.app`
  - Note in code indicates it may need updating once the router is added to `main.py`

- `sample_question()`
  - Minimal “number” question (no `options` field)
  - Fields:
    - `title`, `question_content`, `response_type`, `is_required`, `category`

- `sample_choice_question()`
  - Choice question with `options`
  - Each option includes:
    - `option_text: str`
    - `display_order: int`

### Assumed Data Model (Inferred From Tests)

The API is expected to work with a structure similar to:

- **Question**
  - `question_id: int` (server-generated)
  - `title: str`
  - `question_content: str`
  - `response_type: str`
  - `is_required: bool`
  - `category: str | None` (category is used heavily in filtering tests)

- **Option** (for choice-based questions)
  - `option_text: str`
  - `display_order: int`

The tests imply that options are returned inline under the parent question response.

## Configuration

No special configuration is required to execute the tests beyond the application being importable from:

- `app.main import app`

Run all tests:

```bash
pytest -q