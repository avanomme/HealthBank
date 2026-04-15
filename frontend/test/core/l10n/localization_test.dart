// Created with the Assistance of Claude Code
// frontend/test/core/l10n/localization_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/l10n/page_language_sync.dart';

import '../../test_helpers.dart';

void main() {
  group('Localization', () {
    group('AppLocalizations.of(context)', () {
      testWidgets('returns English localizations for en locale', (
        tester,
      ) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return const SizedBox();
              },
            ),
            locale: const Locale('en'),
          ),
        );

        expect(l10n.authLoginButton, 'Log In');
        expect(l10n.commonSubmit, 'Submit');
        expect(l10n.commonCancel, 'Cancel');
      });

      testWidgets('returns French localizations for fr locale', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return const SizedBox();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(l10n.authLoginButton, 'Ouvrir une session');
        expect(l10n.commonSubmit, 'Soumettre');
        expect(l10n.commonCancel, 'Annuler');
      });
    });

    group('context.l10n extension', () {
      testWidgets('provides easy access to localizations', (tester) async {
        late String loginButton;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                loginButton = context.l10n.authLoginButton;
                return Text(loginButton);
              },
            ),
          ),
        );

        expect(find.text('Log In'), findsOneWidget);
      });
    });

    group('Supported locales', () {
      test('supports English (en)', () {
        expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
      });

      test('supports French (fr)', () {
        expect(AppLocalizations.supportedLocales, contains(const Locale('fr')));
      });

      test('has exactly 3 supported locales', () {
        expect(AppLocalizations.supportedLocales.length, 3);
      });
    });

    group('Localization delegates', () {
      test('includes AppLocalizations delegate', () {
        expect(AppLocalizations.localizationsDelegates, isNotEmpty);
      });
    });

    group('Common strings', () {
      testWidgets('commonSubmit is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonSubmit, isNotEmpty);
      });

      testWidgets('commonCancel is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonCancel, isNotEmpty);
      });

      testWidgets('commonSave is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonSave, isNotEmpty);
      });

      testWidgets('commonDelete is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonDelete, isNotEmpty);
      });

      testWidgets('commonEdit is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonEdit, isNotEmpty);
      });

      testWidgets('commonClose is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.commonClose, isNotEmpty);
      });
    });

    group('Auth strings', () {
      testWidgets('authWelcomeTo is localized in English', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('en'),
          ),
        );

        expect(l10n.authWelcomeTo, 'Welcome to HealthBank.');
      });

      testWidgets('authWelcomeTo is localized in French', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(l10n.authWelcomeTo, isNotEmpty);
        expect(l10n.authWelcomeTo, isNot('Welcome to HealthBank.'));
      });

      testWidgets('authPleaseLogIn is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authPleaseLogIn, isNotEmpty);
      });

      testWidgets('authLoginForgotPassword is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authLoginForgotPassword, isNotEmpty);
      });

      testWidgets('authNewHereRequestAccount is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authNewHereRequestAccount, isNotEmpty);
      });
    });

    group('Validation strings', () {
      testWidgets('authEmailRequired is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authEmailRequired, isNotEmpty);
      });

      testWidgets('authEmailInvalid is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authEmailInvalid, isNotEmpty);
      });

      testWidgets('authPasswordRequired is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.authPasswordRequired, isNotEmpty);
      });
    });

    group('Status strings', () {
      testWidgets('statusActive is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.statusActive, isNotEmpty);
      });

      testWidgets('statusPending is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.statusPending, isNotEmpty);
      });

      testWidgets('statusCompleted is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.statusCompleted, isNotEmpty);
      });

      testWidgets('statusInProgress is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.statusInProgress, isNotEmpty);
      });
    });

    group('Error strings', () {
      testWidgets('errorGeneric is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.errorGeneric, isNotEmpty);
      });

      testWidgets('errorNetwork is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.errorNetwork, isNotEmpty);
      });

      testWidgets('errorNotFound is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.errorNotFound, isNotEmpty);
      });

      testWidgets('errorUnauthorized is localized', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.errorUnauthorized, isNotEmpty);
      });
    });

    group('Admin view-as strings', () {
      testWidgets('admin keys exist in English', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('en'),
          ),
        );

        expect(l10n.adminDashboardTitle, 'Admin Dashboard');
        expect(l10n.adminViewAsLabel, 'View As');
        expect(l10n.adminBackToAdmin, 'Back to Admin');
        expect(l10n.adminViewingAsRole('Researcher'), 'Viewing as Researcher');
        expect(
          l10n.adminViewingAsUser('John', 'john@test.com'),
          'Viewing as John (john@test.com)',
        );
        expect(l10n.adminReturnedToDashboard, 'Returned to admin dashboard');
        expect(l10n.adminEndViewAsError, 'Failed to end view-as');
        expect(l10n.adminReturning, 'Returning...');
        expect(l10n.adminWelcomeMessage, isNotEmpty);
        expect(l10n.roleParticipant, 'Participant');
        expect(l10n.roleResearcher, 'Researcher');
        expect(l10n.roleHcp, 'Healthcare Professional');
      });

      testWidgets('admin keys exist in French', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(l10n.adminDashboardTitle, isNotEmpty);
        expect(l10n.adminDashboardTitle, isNot('Admin Dashboard'));
        expect(l10n.adminViewAsLabel, isNotEmpty);
        expect(l10n.adminBackToAdmin, isNotEmpty);
        expect(l10n.adminViewingAsRole('Chercheur'), contains('Chercheur'));
        expect(l10n.roleParticipant, 'Participant');
        expect(l10n.roleResearcher, 'Chercheur');
        expect(l10n.roleHcp, isNotEmpty);
      });

      testWidgets('research data keys exist in French', (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(l10n.researchDataTitle, isNotEmpty);
        expect(l10n.researchDataTitle, isNot('Research Data'));
        expect(l10n.researchSelectSurvey, isNotEmpty);
        expect(l10n.researchNoSurveys, isNotEmpty);
        expect(l10n.researchExportCsv, isNotEmpty);
        expect(l10n.researchOpenEndedNote, isNotEmpty);
      });
    });

    group('Locale switching', () {
      testWidgets('strings change when locale changes', (tester) async {
        // First render with English
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                return Text(context.l10n.authLoginButton);
              },
            ),
            locale: const Locale('en'),
          ),
        );

        expect(find.text('Log In'), findsOneWidget);

        // Re-render with French
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                return Text(context.l10n.authLoginButton);
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(find.text('Ouvrir une session'), findsOneWidget);
        expect(find.text('Log In'), findsNothing);
      });
    });

    group('Accessibility-sensitive localized content', () {
      testWidgets('English instructional strings avoid positional wording', (
        tester,
      ) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('en'),
          ),
        );

        expect(
          l10n.requestAccountSubtitle,
          'Fill out this form to request an account',
        );
        expect(l10n.requestAccountSubtitle, isNot(contains('below')));
        expect(l10n.consentPageSubtitle, isNot(contains('below')));
        expect(l10n.consentSignatureDisclaimer, isNot(contains('below')));
        expect(l10n.consentElectronicSignatureNotice, isNot(contains('below')));
        expect(l10n.dashboardGraphNoSelection, isNot(contains('above')));
        expect(l10n.surveyBuilderSelectFromPanel, isNot(contains('right')));
      });

      testWidgets('French instructional strings avoid positional wording', (
        tester,
      ) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const SizedBox();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        expect(
          l10n.requestAccountSubtitle,
          'Remplissez ce formulaire pour demander un compte',
        );
        expect(l10n.requestAccountSubtitle, isNot(contains('ci-dessous')));
        expect(l10n.consentPageSubtitle, isNot(contains('ci-dessous')));
        expect(l10n.consentSignatureDisclaimer, isNot(contains('ci-dessous')));
        expect(
          l10n.consentElectronicSignatureNotice,
          isNot(contains('ci-dessous')),
        );
        expect(l10n.dashboardGraphNoSelection, isNot(contains('ci-dessus')));
        expect(l10n.surveyBuilderSelectFromPanel, isNot(contains('droite')));
      });
    });

    group('Page language sync', () {
      test('uses the current locale for the page language tag', () {
        expect(pageLanguageTagForLocale(const Locale('en')), 'en');
        expect(pageLanguageTagForLocale(const Locale('fr')), 'fr');

        String? capturedTag;
        syncPageLanguageForLocale(
          const Locale('fr'),
          writer: (tag) => capturedTag = tag,
        );

        expect(capturedTag, 'fr');
      });
    });
  });
}
