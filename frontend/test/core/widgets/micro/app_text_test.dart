// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppText', () {
    testWidgets('renders the provided text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppText('Welcome back'),
      ));

      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('applies variant styling', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppText(
          'Heading',
          variant: AppTextVariant.headlineSmall,
        ),
      ));

      final text = tester.widget<Text>(find.text('Heading'));
      expect(text.style?.fontSize, isNotNull);
    });

    testWidgets('applies color, weight, and font style overrides',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppText(
          'Styled',
          color: AppTheme.error,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ));

      final text = tester.widget<Text>(find.text('Styled'));
      expect(text.style?.color, AppTheme.error);
      expect(text.style?.fontWeight, FontWeight.w700);
      expect(text.style?.fontStyle, FontStyle.italic);
    });

    testWidgets('forwards alignment and line wrapping options',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SizedBox(
          width: 80,
          child: AppText(
            'A very long sentence for layout',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ));

      final text = tester.widget<Text>(find.text('A very long sentence for layout'));
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.softWrap, isFalse);
    });

    testWidgets('falls back to a theme style for body text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppText('Body'),
      ));

      final text = tester.widget<Text>(find.text('Body'));
      expect(text.style, isNotNull);
      expect(text.style?.color, isNull);
    });
  });
}
