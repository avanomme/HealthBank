// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/state/health_tracking_providers.dart
/// Riverpod providers for health tracking data.
///
/// Provider chain: apiClientProvider → healthTrackingApiProvider → data providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/api/services/health_tracking_api.dart';
import 'package:frontend/src/core/state/locale_provider.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the HealthTrackingApi Retrofit service.
final healthTrackingApiProvider = Provider<HealthTrackingApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HealthTrackingApi(client.dio);
});

/// Provider for all active tracking categories with their metrics.
/// Re-fetches when session or locale changes.
final trackingMetricsByCategoryProvider =
    FutureProvider<List<TrackingCategory>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return api.getMetrics(lang: lang == 'en' ? null : lang);
});

/// Record type for date-range filter parameters.
typedef _DateRange = ({String? startDate, String? endDate});

/// Provider for tracking entries filtered by optional date range.
final trackingEntriesProvider =
    FutureProvider.family<List<TrackingEntry>, _DateRange>(
        (ref, dateRange) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getEntries(
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Provider for the full entry history of a single metric (by metricId).
final trackingHistoryProvider =
    FutureProvider.family<List<TrackingEntry>, int>((ref, metricId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getHistory(metricId);
});

typedef _EntriesFilter = ({
  String? startDate,
  String? endDate,
  int? metricId,
  String? categoryKey,
});

/// Provider for tracking entries with full filter support (date range + metric/category).
final trackingEntriesFilteredProvider =
    FutureProvider.family<List<TrackingEntry>, _EntriesFilter>(
        (ref, f) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getEntries(
    startDate: f.startDate,
    endDate: f.endDate,
    metricId: f.metricId,
    categoryKey: f.categoryKey,
  );
});

typedef _AggregateFilter = ({
  int metricId,
  String? startDate,
  String? endDate,
});

/// Provider for k-anon population aggregate data for a metric.
/// Allows participants to compare their own data to the population average.
final participantAggregateProvider =
    FutureProvider.family<List<AggregateDataPoint>, _AggregateFilter>(
        (ref, f) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getParticipantAggregate(
    metricId: f.metricId,
    startDate: f.startDate,
    endDate: f.endDate,
  );
});

/// Provider for the participant's baseline tracking entries.
final trackingBaselineProvider =
    FutureProvider<List<TrackingEntry>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getBaseline();
});

/// Provider for today's health check-in completion status.
/// Invalidated automatically after entries are submitted so the dashboard
/// updates without a full page refresh.
final healthCheckInStatusProvider =
    FutureProvider<HealthCheckInStatus>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingApiProvider);
  return api.getCheckInStatus();
});

/// Provider for the currently selected tracking date (e.g. for entry forms).
final selectedTrackingDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider for the index of the currently selected tracking category tab.
final selectedTrackingCategoryProvider = StateProvider<int>((ref) {
  return 0;
});

// ── Draft answers ─────────────────────────────────────────────────────────────

/// Holds the current day's partially-filled metric values (metricId → value).
/// Auto-clears when the calendar date changes so stale drafts never carry over.
class TrackingDraftNotifier extends StateNotifier<({String date, Map<int, String> values})> {
  TrackingDraftNotifier()
      : super((date: _today(), values: {}));

  static String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  /// Returns the live values map, clearing it first if the date has rolled over.
  Map<int, String> get values {
    final today = _today();
    if (state.date != today) {
      state = (date: today, values: {});
    }
    return state.values;
  }

  void set(int metricId, String value) {
    final today = _today();
    final base = state.date == today ? Map<int, String>.from(state.values) : <int, String>{};
    base[metricId] = value;
    state = (date: today, values: base);
  }

  void remove(int metricId) {
    if (state.values.containsKey(metricId)) {
      final updated = Map<int, String>.from(state.values)..remove(metricId);
      state = (date: state.date, values: updated);
    }
  }

  void clear() {
    state = (date: _today(), values: {});
  }
}

final trackingDraftProvider =
    StateNotifierProvider<TrackingDraftNotifier, ({String date, Map<int, String> values})>(
  (_) => TrackingDraftNotifier(),
);
