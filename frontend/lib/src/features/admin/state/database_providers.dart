// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/state/database_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show adminApiProvider;

export 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show adminApiProvider;

/// Provider for the list of all database tables with schema info
final databaseTablesProvider = FutureProvider<List<TableSchema>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(adminApiProvider);
  final response = await api.listTables();
  return response.tables;
});

/// Provider for a specific table's detail (schema + data)
final tableDetailProvider =
    FutureProvider.family<TableDetailResponse, TableDetailParams>(
        (ref, params) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(adminApiProvider);
  return api.getTable(
    params.tableName,
    limit: params.limit,
    offset: params.offset,
  );
});

/// Parameters for table detail provider
class TableDetailParams {
  final String tableName;
  final int limit;
  final int offset;

  const TableDetailParams({
    required this.tableName,
    this.limit = 100,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableDetailParams &&
        other.tableName == tableName &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(tableName, limit, offset);
}

/// State notifier for managing table selection and pagination
class DatabaseViewerState {
  final String? selectedTable;
  final int currentPage;
  final int pageSize;
  final bool showSchema;

  const DatabaseViewerState({
    this.selectedTable,
    this.currentPage = 0,
    this.pageSize = 100,
    this.showSchema = true,
  });

  DatabaseViewerState copyWith({
    String? selectedTable,
    int? currentPage,
    int? pageSize,
    bool? showSchema,
  }) {
    return DatabaseViewerState(
      selectedTable: selectedTable ?? this.selectedTable,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      showSchema: showSchema ?? this.showSchema,
    );
  }

  int get offset => currentPage * pageSize;
}

class DatabaseViewerNotifier extends StateNotifier<DatabaseViewerState> {
  DatabaseViewerNotifier() : super(const DatabaseViewerState());

  void selectTable(String tableName) {
    state = state.copyWith(selectedTable: tableName, currentPage: 0);
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void toggleShowSchema() {
    state = state.copyWith(showSchema: !state.showSchema);
  }

  void setShowSchema(bool show) {
    state = state.copyWith(showSchema: show);
  }
}

final databaseViewerProvider =
    StateNotifierProvider<DatabaseViewerNotifier, DatabaseViewerState>((ref) {
  return DatabaseViewerNotifier();
});
