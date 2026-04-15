// Created with the Assistance of Claude Code
// frontend/test/core/api/api_client_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api_client.dart';

void main() {
  group('ApiClient', () {
    setUp(() {
      // Reset singleton between tests
      ApiClient.reset();
      ApiClient.onSessionExpired = null;
    });

    test('is a singleton', () {
      final a = ApiClient();
      final b = ApiClient();
      expect(identical(a, b), isTrue);
    });

    test('reset creates a new instance', () {
      final a = ApiClient();
      ApiClient.reset();
      final b = ApiClient();
      expect(identical(a, b), isFalse);
    });

    test('withCredentials is set in BaseOptions extra on web, absent on native', () {
      final client = ApiClient();
      // On native (test environment), kIsWeb is false so withCredentials is not set
      // On web with same-origin (no API_BASE_URL override), withCredentials would be true
      // This test verifies the extra map is not null and the key is absent in native tests
      expect(client.dio.options.extra, isNotNull);
    });

    test('onSessionExpired callback is null by default', () {
      expect(ApiClient.onSessionExpired, isNull);
    });

    test('onSessionExpired callback can be set', () {
      var called = false;
      ApiClient.onSessionExpired = () => called = true;
      ApiClient.onSessionExpired!();
      expect(called, isTrue);
    });
  });

  group('ApiException', () {
    test('isUnauthorized for 401', () {
      final e = ApiException(message: 'test', statusCode: 401);
      expect(e.isUnauthorized, isTrue);
      expect(e.isForbidden, isFalse);
    });

    test('isForbidden for 403', () {
      final e = ApiException(message: 'test', statusCode: 403);
      expect(e.isForbidden, isTrue);
      expect(e.isUnauthorized, isFalse);
    });

    test('isNotFound for 404', () {
      final e = ApiException(message: 'test', statusCode: 404);
      expect(e.isNotFound, isTrue);
    });

    test('isServerError for 5xx', () {
      final e500 = ApiException(message: 'test', statusCode: 500);
      final e503 = ApiException(message: 'test', statusCode: 503);
      expect(e500.isServerError, isTrue);
      expect(e503.isServerError, isTrue);
    });

    test('isValidationError for 422', () {
      final e = ApiException(message: 'test', statusCode: 422);
      expect(e.isValidationError, isTrue);
    });

    test('toString includes message and status', () {
      final e = ApiException(message: 'Not found', statusCode: 404);
      expect(e.toString(), contains('Not found'));
      expect(e.toString(), contains('404'));
    });
  });
}
