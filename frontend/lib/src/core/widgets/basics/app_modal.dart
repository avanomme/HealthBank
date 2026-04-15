// Created with the Assistance of ChatGPT

/// AppModal
///
/// Description:
/// - A centered modal dialog that displays content above an AppOverlay.
/// - `AppModal` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Renders an AppOverlay behind the modal.
/// - Modal content is centered and vertically aligned.
/// - Default structure: Heading 3 title, body text, primary action button.
///
/// Usage Example:
/// ```dart
/// AppModal(
///   title: 'Confirm action',
///   body: 'This action cannot be undone.',
///   actionLabel: 'Confirm',
///   onClose: () {},
/// );
/// ```
library;


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_overlay.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';

class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onClose,
  });

  /// Modal title text (Heading 3).
  final String title;

  /// Modal body text.
  final String body;

  /// Label for the primary action button.
  final String actionLabel;

  /// Callback invoked when the modal should close.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);
    final headingStyle = textTheme.displaySmall ?? AppTheme.heading3;
    final bodyStyle = textTheme.bodyMedium ?? AppTheme.body;

    final padding = Breakpoints.responsivePadding(width);
    final horizontalMargin = Breakpoints.responsiveHorizontalMargin(width);
    final maxWidth = math.min(Breakpoints.maxContent, width - horizontalMargin * 2);
    final cardRadius = BorderRadius.circular(padding * 0.6);

    return AppOverlay(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(horizontalMargin),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: math.max(0, maxWidth)),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: cardRadius,
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: headingStyle),
                    SizedBox(height: padding * 0.5),
                    Text(body, style: bodyStyle),
                    SizedBox(height: padding),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppFilledButton(
                        label: actionLabel,
                        onPressed: onClose,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
