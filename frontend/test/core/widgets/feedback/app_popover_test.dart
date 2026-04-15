// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_popover.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppPopover', () {
    testWidgets('renders message text and optional icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Enter a valid email address.',
          icon: Icon(Icons.info_outline),
        ),
      ));

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('renders arrow above content by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(message: 'Popover'),
      ));

      final column = tester.widget<Column>(
        find.descendant(of: find.byType(AppPopover), matching: find.byType(Column)),
      );
      expect(column.children.length, 2);
    });

    testWidgets('renders arrow below content when arrowOnTop is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          arrowOnTop: false,
        ),
      ));

      final aligns = tester.widgetList<Align>(
        find.descendant(of: find.byType(AppPopover), matching: find.byType(Align)),
      );
      expect(aligns.length, 1);
    });

    testWidgets('applies color and border overrides', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          backgroundColor: AppTheme.info,
          borderColor: AppTheme.error,
          textColor: AppTheme.white,
        ),
      ));

      final material = tester.widget<Material>(
        find.descendant(of: find.byType(AppPopover), matching: find.byType(Material)),
      );
      final decoratedBox = tester.widget<DecoratedBox>(
        find.descendant(of: find.byType(AppPopover), matching: find.byType(DecoratedBox)),
      );
      final text = tester.widget<Text>(find.text('Popover'));

      expect(material.color, AppTheme.info);
      expect((decoratedBox.decoration as BoxDecoration).border, isNotNull);
      expect(text.style?.color, AppTheme.white);
    });

    testWidgets('supports semantics label exclusion', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          semanticLabel: 'Popover help',
          excludeFromSemantics: true,
        ),
      ));

      expect(
        find.descendant(
          of: find.byType(AppPopover),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    });

    testWidgets('exposes a semantics label when not excluded',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          semanticLabel: 'Popover help',
        ),
      ));

      expect(
        find.descendant(
          of: find.byType(AppPopover),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Popover help',
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses custom arrow size for the caret painter',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          arrowSize: 12,
        ),
      ));

      expect(
        find.descendant(
          of: find.byType(AppPopover),
          matching: find.byWidgetPredicate(
            (widget) => widget is CustomPaint && widget.size == const Size(24, 12),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('omits the border wrapper for a transparent border color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPopover(
          message: 'Popover',
          borderColor: Colors.transparent,
        ),
      ));

      expect(
        find.descendant(
          of: find.byType(AppPopover),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });
  });
}
