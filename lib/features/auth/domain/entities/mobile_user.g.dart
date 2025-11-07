// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileUserImpl _$$MobileUserImplFromJson(Map<String, dynamic> json) =>
    _$MobileUserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String,
      shift: json['shift'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$MobileUserImplToJson(_$MobileUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'status': instance.status,
      'shift': instance.shift,
      'token': instance.token,
    };
