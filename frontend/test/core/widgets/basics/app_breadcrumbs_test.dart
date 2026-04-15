// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_breadcrumbs.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppBreadcrumbs', () {
    testWidgets('renders nothing for an empty item list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(items: []),
      ));

      expect(find.byType(Wrap), findsNothing);
    });

    testWidgets('renders labels and separators for multiple items',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(
          items: [
            AppBreadcrumbItem(label: 'Home'),
            AppBreadcrumbItem(label: 'Settings'),
          ],
        ),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('treats the last item as active by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(
          items: [
            AppBreadcrumbItem(label: 'Home'),
            AppBreadcrumbItem(label: 'Settings'),
          ],
        ),
      ));

      final home = tester.widget<Text>(find.text('Home'));
      final settings = tester.widget<Text>(find.text('Settings'));
      expect(home.style?.fontWeight, FontWeight.w400);
      expect(settings.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('respects explicit active state overrides', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(
          activeColor: AppTheme.error,
          inactiveColor: AppTheme.info,
          items: [
            AppBreadcrumbItem(label: 'Home', isActive: true),
            AppBreadcrumbItem(label: 'Settings', isActive: false),
          ],
        ),
      ));

      final home = tester.widget<Text>(find.text('Home'));
      final settings = tester.widget<Text>(find.text('Settings'));
      expect(home.style?.color, AppTheme.error);
      expect(settings.style?.color, AppTheme.info);
    });

    testWidgets('makes inactive items tappable when onTap is provided',
        (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppBreadcrumbs(
          items: [
            AppBreadcrumbItem(label: 'Home', onTap: () => taps++),
            const AppBreadcrumbItem(label: 'Settings'),
          ],
        ),
      ));

      expect(find.byType(InkWell), findsOneWidget);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('does not render a separator for a single breadcrumb item',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(
          items: [
            AppBreadcrumbItem(label: 'Home'),
          ],
        ),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('/'), findsNothing);
    });

    testWidgets('uses a custom separator and inactive separator color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBreadcrumbs(
          separator: '>',
          inactiveColor: AppTheme.error,
          items: [
            AppBreadcrumbItem(label: 'Home'),
            AppBreadcrumbItem(label: 'Settings'),
          ],
        ),
      ));

      final separator = tester.widget<Text>(find.text('>'));
      expect(separator.style?.color, AppTheme.error);
    });

    testWidgets('does not make an active item tappable even when onTap is provided',
        (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppBreadcrumbs(
          items: [
            AppBreadcrumbItem(
              label: 'Home',
              onTap: () => taps++,
              isActive: true,
            ),
          ],
        ),
      ));

      expect(find.byType(InkWell), findsNothing);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(taps, 0);
    });
  });
}
