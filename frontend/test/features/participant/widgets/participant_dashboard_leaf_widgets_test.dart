import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/participant/widgets/graph_card.dart';
import 'package:frontend/src/features/participant/widgets/notification_banner.dart';
import 'package:frontend/src/features/participant/widgets/remaining_tasks_dropdown.dart';
import 'package:frontend/src/features/participant/widgets/task_card.dart';
import 'package:frontend/src/features/participant/widgets/task_progress_bar.dart';
import 'package:frontend/src/features/participant/widgets/view_all_tasks_button.dart';
import 'package:frontend/src/features/participant/widgets/welcome_banner.dart';

import '../../../test_helpers.dart';

void main() {
  group('Participant dashboard leaf widgets', () {
    testWidgets('GraphCard shows placeholder and custom child', (tester) async {
      await tester.pumpWidget(buildTestWidget(const GraphCard(title: 'Mood Trends')));
      await tester.pumpAndSettle();

      expect(find.text('Mood Trends'), findsOneWidget);
      expect(find.text('Graph placeholder'), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(
          const GraphCard(
            title: 'Sleep',
            height: 240,
            child: Text('Custom Chart'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Chart'), findsOneWidget);
      final contentContainer = tester.widgetList<Container>(find.byType(Container)).last;
      expect(contentContainer.constraints?.maxHeight ?? contentContainer.constraints?.minHeight, 240);
    });

    testWidgets('TaskProgressBar renders localized progress copy', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TaskProgressBar(completedTasks: 2, totalTasks: 5),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your Task Progress:'), findsOneWidget);
      expect(find.text('2 out of 5 tasks completed'), findsOneWidget);
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('TaskProgressBar handles zero total tasks', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TaskProgressBar(completedTasks: 0, totalTasks: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 out of 0 tasks completed'), findsOneWidget);

      final frac = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(frac.widthFactor, 0.0);
    });

    testWidgets('NotificationBanner hides when empty and calls onTap when shown',
        (tester) async {
      var tapped = 0;

      await tester.pumpWidget(
        buildTestWidget(
          NotificationBanner(
            messageCount: 0,
            onTap: () => tapped += 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsNothing);

      await tester.pumpWidget(
        buildTestWidget(
          NotificationBanner(
            messageCount: 3,
            onTap: () => tapped += 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('You have 3 new messages.\nClick to here to view.'),
        findsOneWidget,
      );
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(tapped, 1);
    });

    testWidgets('RemainingTasksDropdown renders count and handles tap', (tester) async {
      var tapped = 0;

      await tester.pumpWidget(
        buildTestWidget(
          RemainingTasksDropdown(
            remainingCount: 4,
            onTap: () => tapped += 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Remaining tasks for today: 4'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(tapped, 1);
    });

    testWidgets('ViewAllTasksButton and WelcomeBanner render and invoke callback',
        (tester) async {
      var pressed = 0;

      await tester.pumpWidget(
        buildTestWidget(
          Column(
            children: [
              const WelcomeBanner(firstName: 'Ada'),
              ViewAllTasksButton(onPressed: () => pressed += 1),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome, Ada. How are you today?'), findsOneWidget);
      expect(find.text('View All Tasks'), findsOneWidget);

      await tester.tap(find.text('View All Tasks'));
      await tester.pumpAndSettle();
      expect(pressed, 1);
    });

    testWidgets('WelcomeBanner handles empty first name', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const WelcomeBanner(firstName: '')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome'), findsOneWidget);
    });

    testWidgets('TaskCard renders optional repeat info and disabled button state',
        (tester) async {
      var tapped = 0;

      await tester.pumpWidget(
        buildTestWidget(
          Column(
            children: [
              TaskCard(
                title: 'Hydration',
                dueTime: 'Due today at 2:30 PM',
                repeatInfo: 'Repeats every 3 days',
                onDoTask: () => tapped += 1,
              ),
              const SizedBox(height: 12),
              const TaskCard(
                title: 'Standalone',
                dueTime: 'Due on 2026-03-23',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('Repeats every 3 days'), findsOneWidget);
      expect(find.text('Standalone'), findsOneWidget);

      await tester.tap(find.text('Do Task').first);
      await tester.pumpAndSettle();
      expect(tapped, 1);

      final secondButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton).last,
      );
      expect(secondButton.onPressed, isNull);
    });
  });
}
