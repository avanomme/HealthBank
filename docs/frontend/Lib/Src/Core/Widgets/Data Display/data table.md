# DataTable

## Overview

`DataTable` is a reusable, theme-aware table widget for displaying structured data with configurable styling, horizontal scrolling, optional borders/footers, sortable columns, and optional “sticky header” behavior. It also supports an alternative rendering mode for expandable rows, enabling row tap interactions and expansion content.

This implementation is distinct from Flutter’s built-in `DataTable` widget; it is a custom table component designed to integrate with `AppTheme` and the project’s `DataTableCell` primitives.

---

## Architecture / Design

### Design Goals

- Provide a consistent table UI aligned with `AppTheme`.
- Support horizontal scrolling for wide tables.
- Provide optional:
  - Sorting (internal auto-sort or externally controlled)
  - Sticky header behavior
  - Expandable rows with custom expansion content
  - Footer content
  - Empty state rendering
- Allow per-table customization for colors, text styles, divider styling, borders, and corner rounding.

### Core Rendering Modes

This widget can render in two primary modes:

1. **Standard Table Mode (default)**
   - Uses Flutter `Table` and `TableRow` for layout.
   - Column widths are based on content, with a minimum enforced by `ConstrainedColumnWidth`.
   - Rows are passed in as `List<Widget>` where each row is typically a `Row(children: [...])` or a single widget.

2. **Expandable Row Mode**
   - Activated when `expandedRowBuilder != null`.
   - Uses a `Row` + `Expanded(flex: ...)` layout instead of `Table`.
   - Supports row tap interactions and inserting expansion content below the tapped row.
   - Column sizing is driven by `DataTableCell.flex` values in `columns`.

### Sorting Model

Sorting is enabled when `enableSorting == true` and a column is considered sortable.

There are two sorting strategies:

- **Externally controlled sort**
  - Enabled when `onSort != null`.
  - Header tap triggers `onSort(columnIndex, nextAscending)`.
  - Parent controls row order and passes `sortColumnIndex` / `sortAscending` back.

- **Internal auto-sort**
  - Enabled when `enableSorting == true` and `onSort == null`.
  - Widget extracts sort keys from the tapped column and sorts `_sortedRows` internally.
  - If no sort column is provided, it defaults to column `0` (if available) so an indicator can be shown consistently.

#### Sort Key Extraction

Internal sorting tries to derive a comparable string key from the cell at `columnIndex`:

- If the cell is a `DataTableCell`, it inspects `child`:
  - `Text` → uses `Text.data`
  - `Row` → scans for the first `Text` child
  - fallback → `toStringShort()`
- If the cell is a raw `Text`, uses `Text.data`.
- Otherwise falls back to `toStringShort()`.

If all non-null extracted keys are numeric, the sort is numeric; otherwise, it is lexicographic.

### Sticky Header Behavior

When `stickyHeader == true` (and the table is not empty), the table renders a fixed header and a scrollable body.

This mode uses a shared column width synchronization strategy:

- `_syncedColumnWidths`: a shared `List<double>` storing the global max width per column.
- `_SyncedColumnWidth`: a custom `TableColumnWidth` that:
  - computes intrinsic width per column for a table,
  - writes the maximum width to the shared list,
  - returns the global max so both header and body converge.

A post-frame callback triggers a second layout pass when widths need resync so the header and body align reliably.

### Horizontal Scrolling

Non-sticky mode:
- A single horizontal `SingleChildScrollView` wraps the table with a `Scrollbar`.

Sticky mode:
- The header and body are placed inside a horizontally scrollable container.
- The body also gets a vertical `SingleChildScrollView`.
- The implementation uses `IntrinsicWidth` to ensure width calculations align across header and body.

### Theming and Styling

Defaults are derived from `AppTheme`:

- Header row background defaults to `AppTheme.primary`.
- Data row background defaults to `AppTheme.white`.
- Header text defaults to `AppTheme.heading5` with `AppTheme.textContrast`.
- Data text defaults to `AppTheme.body` with `AppTheme.textPrimary`.
- Divider defaults to `AppTheme.gray` with reduced opacity.
- Outer border defaults to `Border.all(color: AppTheme.gray)` when `showBorder == true`.

The widget merges text styles using `DefaultTextStyle.merge` so header and body styling applies consistently without requiring each cell to set its own text style.

---

## Configuration

### Required Dependencies

- Flutter `material`
- `AppTheme` (theme tokens)
- `DataTableCell` (for consistent table cells)

### Recommended Usage Pattern

- Define `columns` as a list of `DataTableCell` (or widgets that will be wrapped into `DataTableCell.custom`).
- Define `rows` as a list of `Row(children: [...])`, where each child is typically a `DataTableCell` (or a widget to be wrapped).

---

## API Reference

### Constructor

```dart
const DataTable({
  Key? key,
  Clip clipBehavior = Clip.none,
  BorderRadius? borderRadius,
  BoxBorder? border,
  Color? headingRowColor,
  Color? dataRowColor,
  TextStyle? headingTextStyle,
  Color? headingTextColor,
  TextStyle? dataTextStyle,
  Color? dataTextColor,
  double? dividerThickness,
  Color? dividerColor,
  required List<Widget> columns,
  required List<Widget> rows,
  bool enableSorting = true,
  List<bool>? sortableColumns,
  int? sortColumnIndex,
  bool sortAscending = true,
  void Function(int columnIndex, bool ascending)? onSort,
  double minColumnWidth = 100.0,
  Widget? footer,
  String? emptyMessage,
  bool showBorder = true,
  bool stickyHeader = false,
  double? maxHeight,
  Widget Function(int rowIndex)? expandedRowBuilder,
  int? expandedRowIndex,
  void Function(int rowIndex)? onRowTap,
})