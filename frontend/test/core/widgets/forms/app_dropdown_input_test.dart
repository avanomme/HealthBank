// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_dropdown_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppDropdownInput', () {
    testWidgets('renders label and selected value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            value: 'doctor',
            options: [
              AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
            ],
          ),
        ),
      );

      expect(find.text('Role'), findsOneWidget);
      expect(find.text('Doctor'), findsOneWidget);
    });

    testWidgets('shows hint text when no value is selected', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            hintText: 'Choose role',
            options: [AppDropdownInputOption(label: 'Doctor', value: 'doctor')],
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      final hint = dropdown.hint as Text;
      expect(hint.data, 'Choose role');
    });

    testWidgets('shows required error when selection is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppDropdownInput<String>(
              label: 'Role',
              autovalidateMode: AutovalidateMode.always,
              options: [
                AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Role is required.'), findsOneWidget);
    });

    testWidgets('fires onChanged when a new option is selected', (
      tester,
    ) async {
      String? selected;

      await tester.pumpWidget(
        buildTestWidget(
          AppDropdownInput<String>(
            label: 'Role',
            options: const [
              AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nurse').last);
      await tester.pumpAndSettle();

      expect(selected, 'nurse');
    });

    testWidgets('applies custom validator when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Form(
            child: AppDropdownInput<String>(
              label: 'Role',
              value: 'doctor',
              autovalidateMode: AutovalidateMode.always,
              validator: (value) =>
                  value == 'doctor' ? 'Doctor is blocked.' : null,
              options: const [
                AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Doctor is blocked.'), findsOneWidget);
    });

    testWidgets('disables selection when enabled is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            enabled: false,
            options: [AppDropdownInputOption(label: 'Doctor', value: 'doctor')],
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.onChanged, isNull);
    });

    testWidgets('includes the default Select one option in the menu', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            options: [AppDropdownInputOption(label: 'Doctor', value: 'doctor')],
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Select one').last, findsOneWidget);
    });

    testWidgets('skips required validation when isRequired is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppDropdownInput<String>(
              label: 'Role',
              isRequired: false,
              autovalidateMode: AutovalidateMode.always,
              options: [
                AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Role is required.'), findsNothing);
    });

    testWidgets('updates displayed value when rebuilt with a new selection', (
      tester,
    ) async {
      const options = [
        AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
        AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            value: 'doctor',
            options: options,
          ),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            value: 'nurse',
            options: options,
          ),
        ),
      );

      expect(find.text('Nurse'), findsOneWidget);
    });

    testWidgets('updates its local value even when onChanged is omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            options: [
              AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nurse').last);
      await tester.pumpAndSettle();

      expect(find.text('Nurse'), findsOneWidget);
    });

    testWidgets('exposes semantic label and selected value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppDropdownInput<String>(
            label: 'Role',
            value: 'doctor',
            options: [
              AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
              AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
            ],
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Role, required' &&
              widget.properties.value == 'Doctor',
        ),
        findsOneWidget,
      );
    });
  });
}
