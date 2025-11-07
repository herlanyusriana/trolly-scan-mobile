import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver.freezed.dart';
part 'driver.g.dart';

String _idFromJson(Object? value) => value?.toString() ?? '';
Object _idToJson(String value) => value;

@freezed
class Driver with _$Driver {
  const factory Driver({
    @JsonKey(fromJson: _idFromJson, toJson: _idToJson) required String id,
    required String name,
    String? phone,
    @JsonKey(name: 'license_number') String? licenseNumber,
    required String status,
  }) = _Driver;

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
}
