// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovementReceiptImpl _$$MovementReceiptImplFromJson(
  Map<String, dynamic> json,
) => _$MovementReceiptImpl(
  code: json['code'] as String,
  status: json['status'] as String,
  checkedOutAt: json['checkedOutAt'] == null
      ? null
      : DateTime.parse(json['checkedOutAt'] as String),
  checkedInAt: json['checkedInAt'] == null
      ? null
      : DateTime.parse(json['checkedInAt'] as String),
  sequenceNumber: (json['sequenceNumber'] as num?)?.toInt(),
  destination: json['destination'] as String?,
  vehicleSnapshot: json['vehicleSnapshot'] as String?,
  driverSnapshot: json['driverSnapshot'] as String?,
);

Map<String, dynamic> _$$MovementReceiptImplToJson(
  _$MovementReceiptImpl instance,
) => <String, dynamic>{
  'code': instance.code,
  'status': instance.status,
  'checkedOutAt': instance.checkedOutAt?.toIso8601String(),
  'checkedInAt': instance.checkedInAt?.toIso8601String(),
  'sequenceNumber': instance.sequenceNumber,
  'destination': instance.destination,
  'vehicleSnapshot': instance.vehicleSnapshot,
  'driverSnapshot': instance.driverSnapshot,
};
