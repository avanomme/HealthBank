// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/research_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/research.dart';

part 'research_api.g.dart';

/// Research Data API service for individual anonymized responses & aggregates
///
/// All endpoints require researcher (RoleID=2) or admin (RoleID=4) role.
/// Run `dart run build_runner build` to generate research_api.g.dart
@RestApi()
abstract class ResearchApi {
  factory ResearchApi(Dio dio, {String? baseUrl}) = _ResearchApi;

  /// List all surveys with response counts
  @GET('/research/surveys')
  Future<List<ResearchSurvey>> listResearchSurveys();

  /// Get survey overview stats (respondent count, completion rate)
  @GET('/research/surveys/{id}/overview')
  Future<SurveyOverview> getSurveyOverview(
    @Path('id') int id,
  );

  /// Get individual anonymized response rows for a survey
  @GET('/research/surveys/{id}/responses')
  Future<IndividualResponseData> getIndividualResponses(
    @Path('id') int id, {
    @Query('category') String? category,
    @Query('response_type') String? responseType,
  });

  /// Get aggregate data for all questions in a survey
  @GET('/research/surveys/{id}/aggregates')
  Future<AggregateResponse> getSurveyAggregates(
    @Path('id') int id, {
    @Query('category') String? category,
    @Query('response_type') String? responseType,
  });

  /// Get aggregate data for a single question
  @GET('/research/surveys/{id}/aggregates/{questionId}')
  Future<QuestionAggregate> getQuestionAggregate(
    @Path('id') int id,
    @Path('questionId') int questionId,
  );

  /// Export individual response data as CSV
  @GET('/research/surveys/{id}/export/csv')
  @DioResponseType(ResponseType.plain)
  Future<String> exportCsv(
    @Path('id') int id, {
    @Query('category') String? category,
    @Query('response_type') String? responseType,
  });

  // Data bank endpoints

  /// Get overview stats across surveys (omit surveyIds for all)
  @GET('/research/cross-survey/overview')
  Future<CrossSurveyOverview> getCrossSurveyOverview({
    @Query('survey_ids') List<int>? surveyIds,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });

  /// List available questions in the data bank for field picker
  @GET('/research/cross-survey/questions')
  Future<List<CrossSurveyQuestion>> getAvailableQuestions({
    @Query('survey_ids') List<int>? surveyIds,
    @Query('category') String? category,
    @Query('response_type') String? responseType,
  });

  /// Get individual anonymized response rows (omit surveyIds for all)
  @GET('/research/cross-survey/responses')
  Future<CrossSurveyResponseData> getCrossSurveyResponses({
    @Query('survey_ids') List<int>? surveyIds,
    @Query('question_ids') List<int>? questionIds,
    @Query('category') String? category,
    @Query('response_type') String? responseType,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });

  /// Get aggregate stats across the data bank for charting
  @GET('/research/cross-survey/aggregates')
  Future<CrossSurveyAggregateResponse> getCrossSurveyAggregates({
    @Query('survey_ids') List<int>? surveyIds,
    @Query('question_ids') List<int>? questionIds,
    @Query('category') String? category,
    @Query('response_type') String? responseType,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });

  /// Export data bank individual response data as CSV
  @GET('/research/cross-survey/export/csv')
  @DioResponseType(ResponseType.plain)
  Future<String> exportCrossSurveyCsv({
    @Query('survey_ids') List<int>? surveyIds,
    @Query('question_ids') List<int>? questionIds,
    @Query('category') String? category,
    @Query('response_type') String? responseType,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });
}
