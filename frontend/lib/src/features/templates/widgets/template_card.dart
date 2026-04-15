// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/templates/widgets/template_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/widgets.dart';

/// A card widget that displays a survey template.
///
/// Supports two modes:
/// - Selection mode: tap to select template (for creating surveys)
/// - Normal mode: shows action menu, tap to view/edit
class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.template,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onCreateSurvey,
    this.onPreview,
    this.onDelete,
  });

  /// The template to display
  final Template template;

  /// Whether this card is currently selected (selection mode only)
  final bool isSelected;

  /// Whether selection mode is active
  final bool selectionMode;

  /// Called when the card is tapped
  final VoidCallback? onTap;

  /// Called when edit action is selected
  final VoidCallback? onEdit;

  /// Called when duplicate action is selected
  final VoidCallback? onDuplicate;

  /// Called when create survey action is selected
  final VoidCallback? onCreateSurvey;

  /// Called when preview action is selected
  final VoidCallback? onPreview;

  /// Called when delete action is selected
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final questionCount =
        template.questionCount ?? template.questions?.length ?? 0;
    final cardSummary =
        '${template.title}. ${template.isPublic ? context.l10n.templateListPublic : context.l10n.templateListPrivate}. ${context.l10n.templateCardQuestionCount(questionCount)}.';

    return MergeSemantics(
      child: Semantics(
        container: true,
        button: onTap != null,
        selected: selectionMode ? isSelected : null,
        label: cardSummary,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? const BorderSide(color: AppTheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIcon(),
                      const SizedBox(width: 12),
                      Expanded(child: _buildContent(context)),
                      if (!selectionMode) _buildActionsMenu(context),
                    ],
                  ),
                  if (template.description != null &&
                      template.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      template.description!,
                      style: AppTheme.body.copyWith(
                        color: context.appColors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const AppIconBadge(
      icon: Icons.description_outlined,
      size: 40,
      iconSize: 24,
    );
  }

  Widget _buildContent(BuildContext context) {
    final questionCount =
        template.questionCount ?? template.questions?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          template.title,
          style: AppTheme.body.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              template.isPublic ? Icons.public : Icons.lock_outline,
              size: 14,
              color: context.appColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              template.isPublic
                  ? context.l10n.templateListPublic
                  : context.l10n.templateListPrivate,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.quiz_outlined,
              size: 14,
              color: context.appColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.templateCardQuestionCount(questionCount),
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
          ],
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
          value: 'preview',
          icon: Icons.visibility_outlined,
          label: context.l10n.templateCardPreview,
        ),
        appPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.templateCardEdit,
        ),
        appPopupMenuItem(
          value: 'duplicate',
          icon: Icons.copy_outlined,
          label: context.l10n.templateCardDuplicate,
        ),
        appPopupMenuItem(
          value: 'create_survey',
          icon: Icons.add_box_outlined,
          label: context.l10n.templateCardCreateSurvey,
        ),
        const PopupMenuDivider(),
        appPopupMenuItemDestructive(
          value: 'delete',
          icon: Icons.delete_outline,
          label: context.l10n.templateCardDelete,
        ),
      ],
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'preview':
        onPreview?.call();
      case 'edit':
        onEdit?.call();
      case 'duplicate':
        onDuplicate?.call();
      case 'create_survey':
        onCreateSurvey?.call();
      case 'delete':
        onDelete?.call();
    }
  }
}
