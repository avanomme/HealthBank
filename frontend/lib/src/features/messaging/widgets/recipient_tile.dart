// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/messaging/widgets/recipient_tile.dart
/// Shared recipient tile used in new-conversation and inbox sheets.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';

class RecipientTile extends StatelessWidget {
  const RecipientTile({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MergeSemantics(
        child: Semantics(
          container: true,
          button: true,
          label: context.l10n.messagingOpenConversationWith(name),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppTheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ExcludeSemantics(child: Icon(Icons.chevron_right, color: context.appColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
