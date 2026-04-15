// Created with the Assistance of Claude Code
// State management for the user management table UI state
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/features/admin/pages/user_management_page.dart'
    show UserSortColumn;

/// Immutable state for the user management table
class UserTableState {
  final UserSortColumn sortColumn;
  final bool sortAscending;
  final int? expandedRowIndex;
  final int? impersonatingUserId;

  const UserTableState({
    this.sortColumn = UserSortColumn.name,
    this.sortAscending = true,
    this.expandedRowIndex,
    this.impersonatingUserId,
  });

  UserTableState copyWith({
    UserSortColumn? sortColumn,
    bool? sortAscending,
    int? Function()? expandedRowIndex,
    int? Function()? impersonatingUserId,
  }) {
    return UserTableState(
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      expandedRowIndex:
          expandedRowIndex != null ? expandedRowIndex() : this.expandedRowIndex,
      impersonatingUserId: impersonatingUserId != null
          ? impersonatingUserId()
          : this.impersonatingUserId,
    );
  }
}

/// StateNotifier for user table UI state (sort, expand, impersonation loading)
class UserTableNotifier extends StateNotifier<UserTableState> {
  UserTableNotifier() : super(const UserTableState());

  /// Handle sort column tap — toggles direction if same column, else sets new column ascending
  void onSort(UserSortColumn column) {
    if (state.sortColumn == column) {
      state = state.copyWith(sortAscending: !state.sortAscending);
    } else {
      state = state.copyWith(sortColumn: column, sortAscending: true);
    }
  }

  /// Toggle expanded row — collapse if already expanded, else expand new row
  void toggleExpandedRow(int index) {
    state = state.copyWith(
      expandedRowIndex: () => state.expandedRowIndex == index ? null : index,
    );
  }

  /// Set the user ID currently being impersonated (loading indicator)
  void setImpersonating(int? userId) {
    state = state.copyWith(impersonatingUserId: () => userId);
  }
}

/// Provider for user table UI state
final userTableProvider =
    StateNotifierProvider<UserTableNotifier, UserTableState>((ref) {
  return UserTableNotifier();
});
