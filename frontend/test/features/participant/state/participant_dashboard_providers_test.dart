import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';

class _FakeAuthApi implements AuthApi {
  _FakeAuthApi(this.session);

  final SessionMeResponse session;

  @override
  Future<SessionMeResponse> getSessionInfo() async => session;

  @override
  Future<void> logout() => throw UnimplementedError();

  @override
  Future<dynamic> login(LoginRequest request) => throw UnimplementedError();

  @override
  Future<dynamic> verify2fa(Verify2FARequest request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> requestPasswordReset(PasswordResetEmailRequest request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> confirmPasswordReset(
    PasswordResetConfirmRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<dynamic> getPublicConfig() async => {'registration_open': true};

  @override
  Future<MessageResponse> submitAccountRequest(AccountRequestCreate request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> changePassword(ChangePasswordRequest request) =>
      throw UnimplementedError();

  @override
  Future<MessageResponse> completeProfile(ProfileCompleteRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> requestAccountDeletion() => throw UnimplementedError();
}

class _FakeAssignmentApi implements AssignmentApi {
  _FakeAssignmentApi(this.assignments);

  final List<MyAssignment> assignments;
  int calls = 0;

  @override
  Future<List<MyAssignment>> getMyAssignments({String? status}) async {
    calls += 1;
    return assignments;
  }

  @override
  Future<void> deleteAssignment(int id) => throw UnimplementedError();

  @override
  Future<void> assignSurvey(int surveyId, AssignmentCreate body) =>
      throw UnimplementedError();

  @override
  Future<BulkAssignmentResult> assignSurveyBulk(
    int surveyId,
    Map<String, dynamic> body,
  ) =>
      throw UnimplementedError();

  @override
  Future<List<Assignment>> getSurveyAssignments(
    int surveyId, {
    String? status,
  }) =>
      throw UnimplementedError();

  @override
  Future<Assignment> updateAssignment(int id, AssignmentUpdate assignment) =>
      throw UnimplementedError();
}

class _FakeUserApi implements UserApi {
  _FakeUserApi(this.user);

  final User user;
  int? lastUserId;

  @override
  Future<User> getUser(int id) async {
    lastUserId = id;
    return user;
  }

  @override
  Future<User> createUser(UserCreate user) => throw UnimplementedError();

  @override
  Future<void> deleteUser(int id) => throw UnimplementedError();

  @override
  Future<UserListResponse> listUsers({
    String? role,
    bool? isActive,
    String? search,
    int? limit,
    int? offset,
  }) =>
      throw UnimplementedError();

  @override
  Future<User> toggleUserStatus(int id, bool isActive) =>
      throw UnimplementedError();

  @override
  Future<User> updateCurrentUser(CurrentUserUpdate user) =>
      throw UnimplementedError();

  @override
  Future<User> updateUser(int id, UserUpdate user) =>
      throw UnimplementedError();
}

class _FakeHcpLinkApi implements HcpLinkApi {
  _FakeHcpLinkApi(this.links);

  final List<HcpLink> links;
  int calls = 0;

  @override
  Future<List<HcpLink>> getMyLinks({String? status}) async {
    calls += 1;
    return links;
  }

  @override
  Future<void> deleteLink(int linkId) => throw UnimplementedError();

  @override
  Future<void> requestLink(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<void> respondToLink(int linkId, Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<void> restoreConsent(int linkId) => throw UnimplementedError();

  @override
  Future<void> revokeConsent(int linkId) => throw UnimplementedError();
}

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}

SessionMeResponse _session({
  int accountId = 10,
  String email = 'participant@example.com',
  String? firstName = 'Pat',
  String? lastName = 'Ient',
  ViewingAsUserInfo? viewingAs,
}) {
  return SessionMeResponse(
    user: SessionUserInfo(
      accountId: accountId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      role: 'participant',
      roleId: 1,
    ),
    isImpersonating: false,
    viewingAs: viewingAs,
    sessionExpiresAt: '2099-01-01T00:00:00Z',
  );
}

void main() {
  group('participant dashboard providers', () {
    test('ParticipantProfile.displayName falls back to email', () {
      const profile = ParticipantProfile(
        accountId: 1,
        email: 'fallback@example.com',
      );

      expect(profile.displayName, 'fallback@example.com');
    });

    test('ParticipantProfile.displayName joins first and last names', () {
      const profile = ParticipantProfile(
        accountId: 1,
        email: 'fallback@example.com',
        firstName: '  Jane',
        lastName: 'Doe  ',
      );

      expect(profile.displayName, 'Jane Doe');
    });

    test('API providers construct Retrofit services', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(participantAuthApiProvider), isA<AuthApi>());
      expect(
        container.read(participantAssignmentApiProvider),
        isA<AssignmentApi>(),
      );
      expect(container.read(participantUserApiProvider), isA<UserApi>());
      expect(container.read(participantSurveyApiProvider), isA<SurveyApi>());
      expect(container.read(hcpLinkApiProvider), isA<HcpLinkApi>());
    });

    test('participantSessionProvider returns session from AuthApi', () async {
      final session = _session(accountId: 21, email: 's@example.com');
      final container = ProviderContainer(
        overrides: [
          participantAuthApiProvider.overrideWith((ref) => _FakeAuthApi(session)),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantSessionProvider.future);

      expect(result, session);
    });

    test('participantProfileProvider uses session viewingAs when present',
        () async {
      const viewingAs = ViewingAsUserInfo(
        userId: 99,
        firstName: 'View',
        lastName: 'User',
        email: 'view@example.com',
        role: 'participant',
        roleId: 1,
      );
      final session = _session(
        accountId: 1,
        email: 'session@example.com',
        firstName: 'Session',
        lastName: 'User',
        viewingAs: viewingAs,
      );
      final userApi = _FakeUserApi(
        const User(
          accountId: 99,
          firstName: 'Should',
          lastName: 'NotCall',
          email: 'x@example.com',
        ),
      );
      final container = ProviderContainer(
        overrides: [
          participantSessionProvider.overrideWith((ref) async => session),
          participantUserApiProvider.overrideWith((ref) => userApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantProfileProvider.future);

      expect(result.accountId, 99);
      expect(result.email, 'view@example.com');
      expect(result.firstName, 'View');
      expect(result.lastName, 'User');
      expect(userApi.lastUserId, isNull);
    });

    test('participantProfileProvider falls back to UserApi for missing names',
        () async {
      final session = _session(
        accountId: 55,
        email: 'session@example.com',
        firstName: null,
        lastName: null,
      );
      final userApi = _FakeUserApi(
        const User(
          accountId: 55,
          firstName: 'Fallback',
          lastName: 'Name',
          email: 'fallback@example.com',
        ),
      );
      final container = ProviderContainer(
        overrides: [
          participantSessionProvider.overrideWith((ref) async => session),
          participantUserApiProvider.overrideWith((ref) => userApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantProfileProvider.future);

      expect(userApi.lastUserId, 55);
      expect(result.firstName, 'Fallback');
      expect(result.lastName, 'Name');
    });

    test('participantAssignmentsProvider returns assignments', () async {
      final assignmentApi = _FakeAssignmentApi(
        const [
          MyAssignment(assignmentId: 7, surveyId: 3, status: 'pending'),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          participantAssignmentApiProvider.overrideWith((ref) => assignmentApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(participantAssignmentsProvider.future);

      expect(assignmentApi.calls, 1);
      expect(result, hasLength(1));
      expect(result.first.assignmentId, 7);
    });

    test('hcpLinksProvider returns links', () async {
      final now = DateTime.parse('2026-01-01T00:00:00.000Z');
      final hcpApi = _FakeHcpLinkApi([
        HcpLink(
          linkId: 1,
          hcpId: 20,
          patientId: 30,
          status: 'pending',
          requestedBy: 'hcp',
          requestedAt: now,
          updatedAt: now,
        ),
      ]);
      final container = ProviderContainer(
        overrides: [
          hcpLinkApiProvider.overrideWith((ref) => hcpApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(hcpLinksProvider.future);

      expect(hcpApi.calls, 1);
      expect(result, hasLength(1));
      expect(result.first.linkId, 1);
    });

    test('participantConsentStatusProvider maps needsConsent to false',
        () async {
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.path.contains('/consent/status')) {
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'has_signed_consent': false,
                      'consent_version': null,
                      'consent_signed_at': null,
                      'current_version': 'v2',
                      'needs_consent': true,
                    },
                  ),
                );
                return;
              }
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'unexpected path: ${options.path}',
                ),
              );
            },
          ),
        );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
        ],
      );
      addTearDown(container.dispose);

      final isCurrent =
          await container.read(participantConsentStatusProvider.future);

      expect(isCurrent, isFalse);
    });

    test('participantConsentStatusProvider returns true on errors', () async {
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'boom',
                ),
              );
            },
          ),
        );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
        ],
      );
      addTearDown(container.dispose);

      final isCurrent =
          await container.read(participantConsentStatusProvider.future);

      expect(isCurrent, isTrue);
    });

    test('participantProfileCompleteProvider is false when profile missing names',
        () async {
      final container = ProviderContainer(
        overrides: [
          participantProfileProvider.overrideWith(
            (ref) async =>
                const ParticipantProfile(accountId: 1, email: 'a@b.com'),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(participantProfileProvider.future);
      final isComplete = container.read(participantProfileCompleteProvider);

      expect(isComplete, isFalse);
    });

    test('participantNotificationCountProvider counts all notification sources',
        () async {
      final now = DateTime.parse('2026-01-01T00:00:00.000Z');
      final container = ProviderContainer(
        overrides: [
          hcpLinksProvider.overrideWith(
            (ref) async => [
              HcpLink(
                linkId: 1,
                hcpId: 2,
                patientId: 3,
                status: 'pending',
                requestedBy: 'hcp',
                requestedAt: now,
                updatedAt: now,
              ),
              HcpLink(
                linkId: 2,
                hcpId: 2,
                patientId: 3,
                status: 'accepted',
                requestedBy: 'hcp',
                requestedAt: now,
                updatedAt: now,
              ),
            ],
          ),
          participantProfileCompleteProvider.overrideWith((ref) => false),
          participantConsentStatusProvider.overrideWith((ref) async => false),
          messagingUnreadCountProvider.overrideWith((ref) => 2),
        ],
      );
      addTearDown(container.dispose);

      await container.read(hcpLinksProvider.future);
      await container.read(participantConsentStatusProvider.future);

      final count = container.read(participantNotificationCountProvider);

      expect(count, 5);
    });
  });
}
