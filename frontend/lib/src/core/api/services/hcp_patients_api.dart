// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/hcp_patients_api.dart
import 'package:dio/dio.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';

/// HCP Patients API — read-only access to patient data for linked HCPs.
///
/// Uses raw Dio instead of Retrofit because retrofit_generator does not
/// support [List<Map<String, dynamic>>] return types correctly.
class HcpPatientsApi {
  final Dio _dio;

  HcpPatientsApi(this._dio);

  /// Get all patients linked to the current HCP (active, consented).
  Future<List<Map<String, dynamic>>> getMyPatients() async {
    final response = await _dio.get('/hcp/patients');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  /// Get completed surveys for a specific patient.
  Future<List<Map<String, dynamic>>> getPatientSurveys(int patientId) async {
    final response = await _dio.get('/hcp/patients/$patientId/surveys');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  /// Get a patient's responses for a specific survey.
  Future<List<Map<String, dynamic>>> getPatientResponses(
    int patientId,
    int surveyId,
  ) async {
    final response =
        await _dio.get('/hcp/patients/$patientId/responses/$surveyId');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  // ── Health Tracking ───────────────────────────────────────────────────────

  /// Get active tracking categories + metrics for a linked patient.
  Future<List<TrackingCategory>> getPatientHealthMetrics(int patientId) async {
    final response = await _dio.get(
      '/hcp/patients/$patientId/health-tracking/metrics',
    );
    return (response.data as List)
        .cast<Map<String, dynamic>>()
        .map(TrackingCategory.fromJson)
        .toList();
  }

  /// Get a patient's health tracking entries with optional filters.
  Future<List<TrackingEntry>> getPatientHealthEntries(
    int patientId, {
    String? startDate,
    String? endDate,
    int? metricId,
  }) async {
    final response = await _dio.get(
      '/hcp/patients/$patientId/health-tracking/entries',
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (metricId != null) 'metric_id': metricId,
      },
    );
    return (response.data as List)
        .cast<Map<String, dynamic>>()
        .map(TrackingEntry.fromJson)
        .toList();
  }

  /// Get per-question aggregate averages for a completed survey (for comparison).
  /// Only numeric and scale questions are returned (must meet k-anonymity threshold).
  Future<List<Map<String, dynamic>>> getSurveyQuestionAggregate(
    int patientId,
    int surveyId,
  ) async {
    final response = await _dio.get(
      '/hcp/patients/$patientId/surveys/$surveyId/aggregate',
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  /// Get k-anonymity-filtered aggregate data for a metric (all participants).
  Future<List<AggregateDataPoint>> getPatientHealthAggregate(
    int patientId, {
    required int metricId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await _dio.get(
      '/hcp/patients/$patientId/health-tracking/aggregate',
      queryParameters: {
        'metric_id': metricId,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    return (response.data as List)
        .cast<Map<String, dynamic>>()
        .map(AggregateDataPoint.fromJson)
        .toList();
  }

  /// Export a patient's health tracking entries as CSV.
  Future<String> exportPatientHealthEntries(
    int patientId, {
    String? startDate,
    String? endDate,
    String? metricIds,
  }) async {
    final response = await _dio.get(
      '/hcp/patients/$patientId/health-tracking/export',
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (metricIds != null) 'metric_ids': metricIds,
      },
    );
    return response.data as String;
  }
}
