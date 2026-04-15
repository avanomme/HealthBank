// Created with the Assistance of Claude Code
// frontend/lib/core/api/models/question.dart
/// Question Bank models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;


import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

/// Response type enum matching backend ResponseType
/// Named QuestionResponseType to avoid collision with dio.ResponseType
enum QuestionResponseType {
  @JsonValue('number')
  number,
  @JsonValue('yesno')
  yesno,
  @JsonValue('openended')
  openended,
  @JsonValue('single_choice')
  singleChoice,
  @JsonValue('multi_choice')
  multiChoice,
  @JsonValue('scale')
  scale,
}

/// Question option for choice-based questions
@freezed
sealed class QuestionOptionCreate with _$QuestionOptionCreate {
  const factory QuestionOptionCreate({
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _QuestionOptionCreate;

  factory QuestionOptionCreate.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionCreateFromJson(json);
}

/// Question create request model matching backend QuestionCreate
@freezed
sealed class QuestionCreate with _$QuestionCreate {
  const factory QuestionCreate({
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
    String? category,
    List<QuestionOptionCreate>? options,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
  }) = _QuestionCreate;

  factory QuestionCreate.fromJson(Map<String, dynamic> json) =>
      _$QuestionCreateFromJson(json);
}

/// Question update request model matching backend QuestionUpdate
@freezed
sealed class QuestionUpdate with _$QuestionUpdate {
  const factory QuestionUpdate({
    String? title,
    @JsonKey(name: 'question_content') String? questionContent,
    @JsonKey(name: 'response_type') String? responseType,
    @JsonKey(name: 'is_required') bool? isRequired,
    String? category,
    @JsonKey(name: 'is_active') bool? isActive,
    List<QuestionOptionCreate>? options,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
  }) = _QuestionUpdate;

  factory QuestionUpdate.fromJson(Map<String, dynamic> json) =>
      _$QuestionUpdateFromJson(json);
}

/// Question option response model
@freezed
sealed class QuestionOptionResponse with _$QuestionOptionResponse {
  const factory QuestionOptionResponse({
    @JsonKey(name: 'option_id') required int optionId,
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _QuestionOptionResponse;

  factory QuestionOptionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionResponseFromJson(json);
}

/// Question response model matching backend QuestionResponse
@freezed
sealed class Question with _$Question {
  const factory Question({
    @JsonKey(name: 'question_id') required int questionId,
    String? title,
    @JsonKey(name: 'question_content') required String questionContent,
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'is_required') required bool isRequired,
    String? category,
    @JsonKey(name: 'is_active') bool? isActive,
    List<QuestionOptionResponse>? options,
    @JsonKey(name: 'scale_min') int? scaleMin,
    @JsonKey(name: 'scale_max') int? scaleMax,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

/// Question category response model matching backend CategoryResponse
@freezed
sealed class QuestionCategory with _$QuestionCategory {
  const factory QuestionCategory({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_key') required String categoryKey,
    @JsonKey(name: 'display_order') required int displayOrder,
  }) = _QuestionCategory;

  factory QuestionCategory.fromJson(Map<String, dynamic> json) =>
      _$QuestionCategoryFromJson(json);
}
