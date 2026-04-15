// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/pages/friend_request_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/micro/app_user_avatar.dart';
import 'package:frontend/src/core/widgets/forms/app_email_input.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/messaging/widgets/messaging_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantSessionProvider;

/// Friend request management page.
///
/// Sections:
/// 1. Browse Colleagues (researcher-only) — live-searchable list of other researchers
/// 2. Send friend request by email (privacy-preserving)
/// 3. Incoming friend requests — accept or decline
class FriendRequestPage extends ConsumerStatefulWidget {
  const FriendRequestPage({super.key});

  @override
  ConsumerState<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends ConsumerState<FriendRequestPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sending = false;
  String? _sentMessage;
  // Start disabled — only enable live validation after the first failed submit
  // so errors never appear just from clicking or typing before Send is pressed.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Colleague browse state
  final _colleagueSearchController = TextEditingController();
  List<ResearcherResult> _colleagues = [];
  bool _loadingColleagues = false;
  bool _initialColleagueLoad = true;
  final Set<int> _pendingSent = {};

  @override
  void initState() {
    super.initState();
    _loadColleagues();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _colleagueSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadColleagues([String? query]) async {
    setState(() => _loadingColleagues = true);
    try {
      final api = ref.read(messagingApiProvider);
      final results = await api.listResearchers(query: query);
      if (mounted) {
        setState(() {
          _colleagues = results;
          _loadingColleagues = false;
          _initialColleagueLoad = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingColleagues = false;
          _initialColleagueLoad = false;
        });
      }
    }
  }

  Future<void> _addColleague(int accountId) async {
    final l10n = context.l10n;
    try {
      final api = ref.read(messagingApiProvider);
      await api.sendDirectFriendRequest({'target_account_id': accountId});
      if (mounted) {
        setState(() => _pendingSent.add(accountId));
        AppToast.showSuccess(context, message: l10n.messagingColleagueAdded);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: l10n.messagingColleagueAddError);
      }
    }
  }

  Future<void> _sendFriendRequest() async {
    // Clear the success message before validating so the two messages
    // can never appear simultaneously.
    setState(() => _sentMessage = null);
    if (_emailController.text.trim().isEmpty) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      // Switch to live validation so the error clears as the user corrects it.
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }
    setState(() => _sending = true);
    try {
      final api = ref.read(messagingApiProvider);
      await api.sendFriendRequest({'email': _emailController.text.trim()});
    } catch (e) {
      // Privacy: show same success message for 404/409 (don't reveal if user exists)
      // Only show error for actual network/server failures
      final isClientError =
          e is DioException &&
          e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500;
      if (!isClientError) {
        if (mounted) {
          setState(() {
            _sending = false;
            _sentMessage = null;
          });
          AppToast.showError(context, message: context.l10n.errorNetwork);
        }
        return;
      }
    }
    if (mounted) {
      _emailController.clear();
      setState(() {
        _formKey = GlobalKey<FormState>();
        _autovalidateMode = AutovalidateMode.disabled;
        _sending = false;
        _sentMessage = context.l10n.messagingFriendRequestSent;
      });
    }
  }

  Future<void> _respond(int requestId, String action) async {
    try {
      final api = ref.read(messagingApiProvider);
      await api.respondToFriendRequest(requestId, {'action': action});
      ref.invalidate(incomingFriendRequestsProvider);
      if (mounted) {
        if (action == 'accept') {
          AppToast.showSuccess(
            context,
            message: context.l10n.messagingFriendAccepted,
          );
        } else {
          AppToast.showSuccess(
            context,
            message: context.l10n.messagingFriendDeclined,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(
          context,
          message: context.l10n.messagingFriendRequestError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final requestsAsync = ref.watch(incomingFriendRequestsProvider);
    final role = ref.watch(participantSessionProvider).maybeWhen(
      data: (s) => s.user.role.toLowerCase(),
      orElse: () => '',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: AppPageAlignedContent(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (role == 'researcher') ...[
                        _ColleagueBrowseSection(
                          colleagues: _colleagues,
                          loading: _loadingColleagues,
                          initialLoad: _initialColleagueLoad,
                          searchController: _colleagueSearchController,
                          onSearch: _loadColleagues,
                          onAdd: _addColleague,
                          pendingSent: _pendingSent,
                        ),
                        const SizedBox(height: 24),
                      ],
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.appColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.appColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              l10n.messagingFriendRequestTitle,
                              variant: AppTextVariant.bodyLarge,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Form(
                              key: _formKey,
                              child: AppEmailInput(
                                label: l10n.messagingFriendRequestEmail,
                                controller: _emailController,
                                hintText: l10n.messagingFriendEmailHint,
                                isRequired: false,
                                autovalidateMode: _autovalidateMode,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_sentMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withAlpha(26),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.success.withAlpha(77),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: AppTheme.success,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _sentMessage!,
                                        style: AppTheme.captions.copyWith(
                                          color: AppTheme.success,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: AppFilledButton(
                                label: _sending
                                    ? l10n.messagingSending
                                    : l10n.messagingFriendRequestSend,
                                onPressed: _sending ? null : _sendFriendRequest,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppText(
                        l10n.messagingIncomingRequests,
                        variant: AppTextVariant.bodyLarge,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(height: 12),
                      requestsAsync.when(
                        loading: () => const AppLoadingIndicator(),
                        error: (_, __) => AppText(
                          l10n.messagingError,
                          variant: AppTextVariant.bodyMedium,
                          color: AppTheme.error,
                        ),
                        data: (requests) {
                          if (requests.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: AppText(
                                l10n.messagingNoIncomingRequests,
                                variant: AppTextVariant.bodyMedium,
                                color: context.appColors.textMuted,
                              ),
                            );
                          }
                          return Column(
                            children: requests
                                .map(
                                  (req) => _FriendRequestTile(
                                    request: req,
                                    onAccept: () =>
                                        _respond(req.requestId, 'accept'),
                                    onDecline: () =>
                                        _respond(req.requestId, 'reject'),
                                    l10n: l10n,
                                  ),
                                )
                                .toList(),
                          );
                        },
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
              l10n.messagingFriendRequestTitle,
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

/// Browse Colleagues section — shown only for researchers.
///
/// Displays a live-searchable list of other researchers with per-row Add buttons.
class _ColleagueBrowseSection extends StatelessWidget {
  const _ColleagueBrowseSection({
    required this.colleagues,
    required this.loading,
    required this.initialLoad,
    required this.searchController,
    required this.onSearch,
    required this.onAdd,
    required this.pendingSent,
  });

  final List<ResearcherResult> colleagues;
  final bool loading;
  final bool initialLoad;
  final TextEditingController searchController;
  final void Function(String) onSearch;
  final void Function(int) onAdd;
  final Set<int> pendingSent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.messagingBrowseColleagues,
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 4),
          AppText(
            l10n.messagingBrowseColleaguesSubtitle,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          ),
          const SizedBox(height: 16),
          Semantics(
            label: l10n.messagingSearchColleagues,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.messagingSearchColleagues,
                border: const OutlineInputBorder(),
              ),
              onChanged: onSearch,
            ),
          ),
          const SizedBox(height: 12),
          if (initialLoad)
            const AppLoadingIndicator()
          else if (colleagues.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AppText(
                  l10n.messagingNoColleaguesFound,
                  variant: AppTextVariant.bodyMedium,
                  color: context.appColors.textMuted,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: colleagues.length,
              itemBuilder: (context, index) {
                final r = colleagues[index];
                final alreadySent = pendingSent.contains(r.accountId);
                return ListTile(
                  leading: AppUserAvatar(name: r.displayName),
                  title: Text(r.displayName),
                  trailing: alreadySent
                      ? Tooltip(
                          message: l10n.messagingColleagueRequestSent,
                          child: const ExcludeSemantics(
                            child: Icon(
                              Icons.check,
                              color: AppTheme.success,
                            ),
                          ),
                        )
                      : AppFilledButton(
                          label: l10n.messagingAddColleague,
                          onPressed: () => onAdd(r.accountId),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FriendRequestTile extends StatelessWidget {
  const _FriendRequestTile({
    required this.request,
    required this.onAccept,
    required this.onDecline,
    required this.l10n,
  });

  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final name = request.requesterName ?? 'User #${request.requesterId}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Row(
          children: [
            AppUserAvatar(name: name),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: AppTheme.body.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            // Accept button
            AppTextButton(
              label: l10n.messagingAcceptRequest,
              onPressed: onAccept,
            ),
            // Decline button
            AppTextButton(
              label: l10n.messagingRejectRequest,
              onPressed: onDecline,
            ),
          ],
        ),
      ),
    );
  }
}
