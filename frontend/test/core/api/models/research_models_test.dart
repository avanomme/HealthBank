// Created with the Assistance of Claude Code
// frontend/test/core/api/models/research_models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/research.dart';

void main() {
  group('Research Models', () {
    group('ResearchSurvey', () {
      test('fromJson parses snake_case JSON correctly', () {
        final json = {
          'survey_id': 10,
          'title': 'Health Screening Survey',
          'publication_status': 'published',
          'response_count': 42,
          'question_count': 15,
        };

        final survey = ResearchSurvey.fromJson(json);

        expect(survey.surveyId, 10);
        expect(survey.title, 'Health Screening Survey');
        expect(survey.publicationStatus, 'published');
        expect(survey.responseCount, 42);
        expect(survey.questionCount, 15);
      });

      test('toJson produces snake_case keys', () {
        const survey = ResearchSurvey(
          surveyId: 5,
          title: 'Test',
          publicationStatus: 'draft',
          responseCount: 0,
          questionCount: 3,
        );

        final json = survey.toJson();

        expect(json['survey_id'], 5);
        expect(json['title'], 'Test');
        expect(json['publication_status'], 'draft');
        expect(json['response_count'], 0);
        expect(json['question_count'], 3);
      });

      test('equality works correctly', () {
        const a = ResearchSurvey(
          surveyId: 1,
          title: 'S',
          publicationStatus: 'published',
          responseCount: 10,
          questionCount: 5,
        );
        const b = ResearchSurvey(
          surveyId: 1,
          title: 'S',
          publicationStatus: 'published',
          responseCount: 10,
          questionCount: 5,
        );
        const c = ResearchSurvey(
          surveyId: 2,
          title: 'S',
          publicationStatus: 'published',
          responseCount: 10,
          questionCount: 5,
        );

        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('SurveyOverview', () {
      test('fromJson parses snake_case JSON correctly', () {
        final json = {
          'survey_id': 7,
          'title': 'Wellness Check',
          'respondent_count': 25,
          'completion_rate': 0.85,
          'question_count': 12,
          'suppressed': false,
        };

        final overview = SurveyOverview.fromJson(json);

        expect(overview.surveyId, 7);
        expect(overview.title, 'Wellness Check');
        expect(overview.respondentCount, 25);
        expect(overview.completionRate, 0.85);
        expect(overview.questionCount, 12);
        expect(overview.suppressed, false);
      });

      test('toJson produces snake_case keys', () {
        const overview = SurveyOverview(
          surveyId: 3,
          title: 'Test Overview',
          respondentCount: 50,
          completionRate: 0.92,
          questionCount: 8,
          suppressed: false,
        );

        final json = overview.toJson();

        expect(json['survey_id'], 3);
        expect(json['respondent_count'], 50);
        expect(json['completion_rate'], 0.92);
        expect(json['question_count'], 8);
        expect(json['suppressed'], false);
      });

      test('handles suppressed survey', () {
        final json = {
          'survey_id': 1,
          'title': 'Low Response Survey',
          'respondent_count': 3,
          'completion_rate': 0.0,
          'question_count': 5,
          'suppressed': true,
        };

        final overview = SurveyOverview.fromJson(json);

        expect(overview.suppressed, true);
        expect(overview.respondentCount, 3);
      });
    });

    group('QuestionAggregate', () {
      test('fromJson parses all fields including data Map', () {
        final json = {
          'question_id': 42,
          'question_content': 'What is your age?',
          'response_type': 'number',
          'category': 'demographics',
          'response_count': 30,
          'suppressed': false,
          'data': {
            'min': 18.0,
            'max': 65.0,
            'mean': 34.5,
            'median': 32.0,
            'std_dev': 12.3,
          },
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.questionId, 42);
        expect(agg.questionContent, 'What is your age?');
        expect(agg.responseType, 'number');
        expect(agg.category, 'demographics');
        expect(agg.responseCount, 30);
        expect(agg.suppressed, false);
        expect(agg.data, isNotNull);
        expect(agg.data!['min'], 18.0);
        expect(agg.data!['max'], 65.0);
        expect(agg.data!['mean'], 34.5);
      });

      test('fromJson handles suppressed=true with null data', () {
        final json = {
          'question_id': 5,
          'question_content': 'Sensitive question',
          'response_type': 'yesno',
          'response_count': 3,
          'suppressed': true,
          'data': null,
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.suppressed, true);
        expect(agg.data, isNull);
        expect(agg.responseCount, 3);
        expect(agg.category, isNull);
      });

      test('fromJson handles yesno response type data', () {
        final json = {
          'question_id': 10,
          'question_content': 'Do you exercise regularly?',
          'response_type': 'yesno',
          'category': 'health',
          'response_count': 20,
          'suppressed': false,
          'data': {
            'yes_count': 14,
            'no_count': 6,
            'yes_pct': 70.0,
            'no_pct': 30.0,
          },
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.data!['yes_count'], 14);
        expect(agg.data!['no_count'], 6);
        expect(agg.data!['yes_pct'], 70.0);
      });

      test('fromJson handles single_choice data with options', () {
        final json = {
          'question_id': 15,
          'question_content': 'Favorite fruit?',
          'response_type': 'single_choice',
          'response_count': 25,
          'suppressed': false,
          'data': {
            'options': [
              {'option_text': 'Apple', 'count': 10, 'pct': 40.0},
              {'option_text': 'Banana', 'count': 8, 'pct': 32.0},
              {'option_text': 'Cherry', 'count': 7, 'pct': 28.0},
            ],
          },
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.data!['options'], isList);
        final options = agg.data!['options'] as List;
        expect(options, hasLength(3));
        expect(options[0]['option_text'], 'Apple');
        expect(options[0]['count'], 10);
      });

      test('toJson produces snake_case keys', () {
        const agg = QuestionAggregate(
          questionId: 1,
          questionContent: 'Test?',
          responseType: 'openended',
          responseCount: 10,
          suppressed: false,
        );

        final json = agg.toJson();

        expect(json['question_id'], 1);
        expect(json['question_content'], 'Test?');
        expect(json['response_type'], 'openended');
        expect(json['response_count'], 10);
      });
    });

    group('AggregateResponse', () {
      test('fromJson parses nested list of QuestionAggregate', () {
        final json = {
          'survey_id': 1,
          'title': 'Health Survey',
          'total_respondents': 50,
          'aggregates': [
            {
              'question_id': 1,
              'question_content': 'Age?',
              'response_type': 'number',
              'response_count': 50,
              'suppressed': false,
              'data': {'min': 18.0, 'max': 80.0, 'mean': 45.0},
            },
            {
              'question_id': 2,
              'question_content': 'Exercise?',
              'response_type': 'yesno',
              'response_count': 48,
              'suppressed': false,
              'data': {'yes_count': 30, 'no_count': 18},
            },
            {
              'question_id': 3,
              'question_content': 'Comments',
              'response_type': 'openended',
              'response_count': 2,
              'suppressed': true,
              'data': null,
            },
          ],
        };

        final response = AggregateResponse.fromJson(json);

        expect(response.surveyId, 1);
        expect(response.title, 'Health Survey');
        expect(response.totalRespondents, 50);
        expect(response.aggregates, hasLength(3));
        expect(response.aggregates[0].questionId, 1);
        expect(response.aggregates[0].responseType, 'number');
        expect(response.aggregates[1].questionId, 2);
        expect(response.aggregates[1].responseType, 'yesno');
        expect(response.aggregates[2].suppressed, true);
      });

      test('toJson produces snake_case keys', () {
        const response = AggregateResponse(
          surveyId: 2,
          title: 'Test',
          totalRespondents: 10,
          aggregates: [],
        );

        final json = response.toJson();

        expect(json['survey_id'], 2);
        expect(json['total_respondents'], 10);
        expect(json['aggregates'], isEmpty);
      });

      test('handles empty aggregates list', () {
        final json = {
          'survey_id': 99,
          'title': 'Empty Survey',
          'total_respondents': 0,
          'aggregates': <Map<String, dynamic>>[],
        };

        final response = AggregateResponse.fromJson(json);

        expect(response.aggregates, isEmpty);
        expect(response.totalRespondents, 0);
      });
    });

    group('ResponseQuestion', () {
      test('fromJson parses snake_case JSON correctly', () {
        final json = {
          'question_id': 5,
          'question_content': 'How old are you?',
          'response_type': 'number',
          'category': 'demographics',
        };

        final q = ResponseQuestion.fromJson(json);

        expect(q.questionId, 5);
        expect(q.questionContent, 'How old are you?');
        expect(q.responseType, 'number');
        expect(q.category, 'demographics');
      });

      test('handles null category', () {
        final json = {
          'question_id': 1,
          'question_content': 'Test?',
          'response_type': 'yesno',
        };

        final q = ResponseQuestion.fromJson(json);
        expect(q.category, isNull);
      });

      test('toJson produces snake_case keys', () {
        const q = ResponseQuestion(
          questionId: 3,
          questionContent: 'Comments?',
          responseType: 'openended',
          category: 'general',
        );

        final json = q.toJson();
        expect(json['question_id'], 3);
        expect(json['question_content'], 'Comments?');
        expect(json['response_type'], 'openended');
      });
    });

    group('ResponseRow', () {
      test('fromJson parses anonymous_id and responses map', () {
        final json = {
          'anonymous_id': 'R-abc12345',
          'responses': {'1': '25', '2': 'Yes', '3': 'Option A'},
        };

        final row = ResponseRow.fromJson(json);

        expect(row.anonymousId, 'R-abc12345');
        expect(row.responses['1'], '25');
        expect(row.responses['2'], 'Yes');
        expect(row.responses['3'], 'Option A');
      });

      test('toJson produces correct structure', () {
        const row = ResponseRow(
          anonymousId: 'R-test1234',
          responses: {'1': 'value1', '2': 'value2'},
        );

        final json = row.toJson();
        expect(json['anonymous_id'], 'R-test1234');
        expect(json['responses']['1'], 'value1');
      });

      test('equality works correctly', () {
        const a = ResponseRow(
          anonymousId: 'R-abc',
          responses: {'1': 'Yes'},
        );
        const b = ResponseRow(
          anonymousId: 'R-abc',
          responses: {'1': 'Yes'},
        );
        const c = ResponseRow(
          anonymousId: 'R-def',
          responses: {'1': 'No'},
        );

        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('IndividualResponseData', () {
      test('fromJson parses complete structure', () {
        final json = {
          'survey_id': 1,
          'title': 'Health Survey',
          'respondent_count': 10,
          'suppressed': false,
          'questions': [
            {
              'question_id': 1,
              'question_content': 'Age?',
              'response_type': 'number',
              'category': 'demographics',
            },
          ],
          'rows': [
            {
              'anonymous_id': 'R-abc12345',
              'responses': {'1': '25'},
            },
            {
              'anonymous_id': 'R-def67890',
              'responses': {'1': '30'},
            },
          ],
        };

        final data = IndividualResponseData.fromJson(json);

        expect(data.surveyId, 1);
        expect(data.title, 'Health Survey');
        expect(data.respondentCount, 10);
        expect(data.suppressed, false);
        expect(data.reason, isNull);
        expect(data.questions, hasLength(1));
        expect(data.questions[0].questionId, 1);
        expect(data.rows, hasLength(2));
        expect(data.rows[0].anonymousId, 'R-abc12345');
        expect(data.rows[0].responses['1'], '25');
      });

      test('fromJson handles suppressed data', () {
        final json = {
          'survey_id': 2,
          'title': 'Small Survey',
          'respondent_count': 3,
          'suppressed': true,
          'reason': 'insufficient_responses',
          'questions': <Map<String, dynamic>>[],
          'rows': <Map<String, dynamic>>[],
        };

        final data = IndividualResponseData.fromJson(json);

        expect(data.suppressed, true);
        expect(data.reason, 'insufficient_responses');
        expect(data.questions, isEmpty);
        expect(data.rows, isEmpty);
      });

      test('toJson produces snake_case keys', () {
        const data = IndividualResponseData(
          surveyId: 5,
          title: 'Test',
          respondentCount: 20,
          suppressed: false,
          questions: [],
          rows: [],
        );

        final json = data.toJson();

        expect(json['survey_id'], 5);
        expect(json['respondent_count'], 20);
        expect(json['suppressed'], false);
      });
    });

    group('Optional fields', () {
      test('QuestionAggregate handles missing optional category', () {
        final json = {
          'question_id': 1,
          'question_content': 'Test?',
          'response_type': 'yesno',
          'response_count': 10,
          'suppressed': false,
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.category, isNull);
        expect(agg.data, isNull);
      });

      test('QuestionAggregate handles missing optional data', () {
        final json = {
          'question_id': 2,
          'question_content': 'Open question',
          'response_type': 'openended',
          'category': 'general',
          'response_count': 15,
          'suppressed': false,
        };

        final agg = QuestionAggregate.fromJson(json);

        expect(agg.category, 'general');
        expect(agg.data, isNull);
      });
    });
  });
}
