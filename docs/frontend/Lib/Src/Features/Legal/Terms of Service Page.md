# TermsOfServicePage

**File:** `frontend/lib/src/features/legal/pages/terms_of_service_page.dart`

---

## Overview

`TermsOfServicePage` is a role-aware page that displays the application's Terms of Service. It is implemented as a `ConsumerWidget` using **Flutter Riverpod** to access authentication state and determine the current user's role.

Based on the authenticated user's role, the page dynamically selects the appropriate navigation header while rendering the Terms of Service content inside the shared application layout.

### Responsibilities

- Display the application's Terms of Service.
- Dynamically select the correct header for the current user role.
- Integrate with Riverpod authentication state.
- Provide a consistent layout using `BaseScaffold`.
- Enable scrolling for long legal content.
- Display the application footer.

The current implementation contains placeholder text and should be replaced with the finalized legal content for production.

---

## Architecture / Design

### Role-Based Header Selection

The page retrieves authentication state from the `authProvider` and determines the user's role:

```dart
final authState = ref.watch(authProvider);
final role = authState.user?.role;