// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/data_display/tracking_controls_bar.dart
/// Shared control bar for Health Tracking history views.
///
/// Used in both the participant health-tracking page and the HCP reports page.
/// Renders three SegmentedButton groups (mode | granularity | view) in a
/// responsive layout: two rows on narrow screens (< 520 px wide), one row
/// on wide screens.
///
/// Fixes the "buttons expand vertically" bug by:
///   • softWrap: false + overflow: ellipsis on every segment label Text
///   • SizedBox(height: 40) constraining each SegmentedButton
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';

// ── Shared enums ──────────────────────────────────────────────────────────────

enum TrackingHistoryMode { all, byCategory, byMetric }

enum TrackingResultView { table, chart }

enum TrackingDisplayGranularity { daily, weekly, monthly }

// ── Widget ────────────────────────────────────────────────────────────────────

/// Responsive filter/mode bar for health-tracking history views.
///
/// Groups three SegmentedButton rows (mode, granularity, view) into a
/// single toolbar that collapses to two rows on narrow screens.
class TrackingControlsBar extends StatelessWidget {
  const TrackingControlsBar({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.granularity,
    required this.onGranularityChanged,
    required this.resultsView,
    required this.onResultsViewChanged,
  });

  final TrackingHistoryMode mode;
  final void Function(TrackingHistoryMode) onModeChanged;

  final TrackingDisplayGranularity granularity;
  final void Function(TrackingDisplayGranularity) onGranularityChanged;

  final TrackingResultView resultsView;
  final void Function(TrackingResultView) onResultsViewChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackRows = constraints.maxWidth < 520;

        final modeBtn = Semantics(
          label: l10n.healthTrackingHistoryModeLabel,
          child: SegmentedButton<TrackingHistoryMode>(
            segments: [
              ButtonSegment(
                value: TrackingHistoryMode.all,
                label: Text(
                  l10n.healthTrackingHistoryAll,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                icon: const Icon(Icons.list_alt_outlined, size: 16),
              ),
              ButtonSegment(
                value: TrackingHistoryMode.byCategory,
                label: Text(
                  l10n.healthTrackingHistoryByCategory,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                icon: const Icon(Icons.category_outlined, size: 16),
              ),
              ButtonSegment(
                value: TrackingHistoryMode.byMetric,
                label: Text(
                  l10n.healthTrackingHistoryByMetric,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                icon: const Icon(Icons.show_chart, size: 16),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (s) => onModeChanged(s.first),
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(AppTheme.captions),
            ),
          ),
        );

        final granularityBtn = Semantics(
          label: l10n.healthTrackingGranularityLabel,
          child: SegmentedButton<TrackingDisplayGranularity>(
            segments: [
              ButtonSegment(
                value: TrackingDisplayGranularity.daily,
                label: Text(
                  l10n.healthTrackingGranularityDaily,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment(
                value: TrackingDisplayGranularity.weekly,
                label: Text(
                  l10n.healthTrackingGranularityWeekly,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment(
                value: TrackingDisplayGranularity.monthly,
                label: Text(
                  l10n.healthTrackingGranularityMonthly,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            selected: {granularity},
            onSelectionChanged: (s) => onGranularityChanged(s.first),
            style: const ButtonStyle(
              textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11)),
            ),
          ),
        );

        final viewBtn = Semantics(
          label: l10n.healthTrackingResultsViewLabel,
          child: SegmentedButton<TrackingResultView>(
            segments: [
              ButtonSegment(
                value: TrackingResultView.table,
                icon: Tooltip(
                  message: l10n.healthTrackingViewTable,
                  child: const Icon(Icons.table_rows_outlined, size: 16),
                ),
              ),
              ButtonSegment(
                value: TrackingResultView.chart,
                icon: Tooltip(
                  message: l10n.healthTrackingViewChart,
                  child: const Icon(Icons.bar_chart, size: 16),
                ),
              ),
            ],
            selected: {resultsView},
            onSelectionChanged: (s) => onResultsViewChanged(s.first),
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(AppTheme.captions),
            ),
          ),
        );

        if (stackRows) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              modeBtn,
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: granularityBtn),
                  const SizedBox(width: 8),
                  viewBtn,
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: modeBtn),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: granularityBtn),
            const SizedBox(width: 8),
            viewBtn,
          ],
        );
      },
    );
  }
}
