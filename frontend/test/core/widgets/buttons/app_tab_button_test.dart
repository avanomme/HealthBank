// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_tab_button.dart';

import '../../../test_helpers.dart';

BoxDecoration decorationOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(AppTabButton),
      matching: find.byType(Container),
    ),
  );
  return container.decoration! as BoxDecoration;
}

Text textOf(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label));

void main() {
  group('AppTabButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Pending',
          isSelected: false,
          onTap: () {},
        ),
      ));

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('fires callback when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Pending',
          isSelected: false,
          onTap: () => taps++,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('uses selected colors and weight when selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Active',
          isSelected: true,
          onTap: () {},
        ),
      ));

      final decoration = decorationOf(tester);
      final text = textOf(tester, 'Active');

      expect(decoration.color, AppTheme.primary);
      expect((decoration.border as Border).top.color, AppTheme.primary);
      expect(text.style?.color, AppTheme.textContrast);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('uses unselected colors and normal weight when not selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Archived',
          isSelected: false,
          onTap: () {},
        ),
      ));

      final decoration = decorationOf(tester);
      final text = textOf(tester, 'Archived');

      expect(decoration.color, AppTheme.surface);
      expect((decoration.border as Border).top.color, AppTheme.divider);
      expect(text.style?.color, AppTheme.adaptiveTextPrimary);
      expect(text.style?.fontWeight, FontWeight.normal);
    });

    testWidgets('wraps its content in an InkWell for tap handling',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Draft',
          isSelected: false,
          onTap: () {},
        ),
      ));

      final inkwell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkwell.onTap, isNotNull);
    });

    testWidgets('uses a matching border radius on touch and visual surfaces',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Draft',
          isSelected: false,
          onTap: () {},
        ),
      ));

      final inkwell = tester.widget<InkWell>(find.byType(InkWell));
      final decoration = decorationOf(tester);

      expect(inkwell.borderRadius, BorderRadius.circular(4));
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets('updates its colors when selection state changes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Draft',
          isSelected: false,
          onTap: () {},
        ),
      ));

      expect(decorationOf(tester).color, AppTheme.surface);

      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Draft',
          isSelected: true,
          onTap: () {},
        ),
      ));

      expect(decorationOf(tester).color, AppTheme.primary);
      expect(textOf(tester, 'Draft').style?.color, AppTheme.textContrast);
    });

    testWidgets('fires callback on every tap', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppTabButton(
          label: 'Pending',
          isSelected: false,
          onTap: () => taps++,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(taps, 2);
    });
  });
}
