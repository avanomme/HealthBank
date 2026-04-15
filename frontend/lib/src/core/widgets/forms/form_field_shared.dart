// Created with the Assistance of Codex
/// Shared helpers for all app form field widgets.
///
/// Provides type aliases, responsive metrics resolver ([appFormMetrics]),
/// and the standardised [appInputDecoration] factory used by every form widget.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

const double kAppInputMinHeight = 44;

/// Signature for text-based validator hooks used by form widgets.
typedef AppStringValidator = String? Function(String value);

/// Signature for value-based validator hooks used by non-text form widgets.
typedef AppValueValidator<T> = String? Function(T? value);

/// Resolves responsive typography and spacing for form widgets.
({
  TextStyle labelStyle,
  TextStyle bodyStyle,
  TextStyle captionStyle,
  double spacing,
})
appFormMetrics(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final bp = breakpointForWidth(width);
  final textTheme = AppTheme.textThemeForBreakpoint(bp);
  final spacing = Breakpoints.responsivePadding(width);
  final colors = context.appColors;

  return (
    labelStyle: (textTheme.bodySmall ?? AppTheme.captions).copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    bodyStyle: (textTheme.bodyMedium ?? AppTheme.body).copyWith(
      color: colors.textPrimary,
    ),
    captionStyle: (textTheme.bodySmall ?? AppTheme.captions).copyWith(
      color: colors.textMuted,
    ),
    spacing: spacing,
  );
}

/// Standardized input decoration for all form input widgets.
InputDecoration appInputDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool enabled = true,
  EdgeInsetsGeometry? contentPadding,
}) {
  final theme = Theme.of(context);
  final metrics = appFormMetrics(context);
  final colors = context.appColors;
  final radius = BorderRadius.circular(metrics.spacing * 0.35);

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintStyle: metrics.bodyStyle.copyWith(color: colors.textMuted),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: enabled
        ? colors.inputFill
        : colors.surfaceSubtle.withValues(alpha: 0.75),
    contentPadding:
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: metrics.spacing * 0.7,
          vertical: metrics.spacing * 0.55,
        ),
    constraints: const BoxConstraints(minHeight: kAppInputMinHeight),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.inputBorder.withValues(alpha: 0.9)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppTheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppTheme.error, width: 1.4),
    ),
  );
}

/// Standard label widget shown above each input.
Widget appInputLabel(
  BuildContext context, {
  required String label,
  bool enabled = true,
}) {
  final metrics = appFormMetrics(context);
  return Text(
    label,
    style: metrics.labelStyle.copyWith(
      color: enabled
          ? context.appColors.textPrimary
          : context.appColors.textMuted,
    ),
  );
}

/// Shared animated helper/error message display.
Widget appAnimatedMessage(
  BuildContext context, {
  required String? message,
  required Color color,
}) {
  final metrics = appFormMetrics(context);
  final visible = message != null && message.trim().isNotEmpty;

  return AnimatedSize(
    duration: const Duration(milliseconds: 180),
    curve: Curves.easeOut,
    alignment: Alignment.topLeft,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: visible
          ? Padding(
              key: ValueKey<String>('message-$message'),
              padding: EdgeInsets.only(top: metrics.spacing * 0.35),
              child: Text(
                message,
                style: metrics.captionStyle.copyWith(color: color),
              ),
            )
          : const SizedBox.shrink(key: ValueKey<String>('message-empty')),
    ),
  );
}

/// Required-field validation with project-consistent copy.
String? appRequiredValidation(
  String value, {
  required bool isRequired,
  required String label,
}) {
  if (!isRequired) return null;
  if (value.trim().isNotEmpty) return null;
  return '$label is required.';
}

/// Returns only phone digits from user-entered text.
String phoneDigitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

/// Shared semantic label for a form control.
String appFieldSemanticsLabel(String label, {required bool isRequired}) =>
    isRequired ? '$label, required' : label;

/// Shared semantic hint that combines helper, hint, and validation feedback.
String? appFieldSemanticsHint({
  String? hintText,
  String? helperText,
  String? errorText,
}) {
  final parts = <String>[];
  if (helperText != null && helperText.trim().isNotEmpty) {
    parts.add(helperText.trim());
  }
  if (hintText != null && hintText.trim().isNotEmpty) {
    parts.add(hintText.trim());
  }
  if (errorText != null && errorText.trim().isNotEmpty) {
    parts.add('Error: ${errorText.trim()}');
  }
  if (parts.isEmpty) return null;
  return parts.join('. ');
}

/// Wraps a control with consistent accessibility semantics.
///
/// For native Flutter [TextField] / [TextFormField] descendants [isNativeInput]
/// should be true (the default). In that case this wrapper is intentionally
/// lightweight:
///
/// * No [MergeSemantics] — merging would pull the TextField's own focus/cursor
///   semantics up into a parent container node, which confuses the focus tree
///   and causes intermittent "first tap doesn't place the caret" bugs.
/// * No [container: true] — same reason; a container node between the gesture
///   detector and the field can swallow the first pointer event.
/// * No [textField: true] — the real TextField already declares itself as a
///   text field; redeclaring it in a parent Semantics creates a duplicate node.
///
/// The wrapper still announces validation errors as a live region so screen
/// readers read them out when they appear.
///
/// For non-native controls (custom toggles, dropdowns rendered with InkWell,
/// etc.) pass [isNativeInput: false] to get the full container+merge wrapper.
Widget appFieldSemantics({
  required Widget child,
  required String label,
  required bool enabled,
  bool isRequired = false,
  bool isNativeInput = true,
  bool textField = false,
  bool button = false,
  bool liveRegion = false,
  String? value,
  String? hintText,
  String? helperText,
  String? errorText,
}) {
  final hasError = errorText?.trim().isNotEmpty ?? false;
  final announceLiveRegion = liveRegion || hasError;

  // For real TextField/TextFormField descendants: return the child completely
  // unwrapped. Any Semantics node above a TextField — even one with no
  // container/label/role properties — registers in Flutter web's accessibility
  // tree and can interfere with Chrome's text-input focus routing, causing all
  // fields on the page to freeze. Flutter's own InputDecoration already
  // announces error text via the semantics it builds internally; a live-region
  // wrapper adds no meaningful benefit and causes real focus bugs.
  if (isNativeInput) return child;

  // Non-native controls (custom dropdowns, toggles, date pickers, etc.):
  // full container + merge wrapper as before.
  return MergeSemantics(
    child: Semantics(
      container: true,
      enabled: enabled,
      textField: textField,
      button: button,
      liveRegion: announceLiveRegion,
      label: appFieldSemanticsLabel(label, isRequired: isRequired),
      value: value,
      hint: appFieldSemanticsHint(
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
      ),
      child: child,
    ),
  );
}
