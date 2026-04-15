import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/api/services/participant_api.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FakeParticipantApi implements ParticipantApi {
  int? questionsSurveyId;
  String? questionsLang;
  int? compareSurveyId;
  int? chartSurveyId;

  final ParticipantSurveyQuestionsResponse questionsResponse =
      const ParticipantSurveyQuestionsResponse(
    surveyId: 42,
    title: 'Survey',
    questions: [],
  );

  final List<ParticipantSurveyListItem> surveysResponse = const [
    ParticipantSurveyListItem(
      surveyId: 1,
      title: 'Check-in',
      assignmentStatus: 'pending',
      publicationStatus: 'published',
    ),
  ];

  final List<ParticipantSurveyWithResponses> surveyDataResponse = const [
    ParticipantSurveyWithResponses(
      surveyId: 1,
      title: 'Results',
      publicationStatus: 'published',
      questions: [],
    ),
  ];

  final ParticipantSurveyCompareResponse compareResponse = const
      ParticipantSurveyCompareResponse(
    surveyId: 1,
    participantAnswers: [
      ParticipantAnswerOut(questionId: 9, responseValue: 'Yes'),
    ],
    aggregates: {
      '9': {'yes': 7, 'no': 3},
    },
  );

  final ParticipantChartDataResponse chartDataResponse = const
      ParticipantChartDataResponse(
    surveyId: 1,
    title: 'Charts',
    totalRespondents: 10,
    questions: [],
  );

  @override
  Future<ParticipantSurveyQuestionsResponse> getSurveyQuestions(
    int surveyId, {
    String? lang,
  }) async {
    questionsSurveyId = surveyId;
    questionsLang = lang;
    return questionsResponse;
  }

  @override
  Future<List<ParticipantSurveyListItem>> getSurveys() async {
    return surveysResponse;
  }

  @override
  Future<List<ParticipantSurveyWithResponses>> getSurveyData({String? lang}) async {
    return surveyDataResponse;
  }

  @override
  Future<ParticipantSurveyCompareResponse> compareSurvey(int surveyId) async {
    compareSurveyId = surveyId;
    return compareResponse;
  }

  @override
  Future<ParticipantChartDataResponse> getChartData(
    int surveyId, {
    String? category,
    String? responseType,
    String? lang,
  }) async {
    chartSurveyId = surveyId;
    return chartDataResponse;
  }

  @override
  Future<ParticipantSurveyDraftResponse> getDraft(int surveyId) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveDraft(int surveyId, Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future<void> submitSurvey(int surveyId, Map<String, dynamic> body) {
    throw UnimplementedError();
  }
}

void main() {
  group('participant providers', () {
    test('participantApiProvider creates a ParticipantApi instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final api = container.read(participantApiProvider);

      expect(api, isA<ParticipantApi>());
    });

    test('participantSurveyQuestionsProvider forwards survey id and locale',
        () async {
      final fakeApi = _FakeParticipantApi();
      final container = ProviderContainer(
        overrides: [
          participantApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(participantSurveyQuestionsProvider(42).future);

      expect(fakeApi.questionsSurveyId, 42);
      expect(fakeApi.questionsLang, 'en');
      expect(result, fakeApi.questionsResponse);
    });

    test('participantSurveysProvider returns assigned surveys', () async {
      final fakeApi = _FakeParticipantApi();
      final container = ProviderContainer(
        overrides: [
          participantApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantSurveysProvider.future);

      expect(result, fakeApi.surveysResponse);
    });

    test('participantSurveyDataProvider returns completed survey data',
        () async {
      final fakeApi = _FakeParticipantApi();
      final container = ProviderContainer(
        overrides: [
          participantApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantSurveyDataProvider.future);

      expect(result, fakeApi.surveyDataResponse);
    });

    test('participantCompareProvider passes survey id and returns comparison',
        () async {
      final fakeApi = _FakeParticipantApi();
      final container = ProviderContainer(
        overrides: [
          participantApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantCompareProvider(7).future);

      expect(fakeApi.compareSurveyId, 7);
      expect(result, fakeApi.compareResponse);
    });

    test('participantChartDataProvider passes survey id and returns chart data',
        () async {
      final fakeApi = _FakeParticipantApi();
      final container = ProviderContainer(
        overrides: [
          participantApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantChartDataProvider(9).future);

      expect(fakeApi.chartSurveyId, 9);
      expect(result, fakeApi.chartDataResponse);
    });
  });
}
