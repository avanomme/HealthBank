# Frontend API Models

The HealthBank frontend uses **Freezed** for immutable data classes and **json_serializable** for JSON serialization. All models live in `frontend/lib/src/core/api/models/` and are exported via `models.dart` barrel.

## Code Generation

After modifying any model file, regenerate the `.freezed.dart` and `.g.dart` files:

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

After modifying `.arb` localization files, regenerate translations:

```bash
cd frontend
flutter gen-l10n
```

---

## Model Pattern

Every model follows the same Freezed pattern:

```dart
@freezed
sealed class ModelName with _$ModelName {
  const factory ModelName({
    @JsonKey(name: 'snake_case_field') required int camelCaseField,
    String? optionalField,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
}
```

Key conventions:
- `@JsonKey(name: 'snake_case')` maps from backend Python snake_case to Dart camelCase
- Required fields use `required` keyword
- Optional fields are nullable (`Type?`)
- `sealed class` for pattern matching support
- Each model has `fromJson` factory and generated `toJson` method

---

## Model Files

| File | Models | Backend API |
|------|--------|-------------|
| `auth.dart` | LoginRequest, LoginResponse | POST /auth/login |
| `survey.dart` | Survey, SurveyCreate, SurveyUpdate, QuestionInSurvey, QuestionOption | /surveys/* |
| `template.dart` | Template, TemplateCreate, TemplateUpdate, QuestionInTemplate | /templates/* |
| `question.dart` | Question, QuestionCreate, QuestionUpdate, QuestionCategory, QuestionOptionCreate | /questions/* |
| `admin.dart` | User, UserCreate, UserUpdate, UserListResponse, AuditLogEntry | /admin/* |
| `research.dart` | ResearchSurvey, SurveyOverview, QuestionAggregate, AggregateResponse | /research/* |

---

## Research Data Models

These models match the backend Pydantic response schemas for the research analytics API.

### ResearchSurvey

Returned by `GET /research/surveys`. Lists surveys available for analysis.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `surveyId` | int | `survey_id` | Survey identifier |
| `title` | String | `title` | Survey title |
| `publicationStatus` | String | `publication_status` | draft/published/closed |
| `responseCount` | int | `response_count` | Total response submissions |
| `questionCount` | int | `question_count` | Number of questions |

### SurveyOverview

Returned by `GET /research/surveys/{id}/overview`. Summary statistics.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `surveyId` | int | `survey_id` | Survey identifier |
| `title` | String | `title` | Survey title |
| `respondentCount` | int | `respondent_count` | Distinct participants |
| `completionRate` | double | `completion_rate` | 0.0–1.0 fraction |
| `questionCount` | int | `question_count` | Number of questions |
| `suppressed` | bool | `suppressed` | true if respondents < 5 (k-anonymity) |

### QuestionAggregate

Returned as items in `AggregateResponse.aggregates`. Per-question analytics.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `questionId` | int | `question_id` | Question identifier |
| `questionContent` | String | `question_content` | Question text |
| `responseType` | String | `response_type` | number/yesno/openended/single_choice/multi_choice/scale |
| `category` | String? | `category` | Optional question category |
| `responseCount` | int | `response_count` | Number of responses |
| `suppressed` | bool | `suppressed` | true if responses < 5 |
| `data` | Map<String, dynamic>? | `data` | Aggregate data (structure varies by type) |

**Data field structure by response type:**

- **yesno:** `{yes_count: int, no_count: int, yes_pct: double, no_pct: double}`
- **single_choice / multi_choice:** `{options: [{option_text: str, count: int, pct: double}]}`
- **number / scale:** `{min: double, max: double, mean: double, median: double, std_dev: double, histogram: {bucket_label: count}}`
- **openended:** `null` (no text content exposed for privacy)

### AggregateResponse

Returned by `GET /research/surveys/{id}/aggregates`. Wraps list of question aggregates.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `surveyId` | int | `survey_id` | Survey identifier |
| `title` | String | `title` | Survey title |
| `totalRespondents` | int | `total_respondents` | Total distinct respondents |
| `aggregates` | List<QuestionAggregate> | `aggregates` | Per-question data |

---

## How to Add a New Model

1. Create or edit a model file in `frontend/lib/src/core/api/models/`
2. Follow the Freezed pattern above with `@JsonKey` annotations
3. Add `part 'filename.freezed.dart';` and `part 'filename.g.dart';`
4. Export from `models.dart` barrel: `export 'filename.dart';`
5. Run `dart run build_runner build --delete-conflicting-outputs`
6. Create corresponding Retrofit API service methods in `services/`
7. Run build_runner again to generate the service `.g.dart` file
