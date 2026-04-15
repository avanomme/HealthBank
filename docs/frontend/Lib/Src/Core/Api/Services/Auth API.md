# Auth API Service (`auth_api.dart`)

## Overview
This module defines the `AuthApi` Retrofit service interface for authentication and session-related operations.

It supports:

- User login
- Two-factor authentication verification
- Logout
- Session introspection
- Password reset (request + confirm)
- Account request submission (public)
- Password change
- Profile completion

The service is built with:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models from the shared models barrel (`models.dart`)

File: `frontend/lib/core/api/services/auth_api.dart`

Generated file:
- `auth_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- `@RestApi()` enables Retrofit code generation.
- HTTP methods are declared using:
  - `@POST`
  - `@GET`
  - `@DELETE`
- Request bodies use `@Body()`.
- All responses are wrapped in `Future<T>`.

### Construction

```dart
AuthApi(Dio dio, {String? baseUrl})