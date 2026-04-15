// Created with the Assistance of Codex
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';

class MockAuthNotifier extends StateNotifier<AuthState>
    with Mock
    implements AuthNotifier {
  MockAuthNotifier([AuthState? initial]) : super(initial ?? const AuthState());

  @override
  void clearMustChangePassword() {
    state = state.copyWith(mustChangePassword: false);
  }

  @override
  void clearNeedsProfileCompletion() {
    state = state.copyWith(needsProfileCompletion: false);
  }

  @override
  void markConsentSigned() {
    state = state.copyWith(hasSignedConsent: true);
  }

  @override
  Future<void> logout() async {
    state = const AuthState();
  }

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<String?> verifyMfa(String code) async => null;
}

class FakeAuthApi implements AuthApi {
  FakeAuthApi({
    this.onConfirmPasswordReset,
    this.onChangePassword,
    this.onCompleteProfile,
  });

  Future<MessageResponse> Function(PasswordResetConfirmRequest request)?
  onConfirmPasswordReset;
  Future<MessageResponse> Function(ChangePasswordRequest request)?
  onChangePassword;
  Future<MessageResponse> Function(ProfileCompleteRequest request)?
  onCompleteProfile;

  @override
  Future<MessageResponse> confirmPasswordReset(
    PasswordResetConfirmRequest request,
  ) async {
    return onConfirmPasswordReset?.call(request) ??
        const MessageResponse(message: 'ok');
  }

  @override
  Future<MessageResponse> changePassword(ChangePasswordRequest request) async {
    return onChangePassword?.call(request) ??
        const MessageResponse(message: 'ok');
  }

  @override
  Future<MessageResponse> completeProfile(
    ProfileCompleteRequest request,
  ) async {
    return onCompleteProfile?.call(request) ??
        const MessageResponse(message: 'ok');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<dynamic> login(LoginRequest request) => throw UnimplementedError();

  @override
  Future<dynamic> verify2fa(Verify2FARequest request) =>
      throw UnimplementedError();

  @override
  Future<SessionMeResponse> getSessionInfo() => throw UnimplementedError();

  @override
  Future<MessageResponse> requestPasswordReset(
    PasswordResetEmailRequest request,
  ) => throw UnimplementedError();

  @override
  Future<dynamic> getPublicConfig() async => {'registration_open': true};

  @override
  Future<MessageResponse> submitAccountRequest(AccountRequestCreate request) =>
      throw UnimplementedError();

  @override
  Future<void> requestAccountDeletion() => throw UnimplementedError();
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
        path: '/forgot-password',
        builder: (_, __) => const Scaffold(body: Text('Forgot Password Page')),
      ),
      GoRoute(
        path: '/participant/dashboard',
        builder: (_, __) => const Scaffold(body: Text('Participant Dashboard')),
      ),
      GoRoute(
        path: '/consent',
        builder: (_, __) => const Scaffold(body: Text('Consent Page')),
      ),
    ],
  );
}

void _setSurfaceSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1.0;
}

void main() {
  group('ResetPasswordPage', () {
    testWidgets('uses new-password autofill hints for reset fields', (
      tester,
    ) async {
      final router = _router(
        home: const ResetPasswordPage(token: 'reset-token'),
      );

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(fields[0].autofillHints, const [AutofillHints.newPassword]);
      expect(fields[1].autofillHints, const [AutofillHints.newPassword]);
    });

    testWidgets('shows invalid token state when token is missing', (
      tester,
    ) async {
      final router = _router(home: const ResetPasswordPage());

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Invalid Reset Link'), findsOneWidget);

      await tester.tap(find.text('Back to Login'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });

    testWidgets('submits new password and shows success state', (tester) async {
      PasswordResetConfirmRequest? captured;
      final router = _router(
        home: const ResetPasswordPage(token: 'reset-token'),
      );

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authApiProvider.overrideWithValue(
              FakeAuthApi(
                onConfirmPasswordReset: (request) async {
                  captured = request;
                  return const MessageResponse(message: 'ok');
                },
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'newpassword');
      await tester.enterText(find.byType(TextFormField).last, 'newpassword');
      await tester.tap(find.text('Reset Password').last);
      await tester.pumpAndSettle();

      expect(captured?.token, 'reset-token');
      expect(captured?.newPassword, 'newpassword');
      expect(find.text('Password Reset Successful'), findsOneWidget);
      expect(
        find.text('Your password has been successfully reset.'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when reset submission fails', (tester) async {
      final router = _router(
        home: const ResetPasswordPage(token: 'reset-token'),
      );

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authApiProvider.overrideWithValue(
              FakeAuthApi(
                onConfirmPasswordReset: (request) async {
                  throw Exception('bad token');
                },
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'newpassword');
      await tester.enterText(find.byType(TextFormField).last, 'newpassword');
      await tester.tap(find.text('Reset Password').last);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'This password reset link is invalid or has expired. Please request a new one.',
        ),
        findsOneWidget,
      );
    });
  });

  group('ChangePasswordPage', () {
    testWidgets('uses password autofill hints for current and new passwords', (
      tester,
    ) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authNotifier = MockAuthNotifier(
        AuthState(
          isAuthenticated: true,
          user: _user(role: 'participant', mustChangePassword: true),
        ),
      );
      final router = _router(home: const ChangePasswordPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [authProvider.overrideWith((ref) => authNotifier)],
        ),
      );
      await tester.pumpAndSettle();

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(fields[0].autofillHints, const [AutofillHints.password]);
      expect(fields[1].autofillHints, const [AutofillHints.newPassword]);
      expect(fields[2].autofillHints, const [AutofillHints.newPassword]);
    });

    testWidgets('submits and routes to participant dashboard on success', (
      tester,
    ) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ChangePasswordRequest? captured;
      final authNotifier = MockAuthNotifier(
        AuthState(
          isAuthenticated: true,
          user: _user(role: 'participant', mustChangePassword: true),
        ),
      );
      final router = _router(home: const ChangePasswordPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authProvider.overrideWith((ref) => authNotifier),
            authApiProvider.overrideWithValue(
              FakeAuthApi(
                onChangePassword: (request) async {
                  captured = request;
                  return const MessageResponse(message: 'ok');
                },
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'oldpassword');
      await tester.enterText(fields.at(1), 'newpassword');
      await tester.enterText(fields.at(2), 'newpassword');
      await tester.ensureVisible(find.text('Change Password').last);
      await tester.tap(find.text('Change Password').last);
      await tester.pumpAndSettle();

      expect(captured?.currentPassword, 'oldpassword');
      expect(captured?.newPassword, 'newpassword');
      expect(find.text('Participant Dashboard'), findsOneWidget);
      expect(authNotifier.state.mustChangePassword, isFalse);
    });

    testWidgets('shows incorrect password error from API exception', (
      tester,
    ) async {
      _setSurfaceSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authNotifier = MockAuthNotifier(
        AuthState(
          isAuthenticated: true,
          user: _user(role: 'participant', mustChangePassword: true),
        ),
      );
      final router = _router(home: const ChangePasswordPage());

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            authProvider.overrideWith((ref) => authNotifier),
            authApiProvider.overrideWithValue(
              FakeAuthApi(
                onChangePassword: (request) async {
                  throw DioException(
                    requestOptions: RequestOptions(
                      path: '/auth/change_password',
                    ),
                    error: ApiException(message: 'nope', statusCode: 401),
                  );
                },
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'wrong');
      await tester.enterText(fields.at(1), 'newpassword');
      await tester.enterText(fields.at(2), 'newpassword');
      await tester.ensureVisible(find.text('Change Password').last);
      await tester.tap(find.text('Change Password').last);
      await tester.pumpAndSettle();

      expect(find.text('Current password is incorrect'), findsOneWidget);
    });
  });
}
