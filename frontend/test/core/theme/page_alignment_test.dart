// Created with the Assistance of Codex
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';

void main() {
  group('AppPageAlignmentTheme', () {
    test('resolves all semantic categories for compact breakpoint', () {
      final theme = AppPageAlignmentTheme.forBreakpoint(Breakpoint.compact);

      expect(
        theme.resolve(AppPageAlignment.regular).maxContentWidth,
        Breakpoints.maxContent,
      );
      expect(theme.resolve(AppPageAlignment.compact).horizontalPadding, 12);
      expect(theme.resolve(AppPageAlignment.wide).maxContentWidth, 880);
      expect(
        theme.resolve(AppPageAlignment.sidebarRegular).maxContentWidth,
        double.infinity,
      );
      expect(
        theme.resolve(AppPageAlignment.sidebarCompact).horizontalPadding,
        12,
      );
    });

    test('resolves wide and sidebar metrics for expanded breakpoint', () {
      final theme = AppPageAlignmentTheme.forBreakpoint(Breakpoint.expanded);

      expect(theme.resolve(AppPageAlignment.regular).horizontalPadding, 24);
      expect(
        theme.resolve(AppPageAlignment.compact).maxContentWidth,
        double.infinity,
      );
      expect(theme.resolve(AppPageAlignment.wide).maxContentWidth, 960);
      expect(
        theme.resolve(AppPageAlignment.sidebarRegular).horizontalPadding,
        24,
      );
      expect(
        theme.resolve(AppPageAlignment.sidebarCompact).horizontalPadding,
        20,
      );
    });
  });
}
