# Survey API Models (`survey.dart`)

## Overview
This module defines the data models for the Survey domain, matching backend Pydantic schemas. It supports:

- Survey creation and updates (including question composition)
- Survey creation from a template
- Survey retrieval including embedded questions and options
- Enumerations for publication and survey status values

All models use:
- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/core/api/models/survey.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON mapping** via `@JsonKey(name: ...)`
- **Enum-backed fields** where backend values are constrained (publication and survey status)
- **Nested composition**:
  - `Survey` can include a list of `QuestionInSurvey`
  - `QuestionInSurvey` can include a list of `QuestionOption`
- **Temporal fields** use `DateTime?` and require ISO-8601 strings from the backend

### Model Relationships
- `SurveyCreate` / `SurveyUpdate` are request payloads; they optionally reference questions by ID via `questionIds`.
- `Survey` is the primary response model; it can include embedded questions.
- `QuestionInSurvey` represents questions within a survey context (not the full question bank object).
- `QuestionOption` models options for single/multi-choice questions.

### Code Generation
Generated files required:
- `survey.freezed.dart`
- `survey.g.dart`

Run:
```bash
dart run build_runner build