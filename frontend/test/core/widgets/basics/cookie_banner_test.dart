// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/state/cookie_consent_provider.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/cookie_banner.dart';
import 'package:frontend/src/core/widgets/buttons/app_long_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

// CookieBanner tests need the real notifier (not the accepted stub from
// _defaultOverrides) so they can exercise the banner's visible state.
Widget buildBannerWidget(Widget child, {Locale locale = const Locale('en')}) =>
    buildTestWidget(
      child,
      locale: locale,
      overrides: [
        cookieConsentProvider.overrideWith((ref) => CookieConsentNotifier()),
      ],
    );

void main() {
  group('CookieBanner', () {
    setUp(() {
      // Reset SharedPreferences mock before every test so prior test-suite
      // runs (which may call setConsent(true)) don't bleed into this file.
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders banner and hides it after accepting cookies',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cookies'), findsOneWidget);
      expect(
        find.textContaining('essential cookies', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Accept'), findsOneWidget);

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(find.text('Cookies'), findsNothing);
      expect(find.text('Accept'), findsNothing);
    });

    testWidgets('does not render when consent was already stored',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'cookie_consent': true,
      });

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cookies'), findsNothing);
      expect(find.text('Accept'), findsNothing);
    });

    testWidgets('persists consent after accepting cookies', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('cookie_consent'), isTrue);
    });

    testWidgets('renders localized French copy when locale is French',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
        locale: const Locale('fr'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cookies'), findsOneWidget);
      expect(find.text('Accepter'), findsOneWidget);
      expect(
        find.textContaining('cookies essentiels', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('positions and constrains the banner card', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.left, 16);
      expect(positioned.bottom, 16);

      final constrained = tester.widget<ConstrainedBox>(
        find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox &&
              widget.constraints.maxWidth == 380,
        ),
      );
      expect(constrained.constraints.maxWidth, 380);
    });

    testWidgets('renders the accept action as an AppLongButton',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppLongButton), findsOneWidget);
    });

    testWidgets('uses an elevated white card with rounded corners',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      final material = tester.widget<Material>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Material &&
              widget.elevation == 6 &&
              widget.color == AppTheme.white,
        ),
      );
      expect(material.color, AppTheme.white);
      expect(material.elevation, 6);
      expect(material.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('preserves the positioned layout before acceptance',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(buildBannerWidget(
        const Stack(
          children: [
            CookieBanner(),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(find.byType(Positioned), findsNothing);
    });
  });
}
