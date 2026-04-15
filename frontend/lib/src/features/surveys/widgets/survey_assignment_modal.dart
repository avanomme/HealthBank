// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/surveys/widgets/survey_assignment_modal.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import '../state/survey_providers.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Opens the assignment management modal for a published survey.
Future<void> showSurveyAssignmentModal(
  BuildContext context, {
  required int surveyId,
  required String surveyTitle,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) =>
        _SurveyAssignmentModal(surveyId: surveyId, surveyTitle: surveyTitle),
  );
}

enum _AssignMode { all, demographic }

enum _DemographicGender { all, male, female, nonBinary, unspecified }

/// Modal dialog for managing survey assignments.
///
/// Privacy: aggregate-only assignment data is shown; no participant identifiers.
class _SurveyAssignmentModal extends ConsumerStatefulWidget {
  const _SurveyAssignmentModal({
    required this.surveyId,
    required this.surveyTitle,
  });

  final int surveyId;
  final String surveyTitle;

  @override
  ConsumerState<_SurveyAssignmentModal> createState() =>
      _SurveyAssignmentModalState();
}

class _SurveyAssignmentModalState
    extends ConsumerState<_SurveyAssignmentModal> {
  static const int _ageUpperBound = 999;

  final _formKey = GlobalKey<FormState>();
  final _ageMinController = TextEditingController(text: '0');
  final _ageMaxController = TextEditingController(text: '999');

  _AssignMode _assignMode = _AssignMode.all;
  _DemographicGender _selectedGender = _DemographicGender.all;
  DateTime? _dueDate;
  bool _isAssigning = false;
  String? _errorMessage;
  BulkAssignmentResult? _lastBulkResult;

  @override
  void dispose() {
    _ageMinController.dispose();
    _ageMaxController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  int? _parseAgeValue(String rawValue) => int.tryParse(rawValue.trim());

  AssignmentTargetPreviewParams? _buildPreviewParams() {
    int? ageMin;
    int? ageMax;
    String? gender;

    if (_assignMode == _AssignMode.demographic) {
      ageMin = _parseAgeValue(_ageMinController.text);
      ageMax = _parseAgeValue(_ageMaxController.text);
      gender = _buildGenderPayloadValue();

      if (ageMin == null || ageMax == null || ageMin > ageMax) {
        return null;
      }
    }

    return AssignmentTargetPreviewParams(
      surveyId: widget.surveyId,
      gender: gender,
      ageMin: ageMin,
      ageMax: ageMax,
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  String? _validateAgeField(String? rawValue, AppLocalizations l10n) {
    final value = rawValue?.trim() ?? '';
    if (value.isEmpty) {
      return l10n.surveyAssignAgeValidationRequired;
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return l10n.surveyAssignAgeValidationInteger;
    }
    if (parsed < 0) {
      return l10n.surveyAssignAgeValidationNonNegative;
    }
    if (parsed > _ageUpperBound) {
      return l10n.surveyAssignAgeValidationUpperBound(_ageUpperBound);
    }

    return null;
  }

  String? _buildGenderPayloadValue() {
    switch (_selectedGender) {
      case _DemographicGender.all:
        return null;
      case _DemographicGender.male:
        return 'Male';
      case _DemographicGender.female:
        return 'Female';
      case _DemographicGender.nonBinary:
        return 'Non-binary';
      case _DemographicGender.unspecified:
        // Current backend performs equality filtering on Gender.
        return 'Prefer Not to Say';
    }
  }

  Future<void> _assignBulk(AppLocalizations l10n) async {
    int? ageMin;
    int? ageMax;

    if (_assignMode == _AssignMode.demographic) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) {
        return;
      }

      ageMin = int.tryParse(_ageMinController.text.trim());
      ageMax = int.tryParse(_ageMaxController.text.trim());

      if (ageMin == null || ageMax == null) {
        setState(() => _errorMessage = l10n.surveyAssignAgeValidationInteger);
        return;
      }

      if (ageMin > ageMax) {
        setState(() => _errorMessage = l10n.surveyAssignAgeValidationRange);
        return;
      }
    }

    setState(() {
      _isAssigning = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(assignmentApiProvider);
      final gender = _buildGenderPayloadValue();

      final body = <String, dynamic>{
        'assign_all': _assignMode == _AssignMode.all,
        if (_assignMode == _AssignMode.demographic) 'age_min': ageMin,
        if (_assignMode == _AssignMode.demographic) 'age_max': ageMax,
        if (_assignMode == _AssignMode.demographic && gender != null)
          'gender': gender,
        if (_dueDate != null) 'due_date': _dueDate!.toIso8601String(),
      };

      final result = await api.assignSurveyBulk(widget.surveyId, body);

      ref.invalidate(surveyAssignmentsProvider(widget.surveyId));

      if (!mounted) return;

      setState(() {
        _isAssigning = false;
        _dueDate = null;
        _lastBulkResult = result;
      });

      AppToast.showSuccess(
        context,
        message: l10n.surveyAssignBulkResult(
          result.totalTargeted,
          result.assigned,
          result.skipped,
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final detail = e.response?.data?['detail'] as String? ?? '';
      final msg = e.response?.statusCode == 400 && detail.contains('published')
          ? l10n.surveyAssignErrorNotPublished
          : l10n.surveyAssignErrorGeneral;
      setState(() {
        _isAssigning = false;
        _errorMessage = msg;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isAssigning = false;
        _errorMessage = l10n.surveyAssignErrorGeneral;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(l10n),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.surveyTitle,
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTargetSelection(l10n),
                    if (_assignMode == _AssignMode.demographic) ...[
                      const SizedBox(height: 12),
                      _buildDemographicFilters(l10n),
                    ],
                    const SizedBox(height: 12),
                    _buildAssignmentTargetCounter(),
                    const SizedBox(height: 8),
                    _buildDueDatePicker(l10n),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Semantics(

                        liveRegion: true,

                        child: Text(
                        _errorMessage!,
                        style: AppTheme.captions.copyWith(
                          color: AppTheme.error,
                        ),

                      )
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildAssignButton(l10n),
                    if (_lastBulkResult != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.surveyAssignBulkResult(
                          _lastBulkResult!.totalTargeted,
                          _lastBulkResult!.assigned,
                          _lastBulkResult!.skipped,
                        ),
                        style: AppTheme.captions.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ],
                    const Divider(height: 32),
                    Text(
                      l10n.surveyAssignments,
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAssignmentSummary(l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_ind,
            color: AppTheme.textContrast,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                l10n.surveyAssignTitle,
                style: AppTheme.heading3.copyWith(
                  color: AppTheme.textContrast,
                ),
              ),
            ),
          ),
          IconButton(
                    tooltip: context.l10n.tooltipClose,
            icon: const Icon(Icons.close, color: AppTheme.textContrast),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetSelection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.surveyAssignTargetLabel,
          style: AppTheme.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        RadioGroup<_AssignMode>(
          groupValue: _assignMode,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _assignMode = value;
              _errorMessage = null;
            });
          },
          child: Column(
            children: [
              RadioListTile<_AssignMode>(
                value: _AssignMode.all,
                title: Text(
                  l10n.surveyAssignTargetAll,
                  style: AppTheme.body,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              RadioListTile<_AssignMode>(
                value: _AssignMode.demographic,
                title: Text(
                  l10n.surveyAssignTargetDemographic,
                  style: AppTheme.body,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDemographicFilters(AppLocalizations l10n) {
    return Column(
      children: [
        DropdownButtonFormField<_DemographicGender>(
          key: ValueKey(_selectedGender),
          initialValue: _selectedGender,
          decoration: InputDecoration(
            labelText: l10n.surveyAssignGenderLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            isDense: true,
          ),
          items: [
            DropdownMenuItem(
              value: _DemographicGender.all,
              child: Text(l10n.surveyAssignGenderAll),
            ),
            DropdownMenuItem(
              value: _DemographicGender.male,
              child: Text(l10n.surveyAssignGenderMale),
            ),
            DropdownMenuItem(
              value: _DemographicGender.female,
              child: Text(l10n.surveyAssignGenderFemale),
            ),
            DropdownMenuItem(
              value: _DemographicGender.nonBinary,
              child: Text(l10n.surveyAssignGenderNonBinary),
            ),
            DropdownMenuItem(
              value: _DemographicGender.unspecified,
              child: Text(l10n.surveyAssignGenderUnspecified),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedGender = value);
          },
        ),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageMinController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.surveyAssignAgeMinLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  validator: (value) =>
                      _validateAgeField(value, l10n),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _ageMaxController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.surveyAssignAgeMaxLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  validator: (value) =>
                      _validateAgeField(value, l10n),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDueDatePicker(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: AppOutlinedButton(
            label: _dueDate != null
                ? l10n.surveyAssignmentDueDate(
                    _formatDate(_dueDate!),
                  )
                : l10n.surveyAssignDueDate,
            onPressed: _pickDueDate,
            icon: Icons.calendar_today,
          ),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () => setState(() => _dueDate = null),
            tooltip: l10n.surveyAssignClearDueDate,
          ),
        ],
      ],
    );
  }

  Widget _buildAssignButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: AppFilledButton(
        label: _isAssigning
            ? '...'
            : l10n.surveyAssignButton,
        onPressed: _isAssigning
            ? null
            : () => _assignBulk(l10n),
        backgroundColor: AppTheme.primary,
        textColor: AppTheme.textContrast,
      ),
    );
  }

  Widget _buildAssignmentSummary(AppLocalizations l10n) {
    final assignmentsAsync = ref.watch(
      surveyAssignmentsProvider(widget.surveyId),
    );

    return assignmentsAsync.when(
      data: (assignments) {
        if (assignments.isEmpty) {
          return Text(
            l10n.surveyAssignSummaryNone,
            style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
          );
        }

        final total = assignments.length;
        final pending = assignments.where((a) => a.status == 'pending').length;
        final completed = assignments
            .where((a) => a.status == 'completed')
            .length;
        final expired = assignments.where((a) => a.status == 'expired').length;

        return Text(
          '${l10n.surveyAssignSummaryTotal(total)}'
          '  •  ${l10n.surveyAssignSummaryPending(pending)}'
          '  •  ${l10n.surveyAssignSummaryCompleted(completed)}'
          '  •  ${l10n.surveyAssignSummaryExpired(expired)}',
          style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator.inline(),
              const SizedBox(height: 8),
              Text(
                l10n.surveyAssignLoading,
                style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
              ),
            ],
          ),
        ),
      ),
      error: (_, __) => Text(
        l10n.surveyAssignErrorLoad,
        style: AppTheme.captions.copyWith(color: AppTheme.error),
      ),
    );
  }

  Widget _buildAssignmentTargetCounter() {
    final previewParams = _buildPreviewParams();
    if (previewParams == null) {
      return Text(
        'Assigning survey to ... participants',
        style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
      );
    }

    final previewAsync = ref.watch(
      assignmentTargetPreviewProvider(previewParams),
    );

    return previewAsync.when(
      data: (preview) => Text(
        'Assigning survey to ${preview.assignable} participants',
        style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
      ),
      loading: () => Text(
        'Assigning survey to ... participants',
        style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
      ),
      error: (_, __) => Text(
        'Assigning survey to ... participants',
        style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
      ),
    );
  }
}
