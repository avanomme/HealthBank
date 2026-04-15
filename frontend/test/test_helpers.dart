// Created with the Assistance of Claude Code
// frontend/test/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/state/cookie_consent_provider.dart'
    show CookieConsentNotifier, cookieConsentProvider;
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show publicConfigProvider;

// Default overrides applied to every test widget.
// - publicConfigProvider: prevents MaintenanceBanner from firing real network requests.
// - cookieConsentProvider: simulates consent already given so the cookie banner
//   doesn't obscure widgets under test (the banner is covered by WCAG tests separately).
final _defaultOverrides = <Override>[
  cookieConsentProvider.overrideWith((ref) => CookieConsentNotifier.accepted()),
  publicConfigProvider.overrideWith(
    (ref) async => <String, dynamic>{
      'registration_open': true,
      'maintenance_mode': false,
      'maintenance_message': '',
      'maintenance_completion': '',
    },
  ),
];

/// Test helper to wrap widgets with required providers and MaterialApp
///
/// Use this for testing widgets that need:
/// - MaterialApp context (for navigation, theme, etc.)
/// - Localization support
/// - Riverpod providers
///
/// Example:
/// ```dart
/// testWidgets('renders correctly', (tester) async {
///   await tester.pumpWidget(buildTestWidget(const MyWidget()));
///   expect(find.text('Hello'), findsOneWidget);
/// });
/// ```
Widget buildTestWidget(
  Widget child, {
  List<Override>? overrides,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [..._defaultOverrides, ...?overrides],
    child: MaterialApp(
      theme: AppTheme.defaultTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

/// Test helper to wrap widgets with a full-page scaffold
///
/// Use this when testing pages that expect to be the root of a route
Widget buildTestPage(
  Widget child, {
  List<Override>? overrides,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [..._defaultOverrides, ...?overrides],
    child: MaterialApp(
      theme: AppTheme.defaultTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Test app for router testing
///
/// Wraps a GoRouter in ProviderScope and MaterialApp.router
/// for testing navigation flows
class TestRouterApp extends StatelessWidget {
  final GoRouter router;
  final List<Override>? overrides;
  final Locale locale;

  const TestRouterApp({
    super.key,
    required this.router,
    this.overrides,
    this.locale = const Locale('en'),
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [..._defaultOverrides, ...?overrides],
      child: MaterialApp.router(
        theme: AppTheme.defaultTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}

/// Helper to pump a router and navigate to a location
///
/// Usage:
/// ```dart
/// final router = GoRouter(routes: [...]);
/// await pumpRouterAndGo(tester, router, '/login');
/// expect(find.byType(LoginPage), findsOneWidget);
/// ```
Future<void> pumpRouterAndGo(
  WidgetTester tester,
  GoRouter router,
  String location, {
  List<Override>? overrides,
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(TestRouterApp(
    router: router,
    overrides: overrides,
    locale: locale,
  ));
  await tester.pumpAndSettle();

  router.go(location);
  await tester.pumpAndSettle();
}

/// Extension on WidgetTester for common test operations
extension WidgetTesterExtension on WidgetTester {
  /// Enter text into a TextField by its label
  Future<void> enterTextByLabel(String label, String text) async {
    final field = find.widgetWithText(TextField, label);
    await tap(field);
    await enterText(field, text);
    await pumpAndSettle();
  }

  /// Tap a button by its text
  Future<void> tapButtonByText(String text) async {
    final button = find.widgetWithText(ElevatedButton, text);
    await tap(button);
    await pumpAndSettle();
  }

  /// Tap a text button by its text
  Future<void> tapTextButtonByText(String text) async {
    final button = find.widgetWithText(TextButton, text);
    await tap(button);
    await pumpAndSettle();
  }

  /// Find text and verify it exists
  void expectText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Find text and verify it does not exist
  void expectNoText(String text) {
    expect(find.text(text), findsNothing);
  }
}

/// Common test data constants
class TestData {
  static const validEmail = 'test@example.com';
  static const validPassword = 'password123';
  static const invalidEmail = 'invalid-email';
  static const shortPassword = '123';
  static const userName = 'TestUser';
}

/// Matcher for finding widgets by key
Finder findByKey(String key) => find.byKey(Key(key));

/// Helper to verify a widget is visible on screen
Future<void> expectWidgetVisible(WidgetTester tester, Finder finder) async {
  expect(finder, findsOneWidget);
  final widget = tester.widget(finder);
  expect(widget, isNotNull);
}
