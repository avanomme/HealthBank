<!-- Created with the Assistance of Claude Code -->
# Survey Builder Frontend

The Survey Builder allows researchers to create and edit surveys by adding questions from the question bank.

## Architecture

```
frontend/lib/features/surveys/
├── pages/
│   └── survey_builder_page.dart    # Main builder page (Task 025)
├── state/
│   └── survey_providers.dart       # Riverpod state management
└── widgets/
    └── question_types/             # Question type widgets (Task 017)
```

### Shared Widgets

```
frontend/lib/widgets/shared/
├── app_header.dart                 # Shared header component
├── app_footer.dart                 # Shared footer component
└── shared.dart                     # Barrel export file
```

### Shell Layouts

```
frontend/lib/app/shell/
└── researcher_shell.dart           # Researcher layout with header/footer
```

---

## Quick Start

```dart
import 'package:frontend/features/surveys/pages/survey_builder_page.dart';

// Create new survey
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const SurveyBuilderPage()),
);

// Edit existing survey
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SurveyBuilderPage(surveyId: 123),
  ),
);
```

---

## State Management (Riverpod)

### Providers

| Provider | Type | Description |
|----------|------|-------------|
| `surveyApiProvider` | `Provider<SurveyApi>` | Survey API service |
| `surveysProvider` | `FutureProvider<List<Survey>>` | Fetches surveys with filters |
| `surveyByIdProvider` | `FutureProvider.family<Survey, int>` | Single survey by ID |
| `surveyFiltersProvider` | `StateNotifierProvider<SurveyFilters>` | Filter state |
| `surveyBuilderProvider` | `StateNotifierProvider<SurveyBuilderState>` | Builder page state |

### Usage Examples

```dart
// Access surveys
final surveysAsync = ref.watch(surveysProvider);
surveysAsync.when(
  data: (surveys) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);

// Set filters
ref.read(surveyFiltersProvider.notifier).setPublicationStatus('draft');
ref.read(surveyFiltersProvider.notifier).setSearchQuery('health');

// Builder state
ref.read(surveyBuilderProvider.notifier).setTitle('My Survey');
ref.read(surveyBuilderProvider.notifier).addQuestions(selectedQuestions);
ref.read(surveyBuilderProvider.notifier).removeQuestion(questionId);
ref.read(surveyBuilderProvider.notifier).reorderQuestions(oldIndex, newIndex);

// Save operations
final survey = await ref.read(surveyBuilderProvider.notifier).saveDraft();
final published = await ref.read(surveyBuilderProvider.notifier).saveAndPublish();
```

---

## SurveyBuilderPage

Main page for creating or editing surveys.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `surveyId` | `int?` | `null` | Survey ID to edit (null for new survey) |

### Features

- **Title & Description**: Set survey metadata
- **Date Range**: Optional start and end dates
- **Use Template**: Create a survey from an existing template (Task 026)
- **Add Questions**: Select questions from the question bank
- **Reorder Questions**: Drag and drop to reorder
- **Remove Questions**: Remove questions from the survey
- **Save Draft**: Save without publishing
- **Publish**: Save and make available for assignment

### Builder State

The builder uses `SurveyBuilderState` managed by `surveyBuilderProvider`:

```dart
// Access builder state
final state = ref.watch(surveyBuilderProvider);

// Modify builder state
ref.read(surveyBuilderProvider.notifier).setTitle('New Title');
ref.read(surveyBuilderProvider.notifier).setDescription('Description');
ref.read(surveyBuilderProvider.notifier).setStartDate(DateTime.now());
ref.read(surveyBuilderProvider.notifier).setEndDate(DateTime.now().add(Duration(days: 30)));
ref.read(surveyBuilderProvider.notifier).addQuestions(selectedQuestions);
ref.read(surveyBuilderProvider.notifier).removeQuestion(questionId);
ref.read(surveyBuilderProvider.notifier).reorderQuestions(oldIndex, newIndex);

// Save operations
final survey = await ref.read(surveyBuilderProvider.notifier).saveDraft();
final published = await ref.read(surveyBuilderProvider.notifier).saveAndPublish();

// Reset for new survey
ref.read(surveyBuilderProvider.notifier).reset();

// Load existing survey for editing
await ref.read(surveyBuilderProvider.notifier).loadSurvey(surveyId);

// Load from template (creates new survey with template's questions)
await ref.read(surveyBuilderProvider.notifier).loadFromTemplate(templateId);
```

### UI Layout

```
┌─────────────────────────────────────────────────┐
│ [←] New Survey            [Save Draft] [Publish]│
├─────────────────────────────────────────────────┤
│ Survey Title *                                  │
│ ┌─────────────────────────────────────────────┐ │
│ │ Enter a descriptive title                   │ │
│ └─────────────────────────────────────────────┘ │
│ Description (optional)                          │
│ ┌─────────────────────────────────────────────┐ │
│ │ Describe the purpose...                     │ │
│ └─────────────────────────────────────────────┘ │
│ Start Date              End Date                │
│ ┌──────────────────┐   ┌──────────────────┐    │
│ │ Select date   📅 │   │ Select date   📅 │    │
│ └──────────────────┘   └──────────────────┘    │
├─────────────────────────────────────────────────┤
│ Questions (3)                    Drag to reorder│
│ ┌─────────────────────────────────────────────┐ │
│ │ ≡ [1] Question title          [Type] [🗑]  │ │
│ │    Question content...                      │ │
│ ├─────────────────────────────────────────────┤ │
│ │ ≡ [2] Another question        [Type] [🗑]  │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│                [+ Add Questions]                │
└─────────────────────────────────────────────────┘
```

---

## Shared Components

### AppHeader

Shared header component with navigation and user actions.

```dart
import 'package:frontend/widgets/shared/app_header.dart';

AppHeader(
  navItems: [
    NavItem(label: 'Home', route: '/home'),
    NavItem(label: 'Dashboard', route: '/dashboard'),
    NavItem(label: 'Reports', route: '/reports'),
    NavItem(label: 'Surveys', route: '/surveys'),
  ],
  currentRoute: '/surveys',
  hasNotifications: true,
  onNavItemTap: (route) => Navigator.pushNamed(context, route),
  onNotificationsTap: () => showNotifications(),
  onProfileTap: () => navigateToProfile(),
)
```

### AppFooter

Shared footer component with help links and legal information.

```dart
import 'package:frontend/widgets/shared/app_footer.dart';

// Using defaults
const AppFooter()

// Custom sections
AppFooter(
  sections: [
    FooterSection(
      title: 'Help & Services',
      links: [
        FooterLink(label: 'How to Use HealthBank', route: '/help'),
        FooterLink(label: 'Contact Us', route: '/contact'),
      ],
    ),
  ],
  currentLocale: 'EN',
  onLanguageChange: (locale) => changeLanguage(locale),
)
```

### ResearcherShell

Layout wrapper for researcher pages with header and footer.

```dart
import 'package:frontend/app/shell/researcher_shell.dart';

ResearcherShell(
  currentRoute: '/surveys',
  hasNotifications: true,
  showFooter: true,
  child: SurveyBuilderPage(),
)
```

---

## API Integration

The page uses the `SurveyApi` service from the API client:

```dart
// Create survey
final survey = await surveyApi.createSurvey(SurveyCreate(...));

// Update survey
final updated = await surveyApi.updateSurvey(id, SurveyUpdate(...));

// Get survey with questions
final survey = await surveyApi.getSurvey(id);

// Publish survey
final published = await surveyApi.publishSurvey(id);

// Create from template
final survey = await surveyApi.createFromTemplate(templateId, overrides);
```

---

## Styling

Uses `AppTheme` from `lib/core/theme/theme.dart`:

- **Primary**: `#172B46` - AppBar, buttons, question badges
- **Secondary**: `#145B2C` - Publish button, success states
- **Error**: `#A6192E` - Delete actions, required indicator
- **Background**: `#FAFAFA` - Page background
- **White**: `#FFFFFF` - Cards, form section

---

## Implementation Status

- [x] Survey state providers
- [x] SurveyBuilderPage (Task 025)
- [x] Shared AppHeader widget
- [x] Shared AppFooter widget
- [x] ResearcherShell layout
- [x] Integrate Templates into Survey Builder (Task 026)
- [x] Navigation integration with go_router
- [x] Survey status page route (`/surveys/:id/status`) with assignment analytics
- [x] Survey assignment modal demographic filters (age min/max + gender)
- [x] Survey list responsive actions (inline buttons on normal layouts, overflow fallback on compact/mobile)

---

## Researcher Survey Assignment and Status

- Survey cards open the survey status page (`/surveys/:id/status`) on tap.
- Survey status page shows only aggregate assignment metrics (`assigned total`, `pending`, `completed`, `expired`).
- Assignment pie chart segments are mutually exclusive statuses only (`pending`, `completed`, `expired`).
- Assignment modal supports:
- Assignment mode options: `Assign All Participants` and `Assign by Demographic`.
- Demographic age range uses validated integer min/max (`0` to `999`).
- Demographic gender values are `All`, `Male`, `Female`, `Non-Binary`, and `Unspecified`.
- Bulk assignment results are consumed from API response and shown as aggregate feedback (`total_targeted`, `assigned`, `skipped`).

### TODO (Backend/API Gaps)

- TODO: Add a preflight endpoint for "eligible participants not already assigned" count before submit. Current frontend can only show:
- TODO: Current frontend can show only existing assignment aggregate counts from `GET /surveys/{id}/assignments`.
- TODO: Current frontend can show only post-submit assignment result counts from `POST /surveys/{id}/assign`.
- TODO: If product decides `Unspecified` should map to database `NULL` instead of `"Prefer Not to Say"`, backend filter semantics must support null-aware demographic filtering. Current API uses equality matching.

---

## Template Integration (Task 026)

The Survey Builder supports creating surveys from templates.

### Usage

From the empty state, users can:
1. **Use Template** - Select a template to pre-populate the survey with questions
2. **Add Questions** - Manually select questions from the question bank

### Implementation

```dart
// In survey_builder_page.dart
Future<void> _useTemplate() async {
  final result = await Navigator.push<Template>(
    context,
    MaterialPageRoute(
      builder: (context) => TemplateListPage(
        selectionMode: true,
        onTemplateSelected: (template) {
          Navigator.pop(context, template);
        },
      ),
    ),
  );

  if (result != null) {
    await ref
        .read(surveyBuilderProvider.notifier)
        .loadFromTemplate(result.templateId);
  }
}
```

### State Management

The `loadFromTemplate` method in `SurveyBuilderNotifier`:
- Fetches the template with its questions
- Populates the builder state with template title, description, and questions
- Keeps `surveyId` null (creates a NEW survey, not linked to template)
- Allows user to modify before saving

---

## Testing

Tests should be placed in:
```
frontend/test/features/surveys/
├── pages/
│   └── survey_builder_page_test.dart
└── state/
    └── survey_providers_test.dart
```

### Mock Example

```dart
class MockSurveyApi extends Mock implements SurveyApi {}

void main() {
  late MockSurveyApi mockApi;

  setUp(() {
    mockApi = MockSurveyApi();
  });

  test('creates survey', () async {
    when(() => mockApi.createSurvey(any())).thenAnswer(
      (_) async => Survey(
        surveyId: 1,
        title: 'Test Survey',
        status: 'not-started',
        publicationStatus: 'draft',
      ),
    );

    final survey = await mockApi.createSurvey(SurveyCreate(title: 'Test Survey'));
    expect(survey.surveyId, 1);
  });
}
```
