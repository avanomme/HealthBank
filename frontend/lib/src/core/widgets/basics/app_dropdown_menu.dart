// Created with the Assistance of ChatGPT

/// AppDropdownMenu
///
/// Description:
/// - A theme-aware dropdown menu for selecting from a list of options.
/// - `AppDropdownMenu` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme typography and colors.
/// - Supports disabled and active states per option.
/// - Responsive sizing based on global breakpoints.
///
/// Usage Example:
/// ```dart
/// AppDropdownMenu<String>(
///   initialValue: 'daily',
///   options: const [
///     AppDropdownOption(label: 'Daily', value: 'daily'),
///     AppDropdownOption(label: 'Weekly', value: 'weekly'),
///   ],
///   onChanged: (value) {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.label,
    required this.value,
    this.enabled = true,
  });

  /// Display label for the option.
  final String label;

  /// Underlying value for the option.
  final T value;

  /// Whether the option can be selected.
  final bool enabled;
}

class AppDropdownMenu<T> extends StatelessWidget {
  const AppDropdownMenu({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.hintText,
  });

  /// List of selectable options.
  final List<AppDropdownOption<T>> options;

  /// Currently selected value.
  final T? initialValue;

  /// Callback invoked when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Optional hint text when no value is selected.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);
    final textStyle = textTheme.bodyMedium ?? AppTheme.body;
    final padding = Breakpoints.responsivePadding(width);
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      onChanged: onChanged,
      isExpanded: true,
      iconEnabledColor: AppTheme.primary,
      iconDisabledColor: AppTheme.muted,
      style: textStyle.copyWith(color: context.appColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle.copyWith(color: context.appColors.textMuted),
        contentPadding: EdgeInsets.symmetric(
          horizontal: padding * 0.8,
          vertical: padding * 0.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(padding * 0.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(padding * 0.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.muted),
          borderRadius: BorderRadius.circular(padding * 0.4),
        ),
      ),
      items: options
          .map(
            (option) => DropdownMenuItem<T>(
              value: option.value,
              enabled: option.enabled,
              child: Text(
                option.label,
                style: textStyle.copyWith(
                  color: option.enabled ? context.appColors.textPrimary : context.appColors.textMuted,
                  fontWeight: option.value == initialValue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
