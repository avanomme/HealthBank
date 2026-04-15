// Created with the Assistance of Claude Code
// frontend/lib/src/features/hcp_clients/widgets/hcp_header.dart
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/basics/role_based_header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// HCP-specific header with pre-configured navigation items.
class HcpHeader extends RoleBasedHeader {
  HcpHeader({
    super.key,
    required super.currentRoute,
    super.onNotificationsTap,
    super.onProfileTap,
    super.hasNotifications,
    super.userName,
  }) : super(
          homeRoute: '/hcp/dashboard',
          navItemsBuilder: (context, unreadMessages) => [
            NavItem(label: context.l10n.navDashboard, route: '/hcp/dashboard'),
            NavItem(label: context.l10n.navClients, route: '/hcp/clients'),
            NavItem(label: context.l10n.navReports, route: '/hcp/reports'),
            NavItem(label: context.l10n.navMessages, route: '/messages', badge: unreadMessages),
          ],
        );
}
