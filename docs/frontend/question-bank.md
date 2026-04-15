<!-- Created with the Assistance of Claude Code -->
# Question Bank Frontend

The Question Bank is a reusable library of questions that researchers can use to build surveys.

## Architecture

```
frontend/lib/features/question_bank/
├── pages/
│   └── question_bank_page.dart      # Main browser page
├── widgets/
│   ├── question_bank_card.dart      # Question card widget (Task 019)
│   └── question_bank_form_dialog.dart # Create/edit dialog (Task 020)
└── state/
    └── question_providers.dart      # Riverpod state management
```

---

## Quick Start

```dart
import 'package:frontend/features/question_bank/pages/question_bank_page.dart';
import 'package:frontend/features/question_bank/state/question_providers.dart';

// Browse questions
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const QuestionBankPage()),
);

// Selection mode (for adding to surveys)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => QuestionBankPage(
      selectionMode: true,
      onQuestionsSelected: (questions) {
        // Handle selected questions
        print('Selected ${questions.length} questions');
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
| `apiClientProvider` | `Provider<ApiClient>` | API client singleton |
| `questionApiProvider` | `Provider<QuestionApi>` | Question API service |
| `questionsProvider` | `FutureProvider<List<Question>>` | Fetches questions with filters |
| `questionByIdProvider` | `FutureProvider.family<Question, int>` | Single question by ID |
| `questionFiltersProvider` | `StateNotifierProvider<QuestionFilters>` | Filter state |
| `selectedQuestionIdsProvider` | `StateNotifierProvider<Set<int>>` | Selected question IDs |
| `selectionModeProvider` | `StateProvider<bool>` | Selection mode toggle |

### Usage Examples

```dart
// Access questions
final questionsAsync = ref.watch(questionsProvider);
questionsAsync.when(
  data: (questions) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);

// Set filters
ref.read(questionFiltersProvider.notifier).setResponseType('single_choice');
ref.read(questionFiltersProvider.notifier).setSearchQuery('health');

// Clear filters
ref.read(questionFiltersProvider.notifier).clearAll();

// Selection mode
ref.read(selectedQuestionIdsProvider.notifier).toggle(questionId);
ref.read(selectedQuestionIdsProvider.notifier).selectAll([1, 2, 3]);
final selectedIds = ref.watch(selectedQuestionIdsProvider);
```

---

## QuestionBankPage

Main browser page for viewing and managing questions.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `selectionMode` | `bool` | `false` | Enable multi-select mode |
| `onQuestionsSelected` | `Function(List<Question>)?` | `null` | Callback when confirming selection |

### Features

- **Search**: Full-text search on question title and content
- **Filter by Type**: Number, Yes/No, Open-ended, Single Choice, Multi Choice, Scale
- **Filter by Category**: Health, Lifestyle, Demographics (TODO: load from API)
- **Pull to Refresh**: Swipe down to reload questions
- **Selection Mode**: Multi-select questions for adding to surveys
- **Actions Menu**: Edit, Duplicate, Delete (browse mode only)

### UI Components

1. **Search Bar**: Text field with clear button
2. **Filter Dropdowns**: Type and Category selectors
3. **Active Filters Chips**: Shows applied filters with remove buttons
4. **Question Cards**: Display question info with type icon and tags
5. **Empty State**: Message when no questions found
6. **Error State**: Retry button on API failure

---

## Question Card Layout

```
┌─────────────────────────────────────────────────┐
│ [☐] [Icon]  Title (if present)                 ⋮│
│              Question content text...           │
│              [Type Tag] [Category] [Required]   │
└─────────────────────────────────────────────────┘
```

- **Checkbox**: Visible in selection mode
- **Icon**: Based on response type
- **Title**: Optional, shown in bold
- **Content**: Question text (max 2 lines)
- **Tags**: Type, Category, Required indicator
- **Menu**: Actions (edit, duplicate, delete)

### Response Type Icons

| Type | Icon |
|------|------|
| `number` | `Icons.numbers` |
| `yesno` | `Icons.toggle_on` |
| `openended` | `Icons.text_fields` |
| `single_choice` | `Icons.radio_button_checked` |
| `multi_choice` | `Icons.check_box` |
| `scale` | `Icons.linear_scale` |

---

## API Integration

The page uses the `QuestionApi` service from the API client:

```dart
// List questions with filters
final questions = await questionApi.listQuestions(
  responseType: 'single_choice',
  category: 'health',
  isActive: true,
);

// Get single question
final question = await questionApi.getQuestion(123);

// Create question
final created = await questionApi.createQuestion(QuestionCreate(...));

// Update question
final updated = await questionApi.updateQuestion(123, QuestionUpdate(...));

// Delete question
await questionApi.deleteQuestion(123);
```

---

## Styling

Uses `AppTheme` from `lib/core/theme/theme.dart`:

- **Primary**: `#172B46` - Selected states, type icons
- **Secondary**: `#145B2C` - Category tags
- **Error**: `#A6192E` - Required indicator, delete actions
- **Background**: `#FAFAFA` - Page background
- **Cards**: White with subtle shadow

---

## Implementation Status

- [x] QuestionBankPage (Task 018)
- [x] Riverpod state providers
- [x] Search and filter functionality
- [x] Selection mode for surveys
- [x] QuestionBankCard widget (Task 019)
- [x] QuestionBankFormDialog (Task 020)
- [ ] Navigation integration with go_router

---

## QuestionBankCard

Reusable card widget for displaying a question.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `question` | `Question` | required | The question to display |
| `isSelected` | `bool` | `false` | Whether card is selected |
| `selectionMode` | `bool` | `false` | Enable selection checkbox |
| `onTap` | `VoidCallback?` | `null` | Tap handler (normal mode) |
| `onSelectionChanged` | `ValueChanged<bool>?` | `null` | Selection change handler |
| `onEdit` | `VoidCallback?` | `null` | Edit action handler |
| `onDuplicate` | `VoidCallback?` | `null` | Duplicate action handler |
| `onDelete` | `VoidCallback?` | `null` | Delete action handler |

### Usage

```dart
QuestionBankCard(
  question: question,
  isSelected: selectedIds.contains(question.questionId),
  selectionMode: isSelectionMode,
  onTap: () => navigateToDetails(question),
  onSelectionChanged: (_) => toggleSelection(question.questionId),
  onEdit: () => showEditDialog(question),
  onDuplicate: () => duplicateQuestion(question),
  onDelete: () => confirmDelete(question),
)
```

---

## QuestionBankFormDialog

Dialog for creating or editing questions. Supports all 6 question types.

### Usage

```dart
// Create new question
final newQuestion = await QuestionBankFormDialog.show(context);

// Edit existing question
final updatedQuestion = await QuestionBankFormDialog.show(
  context,
  question: existingQuestion,
);
```

### Features

- **Type Selector**: Visual chips for all 6 question types
- **Title Field**: Optional short title
- **Question Content**: Required question text (multiline)
- **Options Editor**: For single_choice and multi_choice types
  - Dynamic add/remove options
  - Minimum 2 options required
- **Scale Settings**: Min/max range for scale type
- **Category Field**: Optional categorization
- **Required Toggle**: Mark question as required
- **Validation**: Form validation before submission
- **Loading State**: Shows spinner during API call
- **Error Handling**: Displays API errors inline

### Question Types Supported

| Type | Fields |
|------|--------|
| `number` | Title, Content, Category, Required |
| `yesno` | Title, Content, Category, Required |
| `openended` | Title, Content, Category, Required |
| `single_choice` | Title, Content, Options (2+), Category, Required |
| `multi_choice` | Title, Content, Options (2+), Category, Required |
| `scale` | Title, Content, Min, Max, Category, Required |

---

## Testing

Tests should be placed in:
```
frontend/test/features/question_bank/
├── pages/
│   └── question_bank_page_test.dart
├── widgets/
│   ├── question_bank_card_test.dart
│   └── question_bank_form_dialog_test.dart
└── state/
    └── question_providers_test.dart
```

### Mock Example

```dart
class MockQuestionApi extends Mock implements QuestionApi {}

void main() {
  late MockQuestionApi mockApi;

  setUp(() {
    mockApi = MockQuestionApi();
  });

  test('loads questions', () async {
    when(() => mockApi.listQuestions()).thenAnswer(
      (_) async => [
        Question(
          questionId: 1,
          questionContent: 'Test question',
          responseType: 'yesno',
          isRequired: false,
        ),
      ],
    );

    final questions = await mockApi.listQuestions();
    expect(questions.length, 1);
  });
}
```
