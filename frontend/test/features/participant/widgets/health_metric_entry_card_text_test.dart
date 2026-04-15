// Created with the Assistance of Claude Code
// test/features/participant/widgets/health_metric_entry_card_text_test.dart
/// Widget tests for the _TextInput variant of HealthMetricEntryCard.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/features/participant/widgets/health_metric_entry_card.dart';

import '../../../test_helpers.dart';

TrackingMetric _textMetric({String? description}) => TrackingMetric(
      metricId: 1,
      categoryId: 1,
      metricKey: 'notes',
      displayName: 'Daily Notes',
      description: description,
      metricType: 'text',
      unit: null,
      scaleMin: null,
      scaleMax: null,
      choiceOptions: null,
      frequency: 'daily',
      displayOrder: 0,
      isActive: true,
      isBaseline: false,
    );

Widget _card({String? initialValue, void Function(String)? onChanged}) =>
    buildTestWidget(
      HealthMetricEntryCard(
        metric: _textMetric(),
        initialValue: initialValue,
        onChanged: onChanged ?? (_) {},
      ),
    );

void main() {
  group('HealthMetricEntryCard — text type', () {
    testWidgets('renders a TextField for text metric', (tester) async {
      await tester.pumpWidget(_card());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering text calls onChanged with the value', (tester) async {
      String? emitted;
      await tester.pumpWidget(_card(onChanged: (v) => emitted = v));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Feeling good today');
      await tester.pumpAndSettle();

      expect(emitted, 'Feeling good today');
    });

    testWidgets('initialValue pre-fills the text field', (tester) async {
      await tester.pumpWidget(_card(initialValue: 'Pre-filled note'));
      await tester.pumpAndSettle();

      expect(find.text('Pre-filled note'), findsOneWidget);
    });

    testWidgets('answered text card shows check icon', (tester) async {
      await tester.pumpWidget(_card(initialValue: 'something'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('empty text card does not show check icon', (tester) async {
      await tester.pumpWidget(_card(initialValue: null));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });
  });
}
