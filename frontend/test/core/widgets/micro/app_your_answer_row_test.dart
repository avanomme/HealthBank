// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_your_answer_row.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppYourAnswerRow', () {
    testWidgets('renders the label and value in one line', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppYourAnswerRow(
          label: 'Your Answer',
          value: 'Blue',
        ),
      ));

      expect(find.text('Your Answer: Blue'), findsOneWidget);
    });

    testWidgets('shows the person icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppYourAnswerRow(
          label: 'Your Answer',
          value: 'Blue',
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('applies the provided color to icon and text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppYourAnswerRow(
          label: 'Your Answer',
          value: 'Blue',
          color: AppTheme.error,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      final text = tester.widget<Text>(find.text('Your Answer: Blue'));

      expect(icon.color, AppTheme.error);
      expect(text.style?.color, AppTheme.error);
    });

    testWidgets('uses emphasized caption styling', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppYourAnswerRow(
          label: 'Your Answer',
          value: 'Blue',
        ),
      ));

      final text = tester.widget<Text>(find.text('Your Answer: Blue'));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('wraps text in Expanded to avoid overflow', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppYourAnswerRow(
          label: 'Your Answer',
          value: 'A very long answer that should still fit',
        ),
      ));

      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
