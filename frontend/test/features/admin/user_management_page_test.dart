import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/admin/pages/user_management_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show accountRequestCountProvider, deletionRequestCountProvider;
import 'package:frontend/src/features/admin/state/user_providers.dart';
import 'package:frontend/src/features/admin/state/user_table_state.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';

import '../../test_helpers.dart';

class _AuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _AuthNotifier(super.state);

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<String?> verifyMfa(String code) async => null;

  @override
  Future<String?> restoreSession() async => null;

  @override
  Future<void> logout() async {
    state = const AuthState();
  }

  @override
  void clearError() {
    state = state.clearError();
  }

  @override
  void clearMfaChallenge() {}

  @override
  void clearMustChangePassword() {}

  @override
  void clearNeedsProfileCompletion() {}

  @override
  void markConsentSigned() {}

  @override
  void reset() {
    state = const AuthState();
  }
}

class _FakeUserApi implements UserApi {
  UserCreate? lastCreate;
  UserUpdate? lastUpdate;
  Object? createError;
  int? lastUpdatedId;
  Object? updateError;

  @override
  Future<User> createUser(UserCreate user) async {
    if (createError != null) throw createError!;
    lastCreate = user;
    return User(
      accountId: 98,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      role: user.role?.name ?? 'participant',
    );
  }

  @override
  Future<User> updateUser(int id, UserUpdate user) async {
    if (updateError != null) throw updateError!;
    lastUpdatedId = id;
    lastUpdate = user;
    return User(
      accountId: id,
      firstName: user.firstName ?? 'Updated',
      lastName: user.lastName ?? 'User',
      email: user.email ?? 'updated@example.com',
      role: user.role?.name ?? 'participant',
    );
  }

  @override
  Future<void> deleteUser(int id) async => throw UnimplementedError();

  @override
  Future<User> getUser(int id) async => throw UnimplementedError();

  @override
  Future<UserListResponse> listUsers({
    String? role,
    bool? isActive,
    String? search,
    int? limit,
    int? offset,
  }) async =>
      throw UnimplementedError();

  @override
  Future<User> toggleUserStatus(int id, bool isActive) async =>
      throw UnimplementedError();

  @override
  Future<User> updateCurrentUser(CurrentUserUpdate user) async =>
      throw UnimplementedError();
}

class _FakeUserManagementNotifier extends UserManagementNotifier {
  _FakeUserManagementNotifier(super.ref, {AsyncValue<void>? initial}) : super() {
    state = initial ?? const AsyncValue.data(null);
  }

  UserCreate? createdUser;
  int? toggledUserId;
  bool? toggledIsActive;
  int? deletedUserId;

  @override
  Future<User?> createUser(UserCreate user) async {
    createdUser = user;
    return User(
      accountId: 99,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      role: user.role?.name ?? 'participant',
    );
  }

  @override
  Future<User?> toggleUserStatus(int userId, bool isActive) async {
    toggledUserId = userId;
    toggledIsActive = isActive;
    return User(
      accountId: userId,
      firstName: 'Toggle',
      lastName: 'User',
      email: 'toggle@example.com',
      role: 'participant',
      isActive: isActive,
    );
  }

  @override
  Future<bool> deleteUser(int userId) async {
    deletedUserId = userId;
    return true;
  }
}

class _FakeImpersonationNotifier extends ImpersonationNotifier {
  _FakeImpersonationNotifier(
    super.ref, {
    this.roleToReturn = 'participant',
    ImpersonationState? initialState,
  }) : super() {
    if (initialState != null) {
      state = initialState;
    }
  }

  final String? roleToReturn;
  int? startedUserId;

  @override
  Future<String?> startImpersonation(int userId) async {
    startedUserId = userId;
    return roleToReturn;
  }
}

class _RecordingUserTableNotifier extends UserTableNotifier {
  final List<UserSortColumn> sortCalls = [];

  @override
  void onSort(UserSortColumn column) {
    sortCalls.add(column);
    super.onSort(column);
  }
}

User _user({
  required int id,
  required String firstName,
  required String lastName,
  required String email,
  required String role,
  bool isActive = true,
  DateTime? consentSignedAt,
  String? consentVersion,
}) {
  return User(
    accountId: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    role: role,
    isActive: isActive,
    consentSignedAt: consentSignedAt,
    consentVersion: consentVersion,
    lastLogin: DateTime.parse('2026-03-16T10:00:00Z'),
  );
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(2800, 1400);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

DioException _dioError(int status) {
  final request = RequestOptions(path: '/admin/users');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(
      requestOptions: request,
      statusCode: status,
      data: const {},
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('UserManagementPage', () {
    late _FakeUserApi userApi;

    setUp(() {
      userApi = _FakeUserApi();
    });

    Widget buildPage({
      required List<Override> overrides,
    }) {
      return buildTestPage(
        const UserManagementPage(),
        overrides: [
          authProvider.overrideWith(
            (ref) => _AuthNotifier(
              const AuthState(
                isAuthenticated: true,
                user: LoginResponse(
                  expiresAt: '2099-01-01T00:00:00Z',
                  accountId: 900,
                  firstName: 'Admin',
                  lastName: 'User',
                  email: 'admin@example.com',
                  role: 'admin',
                ),
              ),
            ),
          ),
          userApiProvider.overrideWith((ref) => userApi),
          accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
          deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
          impersonationProvider.overrideWith(
            (ref) => _FakeImpersonationNotifier(
              ref,
              roleToReturn: 'participant',
            ),
          ),
          userTableProvider.overrideWith((ref) => UserTableNotifier()),
          ...overrides,
        ],
      );
    }

    testWidgets('shows loading and retry states for user list', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final completer = Completer<UserListResponse>();
      var loads = 0;

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith((ref) async {
              loads += 1;
              if (loads == 1) throw Exception('boom');
              return const UserListResponse(users: [], total: 0);
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load users'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(loads, 2);

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith((ref) => completer.future),
          ],
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('User Management'), findsWidgets);
    });

    testWidgets('expands row and opens consent record dialog',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final user = _user(
        id: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: 'participant',
        consentSignedAt: DateTime.parse('2026-03-16T10:00:00Z'),
        consentVersion: 'v1',
      );

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: [user], total: 1),
            ),
            userConsentProvider(1).overrideWith(
              (ref) async => const UserConsentRecordResponse(
                consentRecordId: 1,
                accountId: 1,
                roleId: 1,
                consentVersion: 'v1',
                documentLanguage: 'en',
                documentText: 'Consent body',
                signatureName: 'Ada Lovelace',
                signedAt: '2026-03-16T10:00:00Z',
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ada Lovelace'));
      await tester.pumpAndSettle();

      expect(find.text('Consent Signed'), findsOneWidget);
      expect(find.text('View Consent Record'), findsOneWidget);

      await tester.tap(find.text('View Consent Record'));
      await tester.pumpAndSettle();
      expect(find.text('Document Text'), findsOneWidget);
      expect(find.text('Consent body'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('toggle and delete actions call user management notifier', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      late _FakeUserManagementNotifier notifier;
      final user = _user(
        id: 3,
        firstName: 'Toggle',
        lastName: 'User',
        email: 'toggle@example.com',
        role: 'participant',
      );

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) {
              notifier = _FakeUserManagementNotifier(ref);
              return notifier;
            }),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: [user], total: 1),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byTooltip('Deactivate'));
      await tester.tap(find.byTooltip('Deactivate'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(notifier.toggledUserId, 3);
      expect(notifier.toggledIsActive, false);

      await tester.ensureVisible(find.byTooltip('Delete user'));
      await tester.tap(find.byTooltip('Delete user'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(notifier.deletedUserId, 3);
      expect(find.text('Toggle User deleted'), findsOneWidget);
    });

    testWidgets('renders narrow filters, clears management error and shows empty table state',
        (tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith(
              (ref) => _FakeUserManagementNotifier(
                ref,
                initial: const AsyncValue.error('boom', StackTrace.empty),
              ),
            ),
            usersProvider.overrideWith(
              (ref) async => const UserListResponse(users: [], total: 0),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add User'), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);
      expect(find.text('Active only'), findsOneWidget);
      expect(find.text('No users found'), findsOneWidget);
      expect(find.text('Error: boom'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      expect(find.text('Error: boom'), findsNothing);
    });

    testWidgets('filter controls update and sorting headers trigger notifier',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      late _RecordingUserTableNotifier tableNotifier;
      final users = [
        _user(
          id: 3,
          firstName: 'Bravo',
          lastName: 'User',
          email: 'bravo@example.com',
          role: 'researcher',
        ),
        _user(
          id: 2,
          firstName: 'Alpha',
          lastName: 'User',
          email: 'alpha@example.com',
          role: 'hcp',
          isActive: false,
        ).copyWith(lastLogin: null),
        _user(
          id: 1,
          firstName: 'Zulu',
          lastName: 'User',
          email: 'zulu@example.com',
          role: 'admin',
        ),
        _user(
          id: 4,
          firstName: '',
          lastName: 'Mystery',
          email: 'mystery@example.com',
          role: 'mystery',
        ).copyWith(lastLogin: null),
      ];

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            userTableProvider.overrideWith((ref) {
              tableNotifier = _RecordingUserTableNotifier();
              return tableNotifier;
            }),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: users, total: users.length),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'alpha');
      await tester.pumpAndSettle();
      await tester.tap(find.text('All Roles'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admin').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Active only'));
      await tester.pumpAndSettle();

      expect(find.text('HCP'), findsOneWidget);
      expect(find.text('mystery'), findsOneWidget);

      for (final header in ['Email', 'Role', 'Status', 'Last Login']) {
        await tester.tap(find.text(header));
        await tester.pumpAndSettle();
      }

      expect(
        tableNotifier.sortCalls,
        containsAll([
          UserSortColumn.email,
          UserSortColumn.role,
          UserSortColumn.status,
          UserSortColumn.lastLogin,
        ]),
      );
    });

    testWidgets('shows admin consent exempt and not-signed branches', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final admin = _user(
        id: 10,
        firstName: 'System',
        lastName: 'Admin',
        email: 'sys@example.com',
        role: 'admin',
      );
      final participant = _user(
        id: 11,
        firstName: 'No',
        lastName: 'Consent',
        email: 'noconsent@example.com',
        role: 'participant',
        consentSignedAt: null,
        consentVersion: null,
      );

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: [admin, participant], total: 2),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('System Admin'));
      await tester.pumpAndSettle();
      expect(find.text('Admin — Consent Exempt'), findsOneWidget);
      expect(find.text('View Consent Record'), findsNothing);

      await tester.tap(find.text('No Consent'));
      await tester.pumpAndSettle();
      expect(find.text('Consent Not Signed'), findsOneWidget);
    });

    testWidgets('view as user hidden and visible states plus reset password modal',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final visibleUser = _user(
        id: 20,
        firstName: 'Visible',
        lastName: 'User',
        email: 'visible@example.com',
        role: 'participant',
      );
      final hiddenAdmin = _user(
        id: 21,
        firstName: 'Hidden',
        lastName: 'Admin',
        email: 'hidden@example.com',
        role: 'admin',
      );
      final hiddenInactive = _user(
        id: 22,
        firstName: 'Hidden',
        lastName: 'Inactive',
        email: 'inactive@example.com',
        role: 'participant',
        isActive: false,
      );

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            impersonationProvider.overrideWith(
              (ref) => _FakeImpersonationNotifier(
                ref,
                roleToReturn: 'participant',
                initialState: const ImpersonationState(
                  currentUser: SessionUserInfo(
                    accountId: 900,
                    firstName: 'Admin',
                    lastName: 'User',
                    email: 'admin@example.com',
                    role: 'admin',
                    roleId: 4,
                  ),
                ),
              ),
            ),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(
                users: [visibleUser, hiddenAdmin, hiddenInactive],
                total: 3,
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('View as User'), findsOneWidget);
      await tester.tap(find.byTooltip('Reset Password').first);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('add user dialog validates and creates user', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      late _FakeUserManagementNotifier notifier;

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) {
              notifier = _FakeUserManagementNotifier(ref);
              return notifier;
            }),
            usersProvider.overrideWith(
              (ref) async => const UserListResponse(users: [], total: 0),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add User'));
      await tester.pumpAndSettle();
      expect(find.text('Add New User'), findsOneWidget);
      final dialog = find.byType(AlertDialog);
      Finder dialogField(int index) =>
          find.descendant(of: dialog, matching: find.byType(TextField)).at(index);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(notifier.createdUser, isNull);
      expect(find.text('Add New User'), findsOneWidget);

      await tester.enterText(dialogField(0), 'new@example.com');
      await tester.enterText(dialogField(1), 'New');
      await tester.enterText(dialogField(2), 'User');
      // Uncheck "Send account setup email" to reveal the password + Generate/Copy buttons
      await tester.tap(find.text('Send account setup email'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();
      expect(find.text('Password copied to clipboard'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(notifier.createdUser, isNotNull);
      expect(notifier.createdUser?.email, 'new@example.com');
      expect(notifier.createdUser?.firstName, 'New');
      expect(notifier.createdUser?.lastName, 'User');
      expect(find.text('User created successfully'), findsOneWidget);
    });

    testWidgets('edit user dialog updates user and maps API errors', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final user = _user(
        id: 14,
        firstName: 'Edit',
        lastName: 'Me',
        email: 'edit@example.com',
        role: 'participant',
      );

      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: [user], total: 1),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Edit user'));
      await tester.pumpAndSettle();
      expect(find.text('Edit User'), findsOneWidget);
      final dialog = find.byType(AlertDialog);
      Finder dialogField(int index) =>
          find.descendant(of: dialog, matching: find.byType(TextField)).at(index);

      await tester.enterText(dialogField(0), 'updated@example.com');
      await tester.enterText(dialogField(1), 'Updated');
      await tester.enterText(dialogField(2), 'Person');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(userApi.lastUpdatedId, 14);
      expect(userApi.lastUpdate?.email, 'updated@example.com');
      expect(find.text('Edit User'), findsNothing);

      for (final scenario in <int, String>{
        404: 'User not found.',
        409: 'Email already in use.',
        422: 'Validation failed. Please check your input.',
        500: 'Server error. Please try again later.',
      }.entries) {
        userApi.updateError = _dioError(scenario.key);
        await tester.pumpWidget(
          buildPage(
            overrides: [
              userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
              usersProvider.overrideWith(
                (ref) async => UserListResponse(users: [user], total: 1),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Edit user'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.byType(AppAnnouncement), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }

      userApi.updateError = Exception('offline');
      await tester.pumpWidget(
        buildPage(
          overrides: [
            userManagementProvider.overrideWith((ref) => _FakeUserManagementNotifier(ref)),
            usersProvider.overrideWith(
              (ref) async => UserListResponse(users: [user], total: 1),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit user'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.byType(AppAnnouncement), findsOneWidget);
    });
  });
}
