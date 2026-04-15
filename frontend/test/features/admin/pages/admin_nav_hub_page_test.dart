import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/admin/pages/admin_nav_hub_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';

import '../../../test_helpers.dart';

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1800, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
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
      ),
    );
  }
}

void main() {
  final baseOverrides = <Override>[
    accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
    deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
  ];

  group('AdminNavHubPage', () {
    testWidgets('renders grouped route sections and representative cards',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(buildTestPage(
        const AdminNavHubPage(),
        overrides: baseOverrides,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AdminNavHubPage), findsOneWidget);
      expect(find.text('Admin'), findsWidgets);
      expect(find.text('Participant'), findsOneWidget);
      expect(find.text('Researcher'), findsOneWidget);
      expect(find.text('Healthcare Provider'), findsOneWidget);
      expect(find.text('Shared'), findsOneWidget);
      expect(find.text('Public / Auth'), findsOneWidget);

      expect(find.text('Database Viewer'), findsOneWidget);
      expect(find.text('User Management'), findsWidgets);
      expect(find.text('Page Navigator'), findsWidgets);
      expect(find.text('/admin/database'), findsOneWidget);
      expect(find.text('/admin/users'), findsOneWidget);
      expect(find.text('/admin/nav-hub'), findsOneWidget);
    });

    testWidgets('navigates when an admin route card is tapped', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final router = GoRouter(
        initialLocation: AppRoutes.adminNavHub,
        routes: [
          GoRoute(
            path: AppRoutes.adminNavHub,
            builder: (context, state) => const AdminNavHubPage(),
          ),
          GoRoute(
            path: AppRoutes.adminUsers,
            builder: (context, state) => const Scaffold(
              body: Text('Users Destination'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        _RouterTestApp(router: router, overrides: baseOverrides),
      );
      await tester.pumpAndSettle();

      final usersPath = find.text('/admin/users');
      await tester.ensureVisible(usersPath);
      await tester.tap(usersPath);
      await tester.pumpAndSettle();

      expect(find.text('Users Destination'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, AppRoutes.adminUsers);
    });

    testWidgets('navigates when a shared route card is tapped', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final router = GoRouter(
        initialLocation: AppRoutes.adminNavHub,
        routes: [
          GoRoute(
            path: AppRoutes.adminNavHub,
            builder: (context, state) => const AdminNavHubPage(),
          ),
          GoRoute(
            path: AppRoutes.messagesNew,
            builder: (context, state) => const Scaffold(
              body: Text('New Message Destination'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        _RouterTestApp(router: router, overrides: baseOverrides),
      );
      await tester.pumpAndSettle();

      final newMessagePath = find.text(AppRoutes.messagesNew);
      await tester.ensureVisible(newMessagePath);
      await tester.tap(newMessagePath);
      await tester.pumpAndSettle();

      expect(find.text('New Message Destination'), findsOneWidget);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.messagesNew,
      );
    });
  });
}
