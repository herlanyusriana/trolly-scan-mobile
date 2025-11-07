import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_receipt.freezed.dart';
part 'movement_receipt.g.dart';

@freezed
class MovementReceipt with _$MovementReceipt {
  const factory MovementReceipt({
    required String code,
    required String status,
    DateTime? checkedOutAt,
    DateTime? checkedInAt,
    int? sequenceNumber,
    String? destination,
    String? vehicleSnapshot,
    String? driverSnapshot,
  }) = _MovementReceipt;

  factory MovementReceipt.fromJson(Map<String, dynamic> json) =>
      _$MovementReceiptFromJson(json);
}

