// frontend/lib/src/core/api/services/health_tracking_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/health_tracking.dart';

part 'health_tracking_api.g.dart';

@RestApi()
abstract class HealthTrackingApi {
  factory HealthTrackingApi(Dio dio, {String? baseUrl}) = _HealthTrackingApi;

  // ── Participant ──────────────────────────────────────────────────────────

  @GET('/health-tracking/metrics')
  Future<List<TrackingCategory>> getMetrics({
    @Query('lang') String? lang,
  });

  @POST('/health-tracking/entries')
  Future<void> submitEntries(@Body() BatchEntrySubmit body);

  @GET('/health-tracking/entries')
  Future<List<TrackingEntry>> getEntries({
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('metric_id') int? metricId,
    @Query('category_key') String? categoryKey,
  });

  @GET('/health-tracking/history/{metricId}')
  Future<List<TrackingEntry>> getHistory(@Path('metricId') int metricId);

  @GET('/health-tracking/baseline')
  Future<List<TrackingEntry>> getBaseline();

  @GET('/health-tracking/status/today')
  Future<HealthCheckInStatus> getCheckInStatus();

  @GET('/health-tracking/participant/aggregate')
  Future<List<AggregateDataPoint>> getParticipantAggregate({
    @Query('metric_id') required int metricId,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });

  @GET('/health-tracking/participant/export')
  Future<String> exportParticipantCsv({
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('metric_ids') String? metricIds,
  });

  // ── Admin ────────────────────────────────────────────────────────────────

  @GET('/health-tracking/admin/categories')
  Future<List<TrackingCategory>> getAdminCategories();

  @POST('/health-tracking/admin/categories')
  Future<void> createCategory(@Body() Map<String, dynamic> body);

  @PUT('/health-tracking/admin/categories/{id}')
  Future<void> updateCategory(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/health-tracking/admin/categories/{id}')
  Future<void> deleteCategory(@Path('id') int id);

  @PATCH('/health-tracking/admin/categories/{id}/restore')
  Future<void> restoreCategory(@Path('id') int id);

  @PATCH('/health-tracking/admin/categories/{id}/toggle')
  Future<void> toggleCategory(@Path('id') int id);

  @PUT('/health-tracking/admin/categories/reorder')
  Future<void> reorderCategories(@Body() List<CategoryOrderItem> body);

  @GET('/health-tracking/admin/metrics')
  Future<List<TrackingMetric>> getAdminMetrics();

  @POST('/health-tracking/admin/metrics')
  Future<void> createMetric(@Body() Map<String, dynamic> body);

  @PUT('/health-tracking/admin/metrics/{id}')
  Future<void> updateMetric(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/health-tracking/admin/metrics/{id}/toggle')
  Future<void> toggleMetric(@Path('id') int id);

  @DELETE('/health-tracking/admin/metrics/{id}')
  Future<void> deleteMetric(@Path('id') int id);

  @PATCH('/health-tracking/admin/metrics/{id}/restore')
  Future<void> restoreMetric(@Path('id') int id);

  @PUT('/health-tracking/admin/metrics/reorder')
  Future<void> reorderMetrics(@Body() List<MetricOrderItem> body);

  // ── Researcher ───────────────────────────────────────────────────────────

  @GET('/health-tracking/research/entry-date-range')
  Future<EntryDateRange> getEntryDateRange();

  @GET('/health-tracking/research/aggregate-multi')
  Future<List<MultiAggregateResult>> getMultiAggregate({
    @Query('metric_ids') required String metricIds,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });

  @GET('/health-tracking/research/aggregate')
  Future<List<AggregateDataPoint>> getAggregate({
    @Query('metric_id') required int metricId,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });

  @GET('/health-tracking/research/categories')
  Future<List<TrackingCategoryStats>> getResearchCategories();

  @GET('/health-tracking/research/export')
  Future<String> exportHealthTrackingCsv({
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('metric_ids') String? metricIds,
  });
}
