// Created with the Assistance of Claude Code
// frontend/lib/features/admin/pages/messages_page.dart
//
// Account Requests page — combines new account requests and user-submitted
// deletion requests into one place with two separate tabs.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/core/widgets/widgets.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';

// ---------------------------------------------------------------------------
// Top-level page
// ---------------------------------------------------------------------------

/// Admin page combining new account creation requests and deletion requests.
class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  _Tab _activeTab = _Tab.newAccounts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AdminScaffold(
      currentRoute: '/admin/messages',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.adminAccountRequests,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Top-level tab switcher ──────────────────────────────────────
          _ResponsiveControlGroup(
            children: [
              AppTabButton(
                label: l10n.adminNewAccountRequestsTab,
                isSelected: _activeTab == _Tab.newAccounts,
                onTap: () => setState(() => _activeTab = _Tab.newAccounts),
              ),
              AppTabButton(
                label: l10n.adminDeletionRequestsTab,
                isSelected: _activeTab == _Tab.deletions,
                onTap: () => setState(() => _activeTab = _Tab.deletions),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Tab content (scrollable list) ──────────────────────────────
          _activeTab == _Tab.newAccounts
              ? const _NewAccountRequestsSection()
              : const _DeletionRequestsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

enum _Tab { newAccounts, deletions }

// ===========================================================================
// NEW ACCOUNT REQUESTS section (existing MessagesPage content)
// ===========================================================================

class _NewAccountRequestsSection extends ConsumerWidget {
  const _NewAccountRequestsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AccountStatusTabs(),
        SizedBox(height: 16),
        _AccountRequestList(),
      ],
    );
  }
}

/// Status filter tabs for new account requests
class _AccountStatusTabs extends ConsumerWidget {
  const _AccountStatusTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(accountRequestStatusFilter);

    return _ResponsiveControlGroup(
      children: [
        AppTabButton(
          label: l10n.adminAccountRequestsPending,
          isSelected: current == 'pending',
          onTap: () =>
              ref.read(accountRequestStatusFilter.notifier).state = 'pending',
        ),
        AppTabButton(
          label: l10n.adminAccountRequestsApproved,
          isSelected: current == 'approved',
          onTap: () =>
              ref.read(accountRequestStatusFilter.notifier).state = 'approved',
        ),
        AppTabButton(
          label: l10n.adminAccountRequestsRejected,
          isSelected: current == 'rejected',
          onTap: () =>
              ref.read(accountRequestStatusFilter.notifier).state = 'rejected',
        ),
      ],
    );
  }
}

class _AccountRequestList extends ConsumerWidget {
  const _AccountRequestList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final requestsAsync = ref.watch(accountRequestsProvider);
    final currentStatus = ref.watch(accountRequestStatusFilter);

    return requestsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: AppLoadingIndicator(),
      ),
      error: (e, _) => AppEmptyState.error(
        title: l10n.adminAccountRequestsLoadError,
        centered: false,
        action: AppOutlinedButton(
          label: l10n.commonRetry,
          onPressed: () => ref.invalidate(accountRequestsProvider),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return AppEmptyState(
            icon: Icons.inbox_outlined,
            title: l10n.adminAccountRequestsEmpty,
            centered: false,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: requests
              .map(
                (req) => _AccountRequestCard(
                  request: req,
                  showActions: currentStatus == 'pending',
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AccountRequestCard extends ConsumerWidget {
  const _AccountRequestCard({required this.request, required this.showActions});

  final AccountRequestResponse request;
  final bool showActions;

  String _roleName(int roleId, AppLocalizations l10n) {
    switch (roleId) {
      case 1:
        return l10n.requestAccountRoleParticipant;
      case 2:
        return l10n.requestAccountRoleResearcher;
      case 3:
        return l10n.requestAccountRoleHcp;
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackHeader = _shouldStackRow(context, constraints.maxWidth);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + role tag
              if (stackHeader) ...[
                AppText(
                  '${request.firstName} ${request.lastName}',
                  variant: AppTextVariant.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                AppColoredTag(
                  label: _roleName(request.roleId, l10n),
                  color: AppTheme.primary,
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        '${request.firstName} ${request.lastName}',
                        variant: AppTextVariant.bodyMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppColoredTag(
                      label: _roleName(request.roleId, l10n),
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              const SizedBox(height: 8),

              // Email
              _IconRow(icon: Icons.email_outlined, text: request.email),

              // Participant-specific
              if (request.roleId == 1) ...[
                if (request.birthdate != null)
                  _IconRow(icon: Icons.cake_outlined, text: request.birthdate!),
                if (request.gender != null)
                  _IconRow(
                    icon: Icons.person_outline,
                    text:
                        request.gender == 'Other' && request.genderOther != null
                        ? '${request.gender} (${request.genderOther})'
                        : request.gender!,
                  ),
              ],

              // Submitted date
              if (request.createdAt != null)
                _IconRow(
                  icon: Icons.schedule,
                  text: request.createdAt!,
                  small: true,
                ),

              // Admin notes
              if (request.adminNotes != null &&
                  request.adminNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _NotesBox(notes: request.adminNotes!),
              ],

              if (showActions) ...[
                const SizedBox(height: 12),
                _AccountRequestActions(request: request),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AccountRequestActions extends ConsumerWidget {
  const _AccountRequestActions({required this.request});
  final AccountRequestResponse request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return _ResponsiveControlGroup(
      stackAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOutlinedButton(
          label: l10n.adminAccountRequestsReject,
          onPressed: () => _handleReject(context, ref),
        ),
        AppFilledButton(
          label: l10n.adminAccountRequestsApprove,
          onPressed: () => _handleApprove(context, ref),
        ),
      ],
    );
  }

  Future<void> _handleApprove(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.adminAccountRequestsApprove,
      content: l10n.adminAccountRequestsApproveConfirm,
      confirmLabel: l10n.adminAccountRequestsApprove,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(adminApiProvider).approveAccountRequest(request.requestId);
      ref.invalidate(accountRequestsProvider);
      ref.invalidate(accountRequestCountProvider);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: l10n.adminAccountRequestsApproved_msg,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          message: context.l10n.commonErrorWithDetail(e.toString()),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminAccountRequestsReject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.adminAccountRequestsRejectConfirm),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: l10n.adminAccountRequestsRejectNotes,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          AppTextButton(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppFilledButton(
            label: l10n.adminAccountRequestsReject,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(adminApiProvider)
          .rejectAccountRequest(
            request.requestId,
            AccountRequestRejectBody(
              adminNotes: notesController.text.trim().isNotEmpty
                  ? notesController.text.trim()
                  : null,
            ),
          );
      ref.invalidate(accountRequestsProvider);
      ref.invalidate(accountRequestCountProvider);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: l10n.adminAccountRequestsRejected_msg,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          message: context.l10n.commonErrorWithDetail(e.toString()),
        );
      }
    } finally {
      notesController.dispose();
    }
  }
}

// ===========================================================================
// DELETION REQUESTS section
// ===========================================================================

class _DeletionRequestsSection extends ConsumerWidget {
  const _DeletionRequestsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DeletionStatusTabs(),
        SizedBox(height: 16),
        _DeletionRequestList(),
      ],
    );
  }
}

class _DeletionStatusTabs extends ConsumerWidget {
  const _DeletionStatusTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(deletionRequestStatusFilter);

    return _ResponsiveControlGroup(
      children: [
        AppTabButton(
          label: l10n.adminAccountRequestsPending,
          isSelected: current == 'pending',
          onTap: () =>
              ref.read(deletionRequestStatusFilter.notifier).state = 'pending',
        ),
        AppTabButton(
          label: l10n.adminAccountRequestsApproved,
          isSelected: current == 'approved',
          onTap: () =>
              ref.read(deletionRequestStatusFilter.notifier).state = 'approved',
        ),
        AppTabButton(
          label: l10n.adminAccountRequestsRejected,
          isSelected: current == 'rejected',
          onTap: () =>
              ref.read(deletionRequestStatusFilter.notifier).state = 'rejected',
        ),
      ],
    );
  }
}

class _DeletionRequestList extends ConsumerWidget {
  const _DeletionRequestList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final requestsAsync = ref.watch(deletionRequestsProvider);
    final currentStatus = ref.watch(deletionRequestStatusFilter);

    return requestsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: AppLoadingIndicator(),
      ),
      error: (e, _) => AppEmptyState.error(
        title: l10n.adminDeletionRequestsLoadError,
        centered: false,
        action: AppOutlinedButton(
          label: l10n.commonRetry,
          onPressed: () => ref.invalidate(deletionRequestsProvider),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return AppEmptyState(
            icon: Icons.delete_outline,
            title: l10n.adminDeletionRequestsEmpty,
            centered: false,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: requests
              .map(
                (req) => _DeletionRequestCard(
                  request: req,
                  showActions: currentStatus == 'pending',
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _DeletionRequestCard extends ConsumerWidget {
  const _DeletionRequestCard({
    required this.request,
    required this.showActions,
  });

  final DeletionRequestResponse request;
  final bool showActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackHeader = _shouldStackRow(context, constraints.maxWidth);
          final statusTag = AppColoredTag(
            label: request.status,
            icon: request.status == 'pending'
                ? Icons.schedule_rounded
                : request.status == 'approved'
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: request.status == 'pending'
                ? AppTheme.caution
                : request.status == 'approved'
                ? AppTheme
                      .success // approved = green ✓
                : AppTheme.error, // rejected = red ✓
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + status tag
              if (stackHeader) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (request.fullName != null) ...[
                      AppUserAvatar(name: request.fullName!),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            request.fullName ?? '—',
                            variant: AppTextVariant.bodyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          _IconRow(
                            icon: Icons.email_outlined,
                            text: request.email,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                statusTag,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (request.fullName != null)
                      AppUserAvatar(name: request.fullName!),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            request.fullName ?? '—',
                            variant: AppTextVariant.bodyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          _IconRow(
                            icon: Icons.email_outlined,
                            text: request.email,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    statusTag,
                  ],
                ),
              const SizedBox(height: 8),

              _IconRow(
                icon: Icons.schedule,
                text:
                    '${l10n.adminDeletionRequestsRequested}: ${request.requestedAt}',
                small: true,
              ),

              if (request.adminNotes != null &&
                  request.adminNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _NotesBox(notes: request.adminNotes!),
              ],

              if (showActions) ...[
                const SizedBox(height: 12),
                _DeletionRequestActions(request: request),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DeletionRequestActions extends ConsumerWidget {
  const _DeletionRequestActions({required this.request});
  final DeletionRequestResponse request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return _ResponsiveControlGroup(
      stackAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOutlinedButton(
          label: l10n.adminDeletionRequestsReject,
          onPressed: () => _handleReject(context, ref),
        ),
        AppFilledButton(
          label: l10n.adminDeletionRequestsApprove,
          backgroundColor: AppTheme.error,
          onPressed: () => _handleApprove(context, ref),
        ),
      ],
    );
  }

  Future<void> _handleApprove(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.adminDeletionRequestsApprove,
      content: l10n.adminDeletionRequestsApproveConfirm,
      confirmLabel: l10n.adminDeletionRequestsApprove,
      isDangerous: true,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(adminApiProvider)
          .approveDeletionRequest(request.requestId);
      ref.invalidate(deletionRequestsProvider);
      ref.invalidate(deletionRequestCountProvider);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: l10n.adminDeletionRequestsApproved_msg,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          message: context.l10n.commonErrorWithDetail(e.toString()),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminDeletionRequestsReject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.adminDeletionRequestsRejectConfirm),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: l10n.adminDeletionRequestsRejectNotes,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          AppTextButton(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppFilledButton(
            label: l10n.adminDeletionRequestsReject,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(adminApiProvider)
          .rejectDeletionRequest(
            request.requestId,
            AccountRequestRejectBody(
              adminNotes: notesController.text.trim().isNotEmpty
                  ? notesController.text.trim()
                  : null,
            ),
          );
      ref.invalidate(deletionRequestsProvider);
      ref.invalidate(deletionRequestCountProvider);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: l10n.adminDeletionRequestsRejected_msg,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          message: context.l10n.commonErrorWithDetail(e.toString()),
        );
      }
    } finally {
      notesController.dispose();
    }
  }
}

// ===========================================================================
// Shared helpers
// ===========================================================================

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text, this.small = false});

  final IconData icon;
  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: small ? 14 : 16, color: context.appColors.textMuted),
          const SizedBox(width: 6),
          Flexible(
            child: AppText(
              text,
              variant: small
                  ? AppTextVariant.bodySmall
                  : AppTextVariant.bodyMedium,
              color: context.appColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveControlGroup extends StatelessWidget {
  const _ResponsiveControlGroup({
    required this.children,
    this.stackAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final CrossAxisAlignment stackAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackControls = _shouldStackRow(context, constraints.maxWidth);

        if (stackControls) {
          return Column(
            crossAxisAlignment: stackAlignment,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                SizedBox(width: double.infinity, child: children[i]),
                if (i < children.length - 1) const SizedBox(height: 8),
              ],
            ],
          );
        }

        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: children,
        );
      },
    );
  }
}

bool _shouldStackRow(BuildContext context, double width) {
  return width < 440 || MediaQuery.textScalerOf(context).scale(1) > 1.3;
}

class _NotesBox extends StatelessWidget {
  const _NotesBox({required this.notes});
  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.appColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppText(
        notes,
        variant: AppTextVariant.bodySmall,
        color: context.appColors.textMuted,
      ),
    );
  }
}
