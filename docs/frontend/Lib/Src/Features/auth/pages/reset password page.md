# ResetPasswordPage

Step 2 of the password reset flow. Accepts a reset token (typically from an email link), lets the user set a new password, confirms it, submits the reset confirmation to the backend, and then shows a success state with navigation back to login.

File: `frontend/lib/src/features/auth/pages/reset_password_page.dart`

## Overview

`ResetPasswordPage` is a `ConsumerStatefulWidget` that:

- Expects a password reset `token` (provided via route/query param and passed into the widget).
- If the token is missing/empty:
  - Shows an “Invalid Reset Link” view with actions to request a new reset link or return to login.
- If the token is present:
  - Shows a form to enter:
    - New password
    - Confirm password
  - Validates input (required, min length, matching confirm)
  - Calls `authApi.confirmPasswordReset(...)` with the token and new password
  - On success, shows a confirmation view with “Back to Login”
  - On failure, shows an error message indicating the link is invalid/expired

The page uses `BaseScaffold` with a top `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `ResetPasswordPage`
  - Controls the reset flow state machine:
    - Invalid token view
    - Form view
    - Success view
  - Owns input controllers and loading/error flags.
  - Orchestrates API calls and UI transitions.

- `BaseScaffold` + `Header`
  - Provides consistent auth-flow layout.
  - Footer disabled (`showFooter: false`).

### State and inputs

Internal state:

- `_obscurePassword` (`bool`): toggles visibility for the new password field.
- `_obscureConfirm` (`bool`): toggles visibility for the confirm field.
- `_isLoading` (`bool`): disables form controls and shows spinner during submission.
- `_isSuccess` (`bool`): switches to success content after a successful reset.
- `_error` (`String?`): displays error message when reset fails.

Controllers:

- `_passwordController` (`TextEditingController`)
- `_confirmController` (`TextEditingController`)

Form:

- `_formKey` (`GlobalKey<FormState>`) controls validation.

Derived state:

- `hasToken` is computed as:
  - `widget.token != null && widget.token!.isNotEmpty`
- Render selection:
  - If `!hasToken` → invalid token content
  - Else if `_isSuccess` → success content
  - Else → form content

### Validation rules

New password:

- Required (`l10n.authPasswordRequired`)
- Minimum length 8 (hardcoded string: “Password must be at least 8 characters”)

Confirm password:

- Required (hardcoded string: “Please confirm your password”)
- Must match `_passwordController.text` (hardcoded string: “Passwords do not match”)

### Submission flow

On submit (`_handleSubmit()`):

1. Validates the form.
2. Sets loading state and clears error.
3. Calls:
   - `authApi.confirmPasswordReset(PasswordResetConfirmRequest(token: token, newPassword: password))`
4. On success:
   - Sets `_isSuccess = true`
   - Clears loading state
5. On error:
   - Clears loading state
   - Sets `_error = 'Invalid or expired reset link. Please request a new one.'`

### Navigation

- Back to login:
  - `context.go('/login')` from form and success content
- Invalid token view:
  - “Request new reset” button routes to `/forgot-password`
  - “Back to login” routes to `/login`

### Responsive layout

- Uses `Breakpoints.isMobile(screenWidth)`:
  - Card padding: 24 (mobile) or 40 (desktop)
  - Horizontal margin: 16 (mobile) or 0 (desktop)
- Content constrained to max width 400 and centered.

## Configuration

No external configuration is required.

Expected dependencies:

- Riverpod provider:
  - `authApiProvider` (API client with `confirmPasswordReset`)
- API model:
  - `PasswordResetConfirmRequest`
- Localization:
  - Uses `context.l10n` for some strings (not all; several strings are currently hardcoded)
- Theme:
  - `AppTheme` and `Breakpoints`
- Routing:
  - Expects `/login` and `/forgot-password` routes to exist

## API Reference

## `ResetPasswordPage`

### Constructor

```dart
const ResetPasswordPage({Key? key, String? token});