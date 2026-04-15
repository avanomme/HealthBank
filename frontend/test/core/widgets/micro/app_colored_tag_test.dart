// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_colored_tag.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppColoredTag', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppColoredTag(
          label: 'Urgent',
          color: AppTheme.error,
        ),
      ));

      expect(find.text('Urgent'), findsOneWidget);
    });

    testWidgets('applies the provided text color and background tint',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppColoredTag(
          label: 'Urgent',
          color: AppTheme.error,
          alpha: 0.2,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      final text = tester.widget<Text>(find.text('Urgent'));

      expect(decoration.color, AppTheme.error.withValues(alpha: 0.2));
      expect(text.style?.color, AppTheme.error);
    });

    testWidgets('uses custom padding and radius', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppColoredTag(
          label: 'Urgent',
          color: AppTheme.error,
          radius: 10,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;

      expect(container.padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 6));
      expect(decoration.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('forwards custom font size', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppColoredTag(
          label: 'Urgent',
          color: AppTheme.error,
          fontSize: 18,
        ),
      ));

      final text = tester.widget<Text>(find.text('Urgent'));
      expect(text.style?.fontSize, 18);
    });

    testWidgets('forwards text alignment', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SizedBox(
          width: 100,
          child: AppColoredTag(
            label: 'Urgent',
            color: AppTheme.error,
            textAlign: TextAlign.center,
          ),
        ),
      ));

      final text = tester.widget<Text>(find.text('Urgent'));
      expect(text.textAlign, TextAlign.center);
    });
  });
}
