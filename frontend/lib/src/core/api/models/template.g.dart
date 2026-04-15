// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TemplateQuestionLinkCreate _$TemplateQuestionLinkCreateFromJson(
  Map<String, dynamic> json,
) => _TemplateQuestionLinkCreate(
  questionId: (json['question_id'] as num).toInt(),
  isRequired: json['is_required'] as bool? ?? false,
);

Map<String, dynamic> _$TemplateQuestionLinkCreateToJson(
  _TemplateQuestionLinkCreate instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'is_required': instance.isRequired,
};

_TemplateCreate _$TemplateCreateFromJson(Map<String, dynamic> json) =>
    _TemplateCreate(
      title: json['title'] as String,
      description: json['description'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      questionIds: (json['question_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map(
            (e) =>
                TemplateQuestionLinkCreate.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$TemplateCreateToJson(_TemplateCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'is_public': instance.isPublic,
      'question_ids': instance.questionIds,
      'questions': instance.questions,
    };

_TemplateUpdate _$TemplateUpdateFromJson(Map<String, dynamic> json) =>
    _TemplateUpdate(
      title: json['title'] as String?,
      description: json['description'] as String?,
      isPublic: json['is_public'] as bool?,
      questionIds: (json['question_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map(
            (e) =>
                TemplateQuestionLinkCreate.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$TemplateUpdateToJson(_TemplateUpdate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'is_public': instance.isPublic,
      'question_ids': instance.questionIds,
      'questions': instance.questions,
    };

_QuestionInTemplate _$QuestionInTemplateFromJson(Map<String, dynamic> json) =>
    _QuestionInTemplate(
      questionId: (json['question_id'] as num).toInt(),
      title: json['title'] as String?,
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      isRequired: json['is_required'] as bool,
      displayOrder: (json['display_order'] as num).toInt(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionInTemplateToJson(_QuestionInTemplate instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'title': instance.title,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'is_required': instance.isRequired,
      'display_order': instance.displayOrder,
      'options': instance.options,
    };

_Template _$TemplateFromJson(Map<String, dynamic> json) => _Template(
  templateId: (json['template_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  isPublic: json['is_public'] as bool,
  questions: (json['questions'] as List<dynamic>?)
      ?.map((e) => QuestionInTemplate.fromJson(e as Map<String, dynamic>))
      .toList(),
  questionCount: (json['question_count'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TemplateToJson(_Template instance) => <String, dynamic>{
  'template_id': instance.templateId,
  'title': instance.title,
  'description': instance.description,
  'is_public': instance.isPublic,
  'questions': instance.questions,
  'question_count': instance.questionCount,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
