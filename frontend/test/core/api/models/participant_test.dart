import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/participant.dart';

void main() {
  group('Participant API models', () {
    test('ParticipantSurveyQuestionsResponse and nested question models round-trip', () {
      const model = ParticipantSurveyQuestionsResponse(
        surveyId: 7,
        title: 'Daily Check-In',
        questions: [
          ParticipantSurveyQuestion(
            questionId: 11,
            title: 'Mood',
            questionContent: 'How are you feeling today?',
            responseType: 'single_choice',
            isRequired: true,
            category: 'Wellness',
            options: [
              ParticipantQuestionOption(
                optionId: 1,
                optionText: 'Good',
                displayOrder: 1,
              ),
            ],
            scaleMin: 1,
            scaleMax: 5,
          ),
        ],
      );

      final parsed = ParticipantSurveyQuestionsResponse.fromJson(model.toJson());
      expect(parsed, model);
    });

    test('ParticipantSurveyListItem preserves assignment metadata', () {
      final model = ParticipantSurveyListItem(
        surveyId: 9,
        title: 'Sleep Survey',
        startDate: DateTime.parse('2024-01-01T00:00:00.000Z'),
        endDate: DateTime.parse('2024-01-31T00:00:00.000Z'),
        assignmentStatus: 'pending',
        assignedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
        dueDate: DateTime.parse('2024-01-10T00:00:00.000Z'),
        completedAt: DateTime.parse('2024-01-09T00:00:00.000Z'),
        publicationStatus: 'published',
      );

      final parsed = ParticipantSurveyListItem.fromJson(model.toJson());
      expect(parsed, model);
    });

    test('ParticipantSurveyWithResponses and question responses round-trip', () {
      final model = ParticipantSurveyWithResponses(
        surveyId: 4,
        title: 'Energy Levels',
        publicationStatus: 'published',
        assignmentStatus: 'completed',
        assignedAt: DateTime.parse('2024-02-01T00:00:00.000Z'),
        dueDate: DateTime.parse('2024-02-07T00:00:00.000Z'),
        completedAt: DateTime.parse('2024-02-05T00:00:00.000Z'),
        questions: const [
          ParticipantQuestionResponse(
            questionId: 1,
            title: 'Energy',
            questionContent: 'How is your energy?',
            responseType: 'scale',
            isRequired: true,
            category: 'Health',
            responseValue: '4',
          ),
        ],
      );

      final parsed = ParticipantSurveyWithResponses.fromJson(model.toJson());
      expect(parsed, model);
    });

    test('ParticipantChartDataResponse preserves aggregates and suppression', () {
      const model = ParticipantChartDataResponse(
        surveyId: 4,
        title: 'Results',
        totalRespondents: 12,
        questions: [
          ChartQuestionData(
            questionId: 1,
            questionContent: 'Energy',
            responseType: 'scale',
            category: 'Health',
            responseValue: '4',
            aggregate: {
              'average': 3.5,
              'distribution': {'1': 1, '4': 3},
            },
            suppressed: true,
          ),
        ],
      );

      final parsed = ParticipantChartDataResponse.fromJson(model.toJson());
      expect(parsed, model);
    });

    test('ParticipantSurveyCompareResponse round-trips participant answers', () {
      const model = ParticipantSurveyCompareResponse(
        surveyId: 8,
        participantAnswers: [
          ParticipantAnswerOut(questionId: 1, responseValue: 'Yes'),
        ],
        aggregates: {
          '1': {'yes': 8, 'no': 2},
        },
      );

      final parsed = ParticipantSurveyCompareResponse.fromJson(model.toJson());
      expect(parsed, model);
    });
  });
}
