// Created with the Assistance of Claude Code
// Dio interceptor for mobile Bearer token authentication

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_session.dart';

/// Dio interceptor that captures session_token from Set-Cookie headers
/// and injects it as Authorization: Bearer on subsequent requests.
///
/// Only used on non-web platforms (Android/iOS/desktop).
/// Web platforms use browser-managed HttpOnly cookies instead.
class MobileAuthInterceptor extends Interceptor {
  final ProviderContainer _container;

  MobileAuthInterceptor(this._container);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _container.read(mobileSessionTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Capture session token on auth responses.
    final path = response.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/2fa/verify') ||
        path.contains('/sessions')) {
      // Primary: read from response body (works on web + mobile).
      // The backend includes session_token in the body when it receives the
      // X-Client-Type: native header (set by api_client when API_BASE_URL is
      // non-empty, i.e. cross-origin dev or native mobile).
      // Remove on Prod(HTTPS): Once HTTPS + SameSite=None;Secure is in place, switch
      // back to cookie-only auth and remove the body extraction path.
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['session_token'] as String?;
        if (token != null && token.isNotEmpty) {
          _container.read(mobileSessionTokenProvider.notifier).state = token;
          handler.next(response);
          return;
        }
      }

      // Fallback: Set-Cookie header (native mobile via dart:io — browsers
      // never expose this header to JS/Dart).
      final cookies = response.headers['set-cookie'];
      final token = extractSessionTokenFromCookies(cookies);
      if (token != null) {
        _container.read(mobileSessionTokenProvider.notifier).state = token;
      } else if (cookies != null &&
          cookies.any((c) => c.contains('session_token='))) {
        // Cookie is being deleted (logout) — clear token
        _container.read(mobileSessionTokenProvider.notifier).state = null;
      }
    }
    handler.next(response);
  }
}
