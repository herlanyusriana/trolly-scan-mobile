import 'package:equatable/equatable.dart';

class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

class ScanCodeAdded extends ScanEvent {
  const ScanCodeAdded(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class ScanCodeRemoved extends ScanEvent {
  const ScanCodeRemoved(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class ScanCleared extends ScanEvent {
  const ScanCleared();
}

class ScanSubmitted extends ScanEvent {
  const ScanSubmitted({
    required this.destination,
    this.vehicleId,
    this.driverId,
    this.vehicleSnapshot,
    this.driverSnapshot,
    required this.status,
  });

  final String destination;
  final String? vehicleId;
  final String? driverId;
  final String? vehicleSnapshot;
  final String? driverSnapshot;
  final String status;

  @override
  List<Object?> get props => [
    destination,
    vehicleId,
    driverId,
    vehicleSnapshot,
    driverSnapshot,
    status,
  ];
}

class ScanMastersRequested extends ScanEvent {
  const ScanMastersRequested();
}
