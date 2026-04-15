// Created with the Assistance of Claude Code
// frontend/test/features/participant/pages/participant_results_page_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/pages/participant_results_page.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../test_helpers.dart';

/// Mock survey data for testing.
final _mockSurveys = [
  ParticipantSurveyWithResponses(
    surveyId: 1,
    title: 'Health Assessment',
    publicationStatus: 'published',
    completedAt: DateTime(2026, 2, 1),
    questions: [
      const ParticipantQuestionResponse(
        questionId: 10,
        questionContent: 'How many hours of sleep?',
        responseType: 'number',
        isRequired: true,
        category: 'Sleep',
        responseValue: '7',
      ),
      const ParticipantQuestionResponse(
        questionId: 11,
        questionContent: 'Do you exercise?',
        responseType: 'yesno',
        isRequired: true,
        category: 'Exercise',
        responseValue: 'yes',
      ),
    ],
  ),
  const ParticipantSurveyWithResponses(
    surveyId: 2,
    title: 'Wellness Check',
    publicationStatus: 'published',
    questions: [
      ParticipantQuestionResponse(
        questionId: 20,
        questionContent: 'Rate your mood',
        responseType: 'scale',
        isRequired: false,
        responseValue: '4',
      ),
    ],
  ),
];

// Mock both messaging providers so no real HTTP calls are made during tests
final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

GoRouter _resultsRouter({
  int? highlightedSurveyId,
}) {
  return GoRouter(
    initialLocation: highlightedSurveyId != null
        ? '/participant/results?surveyId=$highlightedSurveyId'
        : '/participant/results',
    routes: [
      GoRoute(
        path: '/participant/results',
        builder: (_, __) => ParticipantResultsPage(
          highlightedSurveyId: highlightedSurveyId,
        ),
      ),
    ],
  );
}

void main() {
  group('ParticipantResultsPage', () {
    AppLocalizations l10nFromPage(WidgetTester tester) {
      final context = tester.element(find.byType(ParticipantResultsPage));
      return AppLocalizations.of(context);
    }

    Future<void> expandFirstSurvey(WidgetTester tester) async {
      await tester.tap(find.text('Health Assessment').first);
      await tester.pumpAndSettle();
    }

    Future<void> toggleChart(WidgetTester tester) async {
      final chartRow = find
          .ancestor(of: find.byIcon(Icons.list), matching: find.byType(Row))
          .first;
      final chartSwitch = find.descendant(
        of: chartRow,
        matching: find.byType(Switch),
      ).first;
      final widget = tester.widget<Switch>(chartSwitch);
      widget.onChanged?.call(true);
      await tester.pump();
    }

    Future<void> toggleCompare(WidgetTester tester) async {
      final compareRow = find
          .ancestor(of: find.byIcon(Icons.compare_arrows), matching: find.byType(Row))
          .first;
      final compareSwitch = find.descendant(
        of: compareRow,
        matching: find.byType(Switch),
      ).first;
      final widget = tester.widget<Switch>(compareSwitch);
      widget.onChanged?.call(true);
      await tester.pump();
    }

    testWidgets('shows loading indicator while data loads', (tester) async {
      // Use a Completer that never completes to keep loading state
      final completer = Completer<List<ParticipantSurveyWithResponses>>();
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) => completer.future,
          ),
        ],
      ));
      // Don't settle — loading state
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no surveys', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) async => <ParticipantSurveyWithResponses>[],
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Should show the "no results" message
      expect(find.textContaining('completed any surveys'), findsOneWidget);
    });

    testWidgets('shows survey list when data loaded', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) async => _mockSurveys,
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Both survey titles should appear
      expect(find.text('Health Assessment'), findsOneWidget);
      expect(find.text('Wellness Check'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) async => throw Exception('Network error'),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Error text and retry button
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Could not load your data'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('expand survey shows questions and answers', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) async => _mockSurveys,
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Tap the first survey to expand it
      await tester.tap(find.text('Health Assessment'));
      await tester.pumpAndSettle();

      // Question content and response value should appear
      expect(find.text('How many hours of sleep?'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Do you exercise?'), findsOneWidget);
      expect(find.text('yes'), findsOneWidget);
    });

    testWidgets('renders ParticipantScaffold with correct route',
        (tester) async {
      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith(
            (ref) async => <ParticipantSurveyWithResponses>[],
          ),
        ],
      ));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<ParticipantScaffold>(
        find.byType(ParticipantScaffold),
      );
      expect(scaffold.currentRoute, '/participant/results');
    });

    testWidgets('highlighted survey starts expanded and clears query when collapsed',
        (tester) async {
      final router = _resultsRouter(highlightedSurveyId: 1);

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            ..._messagingOverrides,
            participantSurveyDataProvider.overrideWith((ref) async => _mockSurveys),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Starts expanded via highlightedSurveyId.
      expect(find.text('How many hours of sleep?'), findsOneWidget);

      await tester.tap(find.text('Health Assessment').first);
      await tester.pumpAndSettle();

      expect(find.text('How many hours of sleep?'), findsNothing);
      expect(router.routeInformationProvider.value.uri.queryParameters, isEmpty);
    });

    testWidgets('chart toggle covers loading and data states',
        (tester) async {
      final chartCompleter = Completer<ParticipantChartDataResponse>();

      await tester.pumpWidget(
        buildTestPage(
          const ParticipantResultsPage(),
          overrides: [
            ..._messagingOverrides,
            participantSurveyDataProvider.overrideWith((ref) async => _mockSurveys),
            participantChartDataProvider(1).overrideWith((ref) => chartCompleter.future),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await expandFirstSurvey(tester);
      await toggleChart(tester);
      await tester.pump();

      expect(find.text('Loading charts...'), findsOneWidget);

      chartCompleter.complete(
        const ParticipantChartDataResponse(
          surveyId: 1,
          title: 'Health Assessment',
          totalRespondents: 10,
          questions: [
            ChartQuestionData(
              questionId: 10,
              questionContent: 'How many hours of sleep?',
              responseType: 'number',
              responseValue: '7',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Number'), findsOneWidget);
    });


    testWidgets('comparison view handles loading and no-data states',
        (tester) async {
      final compareCompleter = Completer<ParticipantSurveyCompareResponse>();

      await tester.pumpWidget(
        buildTestPage(
          const ParticipantResultsPage(),
          overrides: [
            ..._messagingOverrides,
            participantSurveyDataProvider.overrideWith((ref) async => _mockSurveys),
            participantCompareProvider(1).overrideWith((ref) => compareCompleter.future),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await expandFirstSurvey(tester);
      await toggleCompare(tester);
      await tester.pump();

      expect(find.text('Loading comparison...'), findsOneWidget);

      compareCompleter.complete(
        const ParticipantSurveyCompareResponse(
          surveyId: 1,
          participantAnswers: [],
          aggregates: {'aggregates': []},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No comparison data available.'), findsOneWidget);
    });

    testWidgets('surveys are sorted by completion date descending',
        (tester) async {
      const firstTitle = 'Newest Survey';
      const secondTitle = 'Older Survey';
      const thirdTitle = 'Undated Survey';

      final surveys = [
        ParticipantSurveyWithResponses(
          surveyId: 11,
          title: secondTitle,
          publicationStatus: 'published',
          completedAt: DateTime(2026, 1, 1),
          questions: const [],
        ),
        const ParticipantSurveyWithResponses(
          surveyId: 12,
          title: thirdTitle,
          publicationStatus: 'published',
          questions: [],
        ),
        ParticipantSurveyWithResponses(
          surveyId: 13,
          title: firstTitle,
          publicationStatus: 'published',
          completedAt: DateTime(2026, 3, 1),
          questions: const [],
        ),
      ];

      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith((ref) async => surveys),
        ],
      ));
      await tester.pumpAndSettle();

      final newestY = tester.getTopLeft(find.text(firstTitle)).dy;
      final olderY = tester.getTopLeft(find.text(secondTitle)).dy;
      final undatedY = tester.getTopLeft(find.text(thirdTitle)).dy;

      expect(newestY < olderY, isTrue);
      expect(olderY < undatedY, isTrue);
    });

    testWidgets('question rows show placeholder when answer is missing',
        (tester) async {
      final surveys = [
        const ParticipantSurveyWithResponses(
          surveyId: 99,
          title: 'Response Completeness Survey',
          publicationStatus: 'published',
          questions: [
            ParticipantQuestionResponse(
              questionId: 1,
              questionContent: 'Answered question',
              responseType: 'openended',
              isRequired: false,
              category: 'Category A',
              responseValue: 'present',
            ),
            ParticipantQuestionResponse(
              questionId: 2,
              questionContent: 'Missing question',
              responseType: 'openended',
              isRequired: false,
              category: '',
            ),
          ],
        ),
      ];

      await tester.pumpWidget(buildTestPage(
        const ParticipantResultsPage(),
        overrides: [
          ..._messagingOverrides,
          participantSurveyDataProvider.overrideWith((ref) async => surveys),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Response Completeness Survey'));
      await tester.pumpAndSettle();

      expect(find.text('Category A'), findsOneWidget);
      expect(find.text('Answered question'), findsOneWidget);
      expect(find.text('Missing question'), findsOneWidget);
      expect(find.text('present'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('chart view handles error retry then no-data state',
        (tester) async {
      var chartCalls = 0;

      await tester.pumpWidget(
        buildTestPage(
          const ParticipantResultsPage(),
          overrides: [
            ..._messagingOverrides,
            participantSurveyDataProvider.overrideWith((ref) async => _mockSurveys),
            participantChartDataProvider(1).overrideWith((ref) async {
              chartCalls += 1;
              if (chartCalls == 1) {
                throw Exception('chart load failed');
              }
              return const ParticipantChartDataResponse(
                surveyId: 1,
                title: 'Health Assessment',
                totalRespondents: 10,
                questions: [],
              );
            }),
            // Toggling charts auto-enables comparison; stub it out so it
            // doesn't show its own error Retry button during this test.
            participantCompareProvider(1).overrideWith(
              (ref) async => const ParticipantSurveyCompareResponse(
                surveyId: 1,
                aggregates: {},
                participantAnswers: [],
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await expandFirstSurvey(tester);
      await toggleChart(tester);
      await tester.pumpAndSettle();

      final l10n = l10nFromPage(tester);
      expect(find.text(l10n.participantChartError), findsOneWidget);
      expect(find.text(l10n.participantRetry), findsOneWidget);

      await tester.tap(find.text(l10n.participantRetry));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(chartCalls, 2);
      expect(find.text(l10n.participantChartNoData), findsOneWidget);
    });

    testWidgets('comparison view renders aggregate summaries across types',
        (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ParticipantResultsPage(),
          overrides: [
            ..._messagingOverrides,
            participantSurveyDataProvider.overrideWith((ref) async => _mockSurveys),
            participantCompareProvider(1).overrideWith(
              (ref) async => const ParticipantSurveyCompareResponse(
                surveyId: 1,
                participantAnswers: [
                  ParticipantAnswerOut(questionId: 101, responseValue: '4.5'),
                  ParticipantAnswerOut(questionId: 102, responseValue: 'yes'),
                  ParticipantAnswerOut(questionId: 103, responseValue: 'Blue'),
                ],
                aggregates: {
                  'aggregates': [
                    {
                      'question_id': 101,
                      'question_content': 'Numeric question',
                      'response_type': 'number',
                      'suppressed': false,
                      'data': {'mean': 4.5, 'median': 4.0}
                    },
                    {
                      'question_id': 102,
                      'question_content': 'Yes/no question',
                      'response_type': 'yesno',
                      'suppressed': false,
                      'data': {'yes_count': 3, 'no_count': 1}
                    },
                    {
                      'question_id': 103,
                      'question_content': 'Choice question',
                      'response_type': 'single_choice',
                      'suppressed': false,
                      'data': {
                        'options': [
                          {'option': 'Green', 'count': 2},
                          {'option': 'Blue', 'count': 5}
                        ]
                      }
                    },
                    {
                      'question_id': 104,
                      'question_content': 'Suppressed question',
                      'response_type': 'scale',
                      'suppressed': true,
                      'data': {'mean': 3.0}
                    },
                    {
                      'question_id': 105,
                      'question_content': 'No aggregate payload',
                      'response_type': 'openended',
                      'suppressed': false
                    }
                  ]
                },
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await expandFirstSurvey(tester);
      await toggleCompare(tester);
      await tester.pumpAndSettle();

      final l10n = l10nFromPage(tester);
      expect(find.textContaining('${l10n.participantChartMean}:'), findsOneWidget);
      expect(find.textContaining('${l10n.participantChartMedian}:'), findsOneWidget);
      expect(find.textContaining('${l10n.participantChartYes}: 75%'), findsOneWidget);
      expect(find.textContaining('${l10n.participantCompareMostCommon}: Blue'), findsOneWidget);
      expect(find.text(l10n.participantChartSuppressed), findsOneWidget);
      expect(find.text(l10n.participantCompareNoData), findsOneWidget);
    });

  });
}
