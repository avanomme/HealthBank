// Created with the Assistance of Claude Code
// frontend/test/features/settings/settings_page_test.dart
//
// Tests for SettingsPage — covers the delete-account request flow using a
// mock AuthApi so no real HTTP calls are made.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/src/features/settings/pages/settings_page.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show authApiProvider;
import 'package:frontend/src/core/api/api.dart';

import '../../test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake AuthApi — configures requestAccountDeletion behaviour per test.
// ---------------------------------------------------------------------------

class _FakeAuthApi implements AuthApi {
  final Future<void> Function() _onRequestDeletion;

  _FakeAuthApi({Future<void> Function()? onRequestDeletion})
      : _onRequestDeletion = onRequestDeletion ?? (() async {});

  @override
  Future<void> requestAccountDeletion() => _onRequestDeletion();

  @override
  Future<void> logout() => Future.value();

  @override
  Future<dynamic> login(LoginRequest request) => throw UnimplementedError();

  @override
  Future<dynamic> verify2fa(Verify2FARequest request) =>
      throw UnimplementedError();

  @override
  Future<SessionMeResponse> getSessionInfo() => throw UnimplementedError();

  @override
  Future<MessageResponse> requestPasswordReset(
          PasswordResetEmailRequest request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> confirmPasswordReset(
          PasswordResetConfirmRequest request) =>
      throw UnimplementedError();

  @override
  Future<dynamic> getPublicConfig() async => {'registration_open': true};

  @override
  Future<MessageResponse> submitAccountRequest(
          AccountRequestCreate request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> changePassword(ChangePasswordRequest request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> completeProfile(ProfileCompleteRequest request) =>
      throw UnimplementedError();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

List<Override> _overrides({Future<void> Function()? onRequestDeletion}) => [
      authApiProvider.overrideWithValue(
        _FakeAuthApi(onRequestDeletion: onRequestDeletion),
      ),
    ];

/// Large viewport so all three security tiles fit without scrolling.
Future<void> _pumpLarge(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SettingsPage — delete account', () {
    // ── Rendering ───────────────────────────────────────────────────────────

    testWidgets('renders delete account list tile', (tester) async {
      await tester.pumpWidget(
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete Account'), findsOneWidget);
    });

    testWidgets('delete account tile shows subtitle', (tester) async {
      await tester.pumpWidget(
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Request permanent'), findsOneWidget);
    });

    testWidgets('delete account tile shows delete_forever icon', (tester) async {
      await tester.pumpWidget(
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    // ── Confirm dialog ───────────────────────────────────────────────────────

    testWidgets('tapping tile shows confirm dialog', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pumpLarge(
        tester,
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.text('Request Account Deletion?'), findsOneWidget);
    });

    testWidgets('confirm dialog shows submit and cancel buttons', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pumpLarge(
        tester,
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.text('Submit Request'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel button closes the dialog', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pumpLarge(
        tester,
        buildTestPage(const SettingsPage(), overrides: _overrides()),
      );

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Request Account Deletion?'), findsNothing);
    });

    // ── Successful submission ────────────────────────────────────────────────

    testWidgets('confirming navigates to login page', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const SettingsPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) =>
                const Scaffold(body: Text('Login Page')),
          ),
        ],
      );

      await _pumpLarge(
        tester,
        TestRouterApp(
          router: router,
          overrides: _overrides(onRequestDeletion: () async {}),
        ),
      );

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Request'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });

    testWidgets('confirming calls requestAccountDeletion', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var called = false;

      await _pumpLarge(
        tester,
        buildTestPage(
          const SettingsPage(),
          overrides: _overrides(
            onRequestDeletion: () async {
              called = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Request'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
