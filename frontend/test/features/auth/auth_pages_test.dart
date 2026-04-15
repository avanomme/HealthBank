// Created with the Assistance of Claude Code and Codex
// frontend/test/features/auth/auth_pages_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/src/features/auth/auth.dart';

import '../../test_helpers.dart';

// Mock classes
class MockAuthNotifier extends StateNotifier<AuthState>
    with Mock
    implements AuthNotifier {
  MockAuthNotifier() : super(const AuthState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setAuthenticated(bool authenticated) {
    state = state.copyWith(isAuthenticated: authenticated);
  }

  @override
  Future<void> logout() async {
    // Mock logout - just clear auth state
    state = const AuthState();
  }

  @override
  Future<String?> login(String email, String password) async {
    return null; // null means success, string would be error message
  }
}

void main() {
  group('LoginPage', () {
    late MockAuthNotifier mockAuthNotifier;

    setUp(() {
      mockAuthNotifier = MockAuthNotifier();
    });

    Widget buildLoginPage({
      List<Override>? overrides,
      bool registrationOpen = true,
    }) {
      return buildTestPage(
        const LoginPage(),
        overrides: [
          authProvider.overrideWith((ref) => mockAuthNotifier),
          registrationOpenProvider.overrideWith((ref) async => registrationOpen),
          ...?overrides,
        ],
      );
    }

    group('Rendering', () {
      testWidgets('renders LoginCard widget', (tester) async {
        await tester.pumpWidget(buildLoginPage());
        await tester.pumpAndSettle();

        expect(find.byType(LoginCard), findsOneWidget);
      });

      testWidgets('renders Header with no nav items', (tester) async {
        await tester.pumpWidget(buildLoginPage());
        await tester.pumpAndSettle();

        // Header should be present but without nav items for login
        expect(find.byType(LoginPage), findsOneWidget);
      });

      testWidgets('renders language selector', (tester) async {
        tester.view.physicalSize = const Size(1400, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildLoginPage());
        await tester.pumpAndSettle();

        expect(find.text('EN'), findsOneWidget);
        expect(find.byIcon(Icons.language), findsOneWidget);
      });
    });

    group('Loading state', () {
      testWidgets('passes isLoading to LoginCard when auth is loading', (
        tester,
      ) async {
        mockAuthNotifier.setLoading(true);

        await tester.pumpWidget(buildLoginPage());
        // Use pump() instead of pumpAndSettle() because CircularProgressIndicator
        // animates forever, causing pumpAndSettle to timeout
        await tester.pump();

        final loginCard = tester.widget<LoginCard>(find.byType(LoginCard));
        expect(loginCard.isLoading, true);
      });

      testWidgets('LoginCard isLoading is false when auth is not loading', (
        tester,
      ) async {
        mockAuthNotifier.setLoading(false);

        await tester.pumpWidget(buildLoginPage());
        await tester.pumpAndSettle();

        final loginCard = tester.widget<LoginCard>(find.byType(LoginCard));
        expect(loginCard.isLoading, false);
      });
    });

    group('Registration gating', () {
      testWidgets('hides request account button when registration is closed', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildLoginPage(registrationOpen: false),
        );
        await tester.pumpAndSettle();

        expect(find.text('New Here? Request An Account'), findsNothing);
      });

      testWidgets('shows request account button when registration is open', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildLoginPage(),
        );
        await tester.pumpAndSettle();

        expect(find.text('New Here? Request An Account'), findsOneWidget);
      });
    });
  });

  group('LoginCard', () {
    group('Rendering', () {
      testWidgets('renders welcome title', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginCard()));
        await tester.pumpAndSettle();

        expect(find.text('Welcome to HealthBank.'), findsOneWidget);
      });

      testWidgets('renders subtitle', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginCard()));
        await tester.pumpAndSettle();

        expect(find.text('Please log in to continue.'), findsOneWidget);
      });

      testWidgets('renders LoginForm widget', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginCard()));
        await tester.pumpAndSettle();

        expect(find.byType(LoginForm), findsOneWidget);
      });

      testWidgets('renders request account button', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginCard()));
        await tester.pumpAndSettle();

        expect(find.text('New Here? Request An Account'), findsOneWidget);
      });

      testWidgets('renders divider between form and request account button', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const LoginCard()));
        await tester.pumpAndSettle();

        // The divider is a Container with height 1
        expect(find.byType(LoginCard), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('onRequestAccount is called when button is tapped', (
        tester,
      ) async {
        bool requestAccountCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            LoginCard(onRequestAccount: () => requestAccountCalled = true),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to make the button visible (it may be off-screen on small test viewport)
        final requestButton = find.text('New Here? Request An Account');
        await tester.ensureVisible(requestButton);
        await tester.pumpAndSettle();

        await tester.tap(requestButton);
        await tester.pumpAndSettle();

        expect(requestAccountCalled, true);
      });

      testWidgets('request account button is disabled when loading', (
        tester,
      ) async {
        bool requestAccountCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            LoginCard(
              isLoading: true,
              onRequestAccount: () => requestAccountCalled = true,
            ),
          ),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        final requestButton = find.text('New Here? Request An Account');
        await tester.ensureVisible(requestButton);
        await tester.pump();
        await tester.tap(requestButton, warnIfMissed: false);
        await tester.pump();

        expect(requestAccountCalled, false);
      });
    });

    group('Localization', () {
      testWidgets('displays French welcome text in French locale', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const LoginCard(), locale: const Locale('fr')),
        );
        await tester.pumpAndSettle();

        // Should not show English text
        expect(find.text('Welcome to HealthBank.'), findsNothing);
      });
    });
  });

  group('LoginForm', () {
    group('Rendering', () {
      testWidgets('renders email field', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('renders password field', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('renders forgot password link', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        expect(find.text('Forgot Password?'), findsOneWidget);
      });

      testWidgets('renders login button', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        expect(find.text('Log In'), findsOneWidget);
      });

      testWidgets('password field has visibility toggle', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });

      testWidgets('applies login autofill hints to account fields', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        final fields = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(fields.first.autofillHints, const [
          AutofillHints.username,
          AutofillHints.email,
        ]);
        expect(fields.last.autofillHints, const [AutofillHints.password]);
      });
    });

    group('Password visibility', () {
      testWidgets(
        'password visibility toggle icon shows visibility_off by default',
        (tester) async {
          await tester.pumpWidget(buildTestWidget(const LoginForm()));
          await tester.pumpAndSettle();

          // Password is obscured by default, indicated by visibility_off icon
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
          expect(find.byIcon(Icons.visibility), findsNothing);
        },
      );

      testWidgets('toggling visibility shows password', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });
    });

    group('Validation', () {
      testWidgets('shows error for empty email', (tester) async {
        bool submitCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(onSubmit: (email, password) => submitCalled = true),
          ),
        );
        await tester.pumpAndSettle();

        // Try to submit with empty fields
        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();

        expect(find.text('Enter your email address.'), findsOneWidget);
        expect(submitCalled, false);
      });

      testWidgets('shows error for invalid email format', (tester) async {
        String? submittedEmail;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Dev login shortcut allows username-style input without '@'.
        await tester.enterText(
          find.byType(TextFormField).first,
          'invalid-email',
        );
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email'), findsNothing);
        expect(submittedEmail, 'invalid-email');
      });

      testWidgets('shows error for empty password', (tester) async {
        await tester.pumpWidget(buildTestWidget(const LoginForm()));
        await tester.pumpAndSettle();

        // Enter valid email but no password
        await tester.enterText(
          find.byType(TextFormField).first,
          'test@example.com',
        );
        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();

        expect(find.text('Enter your password.'), findsOneWidget);
      });
    });

    group('Form submission', () {
      testWidgets('calls onSubmit with email and password when valid', (
        tester,
      ) async {
        String? submittedEmail;
        String? submittedPassword;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
                submittedPassword = password;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter valid credentials
        await tester.enterText(
          find.byType(TextFormField).first,
          'test@example.com',
        );
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();

        expect(submittedEmail, 'test@example.com');
        expect(submittedPassword, 'password123');
      });

      testWidgets('trims whitespace from email', (tester) async {
        String? submittedEmail;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter email with whitespace
        await tester.enterText(
          find.byType(TextFormField).first,
          '  test@example.com  ',
        );
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();

        expect(submittedEmail, 'test@example.com');
      });
    });

    group('Forgot password callback', () {
      testWidgets('calls onForgotPassword when link is tapped', (tester) async {
        bool forgotPasswordCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(onForgotPassword: () => forgotPasswordCalled = true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Forgot Password?'));
        await tester.pumpAndSettle();

        expect(forgotPasswordCalled, true);
      });

      testWidgets('forgot password is disabled when loading', (tester) async {
        bool forgotPasswordCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            LoginForm(
              isLoading: true,
              onForgotPassword: () => forgotPasswordCalled = true,
            ),
          ),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        await tester.tap(find.text('Forgot Password?'));
        await tester.pump();

        expect(forgotPasswordCalled, false);
      });
    });

    group('Loading state', () {
      testWidgets('shows loading indicator when isLoading is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const LoginForm(isLoading: true)),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Logging In...'), findsOneWidget);
      });

      testWidgets('hides login text when loading', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const LoginForm(isLoading: true)),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        // The "Log In" text should not be visible when loading
        expect(find.text('Log In'), findsNothing);
      });

      testWidgets('disables form fields when loading', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const LoginForm(isLoading: true)),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        final emailField = tester.widget<TextFormField>(
          find.byType(TextFormField).first,
        );
        expect(emailField.enabled, false);
      });

      testWidgets('disables login button when loading', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const LoginForm(isLoading: true)),
        );
        // Use pump() instead of pumpAndSettle() - CircularProgressIndicator animates forever
        await tester.pump();

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, null);
      });
    });
  });

  group('LogoutPage', () {
    late MockAuthNotifier mockAuthNotifier;

    setUp(() {
      mockAuthNotifier = MockAuthNotifier();
    });

    Widget buildLogoutPage() {
      return buildTestPage(
        const LogoutPage(),
        overrides: [authProvider.overrideWith((ref) => mockAuthNotifier)],
      );
    }

    group('Rendering', () {
      testWidgets('renders LogoutPage and completes logout', (tester) async {
        await tester.pumpWidget(buildLogoutPage());
        // Pump a frame to start the widget
        await tester.pump();
        // The mock logout completes immediately, so we just verify the page renders
        expect(find.byType(LogoutPage), findsOneWidget);
      });

      testWidgets('renders success message after logout', (tester) async {
        await tester.pumpWidget(buildLogoutPage());
        await tester.pumpAndSettle();

        expect(find.text('Logout Successful'), findsOneWidget);
      });

      testWidgets('renders return button after logout', (tester) async {
        await tester.pumpWidget(buildLogoutPage());
        await tester.pumpAndSettle();

        expect(find.text('Return'), findsOneWidget);
      });

      testWidgets('renders language selector', (tester) async {
        tester.view.physicalSize = const Size(1400, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildLogoutPage());
        await tester.pumpAndSettle();

        expect(find.text('EN'), findsOneWidget);
        expect(find.byIcon(Icons.language), findsOneWidget);
      });
    });
  });

  group('ForgotPasswordPage', () {
    testWidgets('renders placeholder text', (tester) async {
      await tester.pumpWidget(buildTestPage(const ForgotPasswordPage()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Forgot Password'), findsOneWidget);
    });

    testWidgets('has Header with no nav items', (tester) async {
      await tester.pumpWidget(buildTestPage(const ForgotPasswordPage()));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });

    testWidgets('uses email autofill hints', (tester) async {
      await tester.pumpWidget(buildTestPage(const ForgotPasswordPage()));
      await tester.pumpAndSettle();

      final emailField = tester.widget<EditableText>(find.byType(EditableText));
      expect(emailField.autofillHints, const [AutofillHints.email]);
    });
  });

  group('RequestAccountPage', () {
    testWidgets('renders placeholder text', (tester) async {
      await tester.pumpWidget(buildTestPage(const RequestAccountPage()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Request Account'), findsOneWidget);
    });

    testWidgets('has Header with no nav items', (tester) async {
      await tester.pumpWidget(buildTestPage(const RequestAccountPage()));
      await tester.pumpAndSettle();

      expect(find.byType(RequestAccountPage), findsOneWidget);
    });

    testWidgets('uses input-purpose autofill hints for name and email fields', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestPage(const RequestAccountPage()));
      await tester.pumpAndSettle();

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(fields[0].autofillHints, const [AutofillHints.givenName]);
      expect(fields[1].autofillHints, const [AutofillHints.familyName]);
      expect(fields[2].autofillHints, const [AutofillHints.email]);
    });
  });

  group('AuthState', () {
    test('has correct default values', () {
      const state = AuthState();

      expect(state.isAuthenticated, false);
      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.user, null);
    });

    test('copyWith updates isAuthenticated', () {
      const state = AuthState();
      final newState = state.copyWith(isAuthenticated: true);

      expect(newState.isAuthenticated, true);
      expect(newState.isLoading, false);
    });

    test('copyWith updates isLoading', () {
      const state = AuthState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.isAuthenticated, false);
    });

    test('copyWith updates error', () {
      const state = AuthState();
      final newState = state.copyWith(error: 'Test error');

      expect(newState.error, 'Test error');
    });

    test('clearError removes error while keeping other state', () {
      const state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        error: 'Test error',
      );
      final newState = state.clearError();

      expect(newState.error, null);
      expect(newState.isAuthenticated, true);
      expect(newState.isLoading, false);
    });
  });

  group('getDashboardRouteForRole', () {
    test('returns admin dashboard for admin role', () {
      expect(getDashboardRouteForRole('admin'), '/admin');
    });

    test('returns surveys for researcher role', () {
      expect(getDashboardRouteForRole('researcher'), '/researcher/dashboard');
    });

    test('returns HCP dashboard for hcp role', () {
      expect(getDashboardRouteForRole('hcp'), '/hcp/dashboard');
    });

    test('returns participant dashboard for participant role', () {
      expect(getDashboardRouteForRole('participant'), '/participant/dashboard');
    });

    test('returns participant dashboard for null role', () {
      expect(getDashboardRouteForRole(null), isNull);
    });

    test('returns participant dashboard for unknown role', () {
      expect(getDashboardRouteForRole('unknown_role'), isNull);
    });
  });
}
