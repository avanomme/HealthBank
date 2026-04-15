// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/graph_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Graph card widget for displaying charts/diagrams
///
/// Matches the Figma design: Card with title and placeholder for graph content
class GraphCard extends StatelessWidget {
  const GraphCard({
    super.key,
    required this.title,
    this.child,
    this.height = 180,
  });

  /// Title displayed at top of card
  final String title;

  /// Graph/chart widget to display (placeholder if null)
  final Widget? child;

  /// Height of the card
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: context.appColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: AppTheme.body.copyWith(
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Graph content area
          Container(
            height: height,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.placeholder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: child ?? Center(
              child: Text(
                'Graph placeholder',
                style: TextStyle(color: context.appColors.textMuted)),
            ),
          ),
        ],
      ),
    );
  }
}
