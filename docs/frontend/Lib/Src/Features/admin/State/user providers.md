# User Providers (`user_providers.dart`)

## Overview

This file defines Riverpod providers and state notifiers for admin-facing user management:

- `userApiProvider`: constructs a `UserApi` using the shared API client.
- `UserFilters` + `UserFiltersNotifier`: holds and mutates filter state used to query users (role, active status, search query).
- `usersProvider`: fetches a filtered list of users (`UserListResponse`) from the backend.
- `userByIdProvider`: fetches an individual `User` by account ID.
- `UserManagementNotifier` + `userManagementProvider`: executes user management mutations (create, update, toggle active, delete) with loading/error state and automatic list refresh.

These providers are typically consumed by the Admin "User Management" page to power search/filter controls, a users table, and CRUD actions.

## Architecture / Design

### API construction: `userApiProvider`

`userApiProvider` is a plain `Provider<UserApi>` that instantiates `UserApi` from the shared API client (`apiClientProvider`). This centralizes `UserApi` construction and makes it easy to mock/override in tests.

### Filter state: `UserFilters`

`UserFilters` is an immutable value object that represents the current user list filter criteria:

- `role`: role filter (e.g., `"participant"`, `"researcher"`, `"hcp"`, `"admin"`)
- `isActive`: active status filter (`true`, `false`, or `null` for "all")
- `searchQuery`: free-text search input (defaults to `''`)

It provides:
- `copyWith(...)` for updates
- explicit `clearX()` helpers to reset specific filters
- `clearAll()` to reset to defaults

### Filter mutations: `UserFiltersNotifier`

`UserFiltersNotifier` is a `StateNotifier<UserFilters>` encapsulating all filter updates. This ensures UI components do not directly manipulate filter objects and keeps filter update behavior consistent.

Notable behaviors:
- `setRole(null)` clears the role filter via `clearRole()`
- `setSearchQuery(...)` stores the raw query; consumers decide how to translate that into API params

### Data fetching: `usersProvider` and `userByIdProvider`

- `usersProvider` depends on `userFiltersProvider`. Any filter change triggers a refetch.
- It converts empty `searchQuery` into `null` for the backend `search` parameter to avoid sending empty strings.
- `userByIdProvider` is a `FutureProvider.family` for loading a single user.

### Mutations: `UserManagementNotifier`

`UserManagementNotifier` tracks mutation lifecycle using `AsyncValue<void>`:
- sets `loading` before the request
- sets `data(null)` on success
- sets `error` on failure
- invalidates `usersProvider` on success to refresh the list

Each mutation method returns a value useful to the UI:
- create/update/toggle return the updated/created `User?` (or `null` on error)
- delete returns `bool` success/failure

The notifier uses `ref.read(userApiProvider)` (not `watch`) to avoid unnecessary rebuilds.

## Configuration

No local configuration is required.

External requirements:
- `apiClientProvider` must supply an API client with a configured `dio` instance.
- `UserApi` must implement:
  - `listUsers({String? role, bool? isActive, String? search})`
  - `getUser(int id)`
  - `createUser(UserCreate user)`
  - `updateUser(int userId, UserUpdate user)`
  - `toggleUserStatus(int userId, bool isActive)`
  - `deleteUser(int userId)`

## API Reference

## `userApiProvider`

```dart
final userApiProvider = Provider<UserApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return UserApi(client.dio);
});