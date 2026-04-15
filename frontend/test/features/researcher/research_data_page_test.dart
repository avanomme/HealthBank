// Created with the Assistance of Claude Code
// frontend/test/features/researcher/research_data_page_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/features/researcher/pages/researcher_pull_data_page.dart';
import 'package:frontend/src/features/researcher/state/research_providers.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';

import '../../test_helpers.dart';

/// Override to prevent real API calls from messaging providers in tests.
final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

// Test data
const _mockSurveys = [
  ResearchSurvey(
    surveyId: 1,
    title: 'Health Survey 2026',
    publicationStatus: 'published',
    responseCount: 50,
    questionCount: 10,
  ),
  ResearchSurvey(
    surveyId: 2,
    title: 'Wellness Check',
    publicationStatus: 'published',
    responseCount: 25,
    questionCount: 5,
  ),
];

const _mockOverview = SurveyOverview(
  surveyId: 1,
  title: 'Health Survey 2026',
  respondentCount: 42,
  completionRate: 85.0,
  questionCount: 10,
  suppressed: false,
);

const _mockSuppressedOverview = SurveyOverview(
  surveyId: 99,
  title: 'Low Response Survey',
  respondentCount: 3,
  completionRate: 0.0,
  questionCount: 5,
  suppressed: true,
);

const _mockIndividualResponses = IndividualResponseData(
  surveyId: 1,
  title: 'Health Survey 2026',
  respondentCount: 6,
  suppressed: false,
  questions: [
    ResponseQuestion(
      questionId: 1,
      questionContent: 'How old are you?',
      responseType: 'number',
      category: 'demographics',
    ),
    ResponseQuestion(
      questionId: 2,
      questionContent: 'Do you exercise regularly?',
      responseType: 'yesno',
      category: 'health',
    ),
  ],
  rows: [
    ResponseRow(anonymousId: 'R-abc12345', responses: {'1': '25', '2': 'Yes'}),
    ResponseRow(anonymousId: 'R-def67890', responses: {'1': '30', '2': 'No'}),
    ResponseRow(anonymousId: 'R-ghi11111', responses: {'1': '45', '2': 'Yes'}),
    ResponseRow(anonymousId: 'R-jkl22222', responses: {'1': '22', '2': 'No'}),
    ResponseRow(anonymousId: 'R-mno33333', responses: {'1': '35', '2': 'Yes'}),
    ResponseRow(anonymousId: 'R-pqr44444', responses: {'1': '28', '2': 'No'}),
  ],
);

const _mockSuppressedResponses = IndividualResponseData(
  surveyId: 1,
  title: 'Low Response Survey',
  respondentCount: 3,
  suppressed: true,
  reason: 'insufficient_responses',
  questions: [],
  rows: [],
);

const _mockEmptyResponses = IndividualResponseData(
  surveyId: 1,
  title: 'Health Survey 2026',
  respondentCount: 0,
  suppressed: false,
  questions: [],
  rows: [],
);

const _mockAggregates = AggregateResponse(
  surveyId: 1,
  title: 'Health Survey 2026',
  totalRespondents: 6,
  aggregates: [
    QuestionAggregate(
      questionId: 1,
      questionContent: 'How old are you?',
      responseType: 'number',
      category: 'demographics',
      responseCount: 6,
      suppressed: false,
      data: {
        'min': 22.0,
        'max': 45.0,
        'mean': 30.83,
        'median': 29.0,
        'std_dev': 8.01,
        'histogram': [
          {'label': '22.0-29.5', 'count': 3},
          {'label': '29.5-37.0', 'count': 2},
          {'label': '37.0-45.0', 'count': 1},
        ],
      },
    ),
    QuestionAggregate(
      questionId: 2,
      questionContent: 'Do you exercise regularly?',
      responseType: 'yesno',
      category: 'health',
      responseCount: 6,
      suppressed: false,
      data: {
        'yes_count': 3,
        'no_count': 3,
        'yes_pct': 50.0,
        'no_pct': 50.0,
      },
    ),
  ],
);

const _mockOpenEndedAggregates = AggregateResponse(
  surveyId: 1,
  title: 'Health Survey 2026',
  totalRespondents: 6,
  aggregates: [
    QuestionAggregate(
      questionId: 3,
      questionContent: 'Describe your current stressors',
      responseType: 'openended',
      category: 'mental_health',
      responseCount: 6,
      suppressed: false,
      data: {},
    ),
  ],
);

const _mockCrossOverview = CrossSurveyOverview(
  surveyIds: [1, 2],
  surveys: [
    CrossSurveySummary(
      surveyId: 1,
      title: 'Health Survey 2026',
      respondentCount: 6,
    ),
    CrossSurveySummary(
      surveyId: 2,
      title: 'Wellness Check',
      respondentCount: 4,
    ),
  ],
  totalRespondentCount: 10,
  totalQuestionCount: 3,
  avgCompletionRate: 82.5,
  suppressed: false,
);

const _mockCrossSuppressedOverview = CrossSurveyOverview(
  surveyIds: [1, 2],
  surveys: [
    CrossSurveySummary(
      surveyId: 1,
      title: 'Health Survey 2026',
      respondentCount: 3,
    ),
  ],
  totalRespondentCount: 3,
  totalQuestionCount: 1,
  avgCompletionRate: 0,
  suppressed: true,
  reason: 'insufficient_responses',
);

const _mockCrossQuestions = [
  CrossSurveyQuestion(
    questionId: 10,
    questionContent: 'How old are you?',
    responseType: 'number',
    category: 'demographics',
    surveyId: 1,
    surveyTitle: 'Health Survey 2026',
    surveyStartDate: '2026-01-01',
  ),
  CrossSurveyQuestion(
    questionId: 20,
    questionContent: 'Rate your mood',
    responseType: 'scale',
    category: 'mental_health',
    surveyId: 2,
    surveyTitle: 'Wellness Check',
    surveyStartDate: '2026-01-08',
  ),
];

const _mockCrossResponses = CrossSurveyResponseData(
  surveyIds: [1, 2],
  surveys: [
    CrossSurveySummary(
      surveyId: 1,
      title: 'Health Survey 2026',
      respondentCount: 6,
    ),
    CrossSurveySummary(
      surveyId: 2,
      title: 'Wellness Check',
      respondentCount: 4,
    ),
  ],
  totalRespondentCount: 10,
  suppressed: false,
  suppressedSurveys: [2],
  questions: _mockCrossQuestions,
  rows: [
    CrossSurveyRow(
      anonymousId: 'R-cross-1',
      responses: {
        '10': '34',
        '20': '4',
      },
    ),
  ],
);

const _mockCrossAggregates = CrossSurveyAggregateResponse(
  surveyIds: [1, 2],
  totalRespondents: 10,
  aggregates: [
    QuestionAggregate(
      questionId: 20,
      questionContent: 'Rate your mood',
      responseType: 'scale',
      category: 'mental_health',
      responseCount: 10,
      suppressed: false,
      data: {
        'min': 1.0,
        'max': 5.0,
        'mean': 3.6,
        'median': 4.0,
      },
    ),
  ],
);

/// Build page with overrides for survey 1 pre-loaded
Widget _buildPageWithSurvey({int? initialSurveyId}) {
  return buildTestPage(
    ResearcherPullDataPage(initialSurveyId: initialSurveyId),
    overrides: [
      ..._messagingOverrides,
      researchSurveysProvider.overrideWith(
        (ref) => Future.value(_mockSurveys),
      ),
      surveyOverviewProvider(1).overrideWith(
        (ref) => Future.value(_mockOverview),
      ),
      individualResponsesProvider(1).overrideWith(
        (ref) => Future.value(_mockIndividualResponses),
      ),
      surveyAggregatesProvider(1).overrideWith(
        (ref) => Future.value(_mockAggregates),
      ),
    ],
  );
}

/// Set a desktop-size test surface so the page layout doesn't overflow.
void _setDesktopSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1920, 1080);
  tester.view.devicePixelRatio = 1.0;
}

/// Reset the test surface back to defaults.
void _resetDesktopSize(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

void main() {
  group('ResearcherPullDataPage', () {
    testWidgets('renders without errors', (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future.value(_mockSurveys),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ResearcherPullDataPage), findsOneWidget);
    });

    testWidgets('shows page title', (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future.value(_mockSurveys),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Research Data'), findsOneWidget);
    });

    testWidgets('shows select survey prompt when no survey selected',
        (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future.value(_mockSurveys),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Select a survey'), findsAtLeast(1));
    });

    testWidgets('survey dropdown populates with mock survey list',
        (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future.value(_mockSurveys),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Open the dropdown
      await tester.tap(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();

      // Should see survey titles in the dropdown menu
      expect(find.text('Health Survey 2026'), findsAtLeast(1));
      expect(find.text('Wellness Check'), findsAtLeast(1));
    });

    testWidgets('loading indicator shows while fetching surveys',
        (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      // Use a Completer that never completes — no pending timer warnings
      final completer = Completer<List<ResearchSurvey>>();
      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => completer.future,
          ),
        ],
      ));
      // Pump a single frame — provider is still loading
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no surveys message on error', (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future<List<ResearchSurvey>>.error(Exception('fail')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('No surveys available'), findsOneWidget);
    });

    group('with survey selected', () {
      Future<void> selectSurvey(WidgetTester tester) async {
        _setDesktopSize(tester);

        await tester.pumpWidget(_buildPageWithSurvey(initialSurveyId: 1));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();
      }

      testWidgets('selecting a survey shows stat cards', (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.byType(AppStatCard), findsNWidgets(3));
      });

      testWidgets(
          'stat cards display respondent count, completion rate, questions',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.text('42'), findsAtLeast(1));
        expect(find.text('85.0%'), findsOneWidget);
        expect(find.text('10'), findsAtLeast(1));
        expect(find.text('Respondents'), findsOneWidget);
        expect(find.text('Completion Rate'), findsOneWidget);
        expect(find.text('Questions'), findsOneWidget);
      });

      testWidgets('shows DataTable with individual response rows',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.byType(DataTable), findsOneWidget);
      });

      testWidgets('DataTable shows anonymous IDs', (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.text('R-abc12345'), findsOneWidget);
        expect(find.text('R-def67890'), findsOneWidget);
      });

      testWidgets('DataTable shows question content as column headers',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.text('How old are you?'), findsOneWidget);
        expect(find.text('Do you exercise regularly?'), findsOneWidget);
      });

      testWidgets('DataTable shows response values in cells',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Check some response values
        expect(find.text('25'), findsAtLeast(1));
        expect(find.text('Yes'), findsAtLeast(1));
        expect(find.text('30'), findsAtLeast(1));
        expect(find.text('No'), findsAtLeast(1));
      });

      testWidgets('DataTable has correct number of rows', (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        final dataTable =
            tester.widget<DataTable>(find.byType(DataTable));
        expect(dataTable.rows.length, 6);
      });

      testWidgets('export CSV button is present', (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.text('Export CSV'), findsOneWidget);
      });
    });

    group('tab navigation', () {
      Future<void> selectSurvey(WidgetTester tester) async {
        _setDesktopSize(tester);

        await tester.pumpWidget(_buildPageWithSurvey(initialSurveyId: 1));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();
      }

      testWidgets('TabBar renders with both tab labels', (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        expect(find.text('Data Table'), findsOneWidget);
        expect(find.text('Analysis'), findsOneWidget);
      });

      testWidgets('Data Table tab shows DataTable by default',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Data Table tab is active by default
        expect(find.byType(DataTable), findsOneWidget);
      });

      testWidgets('switching to Analysis tab shows bar chart (histogram)',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Tap the Analysis tab
        await tester.tap(find.text('Analysis'));
        await tester.pumpAndSettle();

        expect(find.byType(AppBarChart), findsOneWidget);
      });

      testWidgets('Analysis tab shows pie chart (yesno)',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Tap the Analysis tab
        await tester.tap(find.text('Analysis'));
        await tester.pumpAndSettle();

        expect(find.byType(AppPieChart), findsOneWidget);
      });

      testWidgets('overview stat cards visible on both tabs',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Stat cards visible on Data Table tab
        expect(find.byType(AppStatCard), findsNWidgets(3));

        // Switch to Analysis tab
        await tester.tap(find.text('Analysis'));
        await tester.pumpAndSettle();

        // Overview stat cards still visible (3 overview + analysis stat cards)
        // The analysis tab adds mean, median, std_dev stat cards = 3 more
        expect(find.byType(AppStatCard), findsAtLeast(3));
      });

      testWidgets('CSV export button visible on both tabs',
          (tester) async {
        addTearDown(() => _resetDesktopSize(tester));
        await selectSurvey(tester);

        // Visible on Data Table tab
        expect(find.text('Export CSV'), findsOneWidget);

        // Switch to Analysis tab
        await tester.tap(find.text('Analysis'));
        await tester.pumpAndSettle();

        // Still visible
        expect(find.text('Export CSV'), findsOneWidget);
      });
    });

    group('suppressed data', () {
      testWidgets('shows warning when survey has insufficient respondents',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(initialSurveyId: 1),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
            surveyOverviewProvider(1).overrideWith(
              (ref) => Future.value(_mockSuppressedOverview),
            ),
            individualResponsesProvider(1).overrideWith(
              (ref) => Future.value(_mockSuppressedResponses),
            ),
            surveyAggregatesProvider(1).overrideWith(
              (ref) => Future.value(_mockAggregates),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        // Survey pre-selected via initialSurveyId

        expect(find.byIcon(Icons.warning_amber_rounded), findsAtLeast(1));
        expect(find.byType(DataTable), findsNothing);
      });

      testWidgets('shows no data message when empty responses',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(initialSurveyId: 1),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
            surveyOverviewProvider(1).overrideWith(
              (ref) => Future.value(_mockOverview),
            ),
            individualResponsesProvider(1).overrideWith(
              (ref) => Future.value(_mockEmptyResponses),
            ),
            surveyAggregatesProvider(1).overrideWith(
              (ref) => Future.value(_mockAggregates),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        // Survey pre-selected via initialSurveyId

        expect(find.byType(DataTable), findsNothing);
      });
    });

    group('data bank mode', () {
      testWidgets('shows empty-state prompt when no fields are selected',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Data Bank'));
        await tester.pumpAndSettle();

        expect(
          find.text('Use + Add Fields to select data, or filter by survey to browse'),
          findsOneWidget,
        );
      });

      testWidgets('opens field picker dialog from Add Fields button',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
            availableQuestionsProvider.overrideWith(
              (ref) => Future.value(_mockCrossQuestions),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Data Bank'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add Fields'));
        await tester.pumpAndSettle();

        expect(find.text('Available Data Fields'), findsOneWidget);
        expect(find.text('How old are you?'), findsOneWidget);
        expect(find.text('Rate your mood'), findsOneWidget);
      });

      testWidgets('renders cross-survey table and exclusion banner',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
            crossSurveyFiltersProvider.overrideWith(
              (ref) => CrossSurveyFiltersNotifier()..setQuestions([10]),
            ),
            crossSurveyOverviewProvider.overrideWith(
              (ref) => Future.value(_mockCrossOverview),
            ),
            availableQuestionsProvider.overrideWith(
              (ref) => Future.value(_mockCrossQuestions),
            ),
            crossSurveyResponsesProvider.overrideWith(
              (ref) => Future.value(_mockCrossResponses),
            ),
            crossSurveyAggregatesProvider.overrideWith(
              (ref) => Future.value(_mockCrossAggregates),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Data Bank'));
        await tester.pumpAndSettle();

        expect(find.byType(DataTable), findsOneWidget);
        expect(find.text('R-cross-1'), findsOneWidget);
        expect(
          find.textContaining('excluded (fewer than 5 respondents)'),
          findsOneWidget,
        );
      });

      testWidgets('shows suppressed warning for cross-survey overview',
          (tester) async {
        _setDesktopSize(tester);
        addTearDown(() => _resetDesktopSize(tester));

        await tester.pumpWidget(buildTestPage(
          const ResearcherPullDataPage(),
          overrides: [
            ..._messagingOverrides,
            researchSurveysProvider.overrideWith(
              (ref) => Future.value(_mockSurveys),
            ),
            crossSurveyFiltersProvider.overrideWith(
              (ref) => CrossSurveyFiltersNotifier()..setQuestions([10]),
            ),
            crossSurveyOverviewProvider.overrideWith(
              (ref) => Future.value(_mockCrossSuppressedOverview),
            ),
            availableQuestionsProvider.overrideWith(
              (ref) => Future.value(_mockCrossQuestions),
            ),
            crossSurveyResponsesProvider.overrideWith(
              (ref) => Future.value(_mockCrossResponses),
            ),
            crossSurveyAggregatesProvider.overrideWith(
              (ref) => Future.value(_mockCrossAggregates),
            ),
          ],
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Data Bank'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.warning_amber_rounded), findsAtLeast(1));
      });
    });

    testWidgets('analysis tab shows open-ended privacy note',
        (tester) async {
      _setDesktopSize(tester);
      addTearDown(() => _resetDesktopSize(tester));

      await tester.pumpWidget(buildTestPage(
        const ResearcherPullDataPage(initialSurveyId: 1),
        overrides: [
          ..._messagingOverrides,
          researchSurveysProvider.overrideWith(
            (ref) => Future.value(_mockSurveys),
          ),
          surveyOverviewProvider(1).overrideWith(
            (ref) => Future.value(_mockOverview),
          ),
          individualResponsesProvider(1).overrideWith(
            (ref) => Future.value(_mockIndividualResponses),
          ),
          surveyAggregatesProvider(1).overrideWith(
            (ref) => Future.value(_mockOpenEndedAggregates),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Analysis'));
      await tester.pumpAndSettle();

      expect(
        find.text('Open-ended responses are not displayed for privacy'),
        findsOneWidget,
      );
    });
  });
}
