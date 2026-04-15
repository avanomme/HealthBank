# `markdown/aggregation_service.md` — Aggregation & Research Analytics (`backend/app/services/aggregation.py`)

## Overview

`backend/app/services/aggregation.py` implements `AggregationService`, a backend analytics utility for survey research data.

It supports two primary data modes:

1. **Aggregated statistics** per survey/question:
   - numeric stats (min/max/mean/median/std dev)
   - histograms
   - yes/no distributions
   - choice distributions (single and multi-choice)
   - open-ended is intentionally not exposed
2. **Individual anonymized responses**:
   - one row per participant, with irreversible anonymized identifiers

A global **k-anonymity** rule is enforced throughout:

- Data is **suppressed** when distinct respondent count is below `K_ANONYMITY_THRESHOLD = 5`.

Participant IDs are anonymized using **SHA-256** with a **server-side salt** to produce stable but irreversible IDs.

---

## Architecture / Design Explanation

### Data Sources

All data is read from MySQL via `get_db_connection()` and commonly uses:

- `Survey` (metadata: title)
- `Responses` (participant responses)
- `QuestionList` + `QuestionBank` (survey question membership + metadata)
- `SurveyAssignment` (completion counts and optional date filtering)
- `QuestionOptions` (choice question option definitions)

### K-Anonymity Enforcement

The service applies k-anonymity at multiple levels:

- **Survey-level**: `get_survey_overview` suppresses overview if total respondents < 5.
- **Question-level**: `get_question_aggregate` suppresses each question if response count < 5.
- **Individual rows**: `get_individual_responses` returns `suppressed=True` with empty rows if total respondents < 5.
- **Cross-survey**:
  - Excludes surveys with insufficient respondents from the result set, reporting them in `suppressed_surveys`.
  - Can still return non-suppressed results if at least one survey meets the threshold.

Suppression responses include:
- `suppressed: True`
- `reason: "insufficient_responses"`

### Anonymization Strategy

Two anonymization modes are used:

- **Within-survey anonymization**:
  - `_anonymize_id(participant_id, survey_id) -> "R-xxxxxxxx"`
  - Same participant has different IDs across different surveys.
- **Cross-survey anonymization**:
  - `_anonymize_id_cross(participant_id) -> "X-xxxxxxxx"`
  - Same participant has the same ID across surveys to enable correlation.

Both are deterministic SHA-256 hashes derived from:
- a server-side salt constant
- participant ID
- optional survey ID
- a mode label

### Aggregation Strategy

Per-question aggregation depends on `ResponseType`:

- `number`, `scale` → numeric stats + histogram
- `yesno` → yes/no counts and percentages
- `single_choice` → distribution by option
- `multi_choice` → distribution by option (comma-separated storage)
- `openended` → returns `{}` without exposing free-text content

The main survey aggregation function enumerates questions and calls
`get_question_aggregate()` for each.

---

## Configuration

### Constants

- `K_ANONYMITY_THRESHOLD = 5`
- `_ANONYMIZATION_SALT = "hb_research_anonymization_2026"`

The salt is intended to remain server-private to preserve irreversibility.

---

## API Reference

### Class: `AggregationService`

#### `get_survey_overview(survey_id: int) -> dict[str, Any] | None`

Return high-level survey stats:

- title
- respondent_count
- question_count
- completion_rate (assigned vs completed)
- suppression status

**Parameters**
- `survey_id: int`

**Returns**
- `dict` with keys:
  - `survey_id: int`
  - `title: str`
  - `respondent_count: int`
  - `completion_rate: float`
  - `question_count: int`
  - `suppressed: bool`
  - optional `reason: str`
- `None` if survey does not exist

**Suppression**
- If respondents < 5: returns `suppressed=True` with `reason="insufficient_responses"`.

---

#### `get_question_aggregate(survey_id: int, question_id: int) -> dict[str, Any] | None`

Aggregate a single question within a survey.

**Parameters**
- `survey_id: int`
- `question_id: int`

**Returns**
- `None` if question is not part of the survey
- otherwise a dict:
  - `question_id: int`
  - `question_content: str`
  - `response_type: str`
  - `category: str | None`
  - `response_count: int`
  - `suppressed: bool`
  - if not suppressed: `data: dict`
  - if suppressed: `data: None` and `reason`

**ResponseType behaviors**
- `number` / `scale`: numeric stats + histogram
- `yesno`: yes/no counts and percentages
- `single_choice`: options distribution
- `multi_choice`: options distribution + `total_respondents`
- `openended`: empty dict `{}`

---

#### `get_survey_aggregates(...) -> dict[str, Any] | None`

Aggregate all questions in a survey with optional filtering.

**Signature**
- `get_survey_aggregates(survey_id: int, *, category: str | None = None, response_type: str | None = None, question_ids: list[int] | None = None)`

**Parameters**
- `survey_id: int`
- `category: Optional[str]`
- `response_type: Optional[str]`
- `question_ids: Optional[list[int]]`

**Returns**
- `None` if survey does not exist
- otherwise:
  - `survey_id: int`
  - `title: str`
  - `total_respondents: int`
  - `aggregates: list[dict]` (each entry is the output of `get_question_aggregate`)

---

#### `get_csv_export(...) -> str | None`

Export survey aggregates as a CSV string.

**Signature**
- `get_csv_export(survey_id: int, *, category: str | None = None, response_type: str | None = None)`

**Returns**
- `None` if survey not found
- otherwise a CSV string (pandas-generated)

**Notes**
- Suppressed questions are included but contain only base metadata columns.

---

### Individual anonymized response data

#### `_anonymize_id(participant_id: int, survey_id: int) -> str`

Within-survey anonymous identifier.

**Returns**
- `"R-" + 8 hex chars`

---

#### `get_individual_responses(...) -> dict[str, Any] | None`

Return individual response rows with per-survey anonymous IDs.

**Signature**
- `get_individual_responses(survey_id: int, *, category: str | None = None, response_type: str | None = None)`

**Returns**
- `None` if survey not found
- otherwise:
  - `survey_id: int`
  - `title: str`
  - `respondent_count: int`
  - `suppressed: bool`
  - optional `reason`
  - `questions: list[{question_id, question_content, response_type, category}]`
  - `rows: list[{anonymous_id, responses}]`

`responses` is a dict keyed by stringified question ID:
- `"123": "some response value"`

**Suppression**
- If respondents < 5: returns `suppressed=True`, empty questions/rows.

---

#### `get_individual_csv_export(...) -> str | None`

Export individual anonymized rows as CSV.

**Signature**
- `get_individual_csv_export(survey_id: int, *, category: str | None = None, response_type: str | None = None, survey_title: str | None = None)`

**Returns**
- `None` if survey not found
- otherwise CSV string

**Special outputs**
- If suppressed: returns a short single-line message
- If no questions/rows: returns `Anonymous ID\n`

**CSV Format**
- Metadata header lines:
  - `Survey,"<title>"`
  - `Exported,"YYYY-MM-DD HH:MM"`
- Blank line
- Data table with columns:
  - `Anonymous ID`
  - one column per question, using `QuestionContent` as the header

---

## Cross-survey analytics

#### `_anonymize_id_cross(participant_id: int) -> str`

Cross-survey anonymous identifier.

**Returns**
- `"X-" + 8 hex chars`

---

#### `get_cross_survey_overview(...) -> dict[str, Any]`

Overview stats across multiple surveys.

**Signature**
- `get_cross_survey_overview(survey_ids: list[int] | None = None, *, date_from: str | None = None, date_to: str | None = None)`

**Parameters**
- `survey_ids: Optional[list[int]]`
  - if `None`, includes all surveys with responses
- `date_from: Optional[str]` (ISO date string)
- `date_to: Optional[str]` (ISO date string)
  - date filtering is applied via `SurveyAssignment.CompletedAt`

**Returns**
- `survey_ids: list[int]`
- `surveys: list[{survey_id, title, respondent_count}]`
- `total_respondent_count: int`
- `total_question_count: int`
- `avg_completion_rate: float`
- `suppressed: bool`
- optional `reason`

**Suppression**
- Suppressed if total distinct respondents across included surveys < 5.
- If no surveys found: suppressed with `reason="no_surveys_found"`.

---

#### `get_cross_survey_responses(...) -> dict[str, Any]`

Individual rows across multiple surveys with cross-survey anonymous IDs.

**Signature**
- `get_cross_survey_responses(survey_ids: list[int] | None = None, *, date_from: str | None = None, date_to: str | None = None, category: str | None = None, response_type: str | None = None, question_ids: list[int] | None = None)`

**Behavior**
- Surveys with < 5 respondents are excluded and returned in `suppressed_surveys`.
- Each row represents one participant within one survey.
- Participant uses `X-` anonymization to allow correlation across surveys.

**Returns**
- `survey_ids: list[int]` (original requested set or resolved set)
- `surveys: list[{survey_id, title, respondent_count}]` (non-suppressed only)
- `total_respondent_count: int` (across valid surveys)
- `suppressed: bool`
- `suppressed_surveys: list[int]`
- `date_from`, `date_to`
- `questions: list[{question_id, question_content, response_type, category, survey_id, survey_title}]`
- `rows: list[{anonymous_id, survey_id, survey_title, responses}]`

If no valid surveys remain, returns suppressed with `reason="insufficient_responses"`.

---

#### `get_cross_survey_csv_export(...) -> str | None`

CSV export for cross-survey individual rows.

**Columns**
- `Anonymous ID`
- `Survey`
- One column per question, prefixed with survey title:
  - `"<Survey Title>: <QuestionContent>"`

**Returns**
- CSV string
- If suppressed: returns a short single-line message

---

### Data bank utilities

#### `get_available_questions(...) -> list[dict[str, Any]]`

Returns all available questions from surveys that have responses.

**Signature**
- `get_available_questions(survey_ids: list[int] | None = None, *, category: str | None = None, response_type: str | None = None)`

**Returns**
- list of:
  - `question_id`
  - `question_content`
  - `response_type`
  - `category`
  - `survey_id`
  - `survey_title`

---

#### `get_cross_survey_aggregates(...) -> dict[str, Any]`

Aggregates a set of questions across multiple surveys.

**Signature**
- `get_cross_survey_aggregates(survey_ids: list[int] | None = None, *, question_ids: list[int] | None = None, date_from: str | None = None, date_to: str | None = None, category: str | None = None, response_type: str | None = None)`

**Behavior**
- Excludes surveys with < 5 respondents.
- Aggregates each selected question across all valid surveys.
- Output shape matches `get_survey_aggregates` to reuse charting widgets.

**Returns**
- `survey_ids: list[int]`
- `total_respondents: int`
- `aggregates: list[...]` (same per-question structure: suppressed/data)

---

## Parameters and Return Types

### Input types
- Survey identifiers:
  - `survey_id: int`
  - `survey_ids: list[int] | None`
- Filtering:
  - `category: str | None`
  - `response_type: str | None`
  - `question_ids: list[int] | None`
- Date filters:
  - `date_from: str | None` (ISO date)
  - `date_to: str | None` (ISO date)

### Return types
- Dict payloads:
  - `dict[str, Any]`
- Lists:
  - `list[dict[str, Any]]`
- CSV:
  - `str` (CSV content)
- Not found:
  - `None`

---

## Error Handling

This service does not catch database exceptions internally.

Expected behavior:
- MySQL connector errors raised by `get_db_connection()` / cursor operations will propagate to callers.
- Methods generally ensure cursors and connections are closed via `finally`.

Suppression is used for privacy enforcement (not as an error).

---

## Usage Examples (only where helpful)

### Get survey aggregates for charting

```python
from app.services.aggregation import AggregationService

svc = AggregationService()
result = svc.get_survey_aggregates(
    survey_id=123,
    category="Mental Health",
    response_type="scale",
)