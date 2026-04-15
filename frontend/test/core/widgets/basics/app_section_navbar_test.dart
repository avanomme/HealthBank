// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_section_navbar.dart';

import '../../../test_helpers.dart';

void main() {
  const overviewSection = AppSectionNavbarSection(
    id: 'overview',
    label: 'Overview',
    destinationId: 'overview',
    children: [
      AppSectionNavbarItem(
        label: 'Metric A',
        destinationId: 'metric-a',
      ),
      AppSectionNavbarItem(
        label: 'Metric B',
        destinationId: 'metric-b',
      ),
    ],
  );

  const collapsedSection = AppSectionNavbarSection(
    id: 'details',
    label: 'Details',
    destinationId: 'details',
    initiallyExpanded: false,
    children: [
      AppSectionNavbarItem(
        label: 'Evidence',
        destinationId: 'evidence',
      ),
    ],
  );

  group('AppSectionNavbar', () {
    testWidgets('renders sections and fires destination callbacks',
        (tester) async {
      String? tappedDestination;

      await tester.pumpWidget(buildTestWidget(
        AppSectionNavbar(
          sections: const [overviewSection],
          activeDestinationId: 'overview',
          onDestinationTap: (id) => tappedDestination = id,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Metric A'), findsOneWidget);
      expect(find.text('Metric B'), findsOneWidget);

      await tester.tap(find.text('Metric B'));
      await tester.pumpAndSettle();
      expect(tappedDestination, 'metric-b');

      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      expect(tappedDestination, 'overview');
    });

    testWidgets('toggles child visibility for collapsible sections',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSectionNavbar(
          sections: const [overviewSection],
          onDestinationTap: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Metric A').hitTestable(), findsOneWidget);

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Metric A').hitTestable(), findsNothing);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Metric A').hitTestable(), findsOneWidget);
    });

    testWidgets('keeps a section with an active child expanded and non collapsible',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSectionNavbar(
          sections: const [collapsedSection],
          activeDestinationId: 'evidence',
          onDestinationTap: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Evidence'), findsOneWidget);

      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('expands a collapsed section when the active child changes',
        (tester) async {
      String? activeDestination;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      activeDestination = 'evidence';
                    });
                  },
                  child: const Text('Activate'),
                ),
                AppSectionNavbar(
                  sections: const [collapsedSection],
                  activeDestinationId: activeDestination,
                  onDestinationTap: (_) {},
                ),
              ],
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Evidence').hitTestable(), findsNothing);

      await tester.tap(find.text('Activate'));
      await tester.pumpAndSettle();

      expect(find.text('Evidence').hitTestable(), findsOneWidget);
    });

    testWidgets('styles the active child differently from inactive children',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSectionNavbar(
          sections: const [overviewSection],
          activeDestinationId: 'metric-a',
          onDestinationTap: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      final active = tester.widget<Text>(find.text('Metric A'));
      final inactive = tester.widget<Text>(find.text('Metric B'));

      expect(active.style?.fontWeight, FontWeight.w600);
      expect(inactive.style?.fontWeight, FontWeight.w500);
      expect(active.style?.color, isNot(inactive.style?.color));
    });

    testWidgets('keeps user collapsed state when rebuilt with the same structure',
        (tester) async {
      var rebuildCount = 0;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      rebuildCount++;
                    });
                  },
                  child: const Text('Rebuild'),
                ),
                Text('$rebuildCount'),
                AppSectionNavbar(
                  sections: const [overviewSection],
                  activeDestinationId: 'overview',
                  onDestinationTap: (_) {},
                ),
              ],
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Metric A').hitTestable(), findsNothing);

      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Metric A').hitTestable(), findsNothing);
    });

    testWidgets('recomputes expansion when section structure changes',
        (tester) async {
      var useExpandedSection = false;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      useExpandedSection = true;
                    });
                  },
                  child: const Text('Swap'),
                ),
                AppSectionNavbar(
                  sections: [
                    if (useExpandedSection)
                      const AppSectionNavbarSection(
                        id: 'replacement',
                        label: 'Replacement',
                        destinationId: 'replacement',
                        children: [
                          AppSectionNavbarItem(
                            label: 'Replacement Child',
                            destinationId: 'replacement-child',
                          ),
                        ],
                      )
                    else
                      collapsedSection,
                  ],
                  onDestinationTap: (_) {},
                ),
              ],
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Evidence').hitTestable(), findsNothing);

      await tester.tap(find.text('Swap'));
      await tester.pumpAndSettle();

      expect(find.text('Replacement Child').hitTestable(), findsOneWidget);
    });

    testWidgets('uses the collapsed icon for initially collapsed sections',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppSectionNavbar(
          sections: const [collapsedSection],
          onDestinationTap: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsNothing);
    });
  });
}
