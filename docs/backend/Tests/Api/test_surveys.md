# Survey CRUD API Tests (`test_surveys.py`)

TDD (red-phase) test suite for the Survey CRUD API. These tests are written before the survey endpoints exist and are expected to fail until the Survey API is implemented (referenced as “Task 008” in comments).

Endpoints under test:

- `POST   /api/v1/surveys` — Create survey
- `GET    /api/v1/surveys` — List surveys (optionally filtered)
- `GET    /api/v1/surveys/{id}` — Get a single survey (including questions)
- `PUT    /api/v1/surveys/{id}` — Update a survey (including attached questions)
- `DELETE /api/v1/surveys/{id}` — Delete a survey

This test module also assumes integration with the Question Bank API (`/api/v1/questions`) for creating and attaching question IDs to surveys.

## Overview

The Survey API is expected to support:

- Creating surveys in `draft` or `published` states
- Optionally attaching questions at create-time using `question_ids`
- Listing all surveys and filtering by `publication_status`
- Fetching a survey with its attached questions
- Updating survey fields (title, description) and updating attached questions
- Deleting draft surveys and ensuring question link rows are removed while questions remain

Several behaviors are explicitly marked as “TBD” in tests (notably editing published surveys), indicating some requirements are not finalized.

## Architecture / Design

### Test Organization

The file groups tests by endpoint behavior:

- `TestCreateSurvey`
- `TestGetSurveys`
- `TestGetSingleSurvey`
- `TestUpdateSurvey`
- `TestDeleteSurvey`

Each group validates both success paths and error handling (validation errors, not found cases).

### Fixtures

Two primary data fixtures define expected request shapes:

- `sample_survey()`: a basic draft survey without questions
  - `title: str`
  - `description: str`
  - `publication_status: "draft"`

- `sample_survey_with_questions()`: a survey including attached question IDs
  - includes `question_ids: list[int]`

A `client()` fixture returns a `fastapi.testclient.TestClient` bound to `app.main.app`.

Implementation note (in code): this fixture may need updating when the surveys router is added to `main.py` in Task 008.

### Assumed Data Model (Inferred From Tests)

The responses imply the API returns normalized fields:

- **Survey**
  - `survey_id: int` (server-generated)
  - `title: str`
  - `description: str | None`
  - `publication_status: str` (expected at least `draft` and `published`)
  - `questions: list[Question]` (only when requested/available)

- **Question (embedded in survey response)**
  - Not fully specified in this test module, but presence and list length are validated.

### Dependency on Question Bank

Several tests create questions via `/api/v1/questions` and then attach them to surveys through `question_ids`.

This implies:

- The Survey API must validate that provided question IDs exist.
- The Survey API should embed question details in the `questions` field when returning a survey.

## Configuration

Run all tests:

```bash
pytest -q