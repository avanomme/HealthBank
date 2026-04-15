# DatabaseViewerPage (`database_viewer_page.dart`)

## Overview

`DatabaseViewerPage` is an admin-only page that allows viewing database structure and data through an API-backed UI.

Features provided by this page:
- Lists all database tables with row counts.
- Allows selecting a table from a dropdown.
- Toggles between:
  - **Schema view**: columns, types, and constraints (PK/FK/NN) with foreign key references.
  - **Data view**: paginated preview of table rows (intended to exclude sensitive fields on the API side).
- Refreshes the table list and (if selected) the selected table’s detail data.

The page is implemented as a `ConsumerStatefulWidget` to integrate Riverpod providers and manage view interactions.

## Architecture / Design

### State management (Riverpod)

This page uses two main provider streams:

- `databaseTablesProvider`
  - Provides `AsyncValue<List<TableSchema>>` (the list of tables available for viewing).

- `databaseViewerProvider`
  - Holds the UI state for this page (selected table, schema/data toggle, pagination settings).
  - Exposes a notifier used to:
    - `selectTable(String tableName)`
    - `setShowSchema(bool showSchema)`
    - `previousPage()`
    - `nextPage()`
  - Includes pagination fields used in data fetching:
    - `pageSize`
    - `offset`
    - `currentPage`
    - `selectedTable`
    - `showSchema`

In data view, the page also reads:

- `tableDetailProvider(TableDetailParams(...))`
  - Provides `AsyncValue<TableDetailResponse>` for a selected table, with `limit` and `offset` derived from viewer state.

### UI composition

- `AdminScaffold`
  - Wraps page content in a consistent admin layout.
  - Configured with `currentRoute: '/admin/database'`.

- Page content flow
  1. **Loading state**: spinner while table list loads.
  2. **Error state**: centered error UI with retry.
  3. **Content state**:
     - Header (title + table count + refresh)
     - Controls (table selector + schema/data toggle)
     - Main panel:
       - Schema view for selected table
       - Data view for selected table (paginated)

### Auto-selection behavior

If no table is selected and `tables` is non-empty, the first table is automatically selected using a `postFrameCallback`:

- This avoids mutating provider state during build.
- Selection is performed via `databaseViewerProvider.notifier.selectTable(tables.first.name)`.

### Responsive layout

Two areas adapt based on available width:

- Header (`_buildHeader`)
  - Narrow (< 400px): title block stacked above refresh button.
  - Wide: title on the left, refresh on the right.

- Controls (`_buildControls`)
  - Narrow (< 500px): dropdown stacked above centered toggle buttons.
  - Wide: dropdown and toggle buttons shown in a single row.

### Main panel sizing

Within `_buildContent`, a `LayoutBuilder` computes a `contentHeight` from viewport height and clamps the content area between 300 and 800 pixels to keep the schema/data panel usable across screen sizes.

### Schema view design

Schema view (`_buildSchemaView`) is a structured card:
- Header bar with table name, description, and column count.
- Column header row: Column / Type / Constraints / Reference
- Scrollable list of columns via `ListView.builder`
- Legend describing icons and constraint abbreviations:
  - Primary Key (key icon)
  - Foreign Key (link icon)
  - Nullable / Not Null indicators (legend labels; constraints chips emphasize PK/FK/NN)

### Data view design

Data view (`_buildDataView`) fetches table data from `tableDetailProvider` using:
- `tableName`
- `limit: viewerState.pageSize`
- `offset: viewerState.offset`

The resulting table display:
- Shows a header with table name and total rows.
- Uses a horizontally scrollable `DataTable` to accommodate many columns.
- Provides a pagination footer with previous/next controls wired to the viewer state notifier.

Cell values are formatted/truncated by `_formatCellValue`.

## Configuration

No direct configuration is required by this widget, but it depends on the following project components being present and correctly wired:

- Riverpod providers:
  - `databaseTablesProvider`
  - `databaseViewerProvider`
  - `tableDetailProvider` and `TableDetailParams`

- API/types (from `frontend/src/core/api/api.dart`):
  - `TableSchema`
  - `ColumnInfo`
  - `TableDetailParams`
  - `TableDetailResponse`
  - `DatabaseViewerState` (if declared in API layer; otherwise from state layer)

- Theme tokens:
  - `AppTheme` colors from `frontend/src/core/theme/theme.dart`

- Admin layout widget:
  - `AdminScaffold` from `frontend/src/features/admin/widgets/widgets.dart`

## API Reference

## `DatabaseViewerPage`

Admin page widget for viewing database schema and table data.

### Constructor

`const DatabaseViewerPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `DatabaseViewerPage`.

### State

## `_DatabaseViewerPageState`

Internal state for `DatabaseViewerPage`.

### Build and rendering

#### `build(BuildContext context) -> Widget`

Reads providers:
- `ref.watch(databaseTablesProvider)` -> `AsyncValue<List<TableSchema>>`
- `ref.watch(databaseViewerProvider)` -> `DatabaseViewerState`

Build behavior:
- Wraps content in `AdminScaffold(currentRoute: '/admin/database')`.
- Branches rendering based on `tablesAsync.when(...)`:
  - `loading` -> spinner
  - `error` -> `_buildErrorState(error)`
  - `data` -> `_buildContent(tables, viewerState)`

### Error state

#### `_buildErrorState(Object error) -> Widget`

Displays an error UI and a retry button.

User interaction:
- Retry button invalidates `databaseTablesProvider` to re-fetch the tables list.

### Main content

#### `_buildContent(List<TableSchema> tables, DatabaseViewerState viewerState) -> Widget`

Responsibilities:
- Ensures a selected table exists (auto-selects first table if needed).
- Resolves the selected table schema object from `tables`.
- Renders header, controls, and either schema view or data view for the selected table.

Auto-selection:
- Uses `WidgetsBinding.instance.addPostFrameCallback` to call:
  - `ref.read(databaseViewerProvider.notifier).selectTable(tables.first.name)`

Selected table resolution:
- Attempts to match `viewerState.selectedTable` to a table in `tables`.

### Header and controls

#### `_buildHeader(int tableCount) -> Widget`

Renders:
- Title: "Database Viewer"
- Subtitle: "`<tableCount>` tables in database"
- Refresh button:
  - Invalidates `databaseTablesProvider`
  - If a table is selected, also invalidates `tableDetailProvider(TableDetailParams(tableName: selectedTable))`

Responsive behavior:
- Narrow (< 400px): stacks title and refresh vertically.
- Wide: title left, refresh right.

#### `_buildControls(List<TableSchema> tables, DatabaseViewerState viewerState) -> Widget`

Renders a styled container containing:
- Table selector dropdown:
  - `initialValue: viewerState.selectedTable`
  - `items`: each table shows name + "`<rowCount>` rows"
  - `onChanged`: calls `selectTable(value)` on notifier
- View toggle (`ToggleButtons`):
  - Selected state: `[viewerState.showSchema, !viewerState.showSchema]`
  - `onPressed`: calls `setShowSchema(index == 0)`

Responsive behavior:
- Narrow (< 500px): dropdown above centered toggle.
- Wide: dropdown and toggle in a row.

### Schema view

#### `_buildSchemaView(TableSchema table) -> Widget`

Renders a schema card with:
- Header strip with table name, description, and column count.
- Column header row.
- Scrollable column list rendered via `_buildColumnRow(ColumnInfo)`.
- Legend built from `_buildLegendItem(...)`.

#### `_buildColumnRow(ColumnInfo column) -> Widget`

Displays a schema row including:
- Column name
  - Shows a key icon if `column.isPrimaryKey`
  - Shows a link icon if `column.isForeignKey`
  - Uses heavier font for primary key columns
- Type (monospace)
- Constraints chips:
  - `PK` if primary key
  - `FK` if foreign key
  - `NN` if not nullable (`!column.isNullable`)
- Reference string:
  - `column.foreignKeyRef ?? '-'`

#### `_buildConstraintChip(String label, Color color) -> Widget`

Builds a small pill-style chip for constraint abbreviations (PK/FK/NN).

Parameters:
- `label` (`String`): Short constraint label.
- `color` (`Color`): Themed color used for border/fill/text.

Returns:
- `Widget`: A styled container with the label.

#### `_buildLegendItem(IconData icon, String label, Color color) -> Widget`

Builds an icon + label legend row.

Parameters:
- `icon` (`IconData`)
- `label` (`String`)
- `color` (`Color`)

Returns:
- `Widget`: Small row widget describing schema markers.

### Data view

#### `_buildDataView(DatabaseViewerState viewerState) -> Widget`

Behavior:
- If no table is selected: displays "Select a table".
- Otherwise watches `tableDetailProvider(TableDetailParams(...))` with:
  - `tableName: viewerState.selectedTable!`
  - `limit: viewerState.pageSize`
  - `offset: viewerState.offset`

Renders based on provider state:
- `loading` -> spinner
- `error` -> centered error UI + retry button invalidating `tableDetailProvider(TableDetailParams(tableName: selectedTable))`
- `data` -> `_buildDataTable(detail, viewerState)`

#### `_buildDataTable(TableDetailResponse detail, DatabaseViewerState viewerState) -> Widget`

Expected `detail.data` shape (inferred from usage):
- `name` (`String`)
- `total` (`int`)
- `columns` (`List<String>`)
- `rows` (`List<Map<String, dynamic>>` or equivalent map-like access by column key)

Behavior:
- If `rows` is empty: shows a "No data in table" empty state.
- Otherwise:
  - Computes pagination:
    - `totalPages = (data.total / viewerState.pageSize).ceil()`
    - `currentPage = viewerState.currentPage`
  - Renders:
    - Header strip with `<table> Data` and total rows.
    - Horizontally scrollable `DataTable`:
      - Columns built from `data.columns`
      - Cells built by reading `row[col]` and formatting via `_formatCellValue`
    - Pagination footer:
      - Previous button -> `databaseViewerProvider.notifier.previousPage()`
      - Next button -> `databaseViewerProvider.notifier.nextPage()`

#### `_formatCellValue(dynamic value) -> String`

Formats a cell value for display.

Rules:
- If `value == null`: returns `"NULL"`.
- Converts to string.
- If string length > 50: truncates to 47 chars + `"..."`.

Parameters:
- `value` (`dynamic`): Cell value.

Returns:
- `String`: Display-friendly representation.

## Error Handling

### Table list load failures
- Failures from `databaseTablesProvider` render `_buildErrorState`.
- Retry:
  - Retry button invalidates `databaseTablesProvider`.

### Table detail load failures
- Failures from `tableDetailProvider` render a centered error UI.
- Retry:
  - Retry button invalidates `tableDetailProvider(TableDetailParams(tableName: selectedTable))`.

### UI robustness considerations
- Auto-selection uses a `postFrameCallback` to avoid provider writes during build.
- Data table is wrapped in horizontal scroll to prevent overflow on wide column sets.

Potential edge case:
- If `data.total` is `0`, `totalPages` computes to `0`, which may display `"Page 1 of 0"`. If this can occur, consider guarding `totalPages` to be at least `1` in state logic or UI.

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/database': (_) => const DatabaseViewerPage(),
}