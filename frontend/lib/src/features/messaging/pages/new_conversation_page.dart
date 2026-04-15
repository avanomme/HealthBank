// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/pages/new_conversation_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/messaging/widgets/recipient_tile.dart';
import 'package:frontend/src/features/messaging/widgets/messaging_scaffold.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantSessionProvider, hcpLinksProvider;
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart'
    show hcpPatientsProvider;

/// New conversation page — role-aware recipient selection.
///
/// Participant: HCP (from active links) + Friends
/// HCP: Email input + linked patients list
/// Researcher: Email input + contacts list
/// Admin: Email input + contacts list
class NewConversationPage extends ConsumerStatefulWidget {
  const NewConversationPage({super.key});

  @override
  ConsumerState<NewConversationPage> createState() =>
      _NewConversationPageState();
}

class _NewConversationPageState extends ConsumerState<NewConversationPage> {
  bool _creating = false;

  Future<void> _createConversationById(int targetAccountId) async {
    await _startConversation({'target_account_id': targetAccountId});
  }

  Future<void> _createConversationByEmail(String email) async {
    await _startConversation({'target_email': email});
  }

  Future<void> _startConversation(Map<String, dynamic> body) async {
    if (_creating) return;
    setState(() => _creating = true);
    try {
      final api = ref.read(messagingApiProvider);
      final result = await api.createConversation(body);
      if (mounted) {
        ref.invalidate(conversationsProvider);
        context.go('/messages/${result.convId}');
      }
    } on DioException catch (e) {
      if (mounted) {
        final status = e.response?.statusCode;
        if (status == 404) {
          AppToast.showError(
            context,
            message: context.l10n.messagingEmailNotFound,
          );
        } else if (status == 403) {
          AppToast.showError(
            context,
            message: context.l10n.messagingEmailPermission,
          );
        } else {
          AppToast.showError(
            context,
            message: context.l10n.messagingSendError,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.messagingSendError);
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessionAsync = ref.watch(participantSessionProvider);

    final role = sessionAsync.maybeWhen(
      data: (s) => s.user.role.toLowerCase(),
      orElse: () => 'participant',
    );

    return MessagingScaffold(
      alignment: AppPageAlignment.regular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: Column(
        children: [
          _buildPageHeader(l10n),
          Expanded(
            child: _creating
                ? const Center(child: AppLoadingIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: AppPageAlignedContent(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              l10n.messagingSelectRecipient,
                              variant: AppTextVariant.bodyLarge,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(height: 16),
                            if (role == 'participant')
                              _ParticipantRecipients(
                                onCreate: _createConversationById,
                              )
                            else if (role == 'hcp')
                              _HcpRecipients(
                                onCreateById: _createConversationById,
                                onCreateByEmail: _createConversationByEmail,
                              )
                            else if (role == 'researcher')
                              _EmailAndContactsRecipients(
                                onCreateById: _createConversationById,
                                onCreateByEmail: _createConversationByEmail,
                                contactsLabel: l10n.messagingRecipientResearcher,
                                contactsIcon: Icons.science_outlined,
                                contactPickerHint:
                                    l10n.messagingOrPickFromContacts,
                              )
                            else
                              _EmailAndContactsRecipients(
                                onCreateById: _createConversationById,
                                onCreateByEmail: _createConversationByEmail,
                                contactsLabel: l10n.messagingRecipientFriend,
                                contactsIcon: Icons.person_outline,
                                contactPickerHint:
                                    l10n.messagingOrPickFromContacts,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      color: AppTheme.primary,
      child: SafeArea(
        bottom: false,
        child: AppPageAlignedContent(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: AppText(
              l10n.messagingNewConversationTitle,
              variant: AppTextVariant.headlineSmall,
              fontWeight: FontWeight.w600,
              color: context.appColors.surface,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Email input widget (shared across HCP / Researcher / Admin) ───────────────

class _EmailInput extends StatefulWidget {
  const _EmailInput({required this.onSubmit});

  final void Function(String email) onSubmit;

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Semantics(
            label: l10n.messagingEmailLabel,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.go,
              onSubmitted: (v) {
                final email = v.trim();
                if (email.isNotEmpty) widget.onSubmit(email);
              },
              decoration: InputDecoration(
                labelText: l10n.messagingEmailLabel,
                hintText: l10n.messagingEmailHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Tooltip(
            message: l10n.messagingStartConversation,
            child: AppFilledButton(
              label: l10n.messagingStartConversation,
              onPressed: () {
                final email = _controller.text.trim();
                if (email.isNotEmpty) widget.onSubmit(email);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Divider with label ────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppText(
              label,
              variant: AppTextVariant.bodySmall,
              color: context.appColors.textMuted,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

// ── Participant recipient selection ───────────────────────────────────────────

/// Participant: HCP links + Friends (no email — participants can't cold-message)
class _ParticipantRecipients extends ConsumerWidget {
  const _ParticipantRecipients({required this.onCreate});

  final Future<void> Function(int) onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final linksAsync = ref.watch(hcpLinksProvider);
    final friendsAsync = ref.watch(friendsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HCP section
        AppText(
          l10n.messagingRecipientHcp,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 8),
        linksAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.messagingError,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (links) {
            final activeHcps =
                links.where((l) => l.status == 'accepted').toList();
            if (activeHcps.isEmpty) {
              return AppText(
                l10n.messagingNoRecipients,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              );
            }
            return Column(
              children: activeHcps
                  .map(
                    (link) => RecipientTile(
                      name: link.hcpName ?? 'HCP #${link.hcpId}',
                      icon: Icons.medical_services_outlined,
                      onTap: () => onCreate(link.hcpId),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 24),

        // Friends section
        AppText(
          l10n.messagingRecipientFriend,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 8),
        friendsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.messagingError,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (friends) {
            if (friends.isEmpty) {
              return AppText(
                l10n.messagingNoRecipients,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              );
            }
            return Column(
              children: friends
                  .map(
                    (f) => RecipientTile(
                      name: f.displayName,
                      icon: Icons.person_outline,
                      onTap: () => onCreate(f.accountId),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

// ── HCP recipient selection ───────────────────────────────────────────────────

/// HCP: Email input at top, then scrollable linked patients list.
class _HcpRecipients extends ConsumerWidget {
  const _HcpRecipients({
    required this.onCreateById,
    required this.onCreateByEmail,
  });

  final Future<void> Function(int) onCreateById;
  final Future<void> Function(String) onCreateByEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientsAsync = ref.watch(hcpPatientsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailInput(onSubmit: onCreateByEmail),
        _SectionDivider(label: l10n.messagingOrPickFromPatients),
        AppText(
          l10n.messagingRecipientPatient,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 8),
        patientsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.messagingError,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (patients) {
            if (patients.isEmpty) {
              return AppText(
                l10n.messagingNoRecipients,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              );
            }
            return Column(
              children: patients.map((p) {
                final id = p['patient_id'] as int? ?? 0;
                final name =
                    p['patient_name'] as String? ??
                    '${l10n.messagingRecipientPatient} #$id';
                return RecipientTile(
                  name: name,
                  icon: Icons.person_outlined,
                  onTap: () => onCreateById(id),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ── Researcher / Admin recipient selection ────────────────────────────────────

/// Email input + scrollable filterable contacts list.
/// Used for both researchers (contacts = other researchers) and admins
/// (contacts = all friends).
class _EmailAndContactsRecipients extends ConsumerStatefulWidget {
  const _EmailAndContactsRecipients({
    required this.onCreateById,
    required this.onCreateByEmail,
    required this.contactsLabel,
    required this.contactsIcon,
    required this.contactPickerHint,
  });

  final Future<void> Function(int) onCreateById;
  final Future<void> Function(String) onCreateByEmail;
  final String contactsLabel;
  final IconData contactsIcon;
  final String contactPickerHint;

  @override
  ConsumerState<_EmailAndContactsRecipients> createState() =>
      _EmailAndContactsRecipientsState();
}

class _EmailAndContactsRecipientsState
    extends ConsumerState<_EmailAndContactsRecipients> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final contactsAsync = ref.watch(friendsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailInput(onSubmit: widget.onCreateByEmail),
        _SectionDivider(label: widget.contactPickerHint),
        AppText(
          widget.contactsLabel,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 8),
        Semantics(
          label: l10n.messagingSearchResearchers,
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.messagingSearchResearchers,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (v) => setState(() => _filter = v.toLowerCase()),
          ),
        ),
        const SizedBox(height: 8),
        contactsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.messagingError,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (contacts) {
            final filtered = _filter.isEmpty
                ? contacts
                : contacts
                      .where(
                        (c) =>
                            c.displayName.toLowerCase().contains(_filter),
                      )
                      .toList();
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppText(
                  l10n.messagingNoRecipients,
                  variant: AppTextVariant.bodyMedium,
                  color: context.appColors.textMuted,
                ),
              );
            }
            return Column(
              children: filtered
                  .map(
                    (r) => RecipientTile(
                      name: r.displayName,
                      icon: widget.contactsIcon,
                      onTap: () => widget.onCreateById(r.accountId),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
