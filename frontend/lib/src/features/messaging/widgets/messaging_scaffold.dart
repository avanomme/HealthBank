// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/widgets/messaging_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show authProvider;
import 'package:frontend/src/features/auth/state/impersonation_provider.dart'
    show currentUserRoleProvider;

/// Role-aware scaffold for messaging pages.
///
/// Messaging is accessible by all authenticated roles. This scaffold
/// renders the correct role-specific header (and navigation) based on
/// the current session's role so that HCP, researcher and participant
/// users all see their own navigation when reading messages.
class MessagingScaffold extends ConsumerWidget {
  const MessagingScaffold({
    super.key,
    required this.child,
    this.alignment = AppPageAlignment.regular,
    this.bodyBehavior = AppPageBodyBehavior.padded,
    this.scrollable = true,
    this.showFooter = false,
    this.padding,
    this.userName,
    this.maxWidth,
  });

  final Widget child;
  final AppPageAlignment alignment;
  final AppPageBodyBehavior bodyBehavior;
  final bool scrollable;
  final bool showFooter;
  final EdgeInsets? padding;
  final String? userName;
  final double? maxWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Use the unified currentUserRoleProvider which handles both
    // role preview and full impersonation modes, then fall back
    // to the authenticated user's own role.
    final role =
        ref.watch(currentUserRoleProvider)?.toLowerCase() ??
        authState.user?.role?.toLowerCase();

    switch (role) {
      case 'hcp':
        return HcpScaffold(
          currentRoute: '/messages',
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          scrollable: scrollable,
          showFooter: showFooter,
          padding: padding,
          userName: userName,
          maxWidth: maxWidth,
          child: child,
        );

      case 'researcher':
        return ResearcherScaffold(
          currentRoute: '/messages',
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          scrollable: scrollable,
          showFooter: showFooter,
          padding: padding,
          userName: userName,
          maxWidth: maxWidth,
          child: child,
        );

      case 'participant':
        return ParticipantScaffold(
          currentRoute: '/messages',
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          scrollable: scrollable,
          showFooter: showFooter,
          padding: padding,
          userName: userName,
          maxWidth: maxWidth,
          child: child,
        );

      case 'admin':
        // Admin has no dedicated messaging scaffold.
        // If an admin somehow reaches this page without "view as",
        // fall back to participant shell instead of hanging forever.
        return ParticipantScaffold(
          currentRoute: '/messages',
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          scrollable: scrollable,
          showFooter: showFooter,
          padding: padding,
          userName: userName,
          maxWidth: maxWidth,
          child: child,
        );

      default:
        // Unknown role: render a usable shell instead of an infinite loader.
        return ParticipantScaffold(
          currentRoute: '/messages',
          alignment: alignment,
          bodyBehavior: bodyBehavior,
          scrollable: scrollable,
          showFooter: showFooter,
          padding: padding,
          userName: userName,
          maxWidth: maxWidth,
          child: child,
        );
    }
  }
}
