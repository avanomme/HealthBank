# ChangePasswordPage

A forced password change page shown when a user logs in with a temporary password. The user must set a new password before accessing the rest of the application.

File: `frontend/lib/features/auth/pages/change_password_page.dart`

## Overview

`ChangePasswordPage` is a `ConsumerStatefulWidget` that:

- Prompts the user for:
  - Current password
  - New password
  - Confirmation of the new password
- Validates inputs with localized error messages.
- Submits a `ChangePasswordRequest` via `authApiProvider`.
- Updates auth state to clear the “must change password” requirement.
- Redirects the user to the correct next page after success:
  - Profile completion flow (if required)
  - Consent flow (if not signed)
  - Role-appropriate dashboard route
- Displays a simple error message when the change fails.

This page uses `BaseScaffold` with a top `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `ChangePasswordPage`:
  - Provides the page entry point.
  - Owns form controllers and UI flags (loading, field obscurity, error text).
  - Orchestrates password change and post-success navigation.

- `BaseScaffold` + `Header`:
  - Ensures consistent layout and top navigation styling.
  - Footer is disabled (`showFooter: false`) to keep focus on the required action.

### State and form management

Internal state:

- `_isLoading` (`bool`): disables inputs/buttons and shows a spinner in the submit button.
- `_obscureCurrent`, `_obscureNew`, `_obscureConfirm` (`bool`): control visibility toggles for each password field.
- `_error` (`String?`): error text rendered above the submit button when present.

Controllers:

- `_currentPasswordController`
- `_newPasswordController`
- `_confirmPasswordController`

Form:

- `_formKey` validates all fields before submission.

### Validation rules

All fields:
- Required (localized message `changePasswordRequired`).

New password:
- Minimum length 8 (localized `changePasswordMinLength`).
- Must not equal current password (localized `changePasswordSameAsOld`).

Confirm new password:
- Must match new password (localized `changePasswordMismatch`).

### Submission and navigation flow

On successful `authApi.changePassword(...)`:

1. Clears the “must change password” flag:
   - `ref.read(authProvider.notifier).clearMustChangePassword()`
2. Reads updated auth state to determine next route:
   - If `needsProfileCompletion` is true: navigates to `AppRoutes.completeProfile`
   - Else if `hasSignedConsent` is false: navigates to `AppRoutes.consent`
   - Else: navigates to role dashboard route via:
     - `getDashboardRouteForRole(authState.user?.role)`

Navigation uses `GoRouter` (`context.go(...)`).

### Responsive layout

- Uses `Breakpoints.isMobile(screenWidth)` to set paddings/margins:
  - Mobile: smaller outer margins and reduced card padding
  - Desktop: centered fixed-width card with larger padding
- Content is constrained to a max width of 400.

## Configuration

No external configuration is required.

The page expects the following to be available in the app:

- Riverpod providers:
  - `authApiProvider` (API client with `changePassword`)
  - `authProvider` (auth state and notifier)
- Routing:
  - `AppRoutes.completeProfile`
  - `AppRoutes.consent`
  - `getDashboardRouteForRole(role)` helper
- Localization:
  - Strings used via `context.l10n`
- Theme:
  - `AppTheme` and `Breakpoints`

## API Reference

## `ChangePasswordPage`

### Constructor

```dart
const ChangePasswordPage({Key? key});