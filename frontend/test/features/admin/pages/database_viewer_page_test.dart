import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/pages/database_viewer_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show accountRequestCountProvider, deletionRequestCountProvider;
import 'package:frontend/src/features/admin/state/database_providers.dart';

import '../../../test_helpers.dart';

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

  @override
  Future<SystemSettings> getSettings() => throw UnimplementedError();

  @override
  Future<SystemSettings> updateSettings(Map<String, dynamic> body) =>
      throw UnimplementedError();
}

class _TestDatabaseViewerNotifier extends DatabaseViewerNotifier {
  _TestDatabaseViewerNotifier([DatabaseViewerState? initial]) : super() {
    if (initial != null) {
      state = initial;
    }
  }

  int nextCalls = 0;
  int previousCalls = 0;
  final List<String> selectedTables = [];

  @override
  void nextPage() {
    nextCalls++;
    super.nextPage();
  }

  @override
  void previousPage() {
    previousCalls++;
    super.previousPage();
  }

  @override
  void selectTable(String tableName) {
    selectedTables.add(tableName);
    super.selectTable(tableName);
  }
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1800, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

TableSchema _usersTable() {
  return const TableSchema(
    name: 'users',
    description: 'User accounts',
    columns: [
      ColumnInfo(name: 'id', type: 'int', isPrimaryKey: true, isNullable: false),
      ColumnInfo(
        name: 'role_id',
        type: 'int',
        isForeignKey: true,
        isNullable: false,
        foreignKeyRef: 'roles.id',
      ),
      ColumnInfo(name: 'email', type: 'varchar(255)', isNullable: false),
    ],
    rowCount: 5,
  );
}

TableDetailResponse _tableDetail({required List<Map<String, dynamic>> rows}) {
  return TableDetailResponse(
    schemaInfo: _usersTable(),
    data: TableData(
      name: 'users',
      columns: const ['id', 'email'],
      rows: rows,
      total: 5,
    ),
  );
}

Widget _buildPage({
  required List<TableSchema> tables,
  DatabaseViewerState? viewerState,
  Future<List<TableSchema>> Function()? tablesFuture,
  Future<TableDetailResponse> Function(TableDetailParams params)? detailFuture,
  _TestDatabaseViewerNotifier? notifier,
}) {
  final effectiveNotifier = notifier ?? _TestDatabaseViewerNotifier(viewerState);

  return buildTestPage(
    const DatabaseViewerPage(),
    overrides: [
      accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      adminApiProvider.overrideWithValue(_FakeAdminApi()),
      databaseViewerProvider.overrideWith((ref) => effectiveNotifier),
      databaseTablesProvider.overrideWith(
        (ref) => tablesFuture != null ? tablesFuture() : Future.value(tables),
      ),
      tableDetailProvider.overrideWith((ref, params) async {
        if (detailFuture != null) {
          return detailFuture(params);
        }
        return _tableDetail(rows: const [
          {'id': 1, 'email': 'a@example.com'},
          {'id': 2, 'email': 'b@example.com'},
        ]);
      }),
    ],
  );
}

void main() {
  group('DatabaseViewerPage', () {
    testWidgets('shows loading state while tables are loading', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final completer = Completer<List<TableSchema>>();
      await tester.pumpWidget(
        _buildPage(
          tables: const [],
          tablesFuture: () => completer.future,
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when table fetch fails', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          tables: const [],
          tablesFuture: () => Future<List<TableSchema>>.error(
            Exception('tables failed'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load database tables'), findsOneWidget);
      expect(find.textContaining('tables failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('auto-selects first table and renders schema view', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final notifier = _TestDatabaseViewerNotifier(
        const DatabaseViewerState(selectedTable: null, showSchema: true),
      );

      await tester.pumpWidget(
        _buildPage(
          tables: [_usersTable()],
          notifier: notifier,
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(notifier.selectedTables, contains('users'));
      expect(find.text('Database Viewer'), findsOneWidget);
      expect(find.text('1 tables in database'), findsOneWidget);
      expect(find.text('users'), findsWidgets);
      expect(find.text('User accounts'), findsOneWidget);
      expect(find.text('3 columns'), findsOneWidget);
      expect(find.text('PK'), findsOneWidget);
      expect(find.text('FK'), findsOneWidget);
      expect(find.text('NN'), findsWidgets);
      expect(find.text('roles.id'), findsOneWidget);
      expect(find.text('Primary Key'), findsOneWidget);
      expect(find.text('Foreign Key'), findsOneWidget);
    });

    testWidgets('shows data-empty state when selected table has no rows',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          tables: [_usersTable()],
          viewerState: const DatabaseViewerState(
            selectedTable: 'users',
            showSchema: false,
          ),
          detailFuture: (params) async => _tableDetail(rows: const []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No data in table'), findsOneWidget);
    });

    testWidgets('shows data error state when detail fetch fails', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          tables: [_usersTable()],
          viewerState: const DatabaseViewerState(
            selectedTable: 'users',
            showSchema: false,
          ),
          detailFuture: (params) =>
              Future<TableDetailResponse>.error(Exception('detail failed')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load table data'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('renders data table and pagination details', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          tables: [_usersTable()],
          viewerState: const DatabaseViewerState(
            selectedTable: 'users',
            showSchema: false,
          ),
          detailFuture: (params) async => _tableDetail(rows: const [
            {'id': 1, 'email': 'a@example.com'},
            {'id': 2, 'email': 'b@example.com'},
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('users Data'), findsOneWidget);
      expect(find.text('5 rows total'), findsOneWidget);
      expect(find.text('Showing 1-2 of 5'), findsOneWidget);
      expect(find.text('Page 1 of 1'), findsOneWidget);
      expect(find.text('a@example.com'), findsOneWidget);
      expect(find.text('b@example.com'), findsOneWidget);
    });

    testWidgets('calls previous and next pagination actions when enabled',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final notifier = _TestDatabaseViewerNotifier(
        const DatabaseViewerState(
          selectedTable: 'users',
          currentPage: 1,
          pageSize: 2,
          showSchema: false,
        ),
      );

      await tester.pumpWidget(
        _buildPage(
          tables: [_usersTable()],
          notifier: notifier,
          detailFuture: (params) async => TableDetailResponse(
            schemaInfo: _usersTable(),
            data: const TableData(
              name: 'users',
              columns: ['id', 'email'],
              rows: [
                {'id': 3, 'email': 'c@example.com'},
                {'id': 4, 'email': 'd@example.com'},
              ],
              total: 5,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Showing 3-4 of 5'), findsOneWidget);
      expect(find.text('Page 2 of 3'), findsOneWidget);

      final prevButton = find.byIcon(Icons.chevron_left);
      await tester.ensureVisible(prevButton);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      final nextButton = find.byIcon(Icons.chevron_right);
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(notifier.previousCalls, greaterThan(0));
      expect(notifier.nextCalls, greaterThan(0));
    });
  });
}
