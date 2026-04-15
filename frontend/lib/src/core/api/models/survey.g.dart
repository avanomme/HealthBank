// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    _QuestionOption(
      optionId: (json['option_id'] as num).toInt(),
      optionText: json['option_text'] as String,
      displayOrder: (json['display_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuestionOptionToJson(_QuestionOption instance) =>
    <String, dynamic>{
      'option_id': instance.optionId,
      'option_text': instance.optionText,
      'display_order': instance.displayOrder,
    };

_QuestionInSurvey _$QuestionInSurveyFromJson(Map<String, dynamic> json) =>
    _QuestionInSurvey(
      questionId: (json['question_id'] as num).toInt(),
      title: json['title'] as String?,
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      isRequired: json['is_required'] as bool,
      category: json['category'] as String?,
      scaleMin: (json['scale_min'] as num?)?.toInt(),
      scaleMax: (json['scale_max'] as num?)?.toInt(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionInSurveyToJson(_QuestionInSurvey instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'title': instance.title,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'is_required': instance.isRequired,
      'category': instance.category,
      'scale_min': instance.scaleMin,
      'scale_max': instance.scaleMax,
      'options': instance.options,
    };

_SurveyQuestionLinkCreate _$SurveyQuestionLinkCreateFromJson(
  Map<String, dynamic> json,
) => _SurveyQuestionLinkCreate(
  questionId: (json['question_id'] as num).toInt(),
  isRequired: json['is_required'] as bool? ?? false,
);

Map<String, dynamic> _$SurveyQuestionLinkCreateToJson(
  _SurveyQuestionLinkCreate instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'is_required': instance.isRequired,
};

_SurveyCreate _$SurveyCreateFromJson(Map<String, dynamic> json) =>
    _SurveyCreate(
      title: json['title'] as String,
      description: json['description'] as String?,
      publicationStatus: $enumDecodeNullable(
        _$PublicationStatusEnumMap,
        json['publication_status'],
      ),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      questionIds: (json['question_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map(
            (e) => SurveyQuestionLinkCreate.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$SurveyCreateToJson(
  _SurveyCreate instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'publication_status': _$PublicationStatusEnumMap[instance.publicationStatus],
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'question_ids': instance.questionIds,
  'questions': instance.questions,
};

const _$PublicationStatusEnumMap = {
  PublicationStatus.draft: 'draft',
  PublicationStatus.published: 'published',
  PublicationStatus.closed: 'closed',
};

_SurveyUpdate _$SurveyUpdateFromJson(Map<String, dynamic> json) =>
    _SurveyUpdate(
      title: json['title'] as String?,
      description: json['description'] as String?,
      publicationStatus: $enumDecodeNullable(
        _$PublicationStatusEnumMap,
        json['publication_status'],
      ),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      questionIds: (json['question_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map(
            (e) => SurveyQuestionLinkCreate.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$SurveyUpdateToJson(
  _SurveyUpdate instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'publication_status': _$PublicationStatusEnumMap[instance.publicationStatus],
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'question_ids': instance.questionIds,
  'questions': instance.questions,
};

_SurveyFromTemplateCreate _$SurveyFromTemplateCreateFromJson(
  Map<String, dynamic> json,
) => _SurveyFromTemplateCreate(
  title: json['title'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$SurveyFromTemplateCreateToJson(
  _SurveyFromTemplateCreate instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
};

_Survey _$SurveyFromJson(Map<String, dynamic> json) => _Survey(
  surveyId: (json['survey_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  publicationStatus: json['publication_status'] as String,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  questions: (json['questions'] as List<dynamic>?)
      ?.map((e) => QuestionInSurvey.fromJson(e as Map<String, dynamic>))
      .toList(),
  questionCount: (json['question_count'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$SurveyToJson(_Survey instance) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'publication_status': instance.publicationStatus,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'questions': instance.questions,
  'question_count': instance.questionCount,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
