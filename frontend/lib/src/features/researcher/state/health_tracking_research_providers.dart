// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/state/health_tracking_research_providers.dart
/// Riverpod providers for the researcher health tracking analytics page.
///
/// Provider chain: apiClientProvider → healthTrackingResearchApiProvider → data providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/api/services/health_tracking_api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the HealthTrackingApi Retrofit service.
final healthTrackingResearchApiProvider = Provider<HealthTrackingApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HealthTrackingApi(client.dio);
});

/// Provider for researcher-facing category summary (name, participant count,
/// total entry count).
/// Each map contains: category_id, category_key, display_name,
/// participant_count, entry_count from the backend.
final researchTrackingCategoriesProvider =
    FutureProvider<List<TrackingCategoryStats>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(healthTrackingResearchApiProvider);
  return api.getResearchCategories();
});

/// Provider for all active tracking categories + metrics (same endpoint as
/// participants use) — researcher can call it too to populate the metric
/// deep-dive dropdowns.
final researchTrackingMetricsProvider =
    FutureProvider<List<TrackingCategory>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingResearchApiProvider);
  return api.getMetrics();
});

/// Family provider for aggregate data points for a single metric.
/// The family key bundles metricId, optional startDate, and optional endDate.
final researchTrackingAggregateProvider = FutureProvider.family<
    List<AggregateDataPoint>,
    ({int metricId, String? startDate, String? endDate})>((ref, args) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingResearchApiProvider);
  return api.getAggregate(
    metricId: args.metricId,
    startDate: args.startDate,
    endDate: args.endDate,
  );
});

/// Earliest and latest entry dates in the health tracking data set.
/// Used to default the researcher date range to the full available window.
final researchEntryDateRangeProvider =
    FutureProvider<EntryDateRange>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingResearchApiProvider);
  return api.getEntryDateRange();
});

/// Multi-metric aggregate: one AggregateDataPoint list per requested metric.
/// [metricIds] is a sorted comma-separated string, e.g. "1,2,3",
/// so Riverpod can use structural equality on the record.
final researchMultiAggregateProvider = FutureProvider.family<
    List<MultiAggregateResult>,
    ({String metricIds, String startDate, String endDate})>((ref, args) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingResearchApiProvider);
  return api.getMultiAggregate(
    metricIds: args.metricIds,
    startDate: args.startDate,
    endDate: args.endDate,
  );
});

/// Currently selected metric ID for the deep-dive section. null = none selected.
final selectedResearchMetricProvider = StateProvider<int?>((ref) => null);

/// Currently selected category ID for filtering the metric dropdown.
/// null = show all categories.
final selectedResearchCategoryProvider = StateProvider<int?>((ref) => null);
