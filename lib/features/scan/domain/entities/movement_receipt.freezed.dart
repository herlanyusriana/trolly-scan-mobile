// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movement_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MovementReceipt _$MovementReceiptFromJson(Map<String, dynamic> json) {
  return _MovementReceipt.fromJson(json);
}

/// @nodoc
mixin _$MovementReceipt {
  String get code => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get checkedOutAt => throw _privateConstructorUsedError;
  DateTime? get checkedInAt => throw _privateConstructorUsedError;
  int? get sequenceNumber => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  String? get vehicleSnapshot => throw _privateConstructorUsedError;
  String? get driverSnapshot => throw _privateConstructorUsedError;

  /// Serializes this MovementReceipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MovementReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovementReceiptCopyWith<MovementReceipt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementReceiptCopyWith<$Res> {
  factory $MovementReceiptCopyWith(
    MovementReceipt value,
    $Res Function(MovementReceipt) then,
  ) = _$MovementReceiptCopyWithImpl<$Res, MovementReceipt>;
  @useResult
  $Res call({
    String code,
    String status,
    DateTime? checkedOutAt,
    DateTime? checkedInAt,
    int? sequenceNumber,
    String? destination,
    String? vehicleSnapshot,
    String? driverSnapshot,
  });
}

/// @nodoc
class _$MovementReceiptCopyWithImpl<$Res, $Val extends MovementReceipt>
    implements $MovementReceiptCopyWith<$Res> {
  _$MovementReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovementReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? status = null,
    Object? checkedOutAt = freezed,
    Object? checkedInAt = freezed,
    Object? sequenceNumber = freezed,
    Object? destination = freezed,
    Object? vehicleSnapshot = freezed,
    Object? driverSnapshot = freezed,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            checkedOutAt: freezed == checkedOutAt
                ? _value.checkedOutAt
                : checkedOutAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            checkedInAt: freezed == checkedInAt
                ? _value.checkedInAt
                : checkedInAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sequenceNumber: freezed == sequenceNumber
                ? _value.sequenceNumber
                : sequenceNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            destination: freezed == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleSnapshot: freezed == vehicleSnapshot
                ? _value.vehicleSnapshot
                : vehicleSnapshot // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverSnapshot: freezed == driverSnapshot
                ? _value.driverSnapshot
                : driverSnapshot // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MovementReceiptImplCopyWith<$Res>
    implements $MovementReceiptCopyWith<$Res> {
  factory _$$MovementReceiptImplCopyWith(
    _$MovementReceiptImpl value,
    $Res Function(_$MovementReceiptImpl) then,
  ) = __$$MovementReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String code,
    String status,
    DateTime? checkedOutAt,
    DateTime? checkedInAt,
    int? sequenceNumber,
    String? destination,
    String? vehicleSnapshot,
    String? driverSnapshot,
  });
}

/// @nodoc
class __$$MovementReceiptImplCopyWithImpl<$Res>
    extends _$MovementReceiptCopyWithImpl<$Res, _$MovementReceiptImpl>
    implements _$$MovementReceiptImplCopyWith<$Res> {
  __$$MovementReceiptImplCopyWithImpl(
    _$MovementReceiptImpl _value,
    $Res Function(_$MovementReceiptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MovementReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? status = null,
    Object? checkedOutAt = freezed,
    Object? checkedInAt = freezed,
    Object? sequenceNumber = freezed,
    Object? destination = freezed,
    Object? vehicleSnapshot = freezed,
    Object? driverSnapshot = freezed,
  }) {
    return _then(
      _$MovementReceiptImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        checkedOutAt: freezed == checkedOutAt
            ? _value.checkedOutAt
            : checkedOutAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        checkedInAt: freezed == checkedInAt
            ? _value.checkedInAt
            : checkedInAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sequenceNumber: freezed == sequenceNumber
            ? _value.sequenceNumber
            : sequenceNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        destination: freezed == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleSnapshot: freezed == vehicleSnapshot
            ? _value.vehicleSnapshot
            : vehicleSnapshot // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverSnapshot: freezed == driverSnapshot
            ? _value.driverSnapshot
            : driverSnapshot // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MovementReceiptImpl implements _MovementReceipt {
  const _$MovementReceiptImpl({
    required this.code,
    required this.status,
    this.checkedOutAt,
    this.checkedInAt,
    this.sequenceNumber,
    this.destination,
    this.vehicleSnapshot,
    this.driverSnapshot,
  });

  factory _$MovementReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovementReceiptImplFromJson(json);

  @override
  final String code;
  @override
  final String status;
  @override
  final DateTime? checkedOutAt;
  @override
  final DateTime? checkedInAt;
  @override
  final int? sequenceNumber;
  @override
  final String? destination;
  @override
  final String? vehicleSnapshot;
  @override
  final String? driverSnapshot;

  @override
  String toString() {
    return 'MovementReceipt(code: $code, status: $status, checkedOutAt: $checkedOutAt, checkedInAt: $checkedInAt, sequenceNumber: $sequenceNumber, destination: $destination, vehicleSnapshot: $vehicleSnapshot, driverSnapshot: $driverSnapshot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovementReceiptImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.checkedOutAt, checkedOutAt) ||
                other.checkedOutAt == checkedOutAt) &&
            (identical(other.checkedInAt, checkedInAt) ||
                other.checkedInAt == checkedInAt) &&
            (identical(other.sequenceNumber, sequenceNumber) ||
                other.sequenceNumber == sequenceNumber) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.vehicleSnapshot, vehicleSnapshot) ||
                other.vehicleSnapshot == vehicleSnapshot) &&
            (identical(other.driverSnapshot, driverSnapshot) ||
                other.driverSnapshot == driverSnapshot));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    status,
    checkedOutAt,
    checkedInAt,
    sequenceNumber,
    destination,
    vehicleSnapshot,
    driverSnapshot,
  );

  /// Create a copy of MovementReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovementReceiptImplCopyWith<_$MovementReceiptImpl> get copyWith =>
      __$$MovementReceiptImplCopyWithImpl<_$MovementReceiptImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MovementReceiptImplToJson(this);
  }
}

abstract class _MovementReceipt implements MovementReceipt {
  const factory _MovementReceipt({
    required final String code,
    required final String status,
    final DateTime? checkedOutAt,
    final DateTime? checkedInAt,
    final int? sequenceNumber,
    final String? destination,
    final String? vehicleSnapshot,
    final String? driverSnapshot,
  }) = _$MovementReceiptImpl;

  factory _MovementReceipt.fromJson(Map<String, dynamic> json) =
      _$MovementReceiptImpl.fromJson;

  @override
  String get code;
  @override
  String get status;
  @override
  DateTime? get checkedOutAt;
  @override
  DateTime? get checkedInAt;
  @override
  int? get sequenceNumber;
  @override
  String? get destination;
  @override
  String? get vehicleSnapshot;
  @override
  String? get driverSnapshot;

  /// Create a copy of MovementReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovementReceiptImplCopyWith<_$MovementReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
