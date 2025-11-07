import 'package:freezed_annotation/freezed_annotation.dart';

import 'movement_receipt.dart';

part 'trolley_submission.freezed.dart';
part 'trolley_submission.g.dart';

@freezed
class TrolleySubmission with _$TrolleySubmission {
  const factory TrolleySubmission({
    required List<String> trolleyCodes,
    String? vehicleId,
    String? driverId,
    String? vehicleSnapshot,
    String? driverSnapshot,
    String? destination,
    required String status,
    required DateTime createdAt,
    int? sequenceNumber,
    @Default(<MovementReceipt>[]) List<MovementReceipt> receipts,
    bool? uploaded,
  }) = _TrolleySubmission;

  factory TrolleySubmission.fromJson(Map<String, dynamic> json) =>
      _$TrolleySubmissionFromJson(json);
}
