# Participant API Models (`participant.dart`)

## Overview
This module defines the participant-facing survey models used by the frontend.  
These models mirror backend Pydantic schemas and represent:

- Assigned survey list items
- Survey questions with participant responses
- Full survey payloads including responses
- Participant answers for comparison views
- Aggregate comparison data

All models are implemented using `freezed` for immutable value types and `json_serializable` for JSON (de)serialization.

File: `frontend/lib/src/core/api/models/participant.dart`

---

## Architecture / Design

### Design Principles
- **Immutable data models** using `@freezed`
- **Strong JSON mapping** via `@JsonKey(name: ...)`
- **Date handling** using `DateTime` for temporal fields
- **Nested composition** for structured survey responses
- **Generated serialization code** via `*.g.dart`

### Model Relationships

- `ParticipantSurveyListItem`
  - Used for listing assigned surveys.

- `ParticipantQuestionResponse`
  - Represents a question and the participant’s response.

- `ParticipantSurveyWithResponses`
  - Wraps survey metadata plus a list of `ParticipantQuestionResponse`.

- `ParticipantAnswerOut`
  - Lightweight answer representation for comparison endpoints.

- `ParticipantSurveyCompareResponse`
  - Contains participant answers plus aggregate data for comparison.

### Code Generation

Required generated files:

- `participant.freezed.dart`
- `participant.g.dart`

Run:

```bash
dart run build_runner build