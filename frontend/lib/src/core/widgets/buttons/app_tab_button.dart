// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/buttons/app_tab_button.dart

/// AppTabButton
///
/// A toggle-style tab button used for filter/status selection rows.
/// Selected state shows primary background; unselected shows white with border.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppTabButton extends StatelessWidget {
  const AppTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  /// Button label text.
  final String label;

  /// Whether this tab is currently selected.
  final bool isSelected;

  /// Callback when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppTheme.primary : colors.divider,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          softWrap: true,
          style: AppTheme.body.copyWith(
            color: isSelected
                ? AppTheme.textContrast
                : colors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
