// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_email_input.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppEmailInput', () {
    testWidgets('renders label and initialValue', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmailInput(
          label: 'Email',
          initialValue: 'jane@example.com',
        ),
      ));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
    });

    testWidgets('shows required validation error when empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppEmailInput(
            label: 'Email',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Email is required.'), findsOneWidget);
    });

    testWidgets('shows format validation error for invalid email',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppEmailInput(
            label: 'Email',
            initialValue: 'invalid-email',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address (e.g. name@example.com).'), findsOneWidget);
    });

    testWidgets('accepts valid email without format error', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppEmailInput(
            label: 'Email',
            initialValue: 'jane@example.com',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address (e.g. name@example.com).'), findsNothing);
    });

    testWidgets('emits onChanged callback', (tester) async {
      String? changed;

      await tester.pumpWidget(buildTestWidget(
        AppEmailInput(
          label: 'Email',
          onChanged: (value) => changed = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'jane@example.com');
      await tester.pumpAndSettle();

      expect(changed, 'jane@example.com');
    });

    testWidgets('uses controller text when provided', (tester) async {
      final controller = TextEditingController(text: 'owner@example.com');

      await tester.pumpWidget(buildTestWidget(
        AppEmailInput(
          label: 'Email',
          controller: controller,
        ),
      ));

      expect(find.text('owner@example.com'), findsOneWidget);
    });

    testWidgets('skips required validation when isRequired is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppEmailInput(
            label: 'Email',
            isRequired: false,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Email is required.'), findsNothing);
    });

    testWidgets('applies custom validator after email format passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppEmailInput(
            label: 'Email',
            initialValue: 'jane@example.com',
            autovalidateMode: AutovalidateMode.always,
            validator: _blockedEmailValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('This email is blocked.'), findsOneWidget);
    });

    testWidgets('disables the field when enabled is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmailInput(
          label: 'Email',
          enabled: false,
        ),
      ));

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets('uses email keyboard and autofill configuration',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmailInput(label: 'Email'),
      ));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, TextInputType.emailAddress);
      expect(field.textInputAction, TextInputAction.next);
      expect(field.autofillHints, const [AutofillHints.email]);
    });
  });
}

String? _blockedEmailValidator(String value) =>
    value == 'jane@example.com' ? 'This email is blocked.' : null;
