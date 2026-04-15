// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackingCategory _$TrackingCategoryFromJson(Map<String, dynamic> json) =>
    _TrackingCategory(
      categoryId: (json['category_id'] as num).toInt(),
      categoryKey: json['category_key'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool,
      isDeleted: json['is_deleted'] as bool? ?? false,
      metrics:
          (json['metrics'] as List<dynamic>?)
              ?.map((e) => TrackingMetric.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TrackingMetric>[],
    );

Map<String, dynamic> _$TrackingCategoryToJson(_TrackingCategory instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_key': instance.categoryKey,
      'display_name': instance.displayName,
      'description': instance.description,
      'icon': instance.icon,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'is_deleted': instance.isDeleted,
      'metrics': instance.metrics.map((e) => e.toJson()).toList(),
    };

_TrackingMetric _$TrackingMetricFromJson(Map<String, dynamic> json) =>
    _TrackingMetric(
      metricId: (json['metric_id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      metricKey: json['metric_key'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String?,
      metricType: json['metric_type'] as String,
      unit: json['unit'] as String?,
      scaleMin: (json['scale_min'] as num?)?.toInt(),
      scaleMax: (json['scale_max'] as num?)?.toInt(),
      choiceOptions: (json['choice_options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      frequency: json['frequency'] as String,
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool,
      isBaseline: json['is_baseline'] as bool,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TrackingMetricToJson(_TrackingMetric instance) =>
    <String, dynamic>{
      'metric_id': instance.metricId,
      'category_id': instance.categoryId,
      'metric_key': instance.metricKey,
      'display_name': instance.displayName,
      'description': instance.description,
      'metric_type': instance.metricType,
      'unit': instance.unit,
      'scale_min': instance.scaleMin,
      'scale_max': instance.scaleMax,
      'choice_options': instance.choiceOptions,
      'frequency': instance.frequency,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'is_baseline': instance.isBaseline,
      'is_deleted': instance.isDeleted,
    };

_TrackingEntry _$TrackingEntryFromJson(Map<String, dynamic> json) =>
    _TrackingEntry(
      entryId: (json['entry_id'] as num).toInt(),
      participantId: (json['participant_id'] as num).toInt(),
      metricId: (json['metric_id'] as num).toInt(),
      value: json['value'] as String,
      notes: json['notes'] as String?,
      entryDate: DateTime.parse(json['entry_date'] as String),
      isBaseline: json['is_baseline'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TrackingEntryToJson(_TrackingEntry instance) =>
    <String, dynamic>{
      'entry_id': instance.entryId,
      'participant_id': instance.participantId,
      'metric_id': instance.metricId,
      'value': instance.value,
      'notes': instance.notes,
      'entry_date': instance.entryDate.toIso8601String(),
      'is_baseline': instance.isBaseline,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_TrackingEntrySubmit _$TrackingEntrySubmitFromJson(Map<String, dynamic> json) =>
    _TrackingEntrySubmit(
      metricId: (json['metric_id'] as num).toInt(),
      value: json['value'] as String,
      notes: json['notes'] as String?,
      entryDate: healthTrackingDateFromJson(json['entry_date']),
    );

Map<String, dynamic> _$TrackingEntrySubmitToJson(
  _TrackingEntrySubmit instance,
) => <String, dynamic>{
  'metric_id': instance.metricId,
  'value': instance.value,
  'notes': instance.notes,
  'entry_date': healthTrackingDateToJson(instance.entryDate),
};

_HealthCheckInStatus _$HealthCheckInStatusFromJson(Map<String, dynamic> json) =>
    _HealthCheckInStatus(
      isComplete: json['is_complete'] as bool,
      totalDue: (json['total_due'] as num).toInt(),
      completedCount: (json['completed_count'] as num).toInt(),
      hasAnyDue: json['has_any_due'] as bool,
    );

Map<String, dynamic> _$HealthCheckInStatusToJson(
  _HealthCheckInStatus instance,
) => <String, dynamic>{
  'is_complete': instance.isComplete,
  'total_due': instance.totalDue,
  'completed_count': instance.completedCount,
  'has_any_due': instance.hasAnyDue,
};

_BatchEntrySubmit _$BatchEntrySubmitFromJson(Map<String, dynamic> json) =>
    _BatchEntrySubmit(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => TrackingEntrySubmit.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBaseline: json['is_baseline'] as bool? ?? false,
    );

Map<String, dynamic> _$BatchEntrySubmitToJson(_BatchEntrySubmit instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'is_baseline': instance.isBaseline,
    };

_AggregateDataPoint _$AggregateDataPointFromJson(Map<String, dynamic> json) =>
    _AggregateDataPoint(
      entryDate: DateTime.parse(json['entry_date'] as String),
      avgValue: (json['avg_value'] as num).toDouble(),
      participantCount: (json['participant_count'] as num).toInt(),
    );

Map<String, dynamic> _$AggregateDataPointToJson(_AggregateDataPoint instance) =>
    <String, dynamic>{
      'entry_date': instance.entryDate.toIso8601String(),
      'avg_value': instance.avgValue,
      'participant_count': instance.participantCount,
    };

_CategoryOrderItem _$CategoryOrderItemFromJson(Map<String, dynamic> json) =>
    _CategoryOrderItem(
      categoryId: (json['category_id'] as num).toInt(),
      displayOrder: (json['display_order'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryOrderItemToJson(_CategoryOrderItem instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'display_order': instance.displayOrder,
    };

_MetricOrderItem _$MetricOrderItemFromJson(Map<String, dynamic> json) =>
    _MetricOrderItem(
      metricId: (json['metric_id'] as num).toInt(),
      displayOrder: (json['display_order'] as num).toInt(),
    );

Map<String, dynamic> _$MetricOrderItemToJson(_MetricOrderItem instance) =>
    <String, dynamic>{
      'metric_id': instance.metricId,
      'display_order': instance.displayOrder,
    };

_EntryDateRange _$EntryDateRangeFromJson(Map<String, dynamic> json) =>
    _EntryDateRange(
      minDate: json['min_date'] as String?,
      maxDate: json['max_date'] as String?,
    );

Map<String, dynamic> _$EntryDateRangeToJson(_EntryDateRange instance) =>
    <String, dynamic>{
      'min_date': instance.minDate,
      'max_date': instance.maxDate,
    };

_MultiAggregateResult _$MultiAggregateResultFromJson(
  Map<String, dynamic> json,
) => _MultiAggregateResult(
  metricId: (json['metric_id'] as num).toInt(),
  metricName: json['metric_name'] as String,
  categoryName: json['category_name'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => AggregateDataPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AggregateDataPoint>[],
);

Map<String, dynamic> _$MultiAggregateResultToJson(
  _MultiAggregateResult instance,
) => <String, dynamic>{
  'metric_id': instance.metricId,
  'metric_name': instance.metricName,
  'category_name': instance.categoryName,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

_TrackingCategoryStats _$TrackingCategoryStatsFromJson(
  Map<String, dynamic> json,
) => _TrackingCategoryStats(
  categoryId: (json['category_id'] as num).toInt(),
  categoryKey: json['category_key'] as String,
  displayName: json['display_name'] as String,
  participantCount: (json['participant_count'] as num).toInt(),
  totalEntries: (json['total_entries'] as num).toInt(),
  lastEntryDate: json['last_entry_date'] == null
      ? null
      : DateTime.parse(json['last_entry_date'] as String),
);

Map<String, dynamic> _$TrackingCategoryStatsToJson(
  _TrackingCategoryStats instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_key': instance.categoryKey,
  'display_name': instance.displayName,
  'participant_count': instance.participantCount,
  'total_entries': instance.totalEntries,
  'last_entry_date': instance.lastEntryDate?.toIso8601String(),
};
