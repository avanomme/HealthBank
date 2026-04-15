// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/footer.dart';

import '../../../test_helpers.dart';

void main() {
  group('Footer', () {
    testWidgets('renders localized default sections and routes default links',
        (tester) async {
      String? tappedRoute;

      await tester.pumpWidget(buildTestWidget(
        Footer(
          onLinkTap: (route) => tappedRoute = route,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('HealthBank'), findsOneWidget);
      expect(find.text('Help & Services'), findsOneWidget);
      expect(find.text('Legal'), findsOneWidget);
      expect(find.text('How to Use HealthBank'), findsOneWidget);
      expect(find.text('Contact Us'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms of Use'), findsOneWidget);

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();

      expect(tappedRoute, '/privacy-policy');
    });

    testWidgets('renders custom sections and prefers link callbacks',
        (tester) async {
      var directTaps = 0;
      String? routedLink;

      await tester.pumpWidget(buildTestWidget(
        Footer(
          sections: [
            FooterSection(
              title: 'Resources',
              links: [
                FooterLink(
                  label: 'Open Help',
                  onTap: () => directTaps++,
                ),
                const FooterLink(
                  label: 'Go Contact',
                  route: '/contact',
                ),
              ],
            ),
          ],
          onLinkTap: (route) => routedLink = route,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Resources'), findsOneWidget);
      expect(find.text('Open Help'), findsOneWidget);
      expect(find.text('Go Contact'), findsOneWidget);
      expect(find.text('Help & Services'), findsNothing);

      await tester.tap(find.text('Open Help'));
      await tester.pumpAndSettle();
      expect(directTaps, 1);
      expect(routedLink, isNull);

      await tester.tap(find.text('Go Contact'));
      await tester.pumpAndSettle();
      expect(routedLink, '/contact');
    });

    testWidgets('renders localized default sections in French',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Footer(),
        locale: const Locale('fr'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('HealthBank'), findsOneWidget);
      expect(find.text('Aide et services'), findsOneWidget);
      expect(find.text('Mentions légales'), findsOneWidget);
      expect(find.text('Legal'), findsNothing);
      expect(find.text('Politique de confidentialité'), findsOneWidget);
    });

    testWidgets('static default helper sections return expected routes',
        (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ));
      await tester.pumpAndSettle();

      final help = Footer.getDefaultHelpSection(l10n);
      final legal = Footer.getDefaultLegalSection(l10n);

      expect(help.links.map((link) => link.route), ['/help', '/contact']);
      expect(
        legal.links.map((link) => link.route),
        ['/privacy-policy', '/terms-of-service'],
      );
    }, skip: false);

    testWidgets('tapping a link without callback or route is a safe no-op',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Footer(
          sections: [
            FooterSection(
              title: 'Loose Ends',
              links: [
                FooterLink(label: 'No Action'),
              ],
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('No Action'));
      await tester.pumpAndSettle();

      expect(find.text('No Action'), findsOneWidget);
    });

    testWidgets('uses the theme primary background and full width container',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Footer(),
      ));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.color == AppTheme.primary &&
              widget.padding == const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 32,
              ),
        ),
      );

      expect(container.color, AppTheme.primary);
    });

    testWidgets('routes the default help link through onLinkTap',
        (tester) async {
      String? tappedRoute;

      await tester.pumpWidget(buildTestWidget(
        Footer(
          onLinkTap: (route) => tappedRoute = route,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('How to Use HealthBank'));
      await tester.pumpAndSettle();

      expect(tappedRoute, '/help');
    });

    testWidgets('lays out sections with the configured wrap spacing',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Footer(),
      ));
      await tester.pumpAndSettle();

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 64);
      expect(wrap.runSpacing, 24);
    });
  });
}
