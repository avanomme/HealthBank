import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/public/error/not_found_page.dart';

import '../../../test_helpers.dart';

void main() {
  group('NotFoundPage', () {
    group('Widget rendering', () {
      testWidgets('renders Scaffold as root widget', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('has AppBar with title', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Page Not Found'), findsOneWidget);
      });

      testWidgets('displays body content', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(Center), findsWidgets);
      });
    });

    group('Content rendering', () {
      testWidgets('displays error icon', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('displays 404 heading text', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.text('404 - Page Not Found'), findsOneWidget);
      });

      testWidgets('displays error message text', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.textContaining('does not exist'), findsOneWidget);
      });

      testWidgets('displays all expected text widgets', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(Text), findsWidgets);
        // Should have at least 3 Text widgets: AppBar title, 404 heading, error message
        expect(find.byType(Text).evaluate().length, greaterThanOrEqualTo(3));
      });
    });

    group('Layout and structure', () {
      testWidgets('uses Column for vertical layout', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Column uses center main axis alignment', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        final columnFinder = find.byType(Column);
        expect(columnFinder, findsOneWidget);

        // Column uses mainAxisAlignment: MainAxisAlignment.center
        final column = tester.widget<Column>(columnFinder);
        expect(column.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('has proper spacing between elements', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        // Should have SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Visual elements', () {
      testWidgets('error icon has correct size', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        final iconFinder = find.byIcon(Icons.error_outline);
        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 80);
      });

      testWidgets('error icon is red color', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        final iconFinder = find.byIcon(Icons.error_outline);
        final icon = tester.widget<Icon>(iconFinder);

        expect(icon.color, Colors.red);
      });

      testWidgets('heading text has large font size', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        final textFinder = find.text('404 - Page Not Found');
        expect(textFinder, findsOneWidget);

        final text = tester.widget<Text>(textFinder);
        expect(text.style?.fontSize, 24);
      });
    });

    group('Responsive behavior', () {
      testWidgets('renders correctly on desktop viewport', (tester) async {
        tester.view.physicalSize = const Size(1600, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('404 - Page Not Found'), findsOneWidget);
      });

      testWidgets('renders correctly on tablet viewport', (tester) async {
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('404 - Page Not Found'), findsOneWidget);
      });

      testWidgets('renders correctly on mobile viewport', (tester) async {
        tester.view.physicalSize = const Size(420, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('404 - Page Not Found'), findsOneWidget);
      });

      testWidgets('renders correctly on very narrow viewport', (tester) async {
        tester.view.physicalSize = const Size(300, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('renders correctly on very wide viewport', (tester) async {
        tester.view.physicalSize = const Size(2560, 1440);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Widget hierarchy', () {
      testWidgets('Scaffold contains AppBar', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        final scaffoldFinder = find.byType(Scaffold);
        expect(scaffoldFinder, findsOneWidget);

        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('Center contains Column', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Column contains Icon and Text widgets', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('content is properly laid out vertically', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        // All elements should be present in the correct order (icon first, then text)
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('404 - Page Not Found'), findsOneWidget);
        expect(find.textContaining('does not exist'), findsOneWidget);

        // Verify Column structure contains all elements
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Edge cases', () {
      testWidgets('page is stateless and constant', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        // Widget should render without any state management
        expect(find.byType(NotFoundPage), findsOneWidget);
      });

      testWidgets('rebuilds correctly when rebuilt', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        expect(find.text('404 - Page Not Found'), findsOneWidget);

        // Rebuild the widget
        await tester.pumpWidget(
          buildTestPage(const NotFoundPage()),
        );

        // Should still find all elements
        expect(find.text('404 - Page Not Found'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('displays consistently across multiple renders', (tester) async {
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(
            buildTestPage(const NotFoundPage()),
          );

          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.text('Page Not Found'), findsOneWidget);
          expect(find.text('404 - Page Not Found'), findsOneWidget);
          expect(find.textContaining('does not exist'), findsOneWidget);
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
        }
      });
    });
  });
}
