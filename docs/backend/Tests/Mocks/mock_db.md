# In-Memory Database Mock (`backend/tests/mocks/db.py`)

In-memory database mock used by backend tests to simulate MySQL behavior without a real database.

This module provides:

- `FakeCursor`: a stateful cursor that routes incoming SQL strings to in-memory handlers
- `FakeConnection`: a minimal connection wrapper that returns `FakeCursor`

It is designed to support a wide set of SQL patterns used across API modules and their tests, including authentication, sessions, questions, surveys, templates, assignments, and account request flows.

## Overview

`FakeCursor` maintains a collection of class-level “tables” implemented as dictionaries/lists and updates them in response to `execute(query, params)` calls. The cursor uses substring checks and basic regex parsing to recognize SQL statements and translate them into deterministic state changes.

Key goals:

- Provide a lightweight, deterministic replacement for DB calls in unit/integration-style API tests
- Simulate key database behaviors:
  - Auto-increment IDs (`lastrowid`)
  - Affected row counts (`rowcount`)
  - Duplicate/uniqueness failures via `mysql.connector.IntegrityError`
  - Simple `SELECT` results via `fetchone()` and `fetchall()`

## Architecture / Design

### Core Types

- `FakeCursor`
  - Implements:
    - `execute(query, params=None)`
    - `fetchone()`
    - `fetchall()`
    - `close()`
  - Maintains:
    - Per-query state (`_row`, `_rows`)
    - Write metadata (`rowcount`, `lastrowid`)
  - Contains handler methods grouped by domain (auth, questions, surveys, templates, assignments, account requests)

- `FakeConnection`
  - Implements:
    - `cursor(dictionary=False)`
    - `commit()`, `rollback()`, `close()`
  - Returns a `FakeCursor` instance and does not enforce transaction semantics.

### Routing Model

`FakeCursor.execute()` routes SQL to handlers using:

- String containment checks (e.g., `"INSERT INTO QuestionBank" in q`)
- Uppercased query prefix checks (e.g., `qu.startswith("SELECT")`)
- Regex parsing for `UPDATE ... SET ... WHERE ...` queries to determine column updates

Routing is ordered intentionally to avoid substring collisions (notably: `SurveyAssignment` and `SurveyTemplate` are routed before generic `Survey` handlers because both contain the substring `"Survey"`).

### Storage Model (“Tables”)

All storage is class-level on `FakeCursor`, so it persists across cursor instances unless reset by tests.

Auth/session/account storage:

- `roles: dict[int, str]` — role ID → role name
- `used_emails: set[str]` — used for email uniqueness checks
- `users: dict[str, str]` — email → password_hash
- `accounts: dict[str, dict]` — email → account dict
- `sessions: dict[str, dict]` — token_hash → session dict
- `next_auth_id: int`, `next_account_id: int` — auto-increment counters

Account request storage:

- `account_requests: dict[int, dict]`
- `next_request_id: int`

Domain storage (question bank, surveys, templates, assignments):

- `questions: dict[int, dict]`
- `options: dict[int, dict]`
- `surveys: dict[int, dict]`
- `question_list: list[tuple[int, int]]` — (survey_id, question_id)
- `templates: dict[int, dict]`
- `template_questions: list[tuple[int, int, int]]` — (template_id, question_id, display_order)
- `assignments: dict[int, dict]`
- `responses: list[tuple]` (present but only minimally used as a delete guard)

Auto-increment counters:

- `next_question_id`, `next_option_id`, `next_survey_id`, `next_template_id`, `next_assignment_id`

### Assumptions and Conventions

- Queries are matched by simple patterns rather than full SQL parsing.
- Some handlers return tuples (simulating non-dictionary cursors); others return dicts (simulating dictionary cursors). Tests must align with the expected shape for each query.
- Some domain areas are stubbed:
  - Responses count guard always returns `(0,)`
  - QuestionCategories select returns an empty list

## Configuration

### Typical Usage in Tests

Tests typically patch the application’s database factory to return a `FakeConnection`, e.g.:

- `patch("app.api.v1.<module>.get_db_connection", return_value=FakeConnection())`

State-reset between tests is usually required due to class-level storage. A common pattern is a fixture that clears relevant `FakeCursor.*` collections and resets `next_*` counters.

## API Reference

## `FakeConnection`

### `FakeConnection.__init__(results=None)`

- `results`: optional list used as a fallback for `fetchall()` when `_rows` is not set by handlers.

### `cursor(dictionary: bool = False) -> FakeCursor`

Returns a new `FakeCursor`. The `dictionary` parameter is accepted for compatibility but does not change behavior directly; individual query handlers control whether `fetchone()` returns tuples or dicts.

### `commit()`, `rollback()`, `close()`

No-op methods provided for compatibility with DB-API usage in application code.

## `FakeCursor`

### `FakeCursor.__init__(results=None)`

Initializes cursor state:

- `results`: fallback list returned by `fetchall()` when no handler set `_rows`
- `rowcount`: starts at `0`
- `lastrowid`: starts at `None`

### `execute(query: str, params: tuple | list | None = None) -> None`

Routes the SQL query to a specific handler, sets:

- `self._row` for `fetchone()`
- `self._rows` for `fetchall()`
- `self.rowcount` for write operations
- `self.lastrowid` for insert operations

Per-query state is reset at the start of each call:

- `_row = None`
- `_rows = None`

### `fetchone() -> Any`

Returns the last row set by `execute()` via `_row` (tuple or dict depending on handler).

### `fetchall() -> list`

Returns:

- `_rows` if set by the handler
- otherwise `self.results`

### `close() -> None`

No-op.

## Supported SQL Patterns

This mock recognizes and responds to many SQL patterns across modules. The matching is based on substring checks, so query formatting should remain consistent with what the tests and application emit.

### Auth / AccountData / Sessions

Supported patterns include:

- Insert auth row:
  - `INSERT INTO Auth ...` → `_insert_auth`
- Insert account data row:
  - `INSERT INTO AccountData ... FirstName ...` → `_insert_account_data`
- Login select:
  - `SELECT AccountData.AccountID ... Auth.PasswordHash ...` → `_select_login`
- Session create/select/delete:
  - `INSERT INTO Sessions ...` → `_insert_session`
  - `SELECT ... FROM Sessions WHERE TokenHash ...` → `_select_session`
  - `DELETE FROM Sessions ...` → `_delete_session`
- Delete account:
  - `DELETE FROM AccountData ...` → `_delete_account_data`
- Role lookup:
  - `SELECT RoleID FROM Roles WHERE RoleName = %s` → returns `(role_id,)` or `None`
- Account fetch by ID (dict row):
  - `SELECT ... FROM AccountData ... WHERE AccountID ...` → `_select_account_by_id`
- Account update (generic user fields):
  - `UPDATE AccountData SET ... WHERE AccountID = %s` → inlined update logic for:
    - `FirstName`, `LastName`, `Email`, `RoleID`, `IsActive`
- Auth update:
  - `UPDATE Auth ...` → sets `rowcount = 1` without deeper validation
- Change-password auth join select:
  - `FROM AccountData ... JOIN Auth ...` → `_select_auth_for_change_password`
- Account creation response join:
  - `FROM AccountData ... LEFT JOIN Roles ... WHERE a.AccountID = %s` → returns a tuple with key user fields

Email uniqueness simulation:
- Updating `Email` to a value already present on a different account raises `mysql.connector.IntegrityError("Duplicate entry for email")`.

### Question Bank (`QuestionBank`, `QuestionOptions`)

- `INSERT INTO QuestionBank ...` → `_insert_question`
- `INSERT INTO QuestionOptions ...` → `_insert_option`
- `SELECT ... FROM QuestionOptions ...` → `_select_options` (sorted by `DisplayOrder`)
- `DELETE FROM QuestionOptions ...` → `_delete_options`
- `DELETE FROM QuestionBank ...` → `_delete_question` (cascades options)
- `UPDATE QuestionBank ...` → `_update_question` (regex-parsed `SET` clause)
- `SELECT ... FROM QuestionBank ...`
  - Supports:
    - Existence check by ID
    - Single question by ID (with/without timestamps depending on query)
    - List with optional `Category` and/or `ResponseType` filters

### Surveys (`Survey`, `QuestionList`)

Survey table:

- `INSERT INTO Survey ...` → `_insert_survey`
- `SELECT ... FROM Survey ...`
  - Supports:
    - Existence check by ID
    - PublicationStatus check patterns
    - Single survey “full tuple”
    - List with optional `PublicationStatus` filter, sorted by `CreatedAt DESC`
- `UPDATE Survey ...` → `_update_survey`
- `DELETE FROM Survey ...` → `_delete_survey`

QuestionList link table:

- `INSERT INTO QuestionList ...` → `_insert_question_list`
- `DELETE FROM QuestionList ...` → `_delete_question_list` (removes all links for a survey)
- `SELECT COUNT ... FROM QuestionList ...` → `_count_question_list`
- `SELECT ... QuestionList ... JOIN ... QuestionBank ...` → `_select_survey_questions` (returns question tuples)

### Templates (`SurveyTemplate`, `TemplateQuestions`)

Templates:

- `INSERT INTO SurveyTemplate ...` → `_insert_template`
- `SELECT ... FROM SurveyTemplate ...`
  - Supports:
    - Existence check by ID
    - Fetch title/description
    - Fetch full template tuple
    - List with optional `IsPublic` filter, sorted by `CreatedAt DESC`
- `UPDATE SurveyTemplate ...` → `_update_template`
- `DELETE FROM SurveyTemplate ...` → `_delete_template` (cascades template_questions links)

TemplateQuestions:

- `INSERT INTO TemplateQuestions ...` → `_insert_template_question`
- `DELETE FROM TemplateQuestions ...` → `_delete_template_questions`
- `SELECT COUNT ... FROM TemplateQuestions ...` → `_count_template_questions`
- `SELECT ... FROM TemplateQuestions ...` → `_select_template_questions` (returns `(question_id, display_order)` sorted by display_order)
- `SELECT ... TemplateQuestions ... JOIN ... QuestionBank ...` → `_select_template_questions_join` (includes display_order in results)

### Survey Assignments (`SurveyAssignment`)

- `INSERT INTO SurveyAssignment ...` → `_insert_assignment`
- `SELECT ... FROM SurveyAssignment ...`
  - Supports:
    - Existence checks by assignment ID
    - Lists by `SurveyID`
    - Duplicate check by `(SurveyID, AccountID)`
- `UPDATE SurveyAssignment ...` → `_update_assignment`
- `DELETE FROM SurveyAssignment ...`
  - Supports delete by:
    - `SurveyID`
    - `AssignmentID`
- Join query pattern:
  - `SurveyAssignment ... JOIN ... Survey ...` → `_select_my_assignments` (returns assignment rows including survey title)

### Responses (Survey delete guard)

- `SELECT COUNT ... FROM Responses ...` is handled as a stub and always returns `(0,)`.

### QuestionCategories

- `SELECT ... FROM QuestionCategories ...` returns an empty list.

### Account Requests (`AccountRequest`)

- `INSERT INTO AccountRequest ...` → `_insert_account_request`
- `SELECT 1 FROM AccountRequest ...` → `_check_pending_request`
- `SELECT ... COUNT(*) ... FROM AccountRequest ...` → `_count_account_requests`
- `SELECT ... FROM AccountRequest ...`
  - Single by `RequestID`
  - List with optional status filter
- `UPDATE AccountRequest ...` → `_update_account_request`
  - Supports transitions to `approved` or `rejected` based on literal query content.

## Parameters and Return Types

### `execute(query, params)`

- `query: str`
- `params: tuple | list | None`

Return value:
- No explicit return; results are provided through `fetchone()` / `fetchall()` and metadata properties.

### Cursor metadata

- `rowcount: int`
  - Set for writes (insert/update/delete). Some updates default to `1` even when not fully simulated.

- `lastrowid: int | None`
  - Set for inserts that create new entities:
    - Auth, AccountData, QuestionBank, QuestionOptions, Survey, SurveyTemplate, SurveyAssignment, AccountRequest.

### `fetchone()`

Returns either:

- `tuple` for many selects, e.g. `(SurveyID, Title, ...)`
- `dict` for some dictionary-cursor-like operations, e.g. session rows and account request rows

Tests should match the expected shape for the specific query they issue.

### `fetchall()`

Returns:

- `list[tuple]` for many list queries
- `list[dict]` for account request listing
- empty list for stubs (e.g., QuestionCategories)

## Error Handling

This mock intentionally raises MySQL-like errors for certain constraints:

- Duplicate email insertion:
  - `_insert_account_data` raises `mysql.connector.IntegrityError(errno=1062, msg="Duplicate entry")` if the email is already used.

- Duplicate email update:
  - The AccountData update handler raises `mysql.connector.IntegrityError("Duplicate entry for email")` when attempting to change a user’s email to one owned by another account.

Other database errors are not broadly simulated; many operations simply set `rowcount` to `0` when the target entity does not exist.

## Usage Examples (Where Helpful)

### Use as a patched DB connection

In a test, patch an endpoint module to use the fake DB:

```python
from unittest.mock import patch
from backend.tests.mocks.db import FakeConnection

with patch("app.api.v1.users.get_db_connection", return_value=FakeConnection()):
    # call TestClient endpoints that use app.api.v1.users.get_db_connection
    ...