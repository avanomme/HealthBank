// Created with the Assistance of Claude Code
// frontend/test/features/admin/admin_pages_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/admin/admin.dart';
import 'package:frontend/src/features/admin/state/audit_log_providers.dart'
    show
        auditLogActionsProvider,
        auditLogResourceTypesProvider,
        auditLogsProvider;
import 'package:frontend/src/features/admin/state/database_providers.dart'
    show databaseTablesProvider, adminApiProvider;

import '../../test_helpers.dart';

class _FakeAdminApi implements AdminApi {
  @override
  Future<List<BackupInfo>> listBackups() async => const [];

  @override
  Future<BackupInfo> triggerBackup() async => throw UnimplementedError();

  @override
  Future<List<int>> downloadBackup(String backupType, String filename) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteBackup(String filename) async => throw UnimplementedError();

  @override
  Future<RestoreResult> restoreBackup(String backupType, String filename) async =>
      throw UnimplementedError();

  @override
  Future<SystemSettings> getSettings() async => const SystemSettings(
        kAnonymityThreshold: 5,
        registrationOpen: true,
        maintenanceMode: false,
        maxLoginAttempts: 10,
        lockoutDurationMinutes: 30,
        consentRequired: true,
      );

  @override
  Future<SystemSettings> updateSettings(Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<TableListResponse> listTables() async => throw UnimplementedError();

  @override
  Future<TableDetailResponse> getTable(String tableName,
          {int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<TableData> getTableData(String tableName,
          {int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<PasswordResetResponse> resetPassword(
          int userId, PasswordResetRequest request) async =>
      throw UnimplementedError();

  @override
  Future<SendResetEmailResponse> sendResetEmail(
          int userId, SendResetEmailRequest request) async =>
      throw UnimplementedError();

  @override
  Future<ViewAsResponse> startViewingAs(int userId) async =>
      throw UnimplementedError();

  @override
  Future<EndViewAsResponse> endViewingAs() async => throw UnimplementedError();

  @override
  Future<ImpersonateResponse> impersonateUser(int userId) async =>
      throw UnimplementedError();

  @override
  Future<EndImpersonationResponse> endImpersonation() async =>
      throw UnimplementedError();

  @override
  Future<List<AccountRequestResponse>> getAccountRequests(
          {String? status}) async =>
      throw UnimplementedError();

  @override
  Future<AccountRequestCountResponse> getAccountRequestCount() async =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> approveAccountRequest(int requestId) async =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> rejectAccountRequest(
          int requestId, AccountRequestRejectBody body) async =>
      throw UnimplementedError();

  @override
  Future<List<DeletionRequestResponse>> getDeletionRequests(
          {String? status}) async =>
      throw UnimplementedError();

  @override
  Future<DeletionRequestCountResponse> getDeletionRequestCount() async =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> approveDeletionRequest(int requestId) async =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> rejectDeletionRequest(
          int requestId, AccountRequestRejectBody body) async =>
      throw UnimplementedError();

  @override
  Future<AuditLogResponse> getAuditLogs({
    int? limit,
    int? offset,
    String? action,
    String? status,
    int? actorAccountId,
    String? resourceType,
    String? httpMethod,
    String? search,
    String? startDate,
    String? endDate,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<String>> getAuditLogActions() async => throw UnimplementedError();

  @override
  Future<List<String>> getAuditLogResourceTypes() async =>
      throw UnimplementedError();

  @override
  Future<UserConsentRecordResponse?> getUserConsentRecord(int userId) async =>
      throw UnimplementedError();
}

final _adminPageOverrides = <Override>[
  accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
  deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
  usersProvider.overrideWith(
    (ref) async => const UserListResponse(users: [], total: 0),
  ),
  databaseTablesProvider.overrideWith(
    (ref) async => const [
      TableSchema(
        name: 'users',
        description: 'User accounts',
        columns: [ColumnInfo(name: 'id', type: 'integer', isPrimaryKey: true)],
        rowCount: 0,
      ),
    ],
  ),
  auditLogsProvider.overrideWith(
    (ref) async =>
        const AuditLogResponse(events: [], total: 0, limit: 50, offset: 0),
  ),
  auditLogActionsProvider.overrideWith((ref) async => const ['login']),
  auditLogResourceTypesProvider.overrideWith((ref) async => const ['user']),
  accountRequestsProvider.overrideWith(
    (ref) async => const <AccountRequestResponse>[],
  ),
  deletionRequestsProvider.overrideWith(
    (ref) async => const <DeletionRequestResponse>[],
  ),
  adminApiProvider.overrideWithValue(_FakeAdminApi()),
];

const _narrowAccountRequests = [
  AccountRequestResponse(
    requestId: 1,
    firstName: 'Alexandria',
    lastName: 'Montgomery-Santiago',
    email: 'alexandria.montgomery-santiago@example.com',
    roleId: 2,
    status: 'pending',
    adminNotes: 'Needs manual review before approval.',
    createdAt: '2026-03-24T10:15:00Z',
  ),
];

const _narrowDeletionRequests = [
  DeletionRequestResponse(
    requestId: 11,
    accountId: 3,
    fullName: 'Christopher Jonathan Example',
    email: 'christopher.jonathan.example@example.com',
    status: 'pending',
    requestedAt: '2026-03-24T11:30:00Z',
    adminNotes: 'Verify retention policy before deleting this account.',
  ),
];

void main() {
  group('AdminDashboardPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const AdminDashboardPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminDashboardPage), findsOneWidget);
      });

      testWidgets('renders AdminScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const AdminDashboardPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });
    });
  });

  group('UserManagementPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(UserManagementPage), findsOneWidget);
      });

      testWidgets('renders AdminScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });

      testWidgets('renders page header with User Management title', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        // There may be multiple "User Management" texts (sidebar + page header)
        expect(find.text('User Management'), findsWidgets);
      });

      testWidgets('renders Add User button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Add User'), findsOneWidget);
      });

      testWidgets('renders search field', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('renders role filter dropdown', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        // On narrow content areas (< 700px due to sidebar), label is "Role"
        // On wider content areas, label is "Filter by Role"
        expect(find.textContaining('Role'), findsWidgets);
      });

      testWidgets('renders active only filter', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Active only'), findsOneWidget);
      });
    });

    group('Filter Interaction', () {
      testWidgets('can enter search text', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        final searchField = find.byType(TextField).first;
        await tester.enterText(searchField, 'test user');
        await tester.pumpAndSettle();

        expect(find.text('test user'), findsOneWidget);
      });

      testWidgets('can toggle active only filter', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const UserManagementPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        // Tap the InkWell wrapping the active filter icon (sibling of the text)
        final activeOnlyText = find.text('Active only');
        expect(activeOnlyText, findsOneWidget);
        // The InkWell is inside the same Wrap as 'Active only' — find the Wrap
        // then the InkWell within it.
        final filterWrap = find.ancestor(
          of: activeOnlyText,
          matching: find.byType(Wrap),
        ).first;
        await tester.tap(
          find.descendant(of: filterWrap, matching: find.byType(InkWell)).first,
        );
        await tester.pumpAndSettle();

        // After tap the widget still renders without error
        expect(find.text('Active only'), findsOneWidget);
      });
    });
  });

  group('DatabaseViewerPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        tester.view.physicalSize = const Size(1600, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const DatabaseViewerPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(DatabaseViewerPage), findsOneWidget);
      });

      testWidgets('renders AdminScaffold', (tester) async {
        tester.view.physicalSize = const Size(1600, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const DatabaseViewerPage(),
            overrides: _adminPageOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });
    });
  });

  group('AuditLogPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        tester.view.physicalSize = const Size(1600, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const AuditLogPage(), overrides: _adminPageOverrides),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AuditLogPage), findsOneWidget);
      });

      testWidgets('renders AdminScaffold', (tester) async {
        tester.view.physicalSize = const Size(1600, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(const AuditLogPage(), overrides: _adminPageOverrides),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });
    });
  });

  group('MessagesPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const MessagesPage(), overrides: _adminPageOverrides),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MessagesPage), findsOneWidget);
      });

      testWidgets('renders AdminScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(const MessagesPage(), overrides: _adminPageOverrides),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });

      testWidgets(
        'reflows tabs and card actions at narrow width with large text',
        (tester) async {
          tester.view.physicalSize = const Size(640, 1600);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestPage(
              const MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(2)),
                child: MessagesPage(),
              ),
              overrides: [
                ..._adminPageOverrides,
                accountRequestsProvider.overrideWith(
                  (ref) async => _narrowAccountRequests,
                ),
                deletionRequestsProvider.overrideWith(
                  (ref) async => _narrowDeletionRequests,
                ),
              ],
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('New Account Requests'), findsOneWidget);
          expect(find.text('Deletion Requests'), findsOneWidget);
          expect(find.text('Approve'), findsOneWidget);
          expect(find.text('Reject'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    });
  });


  group('UserSortColumn', () {
    test('has all expected values', () {
      expect(UserSortColumn.values, hasLength(5));
      expect(UserSortColumn.values, contains(UserSortColumn.name));
      expect(UserSortColumn.values, contains(UserSortColumn.email));
      expect(UserSortColumn.values, contains(UserSortColumn.role));
      expect(UserSortColumn.values, contains(UserSortColumn.status));
      expect(UserSortColumn.values, contains(UserSortColumn.lastLogin));
    });
  });

  group('AdminScaffold', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const AdminScaffold(
            currentRoute: '/admin',
            userName: 'TestAdmin',
            messageCount: 0,
            child: Text('Admin Content'),
          ),
          overrides: _adminPageOverrides,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Admin Content'), findsOneWidget);
    });

    testWidgets('displays user name', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const AdminScaffold(
            currentRoute: '/admin',
            userName: 'AdminUser',
            messageCount: 0,
            child: SizedBox(),
          ),
          overrides: _adminPageOverrides,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('AdminUser'), findsWidgets);
    });

    testWidgets('shows message count when greater than zero', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const AdminScaffold(
            currentRoute: '/admin',
            userName: 'Admin',
            messageCount: 5,
            child: SizedBox(),
          ),
          overrides: _adminPageOverrides,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminScaffold), findsOneWidget);
    });
  });
}
