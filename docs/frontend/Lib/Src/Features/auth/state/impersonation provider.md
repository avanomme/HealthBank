# Impersonation Provider and State

Riverpod state management for “view as user” (impersonation) behavior in an admin session. Tracks whether the current session is impersonating, the viewed user, optional admin info, session expiration, and exposes helper providers for admin checks and current role.

File: `frontend/lib/src/features/auth/state/impersonation_provider.dart`

## Overview

This module defines:

- `ImpersonationState`: immutable state model describing the current impersonation/session context.
- `ImpersonationNotifier`: `StateNotifier<ImpersonationState>` implementing:
  - Fetching current session info (`fetchSessionInfo`)
  - Starting impersonation (`startImpersonation`)
  - Ending impersonation (`endImpersonation`)
  - Clearing impersonation state (`clearImpersonationState`, `clear`)
  - Clearing error state (`clearError`)
- `impersonationProvider`: `StateNotifierProvider` exposing the state and notifier.
- Helper providers:
  - `isSystemAdminProvider`: checks if the current user can impersonate
  - `currentUserRoleProvider`: returns the current user role from the session context

## Architecture / Design

### How impersonation is represented

Impersonation is modeled as a session-level mode:

- `isImpersonating` indicates whether the backend session is currently “viewing as” another user.
- `currentUser` represents the effective user for the session:
  - When impersonating: the viewed user
  - When not impersonating: the logged-in user (as returned by `getSessionInfo`)
- `adminInfo` contains admin identity details when impersonating (only populated if provided by the session info response).
- `sessionExpiresAt` is stored for informational/diagnostic use.

### Key provider relationships

- `ImpersonationNotifier` reads:
  - `authApiProvider` (to call `getSessionInfo`)
  - `adminApiProvider` (to start/end view-as) from `frontend/src/features/admin/state/database_providers.dart`
  - `authProvider` (for the fallback admin check in `isSystemAdminProvider`)

### Session info synchronization

`fetchSessionInfo()` pulls session state from the backend and normalizes it into `ImpersonationState`. This is intended to keep the frontend aligned with the backend’s view-as state, particularly after login/MFA or other auth transitions.

### Start/End impersonation design notes

This implementation assumes “view-as” modifies the existing admin session on the backend:

- No token switching
- No separate login session for the viewed user
- “Start view-as” sets a server-side `ViewingAsUserID`
- “End view-as” clears that server-side state

The notifier intentionally avoids clearing the entire local state immediately in `endImpersonation()` to prevent UI unmount/navigation ordering problems (see below).

## Configuration

This module expects:

- `authApiProvider` to expose:
  - `getSessionInfo()`
- `adminApiProvider` to expose:
  - `startViewingAs(int userId)`
  - `endViewingAs()`
- API models in `frontend/src/core/api/api.dart` (or re-exported from it), including:
  - `SessionUserInfo`
  - `ImpersonationInfo`
  - The response models returned by:
    - `AuthApi.getSessionInfo()`
    - `adminApi.startViewingAs(...)`

## API Reference

## `ImpersonationState`

### Constructor

```dart
const ImpersonationState({
  bool isImpersonating = false,
  bool isLoading = false,
  String? error,
  SessionUserInfo? currentUser,
  ImpersonationInfo? adminInfo,
  String? sessionExpiresAt,
});