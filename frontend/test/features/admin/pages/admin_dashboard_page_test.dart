import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/pages/admin_dashboard_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';

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
  Future<void> deleteBackup(String filename) async =>
      throw UnimplementedError();

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
  Future<List<String>> getAuditLogActions() async =>
      throw UnimplementedError();

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

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1800, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

class _FakeImpersonationNotifier extends ImpersonationNotifier {
  _FakeImpersonationNotifier(
    super.ref, {
    ImpersonationState? initialState,
  }) {
    if (initialState != null) {
      state = initialState;
    }
  }

  int endCalls = 0;
  int clearCalls = 0;

  @override
  Future<bool> endImpersonation() async {
    endCalls++;
    return true;
  }

  @override
  void clearImpersonationState() {
    clearCalls++;
    state = const ImpersonationState();
  }
}

class _RouterTestApp extends StatelessWidget {
  const _RouterTestApp({required this.router, required this.overrides});

  final GoRouter router;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );
  }
}

Widget _buildPage({
  Future<Map<String, dynamic>> Function()? statsFuture,
  _FakeImpersonationNotifier? impersonationNotifier,
}) {
  return buildTestPage(
    const AdminDashboardPage(),
    overrides: [
      accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      adminApiProvider.overrideWithValue(_FakeAdminApi()),
      adminDashboardStatsProvider.overrideWith(
        (ref) =>
            statsFuture != null ? statsFuture() : Future.value(<String, dynamic>{}),
      ),
      if (impersonationNotifier != null)
        impersonationProvider.overrideWith((ref) => impersonationNotifier),
    ],
  );
}

void main() {
  group('AdminDashboardPage', () {
    testWidgets('shows loading state while stats are loading', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final completer = Completer<Map<String, dynamic>>();
      await tester.pumpWidget(_buildPage(statsFuture: () => completer.future));
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when stats request fails', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          statsFuture: () => Future<Map<String, dynamic>>.error(Exception('boom')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load dashboard'), findsOneWidget);
    });

    testWidgets('renders empty states when dashboard stats are empty',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          statsFuture: () async => <String, dynamic>{
            'users_by_role': <String, dynamic>{},
            'recent_logins': <dynamic>[],
            'recent_account_requests': <dynamic>[],
            'recent_deletion_requests': <dynamic>[],
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('User Distribution'), findsOneWidget);
      expect(find.text('No users yet'), findsOneWidget);
      expect(find.text('Recent Logins'), findsOneWidget);
      expect(find.text('No recent activity'), findsOneWidget);
      expect(find.text('No pending requests'), findsNWidgets(2));
      expect(find.text('Quick Links'), findsOneWidget);
      expect(find.text('Manage Users'), findsOneWidget);
    });

    testWidgets('renders populated alerts and activity lists', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          statsFuture: () async => <String, dynamic>{
            'active_users': 30,
            'total_users': 35,
            'new_users_30d': 5,
            'published_surveys': 7,
            'total_surveys': 10,
            'total_responses': 200,
            'pending_account_requests': 1,
            'pending_deletion_requests': 2,
            'draft_surveys': 3,
            'users_by_role': <String, dynamic>{
              'participant': 18,
              'researcher': 7,
              'hcp': 10,
            },
            'recent_logins': <dynamic>[
              {
                'name': 'Alice Admin',
                'role': 'admin',
                'logged_in_at': '2026-03-20T10:00:00Z',
              },
            ],
            'recent_account_requests': <dynamic>[
              {
                'name': 'Req One',
                'email': 'req1@example.com',
                'created_at': '2026-03-20T10:00:00Z',
              },
            ],
            'recent_deletion_requests': <dynamic>[
              {
                'name': 'Delete One',
                'email': 'del1@example.com',
                'requested_at': '2026-03-20T10:00:00Z',
              },
            ],
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('pending account requests awaiting approval'),
        findsOneWidget,
      );
      expect(find.textContaining('pending deletion requests'), findsOneWidget);
      expect(find.text('Alice Admin'), findsOneWidget);
      expect(find.text('Req One'), findsOneWidget);
      expect(find.text('req1@example.com'), findsOneWidget);
      expect(find.text('Delete One'), findsOneWidget);
      expect(find.text('del1@example.com'), findsOneWidget);
      expect(find.text('User Distribution by Role'), findsOneWidget);
    });

    testWidgets('navigates to messages when tapping action alert',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final router = GoRouter(
        initialLocation: AppRoutes.admin,
        routes: [
          GoRoute(
            path: AppRoutes.admin,
            builder: (context, state) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.adminMessages,
            builder: (context, state) => const Scaffold(
              body: Text('Messages Destination'),
            ),
          ),
        ],
      );

      final overrides = <Override>[
        accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
        deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
        adminApiProvider.overrideWithValue(_FakeAdminApi()),
        adminDashboardStatsProvider.overrideWith(
          (ref) => Future.value(<String, dynamic>{
            'pending_account_requests': 1,
            'pending_deletion_requests': 0,
          }),
        ),
      ];

      await tester.pumpWidget(_RouterTestApp(router: router, overrides: overrides));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('pending account request'));
      await tester.pumpAndSettle();

      expect(find.text('Messages Destination'), findsOneWidget);
    });

    testWidgets('ends active impersonation on initial load', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      late _FakeImpersonationNotifier fakeImpersonation;

      await tester.pumpWidget(
        buildTestPage(
          const AdminDashboardPage(),
          overrides: [
            accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
            deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
            adminApiProvider.overrideWithValue(_FakeAdminApi()),
            adminDashboardStatsProvider.overrideWith(
              (ref) => Future.value(<String, dynamic>{}),
            ),
            impersonationProvider.overrideWith((ref) {
              fakeImpersonation = _FakeImpersonationNotifier(
                ref,
                initialState: const ImpersonationState(mode: ViewAsMode.rolePreview),
              );
              return fakeImpersonation;
            }),
          ],
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(fakeImpersonation.endCalls, 1);
      expect(fakeImpersonation.clearCalls, 1);
    });
  });
}
