// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_time_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppTimeInput', () {
    testWidgets('renders label and read only field by default',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTimeInput(label: 'Preferred Time'),
      ));

      expect(find.text('Preferred Time'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isTrue);
      expect(find.byIcon(Icons.access_time_outlined), findsOneWidget);
    });

    testWidgets('shows formatted initial value when provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTimeInput(
          label: 'Preferred Time',
          value: TimeOfDay(hour: 14, minute: 30),
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, isNotEmpty);
    });

    testWidgets('supports manual entry when enabled', (tester) async {
      TimeOfDay? changed;

      await tester.pumpWidget(buildTestWidget(
        AppTimeInput(
          label: 'Preferred Time',
          allowManualEntry: true,
          onChanged: (value) => changed = value,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isFalse);

      await tester.enterText(find.byType(TextField), '14:30');
      await tester.pumpAndSettle();
      expect(changed, const TimeOfDay(hour: 14, minute: 30));
    });

    testWidgets('shows invalid manual time error when parse fails',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppTimeInput(
            label: 'Preferred Time',
            allowManualEntry: true,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), '99:99');
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid time in HH:MM format (e.g. 09:30).'), findsOneWidget);
    });

    testWidgets('shows required error when empty and required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppTimeInput(
            label: 'Preferred Time',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Preferred Time is required.'), findsOneWidget);
    });

    testWidgets('uses custom hint text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTimeInput(
          label: 'Preferred Time',
          hintText: 'HH:MM',
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, 'HH:MM');
    });

    testWidgets('applies custom validator after required validation passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppTimeInput(
            label: 'Preferred Time',
            value: TimeOfDay(hour: 14, minute: 30),
            autovalidateMode: AutovalidateMode.always,
            validator: _timeValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('That time is unavailable.'), findsOneWidget);
    });

    testWidgets('disables text entry and picker when enabled is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTimeInput(
          label: 'Preferred Time',
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
        const AppTimeInput(
          label: 'Preferred Time',
          value: TimeOfDay(hour: 14, minute: 30),
        ),
      ));

      final initialText =
          tester.widget<TextField>(find.byType(TextField)).controller!.text;

      await tester.pumpWidget(buildTestWidget(
        const AppTimeInput(
          label: 'Preferred Time',
          value: TimeOfDay(hour: 9, minute: 45),
        ),
      ));

      final updatedText =
          tester.widget<TextField>(find.byType(TextField)).controller!.text;

      expect(updatedText, isNot(initialText));
    });

    testWidgets('emits null when manual entry is cleared', (tester) async {
      final values = <TimeOfDay?>[];

      await tester.pumpWidget(buildTestWidget(
        AppTimeInput(
          label: 'Preferred Time',
          allowManualEntry: true,
          onChanged: values.add,
        ),
      ));

      await tester.enterText(find.byType(TextField), '14:30');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(values.last, isNull);
    });
  });
}

String? _timeValidator(TimeOfDay? value) =>
    value != null ? 'That time is unavailable.' : null;
