import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/profile/pages/profile_page.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

import '../../../test_helpers.dart';

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}

Map<String, dynamic> _sessionPayload({
  String? firstName = 'Ada',
  String? lastName = 'Lovelace',
  String email = 'ada@example.com',
  String? birthdate = '1990-05-01',
  String? gender = 'female',
  String role = 'participant',
}) {
  return {
    'user': {
      'account_id': 10,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'role_id': 1,
      'birthdate': birthdate,
      'gender': gender,
    },
    'is_impersonating': false,
    'session_expires_at': '2099-01-01T00:00:00Z',
    'has_signed_consent': true,
    'needs_profile_completion': false,
  };
}

Map<String, dynamic> _userPayload({
  String firstName = 'Ada',
  String lastName = 'Lovelace',
  String email = 'ada@example.com',
  String? birthdate = '1990-05-01T00:00:00.000Z',
  String? gender = 'female',
}) {
  return {
    'account_id': 10,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'role': 'participant',
    'is_active': true,
    'birthdate': birthdate,
    'gender': gender,
  };
}

Dio _buildDio({
  Map<String, dynamic>? sessionPayload,
  Map<String, dynamic>? updateResponse,
  Object? sessionError,
  Object? updateError,
  void Function(Map<String, dynamic> body)? onUpdateBody,
}) {
  final dio = Dio();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.path == '/sessions/me' && options.method == 'GET') {
          if (sessionError != null) {
            handler.reject(
              DioException(requestOptions: options, error: sessionError),
            );
            return;
          }
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: sessionPayload ?? _sessionPayload(),
            ),
          );
          return;
        }

        if (options.path == '/users/me' && options.method == 'PUT') {
          final rawData = options.data;
          if (rawData is Map<String, dynamic>) {
            onUpdateBody?.call(Map<String, dynamic>.from(rawData));
          } else if (rawData != null) {
            try {
              final dynamicData = rawData as dynamic;
              final json = dynamicData.toJson() as Map<String, dynamic>;
              onUpdateBody?.call(Map<String, dynamic>.from(json));
            } catch (_) {
              // Ignore payload capture failures; behavior assertions still run.
            }
          }

          if (updateError != null) {
            handler.reject(
              DioException(requestOptions: options, error: updateError),
            );
            return;
          }

          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: updateResponse ?? _userPayload(),
            ),
          );
          return;
        }

        handler.next(options);
      },
    ),
  );

  return dio;
}

Widget _buildPage(Dio dio) {
  return buildTestPage(
    const ProfilePage(),
    overrides: [
      apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
      messagingUnreadCountProvider.overrideWith((ref) => 0),
    ],
  );
}

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(ProfilePage));
  return AppLocalizations.of(context);
}

void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1440, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('ProfilePage', () {
    testWidgets('renders loaded profile data in view mode', (tester) async {
      await tester.pumpWidget(_buildPage(_buildDio()));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);

      expect(find.text(l10n.profileTitle), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('ada@example.com'), findsOneWidget);
      expect(find.text('1990-05-01'), findsOneWidget);
      expect(find.text('female'), findsOneWidget);
      expect(find.text(l10n.profileEditInformation), findsOneWidget);
    });

    testWidgets('shows load error when session request fails', (tester) async {
      await tester.pumpWidget(
        _buildPage(
          _buildDio(sessionError: 'session failed'),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.profileLoadError), findsOneWidget);
    });

    testWidgets('shows dash placeholder when optional values are missing',
        (tester) async {
      await tester.pumpWidget(
        _buildPage(
          _buildDio(
            sessionPayload: _sessionPayload(
              firstName: null,
              lastName: null,
              birthdate: null,
              gender: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('—'), findsWidgets);
    });

    testWidgets('enters edit mode and shows form fields', (tester) async {
      _useDesktopViewport(tester);
      await tester.pumpWidget(_buildPage(_buildDio()));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.ensureVisible(find.text(l10n.profileEditInformation));
      await tester.tap(find.text(l10n.profileEditInformation));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.text(l10n.profileSaveChanges), findsOneWidget);
      expect(find.text(l10n.commonCancel), findsOneWidget);
    });

    testWidgets('validates required fields before saving', (tester) async {
      _useDesktopViewport(tester);
      await tester.pumpWidget(_buildPage(_buildDio()));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.ensureVisible(find.text(l10n.profileEditInformation));
      await tester.tap(find.text(l10n.profileEditInformation));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '');
      await tester.enterText(fields.at(1), 'Lovelace');
      await tester.enterText(fields.at(2), 'ada@example.com');
      await tester.tap(find.text(l10n.profileSaveChanges));
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileFirstNameRequired), findsOneWidget);
    });

    testWidgets('saves profile and shows success message', (tester) async {
      _useDesktopViewport(tester);
      Map<String, dynamic>? capturedBody;
      final dio = _buildDio(
        onUpdateBody: (body) => capturedBody = body,
        updateResponse: _userPayload(
          firstName: 'Grace',
          lastName: 'Hopper',
          email: 'grace@example.com',
          gender: 'other',
        ),
      );

      await tester.pumpWidget(_buildPage(dio));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.ensureVisible(find.text(l10n.profileEditInformation));
      await tester.tap(find.text(l10n.profileEditInformation));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Grace');
      await tester.enterText(fields.at(1), 'Hopper');
      await tester.enterText(fields.at(2), 'grace@example.com');
      await tester.enterText(fields.at(4), 'other');

      await tester.ensureVisible(find.text(l10n.profileSaveChanges));
      await tester.tap(find.text(l10n.profileSaveChanges));
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileUpdateSuccess), findsOneWidget);
      expect(capturedBody?['first_name'], 'Grace');
      expect(capturedBody?['last_name'], 'Hopper');
      expect(capturedBody?['email'], 'grace@example.com');
      expect(capturedBody?['gender'], 'other');
    });

    testWidgets('shows update error when save fails', (tester) async {
      _useDesktopViewport(tester);
      final dio = _buildDio(updateError: 'update failed');
      await tester.pumpWidget(_buildPage(dio));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.ensureVisible(find.text(l10n.profileEditInformation));
      await tester.tap(find.text(l10n.profileEditInformation));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Grace');
      await tester.enterText(fields.at(1), 'Hopper');
      await tester.enterText(fields.at(2), 'grace@example.com');

      await tester.tap(find.text(l10n.profileSaveChanges));
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileUpdateError), findsOneWidget);
    });

    testWidgets('cancel restores original values and exits edit mode',
        (tester) async {
      _useDesktopViewport(tester);
      await tester.pumpWidget(_buildPage(_buildDio()));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.ensureVisible(find.text(l10n.profileEditInformation));
      await tester.tap(find.text(l10n.profileEditInformation));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Changed');

      await tester.tap(find.text(l10n.commonCancel));
      await tester.pumpAndSettle();

      expect(find.text(l10n.profileEditInformation), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Changed'), findsNothing);
    });
  });
}
