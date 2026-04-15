# survey_preview_dialog.dart

## Overview
`SurveyPreviewDialog` renders an **in-app preview** of a survey as a participant would see it. It is displayed as a modal `Dialog`, includes HealthBank branding, shows questions using the survey question widgets, and stores responses **locally only** (no persistence).

File: `frontend/lib/src/features/surveys/widgets/survey_preview_dialog.dart`

## Architecture / Design

### Responsibilities
- Present a branded preview UI:
  - Top bar (“Survey Preview”) with close button
  - `HealthBankLogoHeader` in the dialog header area
  - Survey title + optional description
  - Divider + scrollable question list
  - Footer notice (“Responses are not saved.”)
- Render each question using the appropriate widget for its `responseType`.
- Track ephemeral preview answers in a local map.

### Key dependencies
- `AppTheme` for styling.
- `HealthBankLogoHeader` for branding.
- Question UI widgets (via `question_types.dart`):
  - `NumberQuestionWidget`
  - `YesNoQuestionWidget`
  - `OpenEndedQuestionWidget`
  - `SingleChoiceWidget`
  - `MultiChoiceWidget`
  - `ScaleQuestionWidget`
- `SurveyQuestionItem` model from `survey_providers.dart` (builder state uses same shape).

## Public API

### SurveyPreviewDialog
A stateful dialog widget.

**Constructor params**
- `title : String` (required) — displayed as the survey title.
- `description : String?` — optional description text shown under the title.
- `questions : List<SurveyQuestionItem>` (required) — list of questions rendered in order.

### showSurveyPreview(...)
Convenience function to show the dialog.

**Signature**
- `Future<void> showSurveyPreview(BuildContext context, { required String title, String? description, required List<SurveyQuestionItem> questions })`

**Behavior**
- Calls `showDialog(...)` and renders `SurveyPreviewDialog`.

## Internal State

### _previewResponses
- Type: `Map<int, dynamic>`
- Key: `questionId`
- Value: varies by question type:
  - `number` → `int?`
  - `yesno` → `bool?`
  - `openended` → `String?`
  - `single_choice` → `String?`
  - `multi_choice` → `List<String>`
  - `scale` → `double?`

This map is updated via `_updateResponse(questionId, value)` and is only used for preview interactivity.

## Rendering / Layout Details

### Dialog sizing
- Uses `MediaQuery`:
  - `maxDialogWidth` = `(screenWidth - 32)` when narrow; otherwise `600.0`.
  - `maxHeight` = `0.9 * screenHeight`.
- Uses `Flexible` for the question content area to prevent overflow.

### Header areas
1. `_buildCloseHeader()`
   - Primary-colored strip with preview icon, “Survey Preview” label, and close icon button.
2. `HealthBankLogoHeader`
   - Medium size, divider disabled.
3. `_buildSurveyHeader()`
   - White background.
   - Displays title (heading style) and optional description (muted body text).

### Content
- If `questions.isEmpty`, displays an empty state with:
  - Icon
  - “No questions in this survey”
  - “Add questions to see how your survey will look”
- Else renders a `ListView.separated`:
  - Padding: 16
  - Separator: `Divider(height: 32)`
  - Each item renders:
    - “Question N” badge
    - question widget chosen by `responseType`

### Footer
`_buildFooter()` shows:
- Info icon + “This is a preview. Responses are not saved.”
- Close button (pops dialog)

## Question Rendering Logic

### Question text
For all types:
- `questionText = question.title ?? question.questionContent`
- Choice options:
  - `options = question.options?.map((o) => o.optionText).toList() ?? []`

### Supported response types
- `number` → `NumberQuestionWidget`
- `yesno` → `YesNoQuestionWidget`
- `openended` → `OpenEndedQuestionWidget`
- `single_choice` → `SingleChoiceWidget`
- `multi_choice` → `MultiChoiceWidget`
- `scale` → `ScaleQuestionWidget`
  - Currently hard-coded: `min: 1`, `max: 10`, `divisions: 9`, `minLabel: 'Low'`, `maxLabel: 'High'`

### Unsupported types
Falls back to `_buildUnsupportedType(question)` which renders a muted warning card including:
- Question text
- “Unsupported question type: <responseType>”

## Error handling
- No async operations in this dialog; no API calls.
- “Error handling” is primarily:
  - safe defaults for missing options (empty list)
  - fallback UI for unknown response types

## Usage example

```dart
await showSurveyPreview(
  context,
  title: state.title.isEmpty ? context.l10n.surveyBuilderUntitledSurvey : state.title,
  description: state.description,
  questions: state.questions,
);