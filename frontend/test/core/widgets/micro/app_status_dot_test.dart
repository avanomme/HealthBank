// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_status_dot.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppStatusDot', () {
    Widget baseIcon() => const Icon(Icons.mail, key: Key('mail-icon'));

    testWidgets('returns only the base icon when there is no notification', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(AppStatusDot(icon: baseIcon())));

      expect(find.byKey(const Key('mail-icon')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppStatusDot),
          matching: find.byType(Positioned),
        ),
        findsNothing,
      );
    });

    testWidgets('shows a dot when hasNotification is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(AppStatusDot(icon: baseIcon(), hasNotification: true)),
      );

      expect(find.byKey(const Key('mail-icon')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppStatusDot),
          matching: find.byType(Positioned),
        ),
        findsOneWidget,
      );
    });

    testWidgets('does not render a badge label when notification is enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(AppStatusDot(icon: baseIcon(), hasNotification: true)),
      );

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('uses the provided indicator color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          AppStatusDot(
            icon: baseIcon(),
            hasNotification: true,
            indicatorColor: AppTheme.error,
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(AppStatusDot),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(decoration.color, AppTheme.error);
    });
  });
}
