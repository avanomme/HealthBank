# Question Bank API Service (`question_api.dart`)

## Overview
This module defines the `QuestionApi` Retrofit service interface for managing Question Bank operations.

It supports:

- Listing question categories
- Creating questions
- Listing questions with filters
- Retrieving a single question
- Updating questions
- Deleting questions

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models exported via `models.dart`

File: `frontend/lib/core/api/services/question_api.dart`

Generated file:
- `question_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` for Retrofit code generation.
- HTTP methods defined using:
  - `@GET`
  - `@POST`
  - `@PUT`
  - `@DELETE`
- URL path parameters use `@Path(...)`.
- Query parameters use `@Query(...)`.
- Request bodies use `@Body()`.

### Construction

```dart
QuestionApi(Dio dio, {String? baseUrl})