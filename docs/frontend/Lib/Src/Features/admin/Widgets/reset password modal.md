# ResetPasswordModal

A modal dialog for administrators to reset a user’s password, optionally generate a secure temporary password, optionally send a reset email (with optional email override), and copy the password to the clipboard.

File: `frontend/lib/src/features/admin/widgets/reset_password_modal.dart`

## Overview

`ResetPasswordModal` is a Riverpod-powered `ConsumerStatefulWidget` presented as an `AlertDialog`. It provides:

- A form-based UI to enter or generate a new password.
- Password visibility toggle.
- Random password generation (12 characters, avoids ambiguous characters).
- Copy-to-clipboard action with confirmation snackbar.
- Optional “Send email notification” flow:
  - Optionally specify an alternate email address.
- Submission that performs:
  1. Password reset via admin API
  2. Optional reset email via admin API
- Success/failure feedback via snackbars and inline error display.

A helper function `showResetPasswordModal` is provided to present the dialog and return whether the operation completed.

## Architecture / Design

### Widget structure

- `ResetPasswordModal` (`ConsumerStatefulWidget`)
  - Owns form state and controllers.
  - Renders an `AlertDialog` containing:
    - User summary card (name/email + avatar)
    - Optional error banner
    - Password input row (field + generate + copy)
    - Email notification options
    - Dialog actions (Cancel / Reset)

- `_ResetPasswordModalState`
  - Manages:
    - Form validation
    - Random password generation
    - UI state for toggles and loading
    - API calls and result handling

### State management

Internal state variables:

- `_obscurePassword` (`bool`): controls password visibility
- `_sendEmail` (`bool`): whether to send reset email
- `_useAlternateEmail` (`bool`): whether to use the email field as override
- `_isLoading` (`bool`): disables inputs/buttons while submitting
- `_errorMessage` (`String?`): shown inline when submission fails

Controllers:

- `_passwordController` (`TextEditingController`): password field
- `_emailController` (`TextEditingController`): alternate email field; pre-populated with `user.email`

Form:

- `_formKey` (`GlobalKey<FormState>`): validates password and optional alternate email.

### Password generation

- `_generatePassword()` produces a 12-character password from:
  - Upper/lower letters and digits excluding ambiguous characters:
    - Excludes: `I`, `O`, `l`, `o`, `0`, `1`
  - Uses `Random.secure()` for randomness.
- `_onGeneratePassword()` sets the generated password into the password field and reveals it (`_obscurePassword = false`).

### API integration flow

On submit (`_onSubmit()`):

1. Validates the form:
   - Password required and at least 8 characters.
   - Alternate email required and must contain `@` only when `_useAlternateEmail` is enabled.
2. Reads `adminApiProvider` from Riverpod.
3. Calls:
   - `adminApi.resetPassword(accountId, PasswordResetRequest(newPassword: password))`
4. If `_sendEmail` is true:
   - Determines `emailOverride`:
     - `null` when not using alternate email
     - `_emailController.text` when `_useAlternateEmail` is true
   - Calls:
     - `adminApi.sendResetEmail(accountId, SendResetEmailRequest(temporaryPassword: password, emailOverride: emailTo))`
5. On success:
   - Closes the dialog with `Navigator.pop(true)`
   - Shows a success `SnackBar` (message depends on whether email was sent)
6. On error:
   - Captures `e.toString()` and strips `Exception: `
   - Displays inline error box
7. Always:
   - Clears loading state when mounted

### Dialog sizing

- Dialog width adapts:
  - If screen width `< 500`: uses `screenWidth * 0.9`
  - Otherwise: fixed width `450.0`

## Configuration

No external configuration is required, but the widget expects:

- Riverpod provider:
  - `adminApiProvider` (from `frontend/src/features/admin/state/database_providers.dart`)
- API models:
  - `User`, `PasswordResetRequest`, `SendResetEmailRequest` (from `frontend/src/core/api/api.dart`)
- Theme:
  - `AppTheme` (from `frontend/src/core/theme/theme.dart`)

## API Reference

## `ResetPasswordModal`

### Constructor

```dart
const ResetPasswordModal({
  Key? key,
  required User user,
});