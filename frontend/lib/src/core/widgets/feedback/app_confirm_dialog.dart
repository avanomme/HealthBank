// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/feedback/app_confirm_dialog.dart
/// Reusable confirmation dialog for destructive or important actions.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.confirmColor,
    this.isDangerous = false,
  });

  /// Dialog title.
  final String title;

  /// Body text or description.
  final String content;

  /// Text for the confirm button.
  final String confirmLabel;

  /// Text for the cancel button. Defaults to 'Cancel'.
  final String cancelLabel;

  /// Called when the confirm button is pressed.
  /// If null, the dialog pops with `true`.
  final VoidCallback? onConfirm;

  /// Color for the confirm button. Defaults to [AppTheme.error]
  /// when [isDangerous] is true, otherwise [AppTheme.primary].
  final Color? confirmColor;

  /// Whether this is a destructive action (uses error color by default).
  final bool isDangerous;

  /// Show the dialog and return `true` if confirmed, `false` otherwise.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        confirmColor ?? (isDangerous ? AppTheme.error : AppTheme.primary);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        AppTextButton(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppFilledButton(
          label: confirmLabel,
          backgroundColor: resolvedColor,
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}
