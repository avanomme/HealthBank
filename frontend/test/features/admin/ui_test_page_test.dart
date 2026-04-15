import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/features/admin/admin.dart';

import '../../test_helpers.dart';

final _uiTestPageOverrides = <Override>[
  accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
  deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
];

void main() {
  testWidgets('UiTestPage renders without assertion errors', (tester) async {
    await tester.pumpWidget(buildTestPage(
      const UiTestPage(),
      overrides: _uiTestPageOverrides,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(UiTestPage), findsOneWidget);
  });

  testWidgets('UiTestPage scrolls past AppGraphRenderer to the bottom sections',
      (tester) async {
    await tester.pumpWidget(buildTestPage(
      const UiTestPage(),
      overrides: _uiTestPageOverrides,
    ));
    await tester.pumpAndSettle();

    final listScrollable = find.descendant(
      of: find.byKey(const Key('ui_test_page_list')),
      matching: find.byType(Scrollable),
    ).first;

    // Scroll to AppGraphRenderer (chart section — verifies chart doesn't block scrolling)
    await tester.scrollUntilVisible(
      find.text('AppGraphRenderer'),
      300,
      scrollable: listScrollable,
      maxScrolls: 150,
    );
    await tester.pumpAndSettle();
    expect(find.text('AppGraphRenderer'), findsOneWidget);

    // Continue scrolling to the last section (AppPlaceholderGraphic)
    await tester.scrollUntilVisible(
      find.text('AppPlaceholderGraphic'),
      300,
      scrollable: listScrollable,
      maxScrolls: 150,
    );
    await tester.pumpAndSettle();
    expect(find.text('AppPlaceholderGraphic'), findsOneWidget);
  });

  testWidgets('UiTestPage can keep scrolling when dragging over chart demos',
      (tester) async {
    await tester.pumpWidget(buildTestPage(
      const UiTestPage(),
      overrides: _uiTestPageOverrides,
    ));
    await tester.pumpAndSettle();

    final contentScrollable = find.descendant(
      of: find.byKey(const Key('ui_test_page_list')),
      matching: find.byType(Scrollable),
    ).first;

    await tester.scrollUntilVisible(
      find.text('AppBarChart'),
      300,
      scrollable: contentScrollable,
    );
    await tester.pumpAndSettle();

    final before = tester.getTopLeft(find.text('AppBarChart')).dy;

    await tester.ensureVisible(find.byType(AppBarChart));
    await tester.pumpAndSettle();

    final chartCenter = tester.getRect(find.byType(AppBarChart)).center;
    await tester.dragFrom(chartCenter, const Offset(0, -200));
    await tester.pumpAndSettle();

    final after = tester.getTopLeft(find.text('AppBarChart')).dy;

    expect(after, lessThan(before));
  });
}
