// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppIcon', () {
    testWidgets('renders the requested icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIcon(Icons.alarm),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.alarm));
      expect(icon.icon, Icons.alarm);
    });

    testWidgets('applies explicit size and color overrides', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIcon(
          Icons.info,
          size: 28,
          color: AppTheme.success,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.info));
      expect(icon.size, 28);
      expect(icon.color, AppTheme.success);
    });

    testWidgets('uses the provided semantic label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIcon(
          Icons.mail,
          semanticLabel: 'Messages',
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.mail));
      expect(icon.semanticLabel, 'Messages');
    });

    testWidgets('inherits IconTheme color when no override is given',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const IconTheme(
          data: IconThemeData(color: AppTheme.error),
          child: AppIcon(Icons.warning),
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.warning));
      expect(icon.color, AppTheme.error);
    });

    testWidgets('computes a responsive default size when not specified',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppIcon(Icons.home),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.size, isNotNull);
      expect(icon.size, greaterThan(0));
    });
  });
}
