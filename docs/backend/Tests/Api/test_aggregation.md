# Aggregation Service Tests (`backend/tests/api/test_aggregation.py`)

## Overview

This module tests `AggregationService` (`app/services/aggregation.py`) with a focus on:

- Survey-level aggregation summaries (`get_survey_overview`)
- Question-level aggregation for all supported response types (`get_question_aggregate`)
- Survey aggregation listing with filters (`get_survey_aggregates`)
- CSV export formatting (`get_csv_export`)
- Individual-response exports with anonymized participant identifiers:
  - `get_individual_responses`
  - `get_individual_csv_export`
- Privacy enforcement:
  - **k-anonymity threshold** is consistently enforced across aggregation and exports
  - aggregation endpoints must not return raw per-response row data in their outputs
  - anonymized IDs must not leak raw participant IDs

The tests rely on mocking `get_db_connection` and using `MagicMock` cursors to emulate query results.

---

## Architecture / Design

### Test structure

The suite is organized by feature area:

- `TestGetSurveyOverview`: survey metadata + response count + suppression behavior
- `TestAggregateNumber`: numeric/scale aggregation stats and histogram behavior
- `TestAggregateYesNo`: yes/no aggregation counts and percentages
- `TestAggregateChoice`: single-choice and multi-choice option counting + option-level suppression
- `TestAggregateOpenEnded`: open-ended aggregation returns no text content
- `TestKAnonymitySuppression`: question-level and option-level suppression rules; nonexistent question behavior
- `TestSurveyAggregatesFilters`: category/response-type filter behavior (SQL contains filter predicate)
- `TestCsvExport`: survey aggregate CSV output structure and suppression behavior
- `TestPrivacy`: explicit assertions that certain aggregation outputs contain no raw response-row artifacts; k constant value
- `TestAnonymizeId`: deterministic anonymization rules and output format
- `TestGetIndividualResponses`: per-participant export path uses anonymized IDs; supports filters; includes open-ended text; never returns raw IDs
- `TestIndividualCsvExport`: per-participant CSV formatting and suppression; ensures no raw IDs appear in CSV content

### Common dependency pattern

All service methods that touch persistence are tested by patching:

- `app.services.aggregation.get_db_connection`

Mocks are configured via:

- `cursor.fetchone.side_effect` for sequential single-row queries
- `cursor.fetchall` / `cursor.fetchall.side_effect` for multi-row results

This test style assumes `AggregationService` performs a predictable sequence of SQL queries per method.

---

## Configuration

### Fixtures

#### `service() -> AggregationService`

Provides a fresh `AggregationService` instance per test.

### Constants imported from implementation

- `K_ANONYMITY_THRESHOLD`
- `_ANONYMIZATION_SALT` (imported but not asserted against in this file)

The suite asserts `K_ANONYMITY_THRESHOLD == 5`.

---

## API Reference

This file documents behavior of `AggregationService` methods under test.

### `AggregationService.get_survey_overview(survey_id: int) -> dict[str, Any] | None`

Returns top-level survey stats.

**Parameters**
- `survey_id: int`

**Returns**
- `None` if the survey does not exist
- Otherwise a dict containing (as asserted):
  - `survey_id: int`
  - `title: str`
  - `respondent_count: int`
  - `question_count: int`
  - `completion_rate: float` (percentage, e.g. `75.0`)
  - `suppressed: bool`
  - If suppressed:
    - `reason: str` (expected `"insufficient_responses"`)

**k-anonymity behavior**
- If `respondent_count < K_ANONYMITY_THRESHOLD`, return a suppressed result.

---

### `AggregationService.get_question_aggregate(survey_id: int, question_id: int) -> dict[str, Any] | None`

Returns aggregated statistics for a question, with k-anonymity enforcement.

**Parameters**
- `survey_id: int`
- `question_id: int`

**Returns**
- `None` if the question does not exist (or does not belong to the survey)
- Otherwise a dict containing (as asserted):
  - `suppressed: bool`
  - `response_count: int`
  - If suppressed:
    - `reason: str` (expected `"insufficient_responses"`)
    - `data: None`
  - If not suppressed:
    - `data: dict[str, Any]` shape depends on response type

**Supported response types (as exercised by tests)**

#### `number`
Returns descriptive stats and a histogram.

- `data.min: float`
- `data.max: float`
- `data.mean: float`
- `data.median: float`
- `data.std_dev: float`
- `data.histogram: list[dict[str, Any]]`

#### `scale`
Like `number`, but histogram bucket labels are expected to be integer-like strings (e.g., `"3"`, `"7"`).

#### `yesno`
Returns counts and percentages:

- `data.yes_count: int`
- `data.no_count: int`
- `data.yes_pct: float`
- `data.no_pct: float`

#### `single_choice`
Returns option counts based on `QuestionOptions`:

- `data.options: list[dict[str, Any]]` where each option includes:
  - `option: str`
  - `count: int`
  - optional `suppressed: bool` when `count < K_ANONYMITY_THRESHOLD`

Options with zero selections exist and are suppressed if `< K`.

#### `multi_choice`
Comma-separated response values are split into individual selections before counting.

- `data.options: list[...]` (same shape as `single_choice`)
- `data.total_respondents: int`

Option-level suppression is applied independently of overall question suppression.

#### `openended`
For privacy, aggregated output must not expose free-text content:

- `data == {}` (empty dict)
- Response text must not appear anywhere in the returned object (stringified).

---

### `AggregationService.get_survey_aggregates(
    survey_id: int,
    category: str | None = None,
    response_type: str | None = None
) -> dict[str, Any] | None`

Returns aggregates for all questions in a survey (optionally filtered).

**Parameters**
- `survey_id: int`
- `category: Optional[str]`
- `response_type: Optional[str]`

**Returns**
- `None` if the survey does not exist
- Otherwise a dict containing at least:
  - `aggregates: list[dict[str, Any]]`

**Filter behavior**
- If `category` is provided, the SQL query used to select questions should include `Category = %s`.
- If `response_type` is provided, the SQL query should include `ResponseType = %s`.

---

### `AggregationService.get_csv_export(survey_id: int) -> str | None`

Exports survey-level aggregates as CSV.

**Parameters**
- `survey_id: int`

**Returns**
- `None` if the survey does not exist
- Otherwise a CSV string.

**CSV expectations**
- Header row includes (as asserted):
  - `Question`
  - `Type`
  - `Category`
  - `Responses`
  - `Suppressed`
  - For numeric types, includes aggregate stat columns such as:
    - `Min`, `Max`, `Mean` (and potentially others)

**Suppression behavior**
- Suppressed rows should be clearly marked (tests check `True` appears in CSV).
- Suppressed rows should not include aggregate stat values.

---

### `AggregationService._anonymize_id(participant_id: int, survey_id: int) -> str`

Produces deterministic anonymized participant identifiers.

**Parameters**
- `participant_id: int`
- `survey_id: int`

**Returns**
- A string formatted as:
  - `"R-" + 8 hex characters` (total length 10)

**Properties asserted**
- Deterministic for same inputs
- Different participants produce different IDs (within same survey)
- Same participant produces different IDs across different surveys
- Output must not contain the raw participant ID

---

### `AggregationService.get_individual_responses(
    survey_id: int,
    category: str | None = None,
    response_type: str | None = None
) -> dict[str, Any] | None`

Returns per-participant rows, keyed by anonymized IDs.

**Parameters**
- `survey_id: int`
- optional filters:
  - `category`
  - `response_type`

**Returns**
- `None` if survey does not exist
- Otherwise a dict containing (as asserted):
  - `survey_id: int`
  - `title: str`
  - `respondent_count: int`
  - `suppressed: bool`
  - `questions: list[dict[str, Any]]`
  - `rows: list[dict[str, Any]]`
- Each row includes:
  - `anonymous_id: str` (starts with `"R-"`)
  - `responses: dict[str, str]` mapping `question_id` (string) to response value

**k-anonymity behavior**
- If respondents `< K`, returns suppressed result with:
  - `reason == "insufficient_responses"`
  - `questions == []`
  - `rows == []`

**Filter behavior**
- When filtering by category, executed SQL should include `Category = %s`.
- When filtering by response type, executed SQL should include `ResponseType = %s`.

**Privacy behavior**
- Raw participant IDs must not appear anywhere in the returned structure.
- Unlike aggregated outputs, open-ended responses are expected to be included in individual exports (still anonymized).

---

### `AggregationService.get_individual_csv_export(survey_id: int) -> str | None`

Exports per-participant rows as CSV.

**Parameters**
- `survey_id: int`

**Returns**
- `None` if survey does not exist
- Otherwise a CSV string.

**CSV expectations**
- Contains a column `"Anonymous ID"` as the first column.
- Remaining columns correspond to question prompts (e.g., `"Age?"`, `"Exercise?"`).
- When suppressed due to `< K`, CSV content should include a suppression message (string contains “suppressed”).

**Privacy behavior**
- CSV content must not contain raw participant IDs.

---

## Parameters and Return Types

### Mocked DB row shapes used in tests

The service implementation is expected to return cursor rows as mapping-like objects (dicts) with keys such as:

- Survey rows:
  - `SurveyID`, `Title`
- Counts:
  - `cnt`
- Assignments:
  - `total_assigned`, `completed`
- Questions:
  - `QuestionID`, `QuestionContent`, `ResponseType`, `Category`
- Responses:
  - `ParticipantID`, `QuestionID`, `ResponseValue`
- Options:
  - `OptionText`

### Return types summary

- Overview / aggregates:
  - `dict[str, Any] | None`
- CSV export methods:
  - `str | None`

---

## Error Handling

The tests validate non-exceptional error handling through return values and suppression flags:

- Nonexistent survey:
  - `get_survey_overview(...) -> None`
  - `get_csv_export(...) -> None`
  - `get_individual_responses(...) -> None`
  - `get_individual_csv_export(...) -> None`
- Nonexistent question:
  - `get_question_aggregate(...) -> None`
- k-anonymity violation:
  - returns an object with:
    - `suppressed == True`
    - `reason == "insufficient_responses"`
    - no aggregate payload (`data is None`) or empty collections in individual export
- Privacy constraints:
  - Aggregation outputs must not leak raw response values (especially open-ended text)
  - Exports must not leak `ParticipantID`

---

## Usage Examples

### Run this test file

```bash
pytest backend/tests/api/test_aggregation.py -q