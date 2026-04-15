// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/multi_choice_widget.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Widget for multi-choice questions.
///
/// Displays checkboxes for selecting multiple options from a list.
class MultiChoiceWidget extends StatefulWidget {
  const MultiChoiceWidget({
    super.key,
    required this.questionText,
    required this.options,
    required this.onChanged,
    this.values = const [],
    this.isRequired = false,
  });

  /// The question text to display
  final String questionText;

  /// List of available options
  final List<String> options;

  /// Callback when the values change
  final ValueChanged<List<String>> onChanged;

  /// Currently selected options
  final List<String> values;

  /// Whether this question is required
  final bool isRequired;

  @override
  State<MultiChoiceWidget> createState() => _MultiChoiceWidgetState();
}

class _MultiChoiceWidgetState extends State<MultiChoiceWidget> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.values);
  }

  @override
  void didUpdateWidget(MultiChoiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      _selectedValues = List.from(widget.values);
    }
  }

  void _toggleOption(String option, bool? selected) {
    setState(() {
      if (selected == true) {
        if (!_selectedValues.contains(option)) {
          _selectedValues.add(option);
        }
      } else {
        _selectedValues.remove(option);
      }
    });
    widget.onChanged(List.from(_selectedValues));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.questionText,
                style: AppTheme.body,
              ),
            ),
            if (widget.isRequired)
              Text(
                '*',
                style: AppTheme.body.copyWith(color: AppTheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.options.map((option) => CheckboxListTile(
              title: Text(option),
              value: _selectedValues.contains(option),
              onChanged: (selected) => _toggleOption(option, selected),
              activeColor: AppTheme.primary,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            )),
      ],
    );
  }
}
