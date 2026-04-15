// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_icon_badge.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppIconBadge', () {
    testWidgets('renders the requested icon by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIconBadge(icon: Icons.star),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders child instead of icon when child is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIconBadge(
          icon: Icons.star,
          child: Text('AB'),
        ),
      ));

      expect(find.text('AB'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('uses the provided size and radius', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIconBadge(
          icon: Icons.star,
          size: 60,
          radius: 16,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;

      expect(tester.getSize(find.byType(Container)), const Size(60, 60));
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('applies the provided icon size and color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIconBadge(
          icon: Icons.star,
          color: AppTheme.error,
          iconSize: 26,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 26);
      expect(icon.color, AppTheme.error);
    });

    testWidgets('uses low alpha background tint from the color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIconBadge(
          icon: Icons.star,
          color: AppTheme.success,
          alpha: 0.2,
        ),
      ));

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.success.withValues(alpha: 0.2));
    });
  });
}
