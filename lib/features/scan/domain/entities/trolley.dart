import 'package:freezed_annotation/freezed_annotation.dart';

part 'trolley.freezed.dart';
part 'trolley.g.dart';

@freezed
class Trolley with _$Trolley {
  const factory Trolley({
    required int id,
    required String code,
    required String type,
    String? kind,
    required String status,
    String? location,
  }) = _Trolley;

  factory Trolley.fromJson(Map<String, dynamic> json) =>
      _$TrolleyFromJson(json);
}
