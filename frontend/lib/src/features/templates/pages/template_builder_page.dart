// Created with the Assistance of Claude Code
// frontend/lib/src/features/templates/pages/template_builder_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/question_bank/pages/question_bank_page.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';
import '../state/template_providers.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Template Builder Page
///
/// Allows researchers to create or edit survey templates.
/// Features:
/// - Set template title, description, and visibility
/// - Add questions from the question bank
/// - Reorder questions via drag and drop
/// - Remove questions from the template
/// - Toggle whether each template question is required
class TemplateBuilderPage extends ConsumerStatefulWidget {
  const TemplateBuilderPage({super.key, this.templateId});

  /// Template ID to edit (null for creating new template)
  final int? templateId;

  @override
  ConsumerState<TemplateBuilderPage> createState() =>
      _TemplateBuilderPageState();
}

class _TemplateBuilderPageState extends ConsumerState<TemplateBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBuilder();
    });
  }

  void _initializeBuilder() {
    final notifier = ref.read(templateBuilderProvider.notifier);

    if (widget.templateId != null) {
      // Edit mode - load existing template
      notifier.loadTemplate(widget.templateId!);
    } else {
      // Create mode - reset to empty state
      notifier.reset();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _syncControllersFromState(TemplateBuilderState state) {
    // Only sync if text differs to avoid cursor jumping
    if (_titleController.text != state.title) {
      _titleController.text = state.title;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
  }

  Future<void> _addQuestionsFromBank() async {
    // Pre-populate selection with existing template question IDs
    final existingIds = ref
        .read(templateBuilderProvider)
        .questions
        .map((q) => q.questionId)
        .toList();

    ref.read(selectedQuestionIdsProvider.notifier).clear();
    ref.read(selectedQuestionIdsProvider.notifier).selectAll(existingIds);
    ref.read(selectionModeProvider.notifier).state = true;

    final result = await Navigator.of(context).push<List<Question>>(
      PageRouteBuilder<List<Question>>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => QuestionBankPage(
          selectionMode: true,
          onQuestionsSelected: (questions) {
            Navigator.pop(context, questions);
          },
        ),
      ),
    );

    // Always clear transient selection-mode state after returning
    ref.read(selectionModeProvider.notifier).state = false;
    ref.read(selectedQuestionIdsProvider.notifier).clear();

    if (result != null && result.isNotEmpty) {
      ref.read(templateBuilderProvider.notifier).addQuestions(result);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final template = await ref.read(templateBuilderProvider.notifier).save();

    if (template != null && mounted) {
      AppToast.showSuccess(
        context,
        message: widget.templateId != null
            ? context.l10n.templateBuilderUpdatedSuccess
            : context.l10n.templateBuilderCreatedSuccess,
      );
      Navigator.pop(context, template);
    }
  }

  String _localizedResponseType(BuildContext context, String responseType) {
    switch (responseType) {
      case 'number':
        return context.l10n.questionTypeNumber;
      case 'yesno':
        return context.l10n.questionTypeYesNo;
      case 'openended':
        return context.l10n.questionTypeOpenEnded;
      case 'single_choice':
        return context.l10n.questionTypeSingleChoice;
      case 'multi_choice':
        return context.l10n.questionTypeMultiChoice;
      case 'scale':
        return context.l10n.questionTypeScale;
      default:
        return responseType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateBuilderProvider);

    // Sync controllers when state changes (for edit mode)
    _syncControllersFromState(state);

    return ResearcherScaffold(
      currentRoute: '/templates',
      alignment: AppPageAlignment.wide,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      child: Column(
        children: [
          // Action bar with title and buttons
          _buildActionBar(state),
          // Main content
          Expanded(
            child: state.isLoading && state.questions.isEmpty
                ? const Center(child: AppLoadingIndicator())
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: AppPageAlignedContent(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (state.errorMessage != null)
                                _buildErrorBanner(state.errorMessage!),
                              _buildFormSection(state),
                              const SizedBox(height: 12),
                              _buildQuestionsSection(state),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Action bar with title and action buttons (replaces AppBar)
  Widget _buildActionBar(TemplateBuilderState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.appColors.divider.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackBar = constraints.maxWidth < 640 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.25;
          final title = Semantics(
            header: true,
            child: Text(
              state.isEditMode
                  ? context.l10n.templateBuilderEditTitle
                  : context.l10n.templateBuilderNewTitle,
              style: AppTheme.heading4,
            ),
          );
          final saveButton = AppFilledButton(
            label: state.isLoading ? '...' : context.l10n.templateBuilderSave,
            onPressed: state.isLoading ? null : _save,
            backgroundColor: AppTheme.primary,
            textColor: AppTheme.textContrast,
          );

          if (stackBar) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: context.l10n.templateBuilderBack,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: title),
                  ],
                ),
                const SizedBox(height: 12),
                saveButton,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: context.l10n.templateBuilderBack,
              ),
              const SizedBox(width: 8),
              Expanded(child: title),
              const SizedBox(width: 12),
              saveButton,
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: AppTheme.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
          IconButton(
            tooltip: context.l10n.tooltipClose,
            icon: const Icon(Icons.close, size: 18),
            onPressed: () =>
                ref.read(templateBuilderProvider.notifier).clearError(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(TemplateBuilderState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: context.l10n.templateBuilderTitleLabel,
              hintText: context.l10n.templateBuilderTitleHint,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.templateBuilderTitleRequired;
              }
              return null;
            },
            onChanged: (value) =>
                ref.read(templateBuilderProvider.notifier).setTitle(value),
          ),
          const SizedBox(height: 16),
          // Description field
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: context.l10n.templateBuilderDescriptionLabel,
              hintText: context.l10n.templateBuilderDescriptionHint,
              border: const OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (value) => ref
                .read(templateBuilderProvider.notifier)
                .setDescription(value),
          ),
          const SizedBox(height: 16),
          // Visibility toggle
          SwitchListTile(
            title: Text(context.l10n.templateBuilderPublicLabel),
            subtitle: Text(context.l10n.templateBuilderPublicSubtitle),
            value: state.isPublic,
            onChanged: (value) =>
                ref.read(templateBuilderProvider.notifier).setIsPublic(value),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection(TemplateBuilderState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackHeader = constraints.maxWidth < 560 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.2;
              final summary = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ExcludeSemantics(child: Icon(Icons.quiz_outlined, size: 20)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.l10n.templateBuilderQuestionsCount(
                        state.questions.length,
                      ),
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
              final addButton = AppFilledButton(
                label: context.l10n.templateBuilderAddQuestions,
                onPressed: _addQuestionsFromBank,
                backgroundColor: AppTheme.secondary,
                textColor: AppTheme.textContrast,
              );

              if (stackHeader) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [summary, const SizedBox(height: 12), addButton],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: summary),
                  const SizedBox(width: 12),
                  addButton,
                ],
              );
            },
          ),
        ),
        if (state.questions.isEmpty)
          _buildEmptyQuestionsState()
        else
          _buildQuestionsList(state),
      ],
    );
  }

  Widget _buildEmptyQuestionsState() {
    return AppEmptyState(
      icon: Icons.quiz_outlined,
      title: context.l10n.templateBuilderNoQuestions,
      subtitle: context.l10n.templateBuilderAddQuestionsHint,
    );
  }

  Widget _buildQuestionsList(TemplateBuilderState state) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.questions.length,
      onReorder: (oldIndex, newIndex) {
        ref
            .read(templateBuilderProvider.notifier)
            .reorderQuestions(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final question = state.questions[index];
        return _buildQuestionTile(question, index);
      },
    );
  }

  Widget _buildQuestionTile(TemplateQuestionItem question, int index) {
    return Card(
      key: ValueKey(question.questionId),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stackTile = constraints.maxWidth < 560 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.2;

            final removeButton = IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: AppTheme.error,
              ),
              onPressed: () {
                ref
                    .read(templateBuilderProvider.notifier)
                    .removeQuestion(question.questionId);
              },
              tooltip: context.l10n.templateBuilderRemoveQuestion,
            );

            final orderBadge = Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );

            final infoColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title ?? question.questionContent,
                  style: AppTheme.body.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _localizedResponseType(context, question.responseType),
                        style: AppTheme.captions.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (question.isRequired)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          context.l10n.questionFormRequiredLabel,
                          style: AppTheme.captions.copyWith(
                            color: AppTheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(context.l10n.questionFormRequiredLabel),
                  subtitle: Text(
                    question.isRequired
                      ? context.l10n.templateBuilderQuestionRequiredSubtitle
                      : context.l10n.templateBuilderQuestionOptionalSubtitle,
                    style: AppTheme.captions.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                  value: question.isRequired,
                  onChanged: (value) {
                    ref
                        .read(templateBuilderProvider.notifier)
                        .setQuestionRequired(question.questionId, value);
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            );

            final moveButtons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  tooltip: context.l10n.reorderMoveUp,
                  onPressed: index > 0
                      ? () => ref
                            .read(templateBuilderProvider.notifier)
                            .reorderQuestions(index, index - 1)
                      : null,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  tooltip: context.l10n.reorderMoveDown,
                  onPressed: index < ref.read(templateBuilderProvider).questions.length - 1
                      ? () => ref
                            .read(templateBuilderProvider.notifier)
                            .reorderQuestions(index, index + 2)
                      : null,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            );

            if (stackTile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_handle,
                          color: context.appColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      orderBadge,
                      const Spacer(),
                      moveButtons,
                      removeButton,
                    ],
                  ),
                  const SizedBox(height: 12),
                  infoColumn,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_handle,
                    color: context.appColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                orderBadge,
                const SizedBox(width: 12),
                Expanded(child: infoColumn),
                const SizedBox(width: 8),
                moveButtons,
                removeButton,
              ],
            );
          },
        ),
      ),
    );
  }
}