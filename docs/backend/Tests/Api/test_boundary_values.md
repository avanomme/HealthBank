# Boundary Value Tests (`backend/tests/api/test_boundary_values.py`)

## Overview

This module applies **Boundary Value Analysis (BVA)** across multiple Survey System APIs. For fields with constraints, tests are designed around:

- Valid “middle” value
- Lower-bound edge and near-edge (inside/outside)
- Upper-bound edge and near-edge (inside/outside)

The suite validates both **input validation** (schema constraints) and **business-rule edge behavior** where rules may be implementation-dependent.

APIs covered:

- Question Bank API (`/api/v1/questions`, `/api/v1/questions/{id}`)
- Survey API (`/api/v1/surveys`, `/api/v1/surveys/{id}`)
- Survey Assignment API (`/api/v1/surveys/{id}/assign`, `/api/v1/assignments/{id}`)
- Template API (`/api/v1/templates`, `/api/v1/templates/{id}`)
- ID boundary behavior across multiple resources

---

## Architecture / Design

### Test organization

The file is organized into endpoint-specific test groups, each with nested classes for constraint categories:

- `TestQuestionBoundaryValues`
  - `TestTitleBoundaries`
  - `TestResponseTypeBoundaries`
  - `TestOptionsBoundaries`
- `TestSurveyBoundaryValues`
  - `TestTitleBoundaries`
  - `TestPublicationStatusBoundaries`
  - `TestQuestionCountBoundaries`
  - `TestDateBoundaries`
- `TestAssignmentBoundaryValues`
  - `TestDueDateBoundaries`
  - `TestBulkAssignmentBoundaries`
- `TestTemplateBoundaryValues`
  - `TestQuestionOrderBoundaries`
  - `TestVisibilityBoundaries`
- `TestIDsBoundaryValues`

### Handling ambiguous business rules

Several tests allow multiple acceptable outcomes depending on how business rules are defined (e.g., “accept or reject”):

- Empty question title: `status_code in [201, 422]`
- Title exceeding max: `status_code in [201, 422]` (truncate vs reject)
- Start date in past: `status_code in [201, 422]`
- End date before start: `status_code in [201, 422]` (expected reject but allows accept)
- Assignment due date in past: `status_code in [201, 422]`
- Single choice question with 1 option or empty options: `status_code in [201, 422]`

This is intentional in BVA when requirements are not fully specified.

### Dependency assumptions

This file references fixtures that are **not defined inside the file**:

- `client`
- `published_survey`
- `sample_assignment`

It assumes they are provided by other test modules (e.g., the assignments test suite) or by shared `conftest.py`.

---

## Configuration

### Time-based boundary values

Date inputs use runtime-relative timestamps:

- `datetime.now()` plus/minus `timedelta(...)`
- ISO serialization via `.isoformat()`

This means outcomes can depend on server-side timezone handling and whether the API normalizes times.

### Expected constraints encoded by tests

The tests encode several expected constraints (even if implementation may differ):

#### Questions
- `title`: 1–128 characters (implied by tests)
- `response_type`: must be one of:
  - `number`, `yesno`, `openended`, `single_choice`, `multi_choice`, `scale`
- `response_type` is case-sensitive (lowercase required)
- `options`: may be required for choice types; count constraints are explored (0, 1, 2, many)

#### Surveys
- `title`: required, non-empty; accepts up to 255 characters
- `publication_status`: must be one of `draft`, `published`, `closed`
- `question_ids`: can be empty; tested at 0, 1, 10 questions
- date logic: start/end boundaries and ordering

#### Assignments
- due date can be absent (`None`) and must serialize correctly
- bulk assignment list size boundaries
- empty bulk list should be rejected (`422`)

#### Templates
- question order must be preserved as provided in `question_ids`
- `is_public` default is `False`
- explicitly setting `is_public` to `True/False` should be reflected

#### IDs
- zero and negative ID access behavior
- very large nonexistent IDs should return `404`
- assignment deletion of nonexistent ID should return `404`

---

## API Reference

This section documents the behaviors asserted by the boundary tests.

### Question Bank API

#### `POST /api/v1/questions`

**Request fields used**
- `title: str`
- `question_content: str`
- `response_type: str`
- `options: list[dict]` (for choice types)
  - `option_text: str`
  - `display_order: int`

**Title boundary expectations**
- Accepts 1-char titles (`201`)
- Accepts 50-char titles (`201`)
- Accepts 128-char titles (`201`)
- For empty title (`""`): implementation may reject (`422`) or accept (`201`)
- For 129-char title: implementation may reject (`422`) or accept (`201`) (truncate vs reject)

**Response type expectations**
- Accepts all supported types and echoes `response_type` in response JSON
- Rejects unknown types (`422`)
- Rejects uppercase/case-mismatched values (`422`)

**Options expectations**
- Single choice with 2 options should be accepted and return 2 options
- Single choice with 1 option or 0 options may be accepted or rejected
- Single choice with 10 options should be accepted and return 10 options

---

### Survey API

#### `POST /api/v1/surveys`

**Request fields used**
- `title: str`
- `description: str` (optional)
- `publication_status: str` (optional)
- `question_ids: list[int]` (optional)
- `start_date: str` (optional ISO datetime)
- `end_date: str` (optional ISO datetime)

**Title boundary expectations**
- Title required and non-empty (`422` for empty or missing)
- Accepts 1-char titles (`201`)
- Accepts 100-char titles (`201`)
- Accepts up to 255-char titles (`201`)

**Publication status expectations**
- Accepts: `draft`, `published`, `closed`
- Rejects unsupported status values (e.g., `"pending"`) with `422`

**Question count expectations**
- Survey can be created with zero questions (`question_ids: []`) and should reflect 0 questions
- Survey with exactly 1 question should return 1 question in response
- Survey with 10 questions should return 10 questions in response

**Date boundary expectations**
- Start date in past: may be accepted (`201`) or rejected (`422`)
- Start date today: should be accepted (`201`)
- End date before start date: should be rejected, but test allows `201` or `422`
- End date equal start date: accepted (`201`)

---

### Assignment API

#### `POST /api/v1/surveys/{id}/assign`

**Request fields used**
- `account_id: int` (single assignment)
- `account_ids: list[int]` (bulk assignment)
- `due_date: str | None` (optional)

**Due date boundary expectations**
- Future due dates accepted (`201`)
- Far-future due date (1 year) accepted (`201`)
- Past due date may be accepted or rejected (`201` or `422`)
- Due date equal to “today” accepted (`201`)
- Missing due date accepted and returns `due_date == None`

**Bulk boundary expectations**
- Assigning to one user via `account_id` accepted (`201`)
- Assigning to 10 users via `account_ids` accepted (`201`) and returns list of length 10 if response is list
- Assigning with `account_ids: []` rejected (`422`)

---

### Template API

#### `POST /api/v1/templates`

**Request fields used**
- `title: str`
- `question_ids: list[int]`
- `is_public: bool` (optional)

**Order boundary expectations**
- Response must preserve question order exactly as provided in `question_ids`

**Visibility boundary expectations**
- Default `is_public == False`
- Explicit `is_public == True` preserved
- Explicit `is_public == False` preserved

---

### ID Boundary Behavior

#### `GET /api/v1/questions/{id}`
- `id == 0` returns `404`
- `id < 0` returns `404` or `422`

#### `GET /api/v1/surveys/{id}`
- `id == 0` returns `404`
- very large nonexistent `id` returns `404`

#### `GET /api/v1/templates/{id}`
- `id == 0` returns `404`

#### `DELETE /api/v1/assignments/{id}`
- nonexistent assignment ID returns `404`

---

## Parameters and Return Types

### Request payloads
- `dict[str, Any]` payloads with endpoint-specific keys
- Date fields are ISO strings from `datetime.isoformat()`
- Options arrays contain dicts with `option_text` and `display_order`

### Response payload expectations (high-level)
- Create endpoints: `201` with JSON that echoes key fields (e.g., question title, response_type, options)
- Get endpoints: `200` with JSON resource or `404` when not found
- Delete endpoints: typically `204` on success or `404` on missing

---

## Error Handling

This suite validates error handling at boundary conditions:

- `422` for schema/validation failures:
  - invalid enum values (`response_type`, `publication_status`)
  - missing required fields (survey title)
  - empty bulk assignment list
- `404` for nonexistent resources and invalid IDs in path
- Some cases intentionally accept either `201` or `422` to accommodate undefined business rules (truncate vs reject, date constraints, option count constraints)

---

## Usage Examples

### Run only this file

```bash
pytest backend/tests/api/test_boundary_values.py -q