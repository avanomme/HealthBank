// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/participant_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/participant.dart';

part 'participant_api.g.dart';

/// Participant API service for personal data view, survey submission,
/// and comparison with aggregates.
///
/// All endpoints require participant (RoleID=1) or admin (RoleID=4) role.
/// Run `dart run build_runner build` to generate participant_api.g.dart
@RestApi()
abstract class ParticipantApi {
  factory ParticipantApi(Dio dio, {String? baseUrl}) = _ParticipantApi;

  /// List all surveys assigned to the participant
  @GET('/participants/surveys')
  Future<List<ParticipantSurveyListItem>> getSurveys();

  /// Get questions for a specific assigned survey (participant-safe)
  @GET('/participants/surveys/{surveyId}/questions')
  Future<ParticipantSurveyQuestionsResponse> getSurveyQuestions(
    @Path('surveyId') int surveyId, {
    @Query('lang') String? lang,
  });

  /// Get all completed surveys with questions and responses
  @GET('/participants/surveys/data')
  Future<List<ParticipantSurveyWithResponses>> getSurveyData({
    @Query('lang') String? lang,
  });

  /// Save draft responses for a survey (auto-save)
  @PUT('/participants/surveys/{surveyId}/draft')
  Future<void> saveDraft(
    @Path('surveyId') int surveyId,
    @Body() Map<String, dynamic> body,
  );

  /// Load any saved draft responses for a survey assignment.
  @GET('/participants/surveys/{surveyId}/draft')
  Future<ParticipantSurveyDraftResponse> getDraft(
    @Path('surveyId') int surveyId,
  );

  /// Submit answers for a survey
  @POST('/participants/surveys/{surveyId}/submit')
  Future<void> submitSurvey(
    @Path('surveyId') int surveyId,
    @Body() Map<String, dynamic> body,
  );

  /// Compare participant responses to aggregate data
  @GET('/participants/surveys/{surveyId}/compare')
  Future<ParticipantSurveyCompareResponse> compareSurvey(
    @Path('surveyId') int surveyId,
  );

  /// Get chart-ready data for a survey (participant response + aggregates)
  @GET('/participants/surveys/{surveyId}/chart-data')
  Future<ParticipantChartDataResponse> getChartData(
    @Path('surveyId') int surveyId, {
    @Query('category') String? category,
    @Query('response_type') String? responseType,
    @Query('lang') String? lang,
  });
}
