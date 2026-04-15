// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_badge.dart';

import '../../../test_helpers.dart';

DecoratedBox badgeBox(WidgetTester tester) =>
    tester.widget<DecoratedBox>(find.byType(DecoratedBox));

Padding badgePadding(WidgetTester tester) =>
    tester.widget<Padding>(find.byType(Padding));

void main() {
  group('AppBadge', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBadge(label: 'Admin'),
      ));

      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('shows leading and trailing widgets when provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBadge(
          label: 'Flagged',
          leading: Icon(Icons.flag),
          trailing: Icon(Icons.close),
        ),
      ));

      expect(find.byIcon(Icons.flag), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('uses variant colors for the primary badge', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBadge(
          label: 'Primary',
          variant: AppBadgeVariant.primary,
        ),
      ));

      final decoration = badgeBox(tester).decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('Primary'));

      expect(decoration.color, AppTheme.primary);
      expect((decoration.border as Border).top.color, AppTheme.primary);
      expect(text.style?.color, AppTheme.textContrast);
    });

    testWidgets('uses caution colors with readable text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBadge(
          label: 'Warning',
          variant: AppBadgeVariant.caution,
        ),
      ));

      final decoration = badgeBox(tester).decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('Warning'));

      expect(decoration.color, AppTheme.caution);
      expect(text.style?.color, AppTheme.textPrimary);
    });

    testWidgets('adjusts padding for the selected size', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBadge(
          label: 'Compact',
          size: AppBadgeSize.small,
        ),
      ));

      expect(
        badgePadding(tester).padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    });
  });
}
