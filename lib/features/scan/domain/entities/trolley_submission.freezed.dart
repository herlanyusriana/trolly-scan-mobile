// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trolley_submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrolleySubmission _$TrolleySubmissionFromJson(Map<String, dynamic> json) {
  return _TrolleySubmission.fromJson(json);
}

/// @nodoc
mixin _$TrolleySubmission {
  List<String> get trolleyCodes => throw _privateConstructorUsedError;
  String? get vehicleId => throw _privateConstructorUsedError;
  String? get driverId => throw _privateConstructorUsedError;
  String? get vehicleSnapshot => throw _privateConstructorUsedError;
  String? get driverSnapshot => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get sequenceNumber => throw _privateConstructorUsedError;
  List<MovementReceipt> get receipts => throw _privateConstructorUsedError;
  bool? get uploaded => throw _privateConstructorUsedError;

  /// Serializes this TrolleySubmission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrolleySubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrolleySubmissionCopyWith<TrolleySubmission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrolleySubmissionCopyWith<$Res> {
  factory $TrolleySubmissionCopyWith(
    TrolleySubmission value,
    $Res Function(TrolleySubmission) then,
  ) = _$TrolleySubmissionCopyWithImpl<$Res, TrolleySubmission>;
  @useResult
  $Res call({
    List<String> trolleyCodes,
    String? vehicleId,
    String? driverId,
    String? vehicleSnapshot,
    String? driverSnapshot,
    String? destination,
    String status,
    DateTime createdAt,
    int? sequenceNumber,
    List<MovementReceipt> receipts,
    bool? uploaded,
  });
}

/// @nodoc
class _$TrolleySubmissionCopyWithImpl<$Res, $Val extends TrolleySubmission>
    implements $TrolleySubmissionCopyWith<$Res> {
  _$TrolleySubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrolleySubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trolleyCodes = null,
    Object? vehicleId = freezed,
    Object? driverId = freezed,
    Object? vehicleSnapshot = freezed,
    Object? driverSnapshot = freezed,
    Object? destination = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? sequenceNumber = freezed,
    Object? receipts = null,
    Object? uploaded = freezed,
  }) {
    return _then(
      _value.copyWith(
            trolleyCodes: null == trolleyCodes
                ? _value.trolleyCodes
                : trolleyCodes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            vehicleId: freezed == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverId: freezed == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleSnapshot: freezed == vehicleSnapshot
                ? _value.vehicleSnapshot
                : vehicleSnapshot // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverSnapshot: freezed == driverSnapshot
                ? _value.driverSnapshot
                : driverSnapshot // ignore: cast_nullable_to_non_nullable
                      as String?,
            destination: freezed == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sequenceNumber: freezed == sequenceNumber
                ? _value.sequenceNumber
                : sequenceNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            receipts: null == receipts
                ? _value.receipts
                : receipts // ignore: cast_nullable_to_non_nullable
                      as List<MovementReceipt>,
            uploaded: freezed == uploaded
                ? _value.uploaded
                : uploaded // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrolleySubmissionImplCopyWith<$Res>
    implements $TrolleySubmissionCopyWith<$Res> {
  factory _$$TrolleySubmissionImplCopyWith(
    _$TrolleySubmissionImpl value,
    $Res Function(_$TrolleySubmissionImpl) then,
  ) = __$$TrolleySubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> trolleyCodes,
    String? vehicleId,
    String? driverId,
    String? vehicleSnapshot,
    String? driverSnapshot,
    String? destination,
    String status,
    DateTime createdAt,
    int? sequenceNumber,
    List<MovementReceipt> receipts,
    bool? uploaded,
  });
}

/// @nodoc
class __$$TrolleySubmissionImplCopyWithImpl<$Res>
    extends _$TrolleySubmissionCopyWithImpl<$Res, _$TrolleySubmissionImpl>
    implements _$$TrolleySubmissionImplCopyWith<$Res> {
  __$$TrolleySubmissionImplCopyWithImpl(
    _$TrolleySubmissionImpl _value,
    $Res Function(_$TrolleySubmissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrolleySubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trolleyCodes = null,
    Object? vehicleId = freezed,
    Object? driverId = freezed,
    Object? vehicleSnapshot = freezed,
    Object? driverSnapshot = freezed,
    Object? destination = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? sequenceNumber = freezed,
    Object? receipts = null,
    Object? uploaded = freezed,
  }) {
    return _then(
      _$TrolleySubmissionImpl(
        trolleyCodes: null == trolleyCodes
            ? _value._trolleyCodes
            : trolleyCodes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        vehicleId: freezed == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverId: freezed == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleSnapshot: freezed == vehicleSnapshot
            ? _value.vehicleSnapshot
            : vehicleSnapshot // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverSnapshot: freezed == driverSnapshot
            ? _value.driverSnapshot
            : driverSnapshot // ignore: cast_nullable_to_non_nullable
                  as String?,
        destination: freezed == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sequenceNumber: freezed == sequenceNumber
            ? _value.sequenceNumber
            : sequenceNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        receipts: null == receipts
            ? _value._receipts
            : receipts // ignore: cast_nullable_to_non_nullable
                  as List<MovementReceipt>,
        uploaded: freezed == uploaded
            ? _value.uploaded
            : uploaded // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrolleySubmissionImpl implements _TrolleySubmission {
  const _$TrolleySubmissionImpl({
    required final List<String> trolleyCodes,
    this.vehicleId,
    this.driverId,
    this.vehicleSnapshot,
    this.driverSnapshot,
    this.destination,
    required this.status,
    required this.createdAt,
    this.sequenceNumber,
    final List<MovementReceipt> receipts = const <MovementReceipt>[],
    this.uploaded,
  }) : _trolleyCodes = trolleyCodes,
       _receipts = receipts;

  factory _$TrolleySubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrolleySubmissionImplFromJson(json);

  final List<String> _trolleyCodes;
  @override
  List<String> get trolleyCodes {
    if (_trolleyCodes is EqualUnmodifiableListView) return _trolleyCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trolleyCodes);
  }

  @override
  final String? vehicleId;
  @override
  final String? driverId;
  @override
  final String? vehicleSnapshot;
  @override
  final String? driverSnapshot;
  @override
  final String? destination;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final int? sequenceNumber;
  final List<MovementReceipt> _receipts;
  @override
  @JsonKey()
  List<MovementReceipt> get receipts {
    if (_receipts is EqualUnmodifiableListView) return _receipts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receipts);
  }

  @override
  final bool? uploaded;

  @override
  String toString() {
    return 'TrolleySubmission(trolleyCodes: $trolleyCodes, vehicleId: $vehicleId, driverId: $driverId, vehicleSnapshot: $vehicleSnapshot, driverSnapshot: $driverSnapshot, destination: $destination, status: $status, createdAt: $createdAt, sequenceNumber: $sequenceNumber, receipts: $receipts, uploaded: $uploaded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrolleySubmissionImpl &&
            const DeepCollectionEquality().equals(
              other._trolleyCodes,
              _trolleyCodes,
            ) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.vehicleSnapshot, vehicleSnapshot) ||
                other.vehicleSnapshot == vehicleSnapshot) &&
            (identical(other.driverSnapshot, driverSnapshot) ||
                other.driverSnapshot == driverSnapshot) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sequenceNumber, sequenceNumber) ||
                other.sequenceNumber == sequenceNumber) &&
            const DeepCollectionEquality().equals(other._receipts, _receipts) &&
            (identical(other.uploaded, uploaded) ||
                other.uploaded == uploaded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_trolleyCodes),
    vehicleId,
    driverId,
    vehicleSnapshot,
    driverSnapshot,
    destination,
    status,
    createdAt,
    sequenceNumber,
    const DeepCollectionEquality().hash(_receipts),
    uploaded,
  );

  /// Create a copy of TrolleySubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrolleySubmissionImplCopyWith<_$TrolleySubmissionImpl> get copyWith =>
      __$$TrolleySubmissionImplCopyWithImpl<_$TrolleySubmissionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrolleySubmissionImplToJson(this);
  }
}

abstract class _TrolleySubmission implements TrolleySubmission {
  const factory _TrolleySubmission({
    required final List<String> trolleyCodes,
    final String? vehicleId,
    final String? driverId,
    final String? vehicleSnapshot,
    final String? driverSnapshot,
    final String? destination,
    required final String status,
    required final DateTime createdAt,
    final int? sequenceNumber,
    final List<MovementReceipt> receipts,
    final bool? uploaded,
  }) = _$TrolleySubmissionImpl;

  factory _TrolleySubmission.fromJson(Map<String, dynamic> json) =
      _$TrolleySubmissionImpl.fromJson;

  @override
  List<String> get trolleyCodes;
  @override
  String? get vehicleId;
  @override
  String? get driverId;
  @override
  String? get vehicleSnapshot;
  @override
  String? get driverSnapshot;
  @override
  String? get destination;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  int? get sequenceNumber;
  @override
  List<MovementReceipt> get receipts;
  @override
  bool? get uploaded;

  /// Create a copy of TrolleySubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrolleySubmissionImplCopyWith<_$TrolleySubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
