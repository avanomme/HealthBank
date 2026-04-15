// Created with the Assistance of Claude Code
// frontend/lib/src/features/surveys/widgets/survey_preview_dialog.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';
import 'package:frontend/src/core/widgets/feedback/app_empty_state.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/question_types.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart'
    show SurveyQuestionItem;

/// Survey Preview Dialog
///
/// Displays a survey as it would appear to participants, with the HealthBank
/// logo prominently displayed in the top left. Questions are interactive
/// but responses are not saved.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => SurveyPreviewDialog(
///     title: 'My Survey',
///     description: 'Survey description',
///     questions: questionItems,
///   ),
/// );
/// ```
class SurveyPreviewDialog extends StatefulWidget {
  const SurveyPreviewDialog({
    super.key,
    required this.title,
    this.description,
    required this.questions,
  });

  /// Survey title
  final String title;

  /// Survey description (optional)
  final String? description;

  /// Questions to display
  final List<SurveyQuestionItem> questions;

  @override
  State<SurveyPreviewDialog> createState() => _SurveyPreviewDialogState();
}

class _SurveyPreviewDialogState extends State<SurveyPreviewDialog> {
  // Store preview responses (not persisted)
  final Map<int, dynamic> _previewResponses = {};

  @override
  Widget build(BuildContext context) {
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
            // Close button header
            _buildCloseHeader(),

            // HealthBank Logo Header (prominent branding)
            const HealthBankLogoHeader(
              size: HealthBankLogoSize.medium,
              showDivider: false,
            ),

            // Survey title and description
            _buildSurveyHeader(),

            // Divider
            Divider(
              height: 1,
              color: context.appColors.textMuted.withValues(alpha: 0.2),
            ),

            // Content
            Flexible(
              child: widget.questions.isEmpty
                  ? _buildEmptyState()
                  : _buildQuestionsList(),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          const ExcludeSemantics(child: Icon(Icons.preview, color: AppTheme.textContrast, size: 18)),
          const SizedBox(width: 8),
          Text(
            'Survey Preview',
            style: AppTheme.captions.copyWith(
              color: AppTheme.textContrast,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textContrast),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: context.l10n.commonClose,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: context.appColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              widget.title,
              style: AppTheme.heading4.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.description != null && widget.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.description!,
              style: AppTheme.body.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const AppEmptyState(
      icon: Icons.quiz_outlined,
      title: 'No questions in this survey',
      subtitle: 'Add questions to see how your survey will look',
      iconSize: 48,
    );
  }

  Widget _buildQuestionsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: widget.questions.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final question = widget.questions[index];
        return _buildQuestionPreview(question, index);
      },
    );
  }

  Widget _buildQuestionPreview(SurveyQuestionItem question, int index) {
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
            'Question ${index + 1}',
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

  Widget _buildQuestionWidget(SurveyQuestionItem question) {
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
          values:
              (_previewResponses[question.questionId] as List<String>?) ?? [],
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
          minLabel: 'Low',
          maxLabel: 'High',
          onChanged: (value) => _updateResponse(question.questionId, value),
        );

      default:
        return _buildUnsupportedType(question);
    }
  }

  Widget _buildUnsupportedType(SurveyQuestionItem question) {
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
                  'Unsupported question type: ${question.responseType}',
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
              context.l10n.surveyPreviewNote,
              style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
            ),
          ),
          AppFilledButton(
            label: context.l10n.commonClose,
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

/// Shows the survey preview dialog
///
/// Usage:
/// ```dart
/// await showSurveyPreview(
///   context,
///   title: 'My Survey',
///   description: 'Description',
///   questions: questionItems,
/// );
/// ```
Future<void> showSurveyPreview(
  BuildContext context, {
  required String title,
  String? description,
  required List<SurveyQuestionItem> questions,
}) {
  return showDialog(
    context: context,
    builder: (context) => SurveyPreviewDialog(
      title: title,
      description: description,
      questions: questions,
    ),
  );
}
