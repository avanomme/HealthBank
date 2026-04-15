import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/features/admin/pages/deletion_queue_page.dart';

void main() {
  group('DeletionQueuePage', () {
    testWidgets('redirects to admin messages on first frame', (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.adminDeletionQueue,
        routes: [
          GoRoute(
            path: AppRoutes.adminDeletionQueue,
            builder: (context, state) => const DeletionQueuePage(),
          ),
          GoRoute(
            path: AppRoutes.adminMessages,
            builder: (context, state) => const Scaffold(
              body: Text('Messages Destination'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // First build should contain the redirect page only.
      expect(find.byType(DeletionQueuePage), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);

      // Run post-frame callback and complete navigation.
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Messages Destination'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, AppRoutes.adminMessages);
    });

    testWidgets('renders as an empty placeholder widget', (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.adminDeletionQueue,
        routes: [
          GoRoute(
            path: AppRoutes.adminDeletionQueue,
            builder: (context, state) => const DeletionQueuePage(),
          ),
          GoRoute(
            path: AppRoutes.adminMessages,
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Before the post-frame redirect, this page renders no visible content.
      final box = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(box.width, 0);
      expect(box.height, 0);
    });
  });
}
