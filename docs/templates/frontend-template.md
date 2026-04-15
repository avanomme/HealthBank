# [Feature Name] Frontend

> Last updated: [DATE] | Task: [TASK_ID]

## Overview

Brief description of this frontend feature and its purpose.

## File Structure

```
lib/features/[feature_name]/
├── models/
│   └── [model].dart          # Data models (Freezed)
├── services/
│   └── [feature]_service.dart # API client (Retrofit)
├── state/
│   └── [feature]_providers.dart # Riverpod providers
├── pages/
│   └── [feature]_page.dart    # Main page
└── widgets/
    ├── [widget1].dart
    └── [widget2].dart
```

## Pages

### [FeatureName]Page

**Location:** `lib/features/[feature]/pages/[feature]_page.dart`

**Purpose:** Main page for [feature] functionality

**Route:** `/[feature]`

**Required Permissions:** `researcher`, `admin`

**Screenshot:**
<!-- Add screenshot here -->

**Key Features:**
- Feature 1
- Feature 2
- Feature 3

## Widgets

### [WidgetName]

**Location:** `lib/features/[feature]/widgets/[widget].dart`

**Purpose:** Reusable widget for displaying [thing]

**Props:**
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| data | ModelType | Yes | - | The data to display |
| onTap | VoidCallback? | No | null | Called when tapped |
| isSelected | bool | No | false | Selection state |

**Usage:**
```dart
WidgetName(
  data: myData,
  onTap: () => handleTap(),
  isSelected: true,
)
```

**States:**
- Default: Normal appearance
- Selected: Highlighted border
- Loading: Shows shimmer
- Error: Shows error message

## State Management

### Providers

**Location:** `lib/features/[feature]/state/[feature]_providers.dart`

```dart
// List provider with pagination
final featureListProvider = AsyncNotifierProvider<FeatureListNotifier, List<Feature>>(() {
  return FeatureListNotifier();
});

// Single item provider
final featureProvider = FutureProvider.family<Feature, int>((ref, id) async {
  return ref.read(featureServiceProvider).getById(id);
});
```

**Usage in Widget:**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(featureListProvider);

    return asyncData.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorWidget(err),
      data: (items) => ListView.builder(...),
    );
  }
}
```

## API Integration

### Service

**Location:** `lib/features/[feature]/services/[feature]_service.dart`

```dart
@RestApi()
abstract class FeatureService {
  factory FeatureService(Dio dio) = _FeatureService;

  @GET('/api/v1/features')
  Future<List<Feature>> getAll();

  @POST('/api/v1/features')
  Future<Feature> create(@Body() CreateFeatureRequest request);
}
```

## Forms & Validation

### [FormName]

**Fields:**
| Field | Type | Validation | Error Message |
|-------|------|------------|---------------|
| name | TextFormField | Required, max 100 chars | "Name is required" |
| email | TextFormField | Required, valid email | "Invalid email" |

**Submission Flow:**
1. Validate all fields
2. Show loading indicator
3. Call API
4. On success: Navigate/show success
5. On error: Show snackbar with message

## Navigation

### Routes
```dart
GoRoute(
  path: '/feature',
  builder: (context, state) => FeaturePage(),
),
GoRoute(
  path: '/feature/:id',
  builder: (context, state) => FeatureDetailPage(
    id: int.parse(state.pathParameters['id']!),
  ),
),
```

### Deep Linking
- `/feature` - List page
- `/feature/123` - Detail page for ID 123
- `/feature/new` - Create new

## Theming

Uses theme from `lib/core/theme/theme.dart`:
- Primary: `AppColors.primary` (#172B46)
- Secondary: `AppColors.secondary` (#145B2C)
- Error: `AppColors.error` (#E03131)

## Accessibility

- [ ] All images have alt text
- [ ] Touch targets are 48x48 minimum
- [ ] Colors have sufficient contrast
- [ ] Screen reader labels on interactive elements

## Testing

**Location:** `test/features/[feature]/`

```bash
# Run feature tests
flutter test test/features/[feature]/

# Run with coverage
flutter test --coverage test/features/[feature]/
```

**Test Coverage:**
- [ ] Widget renders correctly
- [ ] Loading state displays
- [ ] Error state displays
- [ ] User interactions work
- [ ] API integration works

## Troubleshooting

### Common Issues

**Problem:** Widget not updating when data changes
**Solution:** Ensure using `ref.watch()` not `ref.read()` in build method

**Problem:** Form validation not triggering
**Solution:** Check that `Form` widget has a `GlobalKey<FormState>`

## Related Documentation

- [API Documentation](../api/[feature].md)
- [Database Schema](../database/schema.md)
- [Design System](./design-system.md)
