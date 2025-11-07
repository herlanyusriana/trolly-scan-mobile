// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileUser _$MobileUserFromJson(Map<String, dynamic> json) {
  return _MobileUser.fromJson(json);
}

/// @nodoc
mixin _$MobileUser {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get shift => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  /// Serializes this MobileUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileUserCopyWith<MobileUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileUserCopyWith<$Res> {
  factory $MobileUserCopyWith(
    MobileUser value,
    $Res Function(MobileUser) then,
  ) = _$MobileUserCopyWithImpl<$Res, MobileUser>;
  @useResult
  $Res call({
    int id,
    String name,
    String? phone,
    String? email,
    String status,
    String? shift,
    String? token,
  });
}

/// @nodoc
class _$MobileUserCopyWithImpl<$Res, $Val extends MobileUser>
    implements $MobileUserCopyWith<$Res> {
  _$MobileUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? status = null,
    Object? shift = freezed,
    Object? token = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String?,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileUserImplCopyWith<$Res>
    implements $MobileUserCopyWith<$Res> {
  factory _$$MobileUserImplCopyWith(
    _$MobileUserImpl value,
    $Res Function(_$MobileUserImpl) then,
  ) = __$$MobileUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? phone,
    String? email,
    String status,
    String? shift,
    String? token,
  });
}

/// @nodoc
class __$$MobileUserImplCopyWithImpl<$Res>
    extends _$MobileUserCopyWithImpl<$Res, _$MobileUserImpl>
    implements _$$MobileUserImplCopyWith<$Res> {
  __$$MobileUserImplCopyWithImpl(
    _$MobileUserImpl _value,
    $Res Function(_$MobileUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? status = null,
    Object? shift = freezed,
    Object? token = freezed,
  }) {
    return _then(
      _$MobileUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String?,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileUserImpl implements _MobileUser {
  const _$MobileUserImpl({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.status,
    this.shift,
    this.token,
  });

  factory _$MobileUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileUserImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String status;
  @override
  final String? shift;
  @override
  final String? token;

  @override
  String toString() {
    return 'MobileUser(id: $id, name: $name, phone: $phone, email: $email, status: $status, shift: $shift, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, phone, email, status, shift, token);

  /// Create a copy of MobileUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileUserImplCopyWith<_$MobileUserImpl> get copyWith =>
      __$$MobileUserImplCopyWithImpl<_$MobileUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileUserImplToJson(this);
  }
}

abstract class _MobileUser implements MobileUser {
  const factory _MobileUser({
    required final int id,
    required final String name,
    final String? phone,
    final String? email,
    required final String status,
    final String? shift,
    final String? token,
  }) = _$MobileUserImpl;

  factory _MobileUser.fromJson(Map<String, dynamic> json) =
      _$MobileUserImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String get status;
  @override
  String? get shift;
  @override
  String? get token;

  /// Create a copy of MobileUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileUserImplCopyWith<_$MobileUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
