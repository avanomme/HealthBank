# Assignment API Service (`assignment_api.dart`)

## Overview
This module defines the `AssignmentApi` Retrofit service interface for managing assignment-related operations.

It supports:

- Retrieving assignments for the current user
- Updating an assignment
- Deleting an assignment

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative REST endpoint definitions
- Typed models exported via `models.dart`

File: `frontend/lib/core/api/services/assignment_api.dart`

Generated file:
- `assignment_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` to enable Retrofit code generation.
- Each method maps to a backend endpoint using HTTP method annotations:
  - `@GET`
  - `@PUT`
  - `@DELETE`
- URL parameters use `@Path(...)`.
- Query parameters use `@Query(...)`.
- Request bodies use `@Body()`.

### Construction

```dart
AssignmentApi(Dio dio, {String? baseUrl})