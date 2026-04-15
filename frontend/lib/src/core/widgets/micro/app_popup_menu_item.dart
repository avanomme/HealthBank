// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_popup_menu_item.dart

/// appPopupMenuItem
///
/// Helper function to create a PopupMenuItem with icon + label row.
/// Replaces the repeated Row(Icon, SizedBox, Text) pattern in popup menus.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Creates a [PopupMenuItem] with an icon and label in a row.
PopupMenuItem<T> appPopupMenuItem<T>({
  required T value,
  required IconData icon,
  required String label,
  Color? color,
  double iconSize = 20,
}) {
  final effectiveColor = color;
  return PopupMenuItem<T>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: iconSize, color: effectiveColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: effectiveColor != null
              ? TextStyle(color: effectiveColor)
              : null,
        ),
      ],
    ),
  );
}

/// Creates a destructive (error-colored) [PopupMenuItem].
PopupMenuItem<T> appPopupMenuItemDestructive<T>({
  required T value,
  required IconData icon,
  required String label,
}) {
  return appPopupMenuItem<T>(
    value: value,
    icon: icon,
    label: label,
    color: AppTheme.error,
  );
}
