// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/app_password_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppPasswordInput', () {
    testWidgets('renders label and initial value in obscured field',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPasswordInput(
          label: 'Password',
          initialValue: 'secret123',
        ),
      ));

      expect(find.text('Password'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);
    });

    testWidgets('shows required validation error when empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPasswordInput(
            label: 'Password',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('toggles password visibility from the suffix button',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPasswordInput(
          label: 'Password',
          initialValue: 'secret123',
        ),
      ));

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
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('emits onChanged callback', (tester) async {
      String? changed;

      await tester.pumpWidget(buildTestWidget(
        AppPasswordInput(
          label: 'Password',
          onChanged: (value) => changed = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pumpAndSettle();

      expect(changed, 'secret123');
    });

    testWidgets('tints the suffix button red when there is an error',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPasswordInput(
            label: 'Password',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.color, isNull);
      final icon = tester.widget<Icon>(find.byIcon(Icons.visibility_outlined));
      expect(icon.color, isNull);
      expect(find.text('Password is required.'), findsOneWidget);
      expect(AppTheme.error, isNotNull);
    });

    testWidgets('uses controller text when provided', (tester) async {
      final controller = TextEditingController(text: 'Controller value');

      await tester.pumpWidget(buildTestWidget(
        AppPasswordInput(
          label: 'Password',
          controller: controller,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller, controller);
      expect(controller.text, 'Controller value');
    });

    testWidgets('applies custom validator after required validation passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPasswordInput(
            label: 'Password',
            initialValue: 'secret123',
            autovalidateMode: AutovalidateMode.always,
            validator: _blockedPasswordValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Password cannot be reused.'), findsOneWidget);
    });

    testWidgets('disables the field and visibility toggle when disabled',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPasswordInput(
          label: 'Password',
          enabled: false,
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      final button = tester.widget<IconButton>(find.byType(IconButton));

      expect(field.enabled, isFalse);
      expect(button.onPressed, isNull);
    });

    testWidgets('uses provided autofill hints', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPasswordInput(
          label: 'Password',
          autofillHints: [AutofillHints.newPassword],
        ),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofillHints, const [AutofillHints.newPassword]);
    });

    testWidgets('updates the visibility tooltip after toggling',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPasswordInput(label: 'Password'),
      ));

      expect(find.byTooltip('Show password'), findsOneWidget);

      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hide password'), findsOneWidget);
    });
  });
}

String? _blockedPasswordValidator(String value) =>
    value == 'secret123' ? 'Password cannot be reused.' : null;
