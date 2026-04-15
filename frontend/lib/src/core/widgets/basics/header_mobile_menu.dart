// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/header_mobile_menu.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'header.dart' show NavItem;

/// Shows a slide-down mobile navigation menu.
///
/// Call [showHeaderMobileMenu] to display it as a dialog overlay.
void showHeaderMobileMenu(
  BuildContext context, {
  required List<NavItem> navItems,
  String? currentRoute,
  void Function(String route)? onNavItemTap,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close menu',
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, animation, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, animation, _, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      return SlideTransition(
        position: slide,
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            child: SafeArea(
              bottom: false,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.chromeSurfaceGradient,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.chromeBorder, width: 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header bar with close button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menu',
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: ctx.appColors.textPrimary),
                            tooltip: ctx.l10n.tooltipCloseModal,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Navigation items
                    ...navItems.map((item) {
                      final isActive = currentRoute == item.route;
                      return ListTile(
                        leading: item.icon != null
                            ? Icon(item.icon,
                                color: isActive
                                    ? AppTheme.primary
                                    : ctx.appColors.textPrimary)
                            : null,
                        title: Text(
                          item.label,
                          style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                            color: isActive
                                ? AppTheme.primary
                                : ctx.appColors.textPrimary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selected: isActive,
                        selectedTileColor: AppTheme.primary.withValues(alpha: 0.1),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          onNavItemTap?.call(item.route);
                        },
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
