# SurveyBuilderPage

## Overview
`SurveyBuilderPage` is a researcher-facing survey authoring screen for creating or editing surveys. It supports configuring survey metadata (title, description, date range), building the question list (add from inline question bank, reorder via drag-and-drop, remove), previewing the survey, saving drafts, and publishing.

File: `frontend/lib/src/features/surveys/pages/survey_builder_page.dart`

## Architecture / Design
- **Widget type:** `ConsumerStatefulWidget` to manage local form/controllers and interact with Riverpod state.
- **Layout wrapper:** `ResearcherScaffold(currentRoute: '/surveys')`.
- **Two responsive layouts:**
  - **Wide (>= 900px):** side-by-side survey form (60%) and question bank panel (40%).
  - **Narrow:** toggles between form and question bank using a button / FAB.
- **State sources:**
  - `surveyBuilderProvider` (survey builder state + actions)
  - `questionsProvider` (question bank list for inline add)
- **Core UX features:**
  - Auto-save status indicator (idle/pending/saving/saved/error)
  - Preview dialog (`showSurveyPreview(...)`)
  - Optional “Start from template” flow (`TemplateListPage` in selection mode)
  - Draft save and publish flows with validation and confirmation

## Configuration
### Constructor
    const SurveyBuilderPage({ Key? key, int? surveyId })

Parameters:
- **surveyId** — If provided, the builder loads an existing survey for editing; if `null`, the builder starts fresh for a new survey.

## Provider / State Dependencies
From `../state/survey_providers.dart` (imported with `show`):
- `surveyBuilderProvider`
- `SurveyBuilderState`
- `SurveyQuestionItem`
- `AutoSaveStatus`

From question bank:
- `questionsProvider` (list of `Question`)
- `responseTypeLabels` (display labels for response type tags)

Other key dependencies:
- `TemplateListPage` (template selection)
- `showSurveyPreview` (preview modal)
- `AppTheme` and `context.l10n` for styling/localization

## UI Structure
High-level structure:

ResearcherScaffold  
└── Column  
  ├── Action bar (custom header row)  
  └── Expanded content  
    ├── Loading state (spinner) OR  
    └── Wide layout (Row) / Narrow layout (toggle)

### Action bar (`_buildActionBar`)
Contains:
- Back button (pops route)
- Page title (“New survey” / “Edit survey” based on `state.isEditMode`)
- Auto-save indicator (`_buildAutoSaveIndicator(state.autoSaveStatus)`)
- Toggle question bank button (narrow screens only)
- Preview button (disabled when no questions)
- Publish button (calls `_saveAndPublish`)

## Key Behaviors

## Initialization & edit mode
- `initState` schedules `_initializeBuilder()` post-frame.
- `_initializeBuilder()`:
  - Calls `surveyBuilderProvider.notifier.reset()`
  - Clears text controllers
  - If `surveyId != null`, calls `loadSurvey(surveyId)`
- `didUpdateWidget` re-initializes when `surveyId` changes.

## Form synchronization
`_syncControllersFromState(state)` keeps `_titleController` and `_descriptionController` aligned to provider state (important for edit mode and external state updates).

## Adding questions (inline question bank)
- Question bank panel lists `questionsProvider`.
- Already-added questions are detected via `addedQuestionIds` and disabled in the bank list.
- Tapping a question calls `_addQuestion(question)`:
  - `surveyBuilderProvider.notifier.addQuestions([question])`
  - Shows a SnackBar confirming the add.

## Reordering & removing questions
- Reordering is done with `ReorderableListView.builder`:
  - Calls `surveyBuilderProvider.notifier.reorderQuestions(oldIndex, newIndex)`
- Removing uses the trailing icon button:
  - Calls `surveyBuilderProvider.notifier.removeQuestion(questionId)`

## Templates
- `_useTemplate()` navigates to `TemplateListPage(selectionMode: true)`.
- On selection, calls:
  - `surveyBuilderProvider.notifier.loadFromTemplate(templateId)`
- Shows success SnackBar.

## Date range selection
- Start/end date are selected via `showDatePicker`.
- Start date: `setStartDate(date)`
- End date: `setEndDate(date)`
- UI displays `YYYY-MM-DD` or a localized “Select date” placeholder.

## Saving and publishing
### `_saveDraft()`
- Validates form (requires title).
- Calls `surveyBuilderProvider.notifier.saveDraft()`.
- On success:
  - Shows success SnackBar (“saved as draft” or “updated”)
  - `Navigator.pop(context, survey)` returning the saved survey.

### `_saveAndPublish()`
- Validates form.
- Rejects publish if no questions (`state.hasQuestions == false`) and shows error SnackBar.
- Requires confirmation dialog.
- Calls `surveyBuilderProvider.notifier.saveAndPublish()`.
- On success:
  - Shows success SnackBar
  - Pops with the published survey.

## API Reference

### Class: `SurveyBuilderPage extends ConsumerStatefulWidget`
- `surveyId : int?`

### State: `_SurveyBuilderPageState`
Notable members:
- `_formKey : GlobalKey<FormState>`
- Controllers: `_titleController`, `_descriptionController`
- `_showQuestionBank : bool`

Notable methods:
- `_initializeBuilder()`
- `_toggleQuestionBank()`
- `_addQuestion(Question question)`
- `_useTemplate() -> Future<void>`
- `_selectStartDate() -> Future<void>`
- `_selectEndDate() -> Future<void>`
- `_saveDraft() -> Future<void>`
- `_saveAndPublish() -> Future<void>`

UI builders:
- `_buildActionBar(SurveyBuilderState state, bool isWideScreen)`
- `_buildWideLayout(SurveyBuilderState state)`
- `_buildNarrowLayout(SurveyBuilderState state)`
- `_buildSurveyForm(SurveyBuilderState state)`
- `_buildQuestionBankPanel(SurveyBuilderState state)`
- `_buildQuestionsSection(SurveyBuilderState state)`
- `_buildAutoSaveIndicator(AutoSaveStatus status)`

## Error Handling
- Form validation:
  - Title is required.
- Publishing guard:
  - Prevents publishing without questions; shows SnackBar with error styling.
- Builder state error:
  - Displays `state.errorMessage` in a dismissible banner; `clearError()` is invoked on close.
- Question bank load error:
  - Shows retry UI and `ref.invalidate(questionsProvider)`.

## Usage Examples

### Create a new survey
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SurveyBuilderPage()),
    );

### Edit an existing survey
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SurveyBuilderPage(surveyId: 123)),
    );

## Related Files
- `frontend/lib/src/features/surveys/state/survey_providers.dart` — Builder state, autosave, and persistence actions.
- `frontend/lib/features/question_bank/state/question_providers.dart` — `questionsProvider`, `responseTypeLabels`.
- `frontend/lib/src/features/surveys/widgets/survey_preview_dialog.dart` — `showSurveyPreview(...)`.
- `frontend/lib/src/features/templates/pages/template_list_page.dart` — Template selection used by “Start from template”.
- `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart` — Researcher page layout wrapper.
- `frontend/src/core/api/api.dart` — `Question` model used when adding questions.