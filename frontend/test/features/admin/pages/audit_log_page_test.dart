import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/pages/audit_log_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show accountRequestCountProvider, deletionRequestCountProvider;
import 'package:frontend/src/features/admin/state/audit_log_providers.dart';

import '../../../test_helpers.dart';

class _RecordingAuditFiltersNotifier extends AuditLogFiltersNotifier {
  _RecordingAuditFiltersNotifier([AuditLogFilters? initial]) : super() {
    if (initial != null) {
      state = initial;
    }
  }

  String? lastSearch;
  bool clearCalled = false;
  int nextCalls = 0;
  int previousCalls = 0;

  @override
  void setSearch(String? search) {
    lastSearch = search;
    super.setSearch(search);
  }

  @override
  void clearFilters() {
    clearCalled = true;
    super.clearFilters();
  }

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
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1800, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

AuditEvent _event({
  required int id,
  required String createdAt,
  required String status,
  String? method,
  String? actorName,
  String? actorEmail,
  Map<String, dynamic>? metadata,
  String action = 'USER_LOGIN',
  String resourceType = 'user',
}) {
  return AuditEvent(
    auditEventId: id,
    createdAt: createdAt,
    actorType: 'admin',
    actorAccountId: 10,
    actorName: actorName,
    actorEmail: actorEmail,
    httpMethod: method,
    path: '/admin/logs',
    action: action,
    resourceType: resourceType,
    status: status,
    requestId: 'req-$id',
    resourceId: 'res-$id',
    ipAddress: '127.0.0.1',
    userAgent: 'test-agent',
    httpStatusCode: 200,
    errorCode: status == 'failure' ? 'E_FAIL' : null,
    metadata: metadata,
  );
}

Widget _buildPage({
  Future<AuditLogResponse> Function()? logsFuture,
  Future<List<String>> Function()? actionsFuture,
  Future<List<String>> Function()? resourcesFuture,
  _RecordingAuditFiltersNotifier? filtersNotifier,
}) {
  final notifier = filtersNotifier ?? _RecordingAuditFiltersNotifier();

  return buildTestPage(
    const AuditLogPage(),
    overrides: [
      accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      auditLogFiltersProvider.overrideWith((ref) => notifier),
      auditLogsProvider.overrideWith(
        (ref) => logsFuture != null
            ? logsFuture()
            : Future.value(
                AuditLogResponse(
                  events: [
                    _event(
                      id: 1,
                      createdAt: '2026-03-23T10:20:30Z',
                      status: 'success',
                      method: 'GET',
                      actorName: 'Admin User',
                      actorEmail: 'admin@example.com',
                      metadata: const {'reason': 'manual check'},
                    ),
                    _event(
                      id: 2,
                      createdAt: 'bad-ts',
                      status: 'denied',
                      method: null,
                      actorName: null,
                      actorEmail: null,
                      action: 'ACCESS_DENIED',
                      resourceType: 'audit',
                    ),
                  ],
                  total: 2,
                  limit: 50,
                  offset: 0,
                ),
              ),
      ),
      auditLogActionsProvider.overrideWith(
        (ref) => actionsFuture != null
            ? actionsFuture()
            : Future.value(const ['USER_LOGIN', 'ACCESS_DENIED']),
      ),
      auditLogResourceTypesProvider.overrideWith(
        (ref) => resourcesFuture != null
            ? resourcesFuture()
            : Future.value(const ['user', 'audit']),
      ),
    ],
  );
}

void main() {
  group('AuditLogPage', () {
    testWidgets('shows loading indicator while logs are loading', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final logsCompleter = Completer<AuditLogResponse>();
      await tester.pumpWidget(
        _buildPage(logsFuture: () => logsCompleter.future),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when logs request fails', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          logsFuture: () => Future<AuditLogResponse>.error(Exception('boom')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load audit logs'), findsOneWidget);
      expect(find.textContaining('boom'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('renders events table with formatted and fallback values',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(_buildPage());
      await tester.pumpAndSettle();

      expect(find.text('Audit Log'), findsWidgets);
      expect(find.text('USER_LOGIN'), findsOneWidget);
      expect(find.text('ACCESS_DENIED'), findsOneWidget);
      expect(find.text('2026-03-23 10:20:30'), findsOneWidget);
      expect(find.text('bad-ts'), findsOneWidget);
      expect(find.text('SUCCESS'), findsOneWidget);
      expect(find.text('DENIED'), findsOneWidget);
      expect(find.text('GET'), findsOneWidget);
      expect(find.text('-'), findsWidgets);
      expect(find.text('admin'), findsWidgets);
    });

    testWidgets('expands a row to show detailed metadata and fields',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(_buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('USER_LOGIN').first);
      await tester.pumpAndSettle();

      expect(find.text('Event ID'), findsOneWidget);
      expect(find.text('Request ID'), findsOneWidget);
      expect(find.text('Resource Type'), findsWidgets);
      expect(find.text('Metadata'), findsOneWidget);
      expect(find.textContaining('reason: manual check'), findsOneWidget);
    });

    testWidgets('search input updates filters and clear button resets filters',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final notifier = _RecordingAuditFiltersNotifier(
        const AuditLogFilters(
          search: 'existing',
          action: 'USER_LOGIN',
          status: 'success',
        ),
      );

      await tester.pumpWidget(_buildPage(filtersNotifier: notifier));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'admin logs',
      );
      await tester.pump();

      expect(notifier.lastSearch, 'admin logs');

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(notifier.clearCalled, isTrue);
      expect(notifier.state.search, isNull);
      expect(notifier.state.action, isNull);
      expect(notifier.state.status, isNull);
    });

    testWidgets('pagination footer invokes next and previous page actions',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final notifier = _RecordingAuditFiltersNotifier(
        const AuditLogFilters(limit: 1, offset: 1),
      );

      await tester.pumpWidget(
        _buildPage(
          filtersNotifier: notifier,
          logsFuture: () async => AuditLogResponse(
            events: [
              _event(
                id: 99,
                createdAt: '2026-03-23T11:11:11Z',
                status: 'success',
                method: 'POST',
              ),
            ],
            total: 3,
            limit: 1,
            offset: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Showing 2-2 of 3 events'), findsOneWidget);
      expect(find.text('Page 2 of 3'), findsOneWidget);

      final pagerButtons = find.byType(IconButton);
      expect(pagerButtons, findsWidgets);

      await tester.tap(find.byTooltip('Previous page'));
      await tester.pump();
      await tester.tap(find.byTooltip('Next page'));
      await tester.pump();

      expect(notifier.previousCalls, greaterThan(0));
      expect(notifier.nextCalls, greaterThan(0));
    });

    testWidgets('shows loading bars for action and resource filter providers',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final actionsCompleter = Completer<List<String>>();
      final resourcesCompleter = Completer<List<String>>();

      await tester.pumpWidget(
        _buildPage(
          actionsFuture: () => actionsCompleter.future,
          resourcesFuture: () => resourcesCompleter.future,
        ),
      );
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });
  });
}
