// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/state/locale_provider.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';

import '../../../test_helpers.dart';

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(super.ref, AuthState initialState) {
    state = initialState;
  }
}

class _TestLocaleNotifier extends LocaleNotifier {
  _TestLocaleNotifier(super.ref, Locale initialLocale) {
    state = initialLocale;
  }

  @override
  Future<void> setLocale(Locale locale) async {
    state = locale;
  }
}

Widget _buildHeaderTestWidget(
  Header header, {
  double width = 1200,
  List<Override>? overrides,
}) {
  return buildTestWidget(
    Center(
      child: SizedBox(
        width: width,
        child: header,
      ),
    ),
    overrides: overrides,
  );
}

void main() {
  const navItems = [
    NavItem(label: 'Home', route: '/home'),
    NavItem(label: 'Dashboard', route: '/dashboard'),
    NavItem(label: 'Reports', route: '/reports', badge: 1),
  ];

  AuthState authenticatedState() {
    return const AuthState(
      isAuthenticated: true,
      user: LoginResponse(
        expiresAt: '2099-01-01T00:00:00Z',
        accountId: 7,
        firstName: 'Alex',
        lastName: 'Tester',
        email: 'alex@example.com',
        role: 'researcher',
      ),
    );
  }

  group('Header', () {
    testWidgets('renders desktop navigation and fires nav callback',
        (tester) async {
      String? tappedRoute;
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          currentRoute: '/reports',
          onNavItemTap: (route) => tappedRoute = route,
          onLogoTap: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu), findsNothing);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Bank'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);

      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      expect(tappedRoute, '/dashboard');
    });

    testWidgets('renders compact menu and opens built in mobile drawer',
        (tester) async {
      String? tappedRoute;
      tester.view.physicalSize = const Size(700, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          currentRoute: '/dashboard',
          onNavItemTap: (route) => tappedRoute = route,
          onLogoTap: () {},
        ),
        width: 700,
      ));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Menu'), findsOneWidget);
      expect(find.text('Home'), findsNothing);

      await tester.tap(find.byTooltip('Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);

      await tester.tap(find.text('Reports').last);
      await tester.pumpAndSettle();

      expect(tappedRoute, '/reports');
      expect(find.text('Menu'), findsNothing);
    });

    testWidgets('shows language and login actions when logged out',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          onLogoTap: () {},
        ),
        overrides: [
          localeProvider.overrideWith(
            (ref) => _TestLocaleNotifier(ref, const Locale('en')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('EN'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline), findsNothing);
      expect(find.byIcon(Icons.account_circle_outlined), findsNothing);
    });

    testWidgets('shows authenticated actions and notifications callback',
        (tester) async {
      var notificationTaps = 0;
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          onLogoTap: () {},
          onNotificationsTap: () => notificationTaps++,
          hasNotifications: true,
        ),
        overrides: [
          authProvider.overrideWith(
            (ref) => _TestAuthNotifier(ref, authenticatedState()),
          ),
          localeProvider.overrideWith(
            (ref) => _TestLocaleNotifier(ref, const Locale('en')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Log In'), findsNothing);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.minWidth == 8 &&
              widget.constraints?.minHeight == 8,
        ),
        findsWidgets,
      );

      await tester.tap(find.byIcon(Icons.mail_outline));
      await tester.pumpAndSettle();
      expect(notificationTaps, 1);

      await tester.tap(find.byIcon(Icons.account_circle_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Français'), findsOneWidget);
    });

    testWidgets('fires the provided logo callback when tapped',
        (tester) async {
      var logoTaps = 0;
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          onLogoTap: () => logoTaps++,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Health'));
      await tester.pumpAndSettle();

      expect(logoTaps, 1);
    });

    testWidgets('uses the custom menu callback instead of the built in drawer',
        (tester) async {
      var menuTaps = 0;
      tester.view.physicalSize = const Size(550, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          onLogoTap: () {},
          onMenuTap: () => menuTaps++,
        ),
        width: 550,
      ));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Menu'), findsOneWidget);

      await tester.tap(find.byTooltip('Menu'));
      await tester.pumpAndSettle();

      expect(menuTaps, 1);
      expect(find.text('Menu'), findsNothing);
    });

    testWidgets('highlights the active desktop nav item and shows badge dot',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          currentRoute: '/reports',
          onLogoTap: () {},
        ),
      ));
      await tester.pumpAndSettle();

      final reports = tester.widget<Text>(find.text('Reports'));
      expect(reports.style?.color, isNotNull);
      expect(reports.style?.fontWeight, FontWeight.w500);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.minWidth == 8 &&
              widget.constraints?.minHeight == 8,
        ),
        findsWidgets,
      );
    });

    testWidgets('updates the visible language code when logged out language changes',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildHeaderTestWidget(
        Header(
          navItems: navItems,
          onLogoTap: () {},
        ),
        overrides: [
          localeProvider.overrideWith(
            (ref) => _TestLocaleNotifier(ref, const Locale('en')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('EN'), findsOneWidget);

      await tester.tap(find.byTooltip('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Français').last);
      await tester.pumpAndSettle();

      expect(find.text('FR'), findsOneWidget);
      expect(find.text('EN'), findsNothing);
    });
  });
}
