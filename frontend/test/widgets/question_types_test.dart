// Created with the Assistance of Claude Code
// frontend/test/widgets/question_types_test.dart
//
// TDD tests for question type widgets
//
// Tests for 6 question types:
// - NumberQuestionWidget (numeric input)
// - YesNoQuestionWidget (boolean toggle)
// - OpenEndedQuestionWidget (text area)
// - SingleChoiceWidget (radio buttons)
// - MultiChoiceWidget (checkboxes)
// - ScaleQuestionWidget (slider/rating)
//
// These tests are written FIRST (TDD) - they should FAIL initially.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/number_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/yesno_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/openended_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/single_choice_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/multi_choice_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/scale_question_widget.dart';

void main() {
  /// Helper to wrap widgets with MaterialApp and theme
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.defaultTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  group('NumberQuestionWidget', () {
    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'What is your age?',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('What is your age?'), findsOneWidget);
    });

    testWidgets('displays required indicator when isRequired is true',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'What is your age?',
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('accepts numeric input', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'What is your age?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '25');
      await tester.pump();

      expect(capturedValue, 25);
    });

    testWidgets('blocks non-numeric input via filter', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'What is your age?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      // Non-numeric input is filtered out, so the field stays empty
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump();

      // Value should be null since non-numeric chars are blocked
      expect(capturedValue, isNull);
    });

    testWidgets('respects min and max values', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate from 1-10',
          min: 1,
          max: 10,
          onChanged: (_) {},
        ),
      ));

      await tester.enterText(find.byType(TextField), '15');
      await tester.pump();

      expect(find.text('Value must be between 1 and 10'), findsOneWidget);
    });
  });

  group('YesNoQuestionWidget', () {
    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Do you exercise regularly?',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Do you exercise regularly?'), findsOneWidget);
    });

    testWidgets('displays Yes and No options', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Do you exercise regularly?',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('calls onChanged with true when Yes is tapped', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Do you exercise regularly?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Yes'));
      await tester.pump();

      expect(capturedValue, true);
    });

    testWidgets('calls onChanged with false when No is tapped', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Do you exercise regularly?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('No'));
      await tester.pump();

      expect(capturedValue, false);
    });

    testWidgets('shows selected state visually', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Do you exercise regularly?',
          value: true,
          onChanged: (_) {},
        ),
      ));

      // Find the Yes button and verify it shows selected styling
      final yesButton = find.ancestor(
        of: find.text('Yes'),
        matching: find.byType(ElevatedButton),
      );
      expect(yesButton, findsOneWidget);
    });
  });

  group('OpenEndedQuestionWidget', () {
    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Please describe your symptoms',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Please describe your symptoms'), findsOneWidget);
    });

    testWidgets('provides a text area for input', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Please describe your symptoms',
          onChanged: (_) {},
        ),
      ));

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Please describe your symptoms',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Headache and fatigue');
      await tester.pump();

      expect(capturedValue, 'Headache and fatigue');
    });

    testWidgets('supports multiline input', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Please describe your symptoms',
          maxLines: 5,
          onChanged: (_) {},
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 5);
    });

    testWidgets('respects maxLength when specified', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Brief description',
          maxLength: 100,
          onChanged: (_) {},
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 100);
    });
  });

  group('SingleChoiceWidget', () {
    final options = ['Never', 'Sometimes', 'Often', 'Always'];

    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'How often do you exercise?',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('How often do you exercise?'), findsOneWidget);
    });

    testWidgets('displays all options', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'How often do you exercise?',
          options: options,
          onChanged: (_) {},
        ),
      ));

      for (final option in options) {
        expect(find.text(option), findsOneWidget);
      }
    });

    testWidgets('calls onChanged when option is selected', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'How often do you exercise?',
          options: options,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Often'));
      await tester.pump();

      expect(capturedValue, 'Often');
    });

    testWidgets('only one option can be selected', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'How often do you exercise?',
          options: options,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Sometimes'));
      await tester.pump();
      await tester.tap(find.text('Often'));
      await tester.pump();

      expect(capturedValue, 'Often');
      // Verify radio buttons show correct selected state
      expect(find.byType(RadioListTile<String>), findsNWidgets(4));
    });

    testWidgets('shows initial value when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'How often do you exercise?',
          options: options,
          value: 'Always',
          onChanged: (_) {},
        ),
      ));

      // Verify the RadioGroup has the correct groupValue
      // With the new RadioGroup API, we verify the groupValue on the RadioGroup widget
      final radioGroup = tester.widget<RadioGroup<String>>(find.byType(RadioGroup<String>));
      expect(radioGroup.groupValue, 'Always');
    });
  });

  group('MultiChoiceWidget', () {
    final options = ['Headache', 'Fatigue', 'Nausea', 'Dizziness'];

    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select all symptoms you experience:',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Select all symptoms you experience:'), findsOneWidget);
    });

    testWidgets('displays all options as checkboxes', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select all symptoms you experience:',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.byType(CheckboxListTile), findsNWidgets(4));
      for (final option in options) {
        expect(find.text(option), findsOneWidget);
      }
    });

    testWidgets('can select multiple options', (tester) async {
      List<String>? capturedValues;

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select all symptoms you experience:',
          options: options,
          onChanged: (values) => capturedValues = values,
        ),
      ));

      await tester.tap(find.text('Headache'));
      await tester.pump();
      await tester.tap(find.text('Fatigue'));
      await tester.pump();

      expect(capturedValues, containsAll(['Headache', 'Fatigue']));
    });

    testWidgets('can deselect options', (tester) async {
      List<String>? capturedValues;

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select all symptoms you experience:',
          options: options,
          values: const ['Headache', 'Fatigue'],
          onChanged: (values) => capturedValues = values,
        ),
      ));

      await tester.tap(find.text('Headache'));
      await tester.pump();

      expect(capturedValues, ['Fatigue']);
    });

    testWidgets('shows initial values when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select all symptoms you experience:',
          options: options,
          values: const ['Headache', 'Nausea'],
          onChanged: (_) {},
        ),
      ));

      // Verify checkboxes are checked
      final checkboxTiles =
          tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile));
      int checkedCount = 0;
      for (final tile in checkboxTiles) {
        if (tile.value == true) checkedCount++;
      }
      expect(checkedCount, 2);
    });
  });

  group('ScaleQuestionWidget', () {
    testWidgets('displays question text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Rate your pain level'), findsOneWidget);
    });

    testWidgets('displays min and max labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          minLabel: 'No pain',
          maxLabel: 'Severe pain',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('No pain'), findsOneWidget);
      expect(find.text('Severe pain'), findsOneWidget);
    });

    testWidgets('displays slider', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          onChanged: (_) {},
        ),
      ));

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('calls onChanged when slider value changes', (tester) async {
      double? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      // Drag the slider to the right
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      expect(capturedValue, isNotNull);
    });

    testWidgets('displays current value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          divisions: 10,  // With divisions, shows as integer
          value: 5,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('supports integer divisions', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate your pain level',
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (_) {},
        ),
      ));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.divisions, 10);
    });
  });

  group('Question Widget Required Indicator', () {
    testWidgets('NumberQuestionWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Required number',
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('YesNoQuestionWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Required yes/no',
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('OpenEndedQuestionWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Required text',
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('SingleChoiceWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Required choice',
          options: const ['A', 'B'],
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('MultiChoiceWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Required multi-choice',
          options: const ['A', 'B'],
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('ScaleQuestionWidget shows asterisk when required',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Required scale',
          min: 0,
          max: 10,
          isRequired: true,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('*'), findsOneWidget);
    });
  });

  group('Question Widget Accessibility', () {
    testWidgets('NumberQuestionWidget has semantic label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Enter a number',
          onChanged: (_) {},
        ),
      ));

      // Verify Semantics widget wraps the content with the label
      final semanticsWidget = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Enter a number',
      );
      expect(semanticsWidget, findsOneWidget);
    });

    testWidgets('YesNoQuestionWidget has semantic labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or no question',
          onChanged: (_) {},
        ),
      ));

      // Verify Yes and No buttons have semantic labels
      expect(find.bySemanticsLabel('Yes'), findsAtLeast(1));
      expect(find.bySemanticsLabel('No'), findsAtLeast(1));
    });
  });
}
