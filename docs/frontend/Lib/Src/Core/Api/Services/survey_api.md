# Survey API Service (`survey_api.dart`)

## Overview
This module defines the `SurveyApi` Retrofit service interface for managing surveys and survey assignments.

It supports:

- Creating surveys (direct or from templates)
- Listing and retrieving surveys
- Updating and deleting surveys
- Publishing and closing surveys
- Assigning surveys (single and bulk)
- Retrieving survey assignments

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models exported via `models.dart`

File: `frontend/lib/core/api/services/survey_api.dart`

Generated file:
- `survey_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` for code generation.
- HTTP methods used:
  - `@GET`
  - `@POST`
  - `@PUT`
  - `@PATCH`
  - `@DELETE`
- URL parameters use `@Path(...)`.
- Query parameters use `@Query(...)`.
- Request bodies use `@Body()`.

### Construction

```dart
SurveyApi(Dio dio, {String? baseUrl})