// Created with the Assistance of Claude Code
// test/features/participant/widgets/health_metric_entry_card_test.dart
/// Widget tests for HealthMetricEntryCard.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/features/participant/widgets/health_metric_entry_card.dart';

import '../../../test_helpers.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

TrackingMetric _metric({
  int metricId = 1,
  String metricType = 'scale',
  String displayName = 'Test Metric',
  String? description,
  String? unit,
  int? scaleMin,
  int? scaleMax,
  List<String>? choiceOptions,
}) =>
    TrackingMetric(
      metricId: metricId,
      categoryId: 1,
      metricKey: 'test_metric',
      displayName: displayName,
      description: description,
      metricType: metricType,
      unit: unit,
      scaleMin: scaleMin,
      scaleMax: scaleMax,
      choiceOptions: choiceOptions,
      frequency: 'daily',
      displayOrder: 0,
      isActive: true,
      isBaseline: false,
    );

Widget _card({
  required TrackingMetric metric,
  String? initialValue,
  void Function(String)? onChanged,
}) =>
    buildTestWidget(
      HealthMetricEntryCard(
        metric: metric,
        initialValue: initialValue,
        onChanged: onChanged ?? (_) {},
      ),
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('HealthMetricEntryCard', () {
    // ── Scale ──────────────────────────────────────────────────────────────

    testWidgets('renders scale slider for scale metric', (tester) async {
      await tester.pumpWidget(
        _card(metric: _metric(metricType: 'scale', scaleMin: 1, scaleMax: 10)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('scale slider shows current value label when touched',
        (tester) async {
      String? emitted;
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'scale', scaleMin: 1, scaleMax: 10),
          onChanged: (v) => emitted = v,
        ),
      );
      await tester.pumpAndSettle();

      // Drag slider to the right to touch it and change value.
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // After dragging, _touched becomes true — value label should appear.
      expect(emitted, isNotNull);
      // The numeric label text should be visible somewhere in the tree.
      expect(find.text(emitted!), findsWidgets);
    });

    // ── YesNo ──────────────────────────────────────────────────────────────

    testWidgets('renders yes and no ChoiceChips', (tester) async {
      await tester.pumpWidget(
        _card(metric: _metric(metricType: 'yesno')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ChoiceChip), findsNWidgets(2));
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('tapping yes calls onChanged with yes', (tester) async {
      String? emitted;
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'yesno'),
          onChanged: (v) => emitted = v,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(emitted, 'yes');
    });

    testWidgets('tapping no calls onChanged with no', (tester) async {
      String? emitted;
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'yesno'),
          onChanged: (v) => emitted = v,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(emitted, 'no');
    });

    testWidgets('yes chip shows selected state when initialValue is yes',
        (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'yesno'),
          initialValue: 'yes',
        ),
      );
      await tester.pumpAndSettle();

      // Find the ChoiceChip labelled "Yes" and verify it is selected.
      final yesChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Yes'),
      );
      expect(yesChip.selected, isTrue);
    });

    // ── Number ────────────────────────────────────────────────────────────

    testWidgets('renders text field for number metric', (tester) async {
      await tester.pumpWidget(
        _card(metric: _metric(metricType: 'number')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering value calls onChanged', (tester) async {
      String? emitted;
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'number'),
          onChanged: (v) => emitted = v,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '42');
      await tester.pumpAndSettle();

      expect(emitted, '42');
    });

    // ── Single choice ─────────────────────────────────────────────────────

    testWidgets('renders dropdown for single_choice metric', (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(
            metricType: 'single_choice',
            choiceOptions: ['Option A', 'Option B'],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // AppDropdownInput wraps a DropdownButton (not DropdownButtonFormField).
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('answered card shows check_circle icon', (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(
            metricType: 'single_choice',
            choiceOptions: ['Option A', 'Option B'],
          ),
          initialValue: 'Option A',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    // ── Card structure ────────────────────────────────────────────────────

    testWidgets('shows metric description when present', (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(
            metricType: 'scale',
            scaleMin: 1,
            scaleMax: 5,
            description: 'Rate your pain level',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rate your pain level'), findsOneWidget);
    });

    testWidgets('shows unit badge when unanswered', (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'number', unit: 'kg'),
          initialValue: null,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('kg'), findsWidgets);
    });

    testWidgets('shows check icon when answered', (tester) async {
      await tester.pumpWidget(
        _card(
          metric: _metric(metricType: 'scale', scaleMin: 1, scaleMax: 10),
          initialValue: '5',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });
  });
}
