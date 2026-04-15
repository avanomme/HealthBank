// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/state/audit_log_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'database_providers.dart' show adminApiProvider;

/// State for audit log filters
class AuditLogFilters {
  final String? action;
  final String? status;
  final int? actorAccountId;
  final String? resourceType;
  final String? httpMethod;
  final String? search;
  final String? startDate;
  final String? endDate;
  final int limit;
  final int offset;

  const AuditLogFilters({
    this.action,
    this.status,
    this.actorAccountId,
    this.resourceType,
    this.httpMethod,
    this.search,
    this.startDate,
    this.endDate,
    this.limit = 50,
    this.offset = 0,
  });

  AuditLogFilters copyWith({
    String? action,
    String? status,
    int? actorAccountId,
    String? resourceType,
    String? httpMethod,
    String? search,
    String? startDate,
    String? endDate,
    int? limit,
    int? offset,
    bool clearAction = false,
    bool clearStatus = false,
    bool clearActorAccountId = false,
    bool clearResourceType = false,
    bool clearHttpMethod = false,
    bool clearSearch = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return AuditLogFilters(
      action: clearAction ? null : (action ?? this.action),
      status: clearStatus ? null : (status ?? this.status),
      actorAccountId: clearActorAccountId ? null : (actorAccountId ?? this.actorAccountId),
      resourceType: clearResourceType ? null : (resourceType ?? this.resourceType),
      httpMethod: clearHttpMethod ? null : (httpMethod ?? this.httpMethod),
      search: clearSearch ? null : (search ?? this.search),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  int get currentPage => offset ~/ limit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuditLogFilters &&
        other.action == action &&
        other.status == status &&
        other.actorAccountId == actorAccountId &&
        other.resourceType == resourceType &&
        other.httpMethod == httpMethod &&
        other.search == search &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        action,
        status,
        actorAccountId,
        resourceType,
        httpMethod,
        search,
        startDate,
        endDate,
        limit,
        offset,
      );
}

/// Notifier for audit log filters
class AuditLogFiltersNotifier extends StateNotifier<AuditLogFilters> {
  AuditLogFiltersNotifier() : super(const AuditLogFilters());

  void setAction(String? action) {
    state = state.copyWith(action: action, clearAction: action == null, offset: 0);
  }

  void setStatus(String? status) {
    state = state.copyWith(status: status, clearStatus: status == null, offset: 0);
  }

  void setActorAccountId(int? id) {
    state = state.copyWith(actorAccountId: id, clearActorAccountId: id == null, offset: 0);
  }

  void setResourceType(String? type) {
    state = state.copyWith(resourceType: type, clearResourceType: type == null, offset: 0);
  }

  void setHttpMethod(String? method) {
    state = state.copyWith(httpMethod: method, clearHttpMethod: method == null, offset: 0);
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search, clearSearch: search == null || search.isEmpty, offset: 0);
  }

  void setDateRange(String? startDate, String? endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      clearStartDate: startDate == null,
      clearEndDate: endDate == null,
      offset: 0,
    );
  }

  void setPage(int page) {
    state = state.copyWith(offset: page * state.limit);
  }

  void nextPage() {
    state = state.copyWith(offset: state.offset + state.limit);
  }

  void previousPage() {
    if (state.offset >= state.limit) {
      state = state.copyWith(offset: state.offset - state.limit);
    }
  }

  void clearFilters() {
    state = AuditLogFilters(limit: state.limit);
  }
}

/// Provider for audit log filters state
final auditLogFiltersProvider =
    StateNotifierProvider<AuditLogFiltersNotifier, AuditLogFilters>((ref) {
  return AuditLogFiltersNotifier();
});

/// Provider for fetching audit logs based on current filters
final auditLogsProvider = FutureProvider<AuditLogResponse>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(adminApiProvider);
  final filters = ref.watch(auditLogFiltersProvider);

  return api.getAuditLogs(
    limit: filters.limit,
    offset: filters.offset,
    action: filters.action,
    status: filters.status,
    actorAccountId: filters.actorAccountId,
    resourceType: filters.resourceType,
    httpMethod: filters.httpMethod,
    search: filters.search,
    startDate: filters.startDate,
    endDate: filters.endDate,
  );
});

/// Provider for available action types
final auditLogActionsProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(adminApiProvider);
  return api.getAuditLogActions();
});

/// Provider for available resource types
final auditLogResourceTypesProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(adminApiProvider);
  return api.getAuditLogResourceTypes();
});
