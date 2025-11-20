import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

String _idFromJson(Object? value) => value?.toString() ?? '';
Object _idToJson(String value) => value;

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String plateNumber,
    String? name,
    String? category,
    required String status,
  }) = _Vehicle;

  // ignore: unused_element
  const Vehicle._();

  @override
  @JsonKey(fromJson: _idFromJson, toJson: _idToJson)
  String get id;

  @override
  @JsonKey(name: 'plate_number')
  String get plateNumber;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}
