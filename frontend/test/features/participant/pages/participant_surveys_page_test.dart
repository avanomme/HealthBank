import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/pages/participant_surveys_page.dart';
import 'package:frontend/src/features/participant/pages/participant_survey_taking_page.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../test_helpers.dart';

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

class _FakeParticipantApi implements ParticipantApi {
  Map<String, dynamic>? lastDraftBody;
  Map<String, dynamic>? lastSubmitBody;
  int? lastDraftSurveyId;
  int? lastSubmitSurveyId;
  Object? submitError;
  int submitCalls = 0;
  Map<String, String> draftData = const {};

  @override
  Future<void> saveDraft(int surveyId, Map<String, dynamic> body) async {
    lastDraftSurveyId = surveyId;
    lastDraftBody = body;
  }

  @override
  Future<void> submitSurvey(int surveyId, Map<String, dynamic> body) async {
    submitCalls += 1;
    if (submitError != null) throw submitError!;
    lastSubmitSurveyId = surveyId;
    lastSubmitBody = body;
  }

  @override
  Future<List<ParticipantSurveyListItem>> getSurveys() async {
    throw UnimplementedError();
  }

  @override
  Future<ParticipantSurveyQuestionsResponse> getSurveyQuestions(
    int surveyId, {
    String? lang,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ParticipantSurveyWithResponses>> getSurveyData({String? lang}) async {
    throw UnimplementedError();
  }

  @override
  Future<ParticipantSurveyCompareResponse> compareSurvey(int surveyId) async {
    throw UnimplementedError();
  }

  @override
  Future<ParticipantChartDataResponse> getChartData(
    int surveyId, {
    String? category,
    String? responseType,
    String? lang,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ParticipantSurveyDraftResponse> getDraft(int surveyId) async {
    return ParticipantSurveyDraftResponse(draft: draftData);
  }
}

ParticipantSurveyListItem _survey({
  required int id,
  required String title,
  required String status,
  DateTime? dueDate,
  DateTime? completedAt,
  String publicationStatus = 'published',
}) {
  return ParticipantSurveyListItem(
    surveyId: id,
    title: title,
    assignmentStatus: status,
    publicationStatus: publicationStatus,
    dueDate: dueDate,
    completedAt: completedAt,
  );
}

ParticipantSurveyQuestion _question({
  required int id,
  required String prompt,
  required String responseType,
  bool required = true,
  List<ParticipantQuestionOption>? options,
  int? scaleMin,
  int? scaleMax,
}) {
  return ParticipantSurveyQuestion(
    questionId: id,
    questionContent: prompt,
    responseType: responseType,
    isRequired: required,
    options: options,
    scaleMin: scaleMin,
    scaleMax: scaleMax,
  );
}

ParticipantSurveyQuestionsResponse _surveyQuestions(
  List<ParticipantSurveyQuestion> questions,
) {
  return ParticipantSurveyQuestionsResponse(
    surveyId: 1,
    title: 'Mood Survey',
    questions: questions,
  );
}

DioException _submitDioError(int status, String detail) {
  final request = RequestOptions(path: '/participants/surveys/1/submit');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(
      requestOptions: request,
      statusCode: status,
      data: {'detail': detail},
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('ParticipantSurveysPage', () {
    late _FakeParticipantApi api;

    setUp(() {
      api = _FakeParticipantApi();
    });

    TestRouterApp buildListPage(
      List<Override> overrides, {
      String initialLocation = '/participant/surveys',
      Widget page = const ParticipantSurveysPage(),
    }) {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(path: '/participant/surveys', builder: (_, __) => page),
        ],
      );
      return TestRouterApp(router: router, overrides: overrides);
    }

    List<Override> listOverrides({
      Future<List<ParticipantSurveyListItem>> Function(Ref ref)? surveys,
    }) {
      return [
        ..._messagingOverrides,
        participantApiProvider.overrideWith((ref) => api),
        participantSurveysProvider.overrideWith(
          surveys ??
              (ref) async => [
                _survey(id: 1, title: 'Mood Survey', status: 'pending'),
              ],
        ),
      ];
    }

    testWidgets('shows loading indicator while surveys are unresolved', (
      tester,
    ) async {
      final completer = Completer<List<ParticipantSurveyListItem>>();

      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith((ref) => completer.future),
        ]),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no surveys are assigned', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith((ref) async => const []),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('No surveys assigned to you yet.'), findsOneWidget);
    });

    testWidgets('shows error state when surveys fail to load', (tester) async {
      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Could not load surveys. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('renders pending, completed and expired survey cards', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith(
            (ref) async => [
              _survey(
                id: 1,
                title: 'Pending Survey',
                status: 'pending',
                dueDate: DateTime(2026, 3, 20),
              ),
              _survey(
                id: 2,
                title: 'Completed Survey',
                status: 'completed',
                completedAt: DateTime(2026, 3, 10),
              ),
              _survey(id: 3, title: 'Expired Survey', status: 'expired'),
              _survey(id: 4, title: 'Unknown Survey', status: 'paused'),
            ],
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pending Survey'), findsOneWidget);
      expect(find.text('Completed Survey'), findsOneWidget);
      expect(find.text('Expired Survey'), findsOneWidget);
      expect(find.text('Unknown Survey'), findsOneWidget);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Completed'), findsWidgets);
      expect(find.text('Expired'), findsOneWidget);
      expect(find.text('paused'), findsOneWidget);
      expect(find.text('Start Survey'), findsOneWidget);
      expect(find.textContaining('Due: 2026-03-20'), findsOneWidget);
      expect(find.textContaining('· 2026-03-10'), findsOneWidget);
    });

    testWidgets('shows incomplete status and resume action when draft exists',
        (tester) async {
      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith(
            (ref) async => [
              _survey(id: 9, title: 'Draft Survey', status: 'pending')
                  .copyWith(hasDraft: true),
            ],
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Draft Survey'), findsOneWidget);
      expect(find.text('Incomplete'), findsOneWidget);
      expect(find.text('Resume Survey'), findsOneWidget);
    });

    testWidgets('start survey button navigates to survey taking route',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/participant/surveys',
        routes: [
          GoRoute(
            path: '/participant/surveys',
            builder: (_, __) => const ParticipantSurveysPage(),
          ),
          GoRoute(
            path: '/participant/surveys/:surveyId',
            builder: (_, state) => Scaffold(
              body: Text('Survey Route ${state.pathParameters['surveyId']}'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            ...listOverrides(
              surveys: (ref) async => [
                _survey(id: 17, title: 'Navigable Survey', status: 'pending'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Survey'));
      await tester.pumpAndSettle();

      expect(find.text('Survey Route 17'), findsOneWidget);
    });

    testWidgets('reflows survey cards at narrow width with large text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildListPage(
          [
            ...listOverrides(),
            participantSurveysProvider.overrideWith(
              (ref) async => [
                _survey(
                  id: 1,
                  title: 'Pending survey with a longer title for reflow checks',
                  status: 'pending',
                  dueDate: DateTime(2026, 3, 20),
                ),
                _survey(
                  id: 2,
                  title:
                      'Completed survey with a longer title for reflow checks',
                  status: 'completed',
                  completedAt: DateTime(2026, 3, 10),
                ),
              ],
            ),
          ],
          page: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: ParticipantSurveysPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start Survey'), findsOneWidget);
      expect(find.text('Completed'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('retry button invalidates failed survey list provider', (
      tester,
    ) async {
      var loadCount = 0;

      await tester.pumpWidget(
        buildListPage(
          listOverrides(
            surveys: (ref) async {
              loadCount += 1;
              if (loadCount == 1) throw Exception('boom');
              return [
                _survey(id: 1, title: 'Recovered Survey', status: 'pending'),
              ];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(loadCount, 2);
      expect(find.text('Recovered Survey'), findsOneWidget);
    });

    testWidgets('query string only auto opens pending surveys', (tester) async {
      await tester.pumpWidget(
        buildListPage([
          ...listOverrides(),
          participantSurveysProvider.overrideWith(
            (ref) async => [
              _survey(id: 1, title: 'Completed Survey', status: 'completed'),
            ],
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Completed Survey'), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
      expect(find.text('Start Survey'), findsNothing);
    });
  });

  group('ParticipantSurveyTakingPage', () {
    late _FakeParticipantApi api;

    setUp(() {
      api = _FakeParticipantApi();
    });

    void setTallViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    TestRouterApp buildTakingPage(
      List<Override> overrides, {
      int surveyId = 1,
    }) {
      final router = GoRouter(
        initialLocation: '/participant/surveys/$surveyId',
        routes: [
          GoRoute(
            path: '/participant/surveys',
            builder: (_, __) => const ParticipantSurveysPage(),
          ),
          GoRoute(
            path: '/participant/surveys/:surveyId',
            builder: (_, state) {
              final id = int.parse(state.pathParameters['surveyId']!);
              return ParticipantSurveyTakingPage(
                key: UniqueKey(),
                surveyId: id,
              );
            },
          ),
        ],
      );
      return TestRouterApp(
        key: UniqueKey(),
        router: router,
        overrides: overrides,
      );
    }

    List<Override> takingOverrides({
      Future<ParticipantSurveyQuestionsResponse> Function(Ref ref)? questions,
      Future<List<ParticipantSurveyListItem>> Function(Ref ref)? surveys,
    }) {
      return [
        ..._messagingOverrides,
        participantApiProvider.overrideWith((ref) => api),
        participantSurveysProvider.overrideWith(
          surveys ??
              (ref) async => [
                _survey(id: 1, title: 'Mood Survey', status: 'pending'),
              ],
        ),
        if (questions != null)
          participantSurveyQuestionsProvider(1).overrideWith(questions),
      ];
    }

    testWidgets('shows loading state while questions load', (tester) async {
      setTallViewport(tester);
      final completer = Completer<ParticipantSurveyQuestionsResponse>();

      await tester.pumpWidget(
        buildTakingPage(takingOverrides(questions: (ref) => completer.future)),
      );
      await tester.pump();
      // Allow draft load future to complete
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Loading questions...'), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsWidgets);

      completer.complete(
        _surveyQuestions([
          _question(id: 1, prompt: 'Done', responseType: 'openended'),
        ]),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty questions message', (tester) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(questions: (ref) async => _surveyQuestions(const [])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No surveys assigned to you yet.'), findsOneWidget);
    });

    testWidgets('error state retries question provider', (tester) async {
      setTallViewport(tester);
      var loadCount = 0;

      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(
            questions: (ref) async {
              loadCount += 1;
              if (loadCount == 1) throw Exception('offline');
              return _surveyQuestions([
                _question(
                  id: 1,
                  prompt: 'Recovered?',
                  responseType: 'openended',
                ),
              ]);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Network error. Please check your connection and retry.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(loadCount, 2);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('validation errors clear as required answers are filled', (
      tester,
    ) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(
            questions: (ref) async => _surveyQuestions([
              _question(
                id: 1,
                prompt: 'Required text',
                responseType: 'openended',
              ),
              _question(
                id: 2,
                prompt: 'Required yes/no',
                responseType: 'yesno',
              ),
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please answer all required questions before submitting.'),
        findsOneWidget,
      );
      expect(find.text('This question is required.'), findsNWidgets(2));

      await tester.enterText(find.byType(TextField).first, 'filled');
      await tester.pumpAndSettle();
      expect(find.text('This question is required.'), findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('This question is required.'), findsNothing);
    });

    testWidgets('submits survey successfully across all input types', (
      tester,
    ) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(
            questions: (ref) async => _surveyQuestions([
              _question(id: 1, prompt: 'Free text', responseType: 'openended'),
              _question(id: 2, prompt: 'Number', responseType: 'number'),
              _question(
                id: 3,
                prompt: 'Scale',
                responseType: 'scale',
                scaleMin: 1,
                scaleMax: 5,
              ),
              _question(
                id: 4,
                prompt: 'Single choice',
                responseType: 'single_choice',
                options: const [
                  ParticipantQuestionOption(optionId: 10, optionText: 'Alpha'),
                  ParticipantQuestionOption(optionId: 11, optionText: 'Beta'),
                ],
              ),
              _question(
                id: 5,
                prompt: 'Multi choice',
                responseType: 'multi_choice',
                options: const [
                  ParticipantQuestionOption(optionId: 20, optionText: 'One'),
                  ParticipantQuestionOption(optionId: 21, optionText: 'Two'),
                ],
              ),
              _question(id: 6, prompt: 'Yes or no', responseType: 'yesno'),
              _question(id: 7, prompt: 'Fallback', responseType: 'unexpected'),
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'notes');
      await tester.enterText(find.byType(TextField).at(1), '42');
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Beta'));
      await tester.tap(find.text('Beta'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('One'));
      await tester.tap(find.text('One'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Two'));
      await tester.tap(find.text('Two'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(3));
      await tester.enterText(find.byType(TextField).at(2), 'fallback text');
      await tester.pumpAndSettle();

      // Tap submit — triggers confirm dialog
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Confirm the dialog
      // The dialog shows a "Submit" confirm button — find it within the dialog
      final dialogSubmit = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Submit'),
      );
      expect(dialogSubmit, findsOneWidget);
      await tester.tap(dialogSubmit);
      await tester.pumpAndSettle();

      expect(api.submitCalls, 1);
      expect(api.lastSubmitSurveyId, 1);

      final responses =
          (api.lastSubmitBody?['question_responses'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      expect(
        responses,
        containsAll([
          {'question_id': 1, 'response_value': 'notes'},
          {'question_id': 2, 'response_value': '42'},
          {'question_id': 4, 'response_value': '11'},
          {
            'question_id': 5,
            'response_value': jsonEncode(['20', '21']),
          },
          {'question_id': 6, 'response_value': 'yes'},
          {'question_id': 7, 'response_value': 'fallback text'},
        ]),
      );
      // After submit, navigates back to surveys list
      expect(find.text('Survey submitted successfully!'), findsOneWidget);
    });

    testWidgets('back navigation saves draft responses', (tester) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(
            questions: (ref) async => _surveyQuestions([
              _question(id: 1, prompt: 'Draft text', responseType: 'openended'),
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'draft answer');
      await tester.pumpAndSettle();

      // Tap back arrow to save draft and navigate away
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(api.lastDraftSurveyId, 1);
      expect(api.lastDraftBody?['question_responses'], [
        {'question_id': 1, 'response_value': 'draft answer'},
      ]);
    });

    testWidgets(
      'loads draft responses and supports legacy multi-choice parsing',
      (tester) async {
        setTallViewport(tester);
        api.draftData = {
          '1': 'prefilled text',
          '2': '4',
          '3': 'no',
          '4': '10, 11',
        };

        await tester.pumpWidget(
          buildTakingPage(
            takingOverrides(
              questions: (ref) async => _surveyQuestions([
                _question(id: 1, prompt: 'Text', responseType: 'openended'),
                _question(
                  id: 2,
                  prompt: 'Scale',
                  responseType: 'scale',
                  scaleMin: 1,
                  scaleMax: 5,
                ),
                _question(id: 3, prompt: 'YN', responseType: 'yesno'),
                _question(
                  id: 4,
                  prompt: 'Legacy multi',
                  responseType: 'multi_choice',
                  options: const [
                    ParticipantQuestionOption(optionId: 10, optionText: 'One'),
                    ParticipantQuestionOption(optionId: 11, optionText: 'Two'),
                  ],
                ),
              ]),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('prefilled text'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('No'), findsOneWidget);

        final selectedContainers = tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(GestureDetector),
                matching: find.byType(Container),
              ),
            )
            .where((container) {
              final decoration = container.decoration;
              return decoration is BoxDecoration && decoration.color != null;
            })
            .length;
        expect(selectedContainers, greaterThanOrEqualTo(2));

        // Deselect One so only Two remains
        await tester.ensureVisible(find.text('One'));
        await tester.tap(find.text('One'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Submit with confirm dialog
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        final dialogSubmit = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Submit'),
        );
        expect(dialogSubmit, findsOneWidget);
        await tester.tap(dialogSubmit);
        await tester.pumpAndSettle();

        final responses =
            (api.lastSubmitBody?['question_responses'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        expect(
          responses.any(
            (entry) =>
                entry['question_id'] == 4 &&
                entry['response_value'] == jsonEncode(['11']),
          ),
          isTrue,
        );
      },
    );

    testWidgets(
      'renders inline error styling for scale input and deselects multi-choice options',
      (tester) async {
        setTallViewport(tester);
        await tester.pumpWidget(
          buildTakingPage(
            takingOverrides(
              questions: (ref) async => _surveyQuestions([
                _question(
                  id: 1,
                  prompt: 'Scale required',
                  responseType: 'scale',
                  scaleMin: 1,
                  scaleMax: 3,
                ),
                _question(
                  id: 2,
                  prompt: 'Multi choice',
                  responseType: 'multi_choice',
                  options: const [
                    ParticipantQuestionOption(optionId: 20, optionText: 'One'),
                    ParticipantQuestionOption(optionId: 21, optionText: 'Two'),
                  ],
                ),
              ]),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Two'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Two'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        expect(
          find.text('This question is required.'),
          findsAtLeastNWidgets(1),
        );
        expect(find.text('1'), findsWidgets);
        expect(find.text('3'), findsWidgets);
      },
    );

    testWidgets('yes no input supports selecting no', (tester) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        buildTakingPage(
          takingOverrides(
            questions: (ref) async => _surveyQuestions([
              _question(id: 1, prompt: 'Yes or no', responseType: 'yesno'),
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Submit with confirm dialog
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      final dialogSubmit = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Submit'),
      );
      expect(dialogSubmit, findsOneWidget);
      await tester.tap(dialogSubmit);
      await tester.pumpAndSettle();

      final responses =
          (api.lastSubmitBody?['question_responses'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      expect(
        responses.any(
          (entry) =>
              entry['question_id'] == 1 && entry['response_value'] == 'no',
        ),
        isTrue,
      );
    });

    testWidgets('submit maps backend errors to user-facing messages', (
      tester,
    ) async {
      setTallViewport(tester);
      final scenarios = <Object, String>{
        _submitDioError(400, 'already submitted'):
            'You have already completed this survey.',
        _submitDioError(400, 'expired'):
            'This survey has expired and can no longer be submitted.',
        _submitDioError(400, 'not published'):
            'This survey is no longer accepting responses.',
        _submitDioError(403, 'forbidden'):
            'You are not assigned to this survey.',
        _submitDioError(404, 'missing'): 'Survey not found.',
        _submitDioError(500, 'server'):
            'A server error occurred. Please try again later.',
        _submitDioError(418, 'teapot'):
            'Failed to submit survey. Please try again.',
        Exception('offline'):
            'Network error. Please check your connection and retry.',
      };

      for (final entry in scenarios.entries) {
        api = _FakeParticipantApi();
        api.submitError = entry.key;

        await tester.pumpWidget(
          buildTakingPage(
            takingOverrides(
              questions: (ref) async => _surveyQuestions([
                _question(
                  id: 1,
                  prompt: 'Only question',
                  responseType: 'openended',
                ),
              ]),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'answer');
        await tester.pumpAndSettle();

        // Tap submit — triggers confirm dialog
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Confirm the dialog
        final dialogSubmit = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Submit'),
        );
        expect(dialogSubmit, findsOneWidget);
        await tester.tap(dialogSubmit);
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text(entry.value), findsOneWidget);
      }
    });
  });
}
