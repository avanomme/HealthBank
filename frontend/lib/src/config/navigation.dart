// Created with the Assistance of Claude Code
// frontend/lib/src/config/navigation.dart
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/config/go_router.dart';

/// User roles in the system
enum UserRole {
  participant,
  researcher,
  hcp,
  admin,
}

/// Navigation configuration for each role
///
/// Provides consistent navigation items based on user role.
/// Admin uses a different layout (AdminScaffold with sidebar),
/// so this is primarily for participant, researcher, and hcp roles.
class NavigationConfig {
  /// Get navigation items for a specific role
  static List<NavItem> getNavItems(UserRole role) {
    switch (role) {
      case UserRole.participant:
        return _participantNavItems;
      case UserRole.researcher:
        return _researcherNavItems;
      case UserRole.hcp:
        return _hcpNavItems;
      case UserRole.admin:
        // Admin uses sidebar navigation, not header nav
        return [];
    }
  }

  /// Parse role string from API to UserRole enum
  static UserRole? parseRole(String? roleString) {
    if (roleString == null) return null;
    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'researcher':
        return UserRole.researcher;
      case 'hcp':
      case 'healthcare professional':
        return UserRole.hcp;
      case 'participant':
      default:
        return UserRole.participant;
    }
  }

  /// Get the dashboard route for a role
  static String getDashboardRoute(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppRoutes.admin;
      case UserRole.researcher:
        return AppRoutes.surveys;
      case UserRole.hcp:
        return '/hcp/dashboard';
      case UserRole.participant:
        return AppRoutes.participantDashboard;
    }
  }

  // ============================================
  // Role-specific navigation items
  // ============================================

  static const List<NavItem> _participantNavItems = [
    NavItem(label: 'Dashboard', route: '/participant/dashboard'),
    NavItem(label: 'My Surveys', route: '/participant/surveys'),
    NavItem(label: 'Results', route: '/participant/results'),
  ];

  static const List<NavItem> _researcherNavItems = [
    NavItem(label: 'Dashboard', route: '/researcher/dashboard'),
    NavItem(label: 'Surveys', route: '/surveys'),
    NavItem(label: 'Templates', route: '/templates'),
    NavItem(label: 'Question Bank', route: '/questions'),
  ];

  static const List<NavItem> _hcpNavItems = [
    NavItem(label: 'Dashboard', route: '/hcp/dashboard'),
    NavItem(label: 'Clients', route: '/hcp/clients'),
    NavItem(label: 'Reports', route: '/hcp/reports'),
  ];
}
