import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/admin/state/audit_log_providers.dart';
import 'package:frontend/src/features/admin/state/database_providers.dart'
    show adminApiProvider;
import 'package:mocktail/mocktail.dart';

class _MockAdminApi extends Mock implements AdminApi {}

void main() {
  group('AuditLogFiltersNotifier', () {
    test('setters update filters and reset offset to first page', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(auditLogFiltersProvider.notifier);

      notifier.setPage(3);
      expect(container.read(auditLogFiltersProvider).offset, 150);

      notifier.setAction('USER_LOGIN');
      expect(container.read(auditLogFiltersProvider).action, 'USER_LOGIN');
      expect(container.read(auditLogFiltersProvider).offset, 0);

      notifier.setStatus('success');
      expect(container.read(auditLogFiltersProvider).status, 'success');
      expect(container.read(auditLogFiltersProvider).offset, 0);

      notifier.setResourceType('user');
      expect(container.read(auditLogFiltersProvider).resourceType, 'user');

      notifier.setHttpMethod('GET');
      expect(container.read(auditLogFiltersProvider).httpMethod, 'GET');

      notifier.setSearch('admin');
      expect(container.read(auditLogFiltersProvider).search, 'admin');
      expect(container.read(auditLogFiltersProvider).offset, 0);
    });

    test('clear behaviors reset nullable fields', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(auditLogFiltersProvider.notifier);

      notifier.setAction('USER_LOGIN');
      notifier.setStatus('failure');
      notifier.setActorAccountId(123);
      notifier.setResourceType('audit');
      notifier.setHttpMethod('POST');
      notifier.setSearch('foo');
      notifier.setDateRange('2026-01-01', '2026-01-31');

      notifier.setAction(null);
      notifier.setStatus(null);
      notifier.setActorAccountId(null);
      notifier.setResourceType(null);
      notifier.setHttpMethod(null);
      notifier.setSearch('');
      notifier.setDateRange(null, null);

      final filters = container.read(auditLogFiltersProvider);
      expect(filters.action, isNull);
      expect(filters.status, isNull);
      expect(filters.actorAccountId, isNull);
      expect(filters.resourceType, isNull);
      expect(filters.httpMethod, isNull);
      expect(filters.search, isNull);
      expect(filters.startDate, isNull);
      expect(filters.endDate, isNull);
    });

    test('pagination helpers update page/offset correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(auditLogFiltersProvider.notifier);

      expect(container.read(auditLogFiltersProvider).currentPage, 0);

      notifier.nextPage();
      expect(container.read(auditLogFiltersProvider).offset, 50);
      expect(container.read(auditLogFiltersProvider).currentPage, 1);

      notifier.previousPage();
      expect(container.read(auditLogFiltersProvider).offset, 0);
      expect(container.read(auditLogFiltersProvider).currentPage, 0);

      notifier.previousPage();
      expect(container.read(auditLogFiltersProvider).offset, 0);

      notifier.setPage(4);
      expect(container.read(auditLogFiltersProvider).offset, 200);
      expect(container.read(auditLogFiltersProvider).currentPage, 4);
    });

    test('clearFilters keeps limit but resets all filters and offset', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(auditLogFiltersProvider.notifier);

      notifier.setAction('A');
      notifier.setStatus('success');
      notifier.setSearch('term');
      notifier.setPage(2);

      notifier.clearFilters();

      final filters = container.read(auditLogFiltersProvider);
      expect(filters.action, isNull);
      expect(filters.status, isNull);
      expect(filters.search, isNull);
      expect(filters.offset, 0);
      expect(filters.limit, 50);
    });
  });

  group('audit log providers', () {
    test('auditLogsProvider forwards all active filters to API', () async {
      final mockApi = _MockAdminApi();

      when(
        () => mockApi.getAuditLogs(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          action: any(named: 'action'),
          status: any(named: 'status'),
          actorAccountId: any(named: 'actorAccountId'),
          resourceType: any(named: 'resourceType'),
          httpMethod: any(named: 'httpMethod'),
          search: any(named: 'search'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer(
        (_) async => const AuditLogResponse(
          events: [],
          total: 0,
          limit: 50,
          offset: 0,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(auditLogFiltersProvider.notifier);
      notifier.setAction('USER_LOGIN');
      notifier.setStatus('success');
      notifier.setActorAccountId(99);
      notifier.setResourceType('user');
      notifier.setHttpMethod('GET');
      notifier.setSearch('admin');
      notifier.setDateRange('2026-03-01', '2026-03-31');
      notifier.setPage(2);

      final result = await container.read(auditLogsProvider.future);

      expect(result.total, 0);
      verify(
        () => mockApi.getAuditLogs(
          limit: 50,
          offset: 100,
          action: 'USER_LOGIN',
          status: 'success',
          actorAccountId: 99,
          resourceType: 'user',
          httpMethod: 'GET',
          search: 'admin',
          startDate: '2026-03-01',
          endDate: '2026-03-31',
        ),
      ).called(1);
    });

    test('auditLogActionsProvider fetches actions list', () async {
      final mockApi = _MockAdminApi();
      when(() => mockApi.getAuditLogActions())
          .thenAnswer((_) async => const ['LOGIN', 'LOGOUT']);

      final container = ProviderContainer(
        overrides: [adminApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(auditLogActionsProvider.future);

      expect(result, ['LOGIN', 'LOGOUT']);
      verify(() => mockApi.getAuditLogActions()).called(1);
    });

    test('auditLogResourceTypesProvider fetches resource types list', () async {
      final mockApi = _MockAdminApi();
      when(() => mockApi.getAuditLogResourceTypes())
          .thenAnswer((_) async => const ['user', 'survey']);

      final container = ProviderContainer(
        overrides: [adminApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(auditLogResourceTypesProvider.future);

      expect(result, ['user', 'survey']);
      verify(() => mockApi.getAuditLogResourceTypes()).called(1);
    });

    test('auditLogsProvider returns API response payload', () async {
      final mockApi = _MockAdminApi();
      const response = AuditLogResponse(
        events: [
          AuditEvent(
            auditEventId: 1,
            createdAt: '2026-03-23T10:00:00Z',
            actorType: 'admin',
            action: 'USER_LOGIN',
            resourceType: 'user',
            status: 'success',
          ),
        ],
        total: 1,
        limit: 50,
        offset: 0,
      );

      when(
        () => mockApi.getAuditLogs(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          action: any(named: 'action'),
          status: any(named: 'status'),
          actorAccountId: any(named: 'actorAccountId'),
          resourceType: any(named: 'resourceType'),
          httpMethod: any(named: 'httpMethod'),
          search: any(named: 'search'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => response);

      final container = ProviderContainer(
        overrides: [adminApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(auditLogsProvider.future);

      expect(result.total, 1);
      expect(result.events.first.action, 'USER_LOGIN');
    });
  });
}
