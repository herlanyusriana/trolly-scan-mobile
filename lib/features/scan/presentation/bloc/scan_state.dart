import 'package:equatable/equatable.dart';

import '../../domain/entities/trolley_submission.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/driver.dart';

enum ScanStatus { idle, ready, submitting, success, failure }

enum MasterStatus { initial, loading, success, failure }

const _departureUnset = Object();

class ScanState extends Equatable {
  const ScanState({
    this.scannedCodes = const <String>[],
    this.status = ScanStatus.idle,
    this.error,
    this.lastSubmission,
    this.vehicles = const <Vehicle>[],
    this.drivers = const <Driver>[],
    this.mastersStatus = MasterStatus.initial,
    this.mastersError,
    this.departureNumber,
  });

  final List<String> scannedCodes;
  final ScanStatus status;
  final String? error;
  final TrolleySubmission? lastSubmission;
  final List<Vehicle> vehicles;
  final List<Driver> drivers;
  final MasterStatus mastersStatus;
  final String? mastersError;
  final int? departureNumber;

  bool get hasSelection => scannedCodes.isNotEmpty;
  bool get hasDepartureNumber => departureNumber != null;

  ScanState copyWith({
    List<String>? scannedCodes,
    ScanStatus? status,
    String? error,
    TrolleySubmission? lastSubmission,
    List<Vehicle>? vehicles,
    List<Driver>? drivers,
    MasterStatus? mastersStatus,
    String? mastersError,
    Object? departureNumber = _departureUnset,
  }) {
    return ScanState(
      scannedCodes: scannedCodes ?? this.scannedCodes,
      status: status ?? this.status,
      error: error,
      lastSubmission: lastSubmission ?? this.lastSubmission,
      vehicles: vehicles ?? this.vehicles,
      drivers: drivers ?? this.drivers,
      mastersStatus: mastersStatus ?? this.mastersStatus,
      mastersError: mastersError ?? this.mastersError,
      departureNumber: identical(departureNumber, _departureUnset)
          ? this.departureNumber
          : departureNumber as int?,
    );
  }

  @override
  List<Object?> get props => [
    scannedCodes,
    status,
    error,
    lastSubmission,
    vehicles,
    drivers,
    mastersStatus,
    mastersError,
    departureNumber,
  ];
}
