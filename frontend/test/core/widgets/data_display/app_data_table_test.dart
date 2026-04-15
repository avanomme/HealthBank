// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_data_table.dart';

import '../../../test_helpers.dart';

class _UserRow {
  const _UserRow({
    required this.name,
    required this.role,
    required this.active,
  });

  final String name;
  final String role;
  final bool active;
}

void main() {
  const users = [
    _UserRow(name: 'Bob', role: 'Editor', active: false),
    _UserRow(name: 'Alice', role: 'Admin', active: true),
  ];

  List<AppTableColumn<_UserRow>> buildColumns() => [
        AppTableColumn<_UserRow>.text(
          header: 'Name',
          value: (user) => user.name,
        ),
        AppTableColumn<_UserRow>.badge(
          header: 'Role',
          value: (user) => user.role,
          color: (user) =>
              user.role == 'Admin' ? AppTheme.success : AppTheme.caution,
        ),
        AppTableColumn<_UserRow>.status(
          header: 'Status',
          isActive: (user) => user.active,
        ),
      ];

  group('AppDataTable', () {
    testWidgets('renders typed columns and row data', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: users,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Editor'), findsOneWidget);
    });

    testWidgets('sorts rows internally when a sortable header is tapped',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: users,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();

      final aliceY = tester.getTopLeft(find.text('Alice')).dy;
      final bobY = tester.getTopLeft(find.text('Bob')).dy;
      expect(aliceY, lessThan(bobY));
    });

    testWidgets('calls external onSort when provided', (tester) async {
      int? sortedColumn;
      bool? ascending;

      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: users,
          sortColumnIndex: 0,
          sortAscending: true,
          onSort: (columnIndex, nextAscending) {
            sortedColumn = columnIndex;
            ascending = nextAscending;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Role'));
      await tester.pumpAndSettle();

      expect(sortedColumn, 1);
      expect(ascending, isTrue);
    });

    testWidgets('renders expanded content for the selected typed row',
        (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: users,
          expandedIndex: 1,
          expandedBuilder: (user) => Text('Details for ${user.name}'),
          onRowTap: (index) => tappedIndex = index,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Details for Alice'), findsOneWidget);

      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 0);
    });

    testWidgets('shows the configured empty message when there are no items',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: const [],
          emptyMessage: 'No users yet',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('No users yet'), findsOneWidget);
    });

    testWidgets('toggles internal sort direction on repeated header taps',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: buildColumns(),
          items: users,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();

      final bobY = tester.getTopLeft(find.text('Bob')).dy;
      final aliceY = tester.getTopLeft(find.text('Alice')).dy;
      expect(bobY, lessThan(aliceY));
    });

    testWidgets('passes typed expanded content after internal sorting',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                AppDataTable<_UserRow>(
                  stickyHeader: false,
                  columns: buildColumns(),
                  items: users,
                  sortColumnIndex: 0,
                  sortAscending: true,
                  expandedIndex: 0,
                  onSort: (columnIndex, ascending) {
                    setState(() {});
                  },
                  expandedBuilder: (user) => Text('Expanded ${user.name}'),
                ),
              ],
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Expanded Bob'), findsOneWidget);
    });

    testWidgets('respects non-sortable columns from typed definitions',
        (tester) async {
      int? sortedColumn;

      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: [
            ...buildColumns(),
            AppTableColumn<_UserRow>.actions(
              header: 'Actions',
              builder: (_) => const [Text('Open')],
            ),
          ],
          items: users,
          onSort: (columnIndex, ascending) => sortedColumn = columnIndex,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      expect(sortedColumn, isNull);
    });

    testWidgets('emits toggle callbacks from typed toggle columns',
        (tester) async {
      String? toggledUser;
      bool? toggledValue;

      await tester.pumpWidget(buildTestWidget(
        AppDataTable<_UserRow>(
          stickyHeader: false,
          columns: [
            AppTableColumn<_UserRow>.text(
              header: 'Name',
              value: (user) => user.name,
            ),
            AppTableColumn<_UserRow>.toggle(
              header: 'Enabled',
              value: (user) => user.active,
              onChanged: (user, value) {
                toggledUser = user.name;
                toggledValue = value;
              },
            ),
          ],
          items: users,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(toggledUser, 'Bob');
      expect(toggledValue, isTrue);
    });

    testWidgets('renders sticky header mode through the typed wrapper',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SizedBox(
          height: 300,
          child: AppDataTable<_UserRow>(
            columns: buildColumns(),
            items: users,
            stickyHeader: true,
            footer: const Text('Typed footer'),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Typed footer'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });
  });
}
