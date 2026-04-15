// Created with the Assistance of Codex
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_overlay.dart';
import 'package:frontend/src/core/widgets/forms/app_secured_modal.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppSecuredModal', () {
    testWidgets('renders title, body, password field, and actions',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async => true,
          onBack: () {},
        ),
      ));

      expect(find.byType(AppOverlay), findsOneWidget);
      expect(find.text('Delete Record'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('calls onBack when back button is tapped', (tester) async {
      var backs = 0;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async => true,
          onBack: () => backs++,
        ),
      ));

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(backs, 1);
    });

    testWidgets('calls verifyPassword and success callback on valid password',
        (tester) async {
      String? verified;
      String? succeeded;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (password) async {
            verified = password;
            return true;
          },
          onVerificationSuccess: (password) async {
            succeeded = password;
          },
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'ValidPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(verified, 'ValidPass1!');
      expect(succeeded, 'ValidPass1!');
    });

    testWidgets('shows verification failure message when password is rejected',
        (tester) async {
      String? failed;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async => false,
          onVerificationFailure: (password) async {
            failed = password;
          },
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'WrongPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Password verification failed.'), findsOneWidget);
      expect(failed, 'WrongPass1!');
    });

    testWidgets('shows local required validation before verification',
        (tester) async {
      var verifyCalls = 0;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async {
            verifyCalls++;
            return true;
          },
          onBack: () {},
        ),
      ));

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Password is required.'), findsOneWidget);
      expect(verifyCalls, 0);
    });

    testWidgets('renders custom action and password labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          passwordLabel: 'Current Password',
          backLabel: 'Cancel',
          confirmLabel: 'Delete',
          verifyPassword: (_) async => true,
          onBack: () {},
        ),
      ));

      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('shows verifying state and disables actions while pending',
        (tester) async {
      final completer = Completer<bool>();

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) => completer.future,
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'ValidPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pump();

      expect(find.text('Verifying...'), findsOneWidget);
      expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed,
        isNull,
      );
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );

      completer.complete(true);
      await tester.pumpAndSettle();
    });

    testWidgets('shows failure message when verification throws',
        (tester) async {
      String? failed;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          invalidPasswordMessage: 'Custom verification failed.',
          verifyPassword: (_) async => throw Exception('boom'),
          onVerificationFailure: (password) async {
            failed = password;
          },
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'WrongPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Custom verification failed.'), findsOneWidget);
      expect(failed, 'WrongPass1!');
    });

    testWidgets('clears a verification error after password changes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async => false,
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'WrongPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Password verification failed.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'BetterPass2!');
      await tester.pumpAndSettle();

      expect(find.text('Password verification failed.'), findsNothing);
    });

    testWidgets('does not call failure callback on successful verification',
        (tester) async {
      var failureCalls = 0;

      await tester.pumpWidget(buildTestWidget(
        AppSecuredModal(
          title: 'Delete Record',
          body: 'This action cannot be undone.',
          verifyPassword: (_) async => true,
          onVerificationFailure: (_) async {
            failureCalls++;
          },
          onBack: () {},
        ),
      ));

      await tester.enterText(find.byType(TextField), 'ValidPass1!');
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(failureCalls, 0);
    });
  });
}
