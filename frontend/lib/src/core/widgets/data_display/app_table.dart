// frontend/lib/src/core/widgets/data_display/app_table.dart
//
// PURPOSE
// -------
// AppTable is a clean-slate, generic table widget designed to display any
// list of row data. It is intentionally minimal — no sorting, no pagination,
// no expansion, no API awareness. Those features will be layered on top
// incrementally as columns are designed for specific use cases.
//
// HOW DATA FLOWS IN
// -----------------
// Data enters through two props:
//
//   columns  — a list of AppTableColumn objects that describe each column:
//              its header label, the map key used to read a value from each
//              row, its relative width (flex), and an optional custom cell
//              builder.
//
//   rows     — a plain List<Map<String, dynamic>>. One map per row.
//              The map keys must match the AppTableColumn.key values.
//
// Because rows is just a list of maps, it can come from anywhere:
//   • hard-coded test data (for local preview)
//   • JSON decoded directly from an HTTP response
//   • a Riverpod FutureProvider that calls an API endpoint
//   • a FutureBuilder wrapping a Dio call
//
// WIDGET TREE (non-empty)
// -----------------------
//   Container  ←  outer border + rounded corners
//   └─ Column  ←  stacks header above rows (mainAxisSize.min = shrink-wraps)
//      ├─ _Header   ←  one Expanded(flex:N) per column, renders label text
//      └─ _Body
//         └─ Column  ←  one _Row per entry in rows
//            └─ _Row
//               └─ Row  ←  one Expanded(flex:N) per column, renders cell value
//                  └─ _Cell  ←  calls column.build(value) OR renders plain Text
//
// WIDGET TREE (empty)
// -------------------
//   Container
//   └─ Column
//      ├─ _Header
//      └─ _Empty  ←  centred message text

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

// ---------------------------------------------------------------------------
// AppTableColumn
// ---------------------------------------------------------------------------

/// Describes one column in an [AppTable].
///
/// Pass a list of these to [AppTable.columns].
///
/// [label]  — the text shown in the header row.
///
/// [key]    — the key used to look up a value in each row map.
///            Must match a key in the maps passed to [AppTable.rows].
///            If a row map does not contain this key, the cell renders '—'.
///
/// [flex]   — relative width of this column, identical to [Expanded.flex].
///            All column widths are proportional: flex 2 is twice as wide
///            as flex 1. Default is 1.
///
/// [build]  — optional custom cell renderer. Receives the raw value from the
///            row map (may be null if the key was missing). Return any Widget.
///            If omitted, the cell renders value.toString() as plain Text.
///            Use this to render badges, icons, action buttons, etc.
///
/// Example — three columns of different widths, last with a custom builder:
///
/// ```dart
/// const columns = [
///   AppTableColumn(label: 'Name',   key: 'name',   flex: 2),
///   AppTableColumn(label: 'Email',  key: 'email',  flex: 3),
///   AppTableColumn(
///     label: 'Status',
///     key: 'is_active',
///     flex: 1,
///     build: (value) => _StatusBadge(active: value == true),
///   ),
/// ];
/// ```
class AppTableColumn {
  const AppTableColumn({
    required this.label,
    required this.key,
    this.flex = 1,
    this.build,
  });

  /// Text shown in the header row for this column.
  final String label;

  /// Key used to extract the cell value from each row map.
  /// Must match a key in the maps passed to [AppTable.rows].
  final String key;

  /// Relative width of this column (same semantics as [Expanded.flex]).
  /// Defaults to 1. Use larger numbers for wider columns.
  final int flex;

  /// Optional custom cell builder. If provided, this is called instead of
  /// the default Text renderer. Receives the raw value (may be null).
  ///
  /// Example — render a green/red dot based on a boolean:
  /// ```dart
  /// build: (value) => Icon(
  ///   value == true ? Icons.check_circle : Icons.cancel,
  ///   color: value == true ? Colors.green : Colors.red,
  ///   size: 16,
  /// ),
  /// ```
  final Widget Function(dynamic value)? build;
}

// ---------------------------------------------------------------------------
// AppTable
// ---------------------------------------------------------------------------

/// A simple, generic table widget.
///
/// Displays a list of row maps in a bordered, styled table with a coloured
/// header row and alternating row backgrounds.
///
/// **Minimal usage:**
/// ```dart
/// AppTable(
///   columns: [
///     AppTableColumn(label: 'Name',  key: 'name',  flex: 2),
///     AppTableColumn(label: 'Email', key: 'email', flex: 3),
///     AppTableColumn(label: 'Role',  key: 'role',  flex: 1),
///   ],
///   rows: [
///     {'name': 'Alice', 'email': 'alice@hb.com', 'role': 'Admin'},
///     {'name': 'Bob',   'email': 'bob@hb.com',   'role': 'Participant'},
///   ],
/// )
/// ```
///
/// **Wired to an API (via FutureBuilder):**
/// ```dart
/// FutureBuilder<List<Map<String, dynamic>>>(
///   future: MyApi.fetchUsers(),
///   builder: (context, snapshot) {
///     if (!snapshot.hasData) return const CircularProgressIndicator();
///     return AppTable(columns: columns, rows: snapshot.data!);
///   },
/// )
/// ```
///
/// **Wired to a Riverpod provider:**
/// ```dart
/// ref.watch(usersProvider).when(
///   data:    (rows) => AppTable(columns: columns, rows: rows),
///   loading: () => const CircularProgressIndicator(),
///   error:   (e, _) => Text('Error: $e'),
/// )
/// ```
class AppTable extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'No data',
  });

  /// Column definitions — controls headers, key mappings, widths, and
  /// optional custom cell renderers. Order matches left-to-right column order.
  final List<AppTableColumn> columns;

  /// Row data. Each map represents one table row. Map keys must match
  /// [AppTableColumn.key] values. Extra keys in the map are ignored.
  /// If a required key is missing, the cell renders '—'.
  final List<Map<String, dynamic>> rows;

  /// Message displayed when [rows] is empty. Defaults to 'No data'.
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    // Outer container provides the border and rounded corners.
    // clipBehavior.antiAlias ensures the first and last rows don't bleed
    // outside the rounded corners.
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,

      // Column stacks header above body. mainAxisSize.min means the table
      // shrinks to fit its content rather than expanding to fill all height.
      // When you need the table to fill a parent (e.g. inside Expanded),
      // wrap AppTable in an Expanded — do not change mainAxisSize here.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header always shown, even when rows is empty.
          _Header(columns: columns),

          // Body: either the list of rows or the empty state message.
          if (rows.isEmpty)
            _Empty(message: emptyMessage)
          else
            _Body(columns: columns, rows: rows),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Header — the coloured title row
// ---------------------------------------------------------------------------

/// Renders the coloured header row.
///
/// Each column gets an [Expanded] with the column's flex value so widths
/// match the body rows exactly. The children are plain [Text] widgets
/// showing [AppTableColumn.label].
///
/// The background colour is currently a hardcoded navy. When AppTheme is
/// imported, swap `const Color(0xFF1A3C5E)` for `AppTheme.primary`.
class _Header extends StatelessWidget {
  const _Header({required this.columns});

  final List<AppTableColumn> columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Row(
        // Each column gets an Expanded(flex: col.flex) so all header
        // cells share proportional widths with their body cells.
        children: [
          for (final col in columns)
            Expanded(
              flex: col.flex,
              child: Text(
                col.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Body — the list of data rows
// ---------------------------------------------------------------------------

/// Renders all data rows as a vertical [Column].
///
/// Each row is an instance of [_Row], which alternates background colours
/// (even rows white, odd rows light grey) for readability.
///
/// mainAxisSize.min means the body shrinks to fit its rows rather than
/// expanding. The whole table shrinks to content height unless wrapped in
/// an Expanded by the caller.
class _Body extends StatelessWidget {
  const _Body({required this.columns, required this.rows});

  final List<AppTableColumn> columns;
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // enumerate rows so each _Row knows its index (for alternating colour)
        // and whether it is the last row (to skip the bottom divider).
        for (int i = 0; i < rows.length; i++)
          _Row(
            columns: columns,
            row: rows[i],
            isEven: i.isEven,        // even rows get a white background
            isLast: i == rows.length - 1, // last row has no bottom border
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _Row — one data row
// ---------------------------------------------------------------------------

/// Renders a single data row.
///
/// The row is a [Row] of [Expanded] widgets — one per column — each wrapping
/// a [_Cell]. Flex values mirror the header so columns align perfectly.
///
/// The bottom [BorderSide] is omitted on the last row to avoid a double
/// border with the outer container's bottom edge.
///
/// Alternating backgrounds:
///   even rows → white (#FFFFFF)
///   odd rows  → very light grey (#F8FAFC)
class _Row extends StatelessWidget {
  const _Row({
    required this.columns,
    required this.row,
    required this.isEven,
    required this.isLast,
  });

  final List<AppTableColumn> columns;

  /// The raw map for this row. Keys are column keys; values are cell data.
  final Map<String, dynamic> row;

  /// True when this is an even-indexed row (0, 2, 4 …) → white background.
  final bool isEven;

  /// True when this is the final row — suppresses the bottom border so there
  /// is no double line at the bottom of the table card.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // Alternating row colour for readability.
        color: isEven ? context.appColors.surface : context.appColors.rowAlt,

        // Draw a top border between rows. The last row skips this because
        // the outer container already has a bottom border.
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: context.appColors.divider),
              ),
      ),
      child: Row(
        children: [
          for (final col in columns)
            Expanded(
              // flex must match the header's flex so columns are aligned.
              flex: col.flex,
              child: _Cell(column: col, value: row[col.key]),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Cell — one cell inside a row
// ---------------------------------------------------------------------------

/// Renders a single cell.
///
/// If the column has a custom [AppTableColumn.build] function, that function
/// is called with the raw value and its result is shown. This is how you
/// add badges, icons, buttons, or any other widget to a cell.
///
/// If there is no custom builder, the value is converted to a string with
/// value.toString(). Null values render as '—'.
///
/// The [TextOverflow.ellipsis] on the default Text prevents long strings from
/// overflowing the fixed-width Expanded. If you need wrapping instead, use a
/// custom builder with softWrap: true.
class _Cell extends StatelessWidget {
  const _Cell({required this.column, required this.value});

  final AppTableColumn column;

  /// The raw value extracted from the row map using [AppTableColumn.key].
  /// May be null if the key was not present in the row map.
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    // If the column defines a custom builder, delegate to it entirely.
    // The builder receives the raw value and is responsible for all styling.
    if (column.build != null) {
      return column.build!(value);
    }

    // Default renderer: convert value to String, show '—' for null.
    final display = value == null ? '—' : value.toString();

    return Text(
      display,
      style: TextStyle(
        fontSize: 13,
        color: context.appColors.textPrimary,
      ),
      // Prevents long text from overflowing the Expanded and wrapping
      // unexpectedly. A custom builder can opt into soft wrapping.
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ---------------------------------------------------------------------------
// _Empty — shown when rows list is empty
// ---------------------------------------------------------------------------

/// Shown in place of the body when [AppTable.rows] is empty.
///
/// Renders [AppTable.emptyMessage] centred with muted styling.
/// The outer [Padding] ensures consistent vertical breathing room.
class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color: context.appColors.textMuted,
          ),
        ),
      ),
    );
  }
}
