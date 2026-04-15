// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/feedback/app_loading_indicator.dart
/// Reusable loading indicator widget with centered and inline variants.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 36,
    this.strokeWidth = 4,
    this.color,
    this.centered = true,
    this.semanticLabel,
  });

  /// Small inline spinner for buttons and compact spaces.
  const AppLoadingIndicator.inline({
    super.key,
    this.size = 16,
    this.strokeWidth = 2,
    this.color,
    this.centered = false,
    this.semanticLabel,
  });

  /// Diameter of the spinner.
  final double size;

  /// Thickness of the progress arc.
  final double strokeWidth;

  /// Color override. Defaults to [AppTheme.primary].
  final Color? color;

  /// Whether to wrap the spinner in a [Center] widget.
  final bool centered;

  /// Accessible label announced as a live region when the spinner appears.
  /// Defaults to the localized "Loading…" string. Pass empty string to suppress.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final label = semanticLabel ?? context.l10n.commonLoading;
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? AppTheme.primary,
        semanticsLabel: label,
      ),
    );

    return Semantics(
      liveRegion: true,
      label: label,
      child: centered ? Center(child: indicator) : indicator,
    );
  }
}
