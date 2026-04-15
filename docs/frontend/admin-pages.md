# Admin Pages

Documentation for admin dashboard pages.

## User Management Page

Page for managing system users.

### Location

`frontend/lib/src/features/admin/pages/user_management_page.dart`

### Features

1. **User List** - Sortable table of all users
2. **Search** - Filter by name or email
3. **Role Filter** - Filter by role (participant, researcher, hcp, admin)
4. **Active Filter** - Show only active users
5. **User Actions** - Per-row action buttons

### Action Buttons

The user table includes these action buttons per row:

| Icon | Action | Visibility | Description |
|------|--------|------------|-------------|
| `visibility` | View as User | System Admin only | Start impersonation session |
| `lock_reset` | Reset Password | All admins | Open password reset modal |
| `edit_outlined` | Edit User | All admins | Open user edit dialog |
| `block`/`check_circle` | Toggle Status | All admins | Activate/deactivate user |

### View as User (Impersonation)

The "View as User" button allows system administrators to impersonate any user.

**Visibility Rules:**
- Only visible to system administrators (RoleID = 4)
- Hidden for the current user (can't impersonate yourself)
- Hidden for inactive users

**Behavior:**
1. Click the eye icon button
2. Loading spinner appears on that button
3. API call to `/admin/users/{id}/impersonate`
4. On success:
   - New session token is stored
   - Redirects to user's dashboard based on role
   - Success snackbar shown
   - Impersonation banner appears on all pages
5. On failure:
   - Error snackbar with message

**Role-based Redirect:**
| Role | Dashboard Route |
|------|-----------------|
| participant | `/participant/dashboard` |
| researcher | `/surveys` |
| hcp | `/hcp/dashboard` |
| admin | `/admin` |

### Code Example

```dart
// The view as user button is built conditionally
Widget _buildViewAsUserButton(User user) {
  final isSystemAdmin = ref.watch(isSystemAdminProvider);

  if (!isSystemAdmin) {
    return const SizedBox.shrink(); // Hidden
  }

  return IconButton(
    icon: const Icon(Icons.visibility, size: 20),
    onPressed: () => _handleViewAsUser(user),
    tooltip: 'View as User',
    color: AppTheme.info,
  );
}
```

### Integration

The page uses these providers:

- `usersProvider` - Fetches user list from API
- `userFiltersProvider` - Manages search/filter state
- `userManagementProvider` - Handles CRUD operations
- `isSystemAdminProvider` - Checks if current user is system admin
- `impersonationProvider` - Manages impersonation state

### Sorting

The table supports sorting by clicking column headers:

| Column | Sort Key |
|--------|----------|
| Name | First + Last name |
| Email | Email address |
| Role | Role name |
| Status | Active/Inactive |
| Last Login | Login timestamp |

Click a column header to sort ascending, click again to sort descending.

## Database Viewer Page

Page for viewing database tables (admin debugging tool).

### Location

`frontend/lib/src/features/admin/pages/database_viewer_page.dart`

### Features

- Table selector dropdown
- Schema view with column info
- Data view with pagination
- Sensitive columns excluded (passwords, tokens)

## Health Tracking Settings Page

Admin page for managing the health tracking metric catalogue.

### Location

`frontend/lib/src/features/admin/pages/admin_health_tracking_settings_page.dart`

### Route

`/admin/health-tracking`

### Features

1. **Category list** — shows all categories with expand/collapse to reveal their metrics
2. **Drag-and-drop reorder** — categories and metrics can be reordered by dragging; order is persisted to the server on drop
3. **Toggle active/inactive** — categories and metrics can be toggled; inactive items are hidden from participants but preserved
4. **Soft delete & restore** — deleted items move to a "Removed" section and can be restored; existing participant entries are never lost
5. **Add / edit dialogs** — full CRUD dialogs for categories (key, name, description, icon) and metrics (all fields including type, scale range, choice options, frequency)

### State Management

Providers are in `frontend/lib/src/features/admin/state/health_tracking_admin_providers.dart`.

| Provider | Type | Description |
|----------|------|-------------|
| `adminCategoriesProvider` | `FutureProvider<List<TrackingCategory>>` | All categories including inactive/deleted |
| `adminMetricsProvider` | `FutureProvider<List<TrackingMetric>>` | All metrics |
| `adminHtActionProvider` | `StateNotifierProvider` | Handles create/update/delete/reorder mutations |

The page maintains local ordered lists (`_localCategories`, `_localMetrics`) that are updated optimistically for toggles and deletes. A `_pendingRefresh` flag triggers a re-sync from providers after create/edit operations that require a server round-trip to get the new item's ID.

---

## Database Backup & Restore Page

Admin page for managing database backups.

### Location

`frontend/lib/src/features/admin/pages/database_viewer_page.dart` (Backup panel is a tab within this page)

### Route

`/admin/database`

### Features

1. **Backup list** — shows all backup files grouped by type (manual, daily, weekly, monthly) with size and date
2. **Manual backup** — "Create Backup" button calls `POST /admin/backups/trigger`; shows progress indicator
3. **Download** — each backup row has a download button that navigates to the download URL
4. **Delete** — manual backups can be deleted; scheduled backups cannot
5. **Restore** — confirm dialog explains the 4-step restore process (pre-restore backup → restore → migrations); shows `RestoreResult` on completion

---

## Admin Settings Page

System-wide configuration page.

### Location

`frontend/lib/src/features/admin/pages/admin_settings_page.dart`

### Route

`/admin/settings`

### Features

1. **K-Anonymity Threshold** — slider/input for minimum participants per research data point
2. **Registration** — toggle to open/close new participant sign-ups
3. **Maintenance Mode** — toggle + message text field + estimated completion text field; toggling on shows the maintenance banner on every page for all users
4. **Login Security** — max login attempts (0 = unlimited) and lockout duration in minutes
5. **Consent Required** — toggle for whether participants must accept the consent form

All fields show their seeded default value as placeholder text (from `SystemSettingsResponse.defaults`). A "Reset to Default" button per field restores the seeded value without saving. Save calls `PUT /admin/settings` atomically.

---

## Other Admin Pages

| Page | Route | Description |
|------|-------|-------------|
| Dashboard | `/admin` | Admin dashboard overview |
| Users | `/admin/users` | User management |
| Health Tracking | `/admin/health-tracking` | Metric catalogue management |
| Database | `/admin/database` | Database viewer + backup/restore |
| Settings | `/admin/settings` | System-wide configuration |
| Tickets | `/admin/tickets` | Support ticket management |
| Messages | `/admin/messages` | System messages |
| Audit Log | `/admin/logs` | System audit log |
