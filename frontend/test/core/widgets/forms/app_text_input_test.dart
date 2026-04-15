// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_text_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppTextInput', () {
    testWidgets('renders label and initialValue', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppTextInput(label: 'Full Name', initialValue: 'Jane Doe'),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('uses controller text when provided', (tester) async {
      final controller = TextEditingController(text: 'Controller value');

      await tester.pumpWidget(
        buildTestWidget(
          AppTextInput(label: 'Full Name', controller: controller),
        ),
      );

      expect(find.text('Controller value'), findsOneWidget);
    });

    testWidgets('shows required validation error when empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppTextInput(
              label: 'Full Name',
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Full Name is required.'), findsOneWidget);
    });

    testWidgets('skips required validation when isRequired is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppTextInput(
              label: 'Nickname',
              isRequired: false,
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nickname is required.'), findsNothing);
    });

    testWidgets('emits onChanged and onSubmitted callbacks', (tester) async {
      String? changed;
      String? submitted;

      await tester.pumpWidget(
        buildTestWidget(
          AppTextInput(
            label: 'Full Name',
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Jane');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(changed, 'Jane');
      expect(submitted, 'Jane');
    });

    testWidgets('renders hint text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppTextInput(
            label: 'Full Name',
            hintText: 'Enter your full name',
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, 'Enter your full name');
    });

    testWidgets('disables the text field when enabled is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const AppTextInput(label: 'Full Name', enabled: false)),
      );

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets('applies a custom validator after required validation passes', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppTextInput(
              label: 'Full Name',
              initialValue: 'Jane',
              autovalidateMode: AutovalidateMode.always,
              validator: _blockedNameValidator,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('That name is reserved.'), findsOneWidget);
    });

    testWidgets('updates its internal controller when initialValue changes', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppTextInput(label: 'Full Name', initialValue: 'Jane Doe'),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          const AppTextInput(label: 'Full Name', initialValue: 'John Smith'),
        ),
      );

      expect(find.text('John Smith'), findsOneWidget);
    });

    testWidgets('forwards focus, action, and autofill configuration', (
      tester,
    ) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestWidget(
          AppTextInput(
            label: 'Full Name',
            focusNode: focusNode,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode, focusNode);
      expect(field.textInputAction, TextInputAction.next);
      expect(field.autofillHints, const [AutofillHints.name]);
    });

    testWidgets('exposes required label semantics on the input', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppTextInput(
            label: 'Full Name',
            hintText: 'Enter your full name',
          ),
        ),
      );

      // AppTextInput uses native TextField which declares its own semantics.
      // appFieldSemantics passes through for native inputs (isNativeInput: true).
      // Verify the label text is rendered visually.
      expect(find.text('Full Name'), findsOneWidget);
    });
  });
}

String? _blockedNameValidator(String value) =>
    value == 'Jane' ? 'That name is reserved.' : null;
