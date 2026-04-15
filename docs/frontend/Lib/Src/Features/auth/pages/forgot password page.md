# ForgotPasswordPage

Step 1 of the password reset flow. Allows a user to request a password reset link by entering their email address, then shows a success state with a “Back to Login” action.

File: `frontend/lib/src/features/auth/pages/forgot_password_page.dart`

## Overview

`ForgotPasswordPage` is a `ConsumerStatefulWidget` that:

- Displays a form where the user enters their email address.
- Calls `authApi.requestPasswordReset(...)` to request a reset email.
- On success, switches to a confirmation/success UI state.
- Provides navigation back to the login page from both states.
- Handles network failures by showing a simple error message.

The page uses `BaseScaffold` with a `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `ForgotPasswordPage`
  - Owns form state and submission lifecycle.
  - Renders either:
    - Form state (`_buildFormContent`) before successful submission, or
    - Success state (`_buildSuccessContent`) after submission.

- `BaseScaffold` + `Header`
  - Provides consistent auth-flow layout with the standard top header.
  - Footer is disabled (`showFooter: false`).

### State management

Internal state:

- `_isLoading` (`bool`)
  - Disables input and buttons while submission is in progress.
  - Shows a spinner in the submit button.

- `_isSubmitted` (`bool`)
  - Controls whether to render the form or the success view.
  - Set to true after a successful API call.

- `_error` (`String?`)
  - Displays an error message when network/API invocation fails.

Inputs:

- `_emailController` (`TextEditingController`)
  - Holds the email input value.
  - Disposed in `dispose()`.

Form:

- `_formKey` (`GlobalKey<FormState>`)
  - Validates email before submission.

### Validation rules

Email field validation:

- Required (non-empty after trim).
- Must contain `@`.
- Uses localized error string `l10n.authEmailRequired` for both failure cases.

### Submission flow

On submit (`_handleSubmit()`):

1. Validates the form.
2. Sets loading state and clears existing error.
3. Calls:
   - `authApi.requestPasswordReset(PasswordResetEmailRequest(email: trimmedEmail))`
4. On success:
   - Sets `_isSubmitted = true`
   - Clears loading state
5. On error:
   - Clears loading state
   - Sets `_error = 'Unable to connect. Please try again.'`

Note: A comment indicates the backend returns HTTP 202 even for invalid emails, so the UI treats success as “request accepted” and only surfaces network failures.

### Navigation

- “Back to login” uses `context.go('/login')` from both the form and success states.
- The success state also provides an elevated “Back to Login” button.

### Responsive layout

- Uses `Breakpoints.isMobile(screenWidth)` to adjust padding/margins:
  - Card padding: 24 (mobile) or 40 (desktop)
  - Horizontal margin: 16 (mobile) or 0 (desktop)
- Content constrained to max width 400 and centered.

## Configuration

No external configuration is required.

Expected dependencies:

- Riverpod provider:
  - `authApiProvider` (API client used for password reset request)
- API models:
  - `PasswordResetEmailRequest`
- Localization:
  - Strings accessed via `context.l10n`
- Theme:
  - `AppTheme` and `Breakpoints`
- Routing:
  - Uses literal `/login` route via `GoRouter` (`context.go('/login')`)

## API Reference

## `ForgotPasswordPage`

### Constructor

```dart
const ForgotPasswordPage({Key? key});