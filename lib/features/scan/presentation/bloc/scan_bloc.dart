import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/trolley_submission.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/trolley_repository.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc(this._repository) : super(const ScanState()) {
    on<ScanCodeAdded>(_onCodeAdded);
    on<ScanCodeRemoved>(_onCodeRemoved);
    on<ScanCleared>(_onCleared);
    on<ScanSubmitted>(_onSubmitted);
    on<ScanMastersRequested>(_onMastersRequested);
  }

  final TrolleyRepository _repository;

  void _onCodeAdded(ScanCodeAdded event, Emitter<ScanState> emit) {
    if (state.scannedCodes.contains(event.code)) {
      return;
    }
    final updated = List<String>.from(state.scannedCodes)..add(event.code);
    emit(state.copyWith(scannedCodes: updated, status: ScanStatus.ready));
  }

  void _onCodeRemoved(ScanCodeRemoved event, Emitter<ScanState> emit) {
    final updated = List<String>.from(state.scannedCodes)..remove(event.code);
    emit(
      state.copyWith(
        scannedCodes: updated,
        status: updated.isEmpty ? ScanStatus.idle : ScanStatus.ready,
      ),
    );
  }

  void _onCleared(ScanCleared event, Emitter<ScanState> emit) {
    emit(state.copyWith(scannedCodes: [], status: ScanStatus.idle));
  }

  Future<void> _onMastersRequested(
    ScanMastersRequested event,
    Emitter<ScanState> emit,
  ) async {
    if (state.mastersStatus == MasterStatus.loading) return;
    if (state.mastersStatus == MasterStatus.success &&
        state.vehicles.isNotEmpty &&
        state.drivers.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(mastersStatus: MasterStatus.loading, mastersError: null),
    );

    final vehiclesResult = await _repository.fetchVehicles();
    final driversResult = await _repository.fetchDrivers();

    List<Vehicle> vehicles = state.vehicles;
    List<Driver> drivers = state.drivers;
    String? error;

    vehiclesResult.match((err) => error = err, (data) => vehicles = data);

    driversResult.match(
      (err) => error = error ?? err,
      (data) => drivers = data,
    );

    if (error != null) {
      emit(
        state.copyWith(
          mastersStatus: MasterStatus.failure,
          mastersError: error,
          vehicles: vehicles,
          drivers: drivers,
        ),
      );
    } else {
      emit(
        state.copyWith(
          mastersStatus: MasterStatus.success,
          mastersError: null,
          vehicles: vehicles,
          drivers: drivers,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    ScanSubmitted event,
    Emitter<ScanState> emit,
  ) async {
    if (state.scannedCodes.isEmpty) return;

    emit(state.copyWith(status: ScanStatus.submitting));

    final Either<String, TrolleySubmission> result = await _repository
        .submitMovement(
          trolleyCodes: state.scannedCodes,
          destination: event.destination,
          vehicleId: event.vehicleId,
          driverId: event.driverId,
          vehicleSnapshot: event.vehicleSnapshot,
          driverSnapshot: event.driverSnapshot,
          status: event.status,
        );

    result.match(
      (error) {
        emit(
          state.copyWith(
            status: ScanStatus.failure,
            error: error,
            scannedCodes: state.scannedCodes,
            lastSubmission: state.lastSubmission,
          ),
        );
      },
      (submission) {
        emit(
          state.copyWith(
            status: ScanStatus.success,
            scannedCodes: const <String>[],
            lastSubmission: submission,
            error: null,
          ),
        );
      },
    );
  }
}
