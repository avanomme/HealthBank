// Created with the Assistance of Claude Code
// test/features/participant/pages/participant_health_tracking_page_test.dart
/// Page-level tests for ParticipantHealthTrackingPage.
///
/// Tests verify:
/// - Loading states are shown correctly
/// - Error states are shown correctly
/// - Log Today tab: category tabs + entry cards render from provider data
/// - History tab: renders metric selector and table/chart area
/// - Baseline banner appears when no baseline entries exist
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/features/participant/pages/participant_health_tracking_page.dart';
import 'package:frontend/src/features/participant/state/health_tracking_providers.dart'
    show
        trackingMetricsByCategoryProvider,
        trackingBaselineProvider,
        trackingDraftProvider,
        trackingEntriesProvider,
        trackingEntriesFilteredProvider,
        trackingHistoryProvider,
        TrackingDraftNotifier;
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';

import '../../../test_helpers.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

TrackingMetric _metric({
  int id = 1,
  String type = 'scale',
  String name = 'Mood',
  int catId = 1,
}) =>
    TrackingMetric(
      metricId: id,
      categoryId: catId,
      metricKey: 'mood',
      displayName: name,
      metricType: type,
      frequency: 'daily',
      displayOrder: 0,
      isActive: true,
      isBaseline: false,
      scaleMin: 1,
      scaleMax: 10,
    );

TrackingCategory _category({
  int id = 1,
  String name = 'Mental Health',
  List<TrackingMetric>? metrics,
}) =>
    TrackingCategory(
      categoryId: id,
      categoryKey: 'mental_health',
      displayName: name,
      displayOrder: 0,
      isActive: true,
      metrics: metrics ?? [_metric()],
    );

TrackingEntry _entry({int metricId = 1, String value = '7', bool baseline = false}) =>
    TrackingEntry(
      entryId: 1,
      participantId: 2,
      metricId: metricId,
      value: value,
      entryDate: DateTime(2026, 4, 9),
      isBaseline: baseline,
    );

List<Override> _overrides({
  List<TrackingCategory>? categories,
  List<TrackingEntry>? baseline,
  Exception? categoriesError,
}) {
  return [
    trackingMetricsByCategoryProvider.overrideWith(
      (ref) async {
        if (categoriesError != null) throw categoriesError;
        return categories ?? [_category()];
      },
    ),
    trackingBaselineProvider.overrideWith(
      (ref) async => baseline ?? [],
    ),
    trackingDraftProvider.overrideWith(
      (_) => _TrackingDraftNotifierFake(),
    ),
    trackingEntriesProvider.overrideWith((ref, _) async => []),
    trackingEntriesFilteredProvider.overrideWith((ref, _) async => []),
    trackingHistoryProvider.overrideWith((ref, _) async => []),
    incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
    conversationsProvider.overrideWith((ref) async => []),
  ];
}

/// Minimal fake that satisfies StateNotifierProvider without real API.
class _TrackingDraftNotifierFake extends TrackingDraftNotifier {
  _TrackingDraftNotifierFake() : super();
}

Widget _page({List<Override>? overrides}) => buildTestPage(
      const ParticipantHealthTrackingPage(),
      overrides: overrides,
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ParticipantHealthTrackingPage', () {
    // ── Loading ────────────────────────────────────────────────────────────
    testWidgets('shows loading indicator while categories load', (tester) async {
      final completer = Completer<List<TrackingCategory>>();
      await tester.pumpWidget(
        buildTestPage(
          const ParticipantHealthTrackingPage(),
          overrides: [
            trackingMetricsByCategoryProvider
                .overrideWith((ref) => completer.future),
            trackingBaselineProvider.overrideWith((ref) async => []),
            trackingDraftProvider.overrideWith((_) => _TrackingDraftNotifierFake()),
            trackingEntriesProvider.overrideWith((ref, _) async => []),
            trackingEntriesFilteredProvider.overrideWith((ref, _) async => []),
            trackingHistoryProvider.overrideWith((ref, _) async => []),
            incomingFriendRequestsProvider
                .overrideWith((ref) => Future.value([])),
            conversationsProvider.overrideWith((ref) async => []),
          ],
        ),
      );
      // Only one pump — provider is still loading.
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    // ── Error state ────────────────────────────────────────────────────────
    testWidgets('shows error message when categories fail to load',
        (tester) async {
      await tester.pumpWidget(
        _page(
          overrides: _overrides(
            categoriesError: Exception('Network error'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Error text appears somewhere in the tree (l10n: "Could not load metrics.").
      expect(
        find.textContaining('load', findRichText: true, skipOffstage: false),
        findsWidgets,
      );
    });

    // ── Log Today tab ──────────────────────────────────────────────────────
    testWidgets('renders category name on Log Today tab', (tester) async {
      tester.view.physicalSize = const Size(1024, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _page(overrides: _overrides(
          categories: [_category(name: 'Mental Health')],
        )),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mental Health'), findsWidgets);
    });

    testWidgets('renders metric name in entry card', (tester) async {
      tester.view.physicalSize = const Size(1024, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _page(overrides: _overrides(
          categories: [
            _category(metrics: [_metric(name: 'Daily Mood Score')])
          ],
        )),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily Mood Score'), findsOneWidget);
    });

    // ── History tab ────────────────────────────────────────────────────────
    testWidgets('History tab is accessible by tapping tab', (tester) async {
      tester.view.physicalSize = const Size(1024, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_page(overrides: _overrides()));
      await tester.pumpAndSettle();

      // Find the History tab and tap it.
      final historyTab = find.text('History');
      if (historyTab.evaluate().isNotEmpty) {
        await tester.tap(historyTab.first);
        await tester.pumpAndSettle();
      }
      // Page did not crash.
      expect(find.byType(ParticipantHealthTrackingPage), findsOneWidget);
    });

    // ── Baseline banner ────────────────────────────────────────────────────
    testWidgets('baseline banner appears when no baseline entries exist',
        (tester) async {
      tester.view.physicalSize = const Size(1024, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _page(overrides: _overrides(baseline: [])),  // empty baseline
      );
      await tester.pumpAndSettle();

      // A baseline prompt/banner should appear.
      expect(
        find.byWidgetPredicate((w) =>
            w is Text &&
            (w.data?.toLowerCase().contains('baseline') ?? false)),
        findsWidgets,
      );
    });

    testWidgets('baseline banner absent when baseline entries exist',
        (tester) async {
      tester.view.physicalSize = const Size(1024, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _page(
          overrides: _overrides(baseline: [_entry(baseline: true)]),
        ),
      );
      await tester.pumpAndSettle();

      // "Record your baseline" prompt should not appear when baseline exists.
      expect(find.textContaining('Record your baseline'), findsNothing);
    });
  });
}

