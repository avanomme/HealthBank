// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/data_display/app_data_table.dart
/// A typed, declarative table system built on top of [DataTable].
///
/// Usage:
/// ```dart
/// AppDataTable<User>(
///   columns: [
///     AppTableColumn.avatar(
///       header: 'Name',
///       flex: 2,
///       text: (u) => '${u.firstName} ${u.lastName}',
///       initial: (u) => u.firstName[0],
///       color: (u) => getRoleColor(u.role),
///     ),
///     AppTableColumn.text(
///       header: 'Email',
///       value: (u) => u.email,
///       muted: true,
///     ),
///     AppTableColumn.badge(
///       header: 'Role',
///       value: (u) => u.role,
///       color: (u) => getRoleColor(u.role),
///     ),
///     AppTableColumn.status(
///       header: 'Status',
///       isActive: (u) => u.isActive,
///     ),
///     AppTableColumn.actions(
///       header: 'Actions',
///       builder: (u) => [EditButton(u), DeleteButton(u)],
///     ),
///   ],
///   items: users,
///   onSort: (index, ascending) { ... },
///   expandedBuilder: (user) => UserDetails(user),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart'
    as custom;
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';

/// Typed column definition for [AppDataTable].
///
/// Each factory constructor maps to a [DataTableCell] type and takes
/// builder functions that extract values from the row data type [T].
/// This eliminates manual cell construction and enables typed sorting.
class AppTableColumn<T> {
  /// Column header text displayed in the heading row.
  final String header;

  /// Flex weight for column width (default: 1).
  final int flex;

  /// Whether this column supports sorting (default: true).
  final bool sortable;

  /// Header text alignment.
  final CellAlignment headerAlignment;

  /// Builds the cell widget for a given data item.
  final Widget Function(T item) cellBuilder;

  /// Extracts a sortable key from the data item.
  /// When provided, enables typed sorting (e.g. sort by DateTime, not string).
  final Comparable Function(T item)? sortKey;

  const AppTableColumn({
    required this.header,
    this.flex = 1,
    this.sortable = true,
    this.headerAlignment = CellAlignment.start,
    required this.cellBuilder,
    this.sortKey,
  });

  // ---------------------------------------------------------------------------
  // Factory constructors — one per DataTableCell type
  // ---------------------------------------------------------------------------

  /// Plain text column. Sorts alphabetically by default.
  factory AppTableColumn.text({
    required String header,
    required String Function(T) value,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
    bool muted = false,
    Color? textColor,
    FontWeight? fontWeight,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool softWrap = false,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => value(item).toLowerCase(),
      cellBuilder: (item) => DataTableCell.text(
        value(item),
        flex: flex,
        muted: muted,
        textColor: textColor,
        fontWeight: fontWeight,
        alignment: alignment,
        overflow: overflow,
        softWrap: softWrap,
      ),
    );
  }

  /// Colored badge/chip column. Sorts by badge text.
  factory AppTableColumn.badge({
    required String header,
    required String Function(T) value,
    required Color Function(T) color,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => value(item).toLowerCase(),
      cellBuilder: (item) => DataTableCell.badge(
        value(item),
        flex: flex,
        color: color(item),
        alignment: alignment,
      ),
    );
  }

  /// Active/inactive status dot column. Sorts active before inactive.
  factory AppTableColumn.status({
    required String header,
    required bool Function(T) isActive,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
    String? activeText,
    String? inactiveText,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => isActive(item) ? 1 : 0,
      cellBuilder: (item) => DataTableCell.status(
        isActive: isActive(item),
        flex: flex,
        alignment: alignment,
        activeText: activeText,
        inactiveText: inactiveText,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
    );
  }

  /// Date column with relative or absolute formatting.
  /// Sorts by timestamp (null dates sort last).
  factory AppTableColumn.date({
    required String header,
    required DateTime? Function(T) value,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
    String nullText = 'Never',
    bool relative = true,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => value(item)?.millisecondsSinceEpoch ?? 0,
      cellBuilder: (item) => DataTableCell.date(
        value(item),
        flex: flex,
        alignment: alignment,
        nullText: nullText,
        relative: relative,
      ),
    );
  }

  /// Avatar with text column. Sorts alphabetically by text.
  factory AppTableColumn.avatar({
    required String header,
    required String Function(T) text,
    required String Function(T) initial,
    required Color Function(T) color,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => text(item).toLowerCase(),
      cellBuilder: (item) => DataTableCell.avatar(
        text: text(item),
        initial: initial(item),
        color: color(item),
        flex: flex,
        alignment: alignment,
      ),
    );
  }

  /// Action buttons column. Not sortable by default.
  factory AppTableColumn.actions({
    required String header,
    required List<Widget> Function(T) builder,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: false,
      headerAlignment: alignment,
      cellBuilder: (item) => DataTableCell.actions(
        flex: flex,
        alignment: alignment,
        children: builder(item),
      ),
    );
  }

  /// Toggle/switch column. Sorts by boolean value.
  factory AppTableColumn.toggle({
    required String header,
    required bool Function(T) value,
    required void Function(T item, bool newValue)? onChanged,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
    Color? activeColor,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => value(item) ? 1 : 0,
      cellBuilder: (item) => DataTableCell.toggle(
        value: value(item),
        onChanged: onChanged != null ? (v) => onChanged(item, v) : null,
        flex: flex,
        alignment: alignment,
        activeColor: activeColor,
      ),
    );
  }

  /// Icon column. Not sortable by default.
  factory AppTableColumn.icon({
    required String header,
    required IconData Function(T) icon,
    int flex = 1,
    bool sortable = false,
    CellAlignment alignment = CellAlignment.center,
    Color? Function(T)? color,
    double size = 20,
    String? Function(T)? tooltip,
    void Function(T)? onTap,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      cellBuilder: (item) => DataTableCell.icon(
        icon: icon(item),
        flex: flex,
        alignment: alignment,
        color: color?.call(item),
        size: size,
        tooltip: tooltip?.call(item),
        onTap: onTap != null ? () => onTap(item) : null,
      ),
    );
  }

  /// Monospace text column for code, paths, or IDs. Sorts alphabetically.
  factory AppTableColumn.monospace({
    required String header,
    required String Function(T) value,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
    Color? textColor,
    double fontSize = 12,
    bool softWrap = false,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => value(item).toLowerCase(),
      cellBuilder: (item) => DataTableCell.monospace(
        value(item),
        flex: flex,
        alignment: alignment,
        textColor: textColor,
        fontSize: fontSize,
        softWrap: softWrap,
      ),
    );
  }

  /// Stacked two-line text column. Sorts by primary text.
  factory AppTableColumn.multiLine({
    required String header,
    required String Function(T) primary,
    String? Function(T)? secondary,
    int flex = 1,
    bool sortable = true,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: (item) => primary(item).toLowerCase(),
      cellBuilder: (item) => DataTableCell.multiLine(
        primary: primary(item),
        secondary: secondary?.call(item),
        flex: flex,
        alignment: alignment,
      ),
    );
  }

  /// Fully custom column. Provide your own cell builder and optional sort key.
  factory AppTableColumn.custom({
    required String header,
    required Widget Function(T item) builder,
    int flex = 1,
    bool sortable = false,
    CellAlignment alignment = CellAlignment.start,
    Comparable Function(T)? sortKey,
  }) {
    return AppTableColumn<T>(
      header: header,
      flex: flex,
      sortable: sortable,
      headerAlignment: alignment,
      sortKey: sortKey,
      cellBuilder: (item) => DataTableCell.custom(
        flex: flex,
        alignment: alignment,
        child: builder(item),
      ),
    );
  }
}

/// A typed, declarative data table widget.
///
/// Wraps [custom.DataTable] with a clean API based on [AppTableColumn]
/// definitions and a typed item list. Eliminates manual Row/Cell construction.
///
/// Features inherited from [custom.DataTable]:
/// - Sticky header (frozen top row)
/// - Column sorting with typed sort keys
/// - Expandable rows
/// - Horizontal and vertical scrolling
/// - Alternating row colors
/// - Footer widget
/// - Empty state message
///
/// See [AppTableColumn] factories for all available column types.
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.items,
    this.stickyHeader = true,
    this.enableSorting = true,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.expandedIndex,
    this.onRowTap,
    this.expandedBuilder,
    this.footer,
    this.emptyMessage,
    this.minColumnWidth = 100.0,
    this.headingRowColor,
    this.headingTextColor,
    this.headingTextStyle,
    this.dataRowColor,
    this.dataTextColor,
    this.dataTextStyle,
    this.showBorder = true,
    this.borderRadius,
    this.maxHeight,
    this.dividerColor,
    this.dividerThickness,
  });

  /// Column definitions that describe headers, cell rendering, and sort keys.
  final List<AppTableColumn<T>> columns;

  /// The data items to display as rows.
  final List<T> items;

  /// Whether the header row stays fixed during vertical scroll (default: true).
  final bool stickyHeader;

  /// Whether column headers are tappable for sorting (default: true).
  final bool enableSorting;

  /// Index of the currently sorted column.
  final int? sortColumnIndex;

  /// Current sort direction (default: ascending).
  final bool sortAscending;

  /// Called when a sortable header is tapped.
  /// If null, sorting is handled internally using [AppTableColumn.sortKey].
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Index of the currently expanded row (null = none expanded).
  final int? expandedIndex;

  /// Called when a data row is tapped (used to toggle expansion).
  final void Function(int index)? onRowTap;

  /// Builder for expanded content below a row.
  /// Receives the typed item, not a raw index.
  final Widget Function(T item)? expandedBuilder;

  /// Optional footer widget displayed below the table.
  final Widget? footer;

  /// Message shown when [items] is empty (default: 'No data').
  final String? emptyMessage;

  /// Minimum width for each column (default: 100.0).
  final double minColumnWidth;

  /// Background color for the heading row (default: AppTheme.primary).
  final Color? headingRowColor;

  /// Text color for heading cells (default: AppTheme.textContrast).
  final Color? headingTextColor;

  /// Text style for heading cells (default: AppTheme.heading5).
  final TextStyle? headingTextStyle;

  /// Background color for data rows (default: context.appColors.surface).
  final Color? dataRowColor;

  /// Text color for data cells (default: context.appColors.textPrimary).
  final Color? dataTextColor;

  /// Text style for data cells (default: AppTheme.body).
  final TextStyle? dataTextStyle;

  /// Whether to show the outer border (default: true).
  final bool showBorder;

  /// Border radius for table corners.
  final BorderRadius? borderRadius;

  /// Maximum height for the scrollable body when [stickyHeader] is true.
  final double? maxHeight;

  /// Color of horizontal row dividers.
  final Color? dividerColor;

  /// Thickness of horizontal row dividers.
  final double? dividerThickness;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  late List<T> _sortedItems;
  int? _internalSortColumnIndex;
  bool _internalSortAscending = true;

  @override
  void initState() {
    super.initState();
    _internalSortColumnIndex = widget.sortColumnIndex;
    _internalSortAscending = widget.sortAscending;
    _sortedItems = _applySorting(widget.items);
  }

  @override
  void didUpdateWidget(covariant AppDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items) ||
        oldWidget.sortColumnIndex != widget.sortColumnIndex ||
        oldWidget.sortAscending != widget.sortAscending) {
      if (widget.onSort != null) {
        _internalSortColumnIndex = widget.sortColumnIndex;
        _internalSortAscending = widget.sortAscending;
      }
      _sortedItems = _applySorting(widget.items);
    }
  }

  List<T> _applySorting(List<T> items) {
    final colIndex = widget.onSort != null
        ? widget.sortColumnIndex
        : _internalSortColumnIndex;
    if (colIndex == null || colIndex >= widget.columns.length) {
      return List<T>.from(items);
    }

    final column = widget.columns[colIndex];
    final sortKey = column.sortKey;
    if (sortKey == null) return List<T>.from(items);

    final ascending =
        widget.onSort != null ? widget.sortAscending : _internalSortAscending;

    final sorted = List<T>.from(items);
    sorted.sort((a, b) {
      final ka = sortKey(a);
      final kb = sortKey(b);
      return ascending ? ka.compareTo(kb) : kb.compareTo(ka);
    });
    return sorted;
  }

  void _handleInternalSort(int columnIndex, bool ascending) {
    setState(() {
      _internalSortColumnIndex = columnIndex;
      _internalSortAscending = ascending;
      _sortedItems = _applySorting(widget.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    // When the parent controls sorting, pass rows directly (parent sorts).
    // When internal sorting, use our pre-sorted list.
    final displayItems =
        widget.onSort != null ? widget.items : _sortedItems;

    return custom.DataTable(
      stickyHeader: widget.stickyHeader,
      enableSorting: widget.enableSorting,
      sortColumnIndex: widget.onSort != null
          ? widget.sortColumnIndex
          : _internalSortColumnIndex,
      sortAscending: widget.onSort != null
          ? widget.sortAscending
          : _internalSortAscending,
      sortableColumns: widget.columns.map((c) => c.sortable).toList(),
      onSort: widget.onSort ?? (widget.enableSorting ? _handleInternalSort : null),
      minColumnWidth: widget.minColumnWidth,
      emptyMessage: widget.emptyMessage,
      showBorder: widget.showBorder,
      headingRowColor: widget.headingRowColor,
      headingTextColor: widget.headingTextColor,
      headingTextStyle: widget.headingTextStyle,
      dataRowColor: widget.dataRowColor,
      dataTextColor: widget.dataTextColor,
      dataTextStyle: widget.dataTextStyle,
      borderRadius: widget.borderRadius,
      maxHeight: widget.maxHeight,
      dividerColor: widget.dividerColor,
      dividerThickness: widget.dividerThickness,
      expandedRowIndex: widget.expandedIndex,
      onRowTap: widget.onRowTap,
      expandedRowBuilder: widget.expandedBuilder != null
          ? (index) => widget.expandedBuilder!(displayItems[index])
          : null,
      footer: widget.footer,
      columns: widget.columns
          .map((col) => DataTableCell.custom(
                flex: col.flex,
                alignment: col.headerAlignment,
                child: Text(col.header),
              ))
          .toList(),
      rows: displayItems
          .map((item) => Row(
                children: widget.columns
                    .map((col) => col.cellBuilder(item))
                    .toList(),
              ))
          .toList(),
    );
  }
}
