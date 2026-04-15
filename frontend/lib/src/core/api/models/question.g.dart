// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionOptionCreate _$QuestionOptionCreateFromJson(
  Map<String, dynamic> json,
) => _QuestionOptionCreate(
  optionText: json['option_text'] as String,
  displayOrder: (json['display_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuestionOptionCreateToJson(
  _QuestionOptionCreate instance,
) => <String, dynamic>{
  'option_text': instance.optionText,
  'display_order': instance.displayOrder,
};

_QuestionCreate _$QuestionCreateFromJson(Map<String, dynamic> json) =>
    _QuestionCreate(
      title: json['title'] as String?,
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      isRequired: json['is_required'] as bool? ?? false,
      category: json['category'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOptionCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
      scaleMin: (json['scale_min'] as num?)?.toInt(),
      scaleMax: (json['scale_max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuestionCreateToJson(_QuestionCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'is_required': instance.isRequired,
      'category': instance.category,
      'options': instance.options,
      'scale_min': instance.scaleMin,
      'scale_max': instance.scaleMax,
    };

_QuestionUpdate _$QuestionUpdateFromJson(Map<String, dynamic> json) =>
    _QuestionUpdate(
      title: json['title'] as String?,
      questionContent: json['question_content'] as String?,
      responseType: json['response_type'] as String?,
      isRequired: json['is_required'] as bool?,
      category: json['category'] as String?,
      isActive: json['is_active'] as bool?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOptionCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
      scaleMin: (json['scale_min'] as num?)?.toInt(),
      scaleMax: (json['scale_max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuestionUpdateToJson(_QuestionUpdate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'is_required': instance.isRequired,
      'category': instance.category,
      'is_active': instance.isActive,
      'options': instance.options,
      'scale_min': instance.scaleMin,
      'scale_max': instance.scaleMax,
    };

_QuestionOptionResponse _$QuestionOptionResponseFromJson(
  Map<String, dynamic> json,
) => _QuestionOptionResponse(
  optionId: (json['option_id'] as num).toInt(),
  optionText: json['option_text'] as String,
  displayOrder: (json['display_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuestionOptionResponseToJson(
  _QuestionOptionResponse instance,
) => <String, dynamic>{
  'option_id': instance.optionId,
  'option_text': instance.optionText,
  'display_order': instance.displayOrder,
};

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  questionId: (json['question_id'] as num).toInt(),
  title: json['title'] as String?,
  questionContent: json['question_content'] as String,
  responseType: json['response_type'] as String,
  isRequired: json['is_required'] as bool,
  category: json['category'] as String?,
  isActive: json['is_active'] as bool?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => QuestionOptionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  scaleMin: (json['scale_min'] as num?)?.toInt(),
  scaleMax: (json['scale_max'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'question_id': instance.questionId,
  'title': instance.title,
  'question_content': instance.questionContent,
  'response_type': instance.responseType,
  'is_required': instance.isRequired,
  'category': instance.category,
  'is_active': instance.isActive,
  'options': instance.options,
  'scale_min': instance.scaleMin,
  'scale_max': instance.scaleMax,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_QuestionCategory _$QuestionCategoryFromJson(Map<String, dynamic> json) =>
    _QuestionCategory(
      categoryId: (json['category_id'] as num).toInt(),
      categoryKey: json['category_key'] as String,
      displayOrder: (json['display_order'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionCategoryToJson(_QuestionCategory instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_key': instance.categoryKey,
      'display_order': instance.displayOrder,
    };
