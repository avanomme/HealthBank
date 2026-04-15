// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_confirm_password_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppConfirmPasswordInput', () {
    testWidgets('shows guidance and disables field without password link', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const AppConfirmPasswordInput()));

      expect(
        find.text('Link a create-password field first to enable confirmation.'),
        findsOneWidget,
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets('shows required validation when linked and empty', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ValidPass1!');

      await tester.pumpWidget(
        buildTestWidget(
          Form(
            child: AppConfirmPasswordInput(
              createPasswordController: controller,
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Confirm Password is required.'), findsOneWidget);
    });

    testWidgets('shows mismatch validation for non matching password', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ValidPass1!');

      await tester.pumpWidget(
        buildTestWidget(
          Form(
            child: AppConfirmPasswordInput(
              createPasswordController: controller,
              initialValue: 'WrongPass1!',
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passwords must match exactly.'), findsOneWidget);
    });

    testWidgets('shows matching password check state when values match', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ValidPass1!');

      await tester.pumpWidget(
        buildTestWidget(
          AppConfirmPasswordInput(
            createPasswordController: controller,
            initialValue: 'ValidPass1!',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Confirmed password must exactly match Create Password.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('toggles visibility and emits onChanged when linked', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ValidPass1!');
      String? changed;

      await tester.pumpWidget(
        buildTestWidget(
          AppConfirmPasswordInput(
            createPasswordController: controller,
            onChanged: (value) => changed = value,
          ),
        ),
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

    testWidgets('uses createPasswordValue alone to enable confirmation', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppConfirmPasswordInput(createPasswordValue: 'ValidPass1!'),
        ),
      );

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
      expect(find.text('Password Check'), findsOneWidget);
    });

    testWidgets('disables the visibility toggle when no password link exists', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const AppConfirmPasswordInput()));

      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('revalidates when the linked password controller changes', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ValidPass1!');

      await tester.pumpWidget(
        buildTestWidget(
          Form(
            child: AppConfirmPasswordInput(
              createPasswordController: controller,
              initialValue: 'ValidPass1!',
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      controller.text = 'ChangedPass2!';
      await tester.pumpAndSettle();

      expect(find.text('Passwords must match exactly.'), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('applies custom validator after passwords match', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Form(
            child: AppConfirmPasswordInput(
              createPasswordValue: 'ValidPass1!',
              initialValue: 'ValidPass1!',
              autovalidateMode: AutovalidateMode.always,
              validator: _confirmPasswordValidator,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This password pair is blocked.'), findsOneWidget);
    });

    testWidgets('updates the visibility tooltip after toggle when linked', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppConfirmPasswordInput(createPasswordValue: 'ValidPass1!'),
        ),
      );

      expect(find.byTooltip('Show password'), findsOneWidget);

      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets('uses new-password autofill hints when enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppConfirmPasswordInput(createPasswordValue: 'ValidPass1!'),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofillHints, const [AutofillHints.newPassword]);
    });
  });
}

String? _confirmPasswordValidator(String value) =>
    value == 'ValidPass1!' ? 'This password pair is blocked.' : null;
