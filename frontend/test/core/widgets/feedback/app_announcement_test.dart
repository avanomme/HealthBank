// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_announcement.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppAnnouncement', () {
    testWidgets('renders the message text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppAnnouncement(message: 'System maintenance tonight'),
        ),
      );

      expect(find.text('System maintenance tonight'), findsOneWidget);
    });

    testWidgets('renders a leading icon when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppAnnouncement(
            message: 'System maintenance tonight',
            icon: Icon(Icons.info_outline),
          ),
        ),
      );

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          AppAnnouncement(message: 'Tap me', onTap: () => taps++),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('does not wrap content in InkWell when onTap is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const AppAnnouncement(message: 'Read only')),
      );

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('applies background and border color overrides', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppAnnouncement(
            message: 'Styled',
            backgroundColor: AppTheme.error,
            borderColor: AppTheme.white,
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(decoration.color, AppTheme.error);
      expect((decoration.border as Border).top.color, AppTheme.white);
    });

    testWidgets('exposes live announcement semantics', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppAnnouncement(message: 'System maintenance tonight'),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'System maintenance tonight',
        ),
        findsOneWidget,
      );
    });
  });
}
