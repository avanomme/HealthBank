// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_checkbox.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppCheckbox', () {
    testWidgets('renders the initial uncontrolled value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCheckbox(initialValue: true),
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('toggles uncontrolled state and calls onChanged',
        (tester) async {
      bool? changedValue;

      await tester.pumpWidget(buildTestWidget(
        AppCheckbox(
          initialValue: false,
          onChanged: (value) => changedValue = value,
        ),
      ));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
      expect(changedValue, isTrue);
    });

    testWidgets('reflects controlled value updates from the parent',
        (tester) async {
      var currentValue = false;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return AppCheckbox(
              value: currentValue,
              onChanged: (value) => setState(() => currentValue = value ?? false),
            );
          },
        ),
      ));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('is non interactive when disabled', (tester) async {
      var calls = 0;

      await tester.pumpWidget(buildTestWidget(
        AppCheckbox(
          initialValue: false,
          enabled: false,
          onChanged: (_) => calls++,
        ),
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.onChanged, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('passes through active and check colors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCheckbox(
          initialValue: true,
          activeColor: AppTheme.error,
          checkColor: AppTheme.white,
        ),
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, AppTheme.error);
      expect(checkbox.checkColor, AppTheme.white);
    });

    testWidgets('uses theme defaults when colors are omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCheckbox(initialValue: true),
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, AppTheme.primary);
      expect(checkbox.checkColor, AppTheme.textContrast);
    });

    testWidgets('forwards tristate mode to the underlying checkbox',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCheckbox(
          initialValue: false,
          tristate: true,
        ),
      ));

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).tristate, isTrue);
    });

    testWidgets('forwards density and tap target overrides', (tester) async {
      const density = VisualDensity(horizontal: -2, vertical: -2);

      await tester.pumpWidget(buildTestWidget(
        const AppCheckbox(
          initialValue: true,
          visualDensity: density,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.visualDensity, density);
      expect(
        checkbox.materialTapTargetSize,
        MaterialTapTargetSize.shrinkWrap,
      );
    });
  });
}
