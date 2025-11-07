// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverImpl _$$DriverImplFromJson(Map<String, dynamic> json) => _$DriverImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  licenseNumber: json['license_number'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$$DriverImplToJson(_$DriverImpl instance) =>
    <String, dynamic>{
      'id': _idToJson(instance.id),
      'name': instance.name,
      'phone': instance.phone,
      'license_number': instance.licenseNumber,
      'status': instance.status,
    };
