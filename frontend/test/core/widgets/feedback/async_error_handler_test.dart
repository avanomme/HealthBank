import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/core/widgets/feedback/async_error_handler.dart';

import '../../../test_helpers.dart';

void main() {
  group('AsyncValueWidget', () {
    testWidgets('renders data state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          AsyncValueWidget<int>(
            value: const AsyncValue.data(7),
            data: (value) => Text('Value $value'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Value 7'), findsOneWidget);
    });

    testWidgets('renders loading state with message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AsyncValueWidget<int>(
            value: AsyncValue.loading(),
            data: _unusedIntWidget,
            loadingMessage: 'Loading records',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(find.text('Loading records'), findsOneWidget);
    });

    testWidgets('renders error state with retry callback', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        buildTestWidget(
          AsyncValueWidget<int>(
            value: AsyncValue.error(Exception('boom'), StackTrace.empty),
            data: _unusedIntWidget,
            errorMessage: 'Something failed',
            onRetry: () => retried = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something failed'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(retried, isTrue);
    });
  });
}

Widget _unusedIntWidget(int value) => Text('$value');
