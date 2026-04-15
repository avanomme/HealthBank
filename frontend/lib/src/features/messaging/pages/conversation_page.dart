// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/pages/conversation_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/messaging/widgets/messaging_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantSessionProvider;

/// Chat conversation page showing messages with a specific user.
///
/// Displays messages as chat bubbles with send input at the bottom.
class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key, required this.convId});

  final int convId;

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
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
  void didUpdateWidget(covariant ConversationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.convId != widget.convId) {
      _lastMessageCount = -1;
      _restartPolling();
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

  Future<void> _sendMessage(int currentUserId) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      final api = ref.read(messagingApiProvider);
      await api.sendMessage(widget.convId, {'body': text});
      _controller.clear();
      ref.invalidate(messagesProvider(widget.convId));
      _scrollToBottom();
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: context.l10n.messagingSendError);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final messagesAsync = ref.watch(messagesProvider(widget.convId));
    final sessionAsync = ref.watch(participantSessionProvider);

    final currentUserId = sessionAsync.maybeWhen(
      data: (s) => s.viewingAs?.userId ?? s.user.accountId,
      orElse: () => -1,
    );

    // Auto-scroll on first load and when new messages arrive.
    messagesAsync.whenData((messages) {
      final shouldScroll =
          _lastMessageCount == -1 || messages.length > _lastMessageCount;
      if (shouldScroll) {
        _scrollToBottom();
      }
      _lastMessageCount = messages.length;
    });

    return MessagingScaffold(
      alignment: AppPageAlignment.regular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: Column(
        children: [
          _buildPageHeader(l10n),
          Expanded(
            child: AppPageAlignedContent(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildMessagesList(
                        l10n,
                        messagesAsync,
                        currentUserId,
                      ),
                    ),
                    _buildSendInput(l10n, currentUserId),
                  ],
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
              l10n.messagingConversationTitle,
              variant: AppTextVariant.headlineSmall,
              fontWeight: FontWeight.w600,
              color: context.appColors.surface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(
    AppLocalizations l10n,
    AsyncValue<List<Message>> messagesAsync,
    int currentUserId,
  ) {
    return messagesAsync.when(
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicator(centered: false),
            const SizedBox(height: 12),
            AppText(
              l10n.messagingLoading,
              variant: AppTextVariant.bodyMedium,
              color: context.appColors.textMuted,
            ),
          ],
        ),
      ),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 48)),
            const SizedBox(height: 8),
            AppText(
              l10n.messagingError,
              variant: AppTextVariant.bodyMedium,
              color: AppTheme.error,
            ),
            const SizedBox(height: 8),
            AppTextButton(
              label: l10n.commonRetry,
              onPressed: () => ref.invalidate(messagesProvider(widget.convId)),
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
            return _MessageBubble(message: msg, isMe: isMe, l10n: l10n);
          },
        );
      },
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.l10n,
  });

  final Message message;
  final bool isMe;
  final AppLocalizations l10n;

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
          // Sender name
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
          // Bubble
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
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
