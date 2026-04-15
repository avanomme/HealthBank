// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/hcp_link.dart
/// HCP link model matching backend HcpLinkOut schema.
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hcp_link.freezed.dart';
part 'hcp_link.g.dart';

/// HCP-to-patient link record returned by /api/v1/hcp-links/
@freezed
sealed class HcpLink with _$HcpLink {
  const factory HcpLink({
    @JsonKey(name: 'link_id') required int linkId,
    @JsonKey(name: 'hcp_id') required int hcpId,
    @JsonKey(name: 'patient_id') required int patientId,
    @JsonKey(name: 'hcp_name') String? hcpName,
    @JsonKey(name: 'patient_name') String? patientName,
    required String status,
    @JsonKey(name: 'requested_by') required String requestedBy,
    @JsonKey(name: 'requested_at') required DateTime requestedAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'consent_revoked') @Default(false) bool consentRevoked,
  }) = _HcpLink;

  factory HcpLink.fromJson(Map<String, dynamic> json) =>
      _$HcpLinkFromJson(json);
}
