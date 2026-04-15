// Created with the Assistance of Codex
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantAssignmentsProvider;
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/participant/widgets/participant_survey_before_unload.dart';
import 'package:frontend/src/features/participant/widgets/participant_survey_question_fields.dart';
import 'package:go_router/go_router.dart';

/// Dedicated participant survey-taking page with server-backed draft resume.
class ParticipantSurveyTakingPage extends ConsumerStatefulWidget {
  const ParticipantSurveyTakingPage({super.key, required this.surveyId});

  final int surveyId;

  @override
  ConsumerState<ParticipantSurveyTakingPage> createState() =>
      _ParticipantSurveyTakingPageState();
}

class _ParticipantSurveyTakingPageState
    extends ConsumerState<ParticipantSurveyTakingPage>
    with WidgetsBindingObserver {
  static const _autoSaveInterval = Duration(minutes: 2);
  static const _draftSaveDebounceDuration = Duration(milliseconds: 800);

  final Map<int, String> _responses = {};
  final Map<int, String> _validationErrors = {};

  Timer? _autoSaveTimer;
  Timer? _draftSaveDebounce;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  bool _isSavingDraft = false;
  bool _draftLoaded = false;
  String? _submitError;
  String _lastSavedDraftSignature = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDraft();
    _autoSaveTimer = Timer.periodic(_autoSaveInterval, (_) {
      unawaited(_saveDraft());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSaveTimer?.cancel();
    _draftSaveDebounce?.cancel();
    unawaited(_saveDraft());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      unawaited(_saveDraft());
    }
  }

  Future<void> _loadDraft() async {
    try {
      final api = ref.read(participantApiProvider);
      final response = await api.getDraft(widget.surveyId);
      if (!mounted) return;

      setState(() {
        _draftLoaded = true;
        for (final entry in response.draft.entries) {
          _responses[int.parse(entry.key)] = entry.value;
        }
        _lastSavedDraftSignature = _currentDraftSignature();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _draftLoaded = true);
    }
  }

  String _currentDraftSignature() {
    final sortedEntries = _responses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries.map((e) => '${e.key}:${e.value}').join('|');
  }

  void _scheduleDraftSave() {
    if (_isSubmitted) return;

    _draftSaveDebounce?.cancel();
    _draftSaveDebounce = Timer(_draftSaveDebounceDuration, () {
      unawaited(_saveDraft());
    });
  }

  Future<void> _saveDraft() async {
    if (_isSubmitted || _isSavingDraft || _responses.isEmpty) return;

    final signature = _currentDraftSignature();
    if (signature == _lastSavedDraftSignature) return;

    try {
      _isSavingDraft = true;
      final api = ref.read(participantApiProvider);
      await api.saveDraft(widget.surveyId, {
        'question_responses': _responses.entries
            .map(
              (entry) => {
                'question_id': entry.key,
                'response_value': entry.value,
              },
            )
            .toList(),
      });
      _lastSavedDraftSignature = signature;
      if (!mounted) return;
      ref.invalidate(participantSurveysProvider);
    } catch (_) {
      // Draft saving remains best-effort to avoid blocking survey taking.
    } finally {
      _isSavingDraft = false;
    }
  }

  Future<void> _leaveSurveyPage() async {
    if (!_isSubmitted) {
      await _saveDraft();
    }
    if (!mounted) return;
    context.go('/participant/surveys');
  }

  bool _validate(
    List<ParticipantSurveyQuestion> questions,
    AppLocalizations l10n,
  ) {
    final errors = <int, String>{};
    for (final question in questions) {
      if (!question.isRequired) continue;
      final value = _responses[question.questionId];
      if (value == null || value.trim().isEmpty) {
        errors[question.questionId] = l10n.surveyTakingRequiredError;
      }
    }

    setState(() {
      _validationErrors
        ..clear()
        ..addAll(errors);
    });

    return errors.isEmpty;
  }

  Future<void> _submit(
    List<ParticipantSurveyQuestion> questions,
    AppLocalizations l10n,
  ) async {
    if (!_validate(questions, l10n)) {
      AppToast.showError(context, message: l10n.surveyTakingValidationError);
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.surveyTakingConfirmSubmitTitle,
      content: l10n.surveyTakingConfirmSubmitMessage,
      confirmLabel: l10n.surveyTakingSubmit,
      cancelLabel: l10n.commonCancel,
      confirmColor: AppTheme.primary,
    );
    if (!confirmed) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final api = ref.read(participantApiProvider);
      await api.submitSurvey(widget.surveyId, {
        'question_responses': _responses.entries
            .map(
              (entry) => {
                'question_id': entry.key,
                'response_value': entry.value,
              },
            )
            .toList(),
      });

      _isSubmitted = true;
      ref.invalidate(participantSurveysProvider);
      ref.invalidate(participantSurveyQuestionsProvider(widget.surveyId));
      ref.invalidate(participantAssignmentsProvider);
      ref.invalidate(participantSurveyDataProvider);

      if (!mounted) return;
      AppToast.showSuccess(context, message: l10n.surveySubmitSuccess);
      context.go('/participant/surveys');
    } on DioException catch (error) {
      if (!mounted) return;
      final detail = (error.response?.data?['detail'] as String? ?? '')
          .toLowerCase();
      final code = error.response?.statusCode;
      String message;

      if (code == 400 && detail.contains('already')) {
        message = l10n.surveySubmitErrorAlreadySubmitted;
      } else if (code == 400 && detail.contains('expir')) {
        message = l10n.surveySubmitErrorExpired;
      } else if (code == 400 && detail.contains('publish')) {
        message = l10n.surveySubmitErrorNotPublished;
      } else if (code == 403) {
        message = l10n.surveySubmitErrorNotAssigned;
      } else if (code == 404) {
        message = l10n.surveySubmitErrorNotFound;
      } else if (code != null && code >= 500) {
        message = l10n.surveySubmitErrorServer;
      } else {
        message = l10n.surveySubmitErrorGeneral;
      }

      setState(() {
        _isSubmitting = false;
        _submitError = message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitError = l10n.surveyTakingNetworkError;
      });
    }
  }

  void _updateResponse(int questionId, String value) {
    setState(() {
      _responses[questionId] = value;
      _validationErrors.remove(questionId);
    });
    _scheduleDraftSave();
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surveysAsync = ref.watch(participantSurveysProvider);
    final surveyAsync = ref.watch(
      participantSurveyQuestionsProvider(widget.surveyId),
    );

    final surveyListItem = surveysAsync.maybeWhen(
      data: (surveys) => surveys
          .where((survey) => survey.surveyId == widget.surveyId)
          .firstOrNull,
      orElse: () => null,
    );

    return ParticipantSurveyBeforeUnload(
      onBeforeUnload: () {
        unawaited(_saveDraft());
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) async {
          if (didPop) return;
          await _saveDraft();
          if (context.mounted) Navigator.pop(context);
        },
        child: ParticipantScaffold(
          currentRoute: '/participant/surveys',
          alignment: AppPageAlignment.wide,
          bodyBehavior: AppPageBodyBehavior.edgeToEdge,
          showFooter: true,
          child: surveyAsync.when(
            data: (survey) => _buildLoadedState(
              context,
              survey: survey,
              surveyListItem: surveyListItem,
              l10n: l10n,
            ),
            loading: () => _buildLoadingState(l10n),
            error: (_, __) => _buildErrorState(l10n, surveyListItem),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context, {
    required ParticipantSurveyQuestionsResponse survey,
    required ParticipantSurveyListItem? surveyListItem,
    required AppLocalizations l10n,
  }) {
    final questions = survey.questions;

    return Column(
      children: [
        _buildTopBar(l10n),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: AppPageAlignedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleCard(
                  title: survey.title,
                  dueDate: surveyListItem?.dueDate,
                  questionCount: questions.length,
                  hasDraft: surveyListItem?.hasDraft ?? _responses.isNotEmpty,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),
                if (questions.isEmpty)
                  AppEmptyState(
                    icon: Icons.assignment_outlined,
                    title: l10n.participantNoSurveys,
                  )
                else
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final question in questions)
                            ParticipantSurveyQuestionField(
                              key: ValueKey(question.questionId),
                              question: question,
                              value: _responses[question.questionId],
                              error: _validationErrors[question.questionId],
                              onChanged: (value) =>
                                  _updateResponse(question.questionId, value),
                              l10n: l10n,
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildSubmitArea(l10n: l10n, questions: questions),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(
          bottom: BorderSide(color: context.appColors.divider),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _leaveSurveyPage,
            tooltip: l10n.surveyTakingBackToSurveys,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Semantics(header: true, child: Text(l10n.surveyTakingTitle, style: AppTheme.heading4)),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleCard({
    required String title,
    required DateTime? dueDate,
    required int questionCount,
    required bool hasDraft,
    required AppLocalizations l10n,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 10, color: AppTheme.primary),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: AppTheme.heading4)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.help_outline,
                      label: l10n.surveyTakingQuestionCount(questionCount),
                    ),
                    if (dueDate != null)
                      _MetaChip(
                        icon: Icons.schedule,
                        label: l10n.participantSurveyDueDate(
                          _formatDate(dueDate),
                        ),
                      ),
                    if (_draftLoaded && hasDraft)
                      _MetaChip(
                        icon: Icons.save_outlined,
                        label: l10n.participantSurveyStatusIncomplete,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitArea({
    required AppLocalizations l10n,
    required List<ParticipantSurveyQuestion> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_submitError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
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
                      style: AppTheme.captions.copyWith(color: AppTheme.error),
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
          onPressed: _isSubmitting ? null : () => _submit(questions, l10n),
          backgroundColor: AppTheme.primary,
          textColor: AppTheme.textContrast,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ],
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLoadingIndicator(centered: false),
          const SizedBox(height: 16),
          Text(
            l10n.surveyTakingLoadingQuestions,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    AppLocalizations l10n,
    ParticipantSurveyListItem? surveyListItem,
  ) {
    final isExpired = surveyListItem?.assignmentStatus == 'expired';
    final isClosed =
        surveyListItem != null &&
        surveyListItem.assignmentStatus != 'pending' &&
        !surveyListItem.hasDraft;

    return AppEmptyState.error(
      title: isExpired
          ? l10n.surveyTakingExpired
          : isClosed
              ? l10n.surveyTakingClosed
              : l10n.surveyTakingNetworkError,
      action: AppOutlinedButton(
        label: l10n.surveyTakingRetry,
        onPressed: () =>
            ref.invalidate(participantSurveyQuestionsProvider(widget.surveyId)),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.appColors.textMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style:
                AppTheme.captions.copyWith(color: context.appColors.textPrimary),
          ),
        ],
      ),
    );
  }
}