import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:mocktail/mocktail.dart';

class _MockAdminApi extends Mock implements AdminApi {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockDio extends Mock implements Dio {}

void main() {
  group('account_request_providers', () {
    test('adminApiProvider creates an AdminApi instance from apiClientProvider',
        () {
      final mockClient = _MockApiClient();
      final mockDio = _MockDio();
      when(() => mockClient.dio).thenReturn(mockDio);

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => mockClient),
        ],
      );
      addTearDown(container.dispose);

      final api = container.read(adminApiProvider);
      expect(api, isA<AdminApi>());
    });

    test('accountRequestsProvider uses default pending status filter', () async {
      final mockApi = _MockAdminApi();
      final expected = [
        const AccountRequestResponse(
          requestId: 1,
          firstName: 'Jane',
          lastName: 'Doe',
          email: 'jane@example.com',
          roleId: 1,
          status: 'pending',
        ),
      ];

      when(() => mockApi.getAccountRequests(status: any(named: 'status')))
          .thenAnswer((_) async => expected);

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(accountRequestsProvider.future);

      expect(result, expected);
      verify(() => mockApi.getAccountRequests(status: 'pending')).called(1);
    });

    test('accountRequestsProvider forwards updated status filter', () async {
      final mockApi = _MockAdminApi();

      when(() => mockApi.getAccountRequests(status: any(named: 'status')))
          .thenAnswer((_) async => const <AccountRequestResponse>[]);

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      container.read(accountRequestStatusFilter.notifier).state = 'approved';
      await container.read(accountRequestsProvider.future);

      verify(() => mockApi.getAccountRequests(status: 'approved')).called(1);
    });

    test('deletionRequestsProvider uses default pending status filter',
        () async {
      final mockApi = _MockAdminApi();
      final expected = [
        const DeletionRequestResponse(
          requestId: 8,
          accountId: 21,
          fullName: 'User A',
          email: 'a@example.com',
          status: 'pending',
          requestedAt: '2026-03-23T10:00:00Z',
        ),
      ];

      when(() => mockApi.getDeletionRequests(status: any(named: 'status')))
          .thenAnswer((_) async => expected);

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(deletionRequestsProvider.future);

      expect(result, expected);
      verify(() => mockApi.getDeletionRequests(status: 'pending')).called(1);
    });

    test('deletionRequestsProvider forwards updated status filter', () async {
      final mockApi = _MockAdminApi();

      when(() => mockApi.getDeletionRequests(status: any(named: 'status')))
          .thenAnswer((_) async => const <DeletionRequestResponse>[]);

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      container.read(deletionRequestStatusFilter.notifier).state = 'rejected';
      await container.read(deletionRequestsProvider.future);

      verify(() => mockApi.getDeletionRequests(status: 'rejected')).called(1);
    });

    test('accountRequestCountProvider yields first count from API', () async {
      final mockApi = _MockAdminApi();
      when(() => mockApi.getAccountRequestCount()).thenAnswer(
        (_) async => const AccountRequestCountResponse(count: 4),
      );

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      final first = await container.read(accountRequestCountProvider.future);

      expect(first, 4);
      verify(() => mockApi.getAccountRequestCount()).called(1);
    });

    test('deletionRequestCountProvider yields first count from API', () async {
      final mockApi = _MockAdminApi();
      when(() => mockApi.getDeletionRequestCount()).thenAnswer(
        (_) async => const DeletionRequestCountResponse(count: 2),
      );

      final container = ProviderContainer(
        overrides: [
          adminApiProvider.overrideWith((ref) => mockApi),
        ],
      );
      addTearDown(container.dispose);

      final first = await container.read(deletionRequestCountProvider.future);

      expect(first, 2);
      verify(() => mockApi.getDeletionRequestCount()).called(1);
    });

    test('adminDashboardStatsProvider returns empty map when API data is null',
        () async {
      final mockClient = _MockApiClient();
      final mockDio = _MockDio();
      when(() => mockClient.dio).thenReturn(mockDio);
      when(() => mockDio.get<Map<String, dynamic>>('/admin/dashboard/stats'))
          .thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/admin/dashboard/stats'),
          data: null,
          statusCode: 200,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => mockClient),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(adminDashboardStatsProvider.future);

      expect(result, isEmpty);
      verify(() => mockDio.get<Map<String, dynamic>>('/admin/dashboard/stats'))
          .called(1);
    });

    test('adminDashboardStatsProvider returns API map when present', () async {
      final mockClient = _MockApiClient();
      final mockDio = _MockDio();
      when(() => mockClient.dio).thenReturn(mockDio);
      when(() => mockDio.get<Map<String, dynamic>>('/admin/dashboard/stats'))
          .thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/admin/dashboard/stats'),
          data: const {
            'total_users': 12,
            'pending_account_requests': 1,
          },
          statusCode: 200,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => mockClient),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(adminDashboardStatsProvider.future);

      expect(result['total_users'], 12);
      expect(result['pending_account_requests'], 1);
    });
  });
}
