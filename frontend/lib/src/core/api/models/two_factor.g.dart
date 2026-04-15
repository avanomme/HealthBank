// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'two_factor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TwoFactorEnrollResponse _$TwoFactorEnrollResponseFromJson(
  Map<String, dynamic> json,
) => _TwoFactorEnrollResponse(
  provisioningUri: json['provisioning_uri'] as String,
);

Map<String, dynamic> _$TwoFactorEnrollResponseToJson(
  _TwoFactorEnrollResponse instance,
) => <String, dynamic>{'provisioning_uri': instance.provisioningUri};

_TwoFactorConfirmResponse _$TwoFactorConfirmResponseFromJson(
  Map<String, dynamic> json,
) => _TwoFactorConfirmResponse(message: json['message'] as String);

Map<String, dynamic> _$TwoFactorConfirmResponseToJson(
  _TwoFactorConfirmResponse instance,
) => <String, dynamic>{'message': instance.message};

_TwoFactorDisableResponse _$TwoFactorDisableResponseFromJson(
  Map<String, dynamic> json,
) => _TwoFactorDisableResponse(message: json['message'] as String);

Map<String, dynamic> _$TwoFactorDisableResponseToJson(
  _TwoFactorDisableResponse instance,
) => <String, dynamic>{'message': instance.message};

_TwoFactorConfirmRequest _$TwoFactorConfirmRequestFromJson(
  Map<String, dynamic> json,
) => _TwoFactorConfirmRequest(code: json['code'] as String);

Map<String, dynamic> _$TwoFactorConfirmRequestToJson(
  _TwoFactorConfirmRequest instance,
) => <String, dynamic>{'code': instance.code};
