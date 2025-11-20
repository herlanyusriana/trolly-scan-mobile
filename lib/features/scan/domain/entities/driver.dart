import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver.freezed.dart';
part 'driver.g.dart';

String _idFromJson(Object? value) => value?.toString() ?? '';
Object _idToJson(String value) => value;

@freezed
class Driver with _$Driver {
  const factory Driver({
    required String id,
    required String name,
    String? phone,
    String? licenseNumber,
    required String status,
  }) = _Driver;

  // ignore: unused_element
  const Driver._();

  @override
  @JsonKey(fromJson: _idFromJson, toJson: _idToJson)
  String get id;

  @override
  @JsonKey(name: 'license_number')
  String? get licenseNumber;

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
}
