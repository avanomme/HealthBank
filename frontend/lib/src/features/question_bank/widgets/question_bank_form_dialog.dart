// Created with the Assistance of Claude Code
// frontend/lib/features/question_bank/widgets/question_bank_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import '../state/question_providers.dart' show questionsProvider, questionApiProvider, responseTypes, localizedResponseTypeLabels;

/// Dialog for creating or editing questions in the question bank.
///
/// Supports all 6 question types:
/// - number: Numeric input
/// - yesno: Yes/No toggle
/// - openended: Free text
/// - single_choice: Radio buttons (requires options)
/// - multi_choice: Checkboxes (requires options)
/// - scale: Slider rating
///
/// Note:
/// - Required-ness is no longer a property of the reusable question-bank item.
/// - Whether a question is required is now configured when the question is
///   used in a specific survey or template.
class QuestionBankFormDialog extends ConsumerStatefulWidget {
  const QuestionBankFormDialog({
    super.key,
    this.question,
  });

  /// Existing question to edit (null for create mode)
  final Question? question;

  /// Show the dialog and return the created/updated question
  static Future<Question?> show(
    BuildContext context, {
    Question? question,
  }) {
    return showDialog<Question>(
      context: context,
      barrierDismissible: true,
      builder: (context) => QuestionBankFormDialog(question: question),
    );
  }

  @override
  ConsumerState<QuestionBankFormDialog> createState() =>
      _QuestionBankFormDialogState();
}

class _QuestionBankFormDialogState
    extends ConsumerState<QuestionBankFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();

  String _selectedType = 'yesno';
  bool _isLoading = false;
  String? _errorMessage;

  // Options for choice-based questions
  final List<TextEditingController> _optionControllers = [];

  // Scale question settings
  double _scaleMin = 1;
  double _scaleMax = 10;

  bool get _isEditMode => widget.question != null;
  bool get _requiresOptions =>
      _selectedType == 'single_choice' || _selectedType == 'multi_choice';

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _populateFromQuestion(widget.question!);
    } else {
      // Add two default option fields for choice types
      _addOption();
      _addOption();
    }
  }

  void _populateFromQuestion(Question question) {
    _titleController.text = question.title ?? '';
    _contentController.text = question.questionContent;
    _categoryController.text = question.category ?? '';
    _selectedType = question.responseType;
    _scaleMin = (question.scaleMin ?? 1).toDouble();
    _scaleMax = (question.scaleMax ?? 10).toDouble();

    // Populate options if present
    if (question.options != null && question.options!.isNotEmpty) {
      for (final option in question.options!) {
        final controller = TextEditingController(text: option.optionText);
        _optionControllers.add(controller);
      }
    } else if (_requiresOptions) {
      _addOption();
      _addOption();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate options for choice types
    if (_requiresOptions) {
      final validOptions = _optionControllers
          .where((c) => c.text.trim().isNotEmpty)
          .toList();
      if (validOptions.length < 2) {
        setState(() {
          _errorMessage = context.l10n.questionFormProvideOptions;
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(questionApiProvider);
      Question result;

      // Build options list for choice types
      List<QuestionOptionCreate>? options;
      if (_requiresOptions) {
        options = _optionControllers
            .asMap()
            .entries
            .where((e) => e.value.text.trim().isNotEmpty)
            .map((e) => QuestionOptionCreate(
                  optionText: e.value.text.trim(),
                  displayOrder: e.key,
                ))
            .toList();
      }

      if (_isEditMode) {
        result = await api.updateQuestion(
          widget.question!.questionId,
          QuestionUpdate(
            title: _titleController.text.trim().isEmpty
                ? null
                : _titleController.text.trim(),
            questionContent: _contentController.text.trim(),
            responseType: _selectedType,
            // Deprecated on question bank API; required-ness is now set
            // when the question is added to a survey/template.
            isRequired: null,
            category: _categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim(),
            options: options,
            scaleMin: _selectedType == 'scale' ? _scaleMin.toInt() : null,
            scaleMax: _selectedType == 'scale' ? _scaleMax.toInt() : null,
          ),
        );
      } else {
        final rawTitle = _titleController.text.trim();
        final content = _contentController.text.trim();
        final title = rawTitle.isEmpty
            ? (content.length > 100 ? content.substring(0, 100) : content)
            : rawTitle;
        result = await api.createQuestion(
          QuestionCreate(
            title: title,
            questionContent: content,
            responseType: _selectedType,
            // Deprecated on question bank API; required-ness is now set
            // when the question is added to a survey/template.
            isRequired: false,
            category: _categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim(),
            options: options,
            scaleMin: _selectedType == 'scale' ? _scaleMin.toInt() : null,
            scaleMax: _selectedType == 'scale' ? _scaleMax.toInt() : null,
          ),
        );
      }

      // Invalidate questions provider to refresh the list
      ref.invalidate(questionsProvider);

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode
          ? context.l10n.questionFormEditTitle
          : context.l10n.questionFormNewTitle),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error message
                if (_errorMessage != null) ...[
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const ExcludeSemantics(child: Icon(Icons.error_outline,
                              color: AppTheme.error, size: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppTheme.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Question Type Selector
                _buildTypeSelector(context),
                const SizedBox(height: 16),

                // Title (optional)
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.questionFormTitleLabel,
                    hintText: context.l10n.questionFormTitleHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Question Content (required)
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: context.l10n.questionFormQuestionLabel,
                    hintText: context.l10n.questionFormQuestionHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.questionFormQuestionRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Options for choice types
                if (_requiresOptions) ...[
                  _buildOptionsSection(context),
                  const SizedBox(height: 16),
                ],

                // Scale settings
                if (_selectedType == 'scale') ...[
                  _buildScaleSettings(context),
                  const SizedBox(height: 16),
                ],

                // Category
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: context.l10n.questionFormCategoryLabel,
                    hintText: context.l10n.questionFormCategoryHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AppTextButton(
          label: context.l10n.commonCancel,
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        ),
        AppFilledButton(
          label: _isLoading
              ? '...'
              : (_isEditMode
                  ? context.l10n.commonSave
                  : context.l10n.questionFormCreate),
          onPressed: _isLoading ? null : _submit,
        ),
      ],
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.questionFormTypeLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.appColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: responseTypes.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label:
                  Text(localizedResponseTypeLabels(context.l10n)[type] ?? type),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = type;
                    // Initialize options if switching to choice type
                    if (_requiresOptions && _optionControllers.isEmpty) {
                      _addOption();
                      _addOption();
                    }
                  });
                }
              },
              selectedColor: AppTheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.primary
                    : context.appColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              avatar: Icon(
                _getIconForType(type),
                size: 18,
                color: isSelected
                    ? AppTheme.primary
                    : context.appColors.textMuted,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.questionFormOptionsLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.appColors.textMuted,
              ),
            ),
            AppTextButton(
              label: context.l10n.questionFormAddOption,
              onPressed: _addOption,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(_optionControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText:
                          context.l10n.questionFormOptionLabel(index + 1),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                if (_optionControllers.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppTheme.error,
                    onPressed: () => _removeOption(index),
                    tooltip: context.l10n.questionFormRemoveOption,
                  ),
              ],
            ),
          );
        }),
        Text(
          context.l10n.questionFormMinOptionsRequired,
          style:
              AppTheme.captions.copyWith(color: context.appColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildScaleSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.questionFormScaleRange,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.appColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _scaleMin.toInt().toString(),
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMin,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() => _scaleMin = parsed);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: _scaleMax.toInt().toString(),
                decoration: InputDecoration(
                  labelText: context.l10n.questionFormScaleMax,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() => _scaleMax = parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
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