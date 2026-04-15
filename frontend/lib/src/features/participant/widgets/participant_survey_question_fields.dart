// Created with the Assistance of Codex
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/widgets/basics/basics.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Participant-facing survey question renderer and input widgets.
class ParticipantSurveyQuestionField extends StatelessWidget {
  const ParticipantSurveyQuestionField({
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
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          _QuestionInput(
            question: question,
            value: value,
            onChanged: onChanged,
            l10n: l10n,
          ),
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
}

class _QuestionInput extends StatelessWidget {
  const _QuestionInput({
    required this.question,
    required this.value,
    required this.onChanged,
    required this.l10n,
  });

  final ParticipantSurveyQuestion question;
  final String? value;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return switch (question.responseType) {
      'yesno' => _YesNoInput(
          value: value,
          onChanged: onChanged,
          l10n: l10n,
        ),
      'scale' => _ScaleInput(
          value: value,
          onChanged: onChanged,
          min: (question.scaleMin ?? 1).toDouble(),
          max: (question.scaleMax ?? 10).toDouble(),
        ),
      'number' => _NumberInput(
          value: value,
          onChanged: onChanged,
        ),
      'single_choice' => _ChoiceInput(
          value: value,
          options: question.options ?? const [],
          onChanged: onChanged,
          multiSelect: false,
        ),
      'multi_choice' => _ChoiceInput(
          value: value,
          options: question.options ?? const [],
          onChanged: onChanged,
          multiSelect: true,
        ),
      _ => _TextInput(
          value: value,
          onChanged: onChanged,
        ),
    };
  }
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant _TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _NumberInput extends StatefulWidget {
  const _NumberInput({
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant _NumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _ScaleInput extends StatefulWidget {
  const _ScaleInput({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final String? value;
  final ValueChanged<String> onChanged;
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
      _syncFromWidget();
    }
  }

  void _syncFromWidget() {
    _current = (double.tryParse(widget.value ?? '') ?? widget.min)
        .clamp(widget.min, widget.max);
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
                onChanged: (value) {
                  setState(() => _current = value);
                  widget.onChanged(value.round().toString());
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
      ],
    );
  }
}

class _YesNoInput extends StatelessWidget {
  const _YesNoInput({
    required this.value,
    required this.onChanged,
    required this.l10n,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;

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
            color: selected ? color : context.appColors.textMuted.withValues(alpha: 0.3),
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
    required this.multiSelect,
  });

  final String? value;
  final List<ParticipantQuestionOption> options;
  final ValueChanged<String> onChanged;
  final bool multiSelect;

  Set<int> get _selectedIds {
    if (value == null || value!.trim().isEmpty) return {};

    if (!multiSelect) {
      final id = int.tryParse(value!.trim());
      return id != null ? {id} : {};
    }

    try {
      final decoded = jsonDecode(value!);
      if (decoded is List) {
        return decoded
            .map((entry) => int.tryParse(entry.toString().trim()))
            .whereType<int>()
            .toSet();
      }
    } catch (_) {}

    return value!
        .split(',')
        .map((entry) => int.tryParse(entry.trim()))
        .whereType<int>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIds = _selectedIds;

    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AppTappable(
              onTap: () {
                if (multiSelect) {
                  final updated = Set<int>.from(selectedIds);
                  if (updated.contains(option.optionId)) {
                    updated.remove(option.optionId);
                  } else {
                    updated.add(option.optionId);
                  }
                  final ordered = options
                      .map((entry) => entry.optionId)
                      .where(updated.contains)
                      .map((entry) => entry.toString())
                      .toList();
                  onChanged(jsonEncode(ordered));
                  return;
                }

                onChanged(option.optionId.toString());
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selectedIds.contains(option.optionId)
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : context.appColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedIds.contains(option.optionId)
                        ? AppTheme.primary
                        : context.appColors.textMuted.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      multiSelect
                          ? (selectedIds.contains(option.optionId)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank)
                          : (selectedIds.contains(option.optionId)
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked),
                      size: 18,
                      color: selectedIds.contains(option.optionId)
                          ? AppTheme.primary
                          : context.appColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.optionText,
                        style: AppTheme.body.copyWith(
                          color: selectedIds.contains(option.optionId)
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
