// Created with the Assistance of ChatGPT

/// AppCheckbox
///
/// Description:
/// - A theme-aware checkbox input that supports controlled and uncontrolled use.
/// - `AppCheckbox` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme colors for active and check states.
/// - Controlled: provide `value` and `onChanged`.
/// - Uncontrolled: omit `value` and provide `initialValue`.
///
/// Usage Example:
/// ```
/// const AppCheckbox(
///   value: true,
///   onChanged: (value) {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppCheckbox extends StatefulWidget {
  const AppCheckbox({
    super.key,
    this.value,
    this.initialValue = false,
    this.onChanged,
    this.tristate = false,
    this.enabled = true,
    this.activeColor,
    this.checkColor,
    this.visualDensity,
    this.materialTapTargetSize,
  });

  /// Controlled value. When provided, widget is controlled.
  final bool? value;

  /// Initial value for uncontrolled usage.
  final bool initialValue;

  /// Change callback.
  final ValueChanged<bool?>? onChanged;

  /// Whether the checkbox supports a null value.
  final bool tristate;

  /// Whether the checkbox is interactive.
  final bool enabled;

  /// Optional color overrides.
  final Color? activeColor;
  final Color? checkColor;

  /// Optional layout density overrides.
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant AppCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveValue = widget.value ?? _value ?? false;
    final effectiveActiveColor = widget.activeColor ?? AppTheme.primary;
    final effectiveCheckColor = widget.checkColor ?? AppTheme.textContrast;

    return Checkbox(
      value: effectiveValue,
      tristate: widget.tristate,
      activeColor: effectiveActiveColor,
      checkColor: effectiveCheckColor,
      visualDensity: widget.visualDensity,
      materialTapTargetSize: widget.materialTapTargetSize,
      onChanged: widget.enabled
          ? (value) {
              if (widget.value == null) {
                setState(() => _value = value);
              }
              widget.onChanged?.call(value);
            }
          : null,
    );
  }
}
