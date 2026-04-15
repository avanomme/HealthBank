// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_graph_renderer.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppGraphRenderer', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(title: 'Weekly Summary'),
      ));

      expect(find.text('Weekly Summary'), findsOneWidget);
    });

    testWidgets('renders placeholder text when child is null',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          placeholderText: 'Graph placeholder',
        ),
      ));

      expect(find.text('Graph placeholder'), findsOneWidget);
    });

    testWidgets('renders child content when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          child: Text('Graph child'),
        ),
      ));

      expect(find.text('Graph child'), findsOneWidget);
    });

    testWidgets('uses the provided height as min-height for the graph area', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          height: 180,
          child: Text('Graph child'),
        ),
      ));

      expect(
        tester.getSize(find.byType(AppGraphRenderer)).height,
        greaterThanOrEqualTo(180),
      );
    });

    testWidgets('applies custom background and border colors',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          backgroundColor: AppTheme.info,
          borderColor: AppTheme.error,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.info);
      expect((decoration.border as Border).top.color, AppTheme.error);
    });

    testWidgets('uses white background and gray border by default',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(title: 'Weekly Summary'),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.surface);
      expect((decoration.border as Border).top.color, AppTheme.divider);
    });

    testWidgets('uses responsive default height when none is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(500, 800)),
          child: AppGraphRenderer(title: 'Weekly Summary'),
        ),
      ));

      final placeholder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color ==
                AppTheme.placeholder.withValues(alpha: 0.35),
      );
      expect(tester.getSize(placeholder).height, 104);
    });

    testWidgets('applies custom outer padding', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          padding: EdgeInsets.all(24),
        ),
      ));

      final padding = tester.widget<Padding>(
        find.byWidgetPredicate(
          (widget) => widget is Padding && widget.padding == const EdgeInsets.all(24),
        ),
      );
      expect(padding.padding, const EdgeInsets.all(24));
    });

    testWidgets('uses custom placeholder color without child content',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          placeholderColor: AppTheme.info,
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).color == AppTheme.info,
        ),
        findsOneWidget,
      );
    });

    testWidgets('child content renders without placeholder background',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppGraphRenderer(
          title: 'Weekly Summary',
          child: Text('Graph child'),
        ),
      ));

      expect(find.text('Graph child'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).color ==
                  AppTheme.placeholder.withValues(alpha: 0.35),
        ),
        findsNothing,
      );
    });
  });
}
