// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/participant.dart
/// Participant data models matching backend Pydantic schemas.
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

/// Survey questions response for a participant taking a survey.
@freezed
sealed class ParticipantSurveyQuestionsResponse
    with _$ParticipantSurveyQuestionsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ParticipantSurveyQuestionsResponse({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    required List<ParticipantSurveyQuestion> questions,
  }) = _ParticipantSurveyQuestionsResponse;

  factory ParticipantSurveyQuestionsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ParticipantSurveyQuestionsResponseFromJson(json);
}

/// A question returned for a participant to answer.
@freezed
sealed class ParticipantSurveyQuestion with _$ParticipantSurveyQuestion {
  @JsonSerializable(explicitToJson: true)
  const factory ParticipantSurveyQuestion({
    @JsonKey(name: 'question_id') required int questionId,
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') required bool isRequired,
    String? category,
    List<ParticipantQuestionOption>? options,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
  }) = _ParticipantSurveyQuestion;

  factory ParticipantSurveyQuestion.fromJson(Map<String, dynamic> json) =>
      _$ParticipantSurveyQuestionFromJson(json);
}

/// An option for a single/multi choice question.
@freezed
sealed class ParticipantQuestionOption with _$ParticipantQuestionOption {
  const factory ParticipantQuestionOption({
    @JsonKey(name: 'option_id') required int optionId,
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _ParticipantQuestionOption;

  factory ParticipantQuestionOption.fromJson(Map<String, dynamic> json) =>
      _$ParticipantQuestionOptionFromJson(json);
}

/// Survey list item for the participant's assigned surveys.
@freezed
sealed class ParticipantSurveyListItem with _$ParticipantSurveyListItem {
  const factory ParticipantSurveyListItem({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'assignment_status') required String assignmentStatus,
    @JsonKey(name: 'has_draft') @Default(false) bool hasDraft,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'publication_status') required String publicationStatus,
  }) = _ParticipantSurveyListItem;

  factory ParticipantSurveyListItem.fromJson(Map<String, dynamic> json) =>
      _$ParticipantSurveyListItemFromJson(json);
}

/// A single question with the participant's response value.
@freezed
sealed class ParticipantQuestionResponse with _$ParticipantQuestionResponse {
  const factory ParticipantQuestionResponse({
    @JsonKey(name: 'question_id') required int questionId,
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') required bool isRequired,
    String? category,
    @JsonKey(name: 'response_value') String? responseValue,
  }) = _ParticipantQuestionResponse;

  factory ParticipantQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticipantQuestionResponseFromJson(json);
}

/// Survey with all questions and the participant's responses.
@freezed
sealed class ParticipantSurveyWithResponses
    with _$ParticipantSurveyWithResponses {
  @JsonSerializable(explicitToJson: true)
  const factory ParticipantSurveyWithResponses({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'publication_status') required String publicationStatus,
    @JsonKey(name: 'assignment_status') String? assignmentStatus,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    required List<ParticipantQuestionResponse> questions,
  }) = _ParticipantSurveyWithResponses;

  factory ParticipantSurveyWithResponses.fromJson(
          Map<String, dynamic> json) =>
      _$ParticipantSurveyWithResponsesFromJson(json);
}

/// A single question's chart data: participant response + aggregate stats.
@freezed
sealed class ChartQuestionData with _$ChartQuestionData {
  const factory ChartQuestionData({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    String? category,
    @JsonKey(name: 'response_value') String? responseValue,
    Map<String, dynamic>? aggregate,
    @Default(false) bool suppressed,
  }) = _ChartQuestionData;

  factory ChartQuestionData.fromJson(Map<String, dynamic> json) =>
      _$ChartQuestionDataFromJson(json);
}

/// Chart data response for a survey: participant's data + aggregates per question.
@freezed
sealed class ParticipantChartDataResponse
    with _$ParticipantChartDataResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ParticipantChartDataResponse({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    @JsonKey(name: 'total_respondents') required int totalRespondents,
    required List<ChartQuestionData> questions,
  }) = _ParticipantChartDataResponse;

  factory ParticipantChartDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticipantChartDataResponseFromJson(json);
}

/// Participant answer in comparison response.
@freezed
sealed class ParticipantAnswerOut with _$ParticipantAnswerOut {
  const factory ParticipantAnswerOut({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'response_value') String? responseValue,
  }) = _ParticipantAnswerOut;

  factory ParticipantAnswerOut.fromJson(Map<String, dynamic> json) =>
      _$ParticipantAnswerOutFromJson(json);
}

/// Comparison response: participant answers alongside aggregate data.
@freezed
sealed class ParticipantSurveyCompareResponse
    with _$ParticipantSurveyCompareResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ParticipantSurveyCompareResponse({
    @JsonKey(name: 'survey_id') required int surveyId,
    @JsonKey(name: 'participant_answers')
    required List<ParticipantAnswerOut> participantAnswers,
    required Map<String, dynamic> aggregates,
  }) = _ParticipantSurveyCompareResponse;

  factory ParticipantSurveyCompareResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ParticipantSurveyCompareResponseFromJson(json);
}

/// Draft payload returned for an in-progress participant survey.
@freezed
sealed class ParticipantSurveyDraftResponse
    with _$ParticipantSurveyDraftResponse {
  const factory ParticipantSurveyDraftResponse({
    @Default(<String, String>{}) Map<String, String> draft,
  }) = _ParticipantSurveyDraftResponse;

  factory ParticipantSurveyDraftResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticipantSurveyDraftResponseFromJson(json);
}
