// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/header_nav.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'header.dart' show NavItem;

/// Desktop navigation items row.
///
/// Renders nav items at their natural size in a `Row`.
/// The parent is responsible for deciding whether to show this or the
/// hamburger menu based on available width.
class HeaderNav extends StatelessWidget {
  const HeaderNav({
    super.key,
    required this.navItems,
    this.currentRoute,
    this.onNavItemTap,
  });

  final List<NavItem> navItems;
  final String? currentRoute;
  final void Function(String route)? onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navItems.map((item) {
        final isActive = currentRoute == item.route;
        return HeaderNavItem(
          item: item,
          isActive: isActive,
          onTap: () => onNavItemTap?.call(item.route),
        );
      }).toList(),
    );
  }

  /// Measures the actual pixel width the nav items need using [TextPainter].
  ///
  /// This uses the real font metrics rather than a per-character estimate,
  /// so the breakpoint is always accurate — no overflow possible.
  /// [context] is needed to resolve the text theme.
  static double measureWidth(BuildContext context, List<NavItem> items) {
    final style = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    // Use the heavier weight (w500) since active items are bolder and wider
    final activeStyle = style.copyWith(fontWeight: FontWeight.w500);
    const horizontalPadding = 10.0 * 2; // padding per item

    double total = 0;
    for (final item in items) {
      final tp = TextPainter(
        text: TextSpan(text: item.label, style: activeStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      total += tp.width + horizontalPadding;
      tp.dispose();
    }
    // 10% safety margin — test fonts (Ahem) render wider than production fonts
    return total * 1.1;
  }

  /// Fallback estimate when no [BuildContext] is available (e.g. in tests).
  /// Intentionally generous to prevent overflow.
  static double estimateWidth(List<NavItem> items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + (item.label.length * 10.0) + 40,
    );
  }
}

/// Individual navigation item widget.
class HeaderNavItem extends StatelessWidget {
  const HeaderNavItem({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        constraints: const BoxConstraints(minWidth: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                item.label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isActive
                      ? AppTheme.textContrast
                      : context.appColors.textPrimary,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              if (item.badge > 0)
                Positioned(
                  right: -8,
                  top: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.caution,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
