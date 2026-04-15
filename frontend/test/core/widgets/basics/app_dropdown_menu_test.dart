// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_dropdown_menu.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppDropdownMenu', () {
    testWidgets('renders with the selected initial value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          initialValue: 'daily',
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
            AppDropdownOption(label: 'Weekly', value: 'weekly'),
          ],
        ),
      ));

      expect(find.text('Daily'), findsOneWidget);
    });

    testWidgets('shows hint text when no initial value is selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          hintText: 'Choose one',
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
          ],
        ),
      ));

      final field = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(field.decoration.hintText, 'Choose one');
    });

    testWidgets('fires onChanged when a new option is selected',
        (tester) async {
      String? selected;

      await tester.pumpWidget(buildTestWidget(
        AppDropdownMenu<String>(
          options: const [
            AppDropdownOption(label: 'Daily', value: 'daily'),
            AppDropdownOption(label: 'Weekly', value: 'weekly'),
          ],
          onChanged: (value) => selected = value,
        ),
      ));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weekly').last);
      await tester.pumpAndSettle();

      expect(selected, 'weekly');
    });

    testWidgets('renders disabled options in muted text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
            AppDropdownOption(
              label: 'Weekly',
              value: 'weekly',
              enabled: false,
            ),
          ],
        ),
      ));

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      final item = dropdown.items!.singleWhere((entry) => entry.value == 'weekly');
      final text = item.child as Text;
      expect(item.enabled, isFalse);
      expect(text.style?.color, AppTheme.textMuted);
    });

    testWidgets('uses selected option font weight for the initial value',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          initialValue: 'weekly',
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
            AppDropdownOption(label: 'Weekly', value: 'weekly'),
          ],
        ),
      ));

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      final weeklyItem =
          dropdown.items!.singleWhere((entry) => entry.value == 'weekly');
      final weekly = weeklyItem.child as Text;
      expect(weekly.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('is disabled when onChanged is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          initialValue: 'daily',
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
            AppDropdownOption(label: 'Weekly', value: 'weekly'),
          ],
        ),
      ));

      final field = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(field.onChanged, isNull);

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.iconDisabledColor, AppTheme.muted);
    });

    testWidgets('renders safely with an empty options list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          hintText: 'Nothing to pick',
          options: [],
        ),
      ));

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.items, isEmpty);
    });

    testWidgets('uses responsive decoration padding and border styling',
        (tester) async {
      tester.view.physicalSize = const Size(500, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget(
        const AppDropdownMenu<String>(
          hintText: 'Choose one',
          options: [
            AppDropdownOption(label: 'Daily', value: 'daily'),
          ],
        ),
      ));

      final field = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      final decoration = field.decoration;
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(horizontal: 12.8, vertical: 8),
      );

      final enabledBorder = decoration.enabledBorder as OutlineInputBorder;
      expect(enabledBorder.borderRadius, BorderRadius.circular(6.4));
      expect(enabledBorder.borderSide.color, AppTheme.primary);
    });
  });
}
