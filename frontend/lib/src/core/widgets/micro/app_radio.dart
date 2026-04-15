// Created with the Assistance of ChatGPT

/// AppRadio
///
/// Description:
/// - A theme-aware radio input that supports controlled and uncontrolled use.
/// - `AppRadio` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme colors for the active state.
/// - Controlled: provide `groupValue` and `onChanged`.
/// - Uncontrolled: omit `groupValue` and provide `initialGroupValue`.
///
/// Usage Example:
/// ```
/// AppRadio<String>(
///   value: 'yes',
///   groupValue: selectedValue,
///   onChanged: (value) {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppRadio<T> extends StatefulWidget {
  const AppRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.initialGroupValue,
    this.onChanged,
    this.toggleable = false,
    this.enabled = true,
    this.activeColor,
    this.visualDensity,
    this.materialTapTargetSize,
  });

  /// The value represented by this radio.
  final T value;

  /// Controlled group value. When provided, widget is controlled.
  final T? groupValue;

  /// Initial group value for uncontrolled usage.
  final T? initialGroupValue;

  /// Change callback.
  final ValueChanged<T?>? onChanged;

  /// Whether the radio can be toggled off.
  final bool toggleable;

  /// Whether the radio is interactive.
  final bool enabled;

  /// Optional color override for the active state.
  final Color? activeColor;

  /// Optional layout density overrides.
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  State<AppRadio<T>> createState() => _AppRadioState<T>();
}

class _AppRadioState<T> extends State<AppRadio<T>> {
  T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue ?? widget.initialGroupValue;
  }

  @override
  void didUpdateWidget(covariant AppRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groupValue != null && widget.groupValue != oldWidget.groupValue) {
      _groupValue = widget.groupValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGroupValue = widget.groupValue ?? _groupValue;
    final effectiveActiveColor = widget.activeColor ?? AppTheme.primary;

    return RadioGroup<T>(
      groupValue: effectiveGroupValue,
      onChanged: widget.enabled
          ? (value) {
              if (widget.groupValue == null) {
                setState(() => _groupValue = value);
              }
              widget.onChanged?.call(value);
            }
          : (_) {},
      child: Radio<T>(
        value: widget.value,
        toggleable: widget.toggleable,
        activeColor: effectiveActiveColor,
        visualDensity: widget.visualDensity,
        materialTapTargetSize: widget.materialTapTargetSize,
      ),
    );
  }
}
