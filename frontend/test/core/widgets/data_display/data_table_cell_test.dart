// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';

import '../../../test_helpers.dart';

void main() {
  group('DataTableCell', () {
    testWidgets('renders text cells with the configured metadata',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        DataTableCell.text(
          'Alice',
          flex: 2,
          alignment: CellAlignment.end,
        ),
      ));

      final cell = tester.widget<DataTableCell>(find.byType(DataTableCell));
      expect(cell.flex, 2);
      expect(cell.alignment, CellAlignment.end);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('renders badge and status factory content', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        Column(
          children: [
            DataTableCell.badge(
              'Admin',
              color: AppTheme.error,
            ),
            DataTableCell.status(
              isActive: false,
              inactiveText: 'Offline',
              inactiveColor: AppTheme.caution,
            ),
          ],
        ),
      ));

      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);

      final dot = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.minWidth == 8 &&
              widget.constraints?.minHeight == 8,
        ),
      );
      final decoration = dot.decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.caution);
    });

    testWidgets('renders raw null values and truncates long values',
        (tester) async {
      const longValue = 'abcdefghijklmnopqrstuvwxyz';

      await tester.pumpWidget(buildTestWidget(
        Column(
          children: [
            DataTableCell.rawValue(null),
            DataTableCell.rawValue(longValue, maxLength: 10),
          ],
        ),
      ));

      expect(find.text('NULL'), findsOneWidget);
      expect(find.text('abcdefg...'), findsOneWidget);
    });

    testWidgets('icon factory shows tooltip and handles taps',
        (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        DataTableCell.icon(
          icon: Icons.edit_outlined,
          tooltip: 'Edit row',
          onTap: () => taps++,
        ),
      ));

      await tester.longPress(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Edit row'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('toggle factory emits changed values', (tester) async {
      bool? toggled;

      await tester.pumpWidget(buildTestWidget(
        DataTableCell.toggle(
          value: false,
          onChanged: (value) => toggled = value,
        ),
      ));

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(toggled, isTrue);
    });
  });
}
