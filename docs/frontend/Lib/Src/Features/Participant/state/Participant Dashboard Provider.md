# Participant Dashboard Providers Documentation

**File:** (unnamed snippet)  
**Library:** `library;` (Dart library file containing Riverpod providers and a lightweight profile model)

## Overview

This file defines the Riverpod data layer for the participant dashboard feature. It provides:

- A lightweight `ParticipantProfile` model designed for participant-facing UI.
- Providers for API services used by the participant experience (`AuthApi`, `AssignmentApi`, `UserApi`, optional `SurveyApi`).
- Providers that fetch and compose participant dashboard data:
  - Current session (`participantSessionProvider`)
  - Participant profile with fallback name resolution (`participantProfileProvider`)
  - Participant assignments (`participantAssignmentsProvider`)
  - A placeholder notification count (`participantNotificationCountProvider`)

The provider chain is built around an `apiClientProvider` (imported from another feature area) and composes upstream APIs into downstream dashboard-ready state.

## Architecture / Design Explanation

### Provider Chain

The intended chain is:

`apiClientProvider` → API service providers → async data providers → UI consumers

1. **API client**
   - `apiClientProvider` supplies a configured API client (with a `dio` instance).

2. **API service providers**
   - Each API wrapper is constructed from the shared `dio` client:
     - `participantAuthApiProvider` → `AuthApi`
     - `participantAssignmentApiProvider` → `AssignmentApi`
     - `participantUserApiProvider` → `UserApi`
     - `participantSurveyApiProvider` → `SurveyApi` (optional)

3. **Async data providers**
   - `participantSessionProvider` fetches the authenticated session object.
   - `participantProfileProvider` composes a `ParticipantProfile` using the session data and (when needed) a `UserApi` fallback.
   - `participantAssignmentsProvider` fetches the participant’s assignments list.

4. **Synchronous placeholder provider**
   - `participantNotificationCountProvider` currently returns `0` and is intended to be replaced with a real notifications/messages endpoint.

### Profile Composition Strategy

`participantProfileProvider` uses a best-effort approach:

- Prefer session-provided participant identity, including a “viewing as” mode when present.
- Fall back to session user fields if “viewing as” is absent/incomplete.
- If first/last name data is missing and `accountId > 0`, call `UserApi.getUser(accountId)` and use returned name fields.
- Construct a `ParticipantProfile` with the resolved identity.

### Model Design

`ParticipantProfile` is intentionally lightweight for UI use:

- Contains only identifiers and basic contact/name fields.
- Provides a computed `displayName` getter that:
  - Joins trimmed first/last name when available.
  - Falls back to email if name data is missing.

This avoids pushing raw API response objects through UI layers.

## Configuration

No configuration is defined directly in this file.

The behavior depends on:

- `apiClientProvider` supplying a working API client with a configured `dio`.
- API endpoints behind:
  - `AuthApi.getSessionInfo()`
  - `UserApi.getUser(int accountId)`
  - `AssignmentApi.getMyAssignments()`

The placeholder notification provider should be replaced once a notifications/messages count endpoint exists.

## API Reference

### `ParticipantProfile`

Lightweight model used by participant-facing views.

#### Constructor

`ParticipantProfile({ required int accountId, required String email, String? firstName, String? lastName })`

**Parameters**
- `accountId` (`int`): Account/user identifier.
- `email` (`String`): Email address used as identity fallback.
- `firstName` (`String?`): Optional given name.
- `lastName` (`String?`): Optional surname.

**Returns**
- `ParticipantProfile`

#### Properties

- `accountId` (`int`)
- `email` (`String`)
- `firstName` (`String?`)
- `lastName` (`String?`)

#### Getter: `displayName -> String`

**Returns**
- `String`: Best-effort display name.

**Behavior**
- Builds a list from `[firstName, lastName]` where values are non-null and non-empty after trimming.
- If any parts exist, returns them joined by a space.
- Otherwise returns `email`.

---

## Providers

### `participantAuthApiProvider`

`Provider<AuthApi>`

**Purpose**
- Supplies an `AuthApi` instance backed by the shared API client.

**Depends on**
- `apiClientProvider`

**Returns**
- `AuthApi`

---

### `participantAssignmentApiProvider`

`Provider<AssignmentApi>`

**Purpose**
- Supplies an `AssignmentApi` instance backed by the shared API client.

**Depends on**
- `apiClientProvider`

**Returns**
- `AssignmentApi`

---

### `participantUserApiProvider`

`Provider<UserApi>`

**Purpose**
- Supplies a `UserApi` instance backed by the shared API client.

**Depends on**
- `apiClientProvider`

**Returns**
- `UserApi`

---

### `participantSurveyApiProvider`

`Provider<SurveyApi>`

**Purpose**
- Supplies a `SurveyApi` instance for optional task enrichment and survey metadata lookups.

**Depends on**
- `apiClientProvider`

**Returns**
- `SurveyApi`

**Notes**
- Currently not referenced by downstream providers in this file, but is defined for future enrichment use.

---

### `participantSessionProvider`

`FutureProvider<SessionMeResponse>`

**Purpose**
- Fetches the current session information used to derive participant identity and permissions.

**Depends on**
- `participantAuthApiProvider`

**Calls**
- `AuthApi.getSessionInfo()`

**Returns**
- `Future<SessionMeResponse>`

---

### `participantProfileProvider`

`FutureProvider<ParticipantProfile>`

**Purpose**
- Produces a `ParticipantProfile` for UI consumption, with name fallbacks if session data is incomplete.

**Depends on**
- `participantSessionProvider`
- `participantUserApiProvider` (conditionally, only when names are missing and `accountId > 0`)

**Composition Rules**
- Determine `viewingAs = session.viewingAs`.
- Resolve identity fields:
  - `accountId = viewingAs?.userId ?? session.user.accountId`
  - `email = viewingAs?.email ?? session.user.email`
  - `firstName = viewingAs?.firstName ?? session.user.firstName`
  - `lastName = viewingAs?.lastName ?? session.user.lastName`
- If `(firstName == null || lastName == null) && accountId > 0`:
  - Call `UserApi.getUser(accountId)`
  - Set `firstName/lastName` from the user response
- Return `ParticipantProfile(...)`.

**Returns**
- `Future<ParticipantProfile>`

---

### `participantAssignmentsProvider`

`FutureProvider<List<MyAssignment>>`

**Purpose**
- Fetches the participant’s current assignment/task list.

**Depends on**
- `participantAssignmentApiProvider`

**Calls**
- `AssignmentApi.getMyAssignments()`

**Returns**
- `Future<List<MyAssignment>>`

---

### `participantNotificationCountProvider`

`Provider<int>`

**Purpose**
- Placeholder provider for unread notifications/messages count.

**Depends on**
- Nothing

**Returns**
- `int` (currently always `0`)

**Notes**
- Contains a TODO to replace it with a real notifications/messages count endpoint.

---

## Error Handling

### Provider Error Propagation

- `participantSessionProvider`, `participantProfileProvider`, and `participantAssignmentsProvider` are `FutureProvider`s.
  - Any thrown exception from API calls will be captured by Riverpod and exposed as an error state (`AsyncValue.error`) to consumers.

This file does not implement:
- Retry logic
- Error mapping to domain-specific failures
- Logging or reporting hooks

These concerns are expected to be handled by:
- The API layer (`frontend/src/core/api/api.dart`) and/or
- UI consumers rendering appropriate loading/error states.

### Null and Fallback Behavior

- `ParticipantProfile.displayName` safely falls back to `email` when names are missing.
- `participantProfileProvider` attempts to mitigate missing name data by calling `UserApi.getUser(accountId)` when:
  - Either first name or last name is null, and
  - The resolved `accountId` is greater than 0

## Usage Examples

### Reading in a Consumer Widget

A typical usage pattern in a `ConsumerWidget` / `ConsumerState`:

- Watch `participantProfileProvider` to display the participant’s name.
- Watch `participantAssignmentsProvider` to render tasks and progress.
- Watch `participantNotificationCountProvider` to display an unread badge/banner.

Example behaviors:
- Show loading UI while `participantProfileProvider` is loading.
- Show error text if providers error.
- Use `ParticipantProfile.displayName` as a header name fallback.

### Ensuring API Client Availability

Because all API providers depend on `apiClientProvider`, the feature assumes:

- `apiClientProvider` is registered and accessible in the Riverpod scope.
- The API client is authenticated/configured appropriately for the session calls to succeed.

## Related Files

- `frontend/src/features/question_bank/state/question_providers.dart`
  - Exports `apiClientProvider` used as the dependency root for API service providers.
- `frontend/src/core/api/api.dart`
  - Declares API wrappers used here: `AuthApi`, `AssignmentApi`, `UserApi`, `SurveyApi`,
    plus response/model types like `SessionMeResponse` and `MyAssignment`.
- `frontend/lib/src/features/participant/pages/participant_dashboard_page.dart`
  - UI consumer of:
    - `participantProfileProvider`
    - `participantAssignmentsProvider`
    - `participantNotificationCountProvider`
- `frontend/src/features/participant/widgets/participant_scaffold.dart`
  - Participant page shell that likely consumes profile/notification state passed from pages.