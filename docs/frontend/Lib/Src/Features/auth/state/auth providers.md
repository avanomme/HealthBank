# Auth Providers and State

Riverpod providers and state management for authentication, session restore, MFA challenge verification, and role-based dashboard routing.

File: `frontend/lib/features/auth/state/auth_providers.dart`

## Overview

This module defines:

- `authApiProvider`: Riverpod `Provider` that exposes an `AuthApi` instance wired to the app’s shared `Dio` client.
- `AuthState`: immutable state model representing the current authentication/session state, including gating flags (must change password, consent, profile completion) and MFA challenge status.
- `AuthNotifier`: a `StateNotifier<AuthState>` that implements:
  - Login (`login`)
  - MFA verification (`verifyMfa`)
  - Session restore (`restoreSession`)
  - Logout (`logout`)
  - State flag helpers for post-login gates
  - Error parsing for login and MFA workflows
- `authProvider`: `StateNotifierProvider` exposing `AuthNotifier` and `AuthState`.
- `getDashboardRouteForRole`: helper mapping a role string to a route.

## Architecture / Design

### Providers

#### `authApiProvider`

- Type: `Provider<AuthApi>`
- Dependency: `apiClientProvider` (shared API client wrapper exposing `dio`)
- Purpose: constructs `AuthApi(client.dio)` for use by the notifier.

#### `authProvider`

- Type: `StateNotifierProvider<AuthNotifier, AuthState>`
- Purpose: central auth state store for UI and routing decisions.
- Owned logic: auth flows live in `AuthNotifier`.

### `AuthState` model

`AuthState` consolidates the auth/session lifecycle and post-login gates:

Core fields:

- `isAuthenticated`: whether the client considers the user logged in
- `isLoading`: whether an auth-related request is in progress
- `error`: last error message to display
- `user`: `LoginResponse?` containing user/session-related fields

Post-login gating flags:

- `mustChangePassword`: user must visit forced password change
- `hasSignedConsent`: user must complete consent before dashboard
- `needsProfileCompletion`: user (participant) must supply missing profile fields

MFA fields:

- `mfaRequired`: indicates that MFA is required to complete login
- `mfaChallengeToken`: challenge token used for verifying the code

Immutability helpers:

- `copyWith(...)`: produces a new instance with overrides.
- `clearError()`: returns a state identical to the current state but with `error` cleared.

### `AuthNotifier` state machine

#### Login flow

`login(email, password)` performs:

1. Sets state to loading and clears prior errors and MFA flags.
2. Calls `AuthApi.login(LoginRequest(...))`, treating the response as a dynamic map.
3. Branches on MFA challenge:
   - If `json['mfa_required'] == true`:
     - Sets:
       - `mfaRequired = true`
       - `mfaChallengeToken = json['challenge_token']`
       - also carries forward gating flags that may be included in the challenge payload:
         - `mustChangePassword = json['must_change_password'] == true`
         - `needsProfileCompletion = json['needs_profile_completion'] == true`
     - Returns `null` to indicate navigation should go to the MFA page.
   - Else:
     - Parses `LoginResponse.fromJson(json)`
     - Sets authenticated state and gating flags from `LoginResponse`:
       - `mustChangePassword`, `hasSignedConsent`, `needsProfileCompletion`
     - Returns `user.role`

Errors are mapped to user-friendly strings by `_parseError`.

#### MFA verification flow

`verifyMfa(code)`:

1. Requires a non-empty `mfaChallengeToken`; otherwise sets an error and returns `null`.
2. Calls `AuthApi.verify2fa(Verify2FARequest(challengeToken: token, code: code))`.
3. Parses the response into `LoginResponse`.
4. Sets authenticated state and gating flags.
5. Calls `impersonationProvider.notifier.fetchSessionInfo()` after successful auth.
6. Returns `user.role`.

On error:

- Derives a display message via `_parseMfaError`.
- Determines whether to clear the challenge token:
  - Clears on likely lockout/expired cases:
    - when exception string contains `429`, `challenge`, or `expired`
  - Keeps the challenge for normal invalid-code attempts (notably `401`)
- Updates state accordingly:
  - If clearing:
    - `mfaRequired = false`
    - `mfaChallengeToken = null`
  - Else:
    - `mfaRequired = true`
    - keeps the existing token

#### Session restore flow

`restoreSession()`:

1. Calls `AuthApi.getSessionInfo()`.
2. Constructs a `LoginResponse` from session info fields.
3. Sets:
   - `isAuthenticated = true`
   - `user = constructed LoginResponse`
   - `hasSignedConsent`, `needsProfileCompletion` from session info
4. Calls `impersonationProvider.notifier.fetchSessionInfo()`.
5. Returns the restored role for routing.

If restore fails, returns `null` and leaves state unchanged.

#### Logout flow

`logout()` attempts to call `AuthApi.logout()` (ignores errors), then resets state to the default `AuthState()`.

### Role-based routing helper

`getDashboardRouteForRole(role)` maps:

- `admin` → `/admin`
- `researcher` → `/researcher/dashboard`
- `hcp` → `/hcp/dashboard`
- `participant` (default) → `/participant/dashboard`

This helper is used by multiple auth pages to redirect after login/MFA/profile/consent completion.

## Configuration

This module expects:

- A configured API client provider:
  - `apiClientProvider` supplying an object with `.dio`
- An `AuthApi` Retrofit service (or equivalent) exposing:
  - `login`
  - `verify2fa`
  - `logout`
  - `getSessionInfo`
- An impersonation/session integration provider:
  - `impersonationProvider.notifier.fetchSessionInfo()` callable after auth/restore

## API Reference

## Providers

### `authApiProvider`

```dart
final authApiProvider = Provider<AuthApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApi(client.dio);
});