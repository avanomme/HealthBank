# Question Bank API Models (`question.dart`)

## Overview
This module defines the data models for the Question Bank domain in the frontend application.  
These models mirror backend Pydantic schemas and are used for:

- Creating and updating questions
- Representing question options
- Retrieving question records
- Representing question categories
- Handling response types

All models use:

- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/core/api/models/question.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON key mapping** using `@JsonKey(name: ...)`
- **Enum-backed response types** for safe value handling
- **Optional fields for partial updates**
- **Nested model composition** for options and categories
- **Date parsing via `DateTime`**

### Enum Handling
The `QuestionResponseType` enum mirrors backend values and uses `@JsonValue(...)` for exact string mapping.

This avoids collisions with external libraries (e.g., `dio.ResponseType`).

### Code Generation

Required generated files:

- `question.freezed.dart`
- `question.g.dart`

Run:

```bash
dart run build_runner build