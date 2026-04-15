import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';

class DataTable extends StatefulWidget {
  const DataTable({
    super.key,
    this.clipBehavior = Clip.none,
    this.borderRadius,
    this.border,
    this.headingRowColor,
    this.dataRowColor,
    this.headingTextStyle,
    this.headingTextColor,
    this.dataTextStyle,
    this.dataTextColor,
    this.dividerThickness,
    this.dividerColor,
    required this.columns,
    required this.rows,
    this.enableSorting = true,
    this.sortableColumns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.minColumnWidth = 100.0,
    this.footer,
    this.emptyMessage,
    this.showBorder = true,
    this.stickyHeader = false,
    this.maxHeight,
    this.expandedRowBuilder,
    this.expandedRowIndex,
    this.onRowTap,
  });

  final Clip clipBehavior;

  /// Optional border radius for rounding table corners
  final BorderRadius? borderRadius;

  /// Optional border for the outer container
  final BoxBorder? border;

  /// Whether to show outer border (default: true)
  final bool showBorder;

  final Color? headingRowColor;
  final Color? dataRowColor;
  final TextStyle? headingTextStyle;
  final Color? headingTextColor;
  final TextStyle? dataTextStyle;
  final Color? dataTextColor;

  /// Thickness of horizontal row dividers
  final double? dividerThickness;

  /// Color of horizontal row dividers
  final Color? dividerColor;

  final List<Widget> columns;
  final List<Widget> rows;

  /// Whether header taps should trigger sort callbacks (default: true).
  final bool enableSorting;

  /// Optional per-column override for whether a column is sortable.
  /// If null, all columns are considered sortable (subject to [enableSorting]).
  final List<bool>? sortableColumns;

  /// Currently sorted column index (if any).
  final int? sortColumnIndex;

  /// Current sort direction. Interpreted by the parent; this widget just passes it back when toggling.
  final bool sortAscending;

  /// Callback when a sortable header is tapped.
  /// Provides the column index and the next sort direction.
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Minimum width for each column (default: 100.0)
  final double minColumnWidth;

  /// Optional footer widget displayed below the table
  final Widget? footer;

  /// Message to display when rows is empty (default: 'No data')
  final String? emptyMessage;

  /// Whether the header should remain fixed while scrolling vertically.
  /// When true, the header stays at the top and only the body scrolls.
  /// Requires [maxHeight] to be set for the vertical scroll area.
  final bool stickyHeader;

  /// Maximum height for the table body when [stickyHeader] is true.
  /// If null and stickyHeader is true, the table will expand to fill available space.
  final double? maxHeight;

  /// Builder for the expanded content shown below a row when it is expanded.
  /// If non-null, the table uses a Row/flex-based rendering path instead of Table.
  final Widget Function(int rowIndex)? expandedRowBuilder;

  /// Index of the currently expanded row (null = none expanded).
  final int? expandedRowIndex;

  /// Callback when a data row is tapped (used to toggle expansion).
  final void Function(int rowIndex)? onRowTap;

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> {
  late List<Widget> _sortedRows;
  int? _internalSortColumnIndex;
  bool _internalSortAscending = true;

  final ScrollController _horizontalController = ScrollController();
  // For sticky header mode: separate controllers that stay in sync
  final ScrollController _headerHorizontalController = ScrollController();
  final ScrollController _bodyHorizontalController = ScrollController();
  bool _isSyncingScroll = false;

  // For sticky header column width synchronization between header & body Tables.
  // Both Tables write into this shared list so the wider cell wins for each column.
  List<double> _syncedColumnWidths = [];
  bool _needsWidthResync = true;

  @override
  void initState() {
    super.initState();
    _sortedRows = List<Widget>.from(widget.rows);
    _internalSortColumnIndex = widget.sortColumnIndex;
    _internalSortAscending = widget.sortAscending;

    // If the parent hasn't specified a sort column and we're handling sort
    // internally, default to the first column so we can show a single arrow.
    if (widget.enableSorting && widget.onSort == null) {
      _internalSortColumnIndex ??= widget.columns.isNotEmpty ? 0 : null;
      if (_internalSortColumnIndex != null) {
        _applyInternalSort(_internalSortColumnIndex!, _internalSortAscending);
      }
    }

    // Set up linked scroll for sticky header mode
    if (widget.stickyHeader) {
      _headerHorizontalController.addListener(_onHeaderScroll);
      _bodyHorizontalController.addListener(_onBodyScroll);
    }
  }

  void _onHeaderScroll() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_bodyHorizontalController.hasClients) {
      _bodyHorizontalController.jumpTo(_headerHorizontalController.offset);
    }
    _isSyncingScroll = false;
  }

  void _onBodyScroll() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_headerHorizontalController.hasClients) {
      _headerHorizontalController.jumpTo(_bodyHorizontalController.offset);
    }
    _isSyncingScroll = false;
  }

  @override
  void didUpdateWidget(covariant DataTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent provided new rows, refresh the internal list.
    if (!identical(oldWidget.rows, widget.rows)) {
      _sortedRows = List<Widget>.from(widget.rows);
      _needsWidthResync = true;

      // Re-apply internal sort if we're managing it.
      if (widget.enableSorting &&
          widget.onSort == null &&
          _internalSortColumnIndex != null) {
        _applyInternalSort(_internalSortColumnIndex!, _internalSortAscending);
      }
    }

    if (!identical(oldWidget.columns, widget.columns)) {
      _needsWidthResync = true;
    }

    // If the parent controls sorting (onSort != null), mirror its state.
    if (widget.onSort != null) {
      _internalSortColumnIndex = widget.sortColumnIndex;
      _internalSortAscending = widget.sortAscending;
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _headerHorizontalController.removeListener(_onHeaderScroll);
    _bodyHorizontalController.removeListener(_onBodyScroll);
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    super.dispose();
  }

  /// Wraps [child] with a Listener that converts Shift+scroll into horizontal
  /// scroll on the given [controller].
  Widget _withShiftScroll({
    required ScrollController controller,
    required Widget child,
  }) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent &&
              HardwareKeyboard.instance.logicalKeysPressed.any(
                (key) =>
                    key == LogicalKeyboardKey.shiftLeft ||
                    key == LogicalKeyboardKey.shiftRight,
              )) {
            final offset = controller.offset + event.scrollDelta.dy;
            controller.jumpTo(
              offset.clamp(0.0, controller.position.maxScrollExtent),
            );
          }
        },
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve theme + config
    final resolvedHeadingRowColor = widget.headingRowColor ?? AppTheme.primary;
    final colors = context.appColors;
    final resolvedDataRowColor = widget.dataRowColor ?? colors.surface;
    final resolvedHeadingTextStyle =
        widget.headingTextStyle ?? AppTheme.heading5;
    final resolvedDataTextStyle = widget.dataTextStyle ?? AppTheme.body;
    final resolvedHeadingTextColor =
        widget.headingTextColor ?? AppTheme.textContrast;
    final resolvedDataTextColor =
        widget.dataTextColor ?? colors.textPrimary;

    final resolvedDividerThickness = widget.dividerThickness ?? 1.0;
    final resolvedDividerColor =
        widget.dividerColor ?? colors.divider.withValues(alpha: 0.9);

    final resolvedBorderRadius =
        widget.borderRadius ?? const BorderRadius.all(Radius.circular(8));

    // Build column widths map - each column sizes to content with minimum
    final Map<int, TableColumnWidth> columnWidths = {};
    for (int i = 0; i < widget.columns.length; i++) {
      columnWidths[i] = ConstrainedColumnWidth(minWidth: widget.minColumnWidth);
    }

    // Build header cells
    final headerCells = List.generate(widget.columns.length, (index) {
      final col = widget.columns[index];
      final cell = col is DataTableCell
          ? col
          : DataTableCell.custom(child: col);

      final isSortable =
          widget.enableSorting &&
          (widget.sortableColumns == null ||
              (index < widget.sortableColumns!.length &&
                  widget.sortableColumns![index]));

      // Build header content with sort indicator if applicable.
      Widget headerChild = _buildSortableHeader(
        cell: cell,
        index: index,
        isSortable: isSortable,
      );

      if (isSortable) {
        final semanticLabel =
            _extractSortKey(Row(children: [cell]), 0) ?? 'Column ${index + 1}';
        final isCurrent = widget.onSort != null
            ? widget.sortColumnIndex == index
            : _internalSortColumnIndex == index;
        final ascending = widget.onSort != null
            ? widget.sortAscending
            : _internalSortAscending;

        headerChild = MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Semantics(
            button: true,
            label: 'Sort by $semanticLabel',
            value: isCurrent
                ? (ascending ? 'Sorted ascending' : 'Sorted descending')
                : 'Not sorted',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (widget.onSort != null) {
                    final isCurrent = widget.sortColumnIndex == index;
                    final nextAscending = isCurrent
                        ? !widget.sortAscending
                        : true;
                    widget.onSort!(index, nextAscending);
                  } else {
                    final isCurrent = _internalSortColumnIndex == index;
                    final nextAscending = isCurrent
                        ? !_internalSortAscending
                        : true;
                    setState(() {
                      _internalSortColumnIndex = index;
                      _internalSortAscending = nextAscending;
                      _applyInternalSort(index, nextAscending);
                    });
                  }
                },
                child: headerChild,
              ),
            ),
          ),
        );
      }

      return headerChild;
    });

    // If expandable mode, use Row/flex-based rendering path
    if (widget.expandedRowBuilder != null) {
      return _buildExpandableTable(
        headerCells: headerCells,
        resolvedHeadingRowColor: resolvedHeadingRowColor,
        resolvedHeadingTextStyle: resolvedHeadingTextStyle,
        resolvedHeadingTextColor: resolvedHeadingTextColor,
        resolvedDataRowColor: resolvedDataRowColor,
        resolvedDataTextStyle: resolvedDataTextStyle,
        resolvedDataTextColor: resolvedDataTextColor,
        resolvedDividerThickness: resolvedDividerThickness,
        resolvedDividerColor: resolvedDividerColor,
        resolvedBorderRadius: resolvedBorderRadius,
      );
    }

    // Build data rows
    final dataRows = <TableRow>[];
    for (int i = 0; i < _sortedRows.length; i++) {
      final rowWidget = _sortedRows[i];
      final cells = rowWidget is Row ? rowWidget.children : <Widget>[rowWidget];

      final rowCells = List.generate(widget.columns.length, (colIndex) {
        if (colIndex >= cells.length) {
          return const SizedBox.shrink();
        }
        final cellWidget = cells[colIndex];
        return cellWidget is DataTableCell
            ? cellWidget
            : DataTableCell.custom(child: cellWidget);
      });

      dataRows.add(
        TableRow(
          decoration: BoxDecoration(
            color: resolvedDataRowColor,
            borderRadius: i == _sortedRows.length - 1
                ? BorderRadius.only(
                    bottomLeft: resolvedBorderRadius.bottomLeft,
                    bottomRight: resolvedBorderRadius.bottomRight,
                  )
                : BorderRadius.zero,
            border: i > 0
                ? Border(
                    top: BorderSide(
                      color: resolvedDividerColor,
                      width: resolvedDividerThickness,
                    ),
                  )
                : null,
          ),
          children: rowCells,
        ),
      );
    }

    // Build the table or empty state
    final bool isEmpty = _sortedRows.isEmpty;

    Widget tableContent;
    if (isEmpty) {
      // Show empty message
      tableContent = ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: Column(
          children: [
            // Header row even when empty
            Container(
              decoration: BoxDecoration(
                color: resolvedHeadingRowColor,
                borderRadius: BorderRadius.only(
                  topLeft: resolvedBorderRadius.topLeft,
                  topRight: resolvedBorderRadius.topRight,
                ),
              ),
              child: DefaultTextStyle.merge(
                style: resolvedHeadingTextStyle.copyWith(
                  color: resolvedHeadingTextColor,
                ),
                child: Row(children: headerCells),
              ),
            ),
            // Empty message
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: resolvedDataRowColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: resolvedBorderRadius.bottomLeft,
                  bottomRight: resolvedBorderRadius.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  widget.emptyMessage ?? 'No data',
                  style: resolvedDataTextStyle.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      tableContent = ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: Table(
          columnWidths: columnWidths,
          defaultColumnWidth: ConstrainedColumnWidth(
            minWidth: widget.minColumnWidth,
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: resolvedHeadingRowColor,
                borderRadius: BorderRadius.only(
                  topLeft: resolvedBorderRadius.topLeft,
                  topRight: resolvedBorderRadius.topRight,
                ),
              ),
              children: headerCells
                  .map(
                    (cell) => DefaultTextStyle.merge(
                      style: resolvedHeadingTextStyle.copyWith(
                        color: resolvedHeadingTextColor,
                      ),
                      child: cell,
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ...dataRows.map(
              (row) => TableRow(
                decoration: row.decoration,
                children: row.children
                    .map(
                      (cell) => DefaultTextStyle.merge(
                        style: resolvedDataTextStyle.copyWith(
                          color: resolvedDataTextColor,
                        ),
                        child: cell,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }

    // Resolve border
    final resolvedBorder = widget.showBorder
        ? (widget.border ?? Border.all(color: colors.divider))
        : null;

    // Use sticky header layout if enabled
    if (widget.stickyHeader && !isEmpty) {
      return _buildStickyHeaderTable(
        headerCells: headerCells,
        dataRows: dataRows,
        columnWidths: columnWidths,
        resolvedHeadingRowColor: resolvedHeadingRowColor,
        resolvedHeadingTextStyle: resolvedHeadingTextStyle,
        resolvedHeadingTextColor: resolvedHeadingTextColor,
        resolvedDataTextStyle: resolvedDataTextStyle,
        resolvedDataTextColor: resolvedDataTextColor,
        resolvedBorderRadius: resolvedBorderRadius,
        resolvedBorder: resolvedBorder,
      );
    }

    // Build scrollable table: fills available width, scrolls horizontally
    // when content is wider than the viewport.
    Widget buildScrollableTable(BoxConstraints constraints) {
      final minW = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
      return _withShiftScroll(
        controller: _horizontalController,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minW),
              child: tableContent,
            ),
          ),
        ),
      );
    }

    // Wrap with container for border and footer
    if (resolvedBorder != null || widget.footer != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: resolvedBorderRadius,
              border: resolvedBorder,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: widget.footer != null
                      ? BorderRadius.only(
                          topLeft: resolvedBorderRadius.topLeft,
                          topRight: resolvedBorderRadius.topRight,
                        )
                      : resolvedBorderRadius,
                  child: buildScrollableTable(constraints),
                ),
                if (widget.footer != null) widget.footer!,
              ],
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return buildScrollableTable(constraints);
      },
    );
  }

  /// Builds the table with a sticky header that stays fixed during vertical scroll.
  /// Uses two Table widgets with a shared [_SyncedColumnWidth] so that column
  /// widths converge to the global max across header and body after one frame.
  Widget _buildStickyHeaderTable({
    required List<Widget> headerCells,
    required List<TableRow> dataRows,
    required Map<int, TableColumnWidth> columnWidths,
    required Color resolvedHeadingRowColor,
    required TextStyle resolvedHeadingTextStyle,
    required Color resolvedHeadingTextColor,
    required TextStyle resolvedDataTextStyle,
    required Color resolvedDataTextColor,
    required BorderRadius resolvedBorderRadius,
    required BoxBorder? resolvedBorder,
  }) {
    // Ensure the shared width list matches the column count.
    if (_syncedColumnWidths.length != widget.columns.length) {
      _syncedColumnWidths = List<double>.filled(widget.columns.length, 0.0);
      _needsWidthResync = true;
    }

    // Build synced column widths – both Tables reference the same list so
    // the wider cell (header or body) wins for each column.
    final syncedColumnWidths = <int, TableColumnWidth>{};
    for (int i = 0; i < widget.columns.length; i++) {
      syncedColumnWidths[i] = _SyncedColumnWidth(
        minWidth: widget.minColumnWidth,
        syncedWidths: _syncedColumnWidths,
        columnIndex: i,
      );
    }

    // Build header row widget
    final headerRow = Container(
      decoration: BoxDecoration(
        color: resolvedHeadingRowColor,
        borderRadius: BorderRadius.only(
          topLeft: resolvedBorderRadius.topLeft,
          topRight: resolvedBorderRadius.topRight,
        ),
      ),
      child: Table(
        columnWidths: syncedColumnWidths,
        defaultColumnWidth: ConstrainedColumnWidth(
          minWidth: widget.minColumnWidth,
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: headerCells
                .map(
                  (cell) => DefaultTextStyle.merge(
                    style: resolvedHeadingTextStyle.copyWith(
                      color: resolvedHeadingTextColor,
                    ),
                    child: cell,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );

    // Build body table (data rows only)
    final bodyTable = Table(
      columnWidths: syncedColumnWidths,
      defaultColumnWidth: ConstrainedColumnWidth(
        minWidth: widget.minColumnWidth,
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: dataRows
          .map(
            (row) => TableRow(
              decoration: row.decoration,
              children: row.children
                  .map(
                    (cell) => DefaultTextStyle.merge(
                      style: resolvedDataTextStyle.copyWith(
                        color: resolvedDataTextColor,
                      ),
                      child: cell,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );

    // Schedule a second layout pass so both Tables converge on the synced widths.
    if (_needsWidthResync) {
      _needsWidthResync = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }

    // Both header and body in a single horizontal scroll, with body having
    // vertical scroll. IntrinsicWidth sizes to content; ConstrainedBox ensures
    // the table fills the viewport width when content is narrower.
    Widget buildStickyScrollable(BoxConstraints constraints) {
      final minW = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
      return _withShiftScroll(
        controller: _horizontalController,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minW),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Fixed header (no vertical scroll)
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: resolvedBorderRadius.topLeft,
                        topRight: resolvedBorderRadius.topRight,
                      ),
                      child: headerRow,
                    ),
                    // Scrollable body (vertical scroll only)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: bodyTable,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Wrap with border and footer if needed
    if (resolvedBorder != null || widget.footer != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: resolvedBorderRadius,
              border: resolvedBorder,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: buildStickyScrollable(constraints)),
                if (widget.footer != null) widget.footer!,
              ],
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return buildStickyScrollable(constraints);
      },
    );
  }

  /// Builds the table using a Row/flex-based layout that supports expandable rows.
  /// Column widths are driven by DataTableCell.flex instead of Table column widths.
  Widget _buildExpandableTable({
    required List<Widget> headerCells,
    required Color resolvedHeadingRowColor,
    required TextStyle resolvedHeadingTextStyle,
    required Color resolvedHeadingTextColor,
    required Color resolvedDataRowColor,
    required TextStyle resolvedDataTextStyle,
    required Color resolvedDataTextColor,
    required double resolvedDividerThickness,
    required Color resolvedDividerColor,
    required BorderRadius resolvedBorderRadius,
  }) {
    final resolvedBorder = widget.showBorder
        ? (widget.border ?? Border.all(color: context.appColors.divider))
        : null;

    // Extract flex values from column definitions
    List<int> flexValues = widget.columns.map((col) {
      if (col is DataTableCell) return col.flex;
      return 1;
    }).toList();

    // Build header row using Expanded(flex:) for each cell
    Widget headerRow = Container(
      decoration: BoxDecoration(
        color: resolvedHeadingRowColor,
        borderRadius: BorderRadius.only(
          topLeft: resolvedBorderRadius.topLeft,
          topRight: resolvedBorderRadius.topRight,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: resolvedHeadingTextStyle.copyWith(
          color: resolvedHeadingTextColor,
        ),
        child: Row(
          children: [
            for (int i = 0; i < headerCells.length; i++)
              Expanded(flex: flexValues[i], child: headerCells[i]),
          ],
        ),
      ),
    );

    // Build data rows
    final bool isEmpty = _sortedRows.isEmpty;

    List<Widget> bodyChildren = [];
    if (isEmpty) {
      bodyChildren.add(
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: resolvedDataRowColor),
          child: Center(
            child: Text(
              widget.emptyMessage ?? 'No data',
              style: resolvedDataTextStyle.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
          ),
        ),
      );
    } else {
      for (int i = 0; i < _sortedRows.length; i++) {
        final rowWidget = _sortedRows[i];
        final cells = rowWidget is Row
            ? rowWidget.children
            : <Widget>[rowWidget];

        // Build a flex-based Row for this data row
        final rowChildren = <Widget>[];
        for (int colIndex = 0; colIndex < widget.columns.length; colIndex++) {
          Widget cellWidget;
          if (colIndex < cells.length) {
            cellWidget = cells[colIndex];
            if (cellWidget is! DataTableCell) {
              cellWidget = DataTableCell.custom(child: cellWidget);
            }
          } else {
            cellWidget = const SizedBox.shrink();
          }
          rowChildren.add(
            Expanded(flex: flexValues[colIndex], child: cellWidget),
          );
        }

        final isExpanded = widget.expandedRowIndex == i;

        Widget dataRow = Container(
          decoration: BoxDecoration(
            color: isExpanded
                ? resolvedHeadingRowColor.withValues(alpha: 0.05)
                : resolvedDataRowColor,
            border: i > 0
                ? Border(
                    top: BorderSide(
                      color: resolvedDividerColor,
                      width: resolvedDividerThickness,
                    ),
                  )
                : null,
          ),
          child: DefaultTextStyle.merge(
            style: resolvedDataTextStyle.copyWith(color: resolvedDataTextColor),
            child: Row(children: rowChildren),
          ),
        );

        if (widget.onRowTap != null) {
          dataRow = InkWell(onTap: () => widget.onRowTap!(i), child: dataRow);
        }

        bodyChildren.add(dataRow);

        // Insert expansion widget below the row if expanded
        if (isExpanded && widget.expandedRowBuilder != null) {
          bodyChildren.add(widget.expandedRowBuilder!(i));
        }
      }
    }

    // Assemble: header outside vertical scroll, body inside.
    // All paths use ConstrainedBox to fill viewport width, scroll when wider.
    if (widget.stickyHeader) {
      Widget buildExpandableStickyScrollable(BoxConstraints constraints) {
        final minW = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
        return _withShiftScroll(
          controller: _horizontalController,
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: minW),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      headerRow,
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: bodyChildren,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      if (resolvedBorder != null || widget.footer != null) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: resolvedBorderRadius,
                border: resolvedBorder,
              ),
              child: ClipRRect(
                borderRadius: resolvedBorderRadius,
                child: Column(
                  children: [
                    Expanded(
                      child: buildExpandableStickyScrollable(constraints),
                    ),
                    if (widget.footer != null) widget.footer!,
                  ],
                ),
              ),
            );
          },
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return buildExpandableStickyScrollable(constraints);
        },
      );
    }

    // Non-sticky: everything scrolls together
    Widget buildExpandableScrollable(BoxConstraints constraints) {
      final minW = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
      return _withShiftScroll(
        controller: _horizontalController,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minW),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [headerRow, ...bodyChildren],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (resolvedBorder != null || widget.footer != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: resolvedBorderRadius,
              border: resolvedBorder,
            ),
            child: ClipRRect(
              borderRadius: resolvedBorderRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildExpandableScrollable(constraints),
                  if (widget.footer != null) widget.footer!,
                ],
              ),
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return buildExpandableScrollable(constraints);
      },
    );
  }

  Widget _buildSortableHeader({
    required DataTableCell cell,
    required int index,
    required bool isSortable,
  }) {
    if (!isSortable) {
      return cell;
    }

    // Determine which column is considered "active" for sorting.
    final bool isActive = widget.onSort != null
        ? widget.sortColumnIndex == index
        : _internalSortColumnIndex == index;

    // Determine sort direction depending on who controls the sort.
    final bool ascending = widget.onSort != null
        ? widget.sortAscending
        : _internalSortAscending;

    // When active: show a single arrow in the sort direction.
    // When inactive but sortable: show a stacked up/down indicator.
    Widget indicator;
    if (isActive) {
      indicator = Icon(
        ascending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        size: 16,
        color: AppTheme.textContrast,
      );
    } else {
      final Color faded = AppTheme.textContrast.withValues(alpha: 0.6);
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Icon(Icons.arrow_drop_up, size: 14, color: faded)),
          ExcludeSemantics(child: Icon(Icons.arrow_drop_down, size: 14, color: faded)),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [cell, const SizedBox(width: 4), indicator],
    );
  }

  void _applyInternalSort(int columnIndex, bool ascending) {
    // Pair each row widget with its extracted key for the target column.
    final rowsWithKeys = _sortedRows
        .map(
          (rowWidget) =>
              MapEntry(rowWidget, _extractSortKey(rowWidget, columnIndex)),
        )
        .toList();

    // Detect if all non-null keys are numeric.
    bool allNumeric = true;
    for (final entry in rowsWithKeys) {
      final key = entry.value;
      if (key == null) continue;
      if (num.tryParse(key) == null) {
        allNumeric = false;
        break;
      }
    }

    rowsWithKeys.sort((a, b) {
      final ka = a.value;
      final kb = b.value;

      if (ka == null && kb == null) return 0;
      if (ka == null) return ascending ? 1 : -1;
      if (kb == null) return ascending ? -1 : 1;

      if (allNumeric) {
        final na = num.tryParse(ka) ?? 0;
        final nb = num.tryParse(kb) ?? 0;
        return ascending ? na.compareTo(nb) : nb.compareTo(na);
      } else {
        return ascending ? ka.compareTo(kb) : kb.compareTo(ka);
      }
    });

    _sortedRows = rowsWithKeys.map((e) => e.key).toList();
  }

  String? _extractSortKey(Widget rowWidget, int columnIndex) {
    // Each row can be a Row of cells or a single widget.
    final cells = rowWidget is Row ? rowWidget.children : <Widget>[rowWidget];

    if (columnIndex >= cells.length) return null;

    final cellWidget = cells[columnIndex];

    // If it's a DataTableCell, look inside its child.
    if (cellWidget is DataTableCell) {
      final child = cellWidget.child;
      if (child is Text) {
        return child.data ?? child.toStringShort();
      }
      if (child is Row) {
        for (final c in child.children) {
          if (c is Text) {
            return c.data ?? c.toStringShort();
          }
        }
      }
      return child.toStringShort();
    }

    // Raw Text cell.
    if (cellWidget is Text) {
      return cellWidget.data ?? cellWidget.toStringShort();
    }

    // Fallback: use widget description.
    return cellWidget.toStringShort();
  }
}

/// A TableColumnWidth that sizes to content but enforces a minimum width.
class ConstrainedColumnWidth extends TableColumnWidth {
  const ConstrainedColumnWidth({this.minWidth = 0.0});

  final double minWidth;

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double max = 0.0;
    for (final cell in cells) {
      final cellWidth = cell.getMaxIntrinsicWidth(double.infinity);
      if (cellWidth > max) max = cellWidth;
    }
    return max < minWidth ? minWidth : max;
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double max = 0.0;
    for (final cell in cells) {
      final cellWidth = cell.getMinIntrinsicWidth(double.infinity);
      if (cellWidth > max) max = cellWidth;
    }
    return max < minWidth ? minWidth : max;
  }
}

/// Like [ConstrainedColumnWidth] but writes the computed width into a shared
/// list so that two Tables using the same list converge on the global maximum
/// for each column index. Used by the sticky-header layout.
class _SyncedColumnWidth extends TableColumnWidth {
  const _SyncedColumnWidth({
    this.minWidth = 0.0,
    required this.syncedWidths,
    required this.columnIndex,
  });

  final double minWidth;
  final List<double> syncedWidths;
  final int columnIndex;

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double max = 0.0;
    for (final cell in cells) {
      final cellWidth = cell.getMaxIntrinsicWidth(double.infinity);
      if (cellWidth > max) max = cellWidth;
    }
    final result = max < minWidth ? minWidth : max;

    // Update the shared list so the other Table sees the wider value.
    if (columnIndex < syncedWidths.length &&
        result > syncedWidths[columnIndex]) {
      syncedWidths[columnIndex] = result;
    }

    // Return the global max (may include the other Table's wider cells).
    return columnIndex < syncedWidths.length
        ? syncedWidths[columnIndex]
        : result;
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double max = 0.0;
    for (final cell in cells) {
      final cellWidth = cell.getMinIntrinsicWidth(double.infinity);
      if (cellWidth > max) max = cellWidth;
    }
    return max < minWidth ? minWidth : max;
  }
}
