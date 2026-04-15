# Research Data API & Aggregation Service

Complete wiki for the research data analytics system. This document covers the backend aggregation service, all API endpoints, database interactions, security model, and how to extend the system.

## Architecture Overview

```
Frontend (Flutter)                     Backend (FastAPI)
┌──────────────────┐                  ┌─────────────────────────┐
│ ResearchApi      │ ──HTTP GET──▶    │ research.py (router)    │
│ (Retrofit/Dio)   │                  │   require_role(2, 4)    │
└──────────────────┘                  │         │               │
                                      │         ▼               │
                                      │ AggregationService      │
                                      │   K=5 enforcement       │
                                      │   numpy/pandas stats    │
                                      │         │               │
                                      │         ▼               │
                                      │ MySQL Database          │
                                      │   Responses table       │
                                      │   QuestionBank table    │
                                      └─────────────────────────┘
```

**Key files:**
- `backend/app/api/v1/research.py` — 5 REST endpoints
- `backend/app/services/aggregation.py` — aggregate computation
- `backend/app/api/v1/responses.py` — response submission (participant)
- `backend/app/api/deps.py` — `require_role()` auth dependency

## Access Control

All research endpoints require **researcher (RoleID=2)** or **admin (RoleID=4)** via `require_role(2, 4)`. Admin can impersonate a researcher via `ViewingAsUserID` in the Sessions table.

| Role | RoleID | Access |
|------|--------|--------|
| Participant | 1 | 403 Forbidden |
| Researcher | 2 | Full access |
| HCP | 3 | 403 Forbidden |
| Admin | 4 | Full access (also via impersonation) |

The `require_role()` dependency returns an enriched user dict:
```python
{
    "account_id": 10,          # original auth token owner
    "email": "researcher@example.com",
    "effective_account_id": 10, # target user (may differ if impersonating)
    "effective_role_id": 2      # target user's role
}
```

## Privacy: K-Anonymity

The system enforces **k-anonymity** with K=5. This means:

| Rule | Detail |
|------|--------|
| Threshold | `K_ANONYMITY_THRESHOLD = 5` in `aggregation.py` |
| Enforcement | Server-side, checked in every aggregation method |
| Survey level | If < 5 distinct respondents → `suppressed: true` |
| Question level | If < 5 responses to a question → `suppressed: true` |
| Option level | Choice options with < 5 selections → `suppressed: true` on that option |
| Open-ended | Response text is **never** returned; only total count |
| Suppressed output | `{"suppressed": true, "reason": "insufficient_responses", "data": null}` |

**Individual ResponseValue rows are NEVER returned to the frontend.** All data is aggregated.

## API Endpoints

All routes prefixed with `/api/v1/research`. All require `Authorization: Bearer <token>`.

### GET /surveys

List all surveys with response counts.

**Response:** `200 OK`
```json
[
  {
    "survey_id": 1,
    "title": "Health Survey",
    "publication_status": "published",
    "response_count": 142,
    "question_count": 10
  }
]
```

### GET /surveys/{id}/overview

Survey overview stats.

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Health Survey",
  "respondent_count": 42,
  "completion_rate": 85.7,
  "question_count": 10,
  "suppressed": false
}
```

**When suppressed (< 5 respondents):**
```json
{
  "survey_id": 1,
  "title": "New Survey",
  "respondent_count": 3,
  "completion_rate": 100.0,
  "question_count": 5,
  "suppressed": true,
  "reason": "insufficient_responses"
}
```

**Errors:** `404` if survey not found.

### GET /surveys/{id}/aggregates

All question aggregates with optional filters.

| Query Param | Type | Description |
|-------------|------|-------------|
| `category` | string | Filter by QuestionBank.Category |
| `response_type` | string | Filter by ResponseType (number, yesno, openended, single_choice, multi_choice, scale) |

**Response:** `200 OK`
```json
{
  "survey_id": 1,
  "title": "Health Survey",
  "total_respondents": 42,
  "aggregates": [
    {
      "question_id": 5,
      "question_content": "Rate your pain level",
      "response_type": "scale",
      "category": "health",
      "response_count": 25,
      "suppressed": false,
      "data": {
        "min": 1.0,
        "max": 10.0,
        "mean": 5.4,
        "median": 5.0,
        "std_dev": 2.3,
        "histogram": [
          {"label": "1", "count": 3, "suppressed": true},
          {"label": "5", "count": 8}
        ]
      }
    }
  ]
}
```

### GET /surveys/{id}/aggregates/{qid}

Single question aggregate.

**Response:** `200 OK` — same format as one item from the aggregates list above.

**Errors:** `404` if question not found in survey.

### GET /surveys/{id}/export/csv

Download aggregate data as CSV.

| Query Param | Type | Description |
|-------------|------|-------------|
| `category` | string | Filter by category |
| `response_type` | string | Filter by response type |

**Response:** `200 OK` with `Content-Type: text/csv`, `Content-Disposition: attachment; filename=survey_{id}_aggregates.csv`

**CSV columns vary by response type:**

| Common Columns | number/scale | yesno | single/multi choice |
|---------------|-------------|-------|---------------------|
| Question, Type, Category, Responses, Suppressed | Min, Max, Mean, Median, Std Dev | Yes Count, No Count, Yes %, No % | {Option} (count), {Option} (%) |

## Aggregation Service

Location: `backend/app/services/aggregation.py`

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `get_survey_overview(survey_id)` | `dict \| None` | Respondent count, completion rate, question count |
| `get_question_aggregate(survey_id, question_id)` | `dict \| None` | Per-question aggregate (varies by type) |
| `get_survey_aggregates(survey_id, *, category, response_type, question_ids)` | `dict \| None` | All questions with optional filters |
| `get_csv_export(survey_id, *, category, response_type)` | `str \| None` | CSV string via pandas |

### Response Type Aggregation Logic

#### number / scale

Uses numpy for statistical calculations:
- `min`, `max`, `mean`, `median`, `std_dev`
- `histogram`: auto-binned for number, integer buckets (1-10) for scale
- Options with < K responses get `"suppressed": true`

```python
# Internal: _aggregate_numeric(values, response_type)
arr = np.array(nums)
stats = {
    "min": float(np.min(arr)),
    "max": float(np.max(arr)),
    "mean": float(np.mean(arr)),
    "median": float(np.median(arr)),
    "std_dev": float(np.std(arr, ddof=1)),
}
```

#### yesno

Counts yes/no values (accepts: yes, no, 1, 0, true, false):
```json
{
  "yes_count": 18,
  "no_count": 7,
  "yes_pct": 72.0,
  "no_pct": 28.0
}
```

#### single_choice

Counts per defined option from QuestionOptions table:
```json
{
  "options": [
    {"option": "Red", "count": 12, "pct": 48.0},
    {"option": "Blue", "count": 8, "pct": 32.0},
    {"option": "Green", "count": 3, "pct": 12.0, "suppressed": true}
  ]
}
```

#### multi_choice

Same as single_choice but responses are stored as comma-separated values (e.g., `"Red,Blue"`). Percentages are based on total respondents (each can select multiple):
```json
{
  "options": [
    {"option": "Red", "count": 15, "pct": 60.0},
    {"option": "Blue", "count": 10, "pct": 40.0}
  ],
  "total_respondents": 25
}
```

#### openended

No text content is ever exposed. Only `response_count` is returned, `data` is `{}`.

## Database Tables

```
┌──────────────┐    ┌──────────────┐    ┌───────────────┐
│   Survey     │    │ QuestionList │    │ QuestionBank  │
│ SurveyID  PK │◄───│ SurveyID  FK │    │ QuestionID PK │
│ Title        │    │ QuestionID FK│───▶│ QuestionContent│
│ Publication- │    │ ID        PK │    │ ResponseType  │
│   Status     │    └──────────────┘    │ Category      │
└──────┬───────┘                        └───────┬───────┘
       │                                        │
       │    ┌──────────────────┐               │
       │    │   Responses      │               │
       ├───▶│ SurveyID    FK   │◄──────────────┘
       │    │ QuestionID  FK   │    ┌──────────────────┐
       │    │ ParticipantID FK │    │ QuestionOptions  │
       │    │ ResponseValue    │    │ QuestionID   FK  │
       │    │ ResponseID   PK  │    │ OptionText       │
       │    └──────────────────┘    │ DisplayOrder     │
       │                            └──────────────────┘
       │    ┌──────────────────┐
       └───▶│ SurveyAssignment │
            │ SurveyID    FK   │
            │ AccountID   FK   │
            │ CompletedAt      │
            │ Status           │
            └──────────────────┘
```

| Table | Purpose in Aggregation |
|-------|----------------------|
| `Survey` | Survey title and publication status |
| `QuestionList` | Maps questions to surveys (join table) |
| `QuestionBank` | Question text, response type, category |
| `QuestionOptions` | Defined choices for single/multi_choice questions |
| `Responses` | Response values — only accessed via aggregate queries |
| `SurveyAssignment` | Completion rate (CompletedAt vs total assigned) |

## Pydantic Response Models

Defined in `research.py`:

```python
class ResearchSurvey(BaseModel):
    survey_id: int
    title: str
    publication_status: str
    response_count: int
    question_count: int

class SurveyOverviewResponse(BaseModel):
    survey_id: int
    title: str
    respondent_count: int
    completion_rate: float
    question_count: int
    suppressed: bool
    reason: Optional[str] = None

class QuestionAggregateResponse(BaseModel):
    question_id: int
    question_content: str
    response_type: str
    category: Optional[str] = None
    response_count: int
    suppressed: bool
    reason: Optional[str] = None
    data: Optional[dict] = None

class AggregateListResponse(BaseModel):
    survey_id: int
    title: str
    total_respondents: int
    aggregates: list[QuestionAggregateResponse]
```

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `pandas` | >= 2.2.0 | DataFrame operations, CSV export |
| `numpy` | >= 1.26.0 | Statistical calculations (mean, median, std_dev, histogram) |

## How to Add a New Response Type

1. **Database**: Add the type value to the ResponseType column options
2. **`aggregation.py`**: Add a new `_aggregate_<type>()` static method
3. **`aggregation.py`**: Add the type to the `if/elif` chain in `get_question_aggregate()`
4. **`aggregation.py`**: Add CSV column mapping in `get_csv_export()`
5. **`responses.py`**: Add validation logic in `_validate_response_value()`
6. **Frontend**: Add chart rendering for the new type in the data view page
7. **Tests**: Add test cases in `test_aggregation.py` and `test_research.py`

## Security Considerations

- All SQL queries use **parameterized statements** (`%s` placeholders with parameter tuples)
- `require_role()` enforces authorization on every endpoint
- K-anonymity prevents de-identification of small groups
- Open-ended text responses are never returned to prevent data leakage
- CSV exports contain the same aggregate data as the API responses
- The `_aggregation` module-level instance is used for testability (can be patched in tests)

## Testing

See `docs/testing/admin-tests.md` for full test documentation.

| Test File | Tests | Coverage |
|-----------|-------|----------|
| `test_aggregation.py` | 19 tests | All 6 types, k-anonymity, CSV, privacy |
| `test_research.py` | 15 tests | All 5 endpoints, auth, filters, CSV |
| `test_responses.py` | 11 tests | Auth, validation, success paths |
| `test_require_role.py` | 10 tests | Role checks, impersonation, errors |
