// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/widgets/researcher_header.dart
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/basics/role_based_header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Researcher-specific header with pre-configured navigation items.
class ResearcherHeader extends RoleBasedHeader {
  ResearcherHeader({
    super.key,
    required super.currentRoute,
    super.onNotificationsTap,
    super.onProfileTap,
    super.onMenuTap,
    super.hasNotifications,
    super.userName,
  }) : super(
          homeRoute: '/researcher/dashboard',
          navItemsBuilder: (context, unreadMessages) => [
            NavItem(label: context.l10n.navDashboard, route: '/researcher/dashboard'),
            NavItem(label: context.l10n.navSurveys, route: '/surveys'),
            NavItem(label: context.l10n.navTemplates, route: '/templates'),
            NavItem(label: context.l10n.navQuestionBank, route: '/questions'),
            NavItem(label: context.l10n.navData, route: '/researcher/data'),
            NavItem(label: context.l10n.navMessages, route: '/messages', badge: unreadMessages),
          ],
        );
}
