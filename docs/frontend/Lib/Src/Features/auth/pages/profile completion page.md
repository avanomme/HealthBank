# ProfileCompletionPage

A post-login/profile-gating page for participants to complete missing profile fields (birthdate and gender). Typically shown for admin-created participant accounts that lack required demographic fields.

File: `frontend/lib/features/auth/pages/profile_completion_page.dart`

## Overview

`ProfileCompletionPage` is a `ConsumerStatefulWidget` that:

- Collects required participant profile fields:
  - Birthdate (via date picker)
  - Gender (via dropdown)
- Submits the completion payload via `authApi.completeProfile(...)`.
- Updates auth state to clear the “needs profile completion” flag.
- Routes the user onward after success:
  - If consent has not been signed → `AppRoutes.consent`
  - Otherwise → role-appropriate dashboard via `getDashboardRouteForRole(role)`
- Shows localized error messages on validation failure and API failure.

The page uses `BaseScaffold` with a `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `ProfileCompletionPage`
  - Presents a constrained card UI for completion inputs.
  - Orchestrates:
    - Date selection
    - Gender selection
    - Form validation
    - API submission
    - Post-submit routing

- `BaseScaffold` + `Header`
  - Provides consistent auth-flow layout.
  - Footer disabled (`showFooter: false`) to focus completion.

### State and form inputs

Internal state:

- `_selectedBirthdate` (`DateTime?`)
  - Selected via `showDatePicker`.
- `_selectedGender` (`String?`)
  - Selected via `DropdownButtonFormField<String>`.
- `_isLoading` (`bool`)
  - Disables interactions while submission is in progress.
- `_error` (`String?`)
  - Displays a localized message when input is missing or submission fails.

Form:

- `_formKey` (`GlobalKey<FormState>`)
  - Used to validate the form before submit.

### Birthdate selection

- `_pickBirthdate()` opens `showDatePicker` with:
  - `initialDate`: selected birthdate or `now.year - 25`
  - `firstDate`: 1900
  - `lastDate`: today (`now`)
- On selection, sets `_selectedBirthdate`.

Birthdate display format:

- Rendered as `YYYY-MM-DD` in the UI using manual padding (`padLeft(2, '0')`).

### Gender selection

The dropdown values used in the payload are fixed strings:

- `Male`
- `Female`
- `Non-Binary`
- `Prefer Not to Say`
- `Other`

The displayed labels are localized via `l10n.profileCompletionGender*`.

### Submission flow

On submit (`_handleSubmit()`):

1. Validates the form (`_formKey`).
2. Enforces required selections:
   - Birthdate must be selected; otherwise sets `_error` to `l10n.profileCompletionBirthdateRequired`.
   - Gender must be selected; otherwise sets `_error` to `l10n.profileCompletionGenderRequired`.
3. Sets loading state and clears error.
4. Formats birthdate as `YYYY-MM-DD`.
5. Calls:
   - `authApi.completeProfile(ProfileCompleteRequest(birthdate: ..., gender: ...))`
6. Clears auth gating flag:
   - `ref.read(authProvider.notifier).clearNeedsProfileCompletion()`
7. Routes onward:
   - If consent not signed → `context.go(AppRoutes.consent)`
   - Else → `context.go(getDashboardRouteForRole(role))`

On error:

- Clears loading state and sets `_error` to `l10n.profileCompletionError`.

### Responsive layout

- Uses `Breakpoints.isMobile(screenWidth)`:
  - Card padding: 24 (mobile) or 40 (desktop)
  - Horizontal margin: 16 (mobile) or 0 (desktop)
- Content constrained to max width 400 and centered.

## Configuration

No external configuration is required.

Expected dependencies:

- Riverpod providers:
  - `authApiProvider` (API client)
  - `authProvider` (auth state and notifier)
- API models:
  - `ProfileCompleteRequest` (from `frontend/src/core/api/models/models.dart`)
- Routing helpers/constants:
  - `AppRoutes.consent`
  - `getDashboardRouteForRole(role)`
- Localization:
  - Strings accessed via `context.l10n`
- Theme:
  - `AppTheme` and `Breakpoints`

## API Reference

## `ProfileCompletionPage`

### Constructor

```dart
const ProfileCompletionPage({Key? key});