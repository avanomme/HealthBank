import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/public/public_pages.dart';

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );
  }
}

void main() {
  setUp(() {
    authChangeNotifier.update(isAuthenticated: false, sessionReady: false);
  });

  group('GoRouter configuration', () {
    testWidgets('initial route is HomePage at / while session is not ready', (tester) async {
      await tester.pumpWidget(const _TestApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('forgot password route is accessible when unauthenticated', (tester) async {
      authChangeNotifier.update(isAuthenticated: false, sessionReady: true);

      await tester.pumpWidget(const _TestApp());
      await tester.pumpAndSettle();

      appRouter.go(AppRoutes.forgotPassword);
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });

    testWidgets('protected admin route redirects to login when unauthenticated',
        (tester) async {
      authChangeNotifier.update(isAuthenticated: false, sessionReady: true);

      await tester.pumpWidget(const _TestApp());
      await tester.pumpAndSettle();

      appRouter.go(AppRoutes.admin);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    test('dashboard route helper returns expected routes', () {
      expect(getDashboardRouteForRole('participant'), AppRoutes.participantDashboard);
      expect(getDashboardRouteForRole('researcher'), AppRoutes.researcherDashboard);
      expect(getDashboardRouteForRole('hcp'), AppRoutes.hcpDashboard);
      expect(getDashboardRouteForRole('admin'), AppRoutes.admin);
      expect(getDashboardRouteForRole('unknown'), isNull);
    });
  });
}
