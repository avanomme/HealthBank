# Aggregation Service

Aggregation service for research data analytics.

**File:** `backend/app/services/aggregation.py`

---

## Overview

This module provides analytics-friendly access to survey response data in two modes:

1. **Aggregate statistics** (mean, median, histograms, choice distributions)
2. **Individual anonymized response rows** (one row per participant)

Both modes enforce **k-anonymity**. If fewer than `K_ANONYMITY_THRESHOLD` (5) distinct respondents exist for a survey (or a question in certain contexts), data is **suppressed** to protect participant privacy.

Participant identifiers are anonymized using a **deterministic SHA-256 hash** with a server-side salt. This produces consistent but irreversible anonymous IDs (unless the salt is known).

---

## Privacy Model

### K-Anonymity

- `K_ANONYMITY_THRESHOLD = 5`
- If respondent counts fall below this threshold:
  - Survey overview indicates `suppressed: True`
  - Aggregates return `suppressed: True` at question level where applicable
  - Individual response exports return a suppression message or empty data

**Rationale:** Prevents inference attacks when respondent pools are small.

---

### Participant Anonymization

Two anonymization schemes are used:

1. **Within a survey**: stable anonymous IDs scoped to a survey
   - Format: `R-XXXXXXXX` (8 hex chars)
   - Deterministic mapping: `(salt, survey_id, participant_id) -> R-*`

2. **Across surveys**: stable anonymous IDs usable for correlation across surveys
   - Format: `X-XXXXXXXX` (8 hex chars)
   - Deterministic mapping: `(salt, participant_id) -> X-*`

The salt is server-side and is not exposed via API responses, making the mapping irreversible without backend access.

---

## Data Modes

### 1. Survey Aggregates

Provides statistics per question. Numeric questions include descriptive statistics and histograms. Choice questions include per-option counts and percentages. Open-ended questions intentionally do not expose text content.

### 2. Individual Anonymized Responses

Returns one row per respondent with:

- An anonymized participant ID
- A response map keyed by question ID
- Question metadata for interpreting columns

---

## API Reference

### `AggregationService`

#### `get_survey_overview(survey_id: int) -> dict | None`

Return high-level stats for a survey.

**Returns:**

- `None` if the survey does not exist
- A dict including:
  - `survey_id`, `title`
  - `respondent_count`
  - `completion_rate` (assigned vs completed)
  - `question_count`
  - `suppressed` flag and optional `reason`

**Suppression:**
- If `respondent_count < 5`, returns `suppressed: True` with reason `insufficient_responses`

---

#### `get_question_aggregate(survey_id: int, question_id: int) -> dict | None`

Return aggregate data for a single question in a survey.

**Returns:**

- `None` if the question is not part of the survey
- A dict containing:
  - Question metadata
  - `response_count`
  - `suppressed` flag
  - `data` object (or `None` when suppressed)

**Aggregation behavior by response type:**

| Response Type | Output |
|---------------|--------|
| `number` | min/max/mean/median/std_dev + histogram (auto-binned) |
| `scale` | min/max/mean/median/std_dev + histogram (integer buckets) |
| `yesno` | yes/no counts + percentages |
| `single_choice` | per-option counts + percentages |
| `multi_choice` | per-option counts + percentages + total respondents |
| `openended` | empty data (text not exposed) |
| other/unknown | empty data |

**Suppression:**
- If `response_count < 5`, returns `suppressed: True` and `data: None`

---

#### `get_survey_aggregates(...) -> dict | None`

Aggregate all questions in a survey with optional filtering.

**Signature:**

- `survey_id` (`int`)
- `category` (`str | None`)
- `response_type` (`str | None`)
- `question_ids` (`list[int] | None`)

**Returns:**

- `None` if survey not found
- A dict containing:
  - `survey_id`, `title`
  - `total_respondents`
  - `aggregates`: list of per-question aggregate objects

**Notes:**
- K-anonymity is enforced at the question level via `get_question_aggregate`
- Uses per-question calls that each open their own database connection

---

#### `get_csv_export(...) -> str | None`

Return survey aggregate data as a CSV string.

**Returns:**

- `None` if survey not found
- A CSV string with one row per question
- Suppressed questions appear as rows with `Suppressed=True` and no metrics

**Output behavior by type:**
- Numeric metrics become columns (`Min`, `Max`, `Mean`, `Median`, `Std Dev`)
- Choice options expand into columns per option (`Option (count)`, `Option (%)`)
- Open-ended questions add no additional columns

---

## Individual Response API

#### `get_individual_responses(...) -> dict | None`

Return anonymized individual response rows for a single survey.

**Signature:**

- `survey_id` (`int`)
- `category` (`str | None`)
- `response_type` (`str | None`)

**Returns:**

- `None` if survey not found
- A dict with:
  - `survey_id`, `title`
  - `respondent_count`
  - `suppressed` flag and optional `reason`
  - `questions`: list of question metadata
  - `rows`: list of respondent rows

**Row format:**

```json
{
  "anonymous_id": "R-a1b2c3d4",
  "responses": {
    "1": "25",
    "2": "Yes"
  }
}
```

**Suppression:**
- If distinct respondents < 5, returns `suppressed: True` with empty `questions` and `rows`

---

#### `get_individual_csv_export(...) -> str | None`

Export anonymized individual responses as CSV.

**Behavior:**

- Writes a metadata header:
  - Survey name
  - Export timestamp (UTC)
- Then writes a standard CSV table:
  - One row per anonymous participant
  - One column per question (question content is used as the column header)

**Returns:**

- `None` if survey not found
- `"Data suppressed: fewer than 5 respondents\n"` if suppressed
- `"Anonymous ID\n"` if there are no questions or no rows

---

## Cross-Survey API

This section enables analytics across multiple surveys while preserving anonymity.

### `get_cross_survey_overview(...) -> dict`

Return high-level stats across multiple surveys.

**Inputs:**

- `survey_ids` (`list[int] | None`): if `None`, includes all surveys with responses
- `date_from` / `date_to` (`str | None`): optional completion date filter

**Returns:**

- `surveys`: per-survey respondent counts
- `total_respondent_count`: distinct respondents across selected surveys
- `total_question_count`: distinct questions across selected surveys
- `avg_completion_rate`: based on assignment completion
- `suppressed` flag if total respondents < 5

**Suppression:**
- If total distinct respondents across selected surveys < 5, returns `suppressed: True`

---

### `get_cross_survey_responses(...) -> dict`

Return anonymized individual response rows across multiple surveys.

**Inputs:**

- `survey_ids` (`list[int] | None`)
- `date_from` / `date_to` (`str | None`)
- Optional filters:
  - `category`
  - `response_type`
  - `question_ids`

**Key behavior:**

- Applies per-survey k-anonymity:
  - Surveys with < 5 respondents are excluded and listed in `suppressed_surveys`
- Uses cross-survey anonymization:
  - `anonymous_id` uses the `X-` prefix so the same participant can be correlated across surveys

**Row format:**

```json
{
  "anonymous_id": "X-a1b2c3d4",
  "survey_id": 12,
  "survey_title": "Survey Name",
  "responses": {
    "5": "Yes",
    "6": "3"
  }
}
```

---

### `get_cross_survey_csv_export(...) -> str | None`

Return cross-survey individual response data as a CSV string.

**Columns:**

- `Anonymous ID`
- `Survey`
- One column per question (prefixed with survey title for disambiguation)

Example column naming:

```
Survey A: Question Text
Survey B: Question Text
```

**Suppression:**
- If overall result is suppressed, returns:
  ```
  Data suppressed: fewer than 5 respondents
  ```

---

## Data Bank API

### `get_available_questions(...) -> list[dict]`

Return all questions available for selection in the "data bank" UI.

**Inputs:**

- `survey_ids` (`list[int] | None`): limit to these surveys, otherwise uses all surveys that have responses
- Optional filters:
  - `category`
  - `response_type`

**Returns:**
A list of questions including survey context:

- `question_id`
- `question_content`
- `response_type`
- `category`
- `survey_id`
- `survey_title`

Used by the frontend field picker dialog.

---

### `get_cross_survey_aggregates(...) -> dict`

Compute aggregate statistics across a set of surveys.

**Inputs:**

- `survey_ids` (`list[int] | None`)
- Optional filters:
  - `question_ids`
  - `date_from` / `date_to`
  - `category`
  - `response_type`

**Output:**
Returns the same aggregate format as `get_survey_aggregates`, enabling reuse of existing chart components.

**K-anonymity behavior:**

- Excludes surveys with < 5 respondents from the aggregation pool
- Suppresses question-level aggregates with < 5 total responses

---

## Aggregation Output Details

### Numeric (`number`, `scale`)

Returns:

- `min`, `max`, `mean`, `median`, `std_dev`
- `histogram`: list of `{label, count}`

Histogram rules:

- `scale`: integer buckets from observed min to max
- `number`: auto-binned histogram with up to 10 bins

---

### Yes/No (`yesno`)

Returns:

- `yes_count`, `no_count`
- `yes_pct`, `no_pct`

Accepted truthy values are treated as "yes":

- `"yes"`, `"1"`, `"true"` (case-insensitive)

---

### Single Choice (`single_choice`)

Returns:

- `options`: list of `{option, count, pct}`

Option ordering:

- Uses `QuestionOptions.DisplayOrder` if options exist
- Otherwise falls back to sorted keys from observed values

---

### Multi Choice (`multi_choice`)

Assumes responses are stored as comma-separated selections in `ResponseValue`.

Returns:

- `options`: list of `{option, count, pct}`
- `total_respondents`: number of respondents included in that question aggregation

Percentages are based on total respondents (not total selections).

---

### Open-Ended (`openended`)

Returns an empty object and does not expose text responses to reduce re-identification risk.

---

## Error Handling

This module does not implement explicit exception wrapping for database or parsing errors. Callers should assume:

- Database connection failures will raise underlying exceptions
- Aggregation helpers ignore invalid numeric parses rather than raising

---

## Performance Considerations

- `get_survey_aggregates()` calls `get_question_aggregate()` per question, and each call opens its own database connection.
- CSV exports use pandas DataFrames and may consume memory for large exports.
- Cross-survey response extraction may be heavy for large datasets due to per-survey grouping behavior.

---

## Related Files

- `backend/app/services/aggregation.py` — Aggregation and anonymization logic
- `backend/app/utils/utils.py` — Database connection helper (`get_db_connection`)
- Database tables:
  - `Survey`
  - `QuestionList`
  - `QuestionBank`
  - `QuestionOptions`
  - `Responses`
  - `SurveyAssignment`