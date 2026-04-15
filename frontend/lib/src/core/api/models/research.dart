// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/research.dart
/// Research data models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'research.freezed.dart';
part 'research.g.dart';

/// Survey item in the research survey list
@freezed
sealed class ResearchSurvey with _$ResearchSurvey {
  const factory ResearchSurvey({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'publication_status') required String publicationStatus,
    @JsonKey(name: 'response_count') required int responseCount,
    @JsonKey(name: 'question_count') required int questionCount,
  }) = _ResearchSurvey;

  factory ResearchSurvey.fromJson(Map<String, dynamic> json) =>
      _$ResearchSurveyFromJson(json);
}

/// Survey overview stats returned by GET /research/surveys/{id}/overview
@freezed
sealed class SurveyOverview with _$SurveyOverview {
  const factory SurveyOverview({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'respondent_count') required int respondentCount,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'question_count') required int questionCount,
    required bool suppressed,
    @JsonKey(name: 'min_responses') @Default(5) int minResponses,
  }) = _SurveyOverview;

  factory SurveyOverview.fromJson(Map<String, dynamic> json) =>
      _$SurveyOverviewFromJson(json);
}

/// Aggregate data for a single question
@freezed
sealed class QuestionAggregate with _$QuestionAggregate {
  const factory QuestionAggregate({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    String? category,
    @JsonKey(name: 'response_count') required int responseCount,
    required bool suppressed,
    Map<String, dynamic>? data,
  }) = _QuestionAggregate;

  factory QuestionAggregate.fromJson(Map<String, dynamic> json) =>
      _$QuestionAggregateFromJson(json);
}

/// Full aggregate response for a survey (list of question aggregates)
@freezed
sealed class AggregateResponse with _$AggregateResponse {
  const factory AggregateResponse({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'total_respondents') required int totalRespondents,
    required List<QuestionAggregate> aggregates,
  }) = _AggregateResponse;

  factory AggregateResponse.fromJson(Map<String, dynamic> json) =>
      _$AggregateResponseFromJson(json);
}

/// Question metadata in individual response data
@freezed
sealed class ResponseQuestion with _$ResponseQuestion {
  const factory ResponseQuestion({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    String? category,
  }) = _ResponseQuestion;

  factory ResponseQuestion.fromJson(Map<String, dynamic> json) =>
      _$ResponseQuestionFromJson(json);
}

/// A single anonymized participant's response row
@freezed
sealed class ResponseRow with _$ResponseRow {
  const factory ResponseRow({
    @JsonKey(name: 'anonymous_id') required String anonymousId,
    required Map<String, String> responses,
  }) = _ResponseRow;

  factory ResponseRow.fromJson(Map<String, dynamic> json) =>
      _$ResponseRowFromJson(json);
}

/// Individual anonymized response data for a survey
@freezed
sealed class IndividualResponseData with _$IndividualResponseData {
  const factory IndividualResponseData({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'respondent_count') required int respondentCount,
    required bool suppressed,
    String? reason,
    required List<ResponseQuestion> questions,
    required List<ResponseRow> rows,
  }) = _IndividualResponseData;

  factory IndividualResponseData.fromJson(Map<String, dynamic> json) =>
      _$IndividualResponseDataFromJson(json);
}

// ---------------------------------------------------------------------------
// Cross-survey models
// ---------------------------------------------------------------------------

/// Question metadata in cross-survey response data (includes survey info)
@freezed
sealed class CrossSurveyQuestion with _$CrossSurveyQuestion {
  const factory CrossSurveyQuestion({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    String? category,
    @JsonKey(name: 'survey_id') required int surveyId,
    @JsonKey(name: 'survey_title') required String surveyTitle,
    @JsonKey(name: 'survey_start_date') String? surveyStartDate,
  }) = _CrossSurveyQuestion;

  factory CrossSurveyQuestion.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveyQuestionFromJson(json);
}

/// A single anonymized participant's response row (cross-survey)
/// One row per participant with all responses merged across surveys.
@freezed
sealed class CrossSurveyRow with _$CrossSurveyRow {
  const factory CrossSurveyRow({
    @JsonKey(name: 'anonymous_id') required String anonymousId,
    required Map<String, String> responses,
  }) = _CrossSurveyRow;

  factory CrossSurveyRow.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveyRowFromJson(json);
}

/// Per-survey summary in cross-survey response
@freezed
sealed class CrossSurveySummary with _$CrossSurveySummary {
  const factory CrossSurveySummary({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'respondent_count') required int respondentCount,
  }) = _CrossSurveySummary;

  factory CrossSurveySummary.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveySummaryFromJson(json);
}

/// Cross-survey overview stats
@freezed
sealed class CrossSurveyOverview with _$CrossSurveyOverview {
  const factory CrossSurveyOverview({
    @JsonKey(name: 'survey_ids') required List<int> surveyIds,
    required List<CrossSurveySummary> surveys,
    @JsonKey(name: 'total_respondent_count') required int totalRespondentCount,
    @JsonKey(name: 'total_question_count') required int totalQuestionCount,
    @JsonKey(name: 'avg_completion_rate') required double avgCompletionRate,
    required bool suppressed,
    String? reason,
    @JsonKey(name: 'min_responses') @Default(5) int minResponses,
  }) = _CrossSurveyOverview;

  factory CrossSurveyOverview.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveyOverviewFromJson(json);
}

/// Cross-survey aggregate stats (Data Bank analysis tab)
@freezed
sealed class CrossSurveyAggregateResponse with _$CrossSurveyAggregateResponse {
  const factory CrossSurveyAggregateResponse({
    @JsonKey(name: 'survey_ids') required List<int> surveyIds,
    @JsonKey(name: 'total_respondents') required int totalRespondents,
    required List<QuestionAggregate> aggregates,
  }) = _CrossSurveyAggregateResponse;

  factory CrossSurveyAggregateResponse.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveyAggregateResponseFromJson(json);
}

/// Cross-survey individual response data
@freezed
sealed class CrossSurveyResponseData with _$CrossSurveyResponseData {
  const factory CrossSurveyResponseData({
    @JsonKey(name: 'survey_ids') required List<int> surveyIds,
    required List<CrossSurveySummary> surveys,
    @JsonKey(name: 'total_respondent_count') required int totalRespondentCount,
    @JsonKey(name: 'date_from') String? dateFrom,
    @JsonKey(name: 'date_to') String? dateTo,
    required bool suppressed,
    String? reason,
    @JsonKey(name: 'suppressed_surveys') @Default([]) List<int> suppressedSurveys,
    required List<CrossSurveyQuestion> questions,
    required List<CrossSurveyRow> rows,
  }) = _CrossSurveyResponseData;

  factory CrossSurveyResponseData.fromJson(Map<String, dynamic> json) =>
      _$CrossSurveyResponseDataFromJson(json);
}
