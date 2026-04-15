// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/question_bank/widgets/question_bank_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/widgets.dart';
import '../state/question_providers.dart';

/// A card widget that displays a question from the question bank.
///
/// Supports two modes:
/// - Selection mode: shows checkbox, tap to select/deselect
/// - Normal mode: shows action menu, tap to view details
class QuestionBankCard extends StatelessWidget {
  const QuestionBankCard({
    super.key,
    required this.question,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onSelectionChanged,
    this.onEdit,
    this.onDuplicate,
    this.onDelete,
  });

  /// The question to display
  final Question question;

  /// Whether this card is currently selected (selection mode only)
  final bool isSelected;

  /// Whether selection mode is active
  final bool selectionMode;

  /// Called when the card is tapped (normal mode)
  final VoidCallback? onTap;

  /// Called when selection state changes (selection mode)
  final ValueChanged<bool>? onSelectionChanged;

  /// Called when edit action is selected
  final VoidCallback? onEdit;

  /// Called when duplicate action is selected
  final VoidCallback? onDuplicate;

  /// Called when delete action is selected
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final responseTypeLabel =
        localizedResponseTypeLabels(context.l10n)[question.responseType] ??
        question.responseType;
    final cardSummary = [
      question.title,
      question.questionContent,
      responseTypeLabel,
      if (question.isRequired) context.l10n.questionCardRequired,
    ].whereType<String>().join('. ');

    return MergeSemantics(
      child: Semantics(
        container: true,
        button: true,
        selected: selectionMode ? isSelected : null,
        label: cardSummary,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? const BorderSide(color: AppTheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (value) =>
                            onSelectionChanged?.call(value ?? false),
                        activeColor: AppTheme.primary,
                      ),
                    ),
                  _buildTypeIcon(),
                  const SizedBox(width: 16),
                  Expanded(child: _buildContent(context)),
                  if (!selectionMode) _buildActionsMenu(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (selectionMode) {
      onSelectionChanged?.call(!isSelected);
    } else {
      onTap?.call();
    }
  }

  Widget _buildTypeIcon() {
    return AppIconBadge(icon: _getIconForType(question.responseType));
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.title != null)
          Text(
            question.title!,
            style: AppTheme.body.copyWith(fontWeight: FontWeight.w600),
          ),
        Text(
          question.questionContent,
          style: AppTheme.body.copyWith(
            color: question.title != null
                ? context.appColors.textMuted
                : context.appColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildTags(context),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        AppColoredTag(
          label:
              localizedResponseTypeLabels(
                context.l10n,
              )[question.responseType] ??
              question.responseType,
          color: AppTheme.primary,
        ),
        if (question.category != null)
          AppColoredTag(label: question.category!, color: AppTheme.secondary),
        if (question.isRequired)
          AppColoredTag(
            label: context.l10n.questionCardRequired,
            icon: Icons.star_rounded,
            color: AppTheme.error,
          ),
      ],
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: _handleAction,
      itemBuilder: (ctx) => [
        appPopupMenuItem(
          value: 'edit',
          icon: Icons.edit,
          label: context.l10n.questionCardEdit,
        ),
        appPopupMenuItem(
          value: 'duplicate',
          icon: Icons.copy,
          label: context.l10n.questionCardDuplicate,
        ),
        appPopupMenuItemDestructive(
          value: 'delete',
          icon: Icons.delete,
          label: context.l10n.questionCardDelete,
        ),
      ],
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'edit':
        onEdit?.call();
      case 'duplicate':
        onDuplicate?.call();
      case 'delete':
        onDelete?.call();
    }
  }

  IconData _getIconForType(String responseType) {
    switch (responseType) {
      case 'number':
        return Icons.numbers;
      case 'yesno':
        return Icons.toggle_on;
      case 'openended':
        return Icons.text_fields;
      case 'single_choice':
        return Icons.radio_button_checked;
      case 'multi_choice':
        return Icons.check_box;
      case 'scale':
        return Icons.linear_scale;
      default:
        return Icons.help_outline;
    }
  }
}
