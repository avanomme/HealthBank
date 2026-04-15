// Created with the Assistance of Claude Code
// frontend/lib/src/features/surveys/pages/survey_builder_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
//import 'package:frontend/src/core/widgets/basics/basics.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/templates/pages/template_list_page.dart';
import '../state/survey_providers.dart'
    show surveyBuilderProvider, SurveyBuilderState, AutoSaveStatus;
import '../widgets/survey_preview_dialog.dart';
import '../widgets/survey_question_card.dart';
import '../widgets/question_bank_import_dialog.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Google Forms-style Survey Builder Page
///
/// Single-column centered layout where researchers can:
/// - Set survey title, description, and date range in a header card
/// - Add questions inline (created via API on confirm)
/// - Import questions from the question bank via a dialog
/// - Import from templates
/// - Reorder questions via drag handles
/// - Preview, save draft, and publish
class SurveyBuilderPage extends ConsumerStatefulWidget {
  const SurveyBuilderPage({super.key, this.surveyId, this.templateId});

  final int? surveyId;
  final int? templateId;

  @override
  ConsumerState<SurveyBuilderPage> createState() => _SurveyBuilderPageState();
}

class _SurveyBuilderPageState extends ConsumerState<SurveyBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  int? _focusedCardIndex;
  bool _hasDraftQuestion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBuilder();
    });
  }

  @override
  void didUpdateWidget(SurveyBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surveyId != widget.surveyId ||
        oldWidget.templateId != widget.templateId) {
      _initializeBuilder();
    }
  }

  void _initializeBuilder() {
    final notifier = ref.read(surveyBuilderProvider.notifier);
    notifier.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _focusedCardIndex = null;
      _hasDraftQuestion = false;
    });

    if (widget.surveyId != null) {
      notifier.loadSurvey(widget.surveyId!);
    } else if (widget.templateId != null) {
      notifier.loadFromTemplate(widget.templateId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _syncControllersFromState(SurveyBuilderState state) {
    if (_titleController.text != state.title) {
      _titleController.text = state.title;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
  }

  void _clearFocusedQuestion() {
    if (_focusedCardIndex != null || _hasDraftQuestion) {
      setState(() {
        _focusedCardIndex = null;
        _hasDraftQuestion = false;
      });
    }
  }

  // ─── Actions ───

  Future<void> _selectStartDate() async {
    final state = ref.read(surveyBuilderProvider);
    final date = await showDatePicker(
      context: context,
      initialDate: state.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      ref.read(surveyBuilderProvider.notifier).setStartDate(date);
    }
  }

  Future<void> _selectEndDate() async {
    final state = ref.read(surveyBuilderProvider);
    final date = await showDatePicker(
      context: context,
      initialDate: state.endDate ?? state.startDate ?? DateTime.now(),
      firstDate: state.startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      ref.read(surveyBuilderProvider.notifier).setEndDate(date);
    }
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final survey = await ref.read(surveyBuilderProvider.notifier).saveDraft();

    if (survey != null && mounted) {
      AppToast.showSuccess(
        context,
        message: widget.surveyId != null
            ? context.l10n.surveyBuilderUpdatedSuccess
            : context.l10n.surveyBuilderSavedAsDraft,
      );
      Navigator.pop(context, survey);
    }
  }

  Future<void> _saveAndPublish() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(surveyBuilderProvider);
    if (!state.hasQuestions) {
      AppToast.showError(
        context,
        message: context.l10n.surveyBuilderAddQuestionsFirst,
      );
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.surveyPublishTitle,
      content: context.l10n.surveyBuilderPublishConfirmMessage,
      confirmLabel: context.l10n.surveyPublishButton,
      cancelLabel: context.l10n.commonCancel,
      confirmColor: AppTheme.secondary,
    );

    if (!confirmed) return;

    final survey = await ref
        .read(surveyBuilderProvider.notifier)
        .saveAndPublish();

    if (survey != null && mounted) {
      AppToast.showSuccess(
        context,
        message: context.l10n.surveyBuilderPublishedSuccess,
      );
      Navigator.pop(context, survey);
    }
  }

  Future<void> _useTemplate() async {
    final result = await Navigator.push<Template>(
      context,
      PageRouteBuilder<Template>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => TemplateListPage(
          selectionMode: true,
          onTemplateSelected: (template) {
            Navigator.pop(context, template);
          },
        ),
      ),
    );

    if (result != null && mounted) {
      await ref
          .read(surveyBuilderProvider.notifier)
          .loadFromTemplate(result.templateId);

      if (mounted) {
        AppToast.showSuccess(
          context,
          message: context.l10n.surveyBuilderTemplateLoaded(result.title),
        );
      }
    }
  }

  Future<void> _importFromQuestionBank() async {
    final state = ref.read(surveyBuilderProvider);
    final existingIds = state.questions.map((q) => q.questionId).toSet();

    final selected = await QuestionBankImportDialog.show(
      context,
      existingQuestionIds: existingIds,
    );

    if (selected != null && selected.isNotEmpty && mounted) {
      ref.read(surveyBuilderProvider.notifier).addQuestions(selected);
      AppToast.showSuccess(
        context,
        message: context.l10n.surveyBuilderQuestionsImported(selected.length),
      );
    }
  }

  void _addNewDraftQuestion() {
    setState(() {
      _hasDraftQuestion = true;
      _focusedCardIndex = null;
    });
    // Scroll to bottom after frame to show the new draft card
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

  // ─── Build ───

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyBuilderProvider);
    _syncControllersFromState(state);

    return ResearcherScaffold(
      currentRoute: '/surveys',
      alignment: AppPageAlignment.wide,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      child: Column(
        children: [
          _buildActionBar(state),
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
                        child: _buildFormContent(state),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─── Action Bar ───

  Widget _buildActionBar(SurveyBuilderState state) {
    final showAutoSave = state.autoSaveStatus != AutoSaveStatus.idle;

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
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          final stackActions = constraints.maxWidth < 760 || textScale > 1.25;
          final titleText = Semantics(
            header: true,
            child: Text(
              state.isEditMode
                  ? context.l10n.surveyBuilderEditTitle
                  : context.l10n.surveyBuilderNewTitle,
              style: AppTheme.heading4,
            ),
          );
          final previewButton = IconButton(
            icon: const Icon(Icons.preview_outlined),
            tooltip: context.l10n.surveyBuilderPreview,
            onPressed: state.questions.isEmpty
                ? null
                : () => showSurveyPreview(
                      context,
                      title: state.title.isEmpty
                          ? context.l10n.surveyBuilderUntitledSurvey
                          : state.title,
                      description: state.description,
                      questions: state.questions,
                    ),
          );

          final isPublished = state.publicationStatus == 'published';
          final isClosed = state.publicationStatus == 'closed';
          final showPublishButton = !isPublished && !isClosed;
          final primarySaveLabel = isPublished || isClosed ? context.l10n.surveyBuilderUpdateSurvey : context.l10n.surveyBuilderSaveDraft;

          final actionButtons = Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              previewButton,
              AppOutlinedButton(
                label: primarySaveLabel,
                onPressed: state.isLoading ? null : _saveDraft,
              ),
              if (showPublishButton)
                AppFilledButton(
                  label: context.l10n.surveyBuilderPublish,
                  onPressed: state.isLoading ? null : _saveAndPublish,
                  backgroundColor: AppTheme.secondary,
                  textColor: AppTheme.textContrast,
                ),
            ],
          );

          if (stackActions) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: context.l10n.surveyBuilderBack,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: titleText),
                  ],
                ),
                if (showAutoSave) ...[
                  const SizedBox(height: 8),
                  _buildAutoSaveIndicator(state.autoSaveStatus),
                ],
                const SizedBox(height: 12),
                actionButtons,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: context.l10n.surveyBuilderBack,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    titleText,
                    if (showAutoSave)
                      _buildAutoSaveIndicator(state.autoSaveStatus),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Align(
                alignment: Alignment.topRight,
                child: actionButtons,
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Main Content ───

  Widget _buildFormContent(SurveyBuilderState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (state.errorMessage != null) _buildErrorBanner(state),
          _buildTitleCard(state),
          const SizedBox(height: 12),
          if (state.questions.isNotEmpty) _buildQuestionList(state),
          if (_hasDraftQuestion)
            SurveyQuestionCard(
              key: const ValueKey('draft'),
              question: null,
              index: state.questions.length,
              isFocused: true,
              onFocus: () {},
              onDelete: () => setState(() => _hasDraftQuestion = false),
              onQuestionCreated: (question) {
                setState(() {
                  _hasDraftQuestion = false;
                  _focusedCardIndex = state.questions.length - 1;
                });
              },
              isDraft: true,
            ),
          if (state.questions.isEmpty && !_hasDraftQuestion) _buildEmptyState(),
          const SizedBox(height: 12),
          _buildAddQuestionButton(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // ─── Title Card ───

  Widget _buildTitleCard(SurveyBuilderState state) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Colored top accent bar
          Container(height: 10, color: AppTheme.primary),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                TextFormField(
                  controller: _titleController,
                  style: AppTheme.heading4,
                  decoration: InputDecoration(
                    hintText: context.l10n.surveyBuilderTitleHint,
                    hintStyle: AppTheme.heading4.copyWith(
                      color: context.appColors.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.appColors.divider),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.surveyBuilderTitleRequired;
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      ref.read(surveyBuilderProvider.notifier).setTitle(value),
                ),
                const SizedBox(height: 12),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  style: AppTheme.body,
                  decoration: InputDecoration(
                    hintText: context.l10n.surveyBuilderDescriptionHint,
                    hintStyle: AppTheme.body.copyWith(
                      color: context.appColors.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.appColors.divider),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primary),
                    ),
                  ),
                  maxLines: 2,
                  onChanged: (value) => ref
                      .read(surveyBuilderProvider.notifier)
                      .setDescription(value),
                ),
                const SizedBox(height: 16),

                // Date range row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stackDateFields = constraints.maxWidth < 520 ||
                        MediaQuery.textScalerOf(context).scale(1) > 1.2;

                    if (stackDateFields) {
                      return Column(
                        children: [
                          _buildDateField(
                            label: context.l10n.surveyBuilderStartDate,
                            value: state.startDate,
                            onTap: _selectStartDate,
                          ),
                          const SizedBox(height: 12),
                          _buildDateField(
                            label: context.l10n.surveyBuilderEndDate,
                            value: state.endDate,
                            onTap: _selectEndDate,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: context.l10n.surveyBuilderStartDate,
                            value: state.startDate,
                            onTap: _selectStartDate,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            label: context.l10n.surveyBuilderEndDate,
                            value: state.endDate,
                            onTap: _selectEndDate,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          isDense: true,
        ),
        child: Text(
          value != null
              ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'
              : context.l10n.surveyBuilderSelectDate,
          style: value != null
              ? AppTheme.body
              : AppTheme.body.copyWith(color: context.appColors.textMuted),
        ),
      ),
    );
  }

  // ─── Question List (Reorderable) ───

  Widget _buildQuestionList(SurveyBuilderState state) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.questions.length,
      onReorder: (oldIndex, newIndex) {
        ref
            .read(surveyBuilderProvider.notifier)
            .reorderQuestions(oldIndex, newIndex);
        setState(() {
          if (_focusedCardIndex == oldIndex) {
            _focusedCardIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
          } else if (_focusedCardIndex != null) {
            final focused = _focusedCardIndex!;
            if (oldIndex < focused && newIndex > focused) {
              _focusedCardIndex = focused - 1;
            } else if (oldIndex > focused && newIndex <= focused) {
              _focusedCardIndex = focused + 1;
            }
          }
        });
      },
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final question = state.questions[index];
        return SurveyQuestionCard(
          key: ValueKey(question.questionId),
          question: question,
          index: index,
          isFocused: _focusedCardIndex == index,
          onFocus: () => setState(() => _focusedCardIndex = index),
          onCancel: _clearFocusedQuestion,
          onDelete: () {
            ref
                .read(surveyBuilderProvider.notifier)
                .removeQuestion(question.questionId);
            setState(() {
              if (_focusedCardIndex == index) {
                _focusedCardIndex = null;
              } else if (_focusedCardIndex != null &&
                  _focusedCardIndex! > index) {
                _focusedCardIndex = _focusedCardIndex! - 1;
              }
            });
          },
          onQuestionCreated: (_) {},
          isDraft: false,
          onMoveUp: index > 0
              ? () => ref
                    .read(surveyBuilderProvider.notifier)
                    .reorderQuestions(index, index - 1)
              : null,
          onMoveDown: index < state.questions.length - 1
              ? () => ref
                    .read(surveyBuilderProvider.notifier)
                    .reorderQuestions(index, index + 2)
              : null,
        );
      },
    );
  }

  // ─── Add Question Button ───

  Widget _buildAddQuestionButton() {
    return Center(
      child: PopupMenuButton<String>(
        onSelected: (value) async {
          switch (value) {
            case 'new':
              _addNewDraftQuestion();
              break;
            case 'import':
              await _importFromQuestionBank();
              break;
            case 'template':
              await _useTemplate();
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'new',
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(context.l10n.surveyBuilderAddNewQuestion),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'import',
            child: ListTile(
              leading: const Icon(Icons.library_add_outlined),
              title: Text(context.l10n.surveyBuilderImportFromBank),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'template',
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(context.l10n.surveyBuilderStartFromTemplate),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const ExcludeSemantics(child: Icon(Icons.add, color: AppTheme.primary, size: 20)),
              Text(
                context.l10n.surveyBuilderAddQuestions,
                style: AppTheme.body.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Empty State ───

  Widget _buildEmptyState() {
    return AppEmptyState(
      icon: Icons.quiz_outlined,
      title: context.l10n.surveyBuilderEmptyStateTitle,
      subtitle: context.l10n.surveyBuilderEmptyStateSubtitle,
      iconSize: 56,
    );
  }

  // ─── Error Banner ───

  Widget _buildErrorBanner(SurveyBuilderState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppInfoBanner(
        icon: Icons.error_outline,
        message: state.errorMessage!,
        color: AppTheme.error,
        backgroundAlpha: 0.1,
        showBorder: false,
        textStyle: const TextStyle(color: AppTheme.error),
        trailing: IconButton(
          tooltip: context.l10n.tooltipClose,
          icon: const Icon(Icons.close, size: 18),
          onPressed: () =>
              ref.read(surveyBuilderProvider.notifier).clearError(),
        ),
      ),
    );
  }

  // ─── Auto-save Indicator ───

  Widget _buildAutoSaveIndicator(AutoSaveStatus status) {
    switch (status) {
      case AutoSaveStatus.idle:
        return const SizedBox.shrink();
      case AutoSaveStatus.pending:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.caution,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              context.l10n.surveyBuilderAutoSaveUnsaved,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        );
      case AutoSaveStatus.saving:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator.inline(
              size: 12,
              color: context.appColors.textMuted.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              context.l10n.surveyBuilderAutoSaveSaving,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        );
      case AutoSaveStatus.saved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_done_outlined,
              size: 16,
              color: context.appColors.textMuted.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              context.l10n.surveyBuilderAutoSaveSaved,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        );
      case AutoSaveStatus.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 16,
              color: AppTheme.error,
            ),
            const SizedBox(width: 6),
            Text(
              context.l10n.surveyBuilderAutoSaveFailed,
              style: AppTheme.captions.copyWith(
                color: AppTheme.error,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            AppTextButton(
              label: context.l10n.commonRetry,
              onPressed: () => ref.read(surveyBuilderProvider.notifier).saveDraft(),
            ),
          ],
        );
    }
  }
}