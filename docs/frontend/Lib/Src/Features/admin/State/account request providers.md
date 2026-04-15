# Account Request Providers (`account_request_providers.dart`)

## Overview

This file defines Riverpod providers used by the admin UI to manage **account request** workflows. It centralizes:

- Construction of an `AdminApi` client (`adminApiProvider`)
- The currently-selected request status filter tab (`accountRequestStatusFilter`)
- Fetching account requests matching the selected status (`accountRequestsProvider`)
- Fetching a pending request count used for UI badges (`accountRequestCountProvider`)

These providers are typically consumed by admin pages such as the account requests/messages screen, enabling reactive refresh when the selected status changes or when providers are invalidated.

## Architecture / Design

### Provider graph

- `adminApiProvider` depends on `apiClientProvider` and builds `AdminApi` using the configured Dio client.
- `accountRequestStatusFilter` is a `StateProvider<String>` representing the active tab/status (default: `'pending'`).
- `accountRequestsProvider` depends on:
  - `adminApiProvider`
  - `accountRequestStatusFilter`
  and fetches a list of requests filtered by status.
- `accountRequestCountProvider` depends on:
  - `adminApiProvider`
  and fetches the pending request count (for sidebar badges, etc.).

### Reactivity

- Changing `accountRequestStatusFilter` automatically causes `accountRequestsProvider` to recompute and refetch.
- Invalidation (`ref.invalidate(...)`) of `accountRequestsProvider` or `accountRequestCountProvider` forces refetch on next read/watch.

## Configuration

No file-local configuration is required. The following dependencies must be correctly configured elsewhere:

- `apiClientProvider` must provide an API client with a configured `dio` instance.
- `AdminApi` must support:
  - `getAccountRequests({String status})`
  - `getAccountRequestCount()`

## API Reference

## `adminApiProvider`

```dart
final adminApiProvider = Provider<AdminApi>((ref) { ... });