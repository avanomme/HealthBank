// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_phone_input.dart';

import '../../../test_helpers.dart';

void main() {
  const countries = [
    AppPhoneCountry(
      isoCode: 'US',
      label: 'United States',
      dialCode: '+1',
    ),
    AppPhoneCountry(
      isoCode: 'GB',
      label: 'United Kingdom',
      dialCode: '+44',
    ),
  ];

  group('AppPhoneInput', () {
    testWidgets('renders label, selected country, and initial value',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          initialCountry: countries[1],
          initialValue: '555 0123',
        ),
      ));

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('United Kingdom (+44)'), findsOneWidget);
      expect(find.text('555 0123'), findsOneWidget);
    });

    testWidgets('emits normalized value after the initial frame',
        (tester) async {
      String? normalized;

      await tester.pumpWidget(buildTestWidget(
        AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          initialCountry: countries[1],
          initialValue: '555 0123',
          onNormalizedChanged: (value) => normalized = value,
        ),
      ));
      await tester.pump();

      expect(normalized, '+445550123');
    });

    testWidgets('shows required validation error when empty', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPhoneInput(
            label: 'Phone Number',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Phone Number is required.'), findsOneWidget);
    });

    testWidgets('shows invalid validation error for non numeric input',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPhoneInput(
            label: 'Phone Number',
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid phone number including country code.'), findsOneWidget);
    });

    testWidgets('updates country and normalized value when selection changes',
        (tester) async {
      AppPhoneCountry? selectedCountry;
      String? normalized;

      await tester.pumpWidget(buildTestWidget(
        AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          initialCountry: countries[0],
          initialValue: '5550123',
          onCountryChanged: (value) => selectedCountry = value,
          onNormalizedChanged: (value) => normalized = value,
        ),
      ));
      await tester.pump();

      expect(normalized, '+15550123');

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pumpAndSettle();
      await tester.tap(find.text('United Kingdom (+44)').last);
      await tester.pumpAndSettle();

      expect(selectedCountry?.isoCode, 'GB');
      expect(normalized, '+445550123');
    });

    testWidgets('uses controller text when provided', (tester) async {
      final controller = TextEditingController(text: '555 0199');

      await tester.pumpWidget(buildTestWidget(
        AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          controller: controller,
        ),
      ));

      expect(find.text('555 0199'), findsOneWidget);
    });

    testWidgets('emits raw onChanged values', (tester) async {
      String? changed;

      await tester.pumpWidget(buildTestWidget(
        AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          onChanged: (value) => changed = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '555 0000');
      await tester.pumpAndSettle();

      expect(changed, '555 0000');
    });

    testWidgets('skips required validation when isRequired is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPhoneInput(
            label: 'Phone Number',
            isRequired: false,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Phone Number is required.'), findsNothing);
    });

    testWidgets('disables both country picker and text field when disabled',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPhoneInput(
          label: 'Phone Number',
          countries: countries,
          enabled: false,
        ),
      ));

      final dropdown = tester.widget<DropdownButton<AppPhoneCountry>>(
        find.byType(DropdownButton<AppPhoneCountry>),
      );
      final field = tester.widget<TextField>(find.byType(TextField));

      expect(dropdown.onChanged, isNull);
      expect(field.enabled, isFalse);
    });

    testWidgets('applies custom validator after basic validation passes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Form(
          child: AppPhoneInput(
            label: 'Phone Number',
            countries: countries,
            initialValue: '5550123',
            autovalidateMode: AutovalidateMode.always,
            validator: _phoneValidator,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('This phone number is blocked.'), findsOneWidget);
    });
  });
}

String? _phoneValidator(String value) =>
    value == '5550123' ? 'This phone number is blocked.' : null;
