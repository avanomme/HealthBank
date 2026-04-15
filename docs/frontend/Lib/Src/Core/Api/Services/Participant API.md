# Participant API Service (`participant_api.dart`)

## Overview
This module defines the `ParticipantApi` Retrofit service interface for participant-facing survey operations.

It supports:

- Listing assigned surveys
- Retrieving completed survey data with responses
- Submitting survey responses
- Comparing participant responses against aggregate data

All endpoints require:
- Participant role (RoleID = 1), or
- Admin role (RoleID = 4)

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models defined in `participant.dart`

File: `frontend/lib/src/core/api/services/participant_api.dart`

Generated file:
- `participant_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` for Retrofit code generation.
- Endpoints defined using:
  - `@GET`
  - `@POST`
- URL parameters mapped using `@Path(...)`.
- Request bodies mapped using `@Body()`.

### Construction

```dart
ParticipantApi(Dio dio, {String? baseUrl})