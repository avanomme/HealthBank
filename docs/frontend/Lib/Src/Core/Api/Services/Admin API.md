# Admin API Service (`admin_api.dart`)

## Overview
This module defines the `AdminApi` Retrofit service interface for administrative backend operations, including:

- Database viewer endpoints (table list, schema, data)
- Admin-initiated password reset flows
- System administrator “view-as” functionality (preferred)
- Legacy impersonation endpoints (deprecated)
- Account request management (approve/reject workflows)
- Audit log retrieval and filter metadata
- Admin access to user consent records

This service is built with:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions and code generation

File: `frontend/lib/src/core/api/services/admin_api.dart`

Generated file:
- `admin_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- `@RestApi()` marks an interface that Retrofit uses to generate an implementation (`_AdminApi`).
- Each method is annotated with an HTTP verb (`@GET`, `@POST`) and a path.
- Parameters are mapped using:
  - `@Path(...)` for URL segments
  - `@Query(...)` for query parameters
  - `@Body()` for request bodies

### Dependency Injection / Construction
The generated implementation is constructed via:
- `AdminApi(Dio dio, {String? baseUrl})`

`dio` configuration (base URL, interceptors, cookie handling, auth headers, logging, timeouts) is expected to be performed externally before instantiating `AdminApi`.

### View-As vs Impersonation
This service supports two approaches:

- **View-As (preferred)**:
  - Updates the admin’s existing session with a `ViewingAsUserID`
  - Does not generate a new token
  - Eliminates token switching complexity in the frontend
  - Restricted to system administrators

- **Impersonation (deprecated)**:
  - Generates a new session token for the impersonated user
  - Requires session/token switching logic client-side
  - Marked with `@Deprecated(...)` and should be avoided in new code

### Model Dependencies
This service depends on typed request/response models from:
- `database.dart`
- `impersonation.dart`
- `audit_log.dart`
- `account_request.dart`
- `auth.dart`
- `consent.dart`

---

## Configuration (if applicable)

### Code Generation
Generate `admin_api.g.dart` after changing this file:

```bash
dart run build_runner build