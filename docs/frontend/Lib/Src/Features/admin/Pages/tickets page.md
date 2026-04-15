# TicketsPage (`tickets_page.dart`)

## Overview

`TicketsPage` is an admin support management screen that currently renders a static “Support Tickets” header and a custom, sticky-header data table populated with hard-coded sample rows.

This page appears to be a placeholder/prototype for a future support ticket system UI, demonstrating:
- Consistent admin layout via `AdminScaffold`
- A scroll-contained table view (`scrollable: false` on the scaffold)
- A custom `DataTable` widget with sticky headers and many rows

## Architecture / Design

### Layout wrapper

- Uses `AdminScaffold` as the page shell:
  - `currentRoute: '/admin/tickets'` (for navigation highlighting / routing context)
  - `scrollable: false` (table likely handles its own internal scrolling)

### Page structure

The body is a `Column` with:
1. Page title: `"Support Tickets"`
   - Styled from theme `displaySmall` and overridden with:
     - `color: AppTheme.primary`
     - `fontWeight: FontWeight.bold`
2. Spacing: `SizedBox(height: 24)`
3. Table area: `Expanded(child: custom.DataTable(...))`
   - `Expanded` ensures the table consumes remaining vertical space.

### Data table design

- Uses a custom table widget imported as:
  - `frontend/src/core/widgets/data_display/data_table.dart` as `custom`
- Configuration used:
  - `stickyHeader: true`
  - `columns`: 5 columns (`ID`, `Subject`, `Status`, `Priority`, `Created`)
  - `rows`: a long list of `Row` widgets with `Text` children

Notes:
- Rows are static sample data and include duplicates.
- One row intentionally includes a very long “Priority” text value, likely to test overflow handling:
  - `"Medium MediumMediuMediumediumMediumediumMedium"`

## Configuration

No runtime configuration is required.

Dependencies expected:
- `AdminScaffold` (admin layout wrapper) from `frontend/src/features/admin/widgets/widgets.dart`
- `AppTheme` design tokens from `frontend/src/core/theme/theme.dart`
- Custom `DataTable` widget from `frontend/src/core/widgets/data_display/data_table.dart`

## API Reference

## `TicketsPage`

Admin page widget showing a support tickets table (currently static sample content).

### Constructor

`const TicketsPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `TicketsPage`.

### Public Members

#### `build(BuildContext context) -> Widget`

Builds:
- Admin scaffold wrapper (`currentRoute: '/admin/tickets'`, `scrollable: false`)
- Page title text
- An expanded `custom.DataTable` with sticky header and hard-coded rows

#### Parameters
- `context` (`BuildContext`): Used for theme access.

#### Returns
- `Widget`: Fully composed tickets page UI.

## Error Handling

This page contains no explicit error handling because:
- It does not fetch data asynchronously.
- The table rows are hard-coded sample values.

Potential runtime considerations:
- If the custom `DataTable` does not gracefully handle long unbroken strings, cells may overflow; the sample data includes an intentionally long value to surface this issue.

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/tickets': (_) => const TicketsPage(),
}