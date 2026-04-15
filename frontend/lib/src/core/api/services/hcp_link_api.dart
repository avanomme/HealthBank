// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/hcp_link_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/hcp_link.dart';

part 'hcp_link_api.g.dart';

/// HCP Link API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate hcp_link_api.g.dart
@RestApi()
abstract class HcpLinkApi {
  factory HcpLinkApi(Dio dio, {String? baseUrl}) = _HcpLinkApi;

  /// Request a link with a participant by account ID
  @POST('/hcp-links/request')
  Future<void> requestLink(
    @Body() Map<String, dynamic> body,
  );

  /// Get all HCP links for the current user (optional status filter)
  @GET('/hcp-links/')
  Future<List<HcpLink>> getMyLinks({
    @Query('status') String? status,
  });

  /// Respond to a link request (accept or reject)
  @PUT('/hcp-links/{linkId}/respond')
  Future<void> respondToLink(
    @Path('linkId') int linkId,
    @Body() Map<String, dynamic> body,
  );

  /// Delete / remove a link
  @DELETE('/hcp-links/{linkId}')
  Future<void> deleteLink(
    @Path('linkId') int linkId,
  );

  /// Revoke participant consent for a specific HCP link
  @POST('/hcp-links/{linkId}/revoke-consent')
  Future<void> revokeConsent(
    @Path('linkId') int linkId,
  );

  /// Restore participant consent for a specific HCP link
  @POST('/hcp-links/{linkId}/restore-consent')
  Future<void> restoreConsent(
    @Path('linkId') int linkId,
  );
}
