// Created with the Assistance of ChatGPT

/// AppBreadcrumbs
///
/// Description:
/// - A theme-aware breadcrumb trail for representing navigation hierarchy.
/// - `AppBreadcrumbs` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme typography and colors.
/// - Responsive: wraps items based on global breakpoints.
/// - Supports tappable and active breadcrumb items.
///
/// Usage Example:
/// ```dart
/// AppBreadcrumbs(
///   items: [
///     AppBreadcrumbItem(label: 'Home', onTap: () {}),
///     AppBreadcrumbItem(label: 'Settings', isActive: true),
///   ],
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppBreadcrumbItem {
  const AppBreadcrumbItem({
    required this.label,
    this.onTap,
    this.isActive,
  });

  /// Display text for the breadcrumb.
  final String label;

  /// Optional callback when the breadcrumb is tapped.
  final VoidCallback? onTap;

  /// Whether this item is the active (current) page.
  /// If null, the last item in the list is treated as active.
  final bool? isActive;
}

class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({
    super.key,
    required this.items,
    this.separator = '/',
    this.activeColor,
    this.inactiveColor,
  });

  /// Breadcrumb items in hierarchical order.
  final List<AppBreadcrumbItem> items;

  /// Separator displayed between breadcrumb items.
  final String separator;

  /// Optional color override for the active item.
  final Color? activeColor;

  /// Optional color override for inactive items.
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);
    final baseStyle = textTheme.bodySmall ?? AppTheme.captions;

    final spacing = Breakpoints.responsivePadding(width) * 0.25;
    final resolvedActive = activeColor ?? context.appColors.textPrimary;
    final resolvedInactive = inactiveColor ?? context.appColors.textMuted;

    final resolvedItems = _resolveItems(items);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < resolvedItems.length; index++) ...[
          _BreadcrumbLabel(
            item: resolvedItems[index],
            style: baseStyle,
            activeColor: resolvedActive,
            inactiveColor: resolvedInactive,
          ),
          if (index < resolvedItems.length - 1)
            Text(
              separator,
              style: baseStyle.copyWith(color: resolvedInactive),
            ),
        ],
      ],
    );
  }

  List<AppBreadcrumbItem> _resolveItems(List<AppBreadcrumbItem> items) {
    final lastIndex = items.length - 1;
    return items
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isActive = item.isActive ?? (index == lastIndex);
          return AppBreadcrumbItem(
            label: item.label,
            onTap: item.onTap,
            isActive: isActive,
          );
        })
        .toList(growable: false);
  }
}

class _BreadcrumbLabel extends StatelessWidget {
  const _BreadcrumbLabel({
    required this.item,
    required this.style,
    required this.activeColor,
    required this.inactiveColor,
  });

  final AppBreadcrumbItem item;
  final TextStyle style;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final isActive = item.isActive ?? false;
    final resolvedStyle = style.copyWith(
      color: isActive ? activeColor : inactiveColor,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
    );

    final label = Text(item.label, style: resolvedStyle);
    if (item.onTap == null || isActive) {
      return label;
    }

    return InkWell(
      onTap: item.onTap,
      child: label,
    );
  }
}
