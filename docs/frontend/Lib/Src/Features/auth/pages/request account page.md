# RequestAccountPage

A public-facing account request form that allows users to request access to the system by submitting their name, email, and desired role. When the requested role is “Participant”, additional demographic fields (birthdate and gender) are collected.

File: `frontend/lib/features/auth/pages/request_account_page.dart`

## Overview

`RequestAccountPage` is a `ConsumerStatefulWidget` that:

- Collects account request information:
  - First name
  - Last name
  - Email
  - Role selection
- Conditionally collects participant fields when role is Participant:
  - Birthdate (date picker)
  - Gender (dropdown)
  - “Other” gender free-text input
- Submits the form to a public account request endpoint via `authApi.submitAccountRequest(...)`.
- Shows a success confirmation UI once submitted.
- Provides navigation back to login from both form and success states.
- Handles common backend error cases (duplicate email, pending request, rate limiting) and displays user-friendly messages.

The page uses `BaseScaffold` with a `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `RequestAccountPage`
  - Owns and validates form inputs.
  - Switches between:
    - Form UI (`_buildFormContent`)
    - Success UI (`_buildSuccessContent`)
  - Orchestrates conditional participant fields based on role selection.

- `BaseScaffold` + `Header`
  - Provides consistent authentication-flow layout.
  - Footer disabled (`showFooter: false`).

### State management

Internal state:

- `_selectedRoleId` (`int?`)
  - Determines role selection and whether participant fields are shown.
  - Participant is identified as role ID `1`.

- `_selectedGender` (`String?`)
  - Selected gender (participant only).

- `_selectedBirthdate` (`DateTime?`)
  - Selected birthdate (participant only).

- `_isLoading` (`bool`)
  - Disables fields and buttons while submitting.

- `_isSubmitted` (`bool`)
  - Toggles between form view and success view.

- `_error` (`String?`)
  - Displays an error message when submission fails.

Controllers:

- `_firstNameController`
- `_lastNameController`
- `_emailController`
- `_genderOtherController`

Derived state:

- `_isParticipant` (`bool`)
  - True when `_selectedRoleId == 1`.

### Validation rules

- First name: required (localized `requestAccountFirstNameRequired`)
- Last name: required (localized `requestAccountLastNameRequired`)
- Email:
  - required (localized `requestAccountEmailRequired`)
  - must contain `@` (localized `authEmailInvalid`)
- Role: required (localized `requestAccountRoleRequired`)

Participant-specific fields:
- Birthdate:
  - No explicit validator, but value is included if selected; selection is not enforced in code.
- Gender:
  - No explicit validator; selection is optional in code.
- Gender other text:
  - Shown only when `_selectedGender == 'Other'`; no validator.

### Birthdate selection

- `_pickBirthdate()` uses `showDatePicker`:
  - `initialDate`: selected or `now.year - 25`
  - `firstDate`: 1900
  - `lastDate`: today
- Display and submission format: `YYYY-MM-DD` with zero-padded month/day.

### Submission flow

On submit (`_handleSubmit()`):

1. Validates the form via `_formKey`.
2. Sets loading state and clears error.
3. Calls:
   - `authApi.submitAccountRequest(AccountRequestCreate(...))`
4. Builds `AccountRequestCreate`:
   - `firstName`, `lastName`, `email` trimmed
   - `roleId` required (`_selectedRoleId!`)
   - `birthdate`: formatted string when selected, otherwise `null`
   - `gender`: only set when participant, otherwise `null`
   - `genderOther`: only set when gender is `Other`, otherwise `null`
5. On success:
   - Sets `_isSubmitted = true`
   - Clears loading state
6. On error:
   - Parses `e.toString()` for common cases and sets a display message:
     - Duplicate account (409 + “already exists”) → `l10n.requestAccountDuplicateEmail`
     - Duplicate pending request (409 + “pending”) → `l10n.requestAccountDuplicatePending`
     - Rate limit (429) → `Too many requests. Please try again later.`
     - Fallback → `Unable to submit request. Please try again.`
   - Clears loading state

### Navigation

- “Back to login” uses `context.go('/login')` in both form and success views.

### Responsive layout

- Uses `Breakpoints.isMobile(screenWidth)`:
  - Card padding: 24 (mobile) or 40 (desktop)
  - Horizontal margin: 16 (mobile) or 0 (desktop)
- Content constrained to max width 460 and centered.

## Configuration

No external configuration is required.

Expected dependencies:

- Riverpod provider:
  - `authApiProvider` (API client with `submitAccountRequest`)
- API model:
  - `AccountRequestCreate`
- Localization:
  - Strings accessed via `context.l10n`
- Theme:
  - `AppTheme` and `Breakpoints`
- Routing:
  - Uses literal `/login` via `GoRouter` (`context.go('/login')`)

## API Reference

## `RequestAccountPage`

### Constructor

```dart
const RequestAccountPage({Key? key});