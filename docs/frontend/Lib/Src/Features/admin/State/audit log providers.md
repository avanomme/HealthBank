# Audit Log Providers (`audit_log_providers.dart`)

## Overview

This file defines the Riverpod state and data-fetching providers used by the Admin Audit Log UI. It includes:

- An immutable `AuditLogFilters` value object representing all supported filter and pagination state
- An `AuditLogFiltersNotifier` (`StateNotifier`) that updates filter state with sensible defaults (notably resetting pagination when filters change)
- Providers to:
  - fetch audit log events for the active filter set (`auditLogsProvider`)
  - fetch filter option values (available actions and resource types)

These providers are typically consumed by the Audit Log page to render a filter panel, a pageable table of audit events, and dropdown options.

## Architecture / Design

### State model: `AuditLogFilters`

`AuditLogFilters` is a lightweight immutable state object that holds:

- Query filters (action, status, actor, resource type, HTTP method, search, date range)
- Pagination controls (`limit`, `offset`)
- A computed `currentPage`

It overrides `==` and `hashCode` to ensure Riverpod can correctly detect meaningful state changes. This is important because `auditLogsProvider` depends on this filter state; changes should trigger refetches.

### Updates: `AuditLogFiltersNotifier`

`AuditLogFiltersNotifier` encapsulates all mutations of the `AuditLogFilters` state.

Design choices:
- **Reset pagination on filter changes**: most setters apply `offset: 0` so users are returned to page 1 when filters change.
- **Clear flags in `copyWith`**: `copyWith` supports explicit clearing of fields (e.g., `clearStatus`) so callers can pass `null` to clear a filter without ambiguity.
- **Pagination helpers**: `setPage`, `nextPage`, and `previousPage` adjust `offset` based on `limit`.

### Provider graph

- `auditLogFiltersProvider` is the source of truth for filter state.
- `auditLogsProvider` depends on:
  - `adminApiProvider`
  - `auditLogFiltersProvider`
  and calls `AdminApi.getAuditLogs(...)` with the active filters.
- `auditLogActionsProvider` depends on `adminApiProvider` and loads distinct action values.
- `auditLogResourceTypesProvider` depends on `adminApiProvider` and loads distinct resource type values.

### API dependency note

This file imports `adminApiProvider` from `database_providers.dart`:

```dart
import 'database_providers.dart' show adminApiProvider;