// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/admin/pages/user_management_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/features/admin/state/user_providers.dart';
import 'package:frontend/src/features/admin/state/user_table_state.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/features/auth/auth_state.dart';
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart'
    as custom;
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';

/// Sortable columns for the user table
enum UserSortColumn { name, email, role, status, lastLogin }

/// User Management page for admins
///
/// Features:
/// - List all users from API in a sortable table
/// - Search users by name or email
/// - Filter by role
/// - Add new users
/// - Edit user roles and access
/// - Activate/deactivate users
class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  /// Current logged-in user's account ID (to prevent self-deletion)
  int? get _currentAccountId => ref.watch(authProvider).user?.accountId;

  @override
  void initState() {
    super.initState();
    // Initialize search controller with current filter value
    final filters = ref.read(userFiltersProvider);
    _searchController.text = filters.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> _sortUsers(List<User> users, UserTableState tableState) {
    final sorted = List<User>.from(users);
    sorted.sort((a, b) {
      int comparison;
      switch (tableState.sortColumn) {
        case UserSortColumn.name:
          final aName = '${a.firstName} ${a.lastName}'.toLowerCase();
          final bName = '${b.firstName} ${b.lastName}'.toLowerCase();
          comparison = aName.compareTo(bName);
          break;
        case UserSortColumn.email:
          comparison = a.email.toLowerCase().compareTo(b.email.toLowerCase());
          break;
        case UserSortColumn.role:
          final aRole = a.role ?? 'zzz'; // Put null roles at end
          final bRole = b.role ?? 'zzz';
          comparison = aRole.compareTo(bRole);
          break;
        case UserSortColumn.status:
          comparison = (a.isActive ? 0 : 1).compareTo(b.isActive ? 0 : 1);
          break;
        case UserSortColumn.lastLogin:
          if (a.lastLogin == null && b.lastLogin == null) {
            comparison = 0;
          } else if (a.lastLogin == null) {
            comparison = 1;
          } else if (b.lastLogin == null) {
            comparison = -1;
          } else {
            comparison = b.lastLogin!.compareTo(a.lastLogin!);
          }
          break;
      }
      return tableState.sortAscending ? comparison : -comparison;
    });
    return sorted;
  }

  void _onSearchChanged(String value) {
    ref.read(userFiltersProvider.notifier).setSearchQuery(value);
  }

  void _onRoleFilterChanged(String? role) {
    ref.read(userFiltersProvider.notifier).setRole(role);
  }

  void _cycleActiveFilter() {
    final notifier = ref.read(userFiltersProvider.notifier);
    final current = ref.read(userFiltersProvider).isActive;

    if (current == false) {
      notifier.setIsActive(null); // no filter
    } else if (current == null) {
      notifier.setIsActive(true); // active only
    } else {
      notifier.setIsActive(false); // deactivated only
    }
  }

  IconData _activeFilterIcon(bool? isActive) {
    return switch (isActive) {
      null => Icons.check_box_outline_blank, // no filter
      false => Icons.indeterminate_check_box, // inactive only
      true => Icons.check_box, // active only
    };
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final managementState = ref.watch(userManagementProvider);

    return AdminScaffold(
      currentRoute: '/admin/users',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          _buildHeader(),
          const SizedBox(height: 24),

          // Filters row
          _buildFilters(),
          const SizedBox(height: 16),

          // Error banner if any
          if (managementState.hasError)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.error),
              ),
              child: Row(
                children: [
                  const ExcludeSemantics(
                    child: Icon(Icons.error_outline, color: AppTheme.error),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Error: ${managementState.error}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppTheme.error),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.tooltipClose,
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        ref.read(userManagementProvider.notifier).clearError(),
                  ),
                ],
              ),
            ),

          // Users table - wrapped in Expanded to fill available space
          SizedBox(
            height: 560,
            child: usersAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: AppLoadingIndicator(),
              ),
              error: (error, _) => Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.appColors.divider),
                ),
                child: AppEmptyState.error(
                  title: context.l10n.userManagementFailedToLoad,
                  subtitle: error.toString(),
                  action: AppFilledButton(
                    label: context.l10n.commonRetry,
                    onPressed: () => ref.invalidate(usersProvider),
                  ),
                ),
              ),
              data: (response) =>
                  _buildUsersTable(response.users, response.total),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  context.l10n.userManagementTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AppFilledButton(
                label: context.l10n.userManagementAddUser,
                onPressed: _showAddUserDialog,
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Semantics(
                header: true,
                child: Text(
                  context.l10n.userManagementTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AppFilledButton(
              label: context.l10n.userManagementAddUser,
              onPressed: _showAddUserDialog,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use vertical layout when sidebar + content area is narrow
          final isNarrow = constraints.maxWidth < 700;
          final l10n = context.l10n;
          final filters = ref.watch(userFiltersProvider);
          final metrics = appFormMetrics(context);
          final activeFilter = filters.isActive;

          if (isNarrow) {
            // Stack filters vertically on narrow screens
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  style: metrics.bodyStyle,
                  decoration: appInputDecoration(
                    context,
                    hintText: l10n.userManagementSearchShort,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 12),

                // Role filter dropdown
                DropdownButtonFormField<String?>(
                  initialValue: filters.role,
                  isExpanded: true,
                  style: metrics.bodyStyle,
                  dropdownColor: context.appColors.surface,
                  decoration: appInputDecoration(
                    context,
                    labelText: l10n.adminRoleLabel,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.userManagementAll),
                    ),
                    DropdownMenuItem(
                      value: 'participant',
                      child: Text(l10n.roleParticipant),
                    ),
                    DropdownMenuItem(
                      value: 'researcher',
                      child: Text(l10n.roleResearcher),
                    ),
                    DropdownMenuItem(value: 'hcp', child: Text(l10n.roleHcp)),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text(l10n.roleAdmin),
                    ),
                  ],
                  onChanged: _onRoleFilterChanged,
                ),
                const SizedBox(height: 12),

                // Active only checkbox
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InkWell(
                      onTap: _cycleActiveFilter,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          _activeFilterIcon(activeFilter),
                          color: activeFilter == null
                              ? context.appColors.textMuted
                              : AppTheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      l10n.userManagementActiveOnly,
                      style: metrics.bodyStyle,
                    ),
                  ],
                ),
              ],
            );
          }

          // Wide screen layout
          return Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  style: metrics.bodyStyle,
                  decoration: appInputDecoration(
                    context,
                    hintText: l10n.userManagementSearchByEmail,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 16),

              // Role filter dropdown
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: filters.role,
                  isExpanded: true,
                  style: metrics.bodyStyle,
                  dropdownColor: context.appColors.surface,
                  decoration: appInputDecoration(
                    context,
                    labelText: l10n.adminFilterByRoleLabel,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.userManagementAllRoles),
                    ),
                    DropdownMenuItem(
                      value: 'participant',
                      child: Text(l10n.roleParticipant),
                    ),
                    DropdownMenuItem(
                      value: 'researcher',
                      child: Text(l10n.roleResearcher),
                    ),
                    DropdownMenuItem(value: 'hcp', child: Text(l10n.roleHcp)),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text(l10n.roleAdmin),
                    ),
                  ],
                  onChanged: _onRoleFilterChanged,
                ),
              ),
              const SizedBox(width: 16),

              // Active only checkbox
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _cycleActiveFilter,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        _activeFilterIcon(activeFilter),
                        color: activeFilter == null
                            ? context.appColors.textMuted
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.userManagementActiveOnly, style: metrics.bodyStyle),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUsersTable(List<User> users, int total) {
    final l10n = context.l10n;
    final tableState = ref.watch(userTableProvider);
    final tableNotifier = ref.read(userTableProvider.notifier);
    final sortedUsers = _sortUsers(users, tableState);

    // Map UserSortColumn to column index for DataTable
    int? getSortColumnIndex() {
      switch (tableState.sortColumn) {
        case UserSortColumn.name:
          return 0;
        case UserSortColumn.email:
          return 1;
        case UserSortColumn.role:
          return 2;
        case UserSortColumn.status:
          return 3;
        case UserSortColumn.lastLogin:
          return 4;
      }
    }

    // Map column index back to UserSortColumn
    UserSortColumn? getColumnFromIndex(int index) {
      switch (index) {
        case 0:
          return UserSortColumn.name;
        case 1:
          return UserSortColumn.email;
        case 2:
          return UserSortColumn.role;
        case 3:
          return UserSortColumn.status;
        case 4:
          return UserSortColumn.lastLogin;
        default:
          return null; // Actions column not sortable
      }
    }

    return custom.DataTable(
      // Sorting
      sortColumnIndex: getSortColumnIndex(),
      sortAscending: tableState.sortAscending,
      sortableColumns: const [
        true,
        true,
        true,
        true,
        true,
        false,
      ], // Actions not sortable
      onSort: (columnIndex, ascending) {
        final column = getColumnFromIndex(columnIndex);
        if (column != null) {
          tableNotifier.onSort(column);
        }
      },
      // Sticky header for vertical scrolling
      stickyHeader: true,
      // Styling
      headingRowColor: AppTheme.primary,
      headingTextStyle: AppTheme.heading5,
      headingTextColor: AppTheme.textContrast,
      minColumnWidth: 120,
      emptyMessage: 'No users found',
      // Expandable rows
      expandedRowIndex: tableState.expandedRowIndex,
      onRowTap: (index) {
        tableNotifier.toggleExpandedRow(index);
      },
      expandedRowBuilder: (index) => _buildExpandedContent(sortedUsers[index]),
      // Footer
      footer: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.appColors.divider)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.userManagementUsersShown(sortedUsers.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
            Text(
              l10n.userManagementTotalUsers(total),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
          ],
        ),
      ),
      // Columns - use DataTableCell.custom with flex for expandable mode
      columns: [
        _buildTableHeaderCell(l10n.userManagementTableName, flex: 2),
        _buildTableHeaderCell(l10n.userManagementTableEmail, flex: 2),
        _buildTableHeaderCell(l10n.userManagementTableRole, flex: 1),
        _buildTableHeaderCell(l10n.userManagementTableStatus, flex: 1),
        _buildTableHeaderCell(l10n.userManagementTableLastLogin, flex: 1),
        _buildTableHeaderCell(l10n.userManagementTableActions, flex: 2),
      ],
      // Rows
      rows: sortedUsers.map((user) => _buildUserRow(user)).toList(),
    );
  }

  DataTableCell _buildTableHeaderCell(String label, {required int flex}) {
    return DataTableCell.custom(
      flex: flex,
      child: Text(
        label,
        style: AppTheme.heading5.copyWith(color: AppTheme.textContrast),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'admin':
        return AppTheme.error;
      case 'hcp':
        return AppTheme.caution;
      case 'researcher':
        return AppTheme.secondary;
      case 'participant':
      default:
        return AppTheme.info;
    }
  }

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'hcp':
        return 'HCP';
      case 'researcher':
        return 'Researcher';
      case 'participant':
        return 'Participant';
      default:
        return role ?? 'Unknown';
    }
  }

  Widget _buildUserRow(User user) {
    final roleColor = _getRoleColor(user.role);
    final fullName = '${user.firstName} ${user.lastName}';
    final initial = user.firstName.isNotEmpty ? user.firstName[0] : '?';

    // Return a Row - DataTable handles the container/decoration
    return Row(
      children: [
        // Name with avatar
        DataTableCell.avatar(
          text: fullName,
          initial: initial,
          color: roleColor,
          flex: 2,
        ),
        // Email
        DataTableCell.text(user.email, muted: true, flex: 2),
        // Role
        DataTableCell.badge(
          _getRoleDisplayName(user.role),
          color: roleColor,
          flex: 1,
        ),
        // Status
        DataTableCell.status(isActive: user.isActive, flex: 1),
        // Last Login
        DataTableCell.date(user.lastLogin, flex: 1),
        // Actions
        DataTableCell.actions(
          flex: 2,
          children: [
            // View as User button (System Admin only)
            _buildViewAsUserButton(user),
            IconButton(
              icon: const Icon(Icons.lock_reset, size: 20),
              onPressed: () => _showResetPasswordDialog(user),
              tooltip: context.l10n.userManagementResetPasswordTooltip,
              color: AppTheme.caution,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showEditUserDialog(user),
              tooltip: context.l10n.userManagementEditUserTooltip,
              color: AppTheme.primary,
            ),
            IconButton(
              icon: Icon(
                user.isActive
                    ? Icons.block_outlined
                    : Icons.check_circle_outline,
                size: 20,
              ),
              onPressed: () => _toggleUserStatus(user),
              tooltip: user.isActive
                  ? context.l10n.userManagementDeactivate
                  : context.l10n.userManagementActivate,
              color: user.isActive ? AppTheme.error : AppTheme.success,
            ),
            // Delete button — hidden for own account
            if (user.accountId != _currentAccountId)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => _confirmDeleteUser(user),
                tooltip: context.l10n.userManagementDeleteUserTooltip,
                color: AppTheme.error,
              ),
          ],
        ),
      ],
    );
  }

  /// Build the "View as User" button - only visible to system administrators
  Widget _buildViewAsUserButton(User user) {
    final isSystemAdmin = ref.watch(isSystemAdminProvider);
    final isLoading =
        ref.watch(userTableProvider).impersonatingUserId == user.accountId;

    // Only show for system admins (RoleID 4)
    if (!isSystemAdmin) {
      return const SizedBox.shrink();
    }

    // Don't allow impersonating yourself or inactive users
    final impersonationState = ref.watch(impersonationProvider);
    final currentUserId = impersonationState.currentUser?.accountId;
    final isSelf = currentUserId == user.accountId;

    // Don't allow viewing as admin users (no one can impersonate an admin)
    final isAdminUser = user.role == 'admin';

    if (isSelf || !user.isActive || isAdminUser) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: isLoading
          ? const AppLoadingIndicator.inline(size: 20, color: AppTheme.info)
          : const Icon(Icons.visibility, size: 20),
      onPressed: isLoading ? null : () => _handleViewAsUser(user),
      tooltip: context.l10n.userManagementViewAsUser,
      color: AppTheme.info,
    );
  }

  /// Handle the "View as User" action
  Future<void> _handleViewAsUser(User user) async {
    ref.read(userTableProvider.notifier).setImpersonating(user.accountId);

    try {
      final role = await ref
          .read(impersonationProvider.notifier)
          .startImpersonation(user.accountId);

      if (role != null && mounted) {
        // Redirect to the user's dashboard based on their role
        context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);

        AppToast.showSuccess(
          context,
          message: context.l10n.userManagementNowViewingAs(
            '${user.firstName} ${user.lastName}',
          ),
        );
      } else if (mounted) {
        // Show error
        final error = ref.read(impersonationProvider).error;
        AppToast.showError(
          context,
          message: error ?? context.l10n.userManagementFailedToImpersonate,
        );
      }
    } finally {
      if (mounted) {
        ref.read(userTableProvider.notifier).setImpersonating(null);
      }
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => _UserFormDialog(
        title: context.l10n.userManagementAddNewUser,
        showPassword: true,
        showSendEmail: true,
        showParticipantOptionals: true,
        onSave:
            (
              email,
              firstName,
              lastName,
              role, {
              String? password,
              bool sendSetupEmail = false,
              String? birthdate,
              String? gender,
            }) async {
              final result = await ref
                  .read(userManagementProvider.notifier)
                  .createUser(
                    UserCreate(
                      email: email,
                      firstName: firstName,
                      lastName: lastName,
                      password: sendSetupEmail ? null : password,
                      role: role,
                      sendSetupEmail: sendSetupEmail,
                      birthdate: birthdate,
                      gender: gender,
                    ),
                  );
              if (result != null && mounted) {
                AppToast.showSuccess(
                  this.context,
                  message: this.context.l10n.userManagementCreatedSuccess,
                );
              }
            },
      ),
    );
  }

  void _showEditUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => _UserFormDialog(
        title: context.l10n.userManagementEditUserTitle,
        initialEmail: user.email,
        initialFirstName: user.firstName,
        initialLastName: user.lastName,
        initialRole: user.role != null
            ? UserRole.values.firstWhere(
                (r) => r.name == user.role,
                orElse: () => UserRole.participant,
              )
            : null,
        onSave:
            (
              email,
              firstName,
              lastName,
              role, {
              String? password,
              bool sendSetupEmail = false,
              String? birthdate,
              String? gender,
            }) async {
              final l10n = context.l10n;
              final api = ref.read(userApiProvider);
              await api.updateUser(
                user.accountId,
                UserUpdate(
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  role: role,
                ),
              );
              ref.invalidate(usersProvider);
              if (mounted) {
                AppToast.showSuccess(
                  this.context,
                  message: l10n.accountEditSuccess,
                );
              }
            },
      ),
    );
  }

  void _toggleUserStatus(User user) async {
    final result = await ref
        .read(userManagementProvider.notifier)
        .toggleUserStatus(user.accountId, !user.isActive);

    if (result != null && mounted) {
      AppToast.showSuccess(
        context,
        message: user.isActive
            ? context.l10n.userManagementDeactivatedSuccess
            : context.l10n.userManagementActivatedSuccess,
      );
    }
  }

  void _showResetPasswordDialog(User user) {
    showResetPasswordModal(context, user);
  }

  Widget _buildExpandedContent(User user) {
    final l10n = context.l10n;
    final hasSigned = user.consentSignedAt != null;
    final isAdmin = user.role == 'admin';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.02),
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Consent status section
          Row(
            children: [
              Icon(
                isAdmin
                    ? Icons.admin_panel_settings
                    : hasSigned
                    ? Icons.check_circle
                    : Icons.cancel,
                color: isAdmin
                    ? context.appColors.textMuted
                    : hasSigned
                    ? AppTheme.success
                    : AppTheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isAdmin
                    ? l10n.userManagementAdminConsentExempt
                    : hasSigned
                    ? l10n.consentStatusSigned
                    : l10n.consentStatusNotSigned,
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isAdmin
                      ? context.appColors.textMuted
                      : hasSigned
                      ? AppTheme.success
                      : AppTheme.error,
                ),
              ),
              if (hasSigned && user.consentVersion != null) ...[
                const SizedBox(width: 16),
                Text(
                  l10n.consentStatusVersion(user.consentVersion!),
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
          if (hasSigned) ...[
            const SizedBox(height: 12),
            AppFilledButton(
              label: l10n.consentViewRecord,
              onPressed: () => _showConsentRecordDialog(user),
            ),
          ],
        ],
      ),
    );
  }

  void _showConsentRecordDialog(User user) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (ctx) => _ConsentRecordDialog(user: user, l10n: l10n),
    );
  }

  Future<void> _confirmDeleteUser(User user) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.userManagementDeleteUserTitle,
      content:
          'Are you sure you want to permanently delete ${user.fullName} (${user.email})?\n\n'
          'This will remove all their data including sessions, responses, and survey assignments. '
          'This action cannot be undone.',
      confirmLabel: 'Delete',
      isDangerous: true,
    );

    if (!confirmed || !mounted) return;

    final success = await ref
        .read(userManagementProvider.notifier)
        .deleteUser(user.accountId);
    if (success && mounted) {
      AppToast.showSuccess(
        context,
        message: context.l10n.userManagementUserDeleted(user.fullName),
      );
    }
  }
}

/// Dialog for adding/editing users
class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({
    required this.title,
    required this.onSave,
    this.initialEmail,
    this.initialFirstName,
    this.initialLastName,
    this.initialRole,
    this.showPassword = false,
    this.showSendEmail = false,
    this.showParticipantOptionals = false,
  });

  final String title;
  final Future<void> Function(
    String email,
    String firstName,
    String lastName,
    UserRole? role, {
    String? password,
    bool sendSetupEmail,
    String? birthdate,
    String? gender,
  })
  onSave;
  final String? initialEmail;
  final String? initialFirstName;
  final String? initialLastName;
  final UserRole? initialRole;
  final bool showPassword;
  final bool showSendEmail;
  final bool showParticipantOptionals;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _passwordController;
  UserRole? _selectedRole;
  bool _isSaving = false;
  bool _obscurePassword = false;
  bool _sendEmail = true;
  String? _errorMessage;
  String? _emailError;
  String? _nameError;
  DateTime? _selectedDob;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _passwordController = TextEditingController();
    if (widget.showPassword) {
      _passwordController.text = _generatePassword();
    }
    _selectedRole = widget.initialRole ?? UserRole.participant;
  }

  String _generatePassword() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
    final random = Random.secure();
    return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _selectedDob = picked);
    }
  }

  String _formatDob(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 440 ? screenWidth * 0.9 : 400.0;
    final l10n = context.l10n;

    return AlertDialog(
      title: Semantics(
        header: true,
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // API-level error message
              if (_errorMessage != null) ...[
                AppAnnouncement(
                  message: _errorMessage!,
                  icon: const Icon(
                    Icons.error_outline,
                    color: AppTheme.error,
                    size: 16,
                  ),
                  backgroundColor: AppTheme.error.withValues(alpha: 0.1),
                  textColor: AppTheme.error,
                  borderColor: AppTheme.error.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.adminEmailLabel,
                  border: const OutlineInputBorder(),
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isSaving,
                onChanged: (_) => setState(() {
                  _emailError = null;
                  _errorMessage = null;
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: l10n.adminFirstNameLabel,
                  border: const OutlineInputBorder(),
                  errorText: _nameError,
                ),
                enabled: !_isSaving,
                onChanged: (_) => setState(() {
                  _nameError = null;
                  _errorMessage = null;
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: l10n.adminLastNameLabel,
                  border: const OutlineInputBorder(),
                ),
                enabled: !_isSaving,
                onChanged: (_) => setState(() {
                  _nameError = null;
                  _errorMessage = null;
                }),
              ),
              const SizedBox(height: 16),
              if (widget.showPassword && !_sendEmail) ...[
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.adminPasswordLabel,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      tooltip: _obscurePassword
                          ? context.l10n.commonShowPassword
                          : context.l10n.commonHidePassword,
                    ),
                  ),
                  obscureText: _obscurePassword,
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () => setState(() {
                              _passwordController.text = _generatePassword();
                            }),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(context.l10n.userManagementGenerate),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () {
                              Clipboard.setData(
                                ClipboardData(text: _passwordController.text),
                              );
                              if (context.mounted) {
                                AppToast.showSuccess(
                                  context,
                                  message:
                                      context.l10n.userManagementPasswordCopied,
                                );
                              }
                            },
                      icon: const Icon(Icons.copy, size: 18),
                      label: Text(context.l10n.userManagementCopy),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<UserRole>(
                initialValue: _selectedRole,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.adminRoleLabel,
                  border: const OutlineInputBorder(),
                ),
                items: UserRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.displayName),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedRole = value);
                        }
                      },
              ),
              if (widget.showSendEmail) ...[
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _sendEmail,
                  onChanged: _isSaving
                      ? null
                      : (value) => setState(() => _sendEmail = value ?? true),
                  title: Text(l10n.adminAddUserSendSetupEmail),
                  subtitle: Text(
                    l10n.adminAddUserSendSetupEmailHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
              // DOB + Gender — shown only when adding a participant
              if (widget.showParticipantOptionals &&
                  _selectedRole == UserRole.participant) ...[
                const SizedBox(height: 16),
                Divider(color: context.appColors.divider),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.adminAddUserParticipantOptionals,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // DOB picker
                InkWell(
                  onTap: _isSaving ? null : _pickBirthdate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.adminAddUserDateOfBirth,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    ),
                    child: Text(
                      _selectedDob != null ? _formatDob(_selectedDob!) : '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _selectedDob != null
                            ? context.appColors.textPrimary
                            : context.appColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Gender dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.adminAddUserGender,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text(l10n.profileCompletionGenderMale),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text(l10n.profileCompletionGenderFemale),
                    ),
                    DropdownMenuItem(
                      value: 'Non-Binary',
                      child: Text(l10n.profileCompletionGenderNonBinary),
                    ),
                    DropdownMenuItem(
                      value: 'Prefer Not to Say',
                      child: Text(l10n.profileCompletionGenderPreferNotToSay),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text(l10n.profileCompletionGenderOther),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() => _selectedGender = v),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppTextButton(
          label: context.l10n.commonCancel,
          onPressed: _isSaving ? null : () => Navigator.pop(context),
        ),
        AppFilledButton(
          label: _isSaving
              ? context.l10n.commonSaving
              : context.l10n.commonSave,
          onPressed: _isSaving
              ? null
              : () async {
                  // Validate fields
                  final emailVal = _emailController.text.trim();
                  final firstVal = _firstNameController.text.trim();
                  final lastVal = _lastNameController.text.trim();

                  String? emailErr;
                  String? nameErr;
                  if (emailVal.isEmpty ||
                      !RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(emailVal)) {
                    emailErr = l10n.accountEditValidationEmail;
                  }
                  if (firstVal.isEmpty || lastVal.isEmpty) {
                    nameErr = l10n.accountEditValidationName;
                  }
                  if (emailErr != null || nameErr != null) {
                    setState(() {
                      _emailError = emailErr;
                      _nameError = nameErr;
                    });
                    return;
                  }

                  setState(() {
                    _isSaving = true;
                    _errorMessage = null;
                    _emailError = null;
                    _nameError = null;
                  });
                  final navigator = Navigator.of(context);
                  try {
                    await widget.onSave(
                      emailVal,
                      firstVal,
                      lastVal,
                      _selectedRole,
                      password: (widget.showPassword && !_sendEmail)
                          ? _passwordController.text
                          : null,
                      sendSetupEmail: _sendEmail,
                      birthdate:
                          (_selectedDob != null &&
                              _selectedRole == UserRole.participant)
                          ? _formatDob(_selectedDob!)
                          : null,
                      gender:
                          (_selectedGender != null &&
                              _selectedRole == UserRole.participant)
                          ? _selectedGender
                          : null,
                    );
                    if (mounted) navigator.pop();
                  } on DioException catch (e) {
                    if (!mounted) return;
                    final code = e.response?.statusCode;
                    String msg;
                    if (code == 404) {
                      msg = l10n.accountEditError404;
                    } else if (code == 409) {
                      msg = l10n.accountEditError409;
                    } else if (code == 422) {
                      msg = l10n.accountEditError422;
                    } else if (code != null && code >= 500) {
                      msg = l10n.accountEditErrorServer;
                    } else {
                      msg = l10n.accountEditErrorNetwork;
                    }
                    setState(() {
                      _isSaving = false;
                      _errorMessage = msg;
                    });
                  } catch (_) {
                    if (!mounted) return;
                    setState(() {
                      _isSaving = false;
                      _errorMessage = context.l10n.accountEditErrorNetwork;
                    });
                  }
                },
        ),
      ],
    );
  }
}

/// Dialog showing the full consent record details for a user
class _ConsentRecordDialog extends ConsumerWidget {
  const _ConsentRecordDialog({required this.user, required this.l10n});

  final User user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(userConsentProvider(user.accountId));
    final scrollController = ScrollController();

    return AlertDialog(
      title: Semantics(
        header: true,
        child: Text(
          l10n.consentRecordTitle,
          style: AppTheme.heading4.copyWith(color: AppTheme.primary),
        ),
      ),
      content: SizedBox(
        width: 600,
        child: consentAsync.when(
          loading: () =>
              const SizedBox(height: 200, child: AppLoadingIndicator()),
          error: (error, _) => Text(
            'Failed to load consent record: $error',
            style: AppTheme.body.copyWith(color: AppTheme.error),
          ),
          data: (record) {
            if (record == null) {
              return Text(
                l10n.consentStatusNotSigned,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Metadata grid
                  if (record.signatureName != null)
                    _buildDetailRow(
                      context,
                      l10n.consentRecordSignatureName,
                      record.signatureName!,
                    ),
                  _buildDetailRow(
                    context,
                    l10n.consentRecordSignedAt,
                    record.signedAt,
                  ),
                  _buildDetailRow(
                    context,
                    l10n.consentRecordDocumentLanguage,
                    record.documentLanguage.toUpperCase(),
                  ),
                  _buildDetailRow(
                    context,
                    l10n.consentStatusVersion(''),
                    record.consentVersion,
                  ),
                  if (record.ipAddress != null)
                    _buildDetailRow(
                      context,
                      l10n.consentRecordIpAddress,
                      record.ipAddress!,
                    ),
                  if (record.userAgent != null)
                    _buildDetailRow(
                      context,
                      l10n.consentRecordUserAgent,
                      record.userAgent!,
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Document text
                  Text(
                    'Document Text',
                    style: AppTheme.heading5.copyWith(
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.appColors.divider.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: context.appColors.divider),
                    ),
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(
                          record.documentText,
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        AppTextButton(
          label: context.l10n.commonClose,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
