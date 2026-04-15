<!-- Created with the Assistance of Claude Code -->
# Frontend API Client

The HealthBank frontend uses **Retrofit + Dio** for type-safe API communication, with **Freezed** models matching backend Pydantic schemas.

## Architecture

```
frontend/lib/core/api/
├── api.dart              # Main barrel file (import this)
├── api_client.dart       # Dio singleton configuration
├── models/
│   ├── models.dart       # Models barrel file
│   ├── survey.dart       # Survey models (matches backend Pydantic)
│   ├── question.dart     # Question models
│   ├── template.dart     # Template models
│   └── assignment.dart   # Assignment models
└── services/
    ├── services.dart     # Services barrel file
    ├── survey_api.dart   # Survey API endpoints
    ├── question_api.dart # Question Bank API endpoints
    ├── template_api.dart # Template API endpoints
    └── assignment_api.dart # Assignment API endpoints
```

## Quick Start

```dart
import 'package:frontend/core/api/api.dart';

// Get the API client singleton
final client = ApiClient();

// Create typed API services
final surveyApi = SurveyApi(client.dio);
final questionApi = QuestionApi(client.dio);
final templateApi = TemplateApi(client.dio);
final assignmentApi = AssignmentApi(client.dio);

// Make typed API calls
final surveys = await surveyApi.listSurveys();
final survey = await surveyApi.getSurvey(1);
```

## Code Generation

After modifying models or services, regenerate the `.g.dart` and `.freezed.dart` files:

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

For continuous rebuilding during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Configuration

### API Base URL

Configured in `api_client.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api/v1';
  static String get apiBaseUrl => '$baseUrl$apiPrefix';
}
```

### Timeouts

- Connect timeout: 30 seconds
- Receive timeout: 30 seconds

### Default Headers

```dart
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
}
```

---

## Authentication

The API client supports Bearer token authentication:

```dart
// Set auth token after login
ApiClient().setAuthToken(token);

// Clear token on logout
ApiClient().setAuthToken(null);
```

> **TODO:** Token will be automatically loaded from secure storage when auth is implemented.

---

## Error Handling

All API errors are transformed into `ApiException`:

```dart
try {
  final survey = await surveyApi.getSurvey(999);
} on DioException catch (e) {
  final error = e.error as ApiException;

  if (error.isNotFound) {
    // Handle 404
  } else if (error.isValidationError) {
    // Handle 422 validation error
  } else if (error.isUnauthorized) {
    // Handle 401 - redirect to login
  }

  print(error.message); // User-friendly error message
}
```

### ApiException Properties

| Property | Description |
|----------|-------------|
| `message` | User-friendly error message |
| `statusCode` | HTTP status code |
| `data` | Raw response data |
| `isValidationError` | True if 422 |
| `isUnauthorized` | True if 401 |
| `isForbidden` | True if 403 |
| `isNotFound` | True if 404 |
| `isServerError` | True if 5xx |

---

## Models (Freezed)

Models use Freezed for immutability and JSON serialization, matching backend Pydantic schemas.

### Survey Models

```dart
// Create a survey
final survey = SurveyCreate(
  title: 'Health Assessment',
  description: 'Annual health check',
  questionIds: [1, 2, 3],
);

// Response is typed
final created = await surveyApi.createSurvey(survey);
print(created.surveyId);
print(created.publicationStatus); // 'draft'
```

### Question Models

```dart
// Create a choice question
final question = QuestionCreate(
  title: 'Exercise Frequency',
  questionContent: 'How often do you exercise?',
  responseType: 'single_choice',
  isRequired: true,
  options: [
    QuestionOptionCreate(optionText: 'Never'),
    QuestionOptionCreate(optionText: 'Weekly'),
    QuestionOptionCreate(optionText: 'Daily'),
  ],
);
```

### Template Models

```dart
// Create a template
final template = TemplateCreate(
  title: 'Health Assessment Template',
  description: 'Reusable health survey',
  isPublic: true,
  questionIds: [1, 2, 3],
);
```

### Assignment Models

```dart
// Assign survey to user
final assignment = AssignmentCreate(
  accountId: 123,
  dueDate: DateTime.now().add(Duration(days: 7)),
);

// Bulk assign
final bulk = BulkAssignmentCreate(
  accountIds: [1, 2, 3],
  dueDate: DateTime.now().add(Duration(days: 7)),
);

// Bulk assignment aggregate result
final result = BulkAssignmentResult(
  assigned: 10,
  skipped: 2,
  totalTargeted: 12,
);
```

---

## API Services

### SurveyApi

| Method | Endpoint | Description |
|--------|----------|-------------|
| `createSurvey()` | POST /surveys | Create survey |
| `createFromTemplate()` | POST /surveys/from-template/{id} | Create from template |
| `listSurveys()` | GET /surveys | List all surveys |
| `getSurvey()` | GET /surveys/{id} | Get single survey |
| `updateSurvey()` | PUT /surveys/{id} | Update survey |
| `deleteSurvey()` | DELETE /surveys/{id} | Delete survey |
| `publishSurvey()` | PATCH /surveys/{id}/publish | Publish survey |
| `closeSurvey()` | PATCH /surveys/{id}/close | Close survey |
| `assignSurvey()` | POST /surveys/{id}/assign | Assign to user |
| `getSurveyAssignments()` | GET /surveys/{id}/assignments | List assignments |

### QuestionApi

| Method | Endpoint | Description |
|--------|----------|-------------|
| `createQuestion()` | POST /questions | Create question |
| `listQuestions()` | GET /questions | List questions |
| `getQuestion()` | GET /questions/{id} | Get question |
| `updateQuestion()` | PUT /questions/{id} | Update question |
| `deleteQuestion()` | DELETE /questions/{id} | Delete question |

### TemplateApi

| Method | Endpoint | Description |
|--------|----------|-------------|
| `createTemplate()` | POST /templates | Create template |
| `listTemplates()` | GET /templates | List templates |
| `getTemplate()` | GET /templates/{id} | Get template |
| `updateTemplate()` | PUT /templates/{id} | Update template |
| `deleteTemplate()` | DELETE /templates/{id} | Delete template |
| `duplicateTemplate()` | POST /templates/{id}/duplicate | Duplicate template |

### AssignmentApi

| Method | Endpoint | Description |
|--------|----------|-------------|
| `getMyAssignments()` | GET /assignments/me | Get user's assignments |
| `assignSurveyBulk()` | POST /surveys/{surveyId}/assign | Bulk assign by all participants or demographics; returns aggregate counts |
| `getSurveyAssignments()` | GET /surveys/{surveyId}/assignments | List survey assignments |
| `updateAssignment()` | PUT /assignments/{id} | Update assignment |
| `deleteAssignment()` | DELETE /assignments/{id} | Delete assignment |

### AdminApi (Impersonation)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `impersonateUser()` | POST /admin/users/{id}/impersonate | Start impersonating a user (System Admin only) |
| `endImpersonation()` | POST /admin/impersonate/end | End current impersonation session |

### AuthApi (Sessions)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `login()` | POST /auth/login | Login and get session token |
| `logout()` | DELETE /sessions/logout | Logout and invalidate session |
| `getSessionInfo()` | GET /sessions/me | Get session info with impersonation status |

---

## Impersonation Models

Models for admin impersonation feature:

```dart
// Check current session status
final sessionInfo = await authApi.getSessionInfo();
if (sessionInfo.isImpersonating) {
  print('Viewing as: ${sessionInfo.user.firstName}');
  print('Admin: ${sessionInfo.impersonationInfo?.adminEmail}');
}

// Start impersonation (admin only)
final result = await adminApi.impersonateUser(userId);
// Store result.sessionToken as new session
// Redirect based on result.impersonatedUser.role

// End impersonation
final endResult = await adminApi.endImpersonation();
// Redirect to admin dashboard using endResult.adminAccountId
```

---

## Riverpod Integration

For state management, create providers in feature directories:

```dart
// frontend/lib/features/surveys/state/survey_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final surveyApiProvider = Provider((ref) {
  final client = ref.watch(apiClientProvider);
  return SurveyApi(client.dio);
});

final surveysProvider = FutureProvider<List<Survey>>((ref) async {
  final api = ref.watch(surveyApiProvider);
  return api.listSurveys();
});

final surveyProvider = FutureProvider.family<Survey, int>((ref, id) async {
  final api = ref.watch(surveyApiProvider);
  return api.getSurvey(id);
});
```

---

## Testing

Use mocktail to mock API services:

```dart
import 'package:mocktail/mocktail.dart';
import 'package:frontend/core/api/api.dart';

class MockSurveyApi extends Mock implements SurveyApi {}

void main() {
  late MockSurveyApi mockApi;

  setUp(() {
    mockApi = MockSurveyApi();
  });

  test('loads surveys', () async {
    when(() => mockApi.listSurveys()).thenAnswer(
      (_) async => [
        Survey(surveyId: 1, title: 'Test', status: 'not-started', publicationStatus: 'draft'),
      ],
    );

    final surveys = await mockApi.listSurveys();
    expect(surveys.length, 1);
  });
}
```

---

## Interceptors

### _AuthInterceptor

Validates that the `Authorization` header is present on outgoing API requests. In debug mode, logs a warning if the header is missing on non-public endpoints (`/auth/login`, `/auth/register`, `/health`).

The auth token is set via `ApiClient.setAuthToken()` on Dio's default headers. This interceptor acts as a safety net to catch requests that might fire before the token is set.

### _ErrorInterceptor

Transforms Dio errors into `ApiException` instances. Also handles 401 responses:

- On 401 (excluding `/auth/login`): clears auth token and calls `ApiClient.onSessionExpired`
- The session expiry callback is set by `main.dart` to reset auth state and redirect to login
- Other error codes are transformed normally

### _LoggingInterceptor

Debug-mode only. Logs request method/URL, response status, and error details.

## Session Expiry

```dart
// Set by main.dart on app startup
ApiClient.onSessionExpired = () {
  // Clears secure storage, resets auth state
  // GoRouter redirect handles navigation to login
};
```

When a 401 is received on any endpoint except `/auth/login`, the interceptor:
1. Calls `ApiClient().setAuthToken(null)` to clear the Dio header
2. Calls `ApiClient.onSessionExpired?.call()` to notify the app

---

## Implementation Status

- [x] ApiClient singleton with Dio
- [x] Error handling interceptors
- [x] Auth interceptor (debug warning for missing token)
- [x] 401 session expiry handling
- [x] Survey models (Freezed)
- [x] Question models (Freezed)
- [x] Template models (Freezed)
- [x] Assignment models (Freezed)
- [x] SurveyApi service
- [x] QuestionApi service
- [x] TemplateApi service
- [x] AssignmentApi service
- [x] Impersonation models (Freezed)
- [x] AdminApi impersonation endpoints
- [x] AuthApi getSessionInfo endpoint
- [x] Riverpod providers
- [x] Auth token integration
