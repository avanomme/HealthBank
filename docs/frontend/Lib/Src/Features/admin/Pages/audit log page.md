# AuditLogPage (`audit_log_page.dart`)

## Overview

`AuditLogPage` is an admin UI screen for viewing and filtering system audit events. It renders:
- A header with a refresh action.
- A responsive filter panel (search + dropdown filters).
- A paginated, expandable audit log table backed by Riverpod providers.

The page is implemented as a `ConsumerStatefulWidget` to manage:
- A `TextEditingController` for search input.
- Local UI state for the currently expanded row (`_expandedRowId`).

## Architecture / Design

### State management (Riverpod)

This page relies on three core provider families:

- `auditLogsProvider`
  - Supplies audit log data as an `AsyncValue<AuditLogResponse>`.
  - Re-fetched when invalidated (e.g., via refresh button or retry).

- `auditLogFiltersProvider`
  - Holds the current filter state (`AuditLogFilters`) and exposes a notifier used to:
    - `setSearch(String)`
    - `setStatus(String?)`
    - `setHttpMethod(String?)`
    - `setAction(String?)`
    - `setResourceType(String?)`
    - `clearFilters()`
    - `previousPage()`
    - `nextPage()`

- `auditLogActionsProvider` and `auditLogResourceTypesProvider`
  - Provide dropdown option lists for actions and resource types respectively.
  - Independently invalidated on refresh to re-fetch available filter options.

### UI composition

- `AdminScaffold`
  - Used as the layout wrapper for admin pages.
  - Configured with:
    - `currentRoute: '/admin/logs'`
    - `scrollable: false` (page handles its own internal scrolling)

- Top section (header)
  - Title: `"Audit Log"` styled from `displaySmall` with `AppTheme.primary`.
  - Refresh button:
    - Invalidates `auditLogsProvider`, `auditLogActionsProvider`, and `auditLogResourceTypesProvider`.

- Filters panel (`_buildFilters`)
  - Responsive layout via `LayoutBuilder`:
    - Narrow mode (width < 800): stacked controls.
    - Wide mode: two-row layout with a clear button.
  - Controls:
    - Search `TextField` drives `filters.search` via notifier `setSearch`.
    - Status dropdown (`success`, `failure`, `denied`, or null for all).
    - HTTP method dropdown (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`, or null for all).
    - Action dropdown populated from `auditLogActionsProvider`.
    - Resource type dropdown populated from `auditLogResourceTypesProvider`.
    - Clear button (wide layout) clears search controller and calls `clearFilters()`.

- Data section (table)
  - `custom.DataTable` with:
    - Sticky header enabled.
    - Sorting disabled.
    - Empty state message.
    - Expandable rows:
      - Tapping a row toggles expansion by `auditEventId`.
      - Expanded content shows detailed fields and optional metadata block.

- Footer (pagination)
  - Displays current range and total.
  - Previous/Next page buttons call `previousPage()` / `nextPage()` on the filters notifier.

### Formatting helpers

- `_formatTimestamp(String isoTimestamp)`
  - Parses ISO string into `DateTime` and formats as `yyyy-MM-dd HH:mm:ss` using `intl`.
  - Falls back to original string if parsing fails.

- `_formatMetadata(Map<String, dynamic>)`
  - Renders metadata as `key: value` per line, monospaced.

- `_getStatusColor(String status)` / `_getMethodColor(String? method)`
  - Maps values to theme colors for pills/badges.

## Configuration

No explicit configuration is required by this widget, but the following must exist in the application:

- Riverpod setup and provider definitions:
  - `auditLogsProvider`
  - `auditLogFiltersProvider`
  - `auditLogActionsProvider`
  - `auditLogResourceTypesProvider`

- API models/types (from `frontend/src/core/api/api.dart`):
  - `AuditLogResponse`
  - `AuditEvent`
  - `AuditLogFilters`

- UI components:
  - `AdminScaffold` from `frontend/src/features/admin/widgets/widgets.dart`
  - Custom table widgets:
    - `frontend/src/core/widgets/data_display/data_table.dart` (imported as `custom`)
    - `frontend/src/core/widgets/data_display/data_table_cell.dart`

- `intl` dependency for timestamp formatting (`DateFormat`).

## API Reference

## `AuditLogPage`

Audit Log page widget for viewing and filtering audit events.

### Constructor

`const AuditLogPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `AuditLogPage`.

### State

## `_AuditLogPageState`

Internal state for `AuditLogPage`.

#### Private fields
- `_searchController` (`TextEditingController`)
  - Holds the current search input value; disposed in `dispose()`.
- `_expandedRowId` (`int?`)
  - Stores the `auditEventId` of the expanded row, or `null` for none.

### Widget lifecycle

#### `dispose() -> void`
Disposes the internal `TextEditingController`.

### Build and rendering

#### `build(BuildContext context) -> Widget`
Renders the scaffold, filters, and content table.

Dependencies read from `ref`:
- `ref.watch(auditLogsProvider)` -> `AsyncValue<AuditLogResponse>`
- `ref.watch(auditLogFiltersProvider)` -> `AuditLogFilters`

### Filter builders

#### `_buildFilters(AuditLogFilters filters) -> Widget`
Renders a responsive filters panel.
Provider dependencies:
- `ref.watch(auditLogActionsProvider)` -> `AsyncValue<List<String>>`
- `ref.watch(auditLogResourceTypesProvider)` -> `AsyncValue<List<String>>`

User interactions:
- Search `onChanged` calls `setSearch(String)` on the filters notifier.
- Dropdowns call corresponding setter methods on the filters notifier.
- Clear button clears controller and calls `clearFilters()`.

#### `_buildStatusDropdown(AuditLogFilters filters) -> Widget`
Dropdown for `filters.status` with options:
- `null` (All Statuses)
- `success`
- `failure`
- `denied`

On change: `setStatus(String?)`.

#### `_buildHttpMethodDropdown(AuditLogFilters filters) -> Widget`
Dropdown for `filters.httpMethod` with options:
- `null` (All Methods)
- `GET`, `POST`, `PUT`, `PATCH`, `DELETE`

On change: `setHttpMethod(String?)`.

#### `_buildActionDropdown(AuditLogFilters filters, List<String> actions) -> Widget`
Dropdown for `filters.action`.
Items:
- `null` (All Actions)
- `actions` list as provided by `auditLogActionsProvider`

On change: `setAction(String?)`.

#### `_buildResourceTypeDropdown(AuditLogFilters filters, List<String> types) -> Widget`
Dropdown for `filters.resourceType`.
Items:
- `null` (All Resources)
- `types` list as provided by `auditLogResourceTypesProvider`

On change: `setResourceType(String?)`.

### Error/empty states

#### `_buildErrorState(Object error) -> Widget`
Displays a styled error container with:
- Error icon
- "Failed to load audit logs"
- `error.toString()` (truncated)
- Retry button that invalidates `auditLogsProvider`

### Table and row rendering

#### `_buildAuditLogTable(AuditLogResponse response, AuditLogFilters filters) -> Widget`
Builds `custom.DataTable` with:
- Columns: Timestamp, Actor, Action, Path, Status, Method, Expand icon
- Rows: `_buildEventRow(AuditEvent)`
- Expand behavior:
  - `expandedRowIndex` computed by locating `auditEventId` in `events`
  - `onRowTap` toggles `_expandedRowId`
  - Expanded content uses `_buildExpandedDetails(AuditEvent)`
- Footer: `_buildPaginationFooter(AuditLogResponse, AuditLogFilters)`

#### `_buildEventRow(AuditEvent event) -> Widget`
Renders a single row with:
- Timestamp formatted via `_formatTimestamp`
- Actor block:
  - `actorName` (if present)
  - `actorEmail` (if present)
  - Fallback to italic `actorType` if neither present
- Action (`event.action`)
- Path (`event.path ?? '-'`)
- Status pill colored via `_getStatusColor(event.status)`
- HTTP method badge (if present) colored via `_getMethodColor(event.httpMethod)`
- Expand indicator icon toggled by `_expandedRowId`

#### `_buildExpandedDetails(AuditEvent event) -> Widget`
Expanded panel showing detailed fields in two columns, including:
- Event ID, Request ID, Resource Type/ID, HTTP status
- IP address, Actor type, Actor ID, optional error code
Optional sections:
- User agent (if present)
- Metadata (if present and non-empty), rendered via `_formatMetadata`

#### `_buildDetailRow(String label, String value, {bool wrap = false}) -> Widget`
Helper for label/value rows.
- `wrap: true` uses `CrossAxisAlignment.start` and disables ellipsis truncation.

### Pagination

#### `_buildPaginationFooter(AuditLogResponse response, AuditLogFilters filters) -> Widget`
Computes and renders:
- Current item range:
  - `startItem = filters.offset + 1`
  - `endItem = (filters.offset + response.events.length).clamp(0, response.total)`
- Total pages:
  - `totalPages = (response.total / filters.limit).ceil()`
- Page controls:
  - Previous enabled if `currentPage > 0` -> `previousPage()`
  - Next enabled if `currentPage < totalPages - 1` -> `nextPage()`

### Formatting and color helpers

#### `_formatTimestamp(String isoTimestamp) -> String`
Parameters:
- `isoTimestamp` (`String`): ISO-8601 timestamp

Returns:
- `String`: Formatted `yyyy-MM-dd HH:mm:ss` when parsable; otherwise the original input.

Errors:
- Catches all parsing/formatting errors and returns the original string.

#### `_formatMetadata(Map<String, dynamic> metadata) -> String`
Parameters:
- `metadata` (`Map<String, dynamic>`)

Returns:
- `String`: Multiline `key: value` format.

#### `_getStatusColor(String status) -> Color`
Maps `status` to theme colors:
- `success` -> `AppTheme.success`
- `failure` -> `AppTheme.error`
- `denied` -> `AppTheme.caution`
- default -> `AppTheme.textMuted`

#### `_getMethodColor(String? method) -> Color`
Maps HTTP method to theme colors:
- `GET` -> `AppTheme.info`
- `POST` -> `AppTheme.success`
- `PUT` / `PATCH` -> `AppTheme.caution`
- `DELETE` -> `AppTheme.error`
- default / null -> `AppTheme.textMuted`

## Error Handling

### Data loading failures
- Audit log retrieval errors are surfaced via `auditLogsAsync.when(error: ...)` and rendered using `_buildErrorState`.
- Retry behavior:
  - Retry button invalidates `auditLogsProvider` to trigger a re-fetch.

### Robust timestamp formatting
- Timestamp parsing/formatting errors are caught and do not crash the UI; the raw string is displayed instead.

### Dropdown option failures
- If `auditLogActionsProvider` or `auditLogResourceTypesProvider` errors, the corresponding dropdown area collapses to `SizedBox.shrink()` (no UI shown for that control).

### Potential edge cases to be aware of
- If `response.total` is `0`, `totalPages` computes to `0`, which can produce `"Page 1 of 0"` in the footer. If this can occur, consider guarding `totalPages` to be at least `1` in the provider/model layer or in the footer logic.
- If `_expandedRowId` references an event not present in the current page, `indexWhere` returns `-1`; this results in `expandedRowIndex` being `-1` rather than `null`. If `custom.DataTable` does not tolerate `-1`, consider converting `-1` to `null`.

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/logs': (_) => const AuditLogPage(),
}