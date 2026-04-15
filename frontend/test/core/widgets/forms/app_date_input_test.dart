// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_date_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppDateInput', () {
    testWidgets('renders label and read only field by default',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDateInput(label: 'Date of Birth'),
      ));

      expect(find.text('Date of Birth'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isTrue);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('shows initial formatted value when provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDateInput(
          label: 'Date of Birth',
          value: DateTime(2024, 1, 15),
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, isNotEmpty);
    });

    testWidgets('supports manual entry when enabled', (tester) async {
      DateTime? changed;

      await tester.pumpWidget(buildTestWidget(
        AppDateInput(
          label: 'Date of Birth',
          allowManualEntry: true,
          onChanged: (value) => changed = value,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isFalse);

      await tester.enterText(find.byType(TextField), '2024-01-15');
      await tester.pumpAndSettle();
      expect(changed, DateTime(2024, 1, 15));
    });

    testWidgets('shows invalid manual date error when parse fails',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppDateInput(
            label: 'Date of Birth',
            allowManualEntry: true,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'not-a-date');
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a valid date in YYYY-MM-DD format (e.g. 2024-01-15).'),
        findsOneWidget,
      );
    });

    testWidgets('shows required error when empty and required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppDateInput(
            label: 'Date of Birth',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Date of Birth is required.'), findsOneWidget);
    });

    testWidgets('uses custom hint text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDateInput(
          label: 'Date of Birth',
          hintText: 'YYYY-MM-DD',
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, 'YYYY-MM-DD');
    });

    testWidgets('applies custom validator after required validation passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        Form(
          child: AppDateInput(
            label: 'Date of Birth',
            value: DateTime(2024, 1, 15),
            autovalidateMode: AutovalidateMode.always,
            validator: _dateValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('That date is unavailable.'), findsOneWidget);
    });

    testWidgets('disables text entry and picker when enabled is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDateInput(
          label: 'Date of Birth',
          enabled: false,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      final button = tester.widget<IconButton>(find.byType(IconButton));

      expect(field.enabled, isFalse);
      expect(button.onPressed, isNull);
    });

    testWidgets('updates displayed text when value changes on rebuild',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppDateInput(
          label: 'Date of Birth',
          value: DateTime(2024, 1, 15),
        ),
      ));

      final initialText =
          tester.widget<TextField>(find.byType(TextField)).controller!.text;

      await tester.pumpWidget(buildTestWidget(
        AppDateInput(
          label: 'Date of Birth',
          value: DateTime(2024, 2, 20),
        ),
      ));

      final updatedText =
          tester.widget<TextField>(find.byType(TextField)).controller!.text;

      expect(updatedText, isNot(initialText));
    });

    testWidgets('emits null when manual entry is cleared', (tester) async {
      final values = <DateTime?>[];

      await tester.pumpWidget(buildTestWidget(
        AppDateInput(
          label: 'Date of Birth',
          allowManualEntry: true,
          onChanged: values.add,
        ),
      ));

      await tester.enterText(find.byType(TextField), '2024-01-15');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(values.last, isNull);
    });
  });
}

String? _dateValidator(DateTime? value) =>
    value != null ? 'That date is unavailable.' : null;
