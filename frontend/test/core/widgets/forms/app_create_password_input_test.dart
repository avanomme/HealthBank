// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_create_password_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppCreatePasswordInput', () {
    testWidgets('renders label and password check section', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AppCreatePasswordInput()));

      expect(find.text('Create Password'), findsOneWidget);
      expect(find.text('Password Check'), findsOneWidget);
      expect(find.text('Minimum 8 characters.'), findsOneWidget);
    });

    testWidgets('shows required validation error when empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppCreatePasswordInput(
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create Password is required.'), findsOneWidget);
    });

    testWidgets('shows rule error when password does not meet requirements', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppCreatePasswordInput(
              initialValue: 'short',
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Password does not meet the required rules.'),
        findsOneWidget,
      );
    });

    testWidgets('accepts a valid password without rule error', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppCreatePasswordInput(
              initialValue: 'ValidPass1!',
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Password does not meet the required rules.'),
        findsNothing,
      );
    });

    testWidgets('toggles visibility and emits onChanged', (tester) async {
      String? changed;

      await tester.pumpWidget(
        buildTestWidget(
          AppCreatePasswordInput(onChanged: (value) => changed = value),
        ),
      );

      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isFalse,
      );

      await tester.enterText(find.byType(TextField), 'ValidPass1!');
      await tester.pumpAndSettle();
      expect(changed, 'ValidPass1!');
    });

    testWidgets('renders custom label and hint text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppCreatePasswordInput(
            label: 'Set Password',
            hintText: 'Choose a password',
          ),
        ),
      );

      expect(find.text('Set Password'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).decoration?.hintText,
        'Choose a password',
      );
    });

    testWidgets('shows the maximum length rule when password is too long', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppCreatePasswordInput(
            initialValue: 'VeryLongPasswordValue1234567890XYZ!',
          ),
        ),
      );

      expect(find.text('Maximum 32 characters.'), findsOneWidget);
    });

    testWidgets('shows the email-like fragment rule when violated', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppCreatePasswordInput(initialValue: 'local@example.com'),
        ),
      );

      expect(
        find.text(
          'Must not contain email-like fragments (for example, local@domain.com).',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the ASCII-only rule when non ASCII text is used', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppCreatePasswordInput(initialValue: 'ValidPass1é'),
        ),
      );

      expect(
        find.text('Use ASCII letters, digits, and common symbols only.'),
        findsOneWidget,
      );
    });

    testWidgets('applies custom validator after all password rules pass', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppCreatePasswordInput(
              initialValue: 'ValidPass1!',
              autovalidateMode: AutovalidateMode.always,
              validator: _createPasswordValidator,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Password is already in use.'), findsOneWidget);
    });

    testWidgets('uses new-password autofill hints', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AppCreatePasswordInput()));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofillHints, const [AutofillHints.newPassword]);
    });
  });
}

String? _createPasswordValidator(String value) =>
    value == 'ValidPass1!' ? 'Password is already in use.' : null;
