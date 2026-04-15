// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_overlay.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppOverlay', () {
    testWidgets('renders a non-dismissible modal barrier', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(),
      ));

      final barrier = tester.widget<ModalBarrier>(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(ModalBarrier),
        ),
      );
      expect(barrier.dismissible, isFalse);
    });

    testWidgets('renders child content above the barrier', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(child: Text('Overlay content')),
      ));

      expect(find.text('Overlay content'), findsOneWidget);
    });

    testWidgets('uses the provided barrier color and opacity', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(
          barrierColor: AppTheme.error,
          barrierOpacity: 0.3,
        ),
      ));

      final barrier = tester.widget<ModalBarrier>(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(ModalBarrier),
        ),
      );
      expect(barrier.color, AppTheme.error.withValues(alpha: 0.3));
    });

    testWidgets('expands to fill available space', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(),
      ));

      expect(find.byType(SizedBox), findsOneWidget);
      expect(tester.getSize(find.byType(SizedBox)).width, greaterThan(0));
    });

    testWidgets('does not render extra content when child is null',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(),
      ));

      expect(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(ModalBarrier),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses the default black barrier color and opacity',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(),
      ));

      final barrier = tester.widget<ModalBarrier>(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(ModalBarrier),
        ),
      );
      expect(barrier.color, AppTheme.black.withValues(alpha: 0.45));
    });

    testWidgets('keeps barrier behind child content in the stack',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(child: Text('Overlay content')),
      ));

      final stack = tester.widget<Stack>(
        find.descendant(of: find.byType(AppOverlay), matching: find.byType(Stack)),
      );
      expect(stack.children.first, isA<ModalBarrier>());
      expect(stack.children.last, isA<FocusTraversalGroup>());
    });

    testWidgets('supports a fully transparent custom barrier', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOverlay(
          barrierColor: AppTheme.error,
          barrierOpacity: 0,
        ),
      ));

      final barrier = tester.widget<ModalBarrier>(
        find.descendant(
          of: find.byType(AppOverlay),
          matching: find.byType(ModalBarrier),
        ),
      );
      expect(barrier.color, AppTheme.error.withValues(alpha: 0));
    });
  });
}
