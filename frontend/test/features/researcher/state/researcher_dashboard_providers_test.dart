import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/features/researcher/state/research_providers.dart';
import 'package:frontend/src/features/researcher/state/researcher_dashboard_providers.dart';

void main() {
  group('researcherDashboardSummaryProvider', () {
    test('builds dashboard summary with correct buckets and top surveys',
        () async {
      const surveys = [
        ResearchSurvey(
          surveyId: 1,
          title: 'Published Survey',
          publicationStatus: 'published',
          responseCount: 100,
          questionCount: 10,
        ),
        ResearchSurvey(
          surveyId: 2,
          title: 'Draft Survey',
          publicationStatus: 'draft',
          responseCount: 90,
          questionCount: 8,
        ),
        ResearchSurvey(
          surveyId: 3,
          title: 'In Progress Survey',
          publicationStatus: 'in-progress',
          responseCount: 80,
          questionCount: 6,
        ),
        ResearchSurvey(
          surveyId: 4,
          title: 'Not Started Survey',
          publicationStatus: 'not-started',
          responseCount: 70,
          questionCount: 5,
        ),
        ResearchSurvey(
          surveyId: 5,
          title: 'Closed Survey',
          publicationStatus: 'closed',
          responseCount: 60,
          questionCount: 7,
        ),
        ResearchSurvey(
          surveyId: 6,
          title: 'Complete Survey',
          publicationStatus: 'complete',
          responseCount: 50,
          questionCount: 4,
        ),
        ResearchSurvey(
          surveyId: 7,
          title: 'Cancelled Survey',
          publicationStatus: 'cancelled',
          responseCount: 40,
          questionCount: 3,
        ),
        ResearchSurvey(
          surveyId: 8,
          title: 'Unknown Survey',
          publicationStatus: 'archived',
          responseCount: 30,
          questionCount: 2,
        ),
      ];

      const overview = CrossSurveyOverview(
        surveyIds: [1, 2],
        surveys: [
          CrossSurveySummary(
            surveyId: 1,
            title: 'Published Survey',
            respondentCount: 120,
          ),
        ],
        totalRespondentCount: 321,
        totalQuestionCount: 45,
        avgCompletionRate: 87.5,
        suppressed: true,
        reason: 'insufficient_responses',
      );

      final container = ProviderContainer(
        overrides: [
          researchSurveysProvider.overrideWith((ref) => Future.value(surveys)),
          crossSurveyOverviewProvider.overrideWith(
            (ref) => Future.value(overview),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary =
          await container.read(researcherDashboardSummaryProvider.future);

      expect(summary.activeCount, 4);
      expect(summary.completedCount, 3);
      expect(summary.otherCount, 1);
      expect(summary.totalSurveys, 8);
      expect(summary.statusBuckets, {
        'Active': 4,
        'Completed': 3,
        'Other': 1,
      });

      expect(summary.totalRespondents, 321);
      expect(summary.avgCompletionRate, 87.5);
      expect(summary.suppressed, isTrue);
      expect(summary.reason, 'insufficient_responses');

      expect(summary.surveys, surveys);
      expect(summary.topSurveysByResponses.length, 6);
      expect(summary.topSurveysByResponses.map((s) => s.responseCount).toList(), [
        100,
        90,
        80,
        70,
        60,
        50,
      ]);
    });

    test('handles empty surveys list', () async {
      const overview = CrossSurveyOverview(
        surveyIds: [],
        surveys: [],
        totalRespondentCount: 0,
        totalQuestionCount: 0,
        avgCompletionRate: 0,
        suppressed: false,
      );

      final container = ProviderContainer(
        overrides: [
          researchSurveysProvider.overrideWith((ref) => Future.value(const [])),
          crossSurveyOverviewProvider.overrideWith(
            (ref) => Future.value(overview),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary =
          await container.read(researcherDashboardSummaryProvider.future);

      expect(summary.activeCount, 0);
      expect(summary.completedCount, 0);
      expect(summary.otherCount, 0);
      expect(summary.totalSurveys, 0);
      expect(summary.totalRespondents, 0);
      expect(summary.avgCompletionRate, 0);
      expect(summary.suppressed, isFalse);
      expect(summary.reason, isNull);
      expect(summary.surveys, isEmpty);
      expect(summary.topSurveysByResponses, isEmpty);
      expect(summary.statusBuckets, {
        'Active': 0,
        'Completed': 0,
        'Other': 0,
      });
    });
  });
}
