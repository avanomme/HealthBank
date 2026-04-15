// Created with the Assistance of Codex
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/basics.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:go_router/go_router.dart';

/// Lists participant-assigned surveys and routes pending work to a dedicated
/// survey-taking page.
class ParticipantSurveysPage extends ConsumerWidget {
  const ParticipantSurveysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surveysAsync = ref.watch(participantSurveysProvider);

    return ParticipantScaffold(
      currentRoute: '/participant/surveys',
      showFooter: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(header: true, child: Text(l10n.navSurveys, style: AppTheme.heading3)),
          const SizedBox(height: 8),
          Text(
            l10n.participantNoSurveysSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 16),
          surveysAsync.when(
            data: (surveys) => _buildSurveyList(context, surveys, l10n),
            loading: () => const AppLoadingIndicator(),
            error: (error, _) => AppEmptyState.error(
              title: l10n.participantSurveyLoadError,
              action: AppOutlinedButton(
                label: l10n.participantRetry,
                onPressed: () => ref.invalidate(participantSurveysProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyList(
    BuildContext context,
    List<ParticipantSurveyListItem> surveys,
    AppLocalizations l10n,
  ) {
    if (surveys.isEmpty) {
      return AppEmptyState(
        icon: Icons.assignment_outlined,
        title: l10n.participantNoSurveys,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surveys.length,
      itemBuilder: (context, index) => _SurveyCard(survey: surveys[index]),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  const _SurveyCard({required this.survey});

  final ParticipantSurveyListItem survey;

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _statusKey(ParticipantSurveyListItem survey) {
    if (survey.assignmentStatus == 'pending' && survey.hasDraft) {
      return 'incomplete';
    }
    return survey.assignmentStatus;
  }

  Color _statusColor(BuildContext context, String status) => switch (status) {
    'incomplete' => AppTheme.caution,
    'pending' => AppTheme.caution,
    'completed' => AppTheme.success,
    'expired' => AppTheme.error,
    _ => context.appColors.textMuted,
  };

  String _statusLabel(String status, AppLocalizations l10n) => switch (status) {
    'incomplete' => l10n.participantSurveyStatusIncomplete,
    'pending' => l10n.participantSurveyStatusPending,
    'completed' => l10n.participantSurveyStatusCompleted,
    'expired' => l10n.participantSurveyStatusExpired,
    _ => status,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = _statusKey(survey);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stackHeader =
                constraints.maxWidth < 420 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.2;
            final statusChip = Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(context, status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _statusLabel(status, l10n),
                style: AppTheme.captions.copyWith(
                  color: _statusColor(context, status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stackHeader) ...[
                  Text(
                    survey.title,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  statusChip,
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          survey.title,
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      statusChip,
                    ],
                  ),
                if (survey.dueDate != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: context.appColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.participantSurveyDueDate(
                            _formatDate(survey.dueDate!),
                          ),
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                if (survey.assignmentStatus == 'pending')
                  SizedBox(
                    width: double.infinity,
                    child: AppFilledButton(
                      label: survey.hasDraft
                          ? l10n.participantResumeSurvey
                          : l10n.participantStartSurvey,
                      onPressed: () => context.go(
                        AppRoutes.participantSurveyPath(survey.surveyId),
                      ),
                      backgroundColor: AppTheme.primary,
                      textColor: AppTheme.textContrast,
                    ),
                  )
                else if (survey.assignmentStatus == 'completed')
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppTheme.success,
                      ),
                      Text(
                        l10n.participantSurveyStatusCompleted,
                        style: AppTheme.captions.copyWith(
                          color: AppTheme.success,
                        ),
                      ),
                      if (survey.completedAt != null)
                        Text(
                          '· ${_formatDate(survey.completedAt!)}',
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Survey taker — loads questions and collects responses
// ---------------------------------------------------------------------------

class _SurveyTaker extends ConsumerStatefulWidget {
  const _SurveyTaker({
    required this.surveyId,
    required this.surveyTitle,
    required this.onSubmitted,
  });

  final int surveyId;
  final String surveyTitle;
  final VoidCallback onSubmitted;

  @override
  ConsumerState<_SurveyTaker> createState() => _SurveyTakerState();
}

class _SurveyTakerState extends ConsumerState<_SurveyTaker> {
  // Map from questionId → response value
  final Map<int, String> _responses = {};
  // Map from questionId → validation error
  final Map<int, String> _validationErrors = {};
  bool _isSubmitting = false;
  String? _submitError;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _saveDraft();
    super.dispose();
  }

  Future<void> _loadDraft() async {
    try {
      final dio = ref.read(apiClientProvider).dio;
      final resp = await dio.get<Map<String, dynamic>>(
        '/participants/surveys/${widget.surveyId}/draft',
      );
      final draft = resp.data?['draft'] as Map<String, dynamic>?;
      if (draft != null && draft.isNotEmpty && mounted) {
        setState(() {
          for (final entry in draft.entries) {
            _responses[int.parse(entry.key)] = entry.value.toString();
          }
        });
      }
    } catch (_) {
      // Draft loading is best-effort — don't block survey taking
    }
  }

  Future<void> _saveDraft() async {
    if (_submitted || _responses.isEmpty) return;
    try {
      final api = ref.read(participantApiProvider);
      await api.saveDraft(widget.surveyId, {
        'question_responses': _responses.entries
            .map((e) => {'question_id': e.key, 'response_value': e.value})
            .toList(),
      });
    } catch (_) {
      // Draft saving is best-effort
    }
  }

  bool _validate(List<ParticipantSurveyQuestion> questions, l10n) {
    final errors = <int, String>{};
    for (final q in questions) {
      if (q.isRequired) {
        final v = _responses[q.questionId];
        if (v == null || v.trim().isEmpty) {
          errors[q.questionId] = l10n.surveyTakingRequiredError;
        }
      }
    }
    setState(
      () => _validationErrors
        ..clear()
        ..addAll(errors),
    );
    return errors.isEmpty;
  }

  Future<void> _submit(
    List<ParticipantSurveyQuestion> questions,
    WidgetRef ref,
    l10n,
  ) async {
    if (!_validate(questions, l10n)) {
      // Show a top-level snackbar for validation
      if (mounted) {
        AppToast.showError(context, message: l10n.surveyTakingValidationError);
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final api = ref.read(participantApiProvider);
      await api.submitSurvey(widget.surveyId, {
        'question_responses': _responses.entries
            .map((e) => {'question_id': e.key, 'response_value': e.value})
            .toList(),
      });

      _submitted = true;
      widget.onSubmitted();

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, message: l10n.surveySubmitSuccess);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      final detail = (e.response?.data?['detail'] as String? ?? '')
          .toLowerCase();
      final code = e.response?.statusCode;
      String msg;

      if (code == 400 && detail.contains('already')) {
        msg = l10n.surveySubmitErrorAlreadySubmitted;
      } else if (code == 400 && detail.contains('expir')) {
        msg = l10n.surveySubmitErrorExpired;
      } else if (code == 400 && detail.contains('publish')) {
        msg = l10n.surveySubmitErrorNotPublished;
      } else if (code == 403) {
        msg = l10n.surveySubmitErrorNotAssigned;
      } else if (code == 404) {
        msg = l10n.surveySubmitErrorNotFound;
      } else if (code != null && code >= 500) {
        msg = l10n.surveySubmitErrorServer;
      } else {
        msg = l10n.surveySubmitErrorGeneral;
      }

      setState(() {
        _isSubmitting = false;
        _submitError = msg;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitError = l10n.surveyTakingNetworkError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surveyAsync = ref.watch(
      participantSurveyQuestionsProvider(widget.surveyId),
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _saveDraft();
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        maxChildSize: 0.95,
        builder: (_, scrollController) => SizedBox.expand(
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          widget.surveyTitle,
                          style: AppTheme.heading3,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: context.l10n.tooltipCloseModal,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: surveyAsync.when(
                  data: (survey) {
                    final questions = survey.questions;
                    if (questions.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.participantChartNoData,
                          style: AppTheme.body.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            itemCount: questions.length,
                            itemBuilder: (_, i) => _QuestionField(
                              key: ValueKey(questions[i].questionId),
                              question: questions[i],
                              value: _responses[questions[i].questionId],
                              error: _validationErrors[questions[i].questionId],
                              onChanged: (v) {
                                setState(() {
                                  _responses[questions[i].questionId] = v;
                                  _validationErrors.remove(
                                    questions[i].questionId,
                                  );
                                });
                              },
                              l10n: l10n,
                            ),
                          ),
                        ),

                        // Submit area
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.appColors.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_submitError != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.error.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: AppTheme.error,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _submitError!,
                                            style: AppTheme.captions.copyWith(
                                              color: AppTheme.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              AppFilledButton(
                                label: _isSubmitting
                                    ? l10n.surveyTakingSubmitting
                                    : l10n.surveyTakingSubmit,
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _submit(questions, ref, l10n),
                                backgroundColor: AppTheme.primary,
                                textColor: AppTheme.textContrast,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLoadingIndicator(centered: false),
                        const SizedBox(height: 16),
                        Text(
                          l10n.surveyTakingLoadingQuestions,
                          style: AppTheme.body.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            size: 48,
                            color: AppTheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.surveyTakingNetworkError,
                            style: AppTheme.body.copyWith(
                              color: context.appColors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          AppOutlinedButton(
                            label: l10n.surveyTakingRetry,
                            onPressed: () => ref.invalidate(
                              participantSurveyQuestionsProvider(
                                widget.surveyId,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual question field
// ---------------------------------------------------------------------------

class _QuestionField extends StatelessWidget {
  const _QuestionField({
    super.key,
    required this.question,
    required this.value,
    required this.error,
    required this.onChanged,
    required this.l10n,
  });

  final ParticipantSurveyQuestion question;
  final String? value;
  final String? error;
  final ValueChanged<String> onChanged;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question label
          RichText(
            text: TextSpan(
              style: AppTheme.body.copyWith(
                fontWeight: FontWeight.w500,
                color: context.appColors.textPrimary,
              ),
              children: [
                TextSpan(text: question.questionContent),
                if (question.isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppTheme.body.copyWith(color: AppTheme.error),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Input by response type
          _buildInput(),

          // Inline validation error
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 14,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    error!,
                    style: AppTheme.captions.copyWith(color: AppTheme.error),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return switch (question.responseType) {
      'yesno' => _YesNoInput(
        value: value,
        onChanged: onChanged,
        error: error,
        l10n: l10n,
      ),
      'scale' => _ScaleInput(
        value: value,
        onChanged: onChanged,
        error: error,
        min: (question.scaleMin ?? 1).toDouble(),
        max: (question.scaleMax ?? 10).toDouble(),
      ),
      'number' => _NumberInput(
        value: value,
        onChanged: onChanged,
        error: error,
        responseType: question.responseType,
      ),
      'single_choice' => _ChoiceInput(
        value: value,
        options: question.options ?? [],
        onChanged: onChanged,
        error: error,
        multiSelect: false,
      ),
      'multi_choice' => _ChoiceInput(
        value: value,
        options: question.options ?? [],
        onChanged: onChanged,
        error: error,
        multiSelect: true,
      ),

      _ => _TextInput(value: value, onChanged: onChanged, error: error),
    };
  }
}

// ---------------------------------------------------------------------------
// Input widgets
// ---------------------------------------------------------------------------

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.value,
    required this.onChanged,
    required this.error,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.value,
    required this.onChanged,
    required this.error,
    required this.responseType,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final String? error;
  final String responseType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _ScaleInput extends StatefulWidget {
  const _ScaleInput({
    required this.value,
    required this.onChanged,
    required this.error,
    required this.min,
    required this.max,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final String? error;
  final double min;
  final double max;

  @override
  State<_ScaleInput> createState() => _ScaleInputState();
}

class _ScaleInputState extends State<_ScaleInput> {
  late double _current;

  @override
  void initState() {
    super.initState();
    _syncFromWidget();
  }

  @override
  void didUpdateWidget(covariant _ScaleInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max) {
      final parsed = double.tryParse(widget.value ?? '') ?? widget.min;
      _current = parsed.clamp(widget.min, widget.max);
    }
  }

  void _syncFromWidget() {
    _current = (double.tryParse(widget.value ?? '') ?? widget.min).clamp(
      widget.min,
      widget.max,
    );
  }

  @override
  Widget build(BuildContext context) {
    final divisions = (widget.max - widget.min).round();
    return Column(
      children: [
        Row(
          children: [
            Text('${widget.min.round()}'),
            Expanded(
              child: Slider(
                value: _current,
                min: widget.min,
                max: widget.max,
                divisions: divisions > 0 ? divisions : 1,
                label: _current.round().toString(),
                onChanged: (v) {
                  setState(() => _current = v);
                  widget.onChanged(v.round().toString());
                },
              ),
            ),
            Text('${widget.max.round()}'),
          ],
        ),
        Text(
          '${_current.round()}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class _YesNoInput extends StatelessWidget {
  const _YesNoInput({
    required this.value,
    required this.onChanged,
    required this.error,
    required this.l10n,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final String? error;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ToggleOption(
            label: l10n.participantChartYes,
            selected: value == 'yes',
            color: AppTheme.success,
            onTap: () => onChanged('yes'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ToggleOption(
            label: l10n.participantChartNo,
            selected: value == 'no',
            color: AppTheme.error,
            onTap: () => onChanged('no'),
          ),
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTappable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.15)
              : context.appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? color
                : context.appColors.textMuted.withValues(alpha: 0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTheme.body.copyWith(
              color: selected ? color : context.appColors.textMuted,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceInput extends StatelessWidget {
  const _ChoiceInput({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.error,
    required this.multiSelect,
  });

  final String? value;
  final List<ParticipantQuestionOption> options;
  final ValueChanged<String> onChanged;
  final String? error;
  final bool multiSelect;

  Set<int> get _selectedIds {
    if (value == null || value!.trim().isEmpty) return {};

    if (!multiSelect) {
      final id = int.tryParse(value!.trim());
      return id != null ? {id} : {};
    }

    // Parse JSON array format; fall back to comma-separated for legacy
    try {
      final decoded = jsonDecode(value!);
      if (decoded is List) {
        return decoded
            .map((e) => int.tryParse(e.toString().trim()))
            .whereType<int>()
            .toSet();
      }
    } catch (_) {}

    return value!
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIds = _selectedIds;

    return Column(
      children: [
        for (final opt in options)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AppTappable(
              onTap: () {
                if (multiSelect) {
                  final updated = Set<int>.from(selectedIds);
                  if (updated.contains(opt.optionId)) {
                    updated.remove(opt.optionId);
                  } else {
                    updated.add(opt.optionId);
                  }
                  // Preserve option order and encode as JSON array of strings
                  final ordered = options
                      .map((o) => o.optionId)
                      .where(updated.contains)
                      .map((id) => id.toString())
                      .toList();
                  onChanged(jsonEncode(ordered));
                } else {
                  onChanged(opt.optionId.toString());
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selectedIds.contains(opt.optionId)
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : context.appColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedIds.contains(opt.optionId)
                        ? AppTheme.primary
                        : context.appColors.textMuted.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      multiSelect
                          ? (selectedIds.contains(opt.optionId)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank)
                          : (selectedIds.contains(opt.optionId)
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked),
                      size: 18,
                      color: selectedIds.contains(opt.optionId)
                          ? AppTheme.primary
                          : context.appColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        opt.optionText,
                        style: AppTheme.body.copyWith(
                          color: selectedIds.contains(opt.optionId)
                              ? AppTheme.primary
                              : context.appColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
