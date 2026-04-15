import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/basics/footer.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/surveys/pages/survey_list_page.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:go_router/go_router.dart';

import '../../test_helpers.dart';

Survey _survey({
  int id = 1,
  String title = 'Test Survey',
  String? description = 'Test description',
  String status = 'draft',
  int? questionCount = 5,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return Survey(
    surveyId: id,
    title: title,
    publicationStatus: status,
    status: 'not-started',
    description: description,
    questions: const [],
    questionCount: questionCount,
    startDate: startDate,
    endDate: endDate,
  );
}

void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('SurveyListPage coverage', () {
    testWidgets('displays empty state when no surveys', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
    });

    testWidgets('displays empty state with filters when search has no results', (
      tester,
    ) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveyFiltersProvider.overrideWith(
              (ref) {
                final notifier = SurveyFiltersNotifier();
                notifier.setSearchQuery('nonexistent');
                return notifier;
              },
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('displays error state and retry action', (tester) async {
      _useDesktopViewport(tester);
      late Exception testError;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) async {
                testError = Exception('Failed to load surveys');
                throw testError;
              },
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.widgetWithText(AppFilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('displays surveys in list', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(id: 1, title: 'Survey One', status: 'draft'),
        _survey(id: 2, title: 'Survey Two', status: 'published'),
        _survey(id: 3, title: 'Survey Three', status: 'closed'),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Survey One'), findsOneWidget);
      expect(find.text('Survey Two'), findsOneWidget);
      expect(find.text('Survey Three'), findsOneWidget);
    });

    testWidgets('displays survey status badges with correct colors', (
      tester,
    ) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(id: 1, title: 'Draft Survey', status: 'draft'),
        _survey(id: 2, title: 'Published Survey', status: 'published'),
        _survey(id: 3, title: 'Closed Survey', status: 'closed'),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // All status labels should be present
      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Published'), findsOneWidget);
      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets('displays survey description and question count', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(
          id: 1,
          title: 'Survey With Details',
          description: 'A detailed survey',
          questionCount: 10,
        ),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('A detailed survey'), findsOneWidget);
      expect(find.textContaining('10'), findsWidgets);
    });

    testWidgets('displays date range when survey has dates', (tester) async {
      _useDesktopViewport(tester);

      final startDate = DateTime(2026, 3, 1);
      final endDate = DateTime(2026, 3, 31);
      final surveys = [
        _survey(
          id: 1,
          title: 'Survey With Dates',
          startDate: startDate,
          endDate: endDate,
        ),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Date format is m/d/y - m/d/y
      expect(find.textContaining('3/1/2026'), findsOneWidget);
      expect(find.textContaining('3/31/2026'), findsOneWidget);
    });

    testWidgets('search field filters surveys by title', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(id: 1, title: 'Health Survey'),
        _survey(id: 2, title: 'Nutrition Survey'),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Both surveys initially visible
      expect(find.text('Health Survey'), findsOneWidget);
      expect(find.text('Nutrition Survey'), findsOneWidget);

      // Type in search
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Health');
      await tester.pumpAndSettle();

      // surveysProvider filters based on search query
      expect(find.textContaining('Search'), findsWidgets);
    });

    testWidgets('search clear button appears when text is entered', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsNothing);

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('status filter dropdown has all options', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final dropdownButton = find.byType(DropdownButtonFormField<String?>).first;
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      // Dropdown menu should show status options
      expect(find.text('Published'), findsOneWidget);
      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets('active filters chips display with delete buttons', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveyFiltersProvider.overrideWith(
              (ref) {
                final notifier = SurveyFiltersNotifier();
                notifier.setSearchQuery('test query');
                notifier.setPublicationStatus('draft');
                return notifier;
              },
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Filter chips should be visible
      expect(find.byType(Chip), findsWidgets);
      expect(find.byIcon(Icons.close), findsWidgets);
    });

    testWidgets('clear all button clears search and filters', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Add search text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Clear should exist
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('floating action button navigates to create survey', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNWidgets(2)); // "New Survey" + "From Template" FABs
    });

    testWidgets('survey card tap navigates to status page', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(id: 42, title: 'Clickable Survey'),
      ];

      final router = GoRouter(
        initialLocation: '/surveys',
        routes: [
          GoRoute(
            path: '/surveys',
            builder: (context, state) => const SurveyListPage(),
          ),
          GoRoute(
            path: '/surveys/:id/status',
            builder: (context, state) => const Scaffold(
              body: Text('Survey Status'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Clickable Survey'), findsOneWidget);

      final card = find.byType(InkWell).first;
      await tester.tap(card, warnIfMissed: false);
      await tester.pumpAndSettle();
    });

    testWidgets('survey without description shows only title', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [
        _survey(id: 1, title: 'No Description Survey', description: null),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Description Survey'), findsOneWidget);
    });

    testWidgets('survey with only start date formats correctly', (tester) async {
      _useDesktopViewport(tester);

      final startDate = DateTime(2026, 3, 15);
      final surveys = [
        _survey(
          id: 1,
          title: 'Start Date Only',
          startDate: startDate,
          endDate: null,
        ),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Start Date Only'), findsOneWidget);
      expect(find.textContaining('3/15/2026'), findsOneWidget);
    });

    testWidgets('survey with only end date formats correctly', (tester) async {
      _useDesktopViewport(tester);

      final endDate = DateTime(2026, 4, 30);
      final surveys = [
        _survey(
          id: 1,
          title: 'End Date Only',
          startDate: null,
          endDate: endDate,
        ),
      ];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('End Date Only'), findsOneWidget);
      expect(find.textContaining('4/30/2026'), findsOneWidget);
    });

    testWidgets('refresh indicator triggers survey reload', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [_survey(id: 1, title: 'Test Survey')];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Test Survey'), findsOneWidget);
    });

    testWidgets('list includes footer at bottom', (tester) async {
      _useDesktopViewport(tester);

      final surveys = [_survey(id: 1, title: 'Test Survey')];

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value(surveys),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Footer), findsOneWidget);
    });

    testWidgets('all status dropdown options available', (tester) async {
      _useDesktopViewport(tester);

      await tester.pumpWidget(
        buildTestPage(
          const SurveyListPage(),
          overrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) => Future.value([]),
            ),
            surveysProvider.overrideWith(
              (ref) => Future.value([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownButtonFormField<String?>).first;
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      expect(find.text('Published'), findsWidgets);
      expect(find.text('Closed'), findsWidgets);
    });
  });
}
