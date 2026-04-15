// Created with the Assistance of Claude Code
// frontend/lib/core/api/models/survey.dart
/// Survey models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey.freezed.dart';
part 'survey.g.dart';

/// Publication status enum matching backend PublicationStatus
enum PublicationStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
  @JsonValue('closed')
  closed,
}

/// Survey status enum matching backend SurveyStatus
enum SurveyStatus {
  @JsonValue('in-progress')
  inProgress,
  @JsonValue('complete')
  complete,
  @JsonValue('not-started')
  notStarted,
  @JsonValue('cancelled')
  cancelled,
}

/// Question option model (for single_choice/multi_choice questions)
@freezed
sealed class QuestionOption with _$QuestionOption {
  const factory QuestionOption({
    @JsonKey(name: 'option_id') required int optionId,
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _QuestionOption;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
}

/// Question in survey model matching backend QuestionInSurvey
@freezed
sealed class QuestionInSurvey with _$QuestionInSurvey {
  const factory QuestionInSurvey({
    @JsonKey(name: 'question_id') required int questionId,
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') required bool isRequired,
    String? category,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
    List<QuestionOption>? options,
  }) = _QuestionInSurvey;

  factory QuestionInSurvey.fromJson(Map<String, dynamic> json) =>
      _$QuestionInSurveyFromJson(json);
}

/// Per-survey question link used when creating/updating surveys.
/// Required-ness now belongs to the survey-question association.
@freezed
sealed class SurveyQuestionLinkCreate with _$SurveyQuestionLinkCreate {
  const factory SurveyQuestionLinkCreate({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
  }) = _SurveyQuestionLinkCreate;

  factory SurveyQuestionLinkCreate.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionLinkCreateFromJson(json);
}

/// Survey create request model matching backend SurveyCreate
@freezed
sealed class SurveyCreate with _$SurveyCreate {
  const factory SurveyCreate({
    required String title,
    String? description,
    @JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'question_ids') List<int>? questionIds,
    List<SurveyQuestionLinkCreate>? questions,
  }) = _SurveyCreate;

  factory SurveyCreate.fromJson(Map<String, dynamic> json) =>
      _$SurveyCreateFromJson(json);
}

/// Survey update request model matching backend SurveyUpdate
@freezed
sealed class SurveyUpdate with _$SurveyUpdate {
  const factory SurveyUpdate({
    String? title,
    String? description,
    @JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'question_ids') List<int>? questionIds,
    List<SurveyQuestionLinkCreate>? questions,
  }) = _SurveyUpdate;

  factory SurveyUpdate.fromJson(Map<String, dynamic> json) =>
      _$SurveyUpdateFromJson(json);
}

/// Survey from template create request
@freezed
sealed class SurveyFromTemplateCreate with _$SurveyFromTemplateCreate {
  const factory SurveyFromTemplateCreate({
    String? title,
    String? description,
  }) = _SurveyFromTemplateCreate;

  factory SurveyFromTemplateCreate.fromJson(Map<String, dynamic> json) =>
      _$SurveyFromTemplateCreateFromJson(json);
}

/// Survey response model matching backend SurveyResponse
@freezed
sealed class Survey with _$Survey {
  const factory Survey({
    @JsonKey(name: 'survey_id') required int surveyId,
    required String title,
    String? description,
    required String status,
    @JsonKey(name: 'publication_status') required String publicationStatus,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    List<QuestionInSurvey>? questions,
    @JsonKey(name: 'question_count') int? questionCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Survey;

  factory Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);
}