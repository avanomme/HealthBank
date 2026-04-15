import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/researcher/researcher.dart';
import 'package:frontend/src/features/researcher/state/researcher_dashboard_providers.dart';

import '../../test_helpers.dart';

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

DashboardSummary _summary({
  bool suppressed = false,
  String? reason,
  String firstTitle = 'Health Survey 2026',
  String secondTitle = 'Wellness Check',
}) {
  final surveys = [
    ResearchSurvey(
      surveyId: 1,
      title: firstTitle,
      publicationStatus: 'published',
      responseCount: 50,
      questionCount: 10,
    ),
    ResearchSurvey(
      surveyId: 2,
      title: secondTitle,
      publicationStatus: 'closed',
      responseCount: 20,
      questionCount: 8,
    ),
  ];

  return DashboardSummary(
    activeCount: 1,
    completedCount: 1,
    otherCount: 0,
    totalSurveys: surveys.length,
    totalRespondents: 70,
    avgCompletionRate: 84.2,
    suppressed: suppressed,
    reason: reason,
    surveys: surveys,
    topSurveysByResponses: surveys,
    statusBuckets: const {
      'Active': 1,
      'Completed': 1,
      'Other': 0,
    }, minResponses: 5,
  );
}

void _setSurfaceSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

void main() {
  group('ResearcherDashboardPage', () {
    testWidgets('renders summary content from provider', (tester) async {
      _setSurfaceSize(tester, const Size(1440, 1800));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestPage(
          const ResearcherDashboardPage(),
          overrides: [
            ..._messagingOverrides,
            researcherDashboardSummaryProvider.overrideWith(
              (ref) async => _summary(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResearcherScaffold), findsOneWidget);
      expect(find.text('Survey Statistics Overview'), findsWidgets);
      expect(find.text('Survey Response counts'), findsWidgets);
      expect(find.text('Survey Status Percentages'), findsWidgets);
      expect(find.text('Recent Surveys'), findsWidgets);
      expect(find.text('Active surveys'), findsWidgets);
      expect(find.textContaining('70'), findsWidgets);
    });

    testWidgets('shows loading indicator while summary is unresolved',
        (tester) async {
      final completer = Completer<DashboardSummary>();

      await tester.pumpWidget(
        buildTestPage(
          const ResearcherDashboardPage(),
          overrides: [
            ..._messagingOverrides,
            researcherDashboardSummaryProvider.overrideWith(
              (ref) => completer.future,
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when summary fails', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ResearcherDashboardPage(),
          overrides: [
            ..._messagingOverrides,
            researcherDashboardSummaryProvider.overrideWith(
              (ref) async => throw Exception('boom'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('renders suppression banner when summary is suppressed',
        (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ResearcherDashboardPage(),
          overrides: [
            ..._messagingOverrides,
            researcherDashboardSummaryProvider.overrideWith(
              (ref) async => _summary(
                suppressed: true,
                reason: 'Insufficient responses (minimum 5 required)',
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Insufficient responses (minimum 5 required)'),
        findsOneWidget,
      );
    });

  });

  group('ResearcherScaffold', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ResearcherScaffold(
            currentRoute: '/surveys',
            child: Text('Researcher Content'),
          ),
          overrides: [..._messagingOverrides],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Researcher Content'), findsOneWidget);
    });

    testWidgets('forwards menu taps to the header', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestPage(
          ResearcherScaffold(
            currentRoute: '/surveys',
            onMenuTap: () => tapped = true,
            child: const SizedBox(),
          ),
          overrides: [..._messagingOverrides],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Menu'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('preserves the provided current route', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ResearcherScaffold(
            currentRoute: '/templates',
            child: SizedBox(),
          ),
          overrides: [..._messagingOverrides],
        ),
      );
      await tester.pumpAndSettle();

      final scaffold = tester.widget<ResearcherScaffold>(
        find.byType(ResearcherScaffold),
      );
      expect(scaffold.currentRoute, '/templates');
    });
  });
}
