// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/app_tappable.dart

/// AppTappable
///
/// A theme-aware tappable surface. Use this everywhere an arbitrary widget
/// needs an `onTap` handler but doesn't warrant a full [AppFilledButton]
/// or [AppCard].
///
/// ## Theme integration
/// Splash and highlight colours are read from [Theme.of(context)] so they
/// automatically reflect light/dark mode and any future theme changes.
/// Hover colour uses a semi-transparent tint of [AppTheme.primary].
/// Mouse cursor defaults to [SystemMouseCursors.click] when [onTap] is set.
///
/// ## Accessibility (WCAG 2.1 AA)
/// Supply [semanticLabel] so screen readers announce a meaningful description.
/// `semanticLabel` must always be a **localised** string — pass
/// `context.l10n.someKey`, never a hardcoded English string.
///
/// ## ⚠ Do NOT use as a parent of TextField / TextFormField
/// Any [Semantics] node above a native text field on Flutter Web can
/// interfere with Chrome's focus routing and cause all text fields on the page
/// to freeze (see `appFieldSemantics` in form_field_shared.dart).
///
/// ## Import
/// Always import via the barrel:
/// ```dart
/// import 'package:frontend/src/core/widgets/basics/basics.dart';
/// ```
///
/// ## Usage
/// ```dart
/// // Simple tap
/// AppTappable(
///   onTap: () => context.go('/home'),
///   child: Text('Go home'),
/// )
///
/// // Rounded option card with semantic label
/// AppTappable(
///   onTap: onSelect,
///   borderRadius: BorderRadius.circular(8),
///   semanticLabel: context.l10n.surveyOptionLabel(option.text),
///   child: Container(decoration: BoxDecoration(...), child: ...),
/// )
///
/// // Logo / image tap
/// AppTappable(
///   onTap: handler,
///   semanticLabel: context.l10n.semanticLogoNavigate,
///   child: logo,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppTappable extends StatelessWidget {
  const AppTappable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.semanticLabel,
    this.mouseCursor,
  });

  /// The widget to make tappable.
  final Widget child;

  /// Called when the user taps. Pass `null` to disable tapping.
  final VoidCallback? onTap;

  /// Border radius for clipping the ink ripple — match this to the child's
  /// own [BorderRadius] so the ripple doesn't bleed outside rounded corners.
  final BorderRadius? borderRadius;

  /// Accessible label announced by screen readers.
  /// **Must be a localised string** — use `context.l10n.someKey`.
  /// When provided, wraps the [InkWell] in a [Semantics] node with
  /// `button: true`. Omit when the child's own text is sufficient.
  final String? semanticLabel;

  /// Mouse cursor shown on hover. Defaults to [SystemMouseCursors.click] when
  /// [onTap] is set, [MouseCursor.defer] when disabled.
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget result = InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      // Use theme splash/highlight so light↔dark changes apply automatically.
      splashColor: theme.splashColor,
      highlightColor: theme.highlightColor,
      // Subtle primary tint on hover for web/desktop (theme-aware).
      hoverColor: AppTheme.primary.withValues(alpha: 0.06),
      mouseCursor: mouseCursor ??
          (onTap != null ? SystemMouseCursors.click : MouseCursor.defer),
      child: child,
    );

    // Only add a Semantics wrapper when the caller explicitly supplies a label.
    // An unwrapped InkWell already announces as a button node in the a11y tree;
    // the wrapper is only needed to give it a meaningful spoken description.
    if (semanticLabel != null) {
      result = Semantics(
        label: semanticLabel,
        button: true,
        enabled: onTap != null,
        child: result,
      );
    }

    return result;
  }
}
