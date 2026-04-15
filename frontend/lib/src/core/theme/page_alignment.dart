// Created with the Assistance of Codex
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/breakpoints.dart';

/// Semantic page-shell alignment categories used by scaffolds and page shells.
enum AppPageAlignment { regular, compact, wide, sidebarRegular, sidebarCompact }

/// Resolved shell metrics for a single breakpoint and alignment category.
@immutable
class AppPageAlignmentSpec {
  const AppPageAlignmentSpec({
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.maxContentWidth,
  });

  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double maxContentWidth;

  EdgeInsets get bodyPadding => EdgeInsets.fromLTRB(
    horizontalPadding,
    topPadding,
    horizontalPadding,
    bottomPadding,
  );

  AppPageAlignmentSpec copyWith({
    double? horizontalPadding,
    double? topPadding,
    double? bottomPadding,
    double? maxContentWidth,
  }) {
    return AppPageAlignmentSpec(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      topPadding: topPadding ?? this.topPadding,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    );
  }

  static AppPageAlignmentSpec lerp(
    AppPageAlignmentSpec a,
    AppPageAlignmentSpec b,
    double t,
  ) {
    return AppPageAlignmentSpec(
      horizontalPadding:
          lerpDouble(a.horizontalPadding, b.horizontalPadding, t) ??
          b.horizontalPadding,
      topPadding: lerpDouble(a.topPadding, b.topPadding, t) ?? b.topPadding,
      bottomPadding:
          lerpDouble(a.bottomPadding, b.bottomPadding, t) ?? b.bottomPadding,
      maxContentWidth:
          lerpDouble(a.maxContentWidth, b.maxContentWidth, t) ??
          b.maxContentWidth,
    );
  }
}

/// Theme extension that resolves semantic alignment categories into shell specs.
@immutable
class AppPageAlignmentTheme extends ThemeExtension<AppPageAlignmentTheme> {
  const AppPageAlignmentTheme({
    required this.regular,
    required this.compact,
    required this.wide,
    required this.sidebarRegular,
    required this.sidebarCompact,
  });

  factory AppPageAlignmentTheme.forBreakpoint(Breakpoint breakpoint) {
    switch (breakpoint) {
      case Breakpoint.compact:
        return const AppPageAlignmentTheme(
          regular: AppPageAlignmentSpec(
            horizontalPadding: 16,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: Breakpoints.maxContent,
          ),
          compact: AppPageAlignmentSpec(
            horizontalPadding: 12,
            topPadding: 16,
            bottomPadding: 20,
            maxContentWidth: double.infinity,
          ),
          wide: AppPageAlignmentSpec(
            horizontalPadding: 16,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: 880,
          ),
          sidebarRegular: AppPageAlignmentSpec(
            horizontalPadding: 16,
            topPadding: 16,
            bottomPadding: 20,
            maxContentWidth: double.infinity,
          ),
          sidebarCompact: AppPageAlignmentSpec(
            horizontalPadding: 12,
            topPadding: 16,
            bottomPadding: 20,
            maxContentWidth: double.infinity,
          ),
        );
      case Breakpoint.medium:
        return const AppPageAlignmentTheme(
          regular: AppPageAlignmentSpec(
            horizontalPadding: 20,
            topPadding: 24,
            bottomPadding: 28,
            maxContentWidth: Breakpoints.maxContent,
          ),
          compact: AppPageAlignmentSpec(
            horizontalPadding: 16,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
          wide: AppPageAlignmentSpec(
            horizontalPadding: 20,
            topPadding: 24,
            bottomPadding: 28,
            maxContentWidth: 920,
          ),
          sidebarRegular: AppPageAlignmentSpec(
            horizontalPadding: 20,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
          sidebarCompact: AppPageAlignmentSpec(
            horizontalPadding: 16,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
        );
      case Breakpoint.expanded:
        return const AppPageAlignmentTheme(
          regular: AppPageAlignmentSpec(
            horizontalPadding: 24,
            topPadding: 24,
            bottomPadding: 32,
            maxContentWidth: Breakpoints.maxContent,
          ),
          compact: AppPageAlignmentSpec(
            horizontalPadding: 20,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
          wide: AppPageAlignmentSpec(
            horizontalPadding: 32,
            topPadding: 24,
            bottomPadding: 32,
            maxContentWidth: 960,
          ),
          sidebarRegular: AppPageAlignmentSpec(
            horizontalPadding: 24,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
          sidebarCompact: AppPageAlignmentSpec(
            horizontalPadding: 20,
            topPadding: 20,
            bottomPadding: 24,
            maxContentWidth: double.infinity,
          ),
        );
    }
  }

  final AppPageAlignmentSpec regular;
  final AppPageAlignmentSpec compact;
  final AppPageAlignmentSpec wide;
  final AppPageAlignmentSpec sidebarRegular;
  final AppPageAlignmentSpec sidebarCompact;

  AppPageAlignmentSpec resolve(AppPageAlignment alignment) {
    return switch (alignment) {
      AppPageAlignment.regular => regular,
      AppPageAlignment.compact => compact,
      AppPageAlignment.wide => wide,
      AppPageAlignment.sidebarRegular => sidebarRegular,
      AppPageAlignment.sidebarCompact => sidebarCompact,
    };
  }

  @override
  AppPageAlignmentTheme copyWith({
    AppPageAlignmentSpec? regular,
    AppPageAlignmentSpec? compact,
    AppPageAlignmentSpec? wide,
    AppPageAlignmentSpec? sidebarRegular,
    AppPageAlignmentSpec? sidebarCompact,
  }) {
    return AppPageAlignmentTheme(
      regular: regular ?? this.regular,
      compact: compact ?? this.compact,
      wide: wide ?? this.wide,
      sidebarRegular: sidebarRegular ?? this.sidebarRegular,
      sidebarCompact: sidebarCompact ?? this.sidebarCompact,
    );
  }

  @override
  AppPageAlignmentTheme lerp(
    covariant ThemeExtension<AppPageAlignmentTheme>? other,
    double t,
  ) {
    if (other is! AppPageAlignmentTheme) {
      return this;
    }

    return AppPageAlignmentTheme(
      regular: AppPageAlignmentSpec.lerp(regular, other.regular, t),
      compact: AppPageAlignmentSpec.lerp(compact, other.compact, t),
      wide: AppPageAlignmentSpec.lerp(wide, other.wide, t),
      sidebarRegular: AppPageAlignmentSpec.lerp(
        sidebarRegular,
        other.sidebarRegular,
        t,
      ),
      sidebarCompact: AppPageAlignmentSpec.lerp(
        sidebarCompact,
        other.sidebarCompact,
        t,
      ),
    );
  }
}
