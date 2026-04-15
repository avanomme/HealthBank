// Created with the Assistance of Claude Code
// frontend/lib/src/features/templates/widgets/template_preview_dialog.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';
import 'package:frontend/src/core/widgets/feedback/app_empty_state.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/question_types.dart';

/// Template Preview Dialog
///
/// Displays a template as it would appear in a survey, with all question types
/// rendered in preview mode (interactive but not saving responses).
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => TemplatePreviewDialog(template: template),
/// );
/// ```
class TemplatePreviewDialog extends StatefulWidget {
  const TemplatePreviewDialog({
    super.key,
    required this.template,
  });

  /// The template to preview
  final Template template;

  @override
  State<TemplatePreviewDialog> createState() => _TemplatePreviewDialogState();
}

class _TemplatePreviewDialogState extends State<TemplatePreviewDialog> {
  // Store preview responses (not persisted)
  final Map<int, dynamic> _previewResponses = {};

  @override
  Widget build(BuildContext context) {
    final questions = widget.template.questions ?? [];
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDialogWidth = screenWidth < 632 ? screenWidth - 32 : 600.0;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),

            // HealthBank Logo Header
            const HealthBankLogoHeader(size: HealthBankLogoSize.small),

            // Content
            Flexible(
              child: questions.isEmpty
                  ? _buildEmptyState()
                  : _buildQuestionsList(questions),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          const ExcludeSemantics(child: Icon(Icons.preview, color: AppTheme.textContrast)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.templatePreviewTitle,
                  style: AppTheme.captions.copyWith(
                    color: AppTheme.textContrast.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  widget.template.title,
                  style: AppTheme.body.copyWith(
                    color: AppTheme.textContrast,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textContrast),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: context.l10n.templatePreviewClose,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AppEmptyState(
      icon: Icons.quiz_outlined,
      title: context.l10n.templatePreviewNoQuestions,
      iconSize: 48,
    );
  }

  Widget _buildQuestionsList(List<QuestionInTemplate> questions) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: questions.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final question = questions[index];
        return _buildQuestionPreview(question, index);
      },
    );
  }

  Widget _buildQuestionPreview(QuestionInTemplate question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number badge
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            context.l10n.templatePreviewQuestionNumber(index + 1),
            style: AppTheme.captions.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Question widget based on type
        _buildQuestionWidget(question),
      ],
    );
  }

  Widget _buildQuestionWidget(QuestionInTemplate question) {
    final questionText = question.title ?? question.questionContent;
    final options = question.options?.map((o) => o.optionText).toList() ?? [];

    switch (question.responseType) {
      case 'number':
        return NumberQuestionWidget(
          questionText: questionText,
          value: _previewResponses[question.questionId] as int?,
          isRequired: question.isRequired,
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      case 'yesno':
        return YesNoQuestionWidget(
          questionText: questionText,
          value: _previewResponses[question.questionId] as bool?,
          isRequired: question.isRequired,
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      case 'openended':
        return OpenEndedQuestionWidget(
          questionText: questionText,
          value: _previewResponses[question.questionId] as String?,
          isRequired: question.isRequired,
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      case 'single_choice':
        return SingleChoiceWidget(
          questionText: questionText,
          options: options,
          value: _previewResponses[question.questionId] as String?,
          isRequired: question.isRequired,
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      case 'multi_choice':
        return MultiChoiceWidget(
          questionText: questionText,
          options: options,
          values: (_previewResponses[question.questionId] as List<String>?) ?? [],
          isRequired: question.isRequired,
          onChanged: (values) => _updateResponse(question.questionId, values),
        );

      case 'scale':
        return ScaleQuestionWidget(
          questionText: questionText,
          min: 1,
          max: 10,
          divisions: 9,
          value: _previewResponses[question.questionId] as double?,
          isRequired: question.isRequired,
          minLabel: context.l10n.templatePreviewScaleLow,
          maxLabel: context.l10n.templatePreviewScaleHigh,
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      case 'date':
        return _buildDateQuestion(question);

      case 'time':
        return _buildTimeQuestion(question);

      default:
        return _buildUnsupportedType(question);
    }
  }

  Widget _buildDateQuestion(QuestionInTemplate question) {
    final questionText = question.title ?? question.questionContent;
    final value = _previewResponses[question.questionId] as DateTime?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(questionText, style: AppTheme.body),
            ),
            if (question.isRequired)
              Text(
                '*',
                style: AppTheme.body.copyWith(color: AppTheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppOutlinedButton(
          label: value != null
              ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'
              : context.l10n.templatePreviewSelectDate,
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              _updateResponse(question.questionId, date);
            }
          },
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildTimeQuestion(QuestionInTemplate question) {
    final questionText = question.title ?? question.questionContent;
    final value = _previewResponses[question.questionId] as TimeOfDay?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(questionText, style: AppTheme.body),
            ),
            if (question.isRequired)
              Text(
                '*',
                style: AppTheme.body.copyWith(color: AppTheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppOutlinedButton(
          label: value != null ? value.format(context) : context.l10n.templatePreviewSelectTime,
          onPressed: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: value ?? TimeOfDay.now(),
            );
            if (time != null) {
              _updateResponse(question.questionId, time);
            }
          },
          icon: Icons.access_time,
        ),
      ],
    );
  }

  Widget _buildUnsupportedType(QuestionInTemplate question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.textMuted.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ExcludeSemantics(child: Icon(Icons.warning_amber, color: context.appColors.textMuted)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title ?? question.questionContent,
                  style: AppTheme.body,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.templatePreviewUnsupportedType(question.responseType),
                  style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(
          top: BorderSide(
            color: context.appColors.textMuted.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.appColors.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.templatePreviewFooterNote,
              style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
            ),
          ),
          AppFilledButton(
            label: context.l10n.templatePreviewClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _updateResponse(int questionId, dynamic value) {
    setState(() {
      _previewResponses[questionId] = value;
    });
  }
}

/// Shows the template preview dialog
///
/// Usage:
/// ```dart
/// await showTemplatePreview(context, template);
/// ```
Future<void> showTemplatePreview(BuildContext context, Template template) {
  return showDialog(
    context: context,
    builder: (context) => TemplatePreviewDialog(template: template),
  );
}
