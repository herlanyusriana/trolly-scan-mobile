import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_user.freezed.dart';
part 'mobile_user.g.dart';

@freezed
class MobileUser with _$MobileUser {
  const factory MobileUser({
    required int id,
    required String name,
    String? phone,
    String? email,
    required String status,
    String? shift,
    String? token,
  }) = _MobileUser;

  factory MobileUser.fromJson(Map<String, dynamic> json) => _$MobileUserFromJson(json);
}
