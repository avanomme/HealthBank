// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/participant_header.dart
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/basics/role_based_header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Participant-specific header with pre-configured navigation items.
class ParticipantHeader extends RoleBasedHeader {
  ParticipantHeader({
    super.key,
    required super.currentRoute,
    super.onNotificationsTap,
    super.onProfileTap,
    super.hasNotifications,
    super.userName,
  }) : super(
          homeRoute: '/participant/dashboard',
          navItemsBuilder: (context, unreadMessages) => [
            NavItem(label: context.l10n.navDashboard, route: '/participant/dashboard'),
            NavItem(label: context.l10n.navTasks, route: '/participant/tasks'),
            NavItem(label: context.l10n.navSurveys, route: '/participant/surveys'),
            NavItem(label: context.l10n.navResults, route: '/participant/results'),
            NavItem(label: context.l10n.navHealthTracking, route: '/participant/health-tracking'),
            NavItem(label: context.l10n.navMessages, route: '/messages', badge: unreadMessages),
          ],
        );
}
