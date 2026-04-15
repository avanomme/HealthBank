# UserManagementPage (`user_management_page.dart`)

## Overview

`UserManagementPage` is an admin-facing screen for managing application users. It renders a sortable, filterable user table and provides common administration actions such as creating users, editing user attributes (role/access), resetting passwords, activating/deactivating accounts, deleting accounts, and (for system administrators) impersonating a user account.

Key capabilities shown in this file:
- Fetching users from an API via Riverpod (`usersProvider`)
- Persisting and updating filters through a Riverpod notifier (`userFiltersProvider`)
- Client-side sorting across multiple columns
- Expandable table rows (used here to expose consent status and consent record actions)
- Role-based UI gating for impersonation (`isSystemAdminProvider`)
- Modal dialogs for create/edit user flows (`_UserFormDialog`)
- Consent record viewing dialog backed by `FutureProvider.family` (`userConsentProvider` and `_ConsentRecordDialog`)

## Architecture / Design

### Page container and layout

- The page uses `AdminScaffold` with:
  - `currentRoute: '/admin/users'`
  - `scrollable: false` (table is expected to handle internal scrolling, using sticky headers)

The page’s main content is a `Column`:
1. Header (`_buildHeader`) with “User Management” title and “Add User” button.
2. Filter panel (`_buildFilters`) with:
   - Search text field
   - Role dropdown
   - “Active only” checkbox
3. Optional error banner sourced from `userManagementProvider` state.
4. User table area in an `Expanded`:
   - Loading indicator
   - Error state card with retry (`ref.invalidate(usersProvider)`)
   - Data table (`_buildUsersTable`)

### State management

This page is a `ConsumerStatefulWidget`, combining:
- Local UI state (`State`):
  - `_selectedRoleFilter`, `_showOnlyActive`
  - Sorting: `_sortColumn`, `_sortAscending`
  - Impersonation loading: `_impersonatingUserId`
  - Expandable row index: `_expandedRowIndex`
  - Search `TextEditingController` for input handling
- Riverpod providers (`WidgetRef`):
  - `usersProvider` for fetching current user list
  - `userFiltersProvider` for storing filters (search query, role, isActive)
  - `userManagementProvider` for action state/errors (create/update/toggle/delete)
  - `authProvider` for current logged-in account id (used to prevent self-delete)
  - `impersonationProvider` and `isSystemAdminProvider` for impersonation flows
  - `apiClientProvider` to construct `AdminApi` for consent record retrieval

### Filtering behavior

- Search: `_onSearchChanged` updates `userFiltersProvider.notifier.setSearchQuery(value)`.
- Role: `_onRoleFilterChanged` updates local `_selectedRoleFilter` and calls `setRole(role)`.
- Active-only: `_onActiveFilterChanged` updates local `_showOnlyActive` and calls `setIsActive(value ? true : null)`.

The page initializes the search box based on persisted filters:
- `initState` reads `userFiltersProvider` and sets `_searchController.text = filters.searchQuery`.

### Sorting behavior

Sorting is done client-side by `_sortUsers(List<User>)` and driven by:
- `_sortColumn` (`UserSortColumn`)
- `_sortAscending` (`bool`)

Sort rules:
- Name: lexicographic on `"firstName lastName"` lowercased
- Email: lexicographic on lowercased email
- Role: null roles forced to end using `'zzz'`
- Status: active users sort before inactive
- Last login:
  - nulls sort last
  - non-null values compare by `b.lastLogin!.compareTo(a.lastLogin!)` (descending by recency when ascending mode is enabled)

The custom `DataTable` receives:
- `sortColumnIndex`
- `sortAscending`
- `sortableColumns` with the actions column disabled
- `onSort` toggling:
  - if the same column is clicked: flips `_sortAscending`
  - if a different column is clicked: sets new `_sortColumn` and resets ascending to `true`

### Table rendering

- Uses `custom.DataTable` with:
  - `stickyHeader: true`
  - `minColumnWidth: 120`
  - `emptyMessage: 'No users found'`
  - expandable rows via:
    - `expandedRowIndex`
    - `onRowTap`
    - `expandedRowBuilder`

Rows are constructed using `DataTableCell` factories:
- `DataTableCell.avatar` for name + avatar initial
- `DataTableCell.text` for email
- `DataTableCell.badge` for role
- `DataTableCell.status` for active state indicator
- `DataTableCell.date` for last login
- `DataTableCell.actions` for action buttons

The footer summarizes:
- number of displayed users (after sorting, but before pagination since the page currently receives a `users` list)
- total users from API (`total`)

### Actions and dialogs

Actions are surfaced via icon buttons in the “Actions” column:
- “View as User” (`_buildViewAsUserButton`) gated by:
  - `isSystemAdminProvider == true`
  - not self
  - user is active
  - user role is not `admin`
  - shows a spinner when `_impersonatingUserId == user.accountId`
- Reset password: `_showResetPasswordDialog` delegates to `showResetPasswordModal(context, user)`
- Edit user: `_showEditUserDialog` opens `_UserFormDialog` with initial values
- Activate/deactivate: `_toggleUserStatus` calls `toggleUserStatus(accountId, !isActive)`
- Delete: `_confirmDeleteUser` opens a confirmation dialog and then calls `deleteUser(accountId)`
  - delete icon is hidden for the current logged-in user (`user.accountId != _currentAccountId`)

### Expandable content: consent status

Expanded rows (`_buildExpandedContent`) show:
- Consent status:
  - Admin users: “Admin — Consent Exempt”
  - Non-admin users: signed vs not signed (localized)
- When signed:
  - shows consent version (if present)
  - button to open consent record dialog (`_showConsentRecordDialog`)

### Consent record retrieval

Consent record fetching is done through:

- `userConsentProvider`:
  - `FutureProvider.family<UserConsentRecordResponse?, int>`
  - Constructs `AdminApi` using a Dio client from `apiClientProvider`
  - Calls `adminApi.getUserConsentRecord(userId)`

- `_ConsentRecordDialog`:
  - `ConsumerWidget` watching `userConsentProvider(user.accountId)`
  - Displays:
    - loading state
    - error text
    - not-signed state
    - or a scrollable consent record view, including:
      - signature name (if present)
      - signed at timestamp
      - language
      - consent version
      - IP address and user agent (if present)
      - document text shown in a bounded scrollable container with `SelectableText`

## Configuration

No file-local configuration is required, but this page depends on:
- Properly configured Riverpod providers:
  - `usersProvider`
  - `userFiltersProvider`
  - `userManagementProvider`
  - `authProvider`
  - `impersonationProvider`, `isSystemAdminProvider`
  - `apiClientProvider`
- Routing:
  - Uses `go_router` (`context.go(route)`) in impersonation flow
  - Requires a valid implementation of `getDashboardRouteForRole(role)`
- API client wiring:
  - `apiClientProvider` must expose a client with a configured Dio instance
  - `AdminApi` must expose `getUserConsentRecord(userId)`

## API Reference

## `UserSortColumn`

Sortable columns for the user table.

Values:
- `name`
- `email`
- `role`
- `status`
- `lastLogin`

---

## `UserManagementPage`

Admin page for listing and managing users.

### Constructor

`const UserManagementPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `UserManagementPage`.

### Public Members

#### `createState() -> ConsumerState<UserManagementPage>`

Returns:
- `_UserManagementPageState`

---

## `_UserManagementPageState`

State + behavior for `UserManagementPage`.

### State fields (selected)

- `_searchController` (`TextEditingController`): search input controller
- `_selectedRoleFilter` (`String?`): selected role filter value
- `_showOnlyActive` (`bool`): whether to filter active users only
- `_sortColumn` (`UserSortColumn`): current sort column
- `_sortAscending` (`bool`): current sort direction
- `_impersonatingUserId` (`int?`): user id currently being impersonated (loading state)
- `_expandedRowIndex` (`int?`): currently expanded row index in the table

### Derived properties

#### `_currentAccountId -> int?`

Reads `authProvider` and returns the current user’s `accountId`.

### Lifecycle

#### `initState()`

- Reads `userFiltersProvider` to initialize `_searchController.text`.

#### `dispose()`

- Disposes `_searchController`.

### Rendering

#### `build(BuildContext context) -> Widget`

Builds the page with header, filters, optional error banner, and user table area driven by `usersProvider`.

### Core methods

#### `_sortUsers(List<User> users) -> List<User>`

Returns a sorted copy of `users` according to `_sortColumn` and `_sortAscending`.

Sort semantics:
- `name`: case-insensitive full name
- `email`: case-insensitive
- `role`: nulls at end
- `status`: active first
- `lastLogin`: nulls last; non-null compares by recency

#### `_onSearchChanged(String value) -> void`

Updates persisted filter state:
- `userFiltersProvider.notifier.setSearchQuery(value)`

#### `_onRoleFilterChanged(String? role) -> void`

Updates:
- local `_selectedRoleFilter`
- persisted filter state via `setRole(role)`

#### `_onActiveFilterChanged(bool value) -> void`

Updates:
- local `_showOnlyActive`
- persisted filter state via `setIsActive(value ? true : null)`

#### `_buildUsersTable(List<User> users, int total) -> Widget`

Builds the `custom.DataTable` with:
- sorting configuration and handler
- expandable rows
- footer summary
- `DataTableCell`-based column definitions and rows

#### `_buildUserRow(User user) -> Widget`

Builds a single table `Row` using `DataTableCell` factories and action buttons:
- impersonation (system admin only)
- reset password
- edit
- activate/deactivate
- delete (not allowed on own account)

#### `_buildViewAsUserButton(User user) -> Widget`

Returns:
- `SizedBox.shrink()` if not allowed
- otherwise an `IconButton` with spinner when loading

Eligibility rules:
- system admin only
- cannot impersonate self
- cannot impersonate inactive users
- cannot impersonate admin users

#### `_handleViewAsUser(User user) -> Future<void>`

- Sets `_impersonatingUserId`
- Calls `impersonationProvider.notifier.startImpersonation(user.accountId)`
- On success:
  - navigates to role dashboard route via `context.go(route)`
  - shows success snackbar
- On failure:
  - reads `impersonationProvider.error` and shows error snackbar
- Clears `_impersonatingUserId` in `finally`

#### `_showAddUserDialog() -> void`

Opens `_UserFormDialog` in “Add” mode:
- `showPassword: true`
- calls `userManagementProvider.notifier.createUser(UserCreate(...))`

#### `_showEditUserDialog(User user) -> void`

Opens `_UserFormDialog` in “Edit” mode:
- pre-fills email/first/last/role
- calls `userManagementProvider.notifier.updateUser(accountId, UserUpdate(...))`

#### `_toggleUserStatus(User user) -> void`

Calls:
- `userManagementProvider.notifier.toggleUserStatus(user.accountId, !user.isActive)`
Shows snackbar on success.

#### `_showResetPasswordDialog(User user) -> void`

Delegates to `showResetPasswordModal(context, user)`.

#### `_buildExpandedContent(User user) -> Widget`

Expanded row content showing consent status:
- Admin users treated as consent-exempt
- If consent signed:
  - shows button to open `_ConsentRecordDialog`

#### `_confirmDeleteUser(User user) -> void`

Shows confirmation dialog, then calls:
- `userManagementProvider.notifier.deleteUser(user.accountId)`
Shows snackbar when successful.

---

## `_UserFormDialog`

Modal dialog used for both add and edit flows.

### Constructor

`const _UserFormDialog({required String title, required Future<void> Function(...) onSave, String? initialEmail, String? initialFirstName, String? initialLastName, UserRole? initialRole, bool showPassword = false})`

#### Parameters
- `title` (`String`): Dialog title text.
- `onSave` (`Future<void> Function(String email, String firstName, String lastName, UserRole? role, {String? password})`):
  Callback executed when Save is pressed.
- `initialEmail` (`String?`): Pre-filled email (edit flow).
- `initialFirstName` (`String?`): Pre-filled first name (edit flow).
- `initialLastName` (`String?`): Pre-filled last name (edit flow).
- `initialRole` (`UserRole?`): Pre-selected role (edit flow).
- `showPassword` (`bool`): When true, shows password field + generator/copy controls (add flow).

### Behavior

- In add mode (`showPassword: true`):
  - Generates a 12-character password using a restricted character set and `Random.secure()`.
  - Provides:
    - show/hide password toggle
    - regenerate password
    - copy password to clipboard
- Disables inputs while saving (`_isSaving`)
- On Save:
  - calls `onSave(...)`
  - closes dialog if still mounted

---

## `userConsentProvider`

`FutureProvider.family<UserConsentRecordResponse?, int>`

Fetches a consent record for a user by account id.

### Parameters
- `userId` (`int`): Account id of the user.

### Returns
- `Future<UserConsentRecordResponse?>`:
  - `null` when no record exists (interpreted as not signed)
  - otherwise a full consent record response

---

## `_ConsentRecordDialog`

Dialog displaying the fetched consent record.

### Constructor

`const _ConsentRecordDialog({required User user, required AppLocalizations l10n, required WidgetRef ref})`

#### Parameters
- `user` (`User`): User whose consent record is displayed.
- `l10n` (`AppLocalizations`): Localized strings used in labels.
- `ref` (`WidgetRef`): Riverpod ref used for watching providers.

### UI behavior

- Watches `userConsentProvider(user.accountId)`
- Displays:
  - Loading spinner
  - Error message
  - Not-signed message
  - Or consent record details and document text in scrollable layout

## Error Handling

This page includes multiple error-handling pathways:

- User list fetch:
  - `usersProvider` error renders a styled error card and a Retry button that invalidates `usersProvider`.

- Management actions:
  - `userManagementProvider` exposes `hasError` and `error`.
  - When present, a dismissible error banner is shown.
  - Banner close triggers `userManagementProvider.notifier.clearError()`.

- Impersonation:
  - If `startImpersonation` returns null:
    - reads `impersonationProvider.error` and shows error snackbar.
  - Loading state is tracked per-user via `_impersonatingUserId`.

- Consent record fetch:
  - `_ConsentRecordDialog` shows a formatted error message when `userConsentProvider` fails.

- Mounted checks:
  - Several async actions use `mounted` / `context.mounted` checks before UI operations (snackbars, navigation, closing dialogs).

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/users': (_) => const UserManagementPage(),
}