<!-- Created with the Assistance of Claude Code -->
# Templates Frontend

Survey templates allow researchers to create reusable question sets that can be applied to new surveys.

## Architecture

```
frontend/lib/features/templates/
├── pages/
│   ├── template_list_page.dart      # Main browser page (Task 021)
│   └── template_builder_page.dart   # Create/edit template (Task 023)
├── widgets/
│   ├── template_card.dart           # Template card widget (Task 022)
│   └── template_preview_dialog.dart # Preview dialog (Task 024)
└── state/
    └── template_providers.dart      # Riverpod state management
```

---

## Quick Start

```dart
import 'package:frontend/features/templates/pages/template_list_page.dart';
import 'package:frontend/features/templates/state/template_providers.dart';

// Browse templates
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TemplateListPage()),
);

// Selection mode (for creating surveys from templates)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TemplateListPage(
      selectionMode: true,
      onTemplateSelected: (template) {
        // Handle selected template
        print('Selected: ${template.title}');
      },
    ),
  ),
);
```

---

## State Management (Riverpod)

### Providers

| Provider | Type | Description |
|----------|------|-------------|
| `templateApiProvider` | `Provider<TemplateApi>` | Template API service |
| `templatesProvider` | `FutureProvider<List<Template>>` | Fetches templates with filters |
| `templateByIdProvider` | `FutureProvider.family<Template, int>` | Single template by ID |
| `templateFiltersProvider` | `StateNotifierProvider<TemplateFilters>` | Filter state |
| `selectedTemplateIdsProvider` | `StateNotifierProvider<Set<int>>` | Selected template IDs |
| `templateSelectionModeProvider` | `StateProvider<bool>` | Selection mode toggle |
| `templateBuilderProvider` | `StateNotifierProvider<TemplateBuilderState>` | Builder page state |

### Usage Examples

```dart
// Access templates
final templatesAsync = ref.watch(templatesProvider);
templatesAsync.when(
  data: (templates) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);

// Set filters
ref.read(templateFiltersProvider.notifier).setIsPublic(true);
ref.read(templateFiltersProvider.notifier).setSearchQuery('health');

// Clear filters
ref.read(templateFiltersProvider.notifier).clearAll();

// Selection mode
ref.read(selectedTemplateIdsProvider.notifier).toggle(templateId);
final selectedIds = ref.watch(selectedTemplateIdsProvider);
```

---

## TemplateListPage

Main browser page for viewing and managing templates.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `selectionMode` | `bool` | `false` | Enable single-select mode |
| `onTemplateSelected` | `Function(Template)?` | `null` | Callback when selecting a template |

### Features

- **Search**: Full-text search on title and description
- **Filter by Visibility**: Public, Private, or All
- **Pull to Refresh**: Swipe down to reload templates
- **Selection Mode**: Select a template for creating surveys
- **Actions Menu**: Edit, Duplicate, Create Survey, Delete

### UI Components

1. **Search Bar**: Text field with clear button
2. **Visibility Filter**: Dropdown selector
3. **Active Filters Chips**: Shows applied filters with remove buttons
4. **Template Cards**: Display template info with question count
5. **Empty State**: Message when no templates found
6. **Error State**: Retry button on API failure

---

## TemplateCard

Reusable card widget for displaying a template.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `template` | `Template` | required | The template to display |
| `isSelected` | `bool` | `false` | Whether card is selected |
| `selectionMode` | `bool` | `false` | Enable selection mode (hides action menu) |
| `onTap` | `VoidCallback?` | `null` | Tap handler |
| `onEdit` | `VoidCallback?` | `null` | Edit action handler |
| `onDuplicate` | `VoidCallback?` | `null` | Duplicate action handler |
| `onCreateSurvey` | `VoidCallback?` | `null` | Create survey action handler |
| `onPreview` | `VoidCallback?` | `null` | Preview action handler |
| `onDelete` | `VoidCallback?` | `null` | Delete action handler |

### Usage

```dart
TemplateCard(
  template: template,
  isSelected: selectedIds.contains(template.templateId),
  selectionMode: isSelectionMode,
  onTap: () => navigateToDetails(template),
  onEdit: () => navigateToBuilder(template),
  onDuplicate: () => duplicateTemplate(template),
  onCreateSurvey: () => createSurveyFromTemplate(template),
  onPreview: () => showPreviewDialog(template),
  onDelete: () => confirmDelete(template),
)
```

### Card Layout

```
┌─────────────────────────────────────────────────┐
│ [Icon]  Title                                  ⋮│
│         🔓 Public  📝 5 questions               │
│         Description text (max 2 lines)...       │
└─────────────────────────────────────────────────┘
```

- **Icon**: Template document icon
- **Title**: Template name in bold
- **Visibility**: Public/Private indicator with icon
- **Question Count**: Number of questions in template
- **Description**: Optional, shown below title (max 2 lines)
- **Menu**: Actions (preview, edit, duplicate, create survey, delete)

### Actions Menu

| Action | Description |
|--------|-------------|
| Preview | Opens template preview dialog |
| Edit | Navigate to template builder |
| Duplicate | Creates a copy of the template |
| Create Survey | Creates a new survey from this template |
| Delete | Confirms and deletes the template |

---

## TemplateBuilderPage

Page for creating or editing survey templates.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `templateId` | `int?` | `null` | Template ID to edit (null for new template) |

### Usage

```dart
import 'package:frontend/features/templates/pages/template_builder_page.dart';

// Create new template
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TemplateBuilderPage()),
);

// Edit existing template
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TemplateBuilderPage(templateId: 123),
  ),
);
```

### Features

- **Title & Description**: Set template metadata
- **Visibility Toggle**: Make template public or private
- **Add Questions**: Select questions from the question bank
- **Reorder Questions**: Drag and drop to reorder
- **Remove Questions**: Remove questions from the template
- **Create/Update**: Save template via API

### Builder State

The builder uses `TemplateBuilderState` managed by `templateBuilderProvider`:

```dart
// Access builder state
final state = ref.watch(templateBuilderProvider);

// Modify builder state
ref.read(templateBuilderProvider.notifier).setTitle('New Title');
ref.read(templateBuilderProvider.notifier).addQuestions(selectedQuestions);
ref.read(templateBuilderProvider.notifier).removeQuestion(questionId);
ref.read(templateBuilderProvider.notifier).reorderQuestions(oldIndex, newIndex);

// Save template
final template = await ref.read(templateBuilderProvider.notifier).save();

// Reset for new template
ref.read(templateBuilderProvider.notifier).reset();

// Load existing template for editing
await ref.read(templateBuilderProvider.notifier).loadTemplate(templateId);
```

### UI Layout

```
┌─────────────────────────────────────────────────┐
│ [←] Edit Template                      [Save]   │
├─────────────────────────────────────────────────┤
│ Template Title *                                │
│ ┌─────────────────────────────────────────────┐ │
│ │ Enter a descriptive title                   │ │
│ └─────────────────────────────────────────────┘ │
│ Description (optional)                          │
│ ┌─────────────────────────────────────────────┐ │
│ │ Describe the purpose...                     │ │
│ └─────────────────────────────────────────────┘ │
│ [Toggle] Make Public                            │
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

## TemplatePreviewDialog

Dialog widget for previewing a template as it would appear in a survey.

### Usage

```dart
import 'package:frontend/features/templates/widgets/template_preview_dialog.dart';

// Show preview dialog
await showTemplatePreview(context, template);

// Or use the dialog directly
showDialog(
  context: context,
  builder: (context) => TemplatePreviewDialog(template: template),
);
```

### Features

- **Interactive Preview**: All question types are rendered with working inputs
- **Question Types Supported**:
  - Number input with validation
  - Yes/No radio buttons
  - Open-ended text area
  - Single choice (radio buttons)
  - Multiple choice (checkboxes)
  - Scale/rating slider
  - Date picker
  - Time picker
- **Preview Mode**: Responses are tracked locally but NOT saved
- **Empty State**: Shows message when template has no questions
- **Responsive**: Dialog scales to screen size with max width/height constraints

### Dialog Layout

```
┌─────────────────────────────────────────────────┐
│ [Preview Icon]  Preview                    [X]  │
│                 Template Title                  │
├─────────────────────────────────────────────────┤
│ Question 1                                      │
│ ┌─────────────────────────────────────────────┐ │
│ │ [Question widget based on type]             │ │
│ └─────────────────────────────────────────────┘ │
│ ─────────────────────────────────────────────── │
│ Question 2                                      │
│ ┌─────────────────────────────────────────────┐ │
│ │ [Question widget based on type]             │ │
│ └─────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────┤
│ ℹ This is a preview. Responses not saved [Close]│
└─────────────────────────────────────────────────┘
```

### Props

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `template` | `Template` | Yes | The template to preview (must include questions) |

---

## API Integration

The page uses the `TemplateApi` service from the API client:

```dart
// List templates with filters
final templates = await templateApi.listTemplates(
  isPublic: true,
);

// Get single template with questions
final template = await templateApi.getTemplate(123);

// Create template
final created = await templateApi.createTemplate(TemplateCreate(...));

// Update template
final updated = await templateApi.updateTemplate(123, TemplateUpdate(...));

// Duplicate template
final duplicated = await templateApi.duplicateTemplate(123);

// Delete template
await templateApi.deleteTemplate(123);
```

---

## Styling

Uses `AppTheme` from `lib/core/theme/theme.dart`:

- **Primary**: `#172B46` - Template icon background
- **Secondary**: `#145B2C` - Success states
- **Error**: `#A6192E` - Delete actions
- **Background**: `#FAFAFA` - Page background
- **Cards**: White with subtle shadow

---

## Implementation Status

- [x] TemplateListPage (Task 021)
- [x] Riverpod state providers
- [x] Search and filter functionality
- [x] Selection mode for surveys
- [x] TemplateCard widget (Task 022)
- [x] Template Builder Page (Task 023)
- [x] Template Preview Dialog (Task 024)
- [ ] Navigation integration with go_router

---

## Testing

Tests should be placed in:
```
frontend/test/features/templates/
├── pages/
│   └── template_list_page_test.dart
├── widgets/
│   └── template_card_test.dart
└── state/
    └── template_providers_test.dart
```

### Mock Example

```dart
class MockTemplateApi extends Mock implements TemplateApi {}

void main() {
  late MockTemplateApi mockApi;

  setUp(() {
    mockApi = MockTemplateApi();
  });

  test('loads templates', () async {
    when(() => mockApi.listTemplates()).thenAnswer(
      (_) async => [
        Template(
          templateId: 1,
          title: 'Health Survey Template',
          isPublic: true,
          questionCount: 5,
        ),
      ],
    );

    final templates = await mockApi.listTemplates();
    expect(templates.length, 1);
  });
}
```
