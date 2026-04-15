// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_modal.dart';
import 'package:frontend/src/core/widgets/basics/app_overlay.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppModal', () {
    testWidgets('renders title, body, and action label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      expect(find.text('Confirm action'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders on top of AppOverlay', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      expect(find.byType(AppOverlay), findsOneWidget);
    });

    testWidgets('fires onClose when action button is tapped',
        (tester) async {
      var closed = 0;

      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () => closed++,
        ),
      ));

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(closed, 1);
    });

    testWidgets('uses a centered modal card layout', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Material), findsWidgets);
    });

    testWidgets('keeps the action button aligned to the end',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      final aligns = tester.widgetList<Align>(
        find.descendant(of: find.byType(AppModal), matching: find.byType(Align)),
      );
      expect(
        aligns.any((align) => align.alignment == Alignment.centerRight),
        isTrue,
      );
    });

    testWidgets('uses the theme surface material with elevation',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      final material = tester.widgetList<Material>(find.byType(Material)).firstWhere(
        (widget) => widget.elevation == 8,
      );
      expect(
        material.color,
        Theme.of(tester.element(find.byType(AppModal))).colorScheme.surface,
      );
    });

    testWidgets('constrains modal width using responsive margins',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: AppModal(
            title: 'Confirm action',
            body: 'This action cannot be undone.',
            actionLabel: 'Confirm',
            onClose: () {},
          ),
        ),
      ));

      final box = tester.widget<ConstrainedBox>(
        find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox &&
              widget.constraints.maxWidth == 1336,
        ),
      );
      expect(box.constraints.maxWidth, 1336);
    });

    testWidgets('renders the primary action through AppFilledButton',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppModal(
          title: 'Confirm action',
          body: 'This action cannot be undone.',
          actionLabel: 'Confirm',
          onClose: () {},
        ),
      ));

      expect(find.byType(AppFilledButton), findsOneWidget);
    });
  });
}
