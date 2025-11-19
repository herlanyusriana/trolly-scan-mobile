import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/storage/session_storage.dart';
import '../../domain/entities/trolley_submission.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/trolley_repository.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc(this._repository, this._sessionStorage) : super(const ScanState()) {
    on<ScanCodeAdded>(_onCodeAdded);
    on<ScanCodeRemoved>(_onCodeRemoved);
    on<ScanCleared>(_onCleared);
    on<ScanSubmitted>(_onSubmitted);
    on<ScanMastersRequested>(_onMastersRequested);
    on<ScanSessionRestored>(_onSessionRestored);
    on<ScanDepartureNumberChanged>(_onDepartureNumberChanged);
  }

  final TrolleyRepository _repository;
  final SessionStorage _sessionStorage;

  Future<void> _onCodeAdded(
    ScanCodeAdded event,
    Emitter<ScanState> emit,
  ) async {
    if (state.scannedCodes.contains(event.code)) {
      return;
    }
    final updated = List<String>.from(state.scannedCodes)..add(event.code);
    emit(state.copyWith(scannedCodes: updated, status: ScanStatus.ready));
    await _sessionStorage.savePendingScanCodes(updated);
  }

  Future<void> _onCodeRemoved(
    ScanCodeRemoved event,
    Emitter<ScanState> emit,
  ) async {
    final updated = List<String>.from(state.scannedCodes)..remove(event.code);
    emit(
      state.copyWith(
        scannedCodes: updated,
        status: updated.isEmpty ? ScanStatus.idle : ScanStatus.ready,
      ),
    );
    await _sessionStorage.savePendingScanCodes(updated);
  }

  Future<void> _onCleared(ScanCleared event, Emitter<ScanState> emit) async {
    emit(state.copyWith(scannedCodes: [], status: ScanStatus.idle));
    await _sessionStorage.clearPendingScanCodes();
  }

  Future<void> _onDepartureNumberChanged(
    ScanDepartureNumberChanged event,
    Emitter<ScanState> emit,
  ) async {
    emit(state.copyWith(departureNumber: event.departureNumber));
    if (event.departureNumber != null) {
      await _sessionStorage.saveDepartureNumber(event.departureNumber!);
    } else {
      await _sessionStorage.clearDepartureNumber();
    }
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
          departureNumber: event.departureNumber,
        );

    await result.match<Future<void>>(
      (error) async {
        emit(
          state.copyWith(
            status: ScanStatus.failure,
            error: error,
            scannedCodes: state.scannedCodes,
            lastSubmission: state.lastSubmission,
          ),
        );
      },
      (submission) async {
        emit(
          state.copyWith(
            status: ScanStatus.success,
            scannedCodes: const <String>[],
            lastSubmission: submission,
            error: null,
            departureNumber: null,
          ),
        );
        await _sessionStorage.clearPendingScanCodes();
        await _sessionStorage.clearDepartureNumber();
        await _sessionStorage.prependSubmission(submission);
      },
    );
  }

  Future<void> _onSessionRestored(
    ScanSessionRestored event,
    Emitter<ScanState> emit,
  ) async {
    final savedCodes = _sessionStorage.readPendingScanCodes();
    final savedDeparture = _sessionStorage.readDepartureNumber();
    emit(
      state.copyWith(
        scannedCodes: savedCodes,
        status: savedCodes.isEmpty ? ScanStatus.idle : ScanStatus.ready,
        departureNumber: savedDeparture,
      ),
    );
  }
}

extension ScanBlocX on ScanBloc {
  void restoreSession() {
    add(const ScanSessionRestored());
  }
}
