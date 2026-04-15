// Created with the Assistance of Claude Code
// frontend/lib/src/features/surveys/widgets/question_bank_import_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show questionsProvider, localizedResponseTypeLabels;

/// Modal dialog for importing questions from the question bank into a survey.
///
/// Shows a searchable, multi-select list of all questions. Questions already
/// in the survey are shown with a checkmark and are non-selectable.
class QuestionBankImportDialog extends ConsumerStatefulWidget {
  const QuestionBankImportDialog({
    super.key,
    required this.existingQuestionIds,
  });

  /// IDs of questions already in the survey (shown as "already added")
  final Set<int> existingQuestionIds;

  /// Show the dialog and return selected questions (or null on cancel)
  static Future<List<Question>?> show(
    BuildContext context, {
    required Set<int> existingQuestionIds,
  }) {
    return showDialog<List<Question>>(
      context: context,
      builder: (context) => QuestionBankImportDialog(
        existingQuestionIds: existingQuestionIds,
      ),
    );
  }

  @override
  ConsumerState<QuestionBankImportDialog> createState() =>
      _QuestionBankImportDialogState();
}

class _QuestionBankImportDialogState
    extends ConsumerState<QuestionBankImportDialog> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.library_add_outlined, size: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        context.l10n.surveyBuilderImportDialogTitle,
                        style: AppTheme.heading4,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.tooltipClose,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: context.l10n.commonSearch,
                  hintText: context.l10n.surveyBuilderImportDialogSearch,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value.toLowerCase()),
              ),
            ),

            const Divider(height: 1),

            // Question list
            Expanded(
              child: questionsAsync.when(
                data: (questions) {
                  final filtered = _searchQuery.isEmpty
                      ? questions
                      : questions.where((q) {
                          final title = (q.title ?? '').toLowerCase();
                          final content = q.questionContent.toLowerCase();
                          return title.contains(_searchQuery) ||
                              content.contains(_searchQuery);
                        }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        context.l10n.surveyBuilderNoQuestionsInBank,
                        style: AppTheme.body
                            .copyWith(color: context.appColors.textMuted),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final question = filtered[index];
                      final isAlreadyAdded = widget.existingQuestionIds
                          .contains(question.questionId);
                      final isSelected =
                          _selectedIds.contains(question.questionId);

                      return ListTile(
                        leading: isAlreadyAdded
                            ? Icon(Icons.check_circle,
                                color: AppTheme.success.withValues(alpha: 0.6),
                                size: 22)
                            : Checkbox(
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedIds.add(question.questionId);
                                    } else {
                                      _selectedIds.remove(question.questionId);
                                    }
                                  });
                                },
                                activeColor: AppTheme.primary,
                              ),
                        title: Text(
                          question.title ?? question.questionContent,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isAlreadyAdded
                                ? context.appColors.textMuted
                                : null,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            _buildTag(
                              localizedResponseTypeLabels(context.l10n)[question.responseType] ??
                                  question.responseType,
                              AppTheme.primary,
                            ),
                            if (isAlreadyAdded) ...[
                              const SizedBox(width: 6),
                              _buildTag(
                                context
                                    .l10n.surveyBuilderImportDialogAlreadyAdded,
                                context.appColors.textMuted,
                              ),
                            ],
                          ],
                        ),
                        enabled: !isAlreadyAdded,
                        onTap: isAlreadyAdded
                            ? null
                            : () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedIds.remove(question.questionId);
                                  } else {
                                    _selectedIds.add(question.questionId);
                                  }
                                });
                              },
                      );
                    },
                  );
                },
                loading: () =>
                    const AppLoadingIndicator(),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ExcludeSemantics(child: Icon(Icons.error_outline,
                          color: AppTheme.error, size: 40)),
                      const SizedBox(height: 8),
                      Text(context.l10n.surveyBuilderFailedToLoadQuestions),
                      AppTextButton(
                        label: context.l10n.commonRetry,
                        onPressed: () => ref.invalidate(questionsProvider),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppTextButton(
                    label: context.l10n.commonCancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  AppFilledButton(
                    label: context.l10n.surveyBuilderImportDialogAddSelected(
                        _selectedIds.length),
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () {
                            final allQuestions =
                                ref.read(questionsProvider).valueOrNull ?? [];
                            final selected = allQuestions
                                .where((q) =>
                                    _selectedIds.contains(q.questionId))
                                .toList();
                            Navigator.of(context).pop(selected);
                          },
                    backgroundColor: AppTheme.primary,
                    textColor: AppTheme.textContrast,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTheme.captions.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
