// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/pages/messaging_inbox_page.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/forms/app_email_input.dart';
import 'package:frontend/src/core/widgets/micro/app_user_avatar.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart'
    show
        messagingApiProvider,
        conversationsProvider,
        messagesProvider,
        incomingFriendRequestsProvider,
        friendsProvider,
        allResearchersProvider;
import 'package:frontend/src/features/messaging/widgets/messaging_scaffold.dart';
import 'package:frontend/src/features/messaging/widgets/recipient_tile.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantSessionProvider, hcpLinksProvider;
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart'
    show hcpPatientsProvider;

/// Messaging inbox page showing all conversations with inline thread view.
///
/// On desktop: split pane — conversation list on the left, messages on the right.
/// On mobile: conversation list; tapping a conversation expands it inline.
/// Friend requests and new conversation both open as bottom sheets — never
/// navigating away from the main scaffold.
class MessagingInboxPage extends ConsumerStatefulWidget {
  const MessagingInboxPage({super.key});

  @override
  ConsumerState<MessagingInboxPage> createState() => _MessagingInboxPageState();
}

class _MessagingInboxPageState extends ConsumerState<MessagingInboxPage> {
  int? _selectedConvId;
  Conversation? _selectedConv;
  bool _showingContacts = false;

  /// Set when a new conversation is created — auto-selects once loaded.
  int? _pendingConvId;

  void _selectConversation(Conversation conv) {
    setState(() {
      _selectedConvId = conv.convId;
      _selectedConv = conv;
      _showingContacts = false;
    });
  }

  /// Called after a new conversation is created from the bottom sheet.
  void _handleConversationCreated(int convId) {
    ref.invalidate(conversationsProvider);
    setState(() {
      _pendingConvId = convId;
      _showingContacts = false;
    });
  }

  void _showFriendRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _FriendRequestSheet(),
    );
  }

  void _showNewConversation(BuildContext context) {
    setState(() => _showingContacts = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) =>
          _NewConversationSheet(onCreated: _handleConversationCreated),
    );
  }

  void _toggleContacts() {
    setState(() => _showingContacts = !_showingContacts);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final conversationsAsync = ref.watch(conversationsProvider);
    final requestsAsync = ref.watch(incomingFriendRequestsProvider);
    final sessionAsync = ref.watch(participantSessionProvider);

    final userName = sessionAsync.maybeWhen(
      data: (s) {
        final first = s.viewingAs?.firstName ?? s.user.firstName;
        return (first != null && first.trim().isNotEmpty) ? first.trim() : null;
      },
      orElse: () => null,
    );

    final pendingRequestCount = requestsAsync.maybeWhen(
      data: (reqs) => reqs.length,
      orElse: () => 0,
    );

    // Auto-select newly created conversation once the list refreshes.
    if (_pendingConvId != null) {
      conversationsAsync.whenData((convs) {
        final conv = convs.where((c) => c.convId == _pendingConvId).firstOrNull;
        if (conv != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedConvId = conv.convId;
                _selectedConv = conv;
                _pendingConvId = null;
              });
            }
          });
        }
      });
    }

    return MessagingScaffold(
      alignment: AppPageAlignment.sidebarRegular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      userName: userName,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = Breakpoints.isDesktop(constraints.maxWidth);

          if (isDesktop) {
            return _DesktopLayout(
              conversationsAsync: conversationsAsync,
              selectedConvId: _selectedConvId,
              selectedConv: _selectedConv,
              pendingRequestCount: pendingRequestCount,
              showingContacts: _showingContacts,
              onSelectConversation: _selectConversation,
              onFriendRequestsTap: () => _showFriendRequests(context),
              onNewConversationTap: () => _showNewConversation(context),
              onToggleContacts: _toggleContacts,
              onStartConversation: _handleConversationCreated,
              l10n: l10n,
            );
          }

          return _MobileLayout(
            conversationsAsync: conversationsAsync,
            selectedConvId: _selectedConvId,
            selectedConv: _selectedConv,
            pendingRequestCount: pendingRequestCount,
            showingContacts: _showingContacts,
            onSelectConversation: _selectConversation,
            onFriendRequestsTap: () => _showFriendRequests(context),
            onNewConversationTap: () => _showNewConversation(context),
            onToggleContacts: _toggleContacts,
            onStartConversation: _handleConversationCreated,
            onBack: () => setState(() {
              _selectedConvId = null;
              _selectedConv = null;
            }),
            l10n: l10n,
          );
        },
      ),
    );
  }
}

// ─── Desktop: side-by-side list + thread ──────────────────────────────────────

class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout({
    required this.conversationsAsync,
    required this.selectedConvId,
    required this.selectedConv,
    required this.pendingRequestCount,
    required this.showingContacts,
    required this.onSelectConversation,
    required this.onFriendRequestsTap,
    required this.onNewConversationTap,
    required this.onToggleContacts,
    required this.onStartConversation,
    required this.l10n,
  });

  final AsyncValue<List<Conversation>> conversationsAsync;
  final int? selectedConvId;
  final Conversation? selectedConv;
  final int pendingRequestCount;
  final bool showingContacts;
  final void Function(Conversation) onSelectConversation;
  final VoidCallback onFriendRequestsTap;
  final VoidCallback onNewConversationTap;
  final VoidCallback onToggleContacts;
  final void Function(int convId) onStartConversation;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Left: conversation list / contacts (320px)
        SizedBox(
          width: 320,
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: context.appColors.divider)),
            ),
            child: Column(
              children: [
                _InboxHeader(
                  pendingRequestCount: pendingRequestCount,
                  showingContacts: showingContacts,
                  onFriendRequestsTap: onFriendRequestsTap,
                  onNewConversationTap: onNewConversationTap,
                  onToggleContacts: onToggleContacts,
                  l10n: l10n,
                ),
                Expanded(
                  child: showingContacts
                      ? _ContactsList(
                          onStartConversation: onStartConversation,
                          l10n: l10n,
                        )
                      : _ConversationList(
                          conversationsAsync: conversationsAsync,
                          selectedConvId: selectedConvId,
                          onTap: onSelectConversation,
                          l10n: l10n,
                        ),
                ),
              ],
            ),
          ),
        ),

        // Right: message thread
        Expanded(
          child: selectedConvId != null && selectedConv != null
              ? _InlineThread(
                  convId: selectedConvId!,
                  conv: selectedConv!,
                  l10n: l10n,
                )
              : _EmptyThread(l10n: l10n),
        ),
      ],
    );
  }
}

// ─── Mobile: full-screen list or thread ───────────────────────────────────────

class _MobileLayout extends ConsumerWidget {
  const _MobileLayout({
    required this.conversationsAsync,
    required this.selectedConvId,
    required this.selectedConv,
    required this.pendingRequestCount,
    required this.showingContacts,
    required this.onSelectConversation,
    required this.onFriendRequestsTap,
    required this.onNewConversationTap,
    required this.onToggleContacts,
    required this.onStartConversation,
    required this.onBack,
    required this.l10n,
  });

  final AsyncValue<List<Conversation>> conversationsAsync;
  final int? selectedConvId;
  final Conversation? selectedConv;
  final int pendingRequestCount;
  final bool showingContacts;
  final void Function(Conversation) onSelectConversation;
  final VoidCallback onFriendRequestsTap;
  final VoidCallback onNewConversationTap;
  final VoidCallback onToggleContacts;
  final void Function(int convId) onStartConversation;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedConvId != null && selectedConv != null) {
      return Column(
        children: [
          // Back header
          Container(
            color: AppTheme.primary,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: context.appColors.surface),
                    tooltip: context.l10n.tooltipGoBack,
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: AppText(
                      selectedConv!.otherParticipantName ??
                          'User #${selectedConv!.otherParticipantId}',
                      variant: AppTextVariant.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.surface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _InlineThread(
              convId: selectedConvId!,
              conv: selectedConv!,
              l10n: l10n,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _InboxHeader(
          pendingRequestCount: pendingRequestCount,
          showingContacts: showingContacts,
          onFriendRequestsTap: onFriendRequestsTap,
          onNewConversationTap: onNewConversationTap,
          onToggleContacts: onToggleContacts,
          l10n: l10n,
        ),
        Expanded(
          child: showingContacts
              ? _ContactsList(
                  onStartConversation: onStartConversation,
                  l10n: l10n,
                )
              : _ConversationList(
                  conversationsAsync: conversationsAsync,
                  selectedConvId: null,
                  onTap: onSelectConversation,
                  l10n: l10n,
                ),
        ),
      ],
    );
  }
}

// ─── Shared widgets ────────────────────────────────────────────────────────────

class _InboxHeader extends StatelessWidget {
  const _InboxHeader({
    required this.pendingRequestCount,
    required this.showingContacts,
    required this.onFriendRequestsTap,
    required this.onNewConversationTap,
    required this.onToggleContacts,
    required this.l10n,
  });

  final int pendingRequestCount;
  final bool showingContacts;
  final VoidCallback onFriendRequestsTap;
  final VoidCallback onNewConversationTap;
  final VoidCallback onToggleContacts;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  l10n.messagingInboxTitle,
                  variant: AppTextVariant.headlineSmall,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
              // Friend requests icon
              if (pendingRequestCount > 0)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person_add_outlined),
                      color: AppTheme.primary,
                      tooltip: l10n.messagingIncomingRequests,
                      onPressed: onFriendRequestsTap,
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$pendingRequestCount',
                          style: TextStyle(
                            color: context.appColors.surface,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                IconButton(
                  icon: const Icon(Icons.person_add_outlined),
                  color: context.appColors.textMuted,
                  tooltip: l10n.messagingIncomingRequests,
                  onPressed: onFriendRequestsTap,
                ),
              // New conversation button — rounded bubble with plus
              IconButton(
                icon: const Icon(Icons.add_comment_rounded),
                color: AppTheme.primary,
                tooltip: l10n.messagingStartConversation,
                onPressed: onNewConversationTap,
              ),
            ],
          ),
        ),
        // Tab toggle: Conversations | Contacts
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: context.appColors.divider)),
          ),
          child: Row(
            children: [
              _TabButton(
                label: l10n.messagingInboxTitle,
                icon: Icons.chat_bubble_outline_rounded,
                selected: !showingContacts,
                onTap: showingContacts ? onToggleContacts : null,
              ),
              _TabButton(
                label: l10n.messagingContacts,
                icon: Icons.people_alt_outlined,
                selected: showingContacts,
                onTap: showingContacts ? null : onToggleContacts,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primary : context.appColors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppTheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              AppText(
                label,
                variant: AppTextVariant.bodySmall,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationList extends ConsumerWidget {
  const _ConversationList({
    required this.conversationsAsync,
    required this.selectedConvId,
    required this.onTap,
    required this.l10n,
  });

  final AsyncValue<List<Conversation>> conversationsAsync;
  final int? selectedConvId;
  final void Function(Conversation) onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return conversationsAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 40)),
            const SizedBox(height: 8),
            AppText(
              l10n.messagingError,
              variant: AppTextVariant.bodyMedium,
              color: AppTheme.error,
            ),
            AppTextButton(
              label: l10n.commonRetry,
              onPressed: () => ref.invalidate(conversationsProvider),
            ),
          ],
        ),
      ),
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: context.appColors.textMuted,
                  size: 48,
                ),
                const SizedBox(height: 12),
                AppText(
                  l10n.messagingNoConversations,
                  variant: AppTextVariant.bodyMedium,
                  color: context.appColors.textMuted,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conv = conversations[index];
            final isSelected = conv.convId == selectedConvId;
            return _ConversationTile(
              conversation: conv,
              isSelected: isSelected,
              onTap: () => onTap(conv),
            );
          },
        );
      },
    );
  }
}

class _EmptyThread extends StatelessWidget {
  const _EmptyThread({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(child: Icon(Icons.forum_outlined, size: 64, color: context.appColors.textMuted)),
          const SizedBox(height: 16),
          AppText(
            l10n.messagingSelectConversation,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          ),
        ],
      ),
    );
  }
}

// ─── Inline message thread ─────────────────────────────────────────────────────

class _InlineThread extends ConsumerStatefulWidget {
  const _InlineThread({
    required this.convId,
    required this.conv,
    required this.l10n,
  });

  final int convId;
  final Conversation conv;
  final AppLocalizations l10n;

  @override
  ConsumerState<_InlineThread> createState() => _InlineThreadState();
}

class _InlineThreadState extends ConsumerState<_InlineThread> {
  static const Duration _pollInterval = Duration(seconds: 3);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _pollTimer;
  int _lastMessageCount = -1;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void didUpdateWidget(_InlineThread oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.convId != widget.convId) {
      _lastMessageCount = -1;
      _restartPolling();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!mounted) return;
      ref.invalidate(messagesProvider(widget.convId));
      ref.invalidate(conversationsProvider);
    });
  }

  void _restartPolling() {
    _pollTimer?.cancel();
    _startPolling();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _deleteMessage(int messageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.messagingDeleteMessage),
        content: Text(widget.l10n.messagingDeleteMessageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(widget.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: Text(widget.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final api = ref.read(messagingApiProvider);
      await api.deleteMessage(widget.convId, messageId);
      ref.invalidate(messagesProvider(widget.convId));
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: widget.l10n.messagingError);
      }
    }
  }

  Future<void> _sendMessage(int currentUserId) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      final api = ref.read(messagingApiProvider);
      await api.sendMessage(widget.convId, {'body': text});
      _controller.clear();
      ref.invalidate(messagesProvider(widget.convId));
      ref.invalidate(conversationsProvider);
      _scrollToBottom();
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: widget.l10n.messagingSendError);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final messagesAsync = ref.watch(messagesProvider(widget.convId));
    final sessionAsync = ref.watch(participantSessionProvider);

    final currentUserId = sessionAsync.maybeWhen(
      data: (s) => s.viewingAs?.userId ?? s.user.accountId,
      orElse: () => -1,
    );

    messagesAsync.whenData((messages) {
      final shouldScroll =
          _lastMessageCount == -1 || messages.length > _lastMessageCount;
      if (shouldScroll) {
        _scrollToBottom();
      }
      _lastMessageCount = messages.length;
    });

    final otherName =
        widget.conv.otherParticipantName ??
        'User #${widget.conv.otherParticipantId}';

    return Column(
      children: [
        _buildThreadHeader(otherName),
        Expanded(child: _buildMessageList(l10n, messagesAsync, currentUserId)),
        _buildSendInput(l10n, currentUserId),
      ],
    );
  }

  Widget _buildThreadHeader(String otherName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
      ),
      child: Row(
        children: [
          AppUserAvatar(name: otherName, radius: 18),
          const SizedBox(width: 10),
          AppText(
            otherName,
            variant: AppTextVariant.headlineSmall,
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
    AppLocalizations l10n,
    AsyncValue<List<Message>> messagesAsync,
    int currentUserId,
  ) {
    return Container(
      color: context.appColors.surfaceSubtle,
      child: messagesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 40)),
              const SizedBox(height: 8),
              AppText(
                l10n.messagingError,
                variant: AppTextVariant.bodyMedium,
                color: AppTheme.error,
              ),
              AppTextButton(
                label: l10n.commonRetry,
                onPressed: () =>
                    ref.invalidate(messagesProvider(widget.convId)),
              ),
            ],
          ),
        ),
        data: (messages) {
          if (messages.isEmpty) {
            return Center(
              child: AppText(
                l10n.messagingNoMessages,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg.senderId == currentUserId;
              return _MessageBubble(
                message: msg,
                isMe: isMe,
                l10n: l10n,
                onDelete: isMe ? () => _deleteMessage(msg.messageId) : null,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSendInput(AppLocalizations l10n, int currentUserId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(top: BorderSide(color: context.appColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.messagingMessagePlaceholder,
                hintStyle: AppTheme.body.copyWith(color: context.appColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.appColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.appColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              onSubmitted: _sending ? null : (_) => _sendMessage(currentUserId),
            ),
          ),
          const SizedBox(width: 8),
          _sending
              ? const SizedBox(
                  width: 44,
                  height: 44,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: AppLoadingIndicator.inline(),
                  ),
                )
              : IconButton(
                  onPressed: () => _sendMessage(currentUserId),
                  icon: const Icon(Icons.send_rounded),
                  color: AppTheme.primary,
                  tooltip: l10n.messagingSend,
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: context.appColors.surface,
                  ),
                ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.isSelected,
    required this.onTap,
  });

  final Conversation conversation;
  final bool isSelected;
  final VoidCallback onTap;

  String _formatTime(DateTime? dt, BuildContext context) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return context.l10n.messagingJustNow;
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return DateFormat.Hm().format(dt);
    if (diff.inDays < 7) return DateFormat.E().format(dt);
    return DateFormat.yMd().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final name =
        conversation.otherParticipantName ??
        'User #${conversation.otherParticipantId}';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withAlpha(20)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: context.appColors.divider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            AppUserAvatar(name: name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTheme.body.copyWith(
                      fontWeight: (isSelected || conversation.unreadCount > 0)
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : context.appColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (conversation.lastMessage != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      conversation.lastMessage!,
                      style: AppTheme.captions.copyWith(
                        color: conversation.unreadCount > 0
                            ? context.appColors.textPrimary
                            : context.appColors.textMuted,
                        fontWeight: conversation.unreadCount > 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${conversation.unreadCount}',
                  style: TextStyle(
                    color: context.appColors.surface,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (conversation.lastMessageAt != null)
              Text(
                _formatTime(conversation.lastMessageAt, context),
                style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.l10n,
    this.onDelete,
  });

  final Message message;
  final bool isMe;
  final AppLocalizations l10n;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(message.sentAt.toLocal());
    final senderName = isMe ? l10n.messagingYou : (message.senderName ?? '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
            child: Text(
              senderName,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe && onDelete != null)
                Tooltip(
                  message: l10n.messagingDeleteMessage,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: context.appColors.textMuted,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primary : context.appColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe ? null : Border.all(color: context.appColors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.body,
                        style: AppTheme.body.copyWith(
                          color: isMe ? context.appColors.surface : context.appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: AppTheme.captions.copyWith(
                          color: isMe
                              ? context.appColors.surface.withAlpha(179)
                              : context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Friend requests bottom sheet ─────────────────────────────────────────────

/// Inline friend requests sheet — shown as a bottom sheet inside the messaging
/// scaffold so the user never leaves the main layout.
class _FriendRequestSheet extends ConsumerStatefulWidget {
  const _FriendRequestSheet();

  @override
  ConsumerState<_FriendRequestSheet> createState() =>
      _FriendRequestSheetState();
}

class _FriendRequestSheetState extends ConsumerState<_FriendRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sending = false;
  String? _sentMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendFriendRequest() async {
    if (_emailController.text.trim().isEmpty) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _sending = true;
      _sentMessage = null;
    });
    try {
      final api = ref.read(messagingApiProvider);
      await api.sendFriendRequest({'email': _emailController.text.trim()});
    } catch (_) {
      // Privacy: always show success message regardless of whether user exists
    }
    if (mounted) {
      setState(() {
        _sending = false;
        _sentMessage = context.l10n.messagingFriendRequestSent;
        _emailController.clear();
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

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => SizedBox.expand(
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  AppText(
                    l10n.messagingFriendRequestTitle,
                    variant: AppTextVariant.headlineSmall,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Divider(),
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSendRequestSection(l10n),
                  const SizedBox(height: 20),
                  _buildIncomingRequests(l10n, requestsAsync),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendRequestSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.messagingFriendRequestSend,
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: AppEmailInput(
              label: l10n.messagingFriendRequestEmail,
              controller: _emailController,
              hintText: l10n.messagingFriendEmailHint,
              isRequired: false,
            ),
          ),
          const SizedBox(height: 12),
          if (_sentMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(26),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.success.withAlpha(77)),
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
            const SizedBox(height: 8),
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
    );
  }

  Widget _buildIncomingRequests(
    AppLocalizations l10n,
    AsyncValue<List<FriendRequest>> requestsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.messagingIncomingRequests,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 8),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AppText(
                  l10n.messagingNoIncomingRequests,
                  variant: AppTextVariant.bodyMedium,
                  color: context.appColors.textMuted,
                ),
              );
            }
            return Column(
              children: requests.map((req) {
                final name = req.requesterName ?? 'User #${req.requesterId}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.appColors.divider),
                    ),
                    child: Row(
                      children: [
                        AppUserAvatar(name: name),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            name,
                            style: AppTheme.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        AppTextButton(
                          label: l10n.messagingAcceptRequest,
                          onPressed: () => _respond(req.requestId, 'accept'),
                        ),
                        AppTextButton(
                          label: l10n.messagingRejectRequest,
                          onPressed: () => _respond(req.requestId, 'reject'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ─── New conversation bottom sheet ────────────────────────────────────────────

/// Inline new conversation sheet — role-aware recipient selection shown as a
/// bottom sheet so the user never leaves the main messaging layout.
class _NewConversationSheet extends ConsumerStatefulWidget {
  const _NewConversationSheet({required this.onCreated});

  /// Called with the new conversation ID after creation. The sheet pops itself
  /// before calling this, so the parent can safely update state.
  final void Function(int convId) onCreated;

  @override
  ConsumerState<_NewConversationSheet> createState() =>
      _NewConversationSheetState();
}

class _NewConversationSheetState extends ConsumerState<_NewConversationSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adminIdController = TextEditingController();
  bool _creating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _adminIdController.dispose();
    super.dispose();
  }

  Future<void> _createConversation(int targetAccountId) async {
    if (_creating) return;
    setState(() => _creating = true);
    try {
      final api = ref.read(messagingApiProvider);
      final result = await api.createConversation({
        'target_account_id': targetAccountId,
      });
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCreated(result.convId);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.messagingSendError);
        setState(() => _creating = false);
      }
    }
  }

  Future<void> _createConversationByEmail(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty || _creating) return;
    setState(() => _creating = true);
    try {
      final api = ref.read(messagingApiProvider);
      final result = await api.createConversation({'target_email': trimmed});
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCreated(result.convId);
      }
    } catch (e) {
      if (mounted) {
        final status =
            e is DioException ? e.response?.statusCode : null;
        final msg = status == 404
            ? context.l10n.messagingEmailNotFound
            : status == 403
                ? context.l10n.messagingEmailPermission
                : context.l10n.messagingSendError;
        AppToast.showError(context, message: msg);
        setState(() => _creating = false);
      }
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

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => SizedBox.expand(
        child: _creating
            ? const AppLoadingIndicator()
            : Column(
                children: [
                  // Handle
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        AppText(
                          l10n.messagingNewConversationTitle,
                          variant: AppTextVariant.headlineSmall,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  // Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        AppText(
                          l10n.messagingSelectRecipient,
                          variant: AppTextVariant.bodyLarge,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(height: 16),
                        if (role == 'participant')
                          _SheetParticipantRecipients(
                            emailController: _emailController,
                            onCreateByEmail: _createConversationByEmail,
                            onCreate: _createConversation,
                          )
                        else if (role == 'hcp')
                          _SheetHcpRecipients(
                            emailController: _emailController,
                            onCreateByEmail: _createConversationByEmail,
                            onCreate: _createConversation,
                          )
                        else if (role == 'researcher')
                          _SheetResearcherRecipients(
                            emailController: _emailController,
                            onCreateByEmail: _createConversationByEmail,
                            onCreate: _createConversation,
                          )
                        else
                          _SheetAdminRecipients(
                            idController: _adminIdController,
                            onCreate: _createConversation,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Participant recipients: email input at top, then linked HCPs + friends below.
class _SheetParticipantRecipients extends ConsumerWidget {
  const _SheetParticipantRecipients({
    required this.emailController,
    required this.onCreateByEmail,
    required this.onCreate,
  });

  final TextEditingController emailController;
  final Future<void> Function(String) onCreateByEmail;
  final Future<void> Function(int) onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final linksAsync = ref.watch(hcpLinksProvider);
    final friendsAsync = ref.watch(friendsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Email input ────────────────────────────────────────────────────
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.messagingEmailLabel,
            hintText: l10n.messagingEmailHint,
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppFilledButton(
            label: l10n.messagingStartConversation,
            onPressed: () => onCreateByEmail(emailController.text.trim()),
          ),
        ),
        const SizedBox(height: 24),
        // ── Contacts ───────────────────────────────────────────────────────
        AppText(
          l10n.messagingOrPickFromContacts,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 12),
        AppText(
          l10n.messagingRecipientHcp,
          variant: AppTextVariant.bodySmall,
          fontWeight: FontWeight.w600,
          color: context.appColors.textMuted,
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
        const SizedBox(height: 20),
        AppText(
          l10n.messagingRecipientFriend,
          variant: AppTextVariant.bodySmall,
          fontWeight: FontWeight.w600,
          color: context.appColors.textMuted,
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

/// HCP recipients: email input at top, then linked patients below.
class _SheetHcpRecipients extends ConsumerWidget {
  const _SheetHcpRecipients({
    required this.emailController,
    required this.onCreateByEmail,
    required this.onCreate,
  });

  final TextEditingController emailController;
  final Future<void> Function(String) onCreateByEmail;
  final Future<void> Function(int) onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientsAsync = ref.watch(hcpPatientsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Email input ────────────────────────────────────────────────────
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.messagingEmailLabel,
            hintText: l10n.messagingEmailHint,
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppFilledButton(
            label: l10n.messagingStartConversation,
            onPressed: () => onCreateByEmail(emailController.text.trim()),
          ),
        ),
        const SizedBox(height: 24),
        // ── Patients list ──────────────────────────────────────────────────
        AppText(
          l10n.messagingOrPickFromPatients,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 12),
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
                final name = p['patient_name'] as String? ??
                    '${l10n.messagingRecipientPatient} #$id';
                return RecipientTile(
                  name: name,
                  icon: Icons.person_outlined,
                  onTap: () => onCreate(id),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Researcher recipients: email input at top, then contacts, then all researchers.
class _SheetResearcherRecipients extends ConsumerStatefulWidget {
  const _SheetResearcherRecipients({
    required this.emailController,
    required this.onCreateByEmail,
    required this.onCreate,
  });

  final TextEditingController emailController;
  final Future<void> Function(String) onCreateByEmail;
  final Future<void> Function(int) onCreate;

  @override
  ConsumerState<_SheetResearcherRecipients> createState() =>
      _SheetResearcherRecipientsState();
}

class _SheetResearcherRecipientsState
    extends ConsumerState<_SheetResearcherRecipients> {
  final _filterController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final friendsAsync = ref.watch(friendsProvider);
    final researchersAsync = ref.watch(allResearchersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Email input ────────────────────────────────────────────────────
        TextField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.messagingEmailLabel,
            hintText: l10n.messagingEmailHint,
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppFilledButton(
            label: l10n.messagingStartConversation,
            onPressed: () => widget.onCreateByEmail(widget.emailController.text.trim()),
          ),
        ),
        const SizedBox(height: 24),
        // ── Contacts (friends) ─────────────────────────────────────────────
        AppText(
          l10n.messagingOrPickFromContacts,
          variant: AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
        const SizedBox(height: 8),
        AppText(
          l10n.messagingRecipientFriend,
          variant: AppTextVariant.bodySmall,
          fontWeight: FontWeight.w600,
          color: context.appColors.textMuted,
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
                      onTap: () => widget.onCreate(f.accountId),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        // ── All researchers (with local filter) ────────────────────────────
        AppText(
          l10n.messagingRecipientResearcher,
          variant: AppTextVariant.bodySmall,
          fontWeight: FontWeight.w600,
          color: context.appColors.textMuted,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _filterController,
          decoration: InputDecoration(
            hintText: l10n.messagingSearchResearchers,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
          onChanged: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 8),
        researchersAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.messagingError,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (all) {
            final visible = _filter.isEmpty
                ? all
                : all
                    .where(
                      (r) => r.displayName
                          .toLowerCase()
                          .contains(_filter.toLowerCase()),
                    )
                    .toList();
            if (visible.isEmpty) {
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
              children: visible
                  .map(
                    (r) => RecipientTile(
                      name: r.displayName,
                      icon: Icons.science_outlined,
                      onTap: () => widget.onCreate(r.accountId),
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

/// Admin recipients: enter account ID directly.
class _SheetAdminRecipients extends StatelessWidget {
  const _SheetAdminRecipients({
    required this.idController,
    required this.onCreate,
  });

  final TextEditingController idController;
  final Future<void> Function(int) onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: idController,
          decoration: InputDecoration(
            labelText: l10n.messagingAdminAccountIdLabel,
            hintText: l10n.messagingAdminAccountIdHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppFilledButton(
          label: l10n.messagingStartConversation,
          onPressed: () {
            final id = int.tryParse(idController.text.trim());
            if (id != null && id > 0) {
              onCreate(id);
            }
          },
        ),
      ],
    );
  }
}

// ─── Contacts inline list ─────────────────────────────────────────────────────

class _ContactsList extends ConsumerWidget {
  const _ContactsList({
    required this.onStartConversation,
    required this.l10n,
  });

  final void Function(int convId) onStartConversation;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 40)),
            const SizedBox(height: 8),
            AppText(l10n.messagingError, color: AppTheme.error),
            AppTextButton(
              label: l10n.commonRetry,
              onPressed: () => ref.invalidate(friendsProvider),
            ),
          ],
        ),
      ),
      data: (friends) {
        if (friends.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    size: 48,
                    color: context.appColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    l10n.messagingNoContacts,
                    variant: AppTextVariant.bodyMedium,
                    color: context.appColors.textMuted,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: friends.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: context.appColors.divider),
          itemBuilder: (context, index) {
            final friend = friends[index];
            return _ContactTile(
              friend: friend,
              onStartConversation: onStartConversation,
              l10n: l10n,
            );
          },
        );
      },
    );
  }
}

class _ContactTile extends ConsumerWidget {
  const _ContactTile({
    required this.friend,
    required this.onStartConversation,
    required this.l10n,
  });

  final ResearcherResult friend;
  final void Function(int convId) onStartConversation;
  final AppLocalizations l10n;

  Future<void> _message(BuildContext context, WidgetRef ref) async {
    try {
      final api = ref.read(messagingApiProvider);
      final result = await api.createConversation({
        'target_account_id': friend.accountId,
      });
      if (context.mounted) {
        onStartConversation(result.convId);
        ref.invalidate(conversationsProvider);
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.showError(context, message: l10n.messagingSendError);
      }
    }
  }

  void _openDetail(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _EditContactDialog(
        friend: friend,
        l10n: l10n,
        onMessage: () => _message(context, ref),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _openDetail(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            AppUserAvatar(name: friend.displayName),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    friend.displayName,
                    variant: AppTextVariant.bodyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  if (friend.roleName.isNotEmpty)
                    AppText(
                      friend.roleName,
                      variant: AppTextVariant.bodySmall,
                      color: context.appColors.textMuted,
                    ),
                ],
              ),
            ),
            Tooltip(
              message: l10n.messagingStartConversation,
              child: IconButton(
                icon: const Icon(Icons.add_comment_rounded, size: 18),
                color: AppTheme.primary,
                onPressed: () => _message(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditContactDialog extends ConsumerWidget {
  const _EditContactDialog({
    required this.friend,
    required this.l10n,
    required this.onMessage,
  });

  final ResearcherResult friend;
  final AppLocalizations l10n;
  final VoidCallback onMessage;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.messagingDeleteContact),
        content: Text(l10n.messagingDeleteContactConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.messagingDeleteContact,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final api = ref.read(messagingApiProvider);
      await api.deleteContact(friend.accountId);
      ref.invalidate(friendsProvider);
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
      if (context.mounted) {
        AppToast.showError(context, message: l10n.messagingError);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = this.l10n;
    return AlertDialog(
      title: Row(
        children: [
          AppUserAvatar(name: friend.displayName),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              friend.displayName,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (friend.roleName.isNotEmpty) ...[
            AppText(
              friend.roleName,
              variant: AppTextVariant.bodySmall,
              color: context.appColors.textMuted,
            ),
            const SizedBox(height: 4),
          ],
          if (friend.email.isNotEmpty)
            AppText(
              friend.email,
              variant: AppTextVariant.bodySmall,
              color: context.appColors.textMuted,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _delete(context, ref),
          child: Text(
            l10n.messagingDeleteContact,
            style: const TextStyle(color: AppTheme.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}
