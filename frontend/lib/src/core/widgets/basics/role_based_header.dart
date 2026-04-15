// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/role_based_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart'
    show messagingUnreadCountProvider;

/// A configurable header widget for any role.
///
/// Eliminates duplication between ResearcherHeader, ParticipantHeader,
/// and HcpHeader by accepting nav items and home route as parameters.
///
/// Usage:
/// ```dart
/// RoleBasedHeader(
///   currentRoute: '/researcher/dashboard',
///   homeRoute: '/researcher/dashboard',
///   navItemsBuilder: (context, unreadMessages) => [
///     NavItem(label: 'Dashboard', route: '/researcher/dashboard'),
///     NavItem(label: 'Messages', route: '/messages', badge: unreadMessages),
///   ],
/// )
/// ```
class RoleBasedHeader extends ConsumerWidget implements PreferredSizeWidget {
  const RoleBasedHeader({
    super.key,
    required this.currentRoute,
    required this.homeRoute,
    required this.navItemsBuilder,
    this.onNotificationsTap,
    this.onProfileTap,
    this.onMenuTap,
    this.hasNotifications = false,
    this.userName,
  });

  /// Current active route (for highlighting the active nav item)
  final String currentRoute;

  /// Route to navigate to when logo is tapped (non-admin users)
  final String homeRoute;

  /// Builder that returns nav items given the build context and unread message count
  final List<NavItem> Function(BuildContext context, int unreadMessages) navItemsBuilder;

  /// Callback when notifications icon is tapped
  final VoidCallback? onNotificationsTap;

  /// Callback when profile icon is tapped
  final VoidCallback? onProfileTap;

  /// Callback when hamburger menu is tapped (mobile)
  final VoidCallback? onMenuTap;

  /// Whether there are unread notifications
  final bool hasNotifications;

  /// User name for profile dropdown
  final String? userName;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadMessages = ref.watch(messagingUnreadCountProvider);
    return Header(
      navItems: navItemsBuilder(context, unreadMessages),
      currentRoute: currentRoute,
      onNavItemTap: (route) => context.go(route),
      onNotificationsTap: onNotificationsTap,
      onProfileTap: onProfileTap,
      onMenuTap: onMenuTap,
      hasNotifications: hasNotifications,
      userName: userName,
      // onLogoTap left null — HeaderLogo handles admin view-as clearing
      // and role-based navigation internally
    );
  }
}
