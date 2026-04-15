// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/two_factor_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'two_factor_api.g.dart';

/// Auth API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate auth_api.g.dart
@RestApi()
abstract class TwoFactorAPI {
  factory TwoFactorAPI(Dio dio, {String? baseUrl}) = _TwoFactorAPI;

  /// Enroll account with 2FA. uses current session cookie to get account data.
  @POST('/2fa/enroll')
  Future<TwoFactorEnrollResponse> twoFactorEnroll();

  // confirm 2fa enrollment with totp code
  @POST('/2fa/confirm')
  Future<TwoFactorConfirmResponse> twoFactorConfirm(
    @Body() TwoFactorConfirmRequest request,
  );

  // disable 2fa
  @POST('/2fa/disable')
  Future<TwoFactorDisableResponse> twoFactorDisable();
}