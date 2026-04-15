# Response Submission API

Endpoint for participants to submit survey responses.

## Location

`backend/app/api/v1/responses.py` — registered at `/api/v1/responses`

## Access Control

Only **participants (RoleID=1)** can submit responses via `require_role(1)`.

| Role | Access |
|------|--------|
| Participant (1) | Allowed |
| Researcher (2) | 403 Forbidden |
| HCP (3) | 403 Forbidden |
| Admin (4) | 403 Forbidden |

## POST /

Submit survey responses.

### Request Body

```json
{
  "survey_id": 1,
  "responses": [
    {"question_id": 1, "response_value": "yes"},
    {"question_id": 2, "response_value": "42"},
    {"question_id": 3, "response_value": "Red"}
  ]
}
```

### Validation Steps

The endpoint validates in order:

1. **Survey exists and is published** — 404 if not found, 400 if draft/closed
2. **Participant assigned** — 403 if not in SurveyAssignment
3. **Question in survey** — 400 if QuestionID not in QuestionList for this survey
4. **Value matches type** — 422 if value doesn't match ResponseType

### Response Type Validation

| Type | Valid Values | Error |
|------|-------------|-------|
| `number` | Any numeric string (e.g., "42", "3.14") | "Expected numeric value" |
| `scale` | Numeric 1-10 | "Scale value must be between 1 and 10" |
| `yesno` | yes, no, 1, 0, true, false (case-insensitive) | "Expected yes/no value" |
| `single_choice` | Must match OptionText from QuestionOptions | "not a valid option" |
| `multi_choice` | Comma-separated values, each must match OptionText | "Invalid selections" |
| `openended` | Any string | Never rejected |

### Success Response

`201 Created`
```json
{
  "message": "Responses submitted successfully",
  "survey_id": 1,
  "responses_count": 3
}
```

### Error Responses

| Status | Condition | Detail |
|--------|-----------|--------|
| 400 | Survey not published | "Survey is not published" |
| 400 | Question not in survey | "Question {id} is not in this survey" |
| 401 | No auth token | Standard auth error |
| 403 | Wrong role | "Insufficient role permissions" |
| 403 | Not assigned | "Participant is not assigned to this survey" |
| 404 | Survey not found | "Survey not found" |
| 422 | Value type mismatch | Varies by type (see above) |
| 500 | DB error | "Failed to submit responses" (rollback) |

### Side Effects

After successful submission:
- All responses inserted into `Responses` table
- `SurveyAssignment.CompletedAt` set to `UTC_TIMESTAMP()`
- `SurveyAssignment.Status` updated to `'completed'`
- Transaction committed

On any error, the transaction is rolled back.

## Pydantic Models

```python
class ResponseItem(BaseModel):
    question_id: int
    response_value: str

class SubmitResponsesRequest(BaseModel):
    survey_id: int
    responses: list[ResponseItem]
```

## Testing

11 tests in `backend/tests/api/test_responses.py` — see `docs/testing/admin-tests.md`.
