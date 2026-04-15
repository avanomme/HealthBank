# Research Data API Tests (`test_research.py`)

Test suite for Research/Data Bank endpoints implemented in `app/api/v1/research.py`.

These tests validate:

- Endpoint behavior and response shapes for survey-level and cross-survey research data access
- Parameter passing from HTTP layer to aggregation/service layer
- CSV export behavior (content-type, attachment headers, metadata)
- Auth enforcement (401 without token, 403 for participant, 200 for researcher/admin)

## Overview

The Research Data API provides researcher/admin-only access to aggregated and anonymized survey response data, including:

- Listing surveys with response counts and question counts
- Survey overview statistics
- Per-survey aggregates (optionally filtered by category/response type)
- Per-question aggregates within a survey
- Individual anonymized response rows for a survey (JSON) and CSV exports
- Cross-survey “data bank” operations (overview, responses, aggregates, available questions) with optional filters and CSV export

This test module heavily relies on mocking:

- Authentication (`get_current_user` via `app.api.deps.get_db_connection`)
- Research DB access (`app.api.v1.research.get_db_connection`) for list endpoints
- Aggregation/service layer (`app.api.v1.research._aggregation`) for computed outputs

## Architecture / Design

### Test Client and Auth Override Management

- The tests use the main FastAPI app: `from app.main import app`
- `TestClient(app)` is provided via a `client` fixture.

An `autouse` fixture removes any global dependency override for `get_current_user`:

- `app.dependency_overrides.pop(get_current_user, None)`

This ensures these tests exercise the real auth flow (as implemented in dependencies) instead of a mocked auth override from `conftest.py`.

### Authentication Mocking

The tests patch `app.api.deps.get_db_connection` to control what `get_current_user` returns:

- `_mock_researcher_auth(...)` returns a session row with `RoleID = 2` (researcher)
- `_mock_participant_auth(...)` returns a session row with `RoleID = 1` (participant)

The mocked session row includes:

- `AccountID`
- `Email`
- `TosAcceptedAt`
- `TosVersion`
- `RoleID`
- `ViewingAsUserID`

Authorization is enforced by role checks (likely via `require_role` or similar), and is validated across endpoints.

### Aggregation/Service Layer Mocking

Most endpoint behavior is validated by patching a private aggregation/service object:

- `@patch("app.api.v1.research._aggregation")`

Tests assert that the HTTP layer:

- Returns whatever the aggregation layer returns (or transforms it into expected JSON keys)
- Passes query params to the aggregation layer with correct argument names and values
- Returns `404` when aggregation layer returns `None` (resource not found)

### Research DB Mocking

For `GET /api/v1/research/surveys`, tests patch:

- `@patch("app.api.v1.research.get_db_connection")`

and mock `cursor.fetchall()` results representing survey rows that include:

- `SurveyID`, `Title`, `PublicationStatus`
- `response_count`, `question_count`

The tests expect the endpoint to return a list with normalized keys like:

- `survey_id`
- `response_count`

## Configuration

To run the test suite:

```bash
pytest -q