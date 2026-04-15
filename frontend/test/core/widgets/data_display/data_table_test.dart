// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart'
    as app_table;
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';

import '../../../test_helpers.dart';

void main() {
  List<Widget> buildColumns() => [
    DataTableCell.text('Name'),
    DataTableCell.text('Age'),
  ];

  List<Widget> buildRows() => [
    Row(children: [DataTableCell.text('Bob'), DataTableCell.text('42')]),
    Row(children: [DataTableCell.text('Alice'), DataTableCell.text('30')]),
  ];

  group('DataTable', () {
    testWidgets('renders headers, rows, and footer', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
            footer: const Text('Footer content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Footer content'), findsOneWidget);
    });

    testWidgets('shows the configured empty message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: const [],
            emptyMessage: 'Nothing here',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('calls external onSort with the next direction', (
      tester,
    ) async {
      int? sortedColumn;
      bool? ascending;

      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
            sortColumnIndex: 0,
            sortAscending: true,
            onSort: (columnIndex, nextAscending) {
              sortedColumn = columnIndex;
              ascending = nextAscending;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Age'));
      await tester.pumpAndSettle();

      expect(sortedColumn, 1);
      expect(ascending, isTrue);
    });

    testWidgets('renders expanded rows and reports row taps', (tester) async {
      int? tappedRow;

      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
            expandedRowIndex: 1,
            expandedRowBuilder: (index) => Text('Details for row $index'),
            onRowTap: (index) => tappedRow = index,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Details for row 1'), findsOneWidget);

      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();

      expect(tappedRow, 1);
    });

    testWidgets('internally sorts the first column ascending by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final aliceY = tester.getTopLeft(find.text('Alice')).dy;
      final bobY = tester.getTopLeft(find.text('Bob')).dy;
      expect(aliceY, lessThan(bobY));
    });

    testWidgets(
      'toggles internal sort direction when the same header is tapped',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            app_table.DataTable(
              stickyHeader: false,
              columns: buildColumns(),
              rows: buildRows(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Name'));
        await tester.pumpAndSettle();

        final bobY = tester.getTopLeft(find.text('Bob')).dy;
        final aliceY = tester.getTopLeft(find.text('Alice')).dy;
        expect(bobY, lessThan(aliceY));
      },
    );

    testWidgets('sorts numeric-looking values numerically', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: [
              Row(
                children: [
                  DataTableCell.text('Zed'),
                  DataTableCell.text('100'),
                ],
              ),
              Row(
                children: [DataTableCell.text('Ann'), DataTableCell.text('2')],
              ),
            ],
            sortColumnIndex: 1,
            sortAscending: true,
            onSort: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final annY = tester.getTopLeft(find.text('Ann')).dy;
      final zedY = tester.getTopLeft(find.text('Zed')).dy;
      expect(annY, lessThan(zedY));
    });

    testWidgets('does not sort non-sortable columns', (tester) async {
      int? sortedColumn;

      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
            sortableColumns: const [true, false],
            onSort: (columnIndex, ascending) => sortedColumn = columnIndex,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Age'));
      await tester.pumpAndSettle();

      expect(sortedColumn, isNull);
    });

    testWidgets('renders sticky header mode without layout errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            height: 300,
            child: app_table.DataTable(
              stickyHeader: true,
              columns: buildColumns(),
              rows: buildRows(),
              footer: const Text('Sticky footer'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Sticky footer'), findsOneWidget);
    });

    testWidgets('handles rows with fewer cells than columns safely', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: [
              DataTableCell.text('Name'),
              DataTableCell.text('Age'),
              DataTableCell.text('Status'),
            ],
            rows: [
              Row(children: [DataTableCell.text('Only name')]),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Only name'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('exposes sort semantics for sortable headers', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          app_table.DataTable(
            stickyHeader: false,
            columns: buildColumns(),
            rows: buildRows(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Sort by Name',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Sort by Age',
        ),
        findsOneWidget,
      );
    });
  });
}
