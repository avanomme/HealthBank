# Consent API Service (`consent_api.dart`)

## Overview
This module defines the `ConsentApi` Retrofit service interface for managing user consent flows.

It supports:

- Checking the current user’s consent status
- Submitting a signed consent form

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models from the shared models barrel (`models.dart`)

File: `frontend/lib/src/core/api/services/consent_api.dart`

Generated file:
- `consent_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- `@RestApi()` marks this interface for Retrofit code generation.
- HTTP methods are declared using:
  - `@GET`
  - `@POST`
- Request bodies use `@Body()`.
- Responses are strongly typed.

### Construction

```dart
ConsentApi(Dio dio, {String? baseUrl})