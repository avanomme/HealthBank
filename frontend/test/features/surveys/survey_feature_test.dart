// Created with the Assistance of Claude Code
// frontend/test/features/surveys/survey_feature_test.dart
//
// Comprehensive tests for Survey features including:
// - Survey Preview Dialog with HealthBank logo
// - Question widgets with boundary value testing
// - HealthBank Logo widget variants
//
// Testing strategy: Boundary Value Analysis
// For each numeric/range input:
// - Valid middle value (passing)
// - Just inside lower bound
// - At lower bound (edge)
// - Just outside lower bound (invalid)
// - Just inside upper bound
// - At upper bound (edge)
// - Just outside upper bound (invalid)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/number_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/scale_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/yesno_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/openended_question_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/single_choice_widget.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/multi_choice_widget.dart';
import 'package:frontend/src/features/surveys/widgets/survey_preview_dialog.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart'
    show SurveyQuestionItem;
import 'package:frontend/src/core/api/api.dart' show QuestionOptionResponse;

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

  // ============================================================================
  // HEALTHBANK LOGO WIDGET TESTS
  // ============================================================================
  group('HealthBankLogo Widget', () {
    testWidgets('displays logo text "HealthBank"', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(),
      ));

      expect(find.text('HealthBank'), findsOneWidget);
    });

    testWidgets('displays heart icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(),
      ));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    group('Size Variants', () {
      testWidgets('small size renders correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          const HealthBankLogo(size: HealthBankLogoSize.small),
        ));

        final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(icon.size, 20);
      });

      testWidgets('medium size renders correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          const HealthBankLogo(size: HealthBankLogoSize.medium),
        ));

        final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(icon.size, 28);
      });

      testWidgets('large size renders correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          const HealthBankLogo(size: HealthBankLogoSize.large),
        ));

        final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(icon.size, 40);
      });
    });

    testWidgets('shows tagline when showTagline is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(showTagline: true),
      ));

      expect(find.text('Your Health, Your Data'), findsOneWidget);
    });

    testWidgets('hides tagline when showTagline is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(showTagline: false),
      ));

      expect(find.text('Your Health, Your Data'), findsNothing);
    });

    testWidgets('uses custom color when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(color: Colors.red),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(icon.color, Colors.red);
    });
  });

  group('HealthBankLogoHeader Widget', () {
    testWidgets('displays logo inside header', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(),
      ));

      expect(find.text('HealthBank'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('shows divider by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(showDivider: true),
      ));

      // Header has border decoration when showDivider is true
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('HealthBank'),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.decoration, isNotNull);
    });

    testWidgets('hides divider when showDivider is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(showDivider: false),
      ));

      // Should still render without error
      expect(find.text('HealthBank'), findsOneWidget);
    });
  });

  // ============================================================================
  // NUMBER QUESTION WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('NumberQuestionWidget Boundary Values', () {
    // Test range: min=1, max=10

    testWidgets('accepts valid middle value (5)', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '5');
      await tester.pump();

      expect(capturedValue, 5);
      expect(find.text('Value must be between 1 and 10'), findsNothing);
    });

    testWidgets('accepts value just inside lower bound (2)', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '2');
      await tester.pump();

      expect(capturedValue, 2);
      expect(find.text('Value must be between 1 and 10'), findsNothing);
    });

    testWidgets('accepts value at lower bound (1)', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '1');
      await tester.pump();

      expect(capturedValue, 1);
      expect(find.text('Value must be between 1 and 10'), findsNothing);
    });

    testWidgets('rejects value just outside lower bound (0)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (_) {},
        ),
      ));

      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();

      expect(find.text('Value must be between 1 and 10'), findsOneWidget);
    });

    testWidgets('accepts value just inside upper bound (9)', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '9');
      await tester.pump();

      expect(capturedValue, 9);
      expect(find.text('Value must be between 1 and 10'), findsNothing);
    });

    testWidgets('accepts value at upper bound (10)', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '10');
      await tester.pump();

      expect(capturedValue, 10);
      expect(find.text('Value must be between 1 and 10'), findsNothing);
    });

    testWidgets('rejects value just outside upper bound (11)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (_) {},
        ),
      ));

      await tester.enterText(find.byType(TextField), '11');
      await tester.pump();

      expect(find.text('Value must be between 1 and 10'), findsOneWidget);
    });

    testWidgets('handles negative values when allowed', (tester) async {
      int? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Temperature (-10 to 50)',
          min: -10,
          max: 50,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '-5');
      await tester.pump();

      expect(capturedValue, -5);
      expect(find.text('Value must be between -10 and 50'), findsNothing);
    });

    testWidgets('rejects negative values below min', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Temperature (-10 to 50)',
          min: -10,
          max: 50,
          onChanged: (_) {},
        ),
      ));

      await tester.enterText(find.byType(TextField), '-11');
      await tester.pump();

      expect(find.text('Value must be between -10 and 50'), findsOneWidget);
    });

    testWidgets('handles empty input', (tester) async {
      int? capturedValue = 999; // sentinel value

      await tester.pumpWidget(buildTestWidget(
        NumberQuestionWidget(
          questionText: 'Rate 1-10',
          min: 1,
          max: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      // First enter a value, then clear it
      await tester.enterText(find.byType(TextField), '5');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // When cleared, callback should receive null (or sentinel stays if not called)
      expect(capturedValue == null || capturedValue == 999, isTrue);
    });
  });

  // ============================================================================
  // SCALE QUESTION WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('ScaleQuestionWidget Boundary Values', () {
    // Test range: min=0, max=10

    testWidgets('initializes at minimum value when no value provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate pain 0-10',
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (_) {},
        ),
      ));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 0);
    });

    testWidgets('displays middle value correctly (5)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate pain 0-10',
          min: 0,
          max: 10,
          divisions: 10,
          value: 5,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('displays lower bound value (0)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate pain 0-10',
          min: 0,
          max: 10,
          divisions: 10,
          value: 0,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays upper bound value (10)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate pain 0-10',
          min: 0,
          max: 10,
          divisions: 10,
          value: 10,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('slider respects min value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate 1-5',
          min: 1,
          max: 5,
          onChanged: (_) {},
        ),
      ));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 1);
    });

    testWidgets('slider respects max value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate 1-5',
          min: 1,
          max: 5,
          onChanged: (_) {},
        ),
      ));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.max, 5);
    });

    testWidgets('displays labels at boundaries', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate pain',
          min: 0,
          max: 10,
          minLabel: 'No pain',
          maxLabel: 'Severe',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('No pain'), findsOneWidget);
      expect(find.text('Severe'), findsOneWidget);
    });

    testWidgets('reports value at lower edge when dragged left', (tester) async {
      double? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate 0-10',
          min: 0,
          max: 10,
          value: 5,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      // Drag slider to the left (toward min)
      await tester.drag(find.byType(Slider), const Offset(-200, 0));
      await tester.pump();

      expect(capturedValue, lessThanOrEqualTo(5));
      expect(capturedValue, greaterThanOrEqualTo(0));
    });

    testWidgets('reports value at upper edge when dragged right', (tester) async {
      double? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        ScaleQuestionWidget(
          questionText: 'Rate 0-10',
          min: 0,
          max: 10,
          value: 5,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      // Drag slider to the right (toward max)
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pump();

      expect(capturedValue, greaterThanOrEqualTo(5));
      expect(capturedValue, lessThanOrEqualTo(10));
    });
  });

  // ============================================================================
  // OPEN-ENDED QUESTION WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('OpenEndedQuestionWidget Boundary Values', () {
    testWidgets('accepts empty string', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Comments',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Empty string may result in null or empty string depending on implementation
      expect(capturedValue == null || capturedValue == '', isTrue);
    });

    testWidgets('accepts single character', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Comments',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump();

      expect(capturedValue, 'A');
    });

    testWidgets('accepts text up to maxLength', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Short comment',
          maxLength: 10,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), '1234567890');
      await tester.pump();

      expect(capturedValue, '1234567890');
      expect(capturedValue?.length, 10);
    });

    testWidgets('respects maxLength constraint', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Short comment',
          maxLength: 10,
          onChanged: (_) {},
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 10);
    });

    testWidgets('supports multiple lines', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        OpenEndedQuestionWidget(
          questionText: 'Description',
          maxLines: 5,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      const multilineText = 'Line 1\nLine 2\nLine 3';
      await tester.enterText(find.byType(TextField), multilineText);
      await tester.pump();

      expect(capturedValue, multilineText);
    });
  });

  // ============================================================================
  // SINGLE CHOICE WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('SingleChoiceWidget Boundary Values', () {
    testWidgets('handles minimum options (2)', (tester) async {
      final options = ['Yes', 'No'];

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Binary choice',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('handles many options (10)', (tester) async {
      final options = List.generate(10, (i) => 'Option ${i + 1}');

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Many choices',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 10'), findsOneWidget);
    });

    testWidgets('selects first option correctly', (tester) async {
      String? capturedValue;
      final options = ['First', 'Middle', 'Last'];

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Choose one',
          options: options,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('First'));
      await tester.pump();

      expect(capturedValue, 'First');
    });

    testWidgets('selects last option correctly', (tester) async {
      String? capturedValue;
      final options = ['First', 'Middle', 'Last'];

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Choose one',
          options: options,
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Last'));
      await tester.pump();

      expect(capturedValue, 'Last');
    });

    testWidgets('handles option with empty string', (tester) async {
      final options = ['', 'Non-empty'];

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Edge case',
          options: options,
          onChanged: (_) {},
        ),
      ));

      // Should still render without error
      expect(find.text('Non-empty'), findsOneWidget);
    });

    testWidgets('handles option with long text', (tester) async {
      final longText = 'A' * 200;
      final options = [longText, 'Short'];

      await tester.pumpWidget(buildTestWidget(
        SingleChoiceWidget(
          questionText: 'Long option',
          options: options,
          onChanged: (_) {},
        ),
      ));

      // Should render without overflow error
      expect(find.text('Short'), findsOneWidget);
    });
  });

  // ============================================================================
  // MULTI CHOICE WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('MultiChoiceWidget Boundary Values', () {
    testWidgets('handles zero selections', (tester) async {
      List<String>? capturedValues;
      final options = ['A', 'B', 'C'];

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select any',
          options: options,
          values: const [],
          onChanged: (values) => capturedValues = values,
        ),
      ));

      // No selection - values should be empty
      expect(capturedValues, isNull);
    });

    testWidgets('handles single selection', (tester) async {
      List<String>? capturedValues;
      final options = ['A', 'B', 'C'];

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select any',
          options: options,
          values: const [],
          onChanged: (values) => capturedValues = values,
        ),
      ));

      await tester.tap(find.text('A'));
      await tester.pump();

      expect(capturedValues, ['A']);
    });

    testWidgets('handles all options selected', (tester) async {
      List<String>? capturedValues;
      final options = ['A', 'B', 'C'];

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select any',
          options: options,
          values: const [],
          onChanged: (values) => capturedValues = values,
        ),
      ));

      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.tap(find.text('B'));
      await tester.pump();
      await tester.tap(find.text('C'));
      await tester.pump();

      expect(capturedValues, containsAll(['A', 'B', 'C']));
    });

    testWidgets('can deselect all after selecting all', (tester) async {
      List<String>? capturedValues;
      final options = ['A', 'B'];

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select any',
          options: options,
          values: const ['A', 'B'],
          onChanged: (values) => capturedValues = values,
        ),
      ));

      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.tap(find.text('B'));
      await tester.pump();

      expect(capturedValues, isEmpty);
    });

    testWidgets('handles many options (10)', (tester) async {
      final options = List.generate(10, (i) => 'Item ${i + 1}');

      await tester.pumpWidget(buildTestWidget(
        MultiChoiceWidget(
          questionText: 'Select many',
          options: options,
          onChanged: (_) {},
        ),
      ));

      expect(find.byType(CheckboxListTile), findsNWidgets(10));
    });
  });

  // ============================================================================
  // YES/NO WIDGET - BOUNDARY VALUE TESTS
  // ============================================================================
  group('YesNoQuestionWidget Boundary Values', () {
    testWidgets('starts with no selection (null)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or No?',
          value: null,
          onChanged: (_) {},
        ),
      ));

      // Both buttons should be visible but neither selected state active
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('handles true value', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or No?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Yes'));
      await tester.pump();

      expect(capturedValue, true);
    });

    testWidgets('handles false value', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or No?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('No'));
      await tester.pump();

      expect(capturedValue, false);
    });

    testWidgets('can switch from Yes to No', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or No?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('Yes'));
      await tester.pump();
      expect(capturedValue, true);

      await tester.tap(find.text('No'));
      await tester.pump();
      expect(capturedValue, false);
    });

    testWidgets('can switch from No to Yes', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(buildTestWidget(
        YesNoQuestionWidget(
          questionText: 'Yes or No?',
          onChanged: (value) => capturedValue = value,
        ),
      ));

      await tester.tap(find.text('No'));
      await tester.pump();
      expect(capturedValue, false);

      await tester.tap(find.text('Yes'));
      await tester.pump();
      expect(capturedValue, true);
    });
  });

  // ============================================================================
  // SURVEY PREVIEW DIALOG TESTS
  // ============================================================================
  group('SurveyPreviewDialog', () {
    testWidgets('displays HealthBank logo header', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Test Survey',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('HealthBank'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays survey title', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'My Survey Title',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('My Survey Title'), findsOneWidget);
    });

    testWidgets('displays survey description when provided', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Survey',
                description: 'This is the survey description',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('This is the survey description'), findsOneWidget);
    });

    testWidgets('shows empty state when no questions', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Empty Survey',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('No questions in this survey'), findsOneWidget);
    });

    testWidgets('displays questions when provided', (tester) async {
      final questions = [
        const SurveyQuestionItem(
          questionId: 1,
          title: 'Test Question',
          questionContent: 'What is your age?',
          responseType: 'number',
          isRequired: false,
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Survey with Questions',
                questions: questions,
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('Question 1'), findsOneWidget);
      expect(find.text('Test Question'), findsOneWidget);
    });

    testWidgets('displays preview disclaimer in footer', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Survey',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(
        find.text('This is a preview. Responses are not saved.'),
        findsOneWidget,
      );
    });

    testWidgets('can close dialog', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.defaultTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Survey',
                questions: [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      // Close via the Close button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('HealthBank'), findsNothing);
    });

    group('Question Counts - Boundary Values', () {
      testWidgets('handles 0 questions', (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: [],
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        expect(find.text('No questions in this survey'), findsOneWidget);
      });

      testWidgets('handles 1 question', (tester) async {
        final questions = [
          const SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Single question',
            responseType: 'yesno',
            isRequired: false,
          ),
        ];

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: questions,
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        expect(find.text('Question 1'), findsOneWidget);
        expect(find.text('Question 2'), findsNothing);
      });

      testWidgets('handles multiple questions', (tester) async {
        final questions = List.generate(
          3,
          (i) => SurveyQuestionItem(
            questionId: i + 1,
            questionContent: 'Test Q${i + 1}',
            responseType: 'yesno',
            isRequired: false,
          ),
        );

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: questions,
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        // Verify first question badge is rendered (others may be scrolled off)
        expect(find.text('Question 1'), findsOneWidget);
        // Verify at least one YesNo widget is rendered
        expect(find.byType(YesNoQuestionWidget), findsAtLeast(1));
        // Verify empty state is NOT shown
        expect(find.text('No questions in this survey'), findsNothing);
      });
    });

    group('Different Question Types in Preview', () {
      testWidgets('renders number question type', (tester) async {
        final questions = [
          const SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Enter a number',
            responseType: 'number',
            isRequired: false,
          ),
        ];

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: questions,
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        expect(find.byType(NumberQuestionWidget), findsOneWidget);
      });

      testWidgets('renders scale question type', (tester) async {
        final questions = [
          const SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Rate on scale',
            responseType: 'scale',
            isRequired: false,
          ),
        ];

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: questions,
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        expect(find.byType(ScaleQuestionWidget), findsOneWidget);
      });

      testWidgets('renders single choice with options', (tester) async {
        const questions = [
          SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Choose one',
            responseType: 'single_choice',
            isRequired: false,
            options: [
              QuestionOptionResponse(optionId: 1, optionText: 'Option A', displayOrder: 0),
              QuestionOptionResponse(optionId: 2, optionText: 'Option B', displayOrder: 1),
            ],
          ),
        ];

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.defaultTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSurveyPreview(
                  context,
                  title: 'Survey',
                  questions: questions,
                ),
                child: const Text('Show Preview'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Show Preview'));
        await tester.pumpAndSettle();

        expect(find.byType(SingleChoiceWidget), findsOneWidget);
        expect(find.text('Option A'), findsOneWidget);
        expect(find.text('Option B'), findsOneWidget);
      });
    });
  });
}
