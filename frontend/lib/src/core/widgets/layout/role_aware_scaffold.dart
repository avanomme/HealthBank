// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/layout/role_aware_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart';
import 'package:frontend/src/features/admin/widgets/admin_scaffold.dart';

/// A scaffold that automatically selects the correct role-specific chrome
/// (header, navigation, sidebar) based on the authenticated user's role.
///
/// Use this for shared pages (Profile, Settings, etc.) that should show
/// the user's role-appropriate navigation.
///
/// ```dart
/// RoleAwareScaffold(
///   currentRoute: '/profile',
///   child: ProfileContent(),
/// )
/// ```
class RoleAwareScaffold extends ConsumerWidget {
  const RoleAwareScaffold({
    super.key,
    required this.currentRoute,
    required this.child,
    this.scrollable = true,
    this.showFooter = true,
    this.alignment = AppPageAlignment.regular,
    this.bodyBehavior = AppPageBodyBehavior.padded,
    this.floatingActionButton,
  });

  final String currentRoute;
  final Widget child;
  final bool scrollable;
  final bool showFooter;
  final AppPageAlignment alignment;
  final AppPageBodyBehavior bodyBehavior;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the viewed-as role when impersonating, otherwise the admin's own role
    final role = ref.watch(currentUserRoleProvider) ??
        ref.watch(authProvider).user?.role;

    return switch (role) {
      'admin' => AdminScaffold(
          currentRoute: currentRoute,
          scrollable: scrollable,
          child: child,
        ),
      'researcher' => ResearcherScaffold(
          currentRoute: currentRoute,
          scrollable: scrollable,
          showFooter: showFooter,
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          floatingActionButton: floatingActionButton,
          child: child,
        ),
      'hcp' => HcpScaffold(
          currentRoute: currentRoute,
          scrollable: scrollable,
          showFooter: showFooter,
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          floatingActionButton: floatingActionButton,
          child: child,
        ),
      _ => ParticipantScaffold(
          currentRoute: currentRoute,
          scrollable: scrollable,
          showFooter: showFooter,
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          floatingActionButton: floatingActionButton,
          child: child,
        ),
    };
  }
}
