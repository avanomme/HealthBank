// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Controls whether the scaffold applies resolved shell padding directly.
enum AppPageBodyBehavior { padded, edgeToEdge }

/// [InheritedWidget] that exposes the resolved page alignment spec to descendants.
///
/// Widgets inside a scaffold can read [AppPageAlignmentScope.of] to access
/// the correct horizontal padding and max content width for their breakpoint.
class AppPageAlignmentScope extends InheritedWidget {
  const AppPageAlignmentScope({
    super.key,
    required this.alignment,
    required this.spec,
    required super.child,
  });

  final AppPageAlignment alignment;
  final AppPageAlignmentSpec spec;

  static AppPageAlignmentScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppPageAlignmentScope>();
  }

  static AppPageAlignmentScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No AppPageAlignmentScope found in context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppPageAlignmentScope oldWidget) {
    return alignment != oldWidget.alignment || spec != oldWidget.spec;
  }
}

/// Centers [child] within the max content width defined by the nearest [AppPageAlignmentScope].
///
/// Use on full-bleed pages that still need the shell's max-width constraint applied to their content.
class AppPageAlignedContent extends StatelessWidget {
  const AppPageAlignedContent({
    super.key,
    required this.child,
    this.alignment,
    this.maxWidth,
  });

  final Widget child;
  final AppPageAlignment? alignment;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final spec = context.resolvePageAlignment(alignment);
    final resolvedMaxWidth = maxWidth ?? spec.maxContentWidth;

    if (resolvedMaxWidth == double.infinity) {
      return child;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
        child: child,
      ),
    );
  }
}

extension AppPageAlignmentContext on BuildContext {
  AppPageAlignmentTheme get pageAlignmentTheme {
    final theme = Theme.of(this).extension<AppPageAlignmentTheme>();
    assert(
      theme != null,
      'AppPageAlignmentTheme is not attached to ThemeData.',
    );
    return theme!;
  }

  AppPageAlignmentSpec resolvePageAlignment([AppPageAlignment? alignment]) {
    if (alignment != null) {
      return pageAlignmentTheme.resolve(alignment);
    }

    final scoped = AppPageAlignmentScope.maybeOf(this);
    if (scoped != null) {
      return scoped.spec;
    }

    return pageAlignmentTheme.resolve(AppPageAlignment.regular);
  }
}

/// Adds a horizontal overflow escape hatch for dense page content.
///
/// On narrow screens, descendants can grow wider than the viewport instead of
/// clipping or triggering `RenderFlex overflowed` errors. The viewport keeps at
/// least its own width so normal pages do not collapse.
class AppOverflowSafeArea extends StatelessWidget {
  const AppOverflowSafeArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.maxWidth.isFinite) {
          return child;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
