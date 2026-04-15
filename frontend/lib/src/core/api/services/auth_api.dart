// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/auth_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'auth_api.g.dart';

/// Auth API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate auth_api.g.dart
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  /// Login with email and password
  /// Returns session token, user info, and role for routing
  @POST('/auth/login')
  Future<dynamic> login(@Body() LoginRequest request);

  @POST('/2fa/verify')
  Future<dynamic> verify2fa(@Body() Verify2FARequest request);

  /// Logout - invalidates the session (cookie-based, no body needed)
  @DELETE('/sessions/logout')
  Future<void> logout();

  /// Get current session information
  ///
  /// Returns user info and impersonation status.
  /// Use this to check if currently impersonating a user.
  @GET('/sessions/me')
  Future<SessionMeResponse> getSessionInfo();

  /// Request a password reset email
  @POST('/auth/password_reset_request')
  Future<MessageResponse> requestPasswordReset(
      @Body() PasswordResetEmailRequest request);

  /// Confirm password reset with token and new password
  @POST('/auth/confirm_password_reset')
  Future<MessageResponse> confirmPasswordReset(
      @Body() PasswordResetConfirmRequest request);

  /// Public config — no auth required.
  /// Returns settings the login screen needs before authentication,
  /// e.g. whether self-registration is currently open.
  @GET('/auth/public-config')
  Future<dynamic> getPublicConfig();

  /// Submit a new account request (public, no auth required)
  @POST('/auth/request_account')
  Future<MessageResponse> submitAccountRequest(
      @Body() AccountRequestCreate request);

  /// Change password (for forced password change flow)
  @POST('/auth/change_password')
  Future<MessageResponse> changePassword(
      @Body() ChangePasswordRequest request);

  /// Complete participant profile (birthdate + gender)
  @POST('/auth/complete_profile')
  Future<MessageResponse> completeProfile(
      @Body() ProfileCompleteRequest request);

  /// Submit a self-service account deletion request.
  ///
  /// Deactivates the account immediately and queues it for admin review.
  /// Returns 201 on success. The session cookie is cleared server-side.
  @POST('/auth/me/deletion-request')
  Future<void> requestAccountDeletion();
}
