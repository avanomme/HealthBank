// Created with the Assistance of Claude Code
// frontend/lib/core/api/models/template.dart
/// Template models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'survey.dart';

part 'template.freezed.dart';
part 'template.g.dart';

/// Per-template question link used when creating/updating templates.
/// Required-ness now belongs to the template-question association.
@freezed
sealed class TemplateQuestionLinkCreate with _$TemplateQuestionLinkCreate {
  const factory TemplateQuestionLinkCreate({
    @JsonKey(name: 'question_id') required int questionId,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
  }) = _TemplateQuestionLinkCreate;

  factory TemplateQuestionLinkCreate.fromJson(Map<String, dynamic> json) =>
      _$TemplateQuestionLinkCreateFromJson(json);
}

/// Template create request model matching backend TemplateCreate
@freezed
sealed class TemplateCreate with _$TemplateCreate {
  const factory TemplateCreate({
    required String title,
    String? description,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'question_ids') List<int>? questionIds,
    List<TemplateQuestionLinkCreate>? questions,
  }) = _TemplateCreate;

  factory TemplateCreate.fromJson(Map<String, dynamic> json) =>
      _$TemplateCreateFromJson(json);
}

/// Template update request model matching backend TemplateUpdate
@freezed
sealed class TemplateUpdate with _$TemplateUpdate {
  const factory TemplateUpdate({
    String? title,
    String? description,
    @JsonKey(name: 'is_public') bool? isPublic,
    @JsonKey(name: 'question_ids') List<int>? questionIds,
    List<TemplateQuestionLinkCreate>? questions,
  }) = _TemplateUpdate;

  factory TemplateUpdate.fromJson(Map<String, dynamic> json) =>
      _$TemplateUpdateFromJson(json);
}

/// Question in template model matching backend QuestionInTemplate
@freezed
sealed class QuestionInTemplate with _$QuestionInTemplate {
  const factory QuestionInTemplate({
    @JsonKey(name: 'question_id') required int questionId,
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') required bool isRequired,
    @JsonKey(name: 'display_order') required int displayOrder,
    List<QuestionOption>? options,
  }) = _QuestionInTemplate;

  factory QuestionInTemplate.fromJson(Map<String, dynamic> json) =>
      _$QuestionInTemplateFromJson(json);
}

/// Template response model matching backend TemplateResponse
@freezed
sealed class Template with _$Template {
  const factory Template({
    @JsonKey(name: 'template_id') required int templateId,
    required String title,
    String? description,
    @JsonKey(name: 'is_public') required bool isPublic,
    List<QuestionInTemplate>? questions,
    @JsonKey(name: 'question_count') int? questionCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Template;

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);
}