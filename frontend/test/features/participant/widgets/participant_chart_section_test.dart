import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/data_display/survey_chart_switcher.dart';
import 'package:frontend/src/core/widgets/feedback/app_info_banner.dart';
import 'package:frontend/src/features/participant/widgets/participant_chart_section.dart';

import '../../../test_helpers.dart';

void main() {
  group('ParticipantQuestionChart', () {
    testWidgets('hides open-ended responses', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Why?',
              responseType: 'openended',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ParticipantQuestionChart), findsOneWidget);
      expect(find.byType(SurveyChartSwitcher), findsNothing);
    });

    testWidgets('shows suppressed banner when aggregates are hidden',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Score',
              responseType: 'number',
              suppressed: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppInfoBanner), findsOneWidget);
    });

    testWidgets('shows no-data card when aggregate is missing', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Score',
              responseType: 'number',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
      expect(find.byType(SurveyChartSwitcher), findsNothing);
    });

    testWidgets('renders numeric stats and histogram', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Score',
              responseType: 'number',
              responseValue: '8',
              aggregate: {
                'mean': 7.5,
                'median': 8.0,
                'histogram': [
                  {'label': '0-5', 'count': 2},
                  {'label': '6-10', 'count': 6},
                ],
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppStatCard), findsNWidgets(3));
      expect(find.byType(SurveyChartSwitcher), findsOneWidget);
    });

    testWidgets('renders yes/no chart with answer row', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Do you agree?',
              responseType: 'yesno',
              responseValue: 'Yes',
              aggregate: {
                'yes_count': 4,
                'no_count': 1,
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SurveyChartSwitcher), findsOneWidget);
    });

    testWidgets('renders choice chart from aggregate options', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Pick one',
              responseType: 'single_choice',
              responseValue: 'Blue',
              aggregate: {
                'options': [
                  {'option': 'Blue', 'count': 3},
                  {'option': 'Green', 'count': 2},
                ],
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SurveyChartSwitcher), findsOneWidget);
    });

    testWidgets('returns no chart for unknown response type', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ParticipantQuestionChart(
            question: ChartQuestionData(
              questionId: 1,
              questionContent: 'Unknown',
              responseType: 'custom',
              aggregate: {
                'anything': true,
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SurveyChartSwitcher), findsNothing);
      expect(find.byType(AppInfoBanner), findsNothing);
    });
  });
}
