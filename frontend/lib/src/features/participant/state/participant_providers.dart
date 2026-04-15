// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/state/participant_providers.dart
/// Riverpod providers for participant data.
///
/// Provider chain: apiClientProvider → participantApiProvider → data providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/api/services/participant_api.dart';
import 'package:frontend/src/core/state/locale_provider.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the ParticipantApi Retrofit service.
final participantApiProvider = Provider<ParticipantApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return ParticipantApi(client.dio);
});

/// Provider for questions of a specific assigned survey (participant-safe).
/// Passes the current locale so the backend returns translated content.
final participantSurveyQuestionsProvider =
    FutureProvider.family<ParticipantSurveyQuestionsResponse, int>(
        (ref, surveyId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(participantApiProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return api.getSurveyQuestions(surveyId, lang: lang);
});

/// Provider for the list of surveys assigned to the participant.
final participantSurveysProvider =
    FutureProvider<List<ParticipantSurveyListItem>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(participantApiProvider);
  return api.getSurveys();
});

/// Provider for all completed surveys with questions and the participant's responses.
final participantSurveyDataProvider =
    FutureProvider<List<ParticipantSurveyWithResponses>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(participantApiProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return api.getSurveyData(lang: lang == 'en' ? null : lang);
});

/// Provider for comparison data (participant vs aggregate) by survey ID.
final participantCompareProvider = FutureProvider.family<
    ParticipantSurveyCompareResponse, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(participantApiProvider);
  return api.compareSurvey(surveyId);
});

/// Provider for chart-ready data (participant response + aggregates) by survey ID.
final participantChartDataProvider = FutureProvider.family<
    ParticipantChartDataResponse, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(participantApiProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return api.getChartData(surveyId, lang: lang == 'en' ? null : lang);
});
