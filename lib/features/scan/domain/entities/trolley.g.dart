// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trolley.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrolleyImpl _$$TrolleyImplFromJson(Map<String, dynamic> json) =>
    _$TrolleyImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      type: json['type'] as String,
      kind: json['kind'] as String?,
      status: json['status'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$TrolleyImplToJson(_$TrolleyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'kind': instance.kind,
      'status': instance.status,
      'location': instance.location,
    };
