# MessagesPage (`messages_page.dart`)

## Overview

`MessagesPage` is an admin-facing screen that displays **account requests** and allows administrators to manage them by:
- Viewing requests by status (Pending / Approved / Rejected).
- Approving pending requests (with confirmation).
- Rejecting pending requests (with confirmation and optional admin notes).
- Displaying request details, including participant-specific fields.

The page is built with Flutter + Riverpod and uses localized strings via `context.l10n`.

## Architecture / Design

### Layout and composition

The page is wrapped in `AdminScaffold` and composed of three primary parts:

1. **Header**
   - Localized title `l10n.adminAccountRequests`
   - Styled using the app theme (`AppTheme.primary`, bold)

2. **Status filter tabs** (`_StatusTabs`)
   - Three tab buttons:
     - Pending
     - Approved
     - Rejected
   - Uses a Riverpod state provider (`accountRequestStatusFilter`) to control the active status.

3. **Request list** (`_AccountRequestList`)
   - Watches `accountRequestsProvider` (async list of requests).
   - Displays loading / error / empty / data states.
   - Renders each request as `_AccountRequestCard`.

### State management (Riverpod)

Providers used:

- `accountRequestStatusFilter`
  - A state provider holding the current status filter as a `String` (expected values: `"pending"`, `"approved"`, `"rejected"`).
  - Updated by `_StatusTabs`.

- `accountRequestsProvider`
  - Supplies `AsyncValue<List<AccountRequestResponse>>`.
  - Assumed to return requests corresponding to the current `accountRequestStatusFilter` (either internally or via dependency on that provider).

- `accountRequestCountProvider`
  - Invalidated after approve/reject actions to refresh any badge/count UI elsewhere in the admin area.

- `adminApiProvider`
  - Provides an API client used to approve/reject account requests.

### User interaction flows

#### Approve request
- User clicks **Approve** on a pending request card.
- Confirmation dialog is shown.
- On confirm:
  - Calls `adminApiProvider.approveAccountRequest(request.requestId)`
  - Invalidates:
    - `accountRequestsProvider`
    - `accountRequestCountProvider`
  - Shows a success snackbar (`l10n.adminAccountRequestsApproved_msg`)
- On error:
  - Shows an error snackbar with `Error: <exception>`

#### Reject request
- User clicks **Reject** on a pending request card.
- Confirmation dialog is shown with a `TextField` for optional admin notes.
- On confirm:
  - Calls `adminApiProvider.rejectAccountRequest(request.requestId, AccountRequestRejectBody(...))`
  - `adminNotes` is included only if non-empty after trimming.
  - Invalidates:
    - `accountRequestsProvider`
    - `accountRequestCountProvider`
  - Shows a success snackbar (`l10n.adminAccountRequestsRejected_msg`)
- Notes controller is disposed in `finally` to avoid leaks.

### Localization

All user-facing strings on the page are sourced from `AppLocalizations` (`context.l10n`) except:
- Some dialog button labels use hard-coded `"Cancel"`.
- Error snackbar content uses `'Error: $e'`.

### Request card rendering rules

Each `_AccountRequestCard` displays:
- Full name (`firstName`, `lastName`)
- Role badge derived from `roleId`:
  - `1` -> Participant
  - `2` -> Researcher
  - `3` -> HCP
  - default -> `"Unknown"`
- Email
- Participant-specific fields (only if `roleId == 1`):
  - `birthdate` (if present)
  - `gender` / `genderOther` (if present)
- Created date (`createdAt`) if present
- Admin notes block if `adminNotes` is present and non-empty (not limited to rejected status by code; comment implies rejected)
- Action buttons only if `showActions == true` (i.e., pending tab)

## Configuration

No runtime configuration is required by this widget, but it depends on:

- Localization:
  - `frontend/src/core/l10n/l10n.dart` providing `context.l10n` and the referenced strings.

- Theme:
  - `frontend/src/core/theme/theme.dart` defining `AppTheme` styles/colors (`primary`, `error`, `gray`, `textMuted`, etc).

- API models:
  - `frontend/src/core/api/models/models.dart` providing:
    - `AccountRequestResponse`
    - `AccountRequestRejectBody`

- Providers/API wiring:
  - `frontend/src/features/admin/state/account_request_providers.dart` defining:
    - `accountRequestsProvider`
    - `accountRequestStatusFilter`
    - `accountRequestCountProvider`
    - `adminApiProvider` (or it may be exported from a different file; this page expects it to be available via `ref.read(adminApiProvider)`)

- Admin layout:
  - `frontend/src/features/admin/widgets/widgets.dart` providing `AdminScaffold`.

## API Reference

## `MessagesPage`

Admin screen that lists account requests and allows actions on pending requests.

### Constructor

`const MessagesPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `MessagesPage`.

### Public Members

#### `build(BuildContext context, WidgetRef ref) -> Widget`

Renders:
- Title
- `_StatusTabs` for status filtering
- `_AccountRequestList` for request rendering

Reads:
- `context.l10n` for localized strings.

---

## `_StatusTabs`

Tab row for selecting which request status to view.

### Public Members

#### `build(BuildContext context, WidgetRef ref) -> Widget`

Reads:
- `accountRequestStatusFilter` (`String`)

Writes:
- `accountRequestStatusFilter.notifier.state` set to:
  - `"pending"`, `"approved"`, `"rejected"`

---

## `_TabButton`

Reusable tab button component.

### Constructor

`const _TabButton({required String label, required bool isSelected, required VoidCallback onTap})`

#### Parameters
- `label` (`String`): Text shown inside the tab.
- `isSelected` (`bool`): Controls selected styling (filled primary vs outlined).
- `onTap` (`VoidCallback`): Called when tapped.

#### Returns
- An instance of `_TabButton`.

### Public Members

#### `build(BuildContext context) -> Widget`

Renders an `InkWell` wrapping a styled `Container`.

---

## `_AccountRequestList`

Loads and displays account requests for the current status filter.

### Public Members

#### `build(BuildContext context, WidgetRef ref) -> Widget`

Reads:
- `accountRequestsProvider` (`AsyncValue<List<AccountRequestResponse>>`)
- `accountRequestStatusFilter` (`String`)

Behavior:
- Loading: shows spinner
- Error: shows centered error text
- Empty: shows a styled empty state container
- Data: renders a column of `_AccountRequestCard`

---

## `_AccountRequestCard`

Card UI for a single account request, optionally including approve/reject actions.

### Constructor

`const _AccountRequestCard({required AccountRequestResponse request, required bool showActions})`

#### Parameters
- `request` (`AccountRequestResponse`): The request data to display.
- `showActions` (`bool`): If `true`, renders Approve/Reject buttons.

#### Returns
- An instance of `_AccountRequestCard`.

### Private helpers

#### `_roleName(int roleId, AppLocalizations l10n) -> String`

Maps role ID to localized role name:
- `1` -> `l10n.requestAccountRoleParticipant`
- `2` -> `l10n.requestAccountRoleResearcher`
- `3` -> `l10n.requestAccountRoleHcp`
- default -> `"Unknown"`

### Public Members

#### `build(BuildContext context, WidgetRef ref) -> Widget`

Renders:
- Name + role badge
- Email
- Participant-only fields (birthdate, gender)
- Created date (optional)
- Admin notes (optional)
- Action buttons if `showActions == true`

### Actions

#### `_handleApprove(BuildContext context, WidgetRef ref) -> Future<void>`

Flow:
1. Shows confirmation dialog.
2. If confirmed:
   - Calls `approveAccountRequest(request.requestId)` via `adminApiProvider`.
   - Invalidates `accountRequestsProvider` and `accountRequestCountProvider`.
   - Shows success snackbar.
3. On error:
   - Shows error snackbar.

Notes:
- Guards against using context after unmount with `context.mounted`.

#### `_handleReject(BuildContext context, WidgetRef ref) -> Future<void>`

Flow:
1. Creates a `TextEditingController` for admin notes.
2. Shows confirmation dialog with notes field.
3. If confirmed:
   - Calls `rejectAccountRequest(request.requestId, AccountRequestRejectBody(adminNotes: ...))`.
   - Invalidates `accountRequestsProvider` and `accountRequestCountProvider`.
   - Shows success snackbar.
4. On error:
   - Shows error snackbar.
5. Always disposes the notes controller in `finally`.

Notes:
- `adminNotes` is sent only if trimmed input is non-empty; otherwise `null`.

## Error Handling

### Provider load errors
- `accountRequestsProvider` error state renders an inline error message inside padding:
  - `"Error loading requests: $e"`
  - Styled with `AppTheme.error`.

### API action failures
- Approve/reject failures are caught and surfaced via snackbar:
  - Content: `"Error: $e"`
  - Background: `AppTheme.error`

### Context safety
- After dialogs, actions exit early if:
  - Not confirmed
  - `!context.mounted`

### Resource cleanup
- Reject dialog `TextEditingController` is always disposed (in `finally`).

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/messages': (_) => const MessagesPage(),
}