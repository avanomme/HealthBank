// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/pages/admin_nav_hub_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/config/go_router.dart';
import '../widgets/admin_scaffold.dart';

/// Admin Page Navigator — lists every route in the application, grouped by
/// role, so admins can jump to any page with one click.
///
/// Security: admin session token is already required to reach /admin/*.
/// No additional bypass — the router's role guard still applies for each
/// individual destination, but admins are exempt from all role guards.
class AdminNavHubPage extends StatelessWidget {
  const AdminNavHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: AppRoutes.adminNavHub,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.adminNavHubTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminNavHubSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 32),

          _buildSection(context, context.l10n.adminNavGroupAdmin, [
            _NavRoute(context.l10n.navDashboard, AppRoutes.admin, Icons.admin_panel_settings),
            _NavRoute(context.l10n.navUserManagement, AppRoutes.adminUsers, Icons.people),
            _NavRoute(context.l10n.navDatabaseViewer, AppRoutes.adminDatabase, Icons.storage),
            _NavRoute(context.l10n.navMessages, AppRoutes.adminMessages, Icons.message),
            _NavRoute(context.l10n.navDeletionQueue, AppRoutes.adminDeletionQueue, Icons.delete_sweep),
            _NavRoute(context.l10n.navAuditLog, AppRoutes.adminLogs, Icons.history),
            _NavRoute(context.l10n.navUiTest, AppRoutes.adminUiTest, Icons.science),
            _NavRoute(context.l10n.navPageNavigator, AppRoutes.adminNavHub, Icons.map_outlined),
          ]),

          _buildSection(context, context.l10n.adminNavGroupParticipant, [
            _NavRoute(context.l10n.navDashboard, AppRoutes.participantDashboard, Icons.dashboard),
            _NavRoute(context.l10n.navMySurveys, AppRoutes.participantSurveys, Icons.assignment),
            _NavRoute(context.l10n.navResults, AppRoutes.participantResults, Icons.analytics),
            _NavRoute(context.l10n.navTasks, AppRoutes.participantTasks, Icons.checklist),
          ]),

          _buildSection(context, context.l10n.adminNavGroupResearcher, [
            _NavRoute(context.l10n.navDashboard, AppRoutes.researcherDashboard, Icons.dashboard),
            _NavRoute(context.l10n.navSurveys, AppRoutes.surveys, Icons.assignment),
            _NavRoute(context.l10n.navNewSurvey, AppRoutes.surveyBuilder, Icons.add_box),
            _NavRoute(context.l10n.navTemplates, AppRoutes.templates, Icons.description),
            _NavRoute(context.l10n.navNewTemplate, AppRoutes.templateBuilder, Icons.post_add),
            _NavRoute(context.l10n.navQuestionBank, AppRoutes.questionBank, Icons.quiz),
            _NavRoute(context.l10n.navData, AppRoutes.researcherData, Icons.analytics),
          ]),

          _buildSection(context, context.l10n.adminNavGroupHealthcareProvider, [
            _NavRoute(context.l10n.navDashboard, AppRoutes.hcpDashboard, Icons.dashboard),
            _NavRoute(context.l10n.navClients, AppRoutes.hcpClients, Icons.people),
            _NavRoute(context.l10n.navReports, AppRoutes.hcpReports, Icons.assessment),
          ]),

          _buildSection(context, context.l10n.adminNavGroupShared, [
            _NavRoute(context.l10n.navMessages, AppRoutes.messagesInbox, Icons.inbox),
            _NavRoute(context.l10n.navNewMessage, AppRoutes.messagesNew, Icons.edit),
            _NavRoute(context.l10n.navFriends, AppRoutes.messagesFriends, Icons.group),
            _NavRoute(context.l10n.navSettings, AppRoutes.settings, Icons.settings),
            _NavRoute(context.l10n.navHelp, AppRoutes.help, Icons.help_outline),
          ]),

          _buildSection(context, context.l10n.adminNavGroupPublicAuth, [
            _NavRoute(context.l10n.navHome, AppRoutes.home, Icons.home),
            _NavRoute(context.l10n.navLogin, AppRoutes.login, Icons.login),
            _NavRoute(context.l10n.navForgotPassword, AppRoutes.forgotPassword, Icons.lock_reset),
            _NavRoute(context.l10n.navResetPassword, AppRoutes.resetPassword, Icons.lock_open),
            _NavRoute(context.l10n.navRequestAccount, AppRoutes.requestAccount, Icons.person_add),
            _NavRoute(context.l10n.navConsent, AppRoutes.consent, Icons.check_circle_outline),
            _NavRoute(context.l10n.navCompleteProfile, AppRoutes.completeProfile, Icons.manage_accounts),
            _NavRoute(context.l10n.navChangePassword, AppRoutes.changePassword, Icons.password),
            _NavRoute(context.l10n.navAbout, AppRoutes.about, Icons.info_outline),
            _NavRoute(context.l10n.commonTermsOfService, AppRoutes.termsOfService, Icons.gavel),
            _NavRoute(context.l10n.commonPrivacyPolicy, AppRoutes.privacyPolicy, Icons.privacy_tip_outlined),
            _NavRoute(context.l10n.navErrorPage, '/404-preview', Icons.error_outline),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_NavRoute> routes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTheme.heading3.copyWith(color: AppTheme.primary),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: routes.map((route) => _buildRouteCard(context, route)).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRouteCard(BuildContext context, _NavRoute route) {
    return InkWell(
      onTap: () => context.go(route.path),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(route.icon, size: 28, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(
              route.label,
              style: AppTheme.body.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              route.path,
              style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRoute {
  final String label;
  final String path;
  final IconData icon;

  const _NavRoute(this.label, this.path, this.icon);
}
