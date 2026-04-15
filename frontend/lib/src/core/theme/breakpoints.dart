// Created with the Assistance of Claude Code
// frontend/lib/src/core/theme/breakpoints.dart

/// Breakpoint tiers for responsive typography and layout.
///
/// Aligned with Material Design 3 and 2025-2026 industry standards:
/// - compact: phones (portrait + landscape)
/// - medium: tablets, foldables, small laptops
/// - expanded: laptops, desktops, large monitors
enum Breakpoint { compact, medium, expanded }

/// Returns the appropriate breakpoint for the given width.
Breakpoint breakpointForWidth(double width) {
  if (width < Breakpoints.mobile) return Breakpoint.compact;
  if (width < Breakpoints.desktop) return Breakpoint.medium;
  return Breakpoint.expanded;
}

/// Consistent responsive breakpoints across the app.
///
/// Based on real device widths (2025-2026):
/// - iPhone 15 Pro Max: 430px portrait, 932px landscape
/// - iPad Air: 820px portrait, 1180px landscape
/// - iPad Pro 12.9": 1024px portrait, 1366px landscape
/// - MacBook Air 13": 1440px
/// - 1080p monitor: 1920px
///
/// Usage:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     final width = constraints.maxWidth;
///     if (Breakpoints.isMobile(width)) {
///       // single column, bottom nav
///     } else if (Breakpoints.isTablet(width)) {
///       // 2 columns, nav rail or top nav
///     } else {
///       // full desktop layout, sidebar + wide content
///     }
///   },
/// )
/// ```
class Breakpoints {
  Breakpoints._(); // Prevent instantiation

  // ─── Breakpoint thresholds ───────────────────────────────────────────

  /// Phones: < 600px
  /// Covers all phones in portrait (iPhone SE 375px → iPhone Pro Max 430px)
  /// and most phones in landscape (up to ~600px effective width).
  static const double mobile = 600;

  /// Tablets / small laptops: 600px – 1023px
  /// Covers tablets in portrait (iPad 820px, iPad Mini 768px),
  /// phones in landscape (932px), and foldables (585px+).
  static const double tablet = 1024;

  /// Desktops / laptops: ≥ 1024px
  /// Covers iPad landscape (1180px), laptops (1440px+), and monitors.
  /// This is where sidebars and multi-column layouts are comfortable.
  static const double desktop = 1024;

  /// Large desktops: ≥ 1440px
  /// Standard laptop viewport (MacBook Air). Use for extra-wide layouts
  /// like 3-column dashboards or expanded sidebars.
  static const double largeDesktop = 1440;

  /// Maximum content width for ultra-wide screens.
  /// Prevents lines of text from becoming unreadable on 4K/ultrawide monitors.
  static const double maxContent = 1600;

  // ─── Boolean helpers ─────────────────────────────────────────────────

  /// Phones (< 600px)
  static bool isMobile(double width) => width < mobile;

  /// Tablets and small laptops (600px – 1023px)
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// Desktops and laptops (≥ 1024px)
  static bool isDesktop(double width) => width >= desktop;

  /// Large desktops (≥ 1440px)
  static bool isLargeDesktop(double width) => width >= largeDesktop;

  // ─── Responsive values ───────────────────────────────────────────────

  /// Responsive padding: 16px mobile, 20px tablet, 24px desktop, 32px large
  static double responsivePadding(double width) {
    if (isMobile(width)) return 16;
    if (isTablet(width)) return 20;
    if (isLargeDesktop(width)) return 32;
    return 24;
  }

  /// Responsive horizontal margin: 16px mobile, 24px tablet, 32px desktop, 40px large
  static double responsiveHorizontalMargin(double width) {
    if (isMobile(width)) return 16;
    if (isTablet(width)) return 24;
    if (isLargeDesktop(width)) return 40;
    return 32;
  }
}
