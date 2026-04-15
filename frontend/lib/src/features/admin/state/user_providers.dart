// Created with the Assistance of Claude Code
// frontend/lib/features/admin/state/user_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:frontend/src/features/admin/state/database_providers.dart'
    show adminApiProvider;

/// Provider for the UserApi service
final userApiProvider = Provider<UserApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return UserApi(client.dio);
});

/// Immutable filter parameters for the admin user list.
class UserFilters {
  final String? role;
  final bool? isActive;
  final String searchQuery;

  const UserFilters({
    this.role,
    this.isActive,
    this.searchQuery = '',
  });

  UserFilters copyWith({
    Object? role = _unset,
    Object? isActive = _unset,
    Object? searchQuery = _unset,
  }) {
    return UserFilters(
      role: identical(role, _unset) ? this.role : role as String?,
      isActive: identical(isActive, _unset) ? this.isActive : isActive as bool?,
      searchQuery: identical(searchQuery, _unset)
          ? this.searchQuery
          : searchQuery as String,
    );
  }

  static const Object _unset = Object();

  UserFilters clearRole() {
    return UserFilters(
      role: null,
      isActive: isActive,
      searchQuery: searchQuery,
    );
  }

  UserFilters clearIsActive() {
    return UserFilters(
      role: role,
      isActive: null,
      searchQuery: searchQuery,
    );
  }

  UserFilters clearSearch() {
    return UserFilters(
      role: role,
      isActive: isActive,
      searchQuery: '',
    );
  }

  UserFilters clearAll() {
    return const UserFilters();
  }
}

/// Provider for user filter state
final userFiltersProvider =
    StateNotifierProvider<UserFiltersNotifier, UserFilters>((ref) {
  return UserFiltersNotifier();
});

/// Notifier for user filter state management
class UserFiltersNotifier extends StateNotifier<UserFilters> {
  UserFiltersNotifier() : super(const UserFilters());

  void setRole(String? role) {
    if (role == null) {
      state = state.clearRole();
    } else {
      state = state.copyWith(role: role);
    }
  }

  void setIsActive(bool? isActive) {
    state = state.copyWith(isActive: isActive);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearRole() {
    state = state.clearRole();
  }

  void clearIsActive() {
    state = state.clearIsActive();
  }

  void clearSearch() {
    state = state.clearSearch();
  }

  void clearAll() {
    state = state.clearAll();
  }
}

/// Provider for fetching users from API
final usersProvider = FutureProvider<UserListResponse>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(userApiProvider);
  final filters = ref.watch(userFiltersProvider);

  return api.listUsers(
    role: filters.role,
    isActive: filters.isActive,
    search: filters.searchQuery.isNotEmpty ? filters.searchQuery : null,
  );
});

/// Provider for a single user by ID
final userByIdProvider = FutureProvider.family<User, int>((ref, id) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(userApiProvider);
  return api.getUser(id);
});

/// State notifier for user management operations (create, update, delete)
class UserManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UserManagementNotifier(this.ref) : super(const AsyncValue.data(null));

  /// Create a new user
  Future<User?> createUser(UserCreate user) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(userApiProvider);
      final result = await api.createUser(user);
      state = const AsyncValue.data(null);
      ref.invalidate(usersProvider);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update an existing user
  Future<User?> updateUser(int userId, UserUpdate user) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(userApiProvider);
      final result = await api.updateUser(userId, user);
      state = const AsyncValue.data(null);
      ref.invalidate(usersProvider);
      ref.invalidate(userByIdProvider(userId));
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Toggle user active status
  Future<User?> toggleUserStatus(int userId, bool isActive) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(userApiProvider);
      final result = await api.toggleUserStatus(userId, isActive);
      state = const AsyncValue.data(null);
      ref.invalidate(usersProvider);
      ref.invalidate(userByIdProvider(userId));
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Delete a user
  Future<bool> deleteUser(int userId) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(userApiProvider);
      await api.deleteUser(userId);
      state = const AsyncValue.data(null);
      ref.invalidate(usersProvider);
      ref.invalidate(userByIdProvider(userId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void clearError() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for user management operations
final userManagementProvider =
    StateNotifierProvider<UserManagementNotifier, AsyncValue<void>>((ref) {
  return UserManagementNotifier(ref);
});

/// Provider to fetch consent record for a specific user
final userConsentProvider =
    FutureProvider.family<UserConsentRecordResponse?, int>((ref, userId) async {
  final api = ref.watch(adminApiProvider);
  return api.getUserConsentRecord(userId);
});
