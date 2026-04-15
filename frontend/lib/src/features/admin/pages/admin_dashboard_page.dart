// Created with the Assistance of Claude Code
// frontend/lib/features/admin/pages/admin_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/core/api/models/backup.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    hide adminApiProvider;
import 'package:frontend/src/features/admin/state/database_providers.dart'
    show adminApiProvider;
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/config/go_router.dart';

final _latestBackupProvider = FutureProvider.autoDispose<BackupInfo?>((
  ref,
) async {
  final api = ref.watch(adminApiProvider);
  final list = await api.listBackups();
  if (list.isEmpty) return null;
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list.first;
});

/// Admin Dashboard page — overview of system stats, pending actions, and activity.
///
/// Automatically ends any view-as / impersonation session when loaded,
/// so the admin is always recognized as themselves on this page.
class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  bool _endingViewAs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _endViewAsIfActive());
  }

  Future<void> _endViewAsIfActive() async {
    final impersonation = ref.read(impersonationProvider);
    if (!impersonation.isImpersonating || _endingViewAs) return;

    _endingViewAs = true;
    final notifier = ref.read(impersonationProvider.notifier);
    await notifier.endImpersonation();
    if (!mounted) return;
    notifier.clearImpersonationState();
    _endingViewAs = false;
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    final l10n = context.l10n;

    return AdminScaffold(
      currentRoute: '/admin',
      child: statsAsync.when(
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ExcludeSemantics(
                child: Icon(
                  Icons.error_outline,
                  color: AppTheme.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.adminDashboardFailedToLoad,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        data: (stats) => _DashboardContent(stats: stats, l10n: l10n),
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.stats, required this.l10n});

  final Map<String, dynamic> stats;
  final dynamic l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestBackup = ref.watch(_latestBackupProvider);
    final pendingAccounts = stats['pending_account_requests'] as int? ?? 0;
    final pendingDeletions = stats['pending_deletion_requests'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
          Semantics(
            header: true,
            child: Text(
              l10n.adminDashboardTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adminWelcomeMessage,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 24),

          // Action alerts
          if (pendingAccounts > 0 || pendingDeletions > 0) ...[
            if (pendingAccounts > 0)
              _ActionAlert(
                icon: Icons.person_add_outlined,
                message: context.l10n.adminDashboardPendingAccountAlert(
                  pendingAccounts,
                ),
                color: AppTheme.info,
                route: AppRoutes.adminMessages,
              ),
            if (pendingDeletions > 0) ...[
              const SizedBox(height: 8),
              _ActionAlert(
                icon: Icons.delete_outline,
                message: context.l10n.adminDashboardPendingDeletionAlert(
                  pendingDeletions,
                ),
                color: AppTheme.error,
                route: AppRoutes.adminMessages,
              ),
            ],
            const SizedBox(height: 24),
          ],

          // KPI cards
          _buildKpiRow(context, latestBackup),
          const SizedBox(height: 24),

          // Two-column layout: Role distribution + Recent activity
          _buildRoleAndActivityRow(context),
          const SizedBox(height: 24),

          // Two-column: Recent requests
          _buildRequestsRow(context),
          const SizedBox(height: 24),

          // Quick links
          _buildQuickLinks(context),
        ],
    );
  }

  ({String value, String? subtitle, Color color}) _backupCardValues(
    BuildContext context,
    AsyncValue<BackupInfo?> latestBackup,
  ) {
    final l10n = context.l10n;
    String value = '…';
    String? subtitle;
    Color color = context.appColors.textMuted;
    latestBackup.whenData((b) {
      if (b == null) {
        value = l10n.adminDashboardBackupNone;
        color = AppTheme.caution;
      } else {
        final createdUtc = b.createdAt.isUtc
            ? b.createdAt
            : b.createdAt.toUtc();
        var diff = DateTime.now().toUtc().difference(createdUtc);
        if (diff.isNegative) diff = Duration.zero;
        if (diff.inMinutes < 60) {
          value = '${diff.inMinutes}m ${l10n.adminDashboardBackupAgo}';
        } else if (diff.inHours < 24) {
          value = '${diff.inHours}h ${l10n.adminDashboardBackupAgo}';
        } else {
          value = '${diff.inDays}d ${l10n.adminDashboardBackupAgo}';
        }
        subtitle = '${b.backupType} · ${b.sizeHuman}';
        color = diff.inHours < 25 ? AppTheme.success : AppTheme.caution;
      }
    });
    if (latestBackup.hasError) {
      value = l10n.commonRetry;
      color = AppTheme.error;
    }
    return (value: value, subtitle: subtitle, color: color);
  }

  Widget _buildKpiRow(
    BuildContext context,
    AsyncValue<BackupInfo?> latestBackup,
  ) {
    final l10n = context.l10n;
    final backup = _backupCardValues(context, latestBackup);

    final cards = [
      AppStatCard(
        label: l10n.adminDashboardKpiTotalUsers,
        value: '${stats['active_users'] ?? 0}',
        subtitle: l10n.adminDashboardTotalUsersSubtitle(
          stats['total_users'] as int? ?? 0,
        ),
        icon: Icons.people_outlined,
        color: AppTheme.primary,
        onTap: () => context.go('/admin/users'),
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiNew30d,
        value: '${stats['new_users_30d'] ?? 0}',
        icon: Icons.person_add_outlined,
        color: AppTheme.success,
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiActiveSurveys,
        value: '${stats['published_surveys'] ?? 0}',
        subtitle: l10n.adminDashboardTotalSurveysSubtitle(
          stats['total_surveys'] as int? ?? 0,
        ),
        icon: Icons.assignment_outlined,
        color: AppTheme.info,
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiTotalResponses,
        value: '${stats['total_responses'] ?? 0}',
        icon: Icons.quiz_outlined,
        color: AppTheme.secondary,
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiPendingRequests,
        value: '${stats['pending_account_requests'] ?? 0}',
        icon: Icons.mark_email_unread_outlined,
        color: (stats['pending_account_requests'] ?? 0) > 0
            ? AppTheme.caution
            : context.appColors.textMuted,
        onTap: () => context.go(AppRoutes.adminMessages),
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiDraftSurveys,
        value: '${stats['draft_surveys'] ?? 0}',
        icon: Icons.edit_note_outlined,
        color: context.appColors.textMuted,
      ),
      AppStatCard(
        label: l10n.adminDashboardKpiLatestBackup,
        value: backup.value,
        subtitle: backup.subtitle,
        icon: Icons.backup_outlined,
        color: backup.color,
        onTap: () => context.go(AppRoutes.adminDatabase),
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [for (final card in cards) SizedBox(width: 180, child: card)],
    );
  }

  Widget _buildRoleAndActivityRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 800;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRoleDistribution(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildRecentActivity(context)),
            ],
          );
        }
        return Column(
          children: [
            _buildRoleDistribution(context),
            const SizedBox(height: 16),
            _buildRecentActivity(context),
          ],
        );
      },
    );
  }

  Widget _buildRequestsRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 800;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentAccountRequests(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildRecentDeletionRequests(context)),
            ],
          );
        }
        return Column(
          children: [
            _buildRecentAccountRequests(context),
            const SizedBox(height: 16),
            _buildRecentDeletionRequests(context),
          ],
        );
      },
    );
  }

  Widget _buildRoleDistribution(BuildContext context) {
    final rolesMap = stats['users_by_role'] as Map<String, dynamic>? ?? {};
    final labels = <String>[];
    final values = <double>[];
    for (final entry in rolesMap.entries) {
      labels.add(entry.key[0].toUpperCase() + entry.key.substring(1));
      values.add((entry.value as num).toDouble());
    }

    if (labels.isEmpty) {
      return _buildCard(
        context,
        title: context.l10n.adminDashboardUserDistribution,
        icon: Icons.pie_chart_outline,
        child: Center(child: Text(context.l10n.adminDashboardNoUsers)),
      );
    }

    return _buildCard(
      context,
      title: context.l10n.adminDashboardUserDistributionByRole,
      icon: Icons.pie_chart_outline,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 280,
          child: AppPieChart(
            title: context.l10n.adminDashboardUserRoles,
            data: {
              for (var i = 0; i < labels.length; i++) labels[i]: values[i],
            },
            showLegend: true,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final logins = stats['recent_logins'] as List<dynamic>? ?? [];

    return _buildCard(
      context,
      title: context.l10n.adminDashboardRecentLogins,
      icon: Icons.login,
      child: logins.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.adminDashboardNoActivity,
                style: TextStyle(color: context.appColors.textMuted),
              ),
            )
          : Column(
              children: [
                for (final login in logins.take(8))
                  _ActivityRow(
                    name: login['name'] ?? '',
                    detail: login['role'] ?? '',
                    time: login['logged_in_at'] ?? '',
                    icon: Icons.person_outline,
                  ),
              ],
            ),
    );
  }

  Widget _buildRecentAccountRequests(BuildContext context) {
    final requests = stats['recent_account_requests'] as List<dynamic>? ?? [];

    return _buildCard(
      context,
      title: context.l10n.adminDashboardPendingAccountRequests,
      icon: Icons.person_add_outlined,
      action: requests.isNotEmpty
          ? TextButton(
              onPressed: () => context.go(AppRoutes.adminMessages),
              child: Text(context.l10n.commonViewAll),
            )
          : null,
      child: requests.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.adminDashboardNoPendingRequests,
                style: TextStyle(color: context.appColors.textMuted),
              ),
            )
          : Column(
              children: [
                for (final req in requests)
                  _ActivityRow(
                    name: req['name'] ?? '',
                    detail: req['email'] ?? '',
                    time: req['created_at'] ?? '',
                    icon: Icons.mail_outline,
                  ),
              ],
            ),
    );
  }

  Widget _buildRecentDeletionRequests(BuildContext context) {
    final requests = stats['recent_deletion_requests'] as List<dynamic>? ?? [];

    return _buildCard(
      context,
      title: context.l10n.adminDashboardPendingDeletionRequests,
      icon: Icons.delete_outline,
      action: requests.isNotEmpty
          ? TextButton(
              onPressed: () => context.go(AppRoutes.adminMessages),
              child: Text(context.l10n.commonViewAll),
            )
          : null,
      child: requests.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.adminDashboardNoPendingRequests,
                style: TextStyle(color: context.appColors.textMuted),
              ),
            )
          : Column(
              children: [
                for (final req in requests)
                  _ActivityRow(
                    name: req['name'] ?? '',
                    detail: req['email'] ?? '',
                    time: req['requested_at'] ?? '',
                    icon: Icons.warning_amber_outlined,
                    color: AppTheme.error,
                  ),
              ],
            ),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    final l10n = context.l10n;
    return _buildCard(
      context,
      title: l10n.adminDashboardQuickLinks,
      icon: Icons.link,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _QuickLink(
              label: l10n.adminDashboardManageUsers,
              icon: Icons.people,
              route: '/admin/users',
            ),
            _QuickLink(
              label: l10n.adminDashboardAuditLog,
              icon: Icons.history,
              route: '/admin/logs',
            ),
            _QuickLink(
              label: l10n.adminDashboardDatabaseViewer,
              icon: Icons.storage,
              route: '/admin/database',
            ),
            _QuickLink(
              label: l10n.adminDashboardAccountRequests,
              icon: Icons.mail_outline,
              route: '/admin/messages',
            ),
            _QuickLink(
              label: l10n.adminDashboardUiTestPage,
              icon: Icons.widgets,
              route: '/admin/ui-test',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    Widget? action,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(icon, size: 18, color: AppTheme.primary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
                if (action != null) action,
              ],
            ),
          ),
          Divider(color: context.appColors.divider),
          child,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ActionAlert extends StatelessWidget {
  const _ActionAlert({
    required this.icon,
    required this.message,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String message;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.name,
    required this.detail,
    required this.time,
    required this.icon,
    this.color,
  });

  final String name;
  final String detail;
  final String time;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final timeStr = time.isNotEmpty ? _formatTime(time) : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(
              icon,
              size: 16,
              color: color ?? context.appColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.appColors.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (timeStr.isNotEmpty)
            Text(
              timeStr,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return '';
    }
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () => context.go(route),
      backgroundColor: AppTheme.primary.withValues(alpha: 0.05),
      side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.2)),
    );
  }
}
