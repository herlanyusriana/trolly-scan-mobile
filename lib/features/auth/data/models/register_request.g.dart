// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestImpl(
  name: json['name'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String,
  passwordConfirmation: json['passwordConfirmation'] as String,
);

Map<String, dynamic> _$$RegisterRequestImplToJson(
  _$RegisterRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'password': instance.password,
  'passwordConfirmation': instance.passwordConfirmation,
};
