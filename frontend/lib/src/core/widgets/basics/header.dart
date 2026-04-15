// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/header.dart
//
// Thin shell that composes: logo, nav, actions, and mobile menu.
// Each piece is in its own file for independent testing and reuse.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';

import 'package:frontend/src/core/l10n/l10n.dart';
import 'header_logo.dart';
import 'header_nav.dart';
import 'header_actions.dart';
import 'header_mobile_menu.dart';

export 'header_logo.dart';
export 'header_nav.dart';
export 'header_actions.dart';
export 'header_mobile_menu.dart';

/// Navigation item for the app header.
class NavItem {
  final String label;
  final String route;
  final IconData? icon;
  final int badge;

  const NavItem({
    required this.label,
    required this.route,
    this.icon,
    this.badge = 0,
  });
}

/// App Header — composes logo, nav items, and action buttons.
///
/// On wide screens, nav items display inline at their natural size.
/// On narrow screens, they collapse into a hamburger menu.
/// The breakpoint is calculated from the actual estimated width of
/// all nav items so there is never an overflow.
class Header extends ConsumerWidget implements PreferredSizeWidget {
  const Header({
    super.key,
    required this.navItems,
    this.currentRoute,
    this.onNavItemTap,
    this.onNotificationsTap,
    this.onProfileTap,
    this.onMenuTap,
    this.onLogoTap,
    this.hasNotifications = false,
    this.userName,
    this.mergeWithBottomChrome = false,
    this.useChromeDecoration = true,
  });

  final List<NavItem> navItems;
  final String? currentRoute;
  final void Function(String route)? onNavItemTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final bool hasNotifications;
  final String? userName;
  final bool mergeWithBottomChrome;
  final bool useChromeDecoration;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final isAuthed = auth.isAuthenticated;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = Breakpoints.responsivePadding(width);
        final isCompact = Breakpoints.isMobile(width);
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final canCollapseToMenu = navItems.isNotEmpty || onMenuTap != null;

        // Fixed estimates for breakpoint calculation — stable across font environments.
        final logoWidth = 150.0 + (isCompact ? 20.0 : 48.0);
        final actionsWidth = isCompact ? 140.0 : 172.0;

        // Measure actual nav item widths using TextPainter for pixel-perfect breakpoint.
        // Logo ~150px + padding, actions ~170px, hamburger 40px if shown.
        final navWidth = HeaderNav.measureWidth(context, navItems);
        final minimumExpandedWidth =
            horizontalPadding * 2 +
            logoWidth +
            navWidth +
            actionsWidth +
            32.0; // gap + safety buffer

        final showCompactHeader =
            isCompact || textScale > 1.15 || width < minimumExpandedWidth;

        final content = SizedBox(
          height: 64,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                // Left side: hamburger (compact) + logo + nav
                Expanded(
                  child: Row(
                    children: [
                      // Hamburger menu button (compact mode)
                      if (showCompactHeader && canCollapseToMenu)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.menu,
                              color: AppTheme.primary,
                            ),
                            onPressed: () {
                              if (onMenuTap != null) {
                                onMenuTap!();
                              } else {
                                showHeaderMobileMenu(
                                  context,
                                  navItems: navItems,
                                  currentRoute: currentRoute,
                                  onNavItemTap: onNavItemTap,
                                );
                              }
                            },
                            tooltip: context.l10n.headerMenu,
                          ),
                        ),

                      // Logo
                      HeaderLogo(
                        onTap: onLogoTap,
                        isCompact: showCompactHeader,
                      ),

                      // Inline nav items (desktop only)
                      if (!showCompactHeader)
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: HeaderNav(
                              navItems: navItems,
                              currentRoute: currentRoute,
                              onNavItemTap: onNavItemTap,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: showCompactHeader ? 8 : 16),

                // Right side: actions (always visible, right-justified)
                if (isAuthed)
                  HeaderAuthActions(
                    onNotificationsTap: onNotificationsTap,
                    hasNotifications: hasNotifications,
                    isCompact: showCompactHeader,
                  )
                else
                  HeaderPublicActions(isCompact: showCompactHeader),
              ],
            ),
          ),
        );

        if (!useChromeDecoration) {
          return content;
        }

        return Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: AppTheme.chromeSurfaceGradient,
            border: Border(
              top: BorderSide(color: AppTheme.chromeHighlight, width: 1),
              bottom: mergeWithBottomChrome
                  ? BorderSide.none
                  : BorderSide(color: AppTheme.chromeBorder, width: 1),
            ),
            boxShadow: !mergeWithBottomChrome
                ? AppTheme.chromeHeaderShadow
                : null,
          ),
          child: content,
        );
      },
    );
  }
}
