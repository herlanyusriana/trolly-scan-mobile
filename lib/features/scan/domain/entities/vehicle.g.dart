// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: _idFromJson(json['id']),
      plateNumber: json['plate_number'] as String,
      name: json['name'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': _idToJson(instance.id),
      'plate_number': instance.plateNumber,
      'name': instance.name,
      'category': instance.category,
      'status': instance.status,
    };
