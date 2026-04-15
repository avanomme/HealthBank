// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';

class _MockAuthNotifier extends StateNotifier<AuthState>
    with Mock
    implements AuthNotifier {
  _MockAuthNotifier([AuthState? initial]) : super(initial ?? const AuthState());

  Future<String?> Function(String code)? onVerifyMfa;
  VoidCallback? onClearMfaChallenge;

  @override
  Future<String?> verifyMfa(String code) async {
    return onVerifyMfa?.call(code);
  }

  @override
  void clearMfaChallenge() {
    onClearMfaChallenge?.call();
    state = state.copyWith(
      mfaRequired: false,
      mfaChallengeToken: null,
      error: null,
    );
  }

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<void> logout() async {
    state = const AuthState();
  }
}

class _MockTwoFactorNotifier extends StateNotifier<TwoFactorState>
    with Mock
    implements TwoFactorNotifier {
  _MockTwoFactorNotifier([TwoFactorState? initial])
    : super(initial ?? const TwoFactorState());

  Future<void> Function()? onEnroll;
  Future<String?> Function(String code)? onConfirm;

  @override
  Future<void> enroll() async {
    await onEnroll?.call();
  }

  @override
  Future<String?> confirm(String code) async {
    return onConfirm?.call(code);
  }

  @override
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  @override
  void startVerify() {
    state = state.copyWith(isBusy: true, error: null, confirmMessage: null);
  }

  @override
  void finishVerify({String? error}) {
    state = state.copyWith(isBusy: false, error: error);
  }

  @override
  void clearConfirmMessage() {
    state = state.copyWith(confirmMessage: null);
  }

  @override
  void reset() {
    state = const TwoFactorState();
  }
}

LoginResponse _user({
  String role = 'participant',
  bool mustChangePassword = false,
  bool hasSignedConsent = true,
  bool needsProfileCompletion = false,
}) {
  return LoginResponse(
    expiresAt: '2099-01-01T00:00:00Z',
    accountId: 1,
    firstName: 'Ada',
    lastName: 'Lovelace',
    email: 'ada@example.com',
    role: role,
    mustChangePassword: mustChangePassword,
    hasSignedConsent: hasSignedConsent,
    needsProfileCompletion: needsProfileCompletion,
  );
}

GoRouter _router({required Widget home}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => home),
      GoRoute(
        path: '/login',
        builder: (_, __) => const Scaffold(body: Text('Login Page')),
      ),
      GoRoute(
        path: '/participant/dashboard',
        builder: (_, __) => const Scaffold(body: Text('Participant Dashboard')),
      ),
      GoRoute(
        path: '/consent',
        builder: (_, __) => const Scaffold(body: Text('Consent Page')),
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (_, __) => const Scaffold(body: Text('Complete Profile Page')),
      ),
      GoRoute(
        path: '/change-password',
        builder: (_, __) => const Scaffold(body: Text('Change Password Page')),
      ),
    ],
  );
}

void _setSurfaceSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1.0;
}

void main() {
  group('TwoFactorPage', () {
    testWidgets('shows login prompt when user is not authenticated', (
      tester,
    ) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = _router(home: const TwoFactorPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authProvider.overrideWith((ref) => _MockAuthNotifier()),
            twoFactorProvider.overrideWith((ref) => _MockTwoFactorNotifier()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Please log in first to enroll 2FA.'), findsOneWidget);
      expect(find.text('Enroll (API)'), findsNothing);
      expect(find.text('Verify'), findsNothing);
    });

    testWidgets(
      'enrollment flow calls enroll and confirm then shows snackbar',
      (tester) async {
        _setSurfaceSize(tester);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final authNotifier = _MockAuthNotifier(
          AuthState(isAuthenticated: true, user: _user()),
        );
        final twoFactorNotifier = _MockTwoFactorNotifier();
        var enrollCalled = 0;
        String? confirmedCode;

        twoFactorNotifier.onEnroll = () async {
          enrollCalled += 1;
          twoFactorNotifier.state = twoFactorNotifier.state.copyWith(
            provisioningUri: 'otpauth://totp/HealthBank?secret=ABC123',
          );
        };
        twoFactorNotifier.onConfirm = (code) async {
          confirmedCode = code;
          twoFactorNotifier.state = twoFactorNotifier.state.copyWith(
            confirmMessage: '2FA enabled.',
          );
          return '2FA enabled.';
        };

        final router = _router(home: const TwoFactorPage());

        await tester.pumpWidget(
          TestRouterApp(
            router: router,
            overrides: [
              authProvider.overrideWith((ref) => authNotifier),
              twoFactorProvider.overrideWith((ref) => twoFactorNotifier),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Enroll'));
        await tester.pumpAndSettle();

        expect(enrollCalled, 1);
        expect(find.byType(ProvisioningQrCard), findsOneWidget);

        final confirmButtonBefore = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Confirm 2FA'),
        );
        expect(confirmButtonBefore.onPressed, isNull);

        await tester.enterText(find.byType(TextField), '123456');
        await tester.pump();

        final confirmButtonAfter = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Confirm 2FA'),
        );
        expect(confirmButtonAfter.onPressed, isNotNull);

        await tester.tap(find.text('Confirm 2FA'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(confirmedCode, '123456');
        expect(find.text('2FA enabled.'), findsWidgets);
      },
    );

    testWidgets('challenge mode verifies code and routes to dashboard', (
      tester,
    ) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authNotifier = _MockAuthNotifier(
        const AuthState(
          mfaRequired: true,
          mfaChallengeToken: 'challenge-token',
        ),
      );
      final twoFactorNotifier = _MockTwoFactorNotifier();
      String? verifiedCode;

      authNotifier.onVerifyMfa = (code) async {
        verifiedCode = code;
        authNotifier.state = AuthState(
          isAuthenticated: true,
          user: _user(role: 'participant'),
        );
        return 'participant';
      };

      final router = _router(home: const TwoFactorPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authProvider.overrideWith((ref) => authNotifier),
            twoFactorProvider.overrideWith((ref) => twoFactorNotifier),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Enter the 6-digit code to finish signing in.'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), '654321');
      await tester.pump();
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      expect(verifiedCode, '654321');
      expect(find.text('Participant Dashboard'), findsOneWidget);
    });

    testWidgets('code field uses one-time-code autofill hints', (tester) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authNotifier = _MockAuthNotifier(
        const AuthState(
          mfaRequired: true,
          mfaChallengeToken: 'challenge-token',
        ),
      );

      final router = _router(home: const TwoFactorPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authProvider.overrideWith((ref) => authNotifier),
            twoFactorProvider.overrideWith((ref) => _MockTwoFactorNotifier()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofillHints, const [AutofillHints.oneTimeCode]);
    });

    testWidgets(
      'challenge mode back clears MFA state and respects return route',
      (tester) async {
        _setSurfaceSize(tester);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final authNotifier = _MockAuthNotifier(
          const AuthState(
            mfaRequired: true,
            mfaChallengeToken: 'challenge-token',
          ),
        );
        var clearCalled = 0;
        authNotifier.onClearMfaChallenge = () {
          clearCalled += 1;
        };

        final router = _router(home: const TwoFactorPage(returnTo: '/consent'));

        await tester.pumpWidget(
          TestRouterApp(
            router: router,
            overrides: [
              authProvider.overrideWith((ref) => authNotifier),
              twoFactorProvider.overrideWith((ref) => _MockTwoFactorNotifier()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Back'));
        await tester.pumpAndSettle();

        expect(clearCalled, 1);
        expect(find.text('Consent Page'), findsOneWidget);
      },
    );

    testWidgets(
      'challenge mode routes to consent when MFA succeeds without signed consent',
      (tester) async {
        _setSurfaceSize(tester);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final authNotifier = _MockAuthNotifier(
          const AuthState(
            mfaRequired: true,
            mfaChallengeToken: 'challenge-token',
          ),
        );

        authNotifier.onVerifyMfa = (code) async {
          authNotifier.state = AuthState(
            isAuthenticated: true,
            user: _user(role: 'participant', hasSignedConsent: false),
            hasSignedConsent: false,
          );
          return 'participant';
        };

        final router = _router(home: const TwoFactorPage());

        await tester.pumpWidget(
          TestRouterApp(
            router: router,
            overrides: [
              authProvider.overrideWith((ref) => authNotifier),
              twoFactorProvider.overrideWith((ref) => _MockTwoFactorNotifier()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '123456');
        await tester.pump();
        await tester.tap(find.text('Verify'));
        await tester.pumpAndSettle();

        expect(find.text('Consent Page'), findsOneWidget);
      },
    );
  });
}
