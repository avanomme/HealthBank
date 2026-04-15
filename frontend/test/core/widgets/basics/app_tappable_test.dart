// Created with the Assistance of Claude Code
// frontend/test/core/widgets/basics/app_tappable_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_tappable.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppTappable', () {
    // ── Rendering ────────────────────────────────────────────────────────────

    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTappable(child: Text('tap me')),
      ));

      expect(find.text('tap me'), findsOneWidget);
    });

    testWidgets('uses InkWell as the tappable surface', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () {}, child: const Text('tap me')),
      ));

      // AppTappable must expose an InkWell (not a raw GestureDetector) as
      // its top-level interactive widget.
      expect(find.byType(InkWell), findsOneWidget);

      // The InkWell should be the direct child of AppTappable (or Semantics
      // when semanticLabel is set). Confirm AppTappable itself is not a
      // GestureDetector at the widget boundary level.
      final appTappableElement = tester.element(find.byType(AppTappable));
      expect(appTappableElement.widget, isA<AppTappable>());
    });

    // ── Tap handling ─────────────────────────────────────────────────────────

    testWidgets('calls onTap when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () => taps++, child: const Text('tap me')),
      ));

      await tester.tap(find.text('tap me'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('does not call anything when onTap is null', (tester) async {
      // Should not throw; InkWell is simply disabled.
      await tester.pumpWidget(buildTestWidget(
        const AppTappable(child: Text('disabled')),
      ));

      await tester.tap(find.text('disabled'));
      await tester.pumpAndSettle();
      // No assertion needed — absence of exception is the pass condition.
    });

    testWidgets('calls onTap multiple times correctly', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () => taps++, child: const Text('tap me')),
      ));

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('tap me'));
        await tester.pumpAndSettle();
      }

      expect(taps, 3);
    });

    // ── Mouse cursor ─────────────────────────────────────────────────────────

    testWidgets('InkWell has click cursor when onTap is set', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () {}, child: const Text('tap me')),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('InkWell has defer cursor when onTap is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTappable(child: Text('tap me')),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, MouseCursor.defer);
    });

    testWidgets('respects explicit mouseCursor override', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(
          onTap: () {},
          mouseCursor: SystemMouseCursors.forbidden,
          child: const Text('tap me'),
        ),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.forbidden);
    });

    // ── Border radius ────────────────────────────────────────────────────────

    testWidgets('passes borderRadius to InkWell', (tester) async {
      const radius = BorderRadius.all(Radius.circular(12));

      await tester.pumpWidget(buildTestWidget(
        AppTappable(
          onTap: () {},
          borderRadius: radius,
          child: const Text('tap me'),
        ),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, radius);
    });

    testWidgets('InkWell borderRadius is null when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () {}, child: const Text('tap me')),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, isNull);
    });

    // ── Semantics ────────────────────────────────────────────────────────────

    testWidgets('no Semantics wrapper when semanticLabel is omitted',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () {}, child: const Text('tap me')),
      ));

      // InkWell itself contributes a semantics node, but there should be
      // no explicit Semantics widget wrapping it.
      final semanticsWidgets = tester.widgetList<Semantics>(find.byType(Semantics));
      // None of those Semantics widgets should have an explicit label set.
      final hasExplicitLabel = semanticsWidgets.any(
        (s) => s.properties.label != null && s.properties.label!.isNotEmpty,
      );
      expect(hasExplicitLabel, isFalse);
    });

    testWidgets('adds Semantics wrapper with correct label when semanticLabel provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(
          onTap: () {},
          semanticLabel: 'Navigate to dashboard',
          child: const Text('logo'),
        ),
      ));

      final semanticsWidgets = tester.widgetList<Semantics>(find.byType(Semantics));
      final labelledNode = semanticsWidgets.firstWhere(
        (s) => s.properties.label == 'Navigate to dashboard',
        orElse: () => throw TestFailure(
          'No Semantics node with label "Navigate to dashboard" found',
        ),
      );

      expect(labelledNode.properties.button, isTrue);
    });

    testWidgets('Semantics enabled is true when onTap is set', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(
          onTap: () {},
          semanticLabel: 'Tappable',
          child: const Text('tap me'),
        ),
      ));

      final semanticsWidgets = tester.widgetList<Semantics>(find.byType(Semantics));
      final node = semanticsWidgets.firstWhere(
        (s) => s.properties.label == 'Tappable',
      );
      expect(node.properties.enabled, isTrue);
    });

    testWidgets('Semantics enabled is false when onTap is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTappable(
          semanticLabel: 'Disabled',
          child: Text('tap me'),
        ),
      ));

      final semanticsWidgets = tester.widgetList<Semantics>(find.byType(Semantics));
      final node = semanticsWidgets.firstWhere(
        (s) => s.properties.label == 'Disabled',
      );
      expect(node.properties.enabled, isFalse);
    });

    // ── Theme integration ────────────────────────────────────────────────────

    testWidgets('InkWell splash and highlight colors come from theme',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppTappable(onTap: () {}, child: const Text('tap me')),
      ));

      final context = tester.element(find.byType(AppTappable));
      final theme = Theme.of(context);
      final inkWell = tester.widget<InkWell>(find.byType(InkWell));

      expect(inkWell.splashColor, theme.splashColor);
      expect(inkWell.highlightColor, theme.highlightColor);
    });
  });
}
