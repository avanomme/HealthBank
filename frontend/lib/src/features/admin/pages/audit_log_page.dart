// Created with the Assistance of Claude Code
// frontend/lib/features/admin/pages/audit_log_page.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/utils/download_helper.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart'
    as custom;
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/features/admin/state/audit_log_providers.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Audit Log page for viewing system activity
class AuditLogPage extends ConsumerStatefulWidget {
  const AuditLogPage({super.key});

  @override
  ConsumerState<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends ConsumerState<AuditLogPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _expandedRowId;
  bool _exporting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auditLogsAsync = ref.watch(auditLogsProvider);
    final filters = ref.watch(auditLogFiltersProvider);
    final l10n = context.l10n;

    return AdminScaffold(
      currentRoute: '/admin/logs',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.auditLogTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (auditLogsAsync.hasValue)
                    Tooltip(
                      message: l10n.auditLogExportCsv,
                      child: IconButton(
                        onPressed: _exporting
                            ? null
                            : () => _exportCsv(auditLogsAsync.value!),
                        icon: _exporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: context.appColors.surfaceRaised,
                          foregroundColor: AppTheme.primary,
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      ref.invalidate(auditLogsProvider);
                      ref.invalidate(auditLogActionsProvider);
                      ref.invalidate(auditLogResourceTypesProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: l10n.commonRefresh,
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.textContrast,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters
          _buildFilters(filters),
          const SizedBox(height: 16),

          // Audit log table
          SizedBox(
            height: 560,
            child: auditLogsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: AppLoadingIndicator(),
              ),
              error: (error, _) => _buildErrorState(error),
              data: (response) => _buildAuditLogTable(response, filters),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFilters(AuditLogFilters filters) {
    final l10n = context.l10n;
    final actionsAsync = ref.watch(auditLogActionsProvider);
    final resourceTypesAsync = ref.watch(auditLogResourceTypesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Search and quick filters
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.auditLogSearchPlaceholder,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: context.appColors.divider,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(auditLogFiltersProvider.notifier)
                            .setSearch(value);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Status filter
                    _buildStatusDropdown(filters),
                    const SizedBox(height: 12),

                    // HTTP Method filter
                    _buildHttpMethodDropdown(filters),
                    const SizedBox(height: 12),

                    // Action filter
                    actionsAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (actions) => _buildActionDropdown(filters, actions),
                    ),
                    const SizedBox(height: 12),

                    // Resource Type filter
                    resourceTypesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (types) =>
                          _buildResourceTypeDropdown(filters, types),
                    ),
                  ],
                );
              }

              // Wide layout
              return Column(
                children: [
                  Row(
                    children: [
                      // Search field
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: l10n.auditLogSearchPlaceholder,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: context.appColors.divider,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          onChanged: (value) {
                            ref
                                .read(auditLogFiltersProvider.notifier)
                                .setSearch(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Status filter
                      Expanded(child: _buildStatusDropdown(filters)),
                      const SizedBox(width: 12),

                      // HTTP Method filter
                      Expanded(child: _buildHttpMethodDropdown(filters)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Action filter
                      Expanded(
                        child: actionsAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (actions) =>
                              _buildActionDropdown(filters, actions),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Resource Type filter
                      Expanded(
                        child: resourceTypesAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (types) =>
                              _buildResourceTypeDropdown(filters, types),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Clear filters button
                      AppTextButton(
                        label: l10n.commonClear,
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(auditLogFiltersProvider.notifier)
                              .clearFilters();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(AuditLogFilters filters) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String?>(
      initialValue: filters.status,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.commonStatus,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.auditLogAllStatuses)),
        DropdownMenuItem(value: 'success', child: Text(l10n.auditLogSuccess)),
        DropdownMenuItem(value: 'failure', child: Text(l10n.auditLogFailure)),
        DropdownMenuItem(value: 'denied', child: Text(l10n.auditLogDenied)),
      ],
      onChanged: (value) {
        ref.read(auditLogFiltersProvider.notifier).setStatus(value);
      },
    );
  }

  Widget _buildHttpMethodDropdown(AuditLogFilters filters) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String?>(
      initialValue: filters.httpMethod,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.auditLogHttpMethod,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.auditLogAllMethods)),
        const DropdownMenuItem(value: 'GET', child: Text('GET')),
        const DropdownMenuItem(value: 'POST', child: Text('POST')),
        const DropdownMenuItem(value: 'PUT', child: Text('PUT')),
        const DropdownMenuItem(value: 'PATCH', child: Text('PATCH')),
        const DropdownMenuItem(value: 'DELETE', child: Text('DELETE')),
      ],
      onChanged: (value) {
        ref.read(auditLogFiltersProvider.notifier).setHttpMethod(value);
      },
    );
  }

  Widget _buildActionDropdown(AuditLogFilters filters, List<String> actions) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String?>(
      initialValue: filters.action,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.auditLogAction,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.auditLogAllActions)),
        ...actions.map(
          (action) => DropdownMenuItem(value: action, child: Text(action)),
        ),
      ],
      onChanged: (value) {
        ref.read(auditLogFiltersProvider.notifier).setAction(value);
      },
    );
  }

  Widget _buildResourceTypeDropdown(
    AuditLogFilters filters,
    List<String> types,
  ) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String?>(
      initialValue: filters.resourceType,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.auditLogResourceType,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.auditLogAllResources)),
        ...types.map(
          (type) => DropdownMenuItem(value: type, child: Text(type)),
        ),
      ],
      onChanged: (value) {
        ref.read(auditLogFiltersProvider.notifier).setResourceType(value);
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: AppEmptyState.error(
        title: context.l10n.auditLogFailedToLoad,
        subtitle: error.toString(),
        action: AppFilledButton(
          label: context.l10n.commonRetry,
          onPressed: () => ref.invalidate(auditLogsProvider),
        ),
      ),
    );
  }

  Widget _buildAuditLogTable(
    AuditLogResponse response,
    AuditLogFilters filters,
  ) {
    final events = response.events;

    return custom.DataTable(
      stickyHeader: true,
      enableSorting: false,
      emptyMessage: context.l10n.auditLogNoEvents,
      expandedRowIndex: _expandedRowId != null
          ? events.indexWhere((e) => e.auditEventId == _expandedRowId)
          : null,
      onRowTap: (index) {
        setState(() {
          _expandedRowId = _expandedRowId == events[index].auditEventId
              ? null
              : events[index].auditEventId;
        });
      },
      expandedRowBuilder: (index) => _buildExpandedDetails(events[index]),
      columns: [
        DataTableCell.custom(
          flex: 2,
          child: Text(context.l10n.auditLogColumnTimestamp),
        ),
        DataTableCell.custom(
          flex: 2,
          child: Text(context.l10n.auditLogColumnActor),
        ),
        DataTableCell.custom(
          flex: 2,
          child: Text(context.l10n.auditLogColumnAction),
        ),
        DataTableCell.custom(
          flex: 3,
          child: Text(context.l10n.auditLogColumnPath),
        ),
        DataTableCell.custom(
          flex: 1,
          child: Text(context.l10n.auditLogColumnStatus),
        ),
        DataTableCell.custom(
          flex: 1,
          child: Text(context.l10n.auditLogColumnMethod),
        ),
        DataTableCell.custom(flex: 1, child: const Text('')),
      ],
      rows: events.map((e) => _buildEventRow(e)).toList(),
      footer: _buildPaginationFooter(response, filters),
    );
  }

  Widget _buildEventRow(AuditEvent event) {
    final isExpanded = _expandedRowId == event.auditEventId;
    final statusColor = _getStatusColor(event.status);
    final methodColor = _getMethodColor(event.httpMethod);

    return Row(
      children: [
        // Timestamp
        DataTableCell.custom(
          flex: 2,
          child: Text(
            _formatTimestamp(event.createdAt),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.appColors.textMuted,
              fontFamily: 'monospace',
            ),
          ),
        ),

        // Actor
        DataTableCell.custom(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (event.actorName != null)
                Text(
                  event.actorName!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              if (event.actorEmail != null)
                Text(
                  event.actorEmail!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (event.actorName == null && event.actorEmail == null)
                Text(
                  event.actorType,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: context.appColors.textMuted,
                  ),
                ),
            ],
          ),
        ),

        // Action
        DataTableCell.custom(
          flex: 2,
          child: _ActionChip(action: event.action, getColor: _getActionColor),
        ),

        // Path
        DataTableCell.custom(
          flex: 3,
          child: Text(
            event.path ?? '-',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Status
        DataTableCell.custom(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.status.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // HTTP Method
        DataTableCell.custom(
          flex: 1,
          child: event.httpMethod != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: methodColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.httpMethod!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: methodColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : const Text('-'),
        ),

        // Expand icon
        DataTableCell.custom(
          flex: 1,
          child: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: context.appColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedDetails(AuditEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.02),
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context.l10n.auditLogEventId,
                      event.auditEventId.toString(),
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogRequestId,
                      event.requestId ?? '-',
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogResourceType,
                      event.resourceType,
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogResourceId,
                      event.resourceId ?? '-',
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogHttpStatus,
                      event.httpStatusCode?.toString() ?? '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context.l10n.auditLogIpAddress,
                      event.ipAddress ?? '-',
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogActorType,
                      event.actorType,
                    ),
                    _buildDetailRow(
                      context.l10n.auditLogActorId,
                      event.actorAccountId?.toString() ?? '-',
                    ),
                    if (event.errorCode != null)
                      _buildDetailRow(
                        context.l10n.auditLogErrorCode,
                        event.errorCode!,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (event.userAgent != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              context.l10n.auditLogUserAgent,
              event.userAgent!,
              wrap: true,
            ),
          ],
          if (event.metadata != null && event.metadata!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.auditLogMetadata,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Text(
                _formatMetadata(event.metadata!),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool wrap = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: wrap
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              overflow: wrap ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(
    AuditLogResponse response,
    AuditLogFilters filters,
  ) {
    final currentPage = filters.currentPage;
    final totalPages = (response.total / filters.limit).ceil();
    final startItem = filters.offset + 1;
    final endItem = (filters.offset + response.events.length).clamp(
      0,
      response.total,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.appColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.auditLogShowingEvents(
              startItem,
              endItem,
              response.total,
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 0
                    ? () => ref
                          .read(auditLogFiltersProvider.notifier)
                          .previousPage()
                    : null,
                tooltip: context.l10n.auditLogPreviousPage,
              ),
              Text(
                context.l10n.auditLogPageOf(currentPage + 1, totalPages),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages - 1
                    ? () =>
                          ref.read(auditLogFiltersProvider.notifier).nextPage()
                    : null,
                tooltip: context.l10n.auditLogNextPage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String isoTimestamp) {
    try {
      final dt = DateTime.parse(isoTimestamp);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    } catch (_) {
      return isoTimestamp;
    }
  }

  String _formatMetadata(Map<String, dynamic> metadata) {
    final buffer = StringBuffer();
    metadata.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString().trimRight();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return AppTheme.success;
      case 'failure':
        return AppTheme.error;
      case 'denied':
        return AppTheme.caution;
      default:
        return context.appColors.textMuted;
    }
  }

  Future<void> _exportCsv(AuditLogResponse response) async {
    setState(() => _exporting = true);
    try {
      final buf = StringBuffer();
      // Header
      buf.writeln(
        'Event ID,Timestamp,Actor Name,Actor Email,Actor Type,'
        'Action,HTTP Method,Path,Status,HTTP Status,Resource Type,Resource ID,IP Address,Request ID',
      );
      // Rows
      String esc(dynamic v) {
        final s = (v ?? '').toString().replaceAll('"', '""');
        return '"$s"';
      }

      for (final e in response.events) {
        buf.writeln(
          [
            esc(e.auditEventId),
            esc(e.createdAt),
            esc(e.actorName),
            esc(e.actorEmail),
            esc(e.actorType),
            esc(e.action),
            esc(e.httpMethod),
            esc(e.path),
            esc(e.status),
            esc(e.httpStatusCode),
            esc(e.resourceType),
            esc(e.resourceId),
            esc(e.ipAddress),
            esc(e.requestId),
          ].join(','),
        );
      }
      final bytes = utf8.encode(buf.toString());
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final savedPath = await saveDownload('audit_log_$date.csv', bytes);
      if (mounted) {
        final msg = kIsWeb
            ? context.l10n.backupDownloadStarted
            : context.l10n.backupSavedTo(savedPath);
        AppToast.showSuccess(context, message: msg);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.backupDownloadError);
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Color _getActionColor(String action) {
    final a = action.toLowerCase();

    // Auth / session / 2FA — blue
    if (a.contains('login') ||
        a.contains('logout') ||
        a.contains('session') ||
        a.contains('2fa') ||
        a.contains('register') ||
        a.contains('tos_') ||
        a.contains('password_reset')) {
      return AppTheme.info;
    }

    // Password change — indigo (auth but distinct from reset flow)
    if (a.contains('password')) return const Color(0xFF5C6BC0);

    // Backup — teal
    if (a.contains('backup')) return const Color(0xFF00897B);

    // Database — blue-grey
    if (a.contains('db_') || a.contains('database')) {
      return const Color(0xFF607D8B);
    }

    // Audit / system / health — grey-blue
    if (a.contains('audit_') ||
        a.contains('health_') ||
        a.contains('dashboard')) {
      return const Color(0xFF78909C);
    }

    // Admin / impersonation / view-as — amber warning
    if (a.contains('admin_') ||
        a.contains('impersonat') ||
        a.contains('view_as') ||
        a.contains('view_start') ||
        a.contains('view_end') ||
        a == 'admin_dashboard_viewed') {
      return AppTheme.caution;
    }

    // Consent — purple
    if (a.contains('consent')) return const Color(0xFF8E24AA);

    // Deletion / purge / reject — red
    if (a.contains('delet') || a.contains('purge') || a.contains('reject')) {
      return AppTheme.error;
    }

    // Surveys — deep orange
    if (a.contains('survey') && !a.contains('participant')) {
      return const Color(0xFFE64A19);
    }

    // Participant responses / drafts — orange
    if (a.contains('participant') ||
        a.contains('response') ||
        a.contains('draft') ||
        a.contains('submit')) {
      return const Color(0xFFF57C00);
    }

    // Templates — brown
    if (a.contains('template')) return const Color(0xFF6D4C41);

    // Questions / question bank — deep purple
    if (a.contains('question')) return const Color(0xFF512DA8);

    // Assignments — lime-green
    if (a.contains('assignment')) return const Color(0xFF689F38);

    // Research / aggregation — cyan
    if (a.contains('research') ||
        a.contains('aggregat') ||
        a.contains('cross_survey')) {
      return const Color(0xFF0097A7);
    }

    // Messaging / friends / conversations — pink
    if (a.contains('message') ||
        a.contains('friend') ||
        a.contains('conversation') ||
        a.contains('researcher_search')) {
      return const Color(0xFFE91E63);
    }

    // HCP / patients — green
    if (a.contains('hcp') || a.contains('patient')) {
      return const Color(0xFF2E7D32);
    }

    // Account / user (create, approve, view) — success green
    if (a.contains('account') ||
        a.contains('user') ||
        a.contains('profile') ||
        a.contains('approv') ||
        a.contains('create') ||
        a.contains('accept')) {
      return AppTheme.success;
    }

    return context.appColors.textMuted;
  }

  Color _getMethodColor(String? method) {
    switch (method?.toUpperCase()) {
      case 'GET':
        return AppTheme.info;
      case 'POST':
        return AppTheme.success;
      case 'PUT':
      case 'PATCH':
        return AppTheme.caution;
      case 'DELETE':
        return AppTheme.error;
      default:
        return context.appColors.textMuted;
    }
  }
}

// ── Action chip ───────────────────────────────────────────────────────────────

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.action, required this.getColor});

  final String action;
  final Color Function(String) getColor;

  @override
  Widget build(BuildContext context) {
    final color = getColor(action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        action,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
