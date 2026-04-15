// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/participant/widgets/notification_banner.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Notification banner widget for displaying alerts/messages
///
/// Matches the Figma design: Orange banner with message icon
/// "You have X new messages. Click to here to view."
class NotificationBanner extends StatelessWidget {
  const NotificationBanner({super.key, required this.messageCount, this.onTap});

  /// Number of new messages
  final int messageCount;

  /// Callback when banner is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (messageCount <= 0) {
      return const SizedBox.shrink();
    }

    final message = context.l10n.participantNotificationMessage(messageCount);

    return MergeSemantics(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message,
        button: onTap != null,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.caution,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(child: Icon(Icons.chat_bubble, color: context.appColors.surface, size: 20)),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: AppTheme.body.copyWith(color: context.appColors.surface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
