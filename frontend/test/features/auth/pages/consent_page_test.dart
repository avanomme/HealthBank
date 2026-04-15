import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/auth/pages/consent_page.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;


class _AuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _AuthNotifier(super.state);

  int markConsentSignedCalls = 0;

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<String?> verifyMfa(String code) async => null;

  @override
  Future<String?> restoreSession() async => null;

  @override
  Future<void> logout() async {}

  @override
  void clearError() {}

  @override
  void clearMfaChallenge() {}

  @override
  void clearMustChangePassword() {}

  @override
  void clearNeedsProfileCompletion() {}

  @override
  void markConsentSigned() {
    markConsentSignedCalls++;
    state = state.copyWith(hasSignedConsent: true);
  }

  @override
  void reset() {}
}

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}

class _RouterTestApp extends StatelessWidget {
  const _RouterTestApp({required this.router, required this.overrides});

  final GoRouter router;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, child) => ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
          child: child!,
        ),
      ),
    );
  }
}

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(ConsentPage));
  return AppLocalizations.of(context);
}

void _drainKnownScrollbarAssertion(WidgetTester tester) {
  Object? error;
  while ((error = tester.takeException()) != null) {
    final message = error.toString();
    if (!message.contains(
      'A ScrollController is required when Scrollbar.thumbVisibility is true',
    )) {
      fail('Unexpected Flutter exception: $error');
    }
  }
}

LoginResponse _userWithRole(String role) {
  return LoginResponse(
    expiresAt: '2099-01-01T00:00:00Z',
    accountId: 1,
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    role: role,
  );
}

void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1920, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _buildPage({
  required _AuthNotifier authNotifier,
  required Dio dio,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) => authNotifier),
      apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
    ],
    child: MaterialApp(
      theme: AppTheme.defaultTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      builder: (context, child) => ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
        child: child!,
      ),
      home: PrimaryScrollController(
        controller: ScrollController(),
        child: const ConsentPage(),
      ),
    ),
  );
}

void main() {
  group('ConsentPage', () {
    testWidgets('renders role-specific title for researcher role',
        (tester) async {
      _useDesktopViewport(tester);
      final authNotifier = _AuthNotifier(
        AuthState(isAuthenticated: true, user: _userWithRole('researcher')),
      );
      final dio = Dio();

      await tester.pumpWidget(_buildPage(authNotifier: authNotifier, dio: dio));
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      final l10n = _l10n(tester);
      expect(find.text(l10n.consentResearcherTitle), findsOneWidget);
    });

    testWidgets('submit button is disabled until signed and agreed',
        (tester) async {
      _useDesktopViewport(tester);
      final authNotifier = _AuthNotifier(
        AuthState(isAuthenticated: true, user: _userWithRole('participant')),
      );
      final dio = Dio();

      await tester.pumpWidget(_buildPage(authNotifier: authNotifier, dio: dio));
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      final submitButton =
          find.widgetWithText(ElevatedButton, _l10n(tester).consentSubmitButton);
      
      ElevatedButton button =
          tester.widget<ElevatedButton>(submitButton);
      expect(button.onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'Test User');
      await tester.pump();
      _drainKnownScrollbarAssertion(tester);

      button = tester.widget<ElevatedButton>(submitButton);
      expect(button.onPressed, isNull);

      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      _drainKnownScrollbarAssertion(tester);

      button = tester.widget<ElevatedButton>(submitButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows generic error when submit fails', (tester) async {
      _useDesktopViewport(tester);
      final authNotifier = _AuthNotifier(
        AuthState(isAuthenticated: true, user: _userWithRole('participant')),
      );
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/consent/submit') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }
            handler.next(options);
          },
        ),
      );

      await tester.pumpWidget(_buildPage(authNotifier: authNotifier, dio: dio));
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      await tester.enterText(find.byType(TextField), 'Test User');
      await tester.ensureVisible(find.byType(Checkbox).first);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();
      _drainKnownScrollbarAssertion(tester);

      final submitButton =
          find.widgetWithText(ElevatedButton, _l10n(tester).consentSubmitButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      final l10n = _l10n(tester);
      expect(find.text(l10n.consentErrorGeneric), findsOneWidget);
    });

    testWidgets('submits consent successfully and navigates to dashboard',
        (tester) async {
      _useDesktopViewport(tester);
      final authNotifier = _AuthNotifier(
        AuthState(isAuthenticated: true, user: _userWithRole('participant')),
      );
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/consent/submit' &&
                options.method.toUpperCase() == 'POST') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {
                    'accepted': true,
                    'version': 'v1',
                    'consent_record_id': 123,
                  },
                ),
              );
              return;
            }
            handler.next(options);
          },
        ),
      );

      final router = GoRouter(
        initialLocation: AppRoutes.consent,
        routes: [
          GoRoute(
            path: AppRoutes.consent,
            builder: (context, state) => PrimaryScrollController(
              controller: ScrollController(),
              child: const ConsentPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.participantDashboard,
            builder: (context, state) => const Scaffold(
              body: Text('Participant Dashboard'),
            ),
          ),
        ],
      );

      final overrides = <Override>[
        authProvider.overrideWith((ref) => authNotifier),
        apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
      ];

      await tester.pumpWidget(_RouterTestApp(router: router, overrides: overrides));
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      await tester.enterText(find.byType(TextField), 'Test User');
      await tester.ensureVisible(find.byType(Checkbox).first);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();
      _drainKnownScrollbarAssertion(tester);

      final submitButton =
          find.widgetWithText(ElevatedButton, _l10n(tester).consentSubmitButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      _drainKnownScrollbarAssertion(tester);

      expect(authNotifier.markConsentSignedCalls, 1);
      expect(find.text('Participant Dashboard'), findsOneWidget);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.participantDashboard,
      );
    });
  });
}
