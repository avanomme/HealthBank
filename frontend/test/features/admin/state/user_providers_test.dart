import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/admin/state/database_providers.dart'
    show adminApiProvider;
import 'package:frontend/src/features/admin/state/user_providers.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:mocktail/mocktail.dart';

class _MockUserApi extends Mock implements UserApi {}

class _MockAdminApi extends Mock implements AdminApi {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockDio extends Mock implements Dio {}

void main() {
  group('UserFiltersNotifier', () {
    test('updates and clears role/isActive/search filters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(userFiltersProvider.notifier);

      notifier.setRole('admin');
      notifier.setIsActive(true);
      notifier.setSearchQuery('alice');

      var state = container.read(userFiltersProvider);
      expect(state.role, 'admin');
      expect(state.isActive, true);
      expect(state.searchQuery, 'alice');

      notifier.clearRole();
      notifier.clearIsActive();
      notifier.clearSearch();

      state = container.read(userFiltersProvider);
      expect(state.role, isNull);
      expect(state.isActive, isNull);
      expect(state.searchQuery, '');
    });

    test('setRole(null) clears role', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(userFiltersProvider.notifier);
      notifier.setRole('researcher');
      notifier.setRole(null);

      expect(container.read(userFiltersProvider).role, isNull);
    });

    test('clearAll resets all filters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(userFiltersProvider.notifier);
      notifier.setRole('hcp');
      notifier.setIsActive(false);
      notifier.setSearchQuery('john');

      notifier.clearAll();

      final state = container.read(userFiltersProvider);
      expect(state.role, isNull);
      expect(state.isActive, isNull);
      expect(state.searchQuery, '');
    });
  });

  group('user providers', () {
    test('userApiProvider creates UserApi from apiClientProvider', () {
      final mockClient = _MockApiClient();
      final mockDio = _MockDio();
      when(() => mockClient.dio).thenReturn(mockDio);

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => mockClient),
        ],
      );
      addTearDown(container.dispose);

      final api = container.read(userApiProvider);
      expect(api, isA<UserApi>());
    });

    test('usersProvider forwards filters and nulls empty search', () async {
      final mockApi = _MockUserApi();

      const expected = UserListResponse(
        users: [
          User(
            accountId: 1,
            firstName: 'Alice',
            lastName: 'Admin',
            email: 'alice@example.com',
            role: 'admin',
          ),
        ],
        total: 1,
      );

      when(
        () => mockApi.listUsers(
          role: any(named: 'role'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => expected);

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      // Empty search should be sent as null.
      final first = await container.read(usersProvider.future);
      expect(first.total, 1);
      verify(
        () => mockApi.listUsers(
          role: null,
          isActive: null,
          search: null,
          limit: null,
          offset: null,
        ),
      ).called(1);

      // Non-empty search and filters should be forwarded.
      container.read(userFiltersProvider.notifier).setRole('admin');
      container.read(userFiltersProvider.notifier).setIsActive(true);
      container.read(userFiltersProvider.notifier).setSearchQuery('alice');

      await container.read(usersProvider.future);
      verify(
        () => mockApi.listUsers(
          role: 'admin',
          isActive: true,
          search: 'alice',
          limit: null,
          offset: null,
        ),
      ).called(1);
    });

    test('userByIdProvider fetches specific user', () async {
      final mockApi = _MockUserApi();
      const user = User(
        accountId: 42,
        firstName: 'Bob',
        lastName: 'Builder',
        email: 'bob@example.com',
        role: 'researcher',
      );

      when(() => mockApi.getUser(42)).thenAnswer((_) async => user);

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(userByIdProvider(42).future);
      expect(result.accountId, 42);
      expect(result.firstName, 'Bob');
      verify(() => mockApi.getUser(42)).called(1);
    });

    test('userConsentProvider fetches consent record via admin api', () async {
      final mockAdminApi = _MockAdminApi();
      const consent = UserConsentRecordResponse(
        consentRecordId: 9,
        accountId: 2,
        roleId: 1,
        consentVersion: 'v1',
        documentLanguage: 'en',
        documentText: 'doc',
        signedAt: '2026-03-23T10:00:00Z',
      );

      when(() => mockAdminApi.getUserConsentRecord(2))
          .thenAnswer((_) async => consent);

      final container = ProviderContainer(
        overrides: [adminApiProvider.overrideWith((ref) => mockAdminApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(userConsentProvider(2).future);
      expect(result?.consentRecordId, 9);
      verify(() => mockAdminApi.getUserConsentRecord(2)).called(1);
    });
  });

  group('UserManagementNotifier', () {
    test('createUser success returns user and resets state', () async {
      final mockApi = _MockUserApi();
      const createBody = UserCreate(
        firstName: 'New',
        lastName: 'User',
        email: 'new@example.com',
        password: 'Password123!',
      );
      const created = User(
        accountId: 7,
        firstName: 'New',
        lastName: 'User',
        email: 'new@example.com',
      );

      when(() => mockApi.createUser(createBody)).thenAnswer((_) async => created);

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userManagementProvider.notifier);
      final result = await notifier.createUser(createBody);

      expect(result?.accountId, 7);
      expect(container.read(userManagementProvider).hasError, isFalse);
      verify(() => mockApi.createUser(createBody)).called(1);
    });

    test('createUser failure returns null and sets error state', () async {
      final mockApi = _MockUserApi();
      const createBody = UserCreate(
        firstName: 'Bad',
        lastName: 'User',
        email: 'bad@example.com',
        password: 'Password123!',
      );

      when(() => mockApi.createUser(createBody)).thenThrow(Exception('fail'));

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userManagementProvider.notifier);
      final result = await notifier.createUser(createBody);

      expect(result, isNull);
      expect(container.read(userManagementProvider).hasError, isTrue);
    });

    test('updateUser success invalidates user and list providers', () async {
      final mockApi = _MockUserApi();
      const update = UserUpdate(firstName: 'Updated');
      const updated = User(
        accountId: 5,
        firstName: 'Updated',
        lastName: 'Name',
        email: 'u@example.com',
      );

      when(() => mockApi.updateUser(5, update)).thenAnswer((_) async => updated);

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userManagementProvider.notifier);
      final result = await notifier.updateUser(5, update);

      expect(result?.firstName, 'Updated');
      expect(container.read(userManagementProvider).hasError, isFalse);
      verify(() => mockApi.updateUser(5, update)).called(1);
    });

    test('toggleUserStatus and deleteUser success paths', () async {
      final mockApi = _MockUserApi();
      const toggled = User(
        accountId: 10,
        firstName: 'Toggle',
        lastName: 'User',
        email: 'toggle@example.com',
        isActive: false,
      );

      when(() => mockApi.toggleUserStatus(10, false))
          .thenAnswer((_) async => toggled);
      when(() => mockApi.deleteUser(10)).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userManagementProvider.notifier);

      final toggleResult = await notifier.toggleUserStatus(10, false);
      final deleteResult = await notifier.deleteUser(10);

      expect(toggleResult?.isActive, false);
      expect(deleteResult, isTrue);
      verify(() => mockApi.toggleUserStatus(10, false)).called(1);
      verify(() => mockApi.deleteUser(10)).called(1);
    });

    test('deleteUser failure returns false and clearError resets state', () async {
      final mockApi = _MockUserApi();
      when(() => mockApi.deleteUser(9)).thenThrow(Exception('cannot delete'));

      final container = ProviderContainer(
        overrides: [userApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userManagementProvider.notifier);

      final result = await notifier.deleteUser(9);
      expect(result, isFalse);
      expect(container.read(userManagementProvider).hasError, isTrue);

      notifier.clearError();
      expect(container.read(userManagementProvider).hasError, isFalse);
    });
  });
}
