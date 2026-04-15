// Created with the Assistance of Claude Code
// frontend/lib/features/admin/widgets/admin_sidebar.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Sidebar navigation item
class SidebarItem {
  final String label;
  final String route;
  final IconData? icon;
  final int? badgeCount;

  const SidebarItem({
    required this.label,
    required this.route,
    this.icon,
    this.badgeCount,
  });
}

/// Admin sidebar widget matching the Figma design
///
/// Features:
/// - "Logged in as: Username" header
/// - Navigation items with optional badge counts
///
/// Note: Logout is handled by the Header widget for consistency across all roles.
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.onItemTap,
    this.userName = 'Admin',
    this.width = 240,
  });

  /// Navigation items to display
  final List<SidebarItem> items;

  /// Current active route (for highlighting)
  final String currentRoute;

  /// Callback when a nav item is tapped
  final void Function(String route) onItemTap;

  /// Logged in user name
  final String userName;

  /// Sidebar width
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: AppTheme.chromeSidebarGradient,
        border: Border(
          top: BorderSide(color: AppTheme.chromeHighlight, width: 1),
          right: BorderSide(color: AppTheme.chromeBorder, width: 1),
        ),
        boxShadow: AppTheme.chromeSidebarShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          _buildHeader(context),

          // Divider
          Divider(color: context.appColors.divider, height: 1),

          // Navigation items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items
                    .map(
                      (item) => _SidebarItemWidget(
                        item: item,
                        isActive: currentRoute == item.route,
                        onTap: () => onItemTap(item.route),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logged in as
          Text(
            context.l10n.adminLoggedInAsLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
          ),
          Text(
            userName,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual sidebar item widget
class _SidebarItemWidget extends StatefulWidget {
  const _SidebarItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final SidebarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends State<_SidebarItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFlat = AppTheme.chromeStyle == ChromeStyle.flat;
    final usesMinimalActiveState = isFlat;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: usesMinimalActiveState
                ? null
                : widget.isActive
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary,
                          AppTheme.primaryHover,
                        ],
                      )
                    : AppTheme.chromeItemGradient(hovered: _isHovered),
            color: usesMinimalActiveState
                ? widget.isActive
                    ? AppTheme.primary.withValues(
                        alpha: isFlat
                            ? (isDark ? 0.14 : 0.07)
                            : (isDark ? 0.20 : 0.10),
                      )
                    : _isHovered
                        ? AppTheme.primary.withValues(
                            alpha: isDark ? 0.12 : 0.08,
                          )
                        : Colors.transparent
                : null,
            border: usesMinimalActiveState
                ? Border(
                    left: BorderSide(
                      color: widget.isActive
                          ? AppTheme.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  )
                : Border.all(
                    color: widget.isActive
                        ? AppTheme.primaryHover
                        : AppTheme.chromeBorder,
                  ),
            boxShadow: usesMinimalActiveState
                ? null
                : AppTheme.chromeItemShadows(
                    active: widget.isActive,
                    hovered: _isHovered,
                  ),
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 20,
                  color: widget.isActive
                      ? (usesMinimalActiveState
                          ? AppTheme.primary
                          : AppTheme.textContrast)
                      : context.appColors.textPrimary,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: widget.isActive
                        ? (usesMinimalActiveState
                            ? AppTheme.primary
                            : AppTheme.textContrast)
                        : (usesMinimalActiveState
                            ? context.appColors.textPrimary
                            : AppTheme.primary),
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (widget.item.badgeCount != null && widget.item.badgeCount! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? (usesMinimalActiveState
                            ? AppTheme.primary
                            : AppTheme.textContrast)
                        : AppTheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.item.badgeCount}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.isActive
                          ? (usesMinimalActiveState
                              ? AppTheme.textContrast
                              : AppTheme.primary)
                          : AppTheme.textContrast,
                      fontWeight: FontWeight.w500,
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
