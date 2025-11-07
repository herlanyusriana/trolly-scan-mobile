// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trolley_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrolleySubmissionImpl _$$TrolleySubmissionImplFromJson(
  Map<String, dynamic> json,
) => _$TrolleySubmissionImpl(
  trolleyCodes: (json['trolleyCodes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  vehicleId: json['vehicleId'] as String?,
  driverId: json['driverId'] as String?,
  vehicleSnapshot: json['vehicleSnapshot'] as String?,
  driverSnapshot: json['driverSnapshot'] as String?,
  destination: json['destination'] as String?,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sequenceNumber: (json['sequenceNumber'] as num?)?.toInt(),
  receipts:
      (json['receipts'] as List<dynamic>?)
          ?.map((e) => MovementReceipt.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MovementReceipt>[],
  uploaded: json['uploaded'] as bool?,
);

Map<String, dynamic> _$$TrolleySubmissionImplToJson(
  _$TrolleySubmissionImpl instance,
) => <String, dynamic>{
  'trolleyCodes': instance.trolleyCodes,
  'vehicleId': instance.vehicleId,
  'driverId': instance.driverId,
  'vehicleSnapshot': instance.vehicleSnapshot,
  'driverSnapshot': instance.driverSnapshot,
  'destination': instance.destination,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'sequenceNumber': instance.sequenceNumber,
  'receipts': instance.receipts,
  'uploaded': instance.uploaded,
};
