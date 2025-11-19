import 'package:fpdart/fpdart.dart';

import '../../domain/entities/trolley.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/trolley_submission.dart';

abstract class TrolleyRepository {
  Future<Either<String, List<Trolley>>> fetchAvailableTrolleys();
  Future<Either<String, List<Vehicle>>> fetchVehicles();
  Future<Either<String, List<Driver>>> fetchDrivers();

  Future<Either<String, TrolleySubmission>> submitMovement({
    required List<String> trolleyCodes,
    String? destination,
    String? vehicleId,
    String? driverId,
    String? vehicleSnapshot,
    String? driverSnapshot,
    required String status, // 'in' atau 'out'
    required int departureNumber,
  });
}
