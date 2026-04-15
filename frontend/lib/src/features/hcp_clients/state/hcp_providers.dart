// Created with the Assistance of Claude Code
// frontend/lib/src/features/hcp_clients/state/hcp_providers.dart
/// Riverpod providers for HCP patient data.
///
/// Provider chain: apiClientProvider → HcpPatientsApi → patient FutureProviders
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for HcpPatientsApi service.
final hcpPatientsApiProvider = Provider<HcpPatientsApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HcpPatientsApi(client.dio);
});

/// Provider for all patients linked to the current HCP (active + consented).
final hcpPatientsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(hcpPatientsApiProvider);
  return api.getMyPatients();
});

/// Provider for completed surveys for a specific patient.
final hcpPatientSurveysProvider = FutureProvider.family<
    List<Map<String, dynamic>>, int>((ref, patientId) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(hcpPatientsApiProvider);
  return api.getPatientSurveys(patientId);
});

/// Provider for a patient's responses for a specific survey.
/// Param is a record: (patientId, surveyId).
final hcpPatientResponsesProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({int patientId, int surveyId})>((ref, params) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(hcpPatientsApiProvider);
  return api.getPatientResponses(params.patientId, params.surveyId);
});

// ── Health Tracking providers ─────────────────────────────────────────────────

/// Active tracking categories + metrics for a linked patient.
final hcpPatientHealthMetricsProvider =
    FutureProvider.family<List<TrackingCategory>, int>((ref, patientId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(hcpPatientsApiProvider);
  return api.getPatientHealthMetrics(patientId);
});

/// A patient's health tracking entries with optional filters.
/// Param: (patientId, startDate, endDate, metricId).
final hcpPatientHealthEntriesProvider = FutureProvider.family<
    List<TrackingEntry>,
    ({int patientId, String? startDate, String? endDate, int? metricId})>(
  (ref, params) async {
    ref.watch(sessionKeyProvider);
    final api = ref.watch(hcpPatientsApiProvider);
    return api.getPatientHealthEntries(
      params.patientId,
      startDate: params.startDate,
      endDate: params.endDate,
      metricId: params.metricId,
    );
  },
);

/// Per-question aggregate averages for a survey (numeric/scale questions only).
/// Param: (patientId, surveyId).
final hcpSurveyQuestionAggregateProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({int patientId, int surveyId})>((ref, params) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(hcpPatientsApiProvider);
  return api.getSurveyQuestionAggregate(params.patientId, params.surveyId);
});

/// k-anon aggregate data for a metric (for patient vs population comparison).
/// Param: (patientId, metricId, startDate, endDate).
final hcpHealthAggregateProvider = FutureProvider.family<
    List<AggregateDataPoint>,
    ({int patientId, int metricId, String? startDate, String? endDate})>(
  (ref, params) async {
    ref.watch(sessionKeyProvider);
    final api = ref.watch(hcpPatientsApiProvider);
    return api.getPatientHealthAggregate(
      params.patientId,
      metricId: params.metricId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  },
);
