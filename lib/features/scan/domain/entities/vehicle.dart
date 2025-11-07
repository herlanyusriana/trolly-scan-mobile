import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

String _idFromJson(Object? value) => value?.toString() ?? '';
Object _idToJson(String value) => value;

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    @JsonKey(fromJson: _idFromJson, toJson: _idToJson) required String id,
    @JsonKey(name: 'plate_number') required String plateNumber,
    String? name,
    String? category,
    required String status,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}
