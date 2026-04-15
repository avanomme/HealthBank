// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/state/impersonation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show authApiProvider, authProvider, sessionKeyProvider;
import 'package:frontend/src/features/admin/state/database_providers.dart';

/// Describes which view-as mode is active.
///
/// - [none]: admin is on their own pages, no view-as active.
/// - [rolePreview]: frontend-only role preview (no backend API call).
/// - [fullUser]: full backend impersonation with ViewingAsUserID.
enum ViewAsMode { none, rolePreview, fullUser }

const String _previewRoleStorageKey = 'admin_view_as_preview_role';

/// State class for the unified impersonation / view-as system.
class ImpersonationState {
  final ViewAsMode mode;
  final String? previewRole;
  final bool isLoading;
  final String? error;
  final SessionUserInfo? currentUser;
  final ImpersonationInfo? adminInfo;
  final String? sessionExpiresAt;

  const ImpersonationState({
    this.mode = ViewAsMode.none,
    this.previewRole,
    this.isLoading = false,
    this.error,
    this.currentUser,
    this.adminInfo,
    this.sessionExpiresAt,
  });

  /// Whether any view-as mode is active (role preview or full user).
  bool get isActive => mode != ViewAsMode.none;

  /// Whether in frontend-only role preview mode.
  bool get isRolePreview => mode == ViewAsMode.rolePreview;

  /// Whether in full backend impersonation mode.
  bool get isFullUser => mode == ViewAsMode.fullUser;

  /// Backward-compatible alias — true when any view-as mode is active.
  bool get isImpersonating => isActive;

  ImpersonationState copyWith({
    ViewAsMode? mode,
    String? previewRole,
    bool clearPreviewRole = false,
    bool? isLoading,
    String? error,
    SessionUserInfo? currentUser,
    ImpersonationInfo? adminInfo,
    String? sessionExpiresAt,
    bool clearCurrentUser = false,
    bool clearAdminInfo = false,
    bool clearSessionExpiresAt = false,
  }) {
    return ImpersonationState(
      mode: mode ?? this.mode,
      previewRole: clearPreviewRole ? null : (previewRole ?? this.previewRole),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      adminInfo: clearAdminInfo ? null : (adminInfo ?? this.adminInfo),
      sessionExpiresAt: clearSessionExpiresAt
          ? null
          : (sessionExpiresAt ?? this.sessionExpiresAt),
    );
  }

  /// Clear state (used on logout)
  ImpersonationState clear() {
    return const ImpersonationState();
  }

  /// Get the current user's full name
  String get currentUserName {
    if (currentUser == null) return '';
    final first = currentUser!.firstName ?? '';
    final last = currentUser!.lastName ?? '';
    return '$first $last'.trim();
  }

  /// Get the admin's full name (when impersonating)
  String get adminName {
    if (adminInfo == null) return '';
    final first = adminInfo!.adminFirstName ?? '';
    final last = adminInfo!.adminLastName ?? '';
    return '$first $last'.trim();
  }
}

/// State notifier for managing impersonation state
class ImpersonationNotifier extends StateNotifier<ImpersonationState> {
  final Ref ref;

  ImpersonationNotifier(this.ref) : super(const ImpersonationState()) {
    _hydratePreviewRole();
  }

  Future<void> _hydratePreviewRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(_previewRoleStorageKey);

      if (role != null && role.isNotEmpty) {
        state = state.copyWith(
          mode: ViewAsMode.rolePreview,
          previewRole: role.toLowerCase(),
        );
      }
    } catch (_) {}
  }

  Future<void> _savePreviewRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    if (role == null || role.isEmpty) {
      await prefs.remove(_previewRoleStorageKey);
    } else {
      await prefs.setString(_previewRoleStorageKey, role.toLowerCase());
    }
  }

  /// Fetch current session info and update impersonation state
  Future<void> fetchSessionInfo() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authApi = ref.read(authApiProvider);
      final response = await authApi.getSessionInfo();

      if (response.isImpersonating) {
        // Full backend impersonation should override preview mode.
        await _savePreviewRole(null);

        state = ImpersonationState(
          mode: ViewAsMode.fullUser,
          isLoading: false,
          currentUser: response.user,
          adminInfo: response.impersonationInfo,
          sessionExpiresAt: response.sessionExpiresAt,
        );
      } else {
        // No backend impersonation.
        // Preserve frontend role preview if one is active/persisted.
        final previewRole = state.previewRole;

        state = ImpersonationState(
          mode: previewRole != null ? ViewAsMode.rolePreview : ViewAsMode.none,
          previewRole: previewRole,
          isLoading: false,
          currentUser: response.user,
          adminInfo: null,
          sessionExpiresAt: response.sessionExpiresAt,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
    }
  }

  /// Start frontend-only role preview — no API call, just navigation chrome switch.
  Future<void> startRolePreview(String role) async {
    final normalized = role.toLowerCase();

    state = state.copyWith(
      mode: ViewAsMode.rolePreview,
      previewRole: normalized,
      error: null,
    );

    await _savePreviewRole(normalized);
  }

  /// Start viewing as another user (admin only) — full backend impersonation.
  Future<String?> startImpersonation(int userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final adminApi = ref.read(adminApiProvider);
      final response = await adminApi.startViewingAs(userId);

      await _savePreviewRole(null);

      state = ImpersonationState(
        mode: ViewAsMode.fullUser,
        isLoading: false,
        currentUser: SessionUserInfo(
          accountId: response.viewedUser.userId,
          firstName: response.viewedUser.firstName,
          lastName: response.viewedUser.lastName,
          email: response.viewedUser.email,
          role: response.viewedUser.role,
          roleId: response.viewedUser.roleId,
        ),
        adminInfo: null,
      );

      ref.read(sessionKeyProvider.notifier).state++;
      return response.viewedUser.role;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return null;
    }
  }

  /// End any active view-as mode and return to admin view.
  Future<bool> endImpersonation() async {
    if (state.isRolePreview) {
      await _savePreviewRole(null);
      state = const ImpersonationState();
      return true;
    }

    // Full user impersonation: call backend to clear ViewingAsUserID
    state = state.copyWith(isLoading: true, error: null);

    try {
      final adminApi = ref.read(adminApiProvider);

      // Call view-as/end endpoint - no token switching needed
      await adminApi.endViewingAs();

      // Rebuild auth state from the now-restored admin session.
      await ref.read(authProvider.notifier).restoreSession();

      // Refresh impersonation/session info too, so currentUser/adminInfo are correct.
      await fetchSessionInfo();

      // Bump session key so all providers re-fetch with admin's own identity.
      ref.read(sessionKeyProvider.notifier).state++;

      // Mark as no longer loading. After restoreSession + fetchSessionInfo,
      // state should now represent the non-impersonating admin session.
      state = state.copyWith(isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return false;
    }
  }

  /// Clear impersonation state after navigation
  ///
  /// Call this AFTER navigating to the admin page to avoid
  /// the banner unmounting before navigation completes.
  void clearImpersonationState() {
    state = const ImpersonationState();
    _savePreviewRole(null);
  }

  /// Clear impersonation state (called on logout)
  void clear() {
    state = const ImpersonationState();
    _savePreviewRole(null);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  String _parseError(dynamic error) {
    final msg = error.toString();
    if (msg.contains('401')) return 'Session expired. Please login again.';
    if (msg.contains('403')) {
      return 'Only system administrators can view as other users.';
    }
    if (msg.contains('404')) return 'User not found.';
    if (msg.contains('400')) return 'Invalid request.';
    if (msg.contains('500')) return 'Server error. Please try again later.';
    return 'An error occurred. Please try again.';
  }
}

/// Provider for impersonation state management
final impersonationProvider =
    StateNotifierProvider<ImpersonationNotifier, ImpersonationState>((ref) {
  return ImpersonationNotifier(ref);
});

/// Helper provider to check if the real authenticated user is a system admin.
final isSystemAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.role == 'admin';
});

/// Helper provider to get the current user's effective role name.
///
/// Priority:
/// 1. Role preview mode -> previewed role
/// 2. Full user impersonation -> impersonated user's role
/// 3. Normal session -> authenticated user's role
final currentUserRoleProvider = Provider<String?>((ref) {
  final impersonationState = ref.watch(impersonationProvider);

  // Role preview: return the previewed role directly
  if (impersonationState.isRolePreview) {
    return impersonationState.previewRole;
  }

  if (impersonationState.isFullUser) {
    return impersonationState.currentUser?.role;
  }

  final authState = ref.watch(authProvider);
  return authState.user?.role;
});