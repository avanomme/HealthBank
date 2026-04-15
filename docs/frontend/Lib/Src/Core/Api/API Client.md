// Created with the Assistance of Claude Code
// frontend/lib/core/api/api_client.dart
/// API Client configuration using Retrofit + Dio
///
/// This file provides the base API client configuration for making HTTP
/// requests to the HealthBank backend API.
///
/// Usage:
/// ```dart
/// final apiClient = ApiClient();
/// final response = await apiClient.dio.get('/api/v1/surveys');
/// ```
///
/// For typed API calls, use the generated Retrofit services.
library;


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API configuration constants
class ApiConfig {
  // TODO: Remove in production - local development override
  // Set via: flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
  static const String _devOverride = String.fromEnvironment('API_BASE_URL');

  /// Base URL for the backend API
  /// When running through nginx (production/Docker), use relative path
  /// When running locally for development, use direct backend URL
  ///
  /// For local Flutter development with Docker backend:
  ///   flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
  static String get baseUrl {
    // Allow override via dart-define for local development
    if (_devOverride.isNotEmpty) {
      return _devOverride;
    }
    // For web builds served through nginx, use relative URLs
    // The nginx config proxies /api/* to the backend
    if (kIsWeb) {
      return ''; // Empty base URL = relative path, nginx proxies /api/* to backend
    }
    // For desktop/mobile, use 127.0.0.1 instead of localhost
    // Windows has known issues resolving localhost in some network configurations
    // Using 127.0.0.1 works consistently across all platforms
    return 'http://127.0.0.1:8000';
  }

  /// API version prefix
  static const String apiPrefix = '/api/v1';

  /// Full API base URL
  static String get apiBaseUrl => '$baseUrl$apiPrefix';

  /// Request timeout duration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Private constructor - this class should not be instantiated
  ApiConfig._();
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';

  /// Check if error is a validation error (422)
  bool get isValidationError => statusCode == 422;

  /// Check if error is unauthorized (401)
  bool get isUnauthorized => statusCode == 401;

  /// Check if error is forbidden (403)
  bool get isForbidden => statusCode == 403;

  /// Check if error is not found (404)
  bool get isNotFound => statusCode == 404;

  /// Check if error is a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;
}

/// API Client singleton for making HTTP requests
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  /// Private constructor
  ApiClient._internal() {
    _dio = _createDio();
  }

  /// Factory constructor returning singleton instance
  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Access to the Dio instance
  Dio get dio => _dio;

  /// Create and configure Dio instance
  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        extra: {'withCredentials': true}, // Send cookies cross-origin
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }

  /// Reset the singleton instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  /// Called when a 401 is received on a non-login endpoint.
  /// Set by the app layer to handle session expiry (clear state + navigate).
  static void Function()? onSessionExpired;
}

/// Interceptor for logging requests and responses (debug mode only)
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API Request: ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('Request Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API Response: ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API Error: ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('Error Message: ${err.message}');
    }
    handler.next(err);
  }
}

/// Interceptor for transforming Dio errors into ApiExceptions.
///
/// Also handles 401 responses by clearing the auth token and invoking
/// [ApiClient.onSessionExpired] to redirect to login.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    // Handle 401 — session expired or invalid token.
    // Exclude login endpoint (401 there means wrong credentials, not expiry).
    if (statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/login') &&
        !err.requestOptions.path.contains('/2fa/verify') &&
        !err.requestOptions.path.contains('/2fa/confirm') &&
        !err.requestOptions.path.contains('/sessions/me')) {
      ApiClient.onSessionExpired?.call();
    }

    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.connectionError:
        message = 'Unable to connect to server. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        message = _extractErrorMessage(err.response);
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      default:
        message = err.message ?? 'An unexpected error occurred.';
    }

    // Transform to ApiException and continue error handling
    final apiException = ApiException(
      message: message,
      statusCode: statusCode,
      data: err.response?.data,
    );

    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: apiException,
      response: err.response,
      type: err.type,
    ));
  }

  /// Extract error message from response
  String _extractErrorMessage(Response? response) {
    if (response?.data == null) {
      return 'An error occurred.';
    }

    final data = response!.data;

    // Handle FastAPI error format: {"detail": "message"} or {"detail": [...]}
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        // Validation error format
        final firstError = detail.first;
        if (firstError is Map<String, dynamic>) {
          final msg = firstError['msg'] ?? 'Validation error';
          final loc = firstError['loc'];
          if (loc is List && loc.length > 1) {
            return '${loc.last}: $msg';
          }
          return msg.toString();
        }
      }
    }

    return 'An error occurred (${response.statusCode}).';
  }
}
