# Admin Panel — Table Widget Reference

This document explains the full widget setup for every table in the admin panel, what each wrapper does, and how the custom `DataTable` works internally.

---

## Core Widget: `DataTable` (custom)

**File:** `frontend/lib/src/core/widgets/data_display/data_table.dart`
**Import alias used in pages:** `import '...data_table.dart' as custom;`

This is **not** Flutter's built-in `DataTable`. It is a fully custom widget built on top of Flutter's `Table` widget. It has three internal rendering paths depending on which props are set:

| Mode | Triggered by | Internal layout |
|------|-------------|-----------------|
| **Standard** | no sticky header, no expandable | `Scrollbar` → `SingleChildScrollView(horizontal)` → `ClipRRect` → `Table` |
| **Sticky header** | `stickyHeader: true` | `Scrollbar` → `SingleChildScrollView(horizontal)` → `IntrinsicWidth` → `Column` [header `Table` + `Expanded` → `SingleChildScrollView(vertical)` → body `Table`] |
| **Expandable** | `expandedRowBuilder != null` | Same as sticky header but uses **`Row` + `Expanded(flex:)`** instead of `Table` for column sizing — so rows can collapse/expand without disrupting table layout |

### Key props

| Prop | Type | What it does |
|------|------|-------------|
| `columns` | `List<Widget>` | Header cells — pass `DataTableCell.custom(flex: N, child: Text(...))` |
| `rows` | `List<Widget>` | Data rows — each should be a `Row` whose children are `DataTableCell` instances |
| `stickyHeader` | `bool` | Pins the header; body gets its own vertical scroll |
| `expandedRowBuilder` | `Widget Function(int)?` | If non-null, switches to flex-Row layout and inserts this widget below the tapped row |
| `expandedRowIndex` | `int?` | Which row is currently expanded (controlled by parent) |
| `onRowTap` | `void Function(int)?` | Called when a row is tapped; parent calls `setState` to update `expandedRowIndex` |
| `enableSorting` | `bool` | Whether header taps fire sort callbacks |
| `sortableColumns` | `List<bool>?` | Per-column sort toggle |
| `onSort` | `void Function(int, bool)?` | External sort handler; if null, DataTable sorts internally |
| `footer` | `Widget?` | Pagination bar placed outside the scroll area |
| `emptyMessage` | `String?` | Shown when `rows` is empty |

### Column sizing — two systems

**Standard / sticky-header mode** uses `ConstrainedColumnWidth(minWidth: 100)` — Flutter's `Table` intrinsically sizes columns to their content, with a floor of 100px.

**Expandable mode** uses `Expanded(flex: N)` on every cell — the `flex` value comes from `DataTableCell.flex`. This means column widths are proportional, not content-sized.

---

## Cell Widget: `DataTableCell`

**File:** `frontend/lib/src/core/widgets/data_display/data_table_cell.dart`

A thin `StatelessWidget` that wraps a `child` with consistent padding and alignment. Used for both column headers and row cells. Has factory constructors for common patterns:

| Factory | What it renders |
|---------|----------------|
| `DataTableCell.text(str)` | Plain `Text` with optional muted/color/weight |
| `DataTableCell.badge(str, color:)` | Colored pill `Container` with rounded corners |
| `DataTableCell.status(isActive:)` | Colored dot + "Active" / "Inactive" text |
| `DataTableCell.date(datetime)` | Formatted date string |
| `DataTableCell.avatar(name, initial)` | `CircleAvatar` + name text side by side |
| `DataTableCell.actions(...)` | `Row` of `IconButton` widgets |
| `DataTableCell.custom(child:, flex:)` | Pass-through for arbitrary widgets |

`flex` defaults to `1`. Set it on column headers and it automatically applies to body cells in expandable mode.

---

## Page-by-Page Breakdown

---

### 1. `user_management_page.dart`

**Lines:** table built in `_buildUsersTable()` ~L434

```
AdminScaffold
└─ Column
   ├─ Row                           ← page title + filter toggle button
   ├─ SizedBox(24)
   ├─ Container                     ← filter bar (search, role dropdown, status dropdown)
   ├─ SizedBox(16)
   └─ Expanded                      ← ⚠️ takes all remaining vertical space so the table fills
      └─ custom.DataTable
            stickyHeader: true      ← header fixed; body scrolls vertically
            expandedRowBuilder: ✓   ← activates flex-Row layout (not Table)
            onRowTap: ✓             ← parent setState toggles _expandedRowIndex
            expandedRowIndex: _expandedRowIndex
            enableSorting: true
            sortableColumns: [T,T,T,T,T,F]
            onSort: ✓               ← parent controls sort state
            footer: pagination bar
            columns: [
              DataTableCell.custom(flex:2, 'Name')
              DataTableCell.custom(flex:2, 'Email')
              DataTableCell.custom(flex:1, 'Role')
              DataTableCell.custom(flex:1, 'Status')
              DataTableCell.custom(flex:1, 'Last Login')
              DataTableCell.custom(flex:2, 'Actions')
            ]
            rows: [
              Row [
                DataTableCell.avatar(name, initial, flex:2)
                DataTableCell.text(email, flex:2)
                DataTableCell.badge(role, flex:1)
                DataTableCell.status(isActive, flex:1)
                DataTableCell.date(lastLogin, flex:1)
                DataTableCell.actions(flex:2) → Row of IconButtons
              ]
              ... one Row per user
            ]
```

**Why `Expanded` wraps the table:**
`AdminScaffold` is `scrollable: false`, so the page's `Column` has a fixed height. Without `Expanded`, the `DataTable` has no height constraint and Flutter throws an unbounded height error. `Expanded` says "give the table all leftover vertical space."

**Why `stickyHeader: true` AND `expandedRowBuilder`:**
These activate the most complex internal path: flex-Row layout (for expandable) combined with the sticky header scroll structure. The header row is rendered outside the vertical `SingleChildScrollView`; the body rows are inside it.

---

### 2. `audit_log_page.dart`

**Lines:** table built in `_buildAuditLogTable()` ~L365

```
AdminScaffold
└─ Column
   ├─ Row                           ← title + refresh IconButton
   ├─ SizedBox(24)
   ├─ Container                     ← filters (search TextField, 4 DropdownButtonFormField)
   ├─ SizedBox(16)
   └─ Expanded                      ← same reason as user_management: fills vertical space
      └─ custom.DataTable
            stickyHeader: true
            enableSorting: false    ← no sort arrows shown
            expandedRowBuilder: ✓   ← row tap shows detailed event fields
            expandedRowIndex: calculated from _expandedRowId
            onRowTap: ✓
            emptyMessage: 'No audit events found'
            footer: pagination bar
            columns: [
              DataTableCell.custom(flex:2, 'Timestamp')
              DataTableCell.custom(flex:2, 'Actor')
              DataTableCell.custom(flex:2, 'Action')
              DataTableCell.custom(flex:3, 'Path')
              DataTableCell.custom(flex:1, 'Status')
              DataTableCell.custom(flex:1, 'Method')
              DataTableCell.custom(flex:1, '')     ← expand chevron column
            ]
            rows: [
              Row [
                DataTableCell.custom(flex:2, timestamp Text)
                DataTableCell.custom(flex:2, Column[actor name + type chip])
                DataTableCell.custom(flex:2, action Text)
                DataTableCell.custom(flex:3, path Text monospace)
                DataTableCell.custom(flex:1, status badge Container)
                DataTableCell.custom(flex:1, method badge Container)
                DataTableCell.custom(flex:1, expand Icon)
              ]
            ]
```

**Expanded row detail** (`_buildExpandedDetails`):
Returns a `Container` with two side-by-side `Column`s (left: event ID/resource/status; right: IP/actor type/error). Optional sections for User Agent and Metadata JSON.

---

### 3. `database_viewer_page.dart`

This page has **two completely different table implementations** that swap based on a tab:

---

#### 3a. Schema View (tab: "Schema")

**Lines:** ~L345

```
Container                            ← outer card with rounded border
└─ Column
   ├─ Container                      ← card header (table icon, name, description, column count)
   ├─ Container                      ← column list header row (4 Expanded children)
   │  └─ Row
   │     ├─ Expanded(flex:2) 'Column'
   │     ├─ Expanded(flex:2) 'Type'
   │     ├─ Expanded(flex:1) 'Constraints'
   │     └─ Expanded(flex:2) 'Reference'
   ├─ Expanded
   │  └─ ListView.builder             ← one item per DB column
   │     └─ _buildColumnRow()
   │        └─ Container
   │           └─ Row
   │              ├─ Expanded(flex:2) column name + PK/FK/nullable icons
   │              ├─ Expanded(flex:2) type text (monospace font)
   │              ├─ Expanded(flex:1) Wrap of constraint Chips
   │              └─ Expanded(flex:2) foreign key reference text
   └─ Container                      ← legend row
      └─ Wrap (spacing:16)
         └─ _buildLegendItem() × 4   ← PK, FK, Nullable, Not Null icons
```

**Does NOT use `custom.DataTable`.** This is a hand-rolled `ListView.builder` with `Row` + `Expanded` column sizing. The header row is a separate `Container` above the `ListView`.

---

#### 3b. Data View (tab: "Data")

**Lines:** ~L560

```
Container                            ← outer card
└─ Column
   ├─ Container                      ← header (table name + row count)
   ├─ Expanded
   │  └─ SingleChildScrollView       ← horizontal scroll (outer)
   │     └─ SingleChildScrollView    ← vertical scroll (inner)
   │        └─ DataTable             ← ⚠️ FLUTTER NATIVE DataTable, NOT custom
   │           headingRowColor: gray
   │           columns: [ DataColumn(Text(colName)) × N ]
   │           rows: [ DataRow(cells: [DataCell(Text(value))] × N) × M ]
   └─ Container                      ← pagination footer
      └─ Row
         ├─ Text (item count)
         └─ Row (prev/next buttons + page indicator)
```

**Uses Flutter's native `DataTable`** (not the custom one). Wrapped in **two nested `SingleChildScrollView`** — outer for horizontal, inner for vertical. This means the header is **not sticky** and scrolls with the data.

**Problem:** The double `SingleChildScrollView` approach causes column widths to shrink-wrap, which can look inconsistent compared to the custom `DataTable`. There is also no sticky header.

---

### 4. `tickets_page.dart`

**Lines:** L13–L87

```
AdminScaffold(scrollable: false)
└─ Column
   ├─ Text                           ← page title
   ├─ SizedBox(24)
   └─ Expanded
      └─ custom.DataTable
            stickyHeader: true
            expandedRowBuilder: null ← uses standard Table path (not flex-Row)
            columns: [
              Text('ID')             ← ⚠️ plain Text, not DataTableCell.custom
              Text('Subject')
              Text('Status')
              Text('Priority')
              Text('Created')
            ]
            rows: [
              Row [
                Text(id)             ← ⚠️ plain Text in rows too
                Text(subject)
                Text(status)
                Text(priority)
                Text(created)
              ]
              ... 40+ hardcoded sample rows
            ]
```

**Simplest table in the codebase.** Uses plain `Text` widgets as column/row children instead of `DataTableCell` — DataTable wraps them in `DataTableCell.custom()` automatically.

No expandable rows, no sorting, no real data — all rows are hardcoded sample data.

---

## Wrappers Explained — Quick Reference

| Wrapper | Why it's there |
|---------|---------------|
| `AdminScaffold(scrollable: false)` | Makes the page non-scrollable so the table can own vertical scroll |
| `Expanded` (around DataTable) | Gives the table a bounded height inside the page `Column`; required for sticky header to work |
| `IntrinsicWidth` (inside DataTable) | Forces the horizontal scroll area to be exactly as wide as the widest row — without it, the table would stretch to fill screen width |
| `SingleChildScrollView(horizontal)` | Scrollbar that lets the table scroll sideways if columns overflow the viewport |
| `SingleChildScrollView(vertical)` | Body-only vertical scroll in sticky header mode — header stays outside this |
| `ClipRRect` | Clips the table's rounded corners cleanly (otherwise the first/last rows' backgrounds bleed past the border radius) |
| `Container(decoration: BoxDecoration(...))` | The outer border and border radius on the whole table card |
| `DefaultTextStyle.merge(...)` | Propagates the resolved text style down to all cells without each cell needing to set it explicitly |
| `_SyncedColumnWidth` | Custom `TableColumnWidth` that shares a list of widths between the header `Table` and body `Table` — ensures both tables converge to the same column widths after one layout frame |

---

## Known Issues

| Page | Issue |
|------|-------|
| `database_viewer_page.dart` data view | Uses Flutter's native `DataTable` inside double `SingleChildScrollView` — no sticky header, inconsistent column sizing, no design system styling |
| `database_viewer_page.dart` schema view | Hand-rolled `ListView` + `Row` — not using `custom.DataTable` at all; the column header is a separate widget not linked to the list |
| `tickets_page.dart` | 40+ hardcoded rows — should be driven by real data |
| `user_management_page.dart` | `build()` method is ~872 lines — the table row builder, expanded content builder, filter widgets, and pagination all inline in one file |
| `audit_log_page.dart` | `build()` method is ~690 lines — same problem |
