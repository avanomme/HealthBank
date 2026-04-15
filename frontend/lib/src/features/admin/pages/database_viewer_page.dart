// Created with the Assistance of Claude Code
// frontend/lib/features/admin/pages/database_viewer_page.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart' as custom;
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/utils/download_helper.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/features/admin/state/database_providers.dart';

// ── backup providers (local to this page) ────────────────────────────────────

final _backupsProvider = FutureProvider.autoDispose<List<BackupInfo>>((ref) {
  return ref.watch(adminApiProvider).listBackups();
});

// ── page ─────────────────────────────────────────────────────────────────────

/// Database Viewer page for admins — includes inline backup management.
///
/// Features:
/// - Database Backup panel at top: create manual backup, download any backup
/// - View all database tables
/// - See table schema (columns, types, constraints)
/// - Preview table data (excludes sensitive fields like passwords)
class DatabaseViewerPage extends ConsumerStatefulWidget {
  const DatabaseViewerPage({super.key});

  @override
  ConsumerState<DatabaseViewerPage> createState() => _DatabaseViewerPageState();
}

class _DatabaseViewerPageState extends ConsumerState<DatabaseViewerPage> {
  // ── backup state ────────────────────────────────────────────────────────────
  bool _triggering = false;
  String? _downloadingFile;
  String? _restoringFile;

  Future<void> _triggerBackup() async {
    setState(() => _triggering = true);
    try {
      final info = await ref.read(adminApiProvider).triggerBackup();
      ref.invalidate(_backupsProvider);
      if (mounted) {
        AppToast.showSuccess(
          context,
          message: context.l10n.backupCreatedSuccess(info.sizeHuman),
        );
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.backupCreatedError);
      }
    } finally {
      if (mounted) setState(() => _triggering = false);
    }
  }

  Future<void> _download(BackupInfo backup) async {
    setState(() => _downloadingFile = backup.filename);
    try {
      final parts = backup.filename.split('/');
      final bytes = await ref.read(adminApiProvider).downloadBackup(parts[0], parts[1]);
      final savedPath = await saveDownload(parts[1], bytes);
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
      if (mounted) setState(() => _downloadingFile = null);
    }
  }

  Future<void> _restore(BackupInfo backup) async {
    final parts = backup.filename.split('/');
    final backupType = parts[0];
    final filename = parts.length > 1 ? parts[1] : parts[0];
    setState(() => _restoringFile = backup.filename);
    try {
      final result = await ref.read(adminApiProvider).restoreBackup(backupType, filename);
      ref.invalidate(_backupsProvider);
      if (mounted) {
        AppToast.showSuccess(
          context,
          message: context.l10n.backupRestoreSuccess(
            result.preBackupSizeHuman,
            result.migrationsRun,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.backupRestoreError);
      }
    } finally {
      if (mounted) setState(() => _restoringFile = null);
    }
  }

  Future<void> _delete(BackupInfo backup) async {
    final parts = backup.filename.split('/');
    final filename = parts.length > 1 ? parts[1] : parts[0];
    try {
      await ref.read(adminApiProvider).deleteBackup(filename);
      ref.invalidate(_backupsProvider);
      if (mounted) {
        AppToast.showSuccess(context, message: context.l10n.backupDeleteSuccess);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.backupDeleteError);
      }
    }
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(databaseTablesProvider);
    final viewerState = ref.watch(databaseViewerProvider);

    return AdminScaffold(
      currentRoute: '/admin/database',
      child: tablesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, stack) => _buildErrorState(error),
        data: (tables) => _buildContent(tables, viewerState),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return AppEmptyState.error(
      title: context.l10n.dbViewerFailedToLoad,
      subtitle: error.toString(),
      action: AppOutlinedButton(
        onPressed: () => ref.invalidate(databaseTablesProvider),
        icon: Icons.refresh,
        label: context.l10n.commonRetry,
      ),
    );
  }

  Widget _buildContent(List<TableSchema> tables, DatabaseViewerState viewerState) {
    if (viewerState.selectedTable == null && tables.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(databaseViewerProvider.notifier).selectTable(tables.first.name);
      });
    }

    final selectedTable = viewerState.selectedTable != null
        ? tables.where((t) => t.name == viewerState.selectedTable).firstOrNull
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentHeight = constraints.maxHeight > 0
            ? constraints.maxHeight - 200
            : 500.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── page title ───────────────────────────────────────────────────
            Semantics(
              header: true,
              child: Text(
                context.l10n.dbPageTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Database Utilities section ───────────────────────────────────
            _SectionHeading(title: context.l10n.dbUtilitiesTitle, icon: Icons.build_outlined),
            const SizedBox(height: 12),
            _BackupPanel(
              triggering: _triggering,
              downloadingFile: _downloadingFile,
              onTrigger: _triggerBackup,
              onDownload: _download,
              onDelete: _delete,
            ),
            const SizedBox(height: 16),

            // ── Restore from Backup section ──────────────────────────────────
            _RestorePanel(
              restoringFile: _restoringFile,
              onRestore: _restore,
            ),
            const SizedBox(height: 32),

            // ── Database Viewer section ──────────────────────────────────────
            _buildViewerHeader(tables.length),
            const SizedBox(height: 12),
            _buildControls(tables, viewerState),
            const SizedBox(height: 16),

            if (selectedTable != null)
              SizedBox(
                height: contentHeight.clamp(300.0, 800.0),
                child: viewerState.showSchema
                    ? _buildSchemaView(selectedTable)
                    : _buildDataView(viewerState),
              ),
          ],
        );
      },
    );
  }

  // ── viewer section header ────────────────────────────────────────────────────

  Widget _buildViewerHeader(int tableCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackActions = constraints.maxWidth < 480;

        if (stackActions) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(
                title: context.l10n.dbViewerTitle,
                icon: Icons.table_chart_outlined,
                subtitle: context.l10n.dbViewerTablesCount(tableCount),
              ),
              const SizedBox(height: 12),
              AppOutlinedButton(
                onPressed: () {
                  ref.invalidate(databaseTablesProvider);
                  final sel = ref.read(databaseViewerProvider).selectedTable;
                  if (sel != null) {
                    ref.invalidate(
                      tableDetailProvider(TableDetailParams(tableName: sel)),
                    );
                  }
                },
                icon: Icons.refresh,
                label: context.l10n.commonRefresh,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _SectionHeading(
                title: context.l10n.dbViewerTitle,
                icon: Icons.table_chart_outlined,
                subtitle: context.l10n.dbViewerTablesCount(tableCount),
              ),
            ),
            const SizedBox(width: 8),
            AppOutlinedButton(
              onPressed: () {
                ref.invalidate(databaseTablesProvider);
                final sel = ref.read(databaseViewerProvider).selectedTable;
                if (sel != null) {
                  ref.invalidate(
                    tableDetailProvider(TableDetailParams(tableName: sel)),
                  );
                }
              },
              icon: Icons.refresh,
              label: context.l10n.commonRefresh,
            ),
          ],
        );
      },
    );
  }

  // ── table controls ───────────────────────────────────────────────────────────

  Widget _buildControls(List<TableSchema> tables, DatabaseViewerState viewerState) {
    final metrics = appFormMetrics(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 500;

          final dropdown = DropdownButtonFormField<String>(
            initialValue: viewerState.selectedTable,
            style: metrics.bodyStyle,
            dropdownColor: context.appColors.surface,
            decoration: appInputDecoration(
              context,
              labelText: context.l10n.dbViewerSelectTable,
            ),
            selectedItemBuilder: (context) => tables
                .map((t) => Align(alignment: Alignment.centerLeft, child: Text(t.name)))
                .toList(),
            items: tables
                .map((t) => DropdownMenuItem(
                      value: t.name,
                      child: Row(
                        children: [
                          Expanded(child: Text(t.name)),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.dbViewerRowsCount(t.rowCount),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.appColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(databaseViewerProvider.notifier).selectTable(value);
              }
            },
          );

          final toggle = Semantics(
            label: context.l10n.dbViewerViewModeLabel,
            child: ToggleButtons(
              isSelected: [viewerState.showSchema, !viewerState.showSchema],
              onPressed: (index) {
                ref.read(databaseViewerProvider.notifier).setShowSchema(index == 0);
              },
              borderRadius: BorderRadius.circular(4),
              color: context.appColors.textPrimary,
              borderColor: context.appColors.divider,
              selectedBorderColor: AppTheme.primary,
              selectedColor: AppTheme.textContrast,
              fillColor: AppTheme.primary,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isNarrow ? 12 : 16),
                  child: Row(children: [
                    const ExcludeSemantics(child: Icon(Icons.schema_outlined, size: 18)),
                    const SizedBox(width: 4),
                    Text(context.l10n.dbViewerSchema),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isNarrow ? 12 : 16),
                  child: Row(children: [
                    const ExcludeSemantics(child: Icon(Icons.table_rows_outlined, size: 18)),
                    const SizedBox(width: 4),
                    Text(context.l10n.dbViewerData),
                  ]),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                dropdown,
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: toggle,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: dropdown),
              const SizedBox(width: 16),
              toggle,
            ],
          );
        },
      ),
    );
  }

  // ── table description lookup ─────────────────────────────────────────────────

  String _localizedTableDescription(BuildContext context, String tableName, String fallback) {
    final l10n = context.l10n;
    switch (tableName) {
      case 'Account2FA': return l10n.dbTableDescAccount2FA;
      case 'AccountData': return l10n.dbTableDescAccountData;
      case 'AccountRequest': return l10n.dbTableDescAccountRequest;
      case 'AuditEvent': return l10n.dbTableDescAuditEvent;
      case 'Auth': return l10n.dbTableDescAuth;
      case 'ConsentRecord': return l10n.dbTableDescConsentRecord;
      case 'ConversationParticipants': return l10n.dbTableDescConversationParticipants;
      case 'Conversations': return l10n.dbTableDescConversations;
      case 'DataTypes': return l10n.dbTableDescDataTypes;
      case 'FriendRequests': return l10n.dbTableDescFriendRequests;
      case 'HcpPatientLink': return l10n.dbTableDescHcpPatientLink;
      case 'Messages': return l10n.dbTableDescMessages;
      case 'QuestionBank': return l10n.dbTableDescQuestionBank;
      case 'QuestionCategories': return l10n.dbTableDescQuestionCategories;
      case 'QuestionList': return l10n.dbTableDescQuestionList;
      case 'QuestionOptions': return l10n.dbTableDescQuestionOptions;
      case 'Responses': return l10n.dbTableDescResponses;
      case 'Roles': return l10n.dbTableDescRoles;
      case 'Sessions': return l10n.dbTableDescSessions;
      case 'Survey': return l10n.dbTableDescSurvey;
      case 'SurveyAssignment': return l10n.dbTableDescSurveyAssignment;
      case 'SurveyTemplate': return l10n.dbTableDescSurveyTemplate;
      case 'TemplateQuestions': return l10n.dbTableDescTemplateQuestions;
      case 'SystemSettings': return l10n.dbTableDescSystemSettings;
      case 'mfa_challenges': return l10n.dbTableDescMfaChallenges;
      case 'PasswordResetTokens': return l10n.dbTableDescPasswordResetTokens;
      default: return fallback;
    }
  }

  // ── schema view ──────────────────────────────────────────────────────────────

  Widget _buildSchemaView(TableSchema table) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                const ExcludeSemantics(child: Icon(Icons.table_chart, color: AppTheme.textContrast)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          table.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.textContrast,
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _localizedTableDescription(context, table.name, table.description),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textContrast.withValues(alpha: 0.8),
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.textContrast.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    context.l10n.dbViewerColumnsCount(table.columns.length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textContrast,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: context.appColors.surfaceSubtle,
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(context.l10n.dbViewerColumnHeader, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text(context.l10n.dbViewerTypeHeader, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text(context.l10n.dbViewerConstraintsHeader, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text(context.l10n.dbViewerReferenceHeader, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: table.columns.length,
              itemBuilder: (context, index) => _buildColumnRow(table.columns[index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.appColors.divider)),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem(Icons.key, context.l10n.dbViewerPrimaryKey, AppTheme.caution),
                _buildLegendItem(Icons.link, context.l10n.dbViewerForeignKey, AppTheme.info),
                _buildLegendItem(Icons.check_circle_outline, context.l10n.dbViewerNullable, AppTheme.success),
                _buildLegendItem(Icons.block, context.l10n.dbViewerNotNull, AppTheme.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnRow(ColumnInfo column) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (column.isPrimaryKey)
                  const Padding(padding: EdgeInsets.only(right: 8), child: ExcludeSemantics(child: Icon(Icons.key, size: 16, color: AppTheme.caution))),
                if (column.isForeignKey)
                  const Padding(padding: EdgeInsets.only(right: 8), child: ExcludeSemantics(child: Icon(Icons.link, size: 16, color: AppTheme.info))),
                Expanded(
                  child: Text(
                    column.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: column.isPrimaryKey ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              column.type,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: context.appColors.textMuted,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                if (column.isPrimaryKey) _buildConstraintChip('PK', AppTheme.caution),
                if (column.isForeignKey) _buildConstraintChip('FK', AppTheme.info),
                if (!column.isNullable) _buildConstraintChip('NN', AppTheme.error),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              column.foreignKeyRef ?? '-',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: column.foreignKeyRef != null ? AppTheme.info : context.appColors.textMuted,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstraintChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted)),
      ],
    );
  }

  // ── data view ────────────────────────────────────────────────────────────────

  Widget _buildDataView(DatabaseViewerState viewerState) {
    if (viewerState.selectedTable == null) {
      return Center(child: Text(context.l10n.dbViewerSelectATable));
    }

    final tableDetailAsync = ref.watch(tableDetailProvider(TableDetailParams(
      tableName: viewerState.selectedTable!,
      limit: viewerState.pageSize,
      offset: viewerState.offset,
    )));

    return tableDetailAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, size: 48, color: AppTheme.error)),
            const SizedBox(height: 16),
            Text(context.l10n.dbViewerFailedToLoadData(error.toString())),
            const SizedBox(height: 16),
            AppOutlinedButton(
              onPressed: () => ref.invalidate(tableDetailProvider(TableDetailParams(
                tableName: viewerState.selectedTable!,
              ))),
              icon: Icons.refresh,
              label: context.l10n.commonRetry,
            ),
          ],
        ),
      ),
      data: (detail) => _buildDataTable(detail, viewerState),
    );
  }

  Widget _buildDataTable(TableDetailResponse detail, DatabaseViewerState viewerState) {
    final data = detail.data;

    if (data.rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.appColors.surfaceRaised,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
          boxShadow: context.appColors.cardShadow,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(child: Icon(Icons.inbox_outlined, size: 48, color: context.appColors.textMuted)),
              const SizedBox(height: 16),
              Text(
                context.l10n.dbViewerNoData,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.appColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    final totalPages = (data.total / viewerState.pageSize).ceil();
    final currentPage = viewerState.currentPage;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                const ExcludeSemantics(child: Icon(Icons.table_rows, color: AppTheme.textContrast)),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      context.l10n.dbViewerTableData(data.name),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textContrast,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.textContrast.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    context.l10n.dbViewerRowsTotal(data.total),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textContrast,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: custom.DataTable(
              stickyHeader: true,
              headingRowColor: context.appColors.surfaceSubtle,
              columns: data.columns
                  .map((col) => Text(col, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)))
                  .toList(),
              rows: data.rows
                  .map((row) => Row(
                        children: data.columns.map((col) => DataTableCell.rawValue(row[col])).toList(),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.appColors.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.dbViewerShowing(
                    viewerState.offset + 1,
                    (viewerState.offset + data.rows.length).clamp(0, data.total),
                    data.total,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: context.l10n.tooltipPreviousPage,
                      onPressed: currentPage > 0
                          ? () => ref.read(databaseViewerProvider.notifier).previousPage()
                          : null,
                    ),
                    Text(context.l10n.dbViewerPageOf(currentPage + 1, totalPages)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: context.l10n.tooltipNextPage,
                      onPressed: currentPage < totalPages - 1
                          ? () => ref.read(databaseViewerProvider.notifier).nextPage()
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Restore Panel ─────────────────────────────────────────────────────────────
//
// Standalone card with a backup dropdown + Restore button.
// Positioned between the Backup Panel and the Database Viewer.

class _RestorePanel extends ConsumerStatefulWidget {
  const _RestorePanel({
    required this.restoringFile,
    required this.onRestore,
  });

  final String? restoringFile;
  final Future<void> Function(BackupInfo) onRestore;

  @override
  ConsumerState<_RestorePanel> createState() => _RestorePanelState();
}

class _RestorePanelState extends ConsumerState<_RestorePanel> {
  BackupInfo? _selected;

  Future<void> _confirmAndRestore(BuildContext context) async {
    if (_selected == null) return;
    final l10n = context.l10n;
    final filename = _selected!.filename.split('/').last;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Semantics(
          header: true,
          child: Text(l10n.backupRestoreConfirmTitle, style: AppTheme.heading4),
        ),
        content: Text(l10n.backupRestoreConfirmBody(filename), style: AppTheme.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.caution),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && _selected != null) {
      await widget.onRestore(_selected!);
    }
  }

  String _fmt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final backupsAsync = ref.watch(_backupsProvider);
    final isRestoring = widget.restoringFile != null;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── header ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: context.appColors.surfaceSubtle,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
              border: Border(bottom: BorderSide(color: context.appColors.divider)),
            ),
            child: Row(
              children: [
                const ExcludeSemantics(
                    child: Icon(Icons.restore_outlined, size: 18, color: AppTheme.caution)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.backupRestoreTitle,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: backupsAsync.when(
              loading: () => const Center(
                child: Padding(padding: EdgeInsets.all(8), child: AppLoadingIndicator()),
              ),
              error: (e, _) => Text(
                l10n.backupLoadError,
                style: AppTheme.captions.copyWith(color: AppTheme.error),
              ),
              data: (backups) {
                if (backups.isEmpty) {
                  return Text(
                    l10n.backupNoRecent,
                    style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
                  );
                }

                // Keep _selected valid if the list refreshed
                if (_selected != null &&
                    !backups.any((b) => b.filename == _selected!.filename)) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => setState(() => _selected = null));
                }

                final metrics = appFormMetrics(context);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<BackupInfo>(
                        initialValue: _selected,
                        style: metrics.bodyStyle,
                        dropdownColor: context.appColors.surface,
                        decoration: appInputDecoration(
                          context,
                          labelText: l10n.backupRestoreSelectLabel,
                        ),
                        hint: Text(
                          l10n.backupRestoreSelectHint,
                          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
                        ),
                        selectedItemBuilder: (_) => backups
                            .map((b) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${b.backupType.toUpperCase()}  •  ${b.filename.split('/').last}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        items: backups
                            .map((b) => DropdownMenuItem<BackupInfo>(
                                  value: b,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        b.filename.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: context.appColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${b.backupType.toUpperCase()}  •  ${_fmt(b.createdAt)}  •  ${b.sizeHuman}',
                                        style: AppTheme.captions.copyWith(
                                          color: context.appColors.textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: isRestoring
                            ? null
                            : (val) => setState(() => _selected = val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Semantics(
                      liveRegion: true,
                      child: AppFilledButton(
                        label: isRestoring ? l10n.backupRestoring : l10n.backupRestoreAction,
                        backgroundColor: AppTheme.caution,
                        onPressed: (_selected == null || isRestoring)
                            ? null
                            : () => _confirmAndRestore(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Heading ───────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final IconData icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: AppTheme.heading3.copyWith(color: AppTheme.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Backup Panel ──────────────────────────────────────────────────────────────
//
// Collapsible card showing all backups grouped by type (Manual first, then
// Daily / Weekly / Monthly). Manual backups have a delete action.
// Scheduled backups are read-only.

class _BackupPanel extends ConsumerStatefulWidget {
  const _BackupPanel({
    required this.triggering,
    required this.downloadingFile,
    required this.onTrigger,
    required this.onDownload,
    required this.onDelete,
  });

  final bool triggering;
  final String? downloadingFile;
  final VoidCallback onTrigger;
  final Future<void> Function(BackupInfo) onDownload;
  final Future<void> Function(BackupInfo) onDelete;

  @override
  ConsumerState<_BackupPanel> createState() => _BackupPanelState();
}

class _BackupPanelState extends ConsumerState<_BackupPanel> {
  bool _expanded = true;
  // Manual / Daily / Weekly / Monthly — manual first for easy access
  static const _order = ['manual', 'daily', 'weekly', 'monthly'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final backupsAsync = ref.watch(_backupsProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── collapsible header ───────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSubtle,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(7),
                  bottom: _expanded ? Radius.zero : const Radius.circular(7),
                ),
                border: _expanded
                    ? Border(bottom: BorderSide(color: context.appColors.divider))
                    : null,
              ),
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.backup_outlined, size: 18, color: AppTheme.primary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.backupPageTitle,
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                  AppFilledButton(
                    label: widget.triggering ? l10n.backupCreating : l10n.backupCreateManual,
                    onPressed: widget.triggering ? null : widget.onTrigger,
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: _expanded ? l10n.backupSectionCollapse : l10n.backupSectionExpand,
                    child: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── collapsible body ─────────────────────────────────────────────
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(12),
              child: backupsAsync.when(
                loading: () => const Center(
                  child: Padding(padding: EdgeInsets.all(16), child: AppLoadingIndicator()),
                ),
                error: (e, _) => Row(
                  children: [
                    const ExcludeSemantics(child: Icon(Icons.warning_amber_outlined, color: AppTheme.error, size: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n.backupLoadError,
                          style: AppTheme.captions.copyWith(color: AppTheme.error)),
                    ),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(_backupsProvider),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(l10n.commonRetry),
                    ),
                  ],
                ),
                data: (backups) {
                  if (backups.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(l10n.backupNoRecent,
                          style: AppTheme.captions.copyWith(color: context.appColors.textMuted)),
                    );
                  }

                  final grouped = <String, List<BackupInfo>>{};
                  for (final b in backups) {
                    grouped.putIfAbsent(b.backupType, () => []).add(b);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final type in _order)
                        if (grouped.containsKey(type)) ...[
                          _BackupTypeSection(
                            type: type,
                            backups: grouped[type]!,
                            downloadingFile: widget.downloadingFile,
                            onDownload: widget.onDownload,
                            onDelete: type == 'manual' ? widget.onDelete : null,
                          ),
                          const SizedBox(height: 12),
                        ],
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── Backup type section ───────────────────────────────────────────────────────

class _BackupTypeSection extends StatelessWidget {
  const _BackupTypeSection({
    required this.type,
    required this.backups,
    required this.downloadingFile,
    required this.onDownload,
    this.onDelete,
  });

  final String type;
  final List<BackupInfo> backups;
  final String? downloadingFile;
  final Future<void> Function(BackupInfo) onDownload;
  final Future<void> Function(BackupInfo)? onDelete; // null = not deletable

  String _label(BuildContext context) => switch (type) {
        'daily'   => context.l10n.backupTypeDaily,
        'weekly'  => context.l10n.backupTypeWeekly,
        'monthly' => context.l10n.backupTypeMonthly,
        'manual'  => context.l10n.backupTypeManual,
        _         => type,
      };

  @override
  Widget build(BuildContext context) {
    // Sort newest-first within each category
    final sorted = [...backups]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _label(context).toUpperCase(),
            style: AppTheme.captions.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final backup in sorted)
              _BackupTile(
                backup: backup,
                isDownloading: downloadingFile == backup.filename,
                onDownload: () => onDownload(backup),
                onDelete: onDelete != null ? () => onDelete!(backup) : null,
              ),
          ],
        ),
      ],
    );
  }
}

// ── Backup tile ───────────────────────────────────────────────────────────────

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.backup,
    required this.isDownloading,
    required this.onDownload,
    this.onDelete,
  });

  final BackupInfo backup;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback? onDelete; // null = not deletable (scheduled backups)

  String _fmt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final filename = backup.filename.split('/').last;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Semantics(header: true, child: Text(l10n.backupDeleteConfirmTitle, style: AppTheme.heading4)),
        content: Text(l10n.backupDeleteConfirmBody(filename), style: AppTheme.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && onDelete != null) onDelete!();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filename = backup.filename.split('/').last;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Icon(Icons.storage_outlined, size: 14, color: context.appColors.textMuted)),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.captions.copyWith(
                        fontWeight: FontWeight.w500,
                        color: context.appColors.textPrimary)),
                Text(
                  '${_fmt(backup.createdAt)}  •  ${backup.sizeHuman}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.captions.copyWith(
                      color: context.appColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Download button
          if (isDownloading)
            const Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            Tooltip(
              message: l10n.backupDownloadTooltip,
              child: IconButton(
                icon: const Icon(Icons.download_outlined, size: 18),
                color: AppTheme.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: onDownload,
              ),
            ),
          // Delete button — only shown for manual backups
          if (onDelete != null)
            Tooltip(
              message: l10n.backupDeleteTooltip,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppTheme.error,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: () => _confirmDelete(context),
              ),
            ),
        ],
      ),
    );
  }
}
