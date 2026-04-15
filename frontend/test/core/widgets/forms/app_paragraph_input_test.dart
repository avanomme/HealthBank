// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_paragraph_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppParagraphInput', () {
    testWidgets('renders label and initial text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppParagraphInput(
          label: 'Notes',
          initialValue: 'Initial note',
        ),
      ));

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Initial note'), findsOneWidget);
    });

    testWidgets('uses minLines and maxLines when fixedHeight is not set',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppParagraphInput(
          label: 'Notes',
          minLines: 4,
          maxLines: 6,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.minLines, 4);
      expect(field.maxLines, 6);
      expect(field.expands, isFalse);
    });

    testWidgets('uses expanding field inside fixed height box',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppParagraphInput(
          label: 'Notes',
          fixedHeight: 180,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      final box = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 180,
        ),
      );
      expect(field.expands, isTrue);
      expect(box.height, 180);
    });

    testWidgets('shows required validation error when empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppParagraphInput(
            label: 'Notes',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Notes is required.'), findsOneWidget);
    });

    testWidgets('emits onChanged callback', (tester) async {
      String? changed;

      await tester.pumpWidget(buildTestWidget(
        AppParagraphInput(
          label: 'Notes',
          onChanged: (value) => changed = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Updated note');
      await tester.pumpAndSettle();

      expect(changed, 'Updated note');
    });

    testWidgets('uses controller text when provided', (tester) async {
      final controller = TextEditingController(text: 'Controller note');

      await tester.pumpWidget(buildTestWidget(
        AppParagraphInput(
          label: 'Notes',
          controller: controller,
        ),
      ));

      expect(find.text('Controller note'), findsOneWidget);
    });

    testWidgets('renders hint text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppParagraphInput(
          label: 'Notes',
          hintText: 'Add details',
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, 'Add details');
    });

    testWidgets('skips required validation when isRequired is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppParagraphInput(
            label: 'Notes',
            isRequired: false,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Notes is required.'), findsNothing);
    });

    testWidgets('applies custom validator after required validation passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppParagraphInput(
            label: 'Notes',
            initialValue: 'forbidden',
            autovalidateMode: AutovalidateMode.always,
            validator: _blockedNoteValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('This note value is blocked.'), findsOneWidget);
    });

    testWidgets('disables the text field when enabled is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppParagraphInput(
          label: 'Notes',
          enabled: false,
        ),
      ));

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });
  });
}

String? _blockedNoteValidator(String value) =>
    value == 'forbidden' ? 'This note value is blocked.' : null;
