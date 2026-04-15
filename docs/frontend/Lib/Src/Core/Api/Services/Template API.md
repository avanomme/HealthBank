# Template API Service (`template_api.dart`)

## Overview
This module defines the `TemplateApi` Retrofit service interface for managing survey templates.

It supports:

- Creating templates
- Listing templates with optional filters
- Retrieving a single template
- Updating templates
- Deleting templates
- Duplicating existing templates

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models exported via `models.dart`

File: `frontend/lib/core/api/services/template_api.dart`

Generated file:
- `template_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` for Retrofit code generation.
- HTTP methods used:
  - `@GET`
  - `@POST`
  - `@PUT`
  - `@DELETE`
- URL parameters use `@Path(...)`.
- Query parameters use `@Query(...)`.
- Request bodies use `@Body()`.

### Construction

```dart
TemplateApi(Dio dio, {String? baseUrl})