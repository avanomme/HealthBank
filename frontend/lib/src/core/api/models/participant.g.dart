// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantSurveyQuestionsResponse
_$ParticipantSurveyQuestionsResponseFromJson(Map<String, dynamic> json) =>
    _ParticipantSurveyQuestionsResponse(
      surveyId: (json['survey_id'] as num).toInt(),
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map(
            (e) =>
                ParticipantSurveyQuestion.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ParticipantSurveyQuestionsResponseToJson(
  _ParticipantSurveyQuestionsResponse instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_ParticipantSurveyQuestion _$ParticipantSurveyQuestionFromJson(
  Map<String, dynamic> json,
) => _ParticipantSurveyQuestion(
  questionId: (json['question_id'] as num).toInt(),
  title: json['title'] as String?,
  questionContent: json['question_content'] as String,
  responseType: json['response_type'] as String,
  isRequired: json['is_required'] as bool,
  category: json['category'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map(
        (e) => ParticipantQuestionOption.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  scaleMin: (json['scale_min'] as num?)?.toInt(),
  scaleMax: (json['scale_max'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParticipantSurveyQuestionToJson(
  _ParticipantSurveyQuestion instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'title': instance.title,
  'question_content': instance.questionContent,
  'response_type': instance.responseType,
  'is_required': instance.isRequired,
  'category': instance.category,
  'options': instance.options?.map((e) => e.toJson()).toList(),
  'scale_min': instance.scaleMin,
  'scale_max': instance.scaleMax,
};

_ParticipantQuestionOption _$ParticipantQuestionOptionFromJson(
  Map<String, dynamic> json,
) => _ParticipantQuestionOption(
  optionId: (json['option_id'] as num).toInt(),
  optionText: json['option_text'] as String,
  displayOrder: (json['display_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParticipantQuestionOptionToJson(
  _ParticipantQuestionOption instance,
) => <String, dynamic>{
  'option_id': instance.optionId,
  'option_text': instance.optionText,
  'display_order': instance.displayOrder,
};

_ParticipantSurveyListItem _$ParticipantSurveyListItemFromJson(
  Map<String, dynamic> json,
) => _ParticipantSurveyListItem(
  surveyId: (json['survey_id'] as num).toInt(),
  title: json['title'] as String,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  assignmentStatus: json['assignment_status'] as String,
  hasDraft: json['has_draft'] as bool? ?? false,
  assignedAt: json['assigned_at'] == null
      ? null
      : DateTime.parse(json['assigned_at'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  publicationStatus: json['publication_status'] as String,
);

Map<String, dynamic> _$ParticipantSurveyListItemToJson(
  _ParticipantSurveyListItem instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'assignment_status': instance.assignmentStatus,
  'has_draft': instance.hasDraft,
  'assigned_at': instance.assignedAt?.toIso8601String(),
  'due_date': instance.dueDate?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'publication_status': instance.publicationStatus,
};

_ParticipantQuestionResponse _$ParticipantQuestionResponseFromJson(
  Map<String, dynamic> json,
) => _ParticipantQuestionResponse(
  questionId: (json['question_id'] as num).toInt(),
  title: json['title'] as String?,
  questionContent: json['question_content'] as String,
  responseType: json['response_type'] as String,
  isRequired: json['is_required'] as bool,
  category: json['category'] as String?,
  responseValue: json['response_value'] as String?,
);

Map<String, dynamic> _$ParticipantQuestionResponseToJson(
  _ParticipantQuestionResponse instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'title': instance.title,
  'question_content': instance.questionContent,
  'response_type': instance.responseType,
  'is_required': instance.isRequired,
  'category': instance.category,
  'response_value': instance.responseValue,
};

_ParticipantSurveyWithResponses _$ParticipantSurveyWithResponsesFromJson(
  Map<String, dynamic> json,
) => _ParticipantSurveyWithResponses(
  surveyId: (json['survey_id'] as num).toInt(),
  title: json['title'] as String,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  publicationStatus: json['publication_status'] as String,
  assignmentStatus: json['assignment_status'] as String?,
  assignedAt: json['assigned_at'] == null
      ? null
      : DateTime.parse(json['assigned_at'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  questions: (json['questions'] as List<dynamic>)
      .map(
        (e) => ParticipantQuestionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ParticipantSurveyWithResponsesToJson(
  _ParticipantSurveyWithResponses instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'publication_status': instance.publicationStatus,
  'assignment_status': instance.assignmentStatus,
  'assigned_at': instance.assignedAt?.toIso8601String(),
  'due_date': instance.dueDate?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_ChartQuestionData _$ChartQuestionDataFromJson(Map<String, dynamic> json) =>
    _ChartQuestionData(
      questionId: (json['question_id'] as num).toInt(),
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      category: json['category'] as String?,
      responseValue: json['response_value'] as String?,
      aggregate: json['aggregate'] as Map<String, dynamic>?,
      suppressed: json['suppressed'] as bool? ?? false,
    );

Map<String, dynamic> _$ChartQuestionDataToJson(_ChartQuestionData instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'category': instance.category,
      'response_value': instance.responseValue,
      'aggregate': instance.aggregate,
      'suppressed': instance.suppressed,
    };

_ParticipantChartDataResponse _$ParticipantChartDataResponseFromJson(
  Map<String, dynamic> json,
) => _ParticipantChartDataResponse(
  surveyId: (json['survey_id'] as num).toInt(),
  title: json['title'] as String,
  totalRespondents: (json['total_respondents'] as num).toInt(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => ChartQuestionData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ParticipantChartDataResponseToJson(
  _ParticipantChartDataResponse instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'total_respondents': instance.totalRespondents,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_ParticipantAnswerOut _$ParticipantAnswerOutFromJson(
  Map<String, dynamic> json,
) => _ParticipantAnswerOut(
  questionId: (json['question_id'] as num).toInt(),
  responseValue: json['response_value'] as String?,
);

Map<String, dynamic> _$ParticipantAnswerOutToJson(
  _ParticipantAnswerOut instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'response_value': instance.responseValue,
};

_ParticipantSurveyCompareResponse _$ParticipantSurveyCompareResponseFromJson(
  Map<String, dynamic> json,
) => _ParticipantSurveyCompareResponse(
  surveyId: (json['survey_id'] as num).toInt(),
  participantAnswers: (json['participant_answers'] as List<dynamic>)
      .map((e) => ParticipantAnswerOut.fromJson(e as Map<String, dynamic>))
      .toList(),
  aggregates: json['aggregates'] as Map<String, dynamic>,
);

Map<String, dynamic> _$ParticipantSurveyCompareResponseToJson(
  _ParticipantSurveyCompareResponse instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'participant_answers': instance.participantAnswers
      .map((e) => e.toJson())
      .toList(),
  'aggregates': instance.aggregates,
};

_ParticipantSurveyDraftResponse _$ParticipantSurveyDraftResponseFromJson(
  Map<String, dynamic> json,
) => _ParticipantSurveyDraftResponse(
  draft:
      (json['draft'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$ParticipantSurveyDraftResponseToJson(
  _ParticipantSurveyDraftResponse instance,
) => <String, dynamic>{'draft': instance.draft};
