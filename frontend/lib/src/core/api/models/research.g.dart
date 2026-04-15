// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResearchSurvey _$ResearchSurveyFromJson(Map<String, dynamic> json) =>
    _ResearchSurvey(
      surveyId: (json['survey_id'] as num).toInt(),
      title: json['title'] as String,
      publicationStatus: json['publication_status'] as String,
      responseCount: (json['response_count'] as num).toInt(),
      questionCount: (json['question_count'] as num).toInt(),
    );

Map<String, dynamic> _$ResearchSurveyToJson(_ResearchSurvey instance) =>
    <String, dynamic>{
      'survey_id': instance.surveyId,
      'title': instance.title,
      'publication_status': instance.publicationStatus,
      'response_count': instance.responseCount,
      'question_count': instance.questionCount,
    };

_SurveyOverview _$SurveyOverviewFromJson(Map<String, dynamic> json) =>
    _SurveyOverview(
      surveyId: (json['survey_id'] as num).toInt(),
      title: json['title'] as String,
      respondentCount: (json['respondent_count'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      questionCount: (json['question_count'] as num).toInt(),
      suppressed: json['suppressed'] as bool,
      minResponses: (json['min_responses'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$SurveyOverviewToJson(_SurveyOverview instance) =>
    <String, dynamic>{
      'survey_id': instance.surveyId,
      'title': instance.title,
      'respondent_count': instance.respondentCount,
      'completion_rate': instance.completionRate,
      'question_count': instance.questionCount,
      'suppressed': instance.suppressed,
      'min_responses': instance.minResponses,
    };

_QuestionAggregate _$QuestionAggregateFromJson(Map<String, dynamic> json) =>
    _QuestionAggregate(
      questionId: (json['question_id'] as num).toInt(),
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      category: json['category'] as String?,
      responseCount: (json['response_count'] as num).toInt(),
      suppressed: json['suppressed'] as bool,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$QuestionAggregateToJson(_QuestionAggregate instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'category': instance.category,
      'response_count': instance.responseCount,
      'suppressed': instance.suppressed,
      'data': instance.data,
    };

_AggregateResponse _$AggregateResponseFromJson(Map<String, dynamic> json) =>
    _AggregateResponse(
      surveyId: (json['survey_id'] as num).toInt(),
      title: json['title'] as String,
      totalRespondents: (json['total_respondents'] as num).toInt(),
      aggregates: (json['aggregates'] as List<dynamic>)
          .map((e) => QuestionAggregate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AggregateResponseToJson(_AggregateResponse instance) =>
    <String, dynamic>{
      'survey_id': instance.surveyId,
      'title': instance.title,
      'total_respondents': instance.totalRespondents,
      'aggregates': instance.aggregates,
    };

_ResponseQuestion _$ResponseQuestionFromJson(Map<String, dynamic> json) =>
    _ResponseQuestion(
      questionId: (json['question_id'] as num).toInt(),
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$ResponseQuestionToJson(_ResponseQuestion instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'question_content': instance.questionContent,
      'response_type': instance.responseType,
      'category': instance.category,
    };

_ResponseRow _$ResponseRowFromJson(Map<String, dynamic> json) => _ResponseRow(
  anonymousId: json['anonymous_id'] as String,
  responses: Map<String, String>.from(json['responses'] as Map),
);

Map<String, dynamic> _$ResponseRowToJson(_ResponseRow instance) =>
    <String, dynamic>{
      'anonymous_id': instance.anonymousId,
      'responses': instance.responses,
    };

_IndividualResponseData _$IndividualResponseDataFromJson(
  Map<String, dynamic> json,
) => _IndividualResponseData(
  surveyId: (json['survey_id'] as num).toInt(),
  title: json['title'] as String,
  respondentCount: (json['respondent_count'] as num).toInt(),
  suppressed: json['suppressed'] as bool,
  reason: json['reason'] as String?,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => ResponseQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => ResponseRow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IndividualResponseDataToJson(
  _IndividualResponseData instance,
) => <String, dynamic>{
  'survey_id': instance.surveyId,
  'title': instance.title,
  'respondent_count': instance.respondentCount,
  'suppressed': instance.suppressed,
  'reason': instance.reason,
  'questions': instance.questions,
  'rows': instance.rows,
};

_CrossSurveyQuestion _$CrossSurveyQuestionFromJson(Map<String, dynamic> json) =>
    _CrossSurveyQuestion(
      questionId: (json['question_id'] as num).toInt(),
      questionContent: json['question_content'] as String,
      responseType: json['response_type'] as String,
      category: json['category'] as String?,
      surveyId: (json['survey_id'] as num).toInt(),
      surveyTitle: json['survey_title'] as String,
      surveyStartDate: json['survey_start_date'] as String?,
    );

Map<String, dynamic> _$CrossSurveyQuestionToJson(
  _CrossSurveyQuestion instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'question_content': instance.questionContent,
  'response_type': instance.responseType,
  'category': instance.category,
  'survey_id': instance.surveyId,
  'survey_title': instance.surveyTitle,
  'survey_start_date': instance.surveyStartDate,
};

_CrossSurveyRow _$CrossSurveyRowFromJson(Map<String, dynamic> json) =>
    _CrossSurveyRow(
      anonymousId: json['anonymous_id'] as String,
      responses: Map<String, String>.from(json['responses'] as Map),
    );

Map<String, dynamic> _$CrossSurveyRowToJson(_CrossSurveyRow instance) =>
    <String, dynamic>{
      'anonymous_id': instance.anonymousId,
      'responses': instance.responses,
    };

_CrossSurveySummary _$CrossSurveySummaryFromJson(Map<String, dynamic> json) =>
    _CrossSurveySummary(
      surveyId: (json['survey_id'] as num).toInt(),
      title: json['title'] as String,
      respondentCount: (json['respondent_count'] as num).toInt(),
    );

Map<String, dynamic> _$CrossSurveySummaryToJson(_CrossSurveySummary instance) =>
    <String, dynamic>{
      'survey_id': instance.surveyId,
      'title': instance.title,
      'respondent_count': instance.respondentCount,
    };

_CrossSurveyOverview _$CrossSurveyOverviewFromJson(Map<String, dynamic> json) =>
    _CrossSurveyOverview(
      surveyIds: (json['survey_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      surveys: (json['surveys'] as List<dynamic>)
          .map((e) => CrossSurveySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRespondentCount: (json['total_respondent_count'] as num).toInt(),
      totalQuestionCount: (json['total_question_count'] as num).toInt(),
      avgCompletionRate: (json['avg_completion_rate'] as num).toDouble(),
      suppressed: json['suppressed'] as bool,
      reason: json['reason'] as String?,
      minResponses: (json['min_responses'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$CrossSurveyOverviewToJson(
  _CrossSurveyOverview instance,
) => <String, dynamic>{
  'survey_ids': instance.surveyIds,
  'surveys': instance.surveys,
  'total_respondent_count': instance.totalRespondentCount,
  'total_question_count': instance.totalQuestionCount,
  'avg_completion_rate': instance.avgCompletionRate,
  'suppressed': instance.suppressed,
  'reason': instance.reason,
  'min_responses': instance.minResponses,
};

_CrossSurveyAggregateResponse _$CrossSurveyAggregateResponseFromJson(
  Map<String, dynamic> json,
) => _CrossSurveyAggregateResponse(
  surveyIds: (json['survey_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  totalRespondents: (json['total_respondents'] as num).toInt(),
  aggregates: (json['aggregates'] as List<dynamic>)
      .map((e) => QuestionAggregate.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CrossSurveyAggregateResponseToJson(
  _CrossSurveyAggregateResponse instance,
) => <String, dynamic>{
  'survey_ids': instance.surveyIds,
  'total_respondents': instance.totalRespondents,
  'aggregates': instance.aggregates,
};

_CrossSurveyResponseData _$CrossSurveyResponseDataFromJson(
  Map<String, dynamic> json,
) => _CrossSurveyResponseData(
  surveyIds: (json['survey_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  surveys: (json['surveys'] as List<dynamic>)
      .map((e) => CrossSurveySummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalRespondentCount: (json['total_respondent_count'] as num).toInt(),
  dateFrom: json['date_from'] as String?,
  dateTo: json['date_to'] as String?,
  suppressed: json['suppressed'] as bool,
  reason: json['reason'] as String?,
  suppressedSurveys:
      (json['suppressed_surveys'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  questions: (json['questions'] as List<dynamic>)
      .map((e) => CrossSurveyQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => CrossSurveyRow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CrossSurveyResponseDataToJson(
  _CrossSurveyResponseData instance,
) => <String, dynamic>{
  'survey_ids': instance.surveyIds,
  'surveys': instance.surveys,
  'total_respondent_count': instance.totalRespondentCount,
  'date_from': instance.dateFrom,
  'date_to': instance.dateTo,
  'suppressed': instance.suppressed,
  'reason': instance.reason,
  'suppressed_surveys': instance.suppressedSurveys,
  'questions': instance.questions,
  'rows': instance.rows,
};
