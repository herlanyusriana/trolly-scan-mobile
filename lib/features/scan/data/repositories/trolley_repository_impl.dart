import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../domain/entities/trolley.dart';
import '../../domain/entities/trolley_submission.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/movement_receipt.dart';
import '../../domain/repositories/trolley_repository.dart';

class TrolleyRepositoryImpl implements TrolleyRepository {
  TrolleyRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<Either<String, List<Trolley>>> fetchAvailableTrolleys() async {
    try {
      final response = await _client.client.get<Map<String, dynamic>>(
        '/api/v1/trolleys',
      );
      final trolleys = (response.data?['data'] as List<dynamic>? ?? const [])
          .map((json) => Trolley.fromJson(json as Map<String, dynamic>))
          .toList();
      return right(trolleys);
    } on DioException catch (error) {
      return left(error.message ?? 'Gagal memuat troli.');
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, List<Vehicle>>> fetchVehicles() async {
    try {
      final response = await _client.client.get<Map<String, dynamic>>(
        '/api/v1/vehicles',
      );
      final vehicles = (response.data?['data'] as List<dynamic>? ?? const [])
          .map((json) => Vehicle.fromJson(json as Map<String, dynamic>))
          .toList();
      return right(vehicles);
    } on DioException catch (error) {
      return left(error.message ?? 'Gagal memuat kendaraan.');
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, List<Driver>>> fetchDrivers() async {
    try {
      final response = await _client.client.get<Map<String, dynamic>>(
        '/api/v1/drivers',
      );
      final drivers = (response.data?['data'] as List<dynamic>? ?? const [])
          .map((json) => Driver.fromJson(json as Map<String, dynamic>))
          .toList();
      return right(drivers);
    } on DioException catch (error) {
      return left(error.message ?? 'Gagal memuat driver.');
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, List<TrolleySubmission>>> fetchSubmissionHistory({
    int limit = 50,
  }) async {
    List<TrolleySubmission> parseList(dynamic data) {
      List<dynamic> list;
      if (data is Map<String, dynamic>) {
        final candidate = data['data'] ?? data['items'] ?? data['history'];
        list = candidate is List ? candidate : const [];
      } else if (data is List) {
        list = data;
      } else {
        list = const [];
      }

      List<TrolleySubmission> submissions = [];
      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;

        String? code;
        final trolley = item['trolley'];
        if (trolley is Map<String, dynamic>) {
          final c = trolley['code'];
          if (c is String) code = c;
        }
        if (code == null) {
          final c = item['trolley_code'] ?? item['code'];
          if (c is String) code = c;
        }

        List<String> trolleyCodes = <String>[];
        final codes = item['trolley_codes'];
        if (codes is List) {
          trolleyCodes = codes.whereType<String>().toList();
        } else if (code != null) {
          trolleyCodes = [code];
        }

        String status = (item['status'] as String?)?.toLowerCase() ?? 'unknown';
        final destination = (item['destination'] as String?) ??
            (item['location'] as String?);

        String? vehicleSnapshot;
        final vSnap = item['vehicle_snapshot'];
        if (vSnap is String && vSnap.isNotEmpty) vehicleSnapshot = vSnap;
        if (vehicleSnapshot == null && item['vehicle'] is Map<String, dynamic>) {
          final plate = (item['vehicle'] as Map<String, dynamic>)['plate_number'];
          if (plate is String && plate.isNotEmpty) vehicleSnapshot = plate;
        }

        String? driverSnapshot;
        final dSnap = item['driver_snapshot'];
        if (dSnap is String && dSnap.isNotEmpty) driverSnapshot = dSnap;
        if (driverSnapshot == null && item['driver'] is Map<String, dynamic>) {
          final name = (item['driver'] as Map<String, dynamic>)['name'];
          if (name is String && name.isNotEmpty) driverSnapshot = name;
        }

        int? sequenceNumber;
        final seq = item['sequence_number'];
        if (seq is int) sequenceNumber = seq;
        if (sequenceNumber == null && seq is String) {
          sequenceNumber = int.tryParse(seq);
        }

        DateTime? checkedOutAt;
        final co = item['checked_out_at'];
        if (co is String) checkedOutAt = DateTime.tryParse(co);

        DateTime? checkedInAt;
        final ci = item['checked_in_at'];
        if (ci is String) checkedInAt = DateTime.tryParse(ci);

        DateTime createdAt = DateTime.now();
        final createdRaw = item['created_at'];
        DateTime? createdParsed;
        if (createdRaw is String) createdParsed = DateTime.tryParse(createdRaw);
        createdAt = createdParsed ?? checkedInAt ?? checkedOutAt ?? createdAt;

        final receipts = <MovementReceipt>[];
        if (item['receipts'] is List) {
          for (final r in (item['receipts'] as List)) {
            if (r is! Map<String, dynamic>) continue;
            DateTime? rOut;
            if (r['checked_out_at'] is String) {
              rOut = DateTime.tryParse(r['checked_out_at'] as String);
            }
            DateTime? rIn;
            if (r['checked_in_at'] is String) {
              rIn = DateTime.tryParse(r['checked_in_at'] as String);
            }
            int? rSeq;
            final rSeqVal = r['sequence_number'];
            if (rSeqVal is int) rSeq = rSeqVal;
            if (rSeq == null && rSeqVal is String) rSeq = int.tryParse(rSeqVal);
            String rCode = code ?? (r['code'] as String? ?? '');
            receipts.add(
              MovementReceipt(
                code: rCode,
                status: (r['status'] as String?) ?? status,
                checkedOutAt: rOut,
                checkedInAt: rIn,
                sequenceNumber: rSeq,
                trolleyKind: r['trolley_kind'] as String?,
                destination: (r['destination'] as String?) ?? destination,
                vehicleSnapshot:
                    (r['vehicle_snapshot'] as String?) ?? vehicleSnapshot,
                driverSnapshot: (r['driver_snapshot'] as String?) ?? driverSnapshot,
              ),
            );
          }
        }

        if (receipts.isEmpty && (code != null || trolleyCodes.isNotEmpty)) {
          receipts.add(
            MovementReceipt(
              code: code ?? (trolleyCodes.isNotEmpty ? trolleyCodes.first : ''),
              status: status,
              checkedOutAt: checkedOutAt,
              checkedInAt: checkedInAt,
              sequenceNumber: sequenceNumber,
              destination: destination,
              vehicleSnapshot: vehicleSnapshot,
              driverSnapshot: driverSnapshot,
            ),
          );
        }

        submissions.add(
          TrolleySubmission(
            trolleyCodes: trolleyCodes,
            destination: destination,
            vehicleId: null,
            driverId: null,
            vehicleSnapshot: vehicleSnapshot,
            driverSnapshot: driverSnapshot,
            status: status,
            createdAt: createdAt,
            sequenceNumber: sequenceNumber,
            receipts: receipts,
            uploaded: true,
          ),
        );
      }

      submissions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return submissions;
    }

    final endpoints = <String>[
      '/api/v1/movements',
      '/api/v1/trolleys/movements',
      '/api/v1/history',
    ];
    for (final path in endpoints) {
      try {
        final response = await _client.client.get(
          path,
          queryParameters: {'limit': limit},
        );
        final data = response.data;
        final submissions = parseList(data);
        if (submissions.isNotEmpty) return right(submissions);
        // If empty but request succeeded, still return right([])
        return right(submissions);
      } on DioException {
        // try next endpoint
        continue;
      } catch (error) {
        return left(error.toString());
      }
    }
    return left('Gagal memuat riwayat dari server.');
  }

  @override
  Future<Either<String, TrolleySubmission>> submitMovement({
    required List<String> trolleyCodes,
    String? destination,
    String? vehicleId,
    String? driverId,
    String? vehicleSnapshot,
    String? driverSnapshot,
    required String status,
    int? departureNumber,
  }) async {
    try {
      final uniqueCodes = trolleyCodes
          .map((code) => code.trim().toUpperCase())
          .where((code) => code.isNotEmpty)
          .toSet()
          .toList();

      if (uniqueCodes.isEmpty) {
        return left('Tidak ada kode troli yang valid.');
      }

      final trolleyResponse = await _client.client.get<Map<String, dynamic>>(
        '/api/v1/trolleys',
      );
      final trolleys =
          (trolleyResponse.data?['data'] as List<dynamic>? ?? const [])
              .map((json) => Trolley.fromJson(json as Map<String, dynamic>))
              .toList();

      final codeToTrolley = {
        for (final trolley in trolleys)
          trolley.code.trim().toUpperCase(): trolley,
      };

      final codeToId = {
        for (final entry in codeToTrolley.entries) entry.key: entry.value.id,
      };

      final missingCodes = uniqueCodes
          .where((code) => !codeToId.containsKey(code))
          .toList();
      if (missingCodes.isNotEmpty) {
        return left('Troli tidak ditemukan: ${missingCodes.join(', ')}');
      }

      final normalizedStatus = status.toLowerCase();
      final trimmedDestination = destination?.trim();
      final trimmedVehicleSnapshot = vehicleSnapshot?.trim();
      final trimmedDriverSnapshot = driverSnapshot?.trim();

      if (normalizedStatus == 'out') {
        if (departureNumber == null) {
          return left('Nomor keberangkatan wajib diisi untuk status OUT.');
        }
        final alreadyOut = uniqueCodes
            .where((code) => codeToTrolley[code]?.status == 'out')
            .toList();
        if (alreadyOut.isNotEmpty) {
          return left(
            'Troli ${alreadyOut.join(', ')} masih berstatus OUT. Selesaikan proses check-in lebih dulu.',
          );
        }

        final internalCodes = uniqueCodes
            .where((code) => codeToTrolley[code]?.type == 'internal')
            .toList();
        if (internalCodes.isNotEmpty) {
          return left(
            'Troli ${internalCodes.join(', ')} adalah tipe internal dan tidak bisa melakukan OUT.',
          );
        }
      } else if (normalizedStatus == 'in') {
        final notOut = uniqueCodes
            .where((code) => codeToTrolley[code]?.status != 'out')
            .toList();
        if (notOut.isNotEmpty) {
          return left(
            'Troli ${notOut.join(', ')} belum melakukan checkout sehingga tidak bisa di-IN-kan.',
          );
        }
      }

      DateTime? submissionTime;
      int? sequenceNumber;
      final receipts = <MovementReceipt>[];

      for (final code in uniqueCodes) {
        final trolleyId = codeToId[code]!;
        final isOut = normalizedStatus == 'out';
        final endpoint =
            '/api/v1/trolleys/$trolleyId/${isOut ? 'checkout' : 'checkin'}';
        final payload = <String, dynamic>{
          if (isOut)
            'destination': trimmedDestination?.isNotEmpty == true
                ? trimmedDestination
                : 'Tidak diketahui',
          if (!isOut)
            'location': trimmedDestination?.isNotEmpty == true
                ? trimmedDestination
                : 'Tidak diketahui',
          if (isOut) 'expected_return_at': null,
          if (isOut && departureNumber != null)
            'sequence_number': departureNumber,
          if (vehicleId != null)
            'vehicle_id': int.tryParse(vehicleId) ?? vehicleId,
          if (driverId != null) 'driver_id': int.tryParse(driverId) ?? driverId,
          if (trimmedVehicleSnapshot != null &&
              trimmedVehicleSnapshot.isNotEmpty)
            'vehicle_snapshot': trimmedVehicleSnapshot,
          if (trimmedDriverSnapshot != null && trimmedDriverSnapshot.isNotEmpty)
            'driver_snapshot': trimmedDriverSnapshot,
        };

        final response = await _client.client.post<Map<String, dynamic>>(
          endpoint,
          data: payload,
        );

        final body = response.data;
        final movement = body?['data'] as Map<String, dynamic>? ?? body;

        if (movement != null) {
          String? readField(String key) {
            final value = movement[key];
            return value is String ? value : null;
          }

          final sequenceValue = movement['sequence_number'];
          int? parsedSequence;
          if (sequenceValue is int) {
            parsedSequence = sequenceValue;
          } else if (sequenceValue is String) {
            parsedSequence = int.tryParse(sequenceValue);
          }
          sequenceNumber ??= parsedSequence;

          final checkedOutAtRaw = readField('checked_out_at');
          final checkedInAtRaw = readField('checked_in_at');
          final checkedOutAt = checkedOutAtRaw != null
              ? DateTime.tryParse(checkedOutAtRaw)
              : null;
          final checkedInAt = checkedInAtRaw != null
              ? DateTime.tryParse(checkedInAtRaw)
              : null;

          final parsedTimestamp = isOut
              ? checkedOutAt
              : checkedInAt ?? checkedOutAt;
          submissionTime ??= parsedTimestamp;

          final statusValue =
              (movement['status'] as String?) ?? normalizedStatus;
          final destinationValue = isOut
              ? readField('destination') ?? trimmedDestination
              : trimmedDestination ?? readField('destination');
          final vehicleSnapshotValue =
              readField('vehicle_snapshot') ??
              (movement['vehicle'] is Map<String, dynamic>
                  ? (movement['vehicle']
                            as Map<String, dynamic>)['plate_number']
                        as String?
                  : null) ??
              trimmedVehicleSnapshot;
          final driverSnapshotValue =
              readField('driver_snapshot') ??
              (movement['driver'] is Map<String, dynamic>
                  ? (movement['driver'] as Map<String, dynamic>)['name']
                        as String?
                  : null) ??
              trimmedDriverSnapshot;

          String? trolleyKindLabel;
          final trolleyData = movement['trolley'];
          if (trolleyData is Map<String, dynamic>) {
            final kind = trolleyData['kind'] as String?;
            switch (kind) {
              case 'reinforce':
                trolleyKindLabel = 'Reinforce';
                break;
              case 'backplate':
                trolleyKindLabel = 'Backplate';
                break;
              case 'compbase':
                trolleyKindLabel = 'CompBase';
                break;
              default:
                trolleyKindLabel = kind;
            }
          }

          receipts.add(
            MovementReceipt(
              code: code,
              status: statusValue,
              sequenceNumber: parsedSequence,
              trolleyKind: trolleyKindLabel,
              checkedOutAt: checkedOutAt,
              checkedInAt: checkedInAt,
              destination: destinationValue,
              vehicleSnapshot: vehicleSnapshotValue,
              driverSnapshot: driverSnapshotValue,
            ),
          );
        }
      }

      final submission = TrolleySubmission(
        trolleyCodes: uniqueCodes,
        destination: trimmedDestination,
        vehicleId: vehicleId,
        driverId: driverId,
        vehicleSnapshot: trimmedVehicleSnapshot,
        driverSnapshot: trimmedDriverSnapshot,
        status: normalizedStatus,
        createdAt: submissionTime ?? DateTime.now(),
        sequenceNumber: sequenceNumber,
        receipts: receipts,
        uploaded: true,
      );

      return right(submission);
    } on DioException catch (error) {
      final data = error.response?.data;
      final detail = data is Map<String, dynamic> ? data['message'] : null;
      final message = detail is String && detail.isNotEmpty
          ? detail
          : error.message ?? 'Gagal mengirim data.';

      return left(message);
    } catch (error) {
      return left(error.toString());
    }
  }
}
