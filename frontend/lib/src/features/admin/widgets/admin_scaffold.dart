// Created with the Assistance of Claude Code
// frontend/lib/features/admin/widgets/admin_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';
import 'admin_sidebar.dart';

/// Admin scaffold widget providing the admin page layout
///
/// Features:
/// - Header at top with account dropdown (consistent with other roles)
/// - "View As" toolbar below the header for role navigation
/// - Collapsible sidebar navigation on the left (hamburger menu always visible)
/// - Main content area on the right
/// - Language selector at bottom right
///
/// Usage:
/// ```dart
/// AdminScaffold(
///   currentRoute: '/admin/users',
///   child: UserManagementContent(),
/// )
/// ```
class AdminScaffold extends ConsumerStatefulWidget {
  const AdminScaffold({
    super.key,
    required this.currentRoute,
    required this.child,
    this.userName = 'Admin',
    this.messageCount = 0,
    this.hasNotifications = false,
    this.onNotificationsTap,
    this.onProfileTap,
    this.scrollable = true,
    this.alignment = AppPageAlignment.sidebarCompact,
  });

  /// Current active route (for sidebar highlighting)
  final String currentRoute;

  /// Main content widget
  final Widget child;

  /// Logged in user name
  final String userName;

  /// Unread message count
  final int messageCount;

  /// Whether there are unread notifications
  final bool hasNotifications;

  /// Callback when notifications icon is tapped
  final VoidCallback? onNotificationsTap;

  /// Callback when profile icon is tapped
  final VoidCallback? onProfileTap;

  /// Whether the content should be wrapped in a SingleChildScrollView.
  /// Set to false for pages with data tables that manage their own scrolling.
  final bool scrollable;

  /// Semantic alignment category for the sidebar page shell.
  final AppPageAlignment alignment;

  @override
  ConsumerState<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends ConsumerState<AdminScaffold> {
  bool _sidebarVisible = true;
  bool? _wasMobile;
  final _mainContentFocusNode = FocusNode();

  @override
  void dispose() {
    _mainContentFocusNode.dispose();
    super.dispose();
  }

  /// Resolve display name from auth state, falling back to widget prop
  String get _resolvedUserName {
    final user = ref.read(authProvider).user;
    if (user != null) {
      final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
      if (fullName.isNotEmpty) return fullName;
      if (user.email != null && user.email!.isNotEmpty) return user.email!;
    }
    return widget.userName;
  }

  List<SidebarItem> _sidebarItems(
    BuildContext context,
    int accountRequestCount,
    int deletionRequestCount,
  ) {
    final totalPending = accountRequestCount + deletionRequestCount;
    return [
      SidebarItem(label: context.l10n.navUserManagement, route: '/admin/users'),
      SidebarItem(label: context.l10n.navDatabase, route: '/admin/database'),
      SidebarItem(
        label: context.l10n.navAccountRequests,
        route: '/admin/messages',
        badgeCount: totalPending > 0 ? totalPending : null,
      ),
      SidebarItem(label: context.l10n.navAuditLog, route: '/admin/logs'),
      SidebarItem(label: context.l10n.navSettings, route: '/admin/settings'),
      SidebarItem(
        label: context.l10n.navHealthTracking,
        route: '/admin/health-tracking',
      ),
      SidebarItem(label: context.l10n.navUiTest, route: '/admin/ui-test'),
      SidebarItem(
        label: context.l10n.navPageNavigator,
        route: '/admin/nav-hub',
      ),
    ];
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingAccountRequests = ref
        .watch(accountRequestCountProvider)
        .when(data: (count) => count, loading: () => 0, error: (_, __) => 0);

    final pendingDeletionRequests = ref
        .watch(deletionRequestCountProvider)
        .when(data: (count) => count, loading: () => 0, error: (_, __) => 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Breakpoints.isMobile(constraints.maxWidth);
        final alignmentSpec = context.pageAlignmentTheme.resolve(
          widget.alignment,
        );

        // Auto-hide/show sidebar only when crossing breakpoint
        if (_wasMobile != isMobile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _wasMobile = isMobile;
                _sidebarVisible = !isMobile;
              });
            }
          });
        }

        return AppPageAlignmentScope(
          alignment: widget.alignment,
          spec: alignmentSpec,
          child: Scaffold(
            body: Column(
              children: [
                // Skip to main content — WCAG 2.4.1 bypass block (visually hidden until focused)
                _SkipToContentButton(
                  onSkip: () => _mainContentFocusNode.requestFocus(),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.chromeRailGradient,
                    boxShadow: AppTheme.chromeHeaderShadow,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.chromeHighlight,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: AppTheme.chromeBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Header(
                        navItems: const [],
                        hasNotifications:
                            widget.hasNotifications ||
                            pendingAccountRequests > 0 ||
                            pendingDeletionRequests > 0,
                        onNotificationsTap: widget.onNotificationsTap,
                        onProfileTap: widget.onProfileTap,
                        userName: _resolvedUserName,
                        onMenuTap: _toggleSidebar,
                        onLogoTap: () => context.go(AppRoutes.admin),
                        mergeWithBottomChrome: true,
                        useChromeDecoration: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 48),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final textScale = MediaQuery.textScalerOf(
                                  context,
                                ).scale(1);
                                final stackToolbar =
                                    constraints.maxWidth < 520 ||
                                    textScale > 1.25;

                                if (stackToolbar) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n.adminDashboardTitle,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.appColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildViewAsMenu(context),
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        context.l10n.adminDashboardTitle,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.appColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _buildViewAsMenu(context),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _sidebarVisible ? 240 : 0,
                        child: _sidebarVisible
                            ? AdminSidebar(
                                userName: _resolvedUserName,
                                currentRoute: widget.currentRoute,
                                items: _sidebarItems(
                                  context,
                                  pendingAccountRequests,
                                  pendingDeletionRequests,
                                ),
                                onItemTap: (route) => context.go(route),
                              )
                            : const SizedBox.shrink(),
                      ),
                      Expanded(
                        child: widget.scrollable
                            ? SingleChildScrollView(
                                padding: alignmentSpec.bodyPadding,
                                child: widget.child,
                              )
                            : Padding(
                                padding: alignmentSpec.bodyPadding,
                                child: widget.child,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewAsMenu(BuildContext context, {bool compact = false}) {
    return PopupMenuButton<String>(
      tooltip: context.l10n.adminViewAsLabel,
      offset: const Offset(0, 40),
      child: compact
          ? ExcludeSemantics(
              child: Icon(
                Icons.visibility,
                size: 18,
                color: context.appColors.textMuted,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility,
                  size: 18,
                  color: context.appColors.textMuted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    context.l10n.adminViewAsLabel,
                    style: AppTheme.body.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ),
                ExcludeSemantics(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: 'participant',
          child: Text(ctx.l10n.roleParticipant),
        ),
        PopupMenuItem(
          value: 'researcher',
          child: Text(ctx.l10n.roleResearcher),
        ),
        PopupMenuItem(value: 'hcp', child: Text(ctx.l10n.roleHcp)),
      ],
      onSelected: (role) {
        ref.read(impersonationProvider.notifier).startRolePreview(role);
        switch (role) {
          case 'participant':
            context.go(AppRoutes.participantDashboard);
          case 'researcher':
            context.go(AppRoutes.researcherDashboard);
          case 'hcp':
            context.go(AppRoutes.hcpDashboard);
        }
      },
    );
  }
}

/// Visually hidden "Skip to main content" button — shown only when focused.
/// Provides WCAG 2.4.1 bypass mechanism for keyboard and screen reader users.
class _SkipToContentButton extends StatefulWidget {
  const _SkipToContentButton({required this.onSkip});
  final VoidCallback onSkip;
  @override
  State<_SkipToContentButton> createState() => _SkipToContentButtonState();
}

class _SkipToContentButtonState extends State<_SkipToContentButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.a11ySkipToContent,
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
        child: _focused
            ? Material(
                color: AppTheme.primary,
                child: InkWell(
                  onTap: widget.onSkip,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      context.l10n.a11ySkipToContent,
                      style: const TextStyle(
                        color: AppTheme.textContrast,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
