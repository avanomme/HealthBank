# LoginForm

A credential entry form used on the login screen. Provides email and password inputs, basic validation, a “Forgot Password” action, and a submit button. Includes a development-only shortcut allowing usernames without an `@` symbol.

File: `frontend/lib/features/auth/widgets/login_form.dart`

## Overview

`LoginForm` is a `StatefulWidget` that:

- Collects:
  - Email (or username in dev shortcut mode)
  - Password
- Validates:
  - Email is non-empty (but does not enforce `@` due to a dev shortcut)
  - Password is non-empty
- Provides:
  - “Forgot Password” text button
  - “Log In” button with loading spinner
- Disables all inputs/actions when `isLoading` is true.
- Supports submitting via:
  - Pressing the “Log In” button
  - Submitting from the password field (`onFieldSubmitted`)

## Architecture / Design

### Widget responsibilities

- `LoginForm`
  - Owns the form state and input controllers.
  - Performs local validation.
  - Emits submitted values through `onSubmit(email, password)` callback.
  - Delegates navigation/side-effects to the parent via callbacks.

### State and controllers

Internal state:

- `_obscurePassword` (`bool`)
  - Toggles password visibility via the suffix icon button.

Controllers:

- `_emailController` (`TextEditingController`)
- `_passwordController` (`TextEditingController`)

Form key:

- `_formKey` (`GlobalKey<FormState>`)
  - Controls validation checks in `_handleSubmit()`.

Lifecycle:

- Controllers are disposed in `dispose()`.

### Submission behavior

`_handleSubmit()`:

- Calls `_formKey.currentState?.validate()`
- If valid, invokes:

  - `widget.onSubmit?.call(_emailController.text.trim(), _passwordController.text)`

Password field also triggers submission on enter via `onFieldSubmitted`.

### Validation rules

Email field validator:

- Fails if empty or whitespace: returns `context.l10n.authEmailRequired`
- Does **not** check for `@` due to a development login shortcut.

Development-only behavior (not enforced in code, documented in comments):

- Allows login with a username only (no `@`)
- Backend is expected to append `@hb.com` automatically
- Comment indicates this should be removed for production

Password field validator:

- Fails if empty: returns `context.l10n.authPasswordRequired`

### Layout and responsiveness

- Uses a `Form` containing a `Column`.
- The bottom row (forgot password + login button) uses `Wrap`:
  - Wraps on narrow screens
  - Uses `spacing` and `runSpacing` to maintain layout on small widths

### Theming and localization

- Labels and button text use `context.l10n`:
  - `commonEmail`, `commonPassword`
  - `authLoginForgotPassword`
  - `authLoginButton`
  - `authEmailRequired`
  - `authPasswordRequired`
- Styling uses `AppTheme`:
  - Filled input backgrounds (`AppTheme.gray`)
  - Button colors (`AppTheme.primary`, `AppTheme.secondary`)
  - Text colors (`AppTheme.textPrimary`, `AppTheme.textMuted`, `AppTheme.textContrast`)

## Configuration

No external configuration is required.

Expected dependencies:

- `AppTheme` from `frontend/src/core/theme/theme.dart`
- Localization extension from `frontend/src/core/l10n/l10n.dart`

## API Reference

## `LoginForm`

### Constructor

```dart
const LoginForm({
  Key? key,
  void Function(String email, String password)? onSubmit,
  VoidCallback? onForgotPassword,
  bool isLoading = false,
});