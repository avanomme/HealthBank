// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/health_tracking.dart
/// Health tracking data models matching backend Pydantic schemas.
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'health_tracking.freezed.dart';
part 'health_tracking.g.dart';

/// Serialises a DateTime as 'yyyy-MM-dd' for backend date fields.
/// Public so dart2js can resolve the reference in @JsonKey annotations.
String healthTrackingDateToJson(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

/// Parses a 'yyyy-MM-dd' string back to DateTime.
/// Public so dart2js can resolve the reference in @JsonKey annotations.
DateTime healthTrackingDateFromJson(dynamic s) => DateTime.parse(s as String);

/// A tracking category with its associated metrics.
/// Matches CategoryResponse from backend.
@freezed
sealed class TrackingCategory with _$TrackingCategory {
  @JsonSerializable(explicitToJson: true)
  const factory TrackingCategory({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_key') required String categoryKey,
    @JsonKey(name: 'display_name') required String displayName,
    String? description,
    String? icon,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'is_active') required bool isActive,
    @Default(false) @JsonKey(name: 'is_deleted') bool isDeleted,
    @Default(<TrackingMetric>[]) List<TrackingMetric> metrics,
  }) = _TrackingCategory;

  factory TrackingCategory.fromJson(Map<String, dynamic> json) =>
      _$TrackingCategoryFromJson(json);
}

/// A single trackable health metric within a category.
/// Matches MetricResponse from backend.
@freezed
sealed class TrackingMetric with _$TrackingMetric {
  @JsonSerializable(explicitToJson: true)
  const factory TrackingMetric({
    @JsonKey(name: 'metric_id') required int metricId,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'metric_key') required String metricKey,
    @JsonKey(name: 'display_name') required String displayName,
    String? description,
    @JsonKey(name: 'metric_type') required String metricType,
    String? unit,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
    @JsonKey(name: 'choice_options') List<String>? choiceOptions,
    required String frequency,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_baseline') required bool isBaseline,
    @Default(false) @JsonKey(name: 'is_deleted') bool isDeleted,
  }) = _TrackingMetric;

  factory TrackingMetric.fromJson(Map<String, dynamic> json) =>
      _$TrackingMetricFromJson(json);
}

/// A recorded health tracking entry for a participant.
/// Matches EntryResponse from backend.
@freezed
sealed class TrackingEntry with _$TrackingEntry {
  @JsonSerializable(explicitToJson: true)
  const factory TrackingEntry({
    @JsonKey(name: 'entry_id') required int entryId,
    @JsonKey(name: 'participant_id') required int participantId,
    @JsonKey(name: 'metric_id') required int metricId,
    required String value,
    String? notes,
    @JsonKey(name: 'entry_date') required DateTime entryDate,
    @JsonKey(name: 'is_baseline') required bool isBaseline,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _TrackingEntry;

  factory TrackingEntry.fromJson(Map<String, dynamic> json) =>
      _$TrackingEntryFromJson(json);
}

/// Payload for submitting a single tracking entry.
@freezed
sealed class TrackingEntrySubmit with _$TrackingEntrySubmit {
  @JsonSerializable(explicitToJson: true)
  const factory TrackingEntrySubmit({
    @JsonKey(name: 'metric_id') required int metricId,
    required String value,
    String? notes,
    // Serialised as 'yyyy-MM-dd' only — backend expects a date, not datetime.
    @JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson)
    required DateTime entryDate,
  }) = _TrackingEntrySubmit;

  factory TrackingEntrySubmit.fromJson(Map<String, dynamic> json) =>
      _$TrackingEntrySubmitFromJson(json);
}

/// Today's health check-in completion status.
/// Matches CheckInStatusResponse from backend.
@freezed
sealed class HealthCheckInStatus with _$HealthCheckInStatus {
  const factory HealthCheckInStatus({
    @JsonKey(name: 'is_complete') required bool isComplete,
    @JsonKey(name: 'total_due') required int totalDue,
    @JsonKey(name: 'completed_count') required int completedCount,
    @JsonKey(name: 'has_any_due') required bool hasAnyDue,
  }) = _HealthCheckInStatus;

  factory HealthCheckInStatus.fromJson(Map<String, dynamic> json) =>
      _$HealthCheckInStatusFromJson(json);
}

/// Payload for submitting a batch of tracking entries.
@freezed
sealed class BatchEntrySubmit with _$BatchEntrySubmit {
  @JsonSerializable(explicitToJson: true)
  const factory BatchEntrySubmit({
    required List<TrackingEntrySubmit> entries,
    @JsonKey(name: 'is_baseline') @Default(false) bool isBaseline,
  }) = _BatchEntrySubmit;

  factory BatchEntrySubmit.fromJson(Map<String, dynamic> json) =>
      _$BatchEntrySubmitFromJson(json);
}

/// A single aggregate data point for researcher analytics.
@freezed
sealed class AggregateDataPoint with _$AggregateDataPoint {
  const factory AggregateDataPoint({
    @JsonKey(name: 'entry_date') required DateTime entryDate,
    @JsonKey(name: 'avg_value') required double avgValue,
    @JsonKey(name: 'participant_count') required int participantCount,
  }) = _AggregateDataPoint;

  factory AggregateDataPoint.fromJson(Map<String, dynamic> json) =>
      _$AggregateDataPointFromJson(json);
}

/// Item used when reordering categories.
@freezed
sealed class CategoryOrderItem with _$CategoryOrderItem {
  const factory CategoryOrderItem({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'display_order') required int displayOrder,
  }) = _CategoryOrderItem;

  factory CategoryOrderItem.fromJson(Map<String, dynamic> json) =>
      _$CategoryOrderItemFromJson(json);
}

/// Item used when reordering metrics.
@freezed
sealed class MetricOrderItem with _$MetricOrderItem {
  const factory MetricOrderItem({
    @JsonKey(name: 'metric_id') required int metricId,
    @JsonKey(name: 'display_order') required int displayOrder,
  }) = _MetricOrderItem;

  factory MetricOrderItem.fromJson(Map<String, dynamic> json) =>
      _$MetricOrderItemFromJson(json);
}

/// Date range of all health tracking entries (for defaulting the researcher UI).
@freezed
sealed class EntryDateRange with _$EntryDateRange {
  const factory EntryDateRange({
    @JsonKey(name: 'min_date') String? minDate,
    @JsonKey(name: 'max_date') String? maxDate,
  }) = _EntryDateRange;

  factory EntryDateRange.fromJson(Map<String, dynamic> json) =>
      _$EntryDateRangeFromJson(json);
}

/// Aggregate data for one metric in a multi-metric researcher query.
@freezed
sealed class MultiAggregateResult with _$MultiAggregateResult {
  @JsonSerializable(explicitToJson: true)
  const factory MultiAggregateResult({
    @JsonKey(name: 'metric_id') required int metricId,
    @JsonKey(name: 'metric_name') required String metricName,
    @JsonKey(name: 'category_name') required String categoryName,
    @Default(<AggregateDataPoint>[]) List<AggregateDataPoint> data,
  }) = _MultiAggregateResult;

  factory MultiAggregateResult.fromJson(Map<String, dynamic> json) =>
      _$MultiAggregateResultFromJson(json);
}

/// Per-category summary stats for the researcher health tracking page.
@freezed
sealed class TrackingCategoryStats with _$TrackingCategoryStats {
  const factory TrackingCategoryStats({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_key') required String categoryKey,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'participant_count') required int participantCount,
    @JsonKey(name: 'total_entries') required int totalEntries,
    @JsonKey(name: 'last_entry_date') DateTime? lastEntryDate,
  }) = _TrackingCategoryStats;

  factory TrackingCategoryStats.fromJson(Map<String, dynamic> json) =>
      _$TrackingCategoryStatsFromJson(json);
}
