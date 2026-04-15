// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_card_task.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppCardTask', () {
    testWidgets('renders title, due text, and action label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCardTask(
          title: 'Daily Check-In',
          dueText: 'Due today',
          actionLabel: 'Do Task',
        ),
      ));

      expect(find.text('Daily Check-In'), findsOneWidget);
      expect(find.text('Due today'), findsOneWidget);
      expect(find.text('Do Task'), findsOneWidget);
    });

    testWidgets('renders repeat text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCardTask(
          title: 'Daily Check-In',
          dueText: 'Due today',
          repeatText: 'Repeats every day',
          actionLabel: 'Do Task',
        ),
      ));

      expect(find.text('Repeats every day'), findsOneWidget);
    });

    testWidgets('hides repeat text when omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCardTask(
          title: 'Daily Check-In',
          dueText: 'Due today',
          actionLabel: 'Do Task',
        ),
      ));

      expect(find.text('Repeats every day'), findsNothing);
    });

    testWidgets('fires onAction when the button is tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppCardTask(
          title: 'Daily Check-In',
          dueText: 'Due today',
          actionLabel: 'Do Task',
          onAction: () => taps++,
        ),
      ));

      await tester.tap(find.text('Do Task'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('passes custom action colors to the button', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCardTask(
          title: 'Daily Check-In',
          dueText: 'Due today',
          actionLabel: 'Do Task',
          actionColor: AppTheme.error,
          actionTextColor: AppTheme.white,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(
        button.style!.backgroundColor!.resolve(<WidgetState>{}),
        AppTheme.error,
      );
      expect(
        button.style!.foregroundColor!.resolve(<WidgetState>{}),
        AppTheme.white,
      );
    });
  });
}
