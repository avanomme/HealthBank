// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_accordion.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppAccordion', () {
    testWidgets('renders title and hides body by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
        ),
      ));

      expect(find.text('Details'), findsOneWidget);
      final box = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(AppAccordion),
          matching: find.byType(ConstrainedBox),
        ),
      );
      expect(box.constraints.maxHeight, 0);
    });

    testWidgets('shows body when initiallyExpanded is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
          initiallyExpanded: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Additional context'), findsOneWidget);
    });

    testWidgets('toggles body visibility when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
        ),
      ));

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();
      expect(find.text('Additional context'), findsOneWidget);

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();
      final box = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(AppAccordion),
          matching: find.byType(ConstrainedBox),
        ),
      );
      expect(box.constraints.maxHeight, 0);
    });

    testWidgets('fires onChanged with the new expanded state',
        (tester) async {
      final values = <bool>[];

      await tester.pumpWidget(buildTestWidget(
        AppAccordion(
          title: 'Details',
          body: 'Additional context',
          onChanged: values.add,
        ),
      ));

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      expect(values, <bool>[true, false]);
    });

    testWidgets('renders leading icon and uses the provided icon color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
          leadingIcon: Icon(Icons.info_outline),
          iconColor: AppTheme.error,
        ),
      ));

      final iconThemes = tester.widgetList<IconTheme>(
        find.descendant(of: find.byType(AppAccordion), matching: find.byType(IconTheme)),
      );
      expect(iconThemes.any((theme) => theme.data.color == AppTheme.error), isTrue);
      final expandIcon = tester.widget<Icon>(find.byIcon(Icons.expand_more));
      expect(expandIcon.color, AppTheme.error);
    });

    testWidgets('updates expansion state when parent changes initiallyExpanded',
        (tester) async {
      var expanded = false;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => setState(() => expanded = !expanded),
                  child: const Text('Toggle parent'),
                ),
                AppAccordion(
                  title: 'Details',
                  body: 'Additional context',
                  initiallyExpanded: expanded,
                ),
              ],
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Additional context').hitTestable(), findsNothing);

      await tester.tap(find.text('Toggle parent'));
      await tester.pumpAndSettle();

      expect(find.text('Additional context').hitTestable(), findsOneWidget);
    });

    testWidgets('uses the primary color for icons when no override is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
          leadingIcon: Icon(Icons.info_outline),
        ),
      ));

      final iconThemes = tester.widgetList<IconTheme>(
        find.descendant(
          of: find.byType(AppAccordion),
          matching: find.byType(IconTheme),
        ),
      );
      expect(
        iconThemes.any((theme) => theme.data.color == AppTheme.primary),
        isTrue,
      );

      final expandIcon = tester.widget<Icon>(find.byIcon(Icons.expand_more));
      expect(expandIcon.color, AppTheme.primary);
    });

    testWidgets('renders only the expand icon when no leading icon is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppAccordion(
          title: 'Details',
          body: 'Additional context',
        ),
      ));

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });
  });
}
