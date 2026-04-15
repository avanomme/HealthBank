// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/surveys/widgets/survey_question_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/widgets.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show localizedResponseTypeLabels, responseTypes;
import '../state/survey_providers.dart'
    show surveyBuilderProvider, SurveyQuestionItem;

/// A Google Forms-style question card for the survey builder.
///
/// Supports two visual modes:
/// - **Unfocused**: Compact read-only summary with question text, type badge,
///   required indicator, and drag handle.
/// - **Focused**: Expanded editing controls (for draft cards) or detailed view
///   (for persisted cards).
///
/// Draft cards (new questions not yet saved) show full editing UI and call
/// [SurveyBuilderNotifier.createAndAddQuestion] on confirm.
class SurveyQuestionCard extends ConsumerStatefulWidget {
  const SurveyQuestionCard({
    super.key,
    this.question,
    required this.index,
    required this.isFocused,
    required this.onFocus,
    required this.onDelete,
    required this.onQuestionCreated,
    required this.isDraft,
    this.onCancel,
    this.onMoveUp,
    this.onMoveDown,
  });

  /// The question data (null for a new draft card)
  final SurveyQuestionItem? question;

  /// Index in the question list (for numbering)
  final int index;

  /// Whether this card is currently focused/expanded
  final bool isFocused;

  /// Called when this card is tapped (to request focus)
  final VoidCallback onFocus;

  /// Called when the user deletes this card
  final VoidCallback onDelete;

  /// Called when a draft question is successfully created via API
  final ValueChanged<Question> onQuestionCreated;

  /// Whether this is a new unsaved draft question
  final bool isDraft;

  /// Called when the user cancels editing on a focused persisted question.
  final VoidCallback? onCancel;

  /// Keyboard alternatives for drag-reorder (WCAG 2.5.7).
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  ConsumerState<SurveyQuestionCard> createState() => _SurveyQuestionCardState();
}

class _SurveyQuestionCardState extends ConsumerState<SurveyQuestionCard> {
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  String _selectedType = 'yesno';
  bool _isRequired = false;
  bool _isCreating = false;
  String? _error;

  // Scale min/max controllers
  final _scaleMinController = TextEditingController(text: '1');
  final _scaleMaxController = TextEditingController(text: '10');

  /// True when this card's fields should be editable — either a new draft
  /// or a focused existing question.
  bool get _isEditable => widget.isDraft || widget.isFocused;

  // Options for choice-based questions
  final List<TextEditingController> _optionControllers = [];

  bool get _requiresOptions =>
      _selectedType == 'single_choice' || _selectedType == 'multi_choice';

  @override
  void initState() {
    super.initState();
    if (widget.isDraft) {
      // New draft — start with two empty option fields
      _addOption();
      _addOption();
    } else if (widget.question != null) {
      // Existing question — populate controllers
      final q = widget.question!;
      _contentController.text = q.questionContent;
      _titleController.text = q.title ?? '';
      _selectedType = q.responseType;
      _isRequired = q.isRequired;
      if (q.options != null) {
        for (final opt in q.options!) {
          _optionControllers.add(TextEditingController(text: opt.optionText));
        }
      }
      if (_requiresOptions && _optionControllers.isEmpty) {
        _addOption();
        _addOption();
      }
      if (q.scaleMin != null) _scaleMinController.text = q.scaleMin.toString();
      if (q.scaleMax != null) _scaleMaxController.text = q.scaleMax.toString();
    }
  }

  @override
  void didUpdateWidget(covariant SurveyQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Keep the local required toggle in sync when the survey builder updates
    // the underlying question item outside this widget.
    if (!widget.isDraft &&
        widget.question != null &&
        oldWidget.question?.isRequired != widget.question?.isRequired) {
      _isRequired = widget.question!.isRequired;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _scaleMinController.dispose();
    _scaleMaxController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  Future<void> _confirmDraft() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() => _error = context.l10n.questionFormQuestionRequired);
      return;
    }

    if (_requiresOptions) {
      final validOptions = _optionControllers
          .where((c) => c.text.trim().isNotEmpty)
          .toList();
      if (validOptions.length < 2) {
        setState(() => _error = context.l10n.questionFormProvideOptions);
        return;
      }
    }

    setState(() {
      _isCreating = true;
      _error = null;
    });

    List<QuestionOptionCreate>? options;
    if (_requiresOptions) {
      options = _optionControllers
          .asMap()
          .entries
          .where((e) => e.value.text.trim().isNotEmpty)
          .map(
            (e) => QuestionOptionCreate(
              optionText: e.value.text.trim(),
              displayOrder: e.key,
            ),
          )
          .toList();
    }

    final title = _titleController.text.trim().isEmpty
        ? (content.length > 100 ? content.substring(0, 100) : content)
        : _titleController.text.trim();

    final createData = QuestionCreate(
      title: title,
      questionContent: content,
      responseType: _selectedType,
      // Deprecated on question bank API; survey-level required-ness is applied
      // below through survey builder state after creation.
      isRequired: false,
      scaleMin: _selectedType == 'scale'
          ? int.tryParse(_scaleMinController.text)
          : null,
      scaleMax: _selectedType == 'scale'
          ? int.tryParse(_scaleMaxController.text)
          : null,
      options: options,
    );

    final question = await ref
        .read(surveyBuilderProvider.notifier)
        .createAndAddQuestion(createData);

    if (!mounted) return;

    if (question != null) {
      // Apply required-ness to the survey-question association, not the bank question.
      ref
          .read(surveyBuilderProvider.notifier)
          .setQuestionRequired(question.questionId, _isRequired);
      widget.onQuestionCreated(question);
    } else {
      setState(() {
        _isCreating = false;
        _error = context.l10n.surveyBuilderQuestionCardCreateFailed;
      });
    }
  }

  /// Save edits to an existing question via PUT /api/v1/questions/{id}.
  /// Only touches the question bank record — the survey link is unchanged.
  Future<void> _saveEdit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() => _error = context.l10n.questionFormQuestionRequired);
      return;
    }

    if (_requiresOptions) {
      final validOptions = _optionControllers
          .where((c) => c.text.trim().isNotEmpty)
          .toList();
      if (validOptions.length < 2) {
        setState(() => _error = context.l10n.questionFormProvideOptions);
        return;
      }
    }

    setState(() {
      _isCreating = true;
      _error = null;
    });

    final title = _titleController.text.trim().isEmpty
        ? (content.length > 100 ? content.substring(0, 100) : content)
        : _titleController.text.trim();

    List<QuestionOptionCreate>? options;
    if (_requiresOptions) {
      options = _optionControllers
          .asMap()
          .entries
          .where((e) => e.value.text.trim().isNotEmpty)
          .map(
            (e) => QuestionOptionCreate(
              optionText: e.value.text.trim(),
              displayOrder: e.key,
            ),
          )
          .toList();
    }

    final question = await ref
        .read(surveyBuilderProvider.notifier)
        .updateQuestion(
          widget.question!.questionId,
          QuestionUpdate(
            title: title,
            questionContent: content,
            responseType: _selectedType,
            // Deprecated on question bank API; survey-level required-ness is
            // handled separately below.
            isRequired: null,
            scaleMin: _selectedType == 'scale'
                ? int.tryParse(_scaleMinController.text)
                : null,
            scaleMax: _selectedType == 'scale'
                ? int.tryParse(_scaleMaxController.text)
                : null,
            options: options,
          ),
        );

    if (!mounted) return;

    if (question != null) {
      // Persist the required toggle on the survey-question link.
      ref
          .read(surveyBuilderProvider.notifier)
          .setQuestionRequired(widget.question!.questionId, _isRequired);

      setState(() {
        _isCreating = false;
      });
    } else {
      setState(() {
        _isCreating = false;
        _error = context.l10n.surveyBuilderQuestionCardUpdateFailed;
      });
    }
  }

  /// Discard edits and restore the controllers to the last saved values.
  void _cancelEdit() {
    final q = widget.question;
    setState(() {
      _error = null;
      _contentController.text = q?.questionContent ?? '';
      _titleController.text = q?.title ?? '';
      _selectedType = q?.responseType ?? 'yesno';
      _isRequired = q?.isRequired ?? false;

      // Reset option controllers to saved option text
      for (final c in _optionControllers) {
        c.dispose();
      }
      _optionControllers.clear();

      if (q?.options != null && q!.options!.isNotEmpty) {
        for (final opt in q.options!) {
          _optionControllers.add(TextEditingController(text: opt.optionText));
        }
      }

      if ((_selectedType == 'single_choice' ||
              _selectedType == 'multi_choice') &&
          _optionControllers.isEmpty) {
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
      }

      _scaleMinController.text = q?.scaleMin?.toString() ?? '1';
      _scaleMaxController.text = q?.scaleMax?.toString() ?? '10';
    });

    widget.onCancel?.call();
  }

  void _handleRequiredChanged(bool value) {
    setState(() {
      _isRequired = value;
    });

    // Existing persisted survey questions should update the survey builder
    // state immediately when the required toggle changes.
    if (!widget.isDraft && widget.question != null) {
      ref
          .read(surveyBuilderProvider.notifier)
          .setQuestionRequired(widget.question!.questionId, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isFocused && !widget.isDraft) {
      return _buildCollapsed();
    }
    return _buildExpanded();
  }

  // ─── Collapsed (unfocused) ───

  Widget _buildCollapsed() {
    final q = widget.question!;
    return Semantics(
      label: 'Question ${widget.index + 1}: ${q.title ?? q.questionContent}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onFocus,
          borderRadius: BorderRadius.circular(8),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stackSummary = constraints.maxWidth < 520 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.25;
                  final summaryTags = Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AppColoredTag(
                        label:
                            localizedResponseTypeLabels(context.l10n)[q.responseType] ??
                                q.responseType,
                        color: AppTheme.primary,
                        fontSize: 11,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                      ),
                      if (q.isRequired)
                        AppColoredTag(
                          label: context.l10n.questionFormRequiredLabel,
                          icon: Icons.star_rounded,
                          color: AppTheme.error,
                          fontSize: 11,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                        ),
                    ],
                  );

                  // WCAG 2.5.7 — keyboard alternative for drag reorder
                  final moveButtons = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up),
                        tooltip: context.l10n.reorderMoveUp,
                        onPressed: widget.onMoveUp,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        tooltip: context.l10n.reorderMoveDown,
                        onPressed: widget.onMoveDown,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  );

                  if (stackSummary) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppIconBadge(
                              icon: Icons.numbers,
                              size: 28,
                              radius: 6,
                              child: Text(
                                '${widget.index + 1}',
                                style: AppTheme.captions.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            moveButtons,
                            ReorderableDragStartListener(
                              index: widget.index,
                              child: Icon(
                                Icons.drag_handle,
                                color: context.appColors.textMuted,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q.title ?? q.questionContent,
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        summaryTags,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppIconBadge(
                        icon: Icons.numbers,
                        size: 28,
                        radius: 6,
                        child: Text(
                          '${widget.index + 1}',
                          style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.title ?? q.questionContent,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.body.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            summaryTags,
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      moveButtons,
                      ReorderableDragStartListener(
                        index: widget.index,
                        child: Icon(
                          Icons.drag_handle,
                          color: context.appColors.textMuted,
                          size: 22,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Expanded (focused / draft) ───

  Widget _buildExpanded() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Blue left accent (using a top bar like Google Forms)
          Container(height: 4, color: AppTheme.primary),

          _buildFormFields(),
          _buildToolbar(),
        ],
      ),
    );
  }

  // ─── Expanded form fields ───

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error banner
          if (_error != null) ...[
            AppInfoBanner(
              icon: Icons.error_outline,
              message: _error!,
              color: AppTheme.error,
              backgroundAlpha: 0.1,
              showBorder: false,
              radius: 6,
              padding: const EdgeInsets.all(10),
              textStyle: const TextStyle(
                color: AppTheme.error,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Title field (optional)
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: context.l10n.questionFormTitleHint,
              labelText: context.l10n.questionFormTitleLabel,
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.appColors.divider),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            style: AppTheme.body.copyWith(fontSize: 14),
            enabled: _isEditable,
          ),
          const SizedBox(height: 12),

          // Question content field
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              hintText: context.l10n.surveyBuilderQuestionCardPlaceholder,
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.appColors.divider),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            style: AppTheme.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            minLines: 1,
            enabled: _isEditable,
          ),
          const SizedBox(height: 16),

          // Type dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.questionFormTypeLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: responseTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      _getIconForType(type),
                      size: 18,
                      color: context.appColors.textMuted,
                    ),
                    Text(
                      localizedResponseTypeLabels(context.l10n)[type] ?? type,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: _isEditable
                ? (val) {
                    if (val != null) {
                      setState(() {
                        _selectedType = val;
                        if (_requiresOptions && _optionControllers.isEmpty) {
                          _addOption();
                          _addOption();
                        }
                      });
                    }
                  }
                : null,
          ),
          const SizedBox(height: 16),

          // Options editor (for choice types)
          if (_requiresOptions) ...[
            _buildOptionsEditor(),
            const SizedBox(height: 16),
          ],

          // Scale range editor
          if (_selectedType == 'scale') ...[
            _buildScaleEditor(),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // ─── Expanded toolbar ───

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.divider.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackToolbar = constraints.maxWidth < 520 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.2;
          final actionButtons = Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              if (!widget.isDraft)
                IconButton(
                  icon: const Icon(Icons.close),
                  color: context.appColors.textMuted,
                  iconSize: 20,
                  tooltip: context.l10n.surveyBuilderQuestionCardCancelEdit,
                  onPressed: _cancelEdit,
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppTheme.error,
                iconSize: 20,
                tooltip: context.l10n.surveyBuilderRemoveQuestion,
                onPressed: widget.onDelete,
              ),
              if (_isEditable)
                _isCreating
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: AppLoadingIndicator.inline(size: 20),
                      )
                    : IconButton(
                        icon: const Icon(Icons.check_circle),
                        color: AppTheme.success,
                        iconSize: 24,
                        tooltip: widget.isDraft
                            ? context.l10n.surveyBuilderQuestionCardConfirm
                            : context.l10n.surveyBuilderQuestionCardSave,
                        onPressed: widget.isDraft ? _confirmDraft : _saveEdit,
                      ),
            ],
          );

          final requiredToggle = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.questionFormRequiredLabel,
                style: AppTheme.captions,
              ),
              const SizedBox(width: 4),
              Switch(
                value: _isRequired,
                onChanged: _isEditable ? _handleRequiredChanged : null,
                activeThumbColor: AppTheme.primary,
              ),
            ],
          );

          if (stackToolbar) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                requiredToggle,
                const SizedBox(height: 8),
                actionButtons,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              requiredToggle,
              const Spacer(),
              Flexible(child: actionButtons),
            ],
          );
        },
      ),
    );
  }

  // ─── Options editor ───

  Widget _buildOptionsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              context.l10n.questionFormOptionsLabel,
              style: AppTheme.captions.copyWith(
                fontWeight: FontWeight.w500,
                color: context.appColors.textMuted,
              ),
            ),
            if (_isEditable)
              AppTextButton(
                label: context.l10n.questionFormAddOption,
                onPressed: _addOption,
              ),
          ],
        ),
        const SizedBox(height: 6),
        ...List.generate(_optionControllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  _selectedType == 'single_choice'
                      ? Icons.radio_button_unchecked
                      : Icons.check_box_outline_blank,
                  size: 20,
                  color: context.appColors.textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _optionControllers[i],
                    decoration: InputDecoration(
                      labelText: context.l10n.questionFormOptionLabel(i + 1),
                      hintText: context.l10n.questionFormOptionLabel(i + 1),
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: context.appColors.divider),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primary),
                      ),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 6),
                    ),
                    enabled: _isEditable,
                  ),
                ),
                if (_isEditable && _optionControllers.length > 2)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: context.appColors.textMuted,
                    tooltip: context.l10n.tooltipRemoveOption,
                    onPressed: () => _removeOption(i),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── Scale editor ───

  Widget _buildScaleEditor() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackFields = constraints.maxWidth < 480 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.2;

        if (stackFields) {
          return Column(
            children: [
              TextField(
                controller: _scaleMinController,
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMin,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                enabled: _isEditable,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _scaleMaxController,
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMax,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                enabled: _isEditable,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: _scaleMinController,
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMin,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                enabled: _isEditable,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _scaleMaxController,
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMax,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                enabled: _isEditable,
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Helpers ───

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