// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_tour_booking_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateTourBookingResponse _$CreateTourBookingResponseFromJson(
  Map<String, dynamic> json,
) {
  return _CreateTourBookingResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateTourBookingResponse {
  TourBookingData get data => throw _privateConstructorUsedError;

  /// Serializes this CreateTourBookingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTourBookingResponseCopyWith<CreateTourBookingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTourBookingResponseCopyWith<$Res> {
  factory $CreateTourBookingResponseCopyWith(
    CreateTourBookingResponse value,
    $Res Function(CreateTourBookingResponse) then,
  ) = _$CreateTourBookingResponseCopyWithImpl<$Res, CreateTourBookingResponse>;
  @useResult
  $Res call({TourBookingData data});

  $TourBookingDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CreateTourBookingResponseCopyWithImpl<
  $Res,
  $Val extends CreateTourBookingResponse
>
    implements $CreateTourBookingResponseCopyWith<$Res> {
  _$CreateTourBookingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as TourBookingData,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TourBookingDataCopyWith<$Res> get data {
    return $TourBookingDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateTourBookingResponseImplCopyWith<$Res>
    implements $CreateTourBookingResponseCopyWith<$Res> {
  factory _$$CreateTourBookingResponseImplCopyWith(
    _$CreateTourBookingResponseImpl value,
    $Res Function(_$CreateTourBookingResponseImpl) then,
  ) = __$$CreateTourBookingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TourBookingData data});

  @override
  $TourBookingDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CreateTourBookingResponseImplCopyWithImpl<$Res>
    extends
        _$CreateTourBookingResponseCopyWithImpl<
          $Res,
          _$CreateTourBookingResponseImpl
        >
    implements _$$CreateTourBookingResponseImplCopyWith<$Res> {
  __$$CreateTourBookingResponseImplCopyWithImpl(
    _$CreateTourBookingResponseImpl _value,
    $Res Function(_$CreateTourBookingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$CreateTourBookingResponseImpl(
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as TourBookingData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTourBookingResponseImpl implements _CreateTourBookingResponse {
  const _$CreateTourBookingResponseImpl({required this.data});

  factory _$CreateTourBookingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTourBookingResponseImplFromJson(json);

  @override
  final TourBookingData data;

  @override
  String toString() {
    return 'CreateTourBookingResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTourBookingResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTourBookingResponseImplCopyWith<_$CreateTourBookingResponseImpl>
  get copyWith =>
      __$$CreateTourBookingResponseImplCopyWithImpl<
        _$CreateTourBookingResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTourBookingResponseImplToJson(this);
  }
}

abstract class _CreateTourBookingResponse implements CreateTourBookingResponse {
  const factory _CreateTourBookingResponse({
    required final TourBookingData data,
  }) = _$CreateTourBookingResponseImpl;

  factory _CreateTourBookingResponse.fromJson(Map<String, dynamic> json) =
      _$CreateTourBookingResponseImpl.fromJson;

  @override
  TourBookingData get data;

  /// Create a copy of CreateTourBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTourBookingResponseImplCopyWith<_$CreateTourBookingResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TourBookingData _$TourBookingDataFromJson(Map<String, dynamic> json) {
  return _TourBookingData.fromJson(json);
}

/// @nodoc
mixin _$TourBookingData {
  String get id => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get specialRequests => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double get pricePerAdultAtBooking => throw _privateConstructorUsedError;
  double get pricePerChildAtBooking => throw _privateConstructorUsedError;
  String? get paymentDeadline => throw _privateConstructorUsedError;
  String get tourName => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  List<BookingMemberData> get members => throw _privateConstructorUsedError;
  PaymentData? get payment =>
      throw _privateConstructorUsedError; // Additional fields from GET /api/v1/bookings/{id}
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TourBookingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourBookingDataCopyWith<TourBookingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourBookingDataCopyWith<$Res> {
  factory $TourBookingDataCopyWith(
    TourBookingData value,
    $Res Function(TourBookingData) then,
  ) = _$TourBookingDataCopyWithImpl<$Res, TourBookingData>;
  @useResult
  $Res call({
    String id,
    String customerName,
    String customerPhone,
    String specialRequests,
    String status,
    double totalPrice,
    double pricePerAdultAtBooking,
    double pricePerChildAtBooking,
    String? paymentDeadline,
    String tourName,
    String startDate,
    String endDate,
    List<BookingMemberData> members,
    PaymentData? payment,
    String paymentMethod,
    String paymentStatus,
    String? transactionId,
    String createdAt,
  });

  $PaymentDataCopyWith<$Res>? get payment;
}

/// @nodoc
class _$TourBookingDataCopyWithImpl<$Res, $Val extends TourBookingData>
    implements $TourBookingDataCopyWith<$Res> {
  _$TourBookingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? specialRequests = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? pricePerAdultAtBooking = null,
    Object? pricePerChildAtBooking = null,
    Object? paymentDeadline = freezed,
    Object? tourName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? members = null,
    Object? payment = freezed,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? transactionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhone: null == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            specialRequests: null == specialRequests
                ? _value.specialRequests
                : specialRequests // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            pricePerAdultAtBooking: null == pricePerAdultAtBooking
                ? _value.pricePerAdultAtBooking
                : pricePerAdultAtBooking // ignore: cast_nullable_to_non_nullable
                      as double,
            pricePerChildAtBooking: null == pricePerChildAtBooking
                ? _value.pricePerChildAtBooking
                : pricePerChildAtBooking // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentDeadline: freezed == paymentDeadline
                ? _value.paymentDeadline
                : paymentDeadline // ignore: cast_nullable_to_non_nullable
                      as String?,
            tourName: null == tourName
                ? _value.tourName
                : tourName // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<BookingMemberData>,
            payment: freezed == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as PaymentData?,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentDataCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $PaymentDataCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TourBookingDataImplCopyWith<$Res>
    implements $TourBookingDataCopyWith<$Res> {
  factory _$$TourBookingDataImplCopyWith(
    _$TourBookingDataImpl value,
    $Res Function(_$TourBookingDataImpl) then,
  ) = __$$TourBookingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String customerName,
    String customerPhone,
    String specialRequests,
    String status,
    double totalPrice,
    double pricePerAdultAtBooking,
    double pricePerChildAtBooking,
    String? paymentDeadline,
    String tourName,
    String startDate,
    String endDate,
    List<BookingMemberData> members,
    PaymentData? payment,
    String paymentMethod,
    String paymentStatus,
    String? transactionId,
    String createdAt,
  });

  @override
  $PaymentDataCopyWith<$Res>? get payment;
}

/// @nodoc
class __$$TourBookingDataImplCopyWithImpl<$Res>
    extends _$TourBookingDataCopyWithImpl<$Res, _$TourBookingDataImpl>
    implements _$$TourBookingDataImplCopyWith<$Res> {
  __$$TourBookingDataImplCopyWithImpl(
    _$TourBookingDataImpl _value,
    $Res Function(_$TourBookingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? specialRequests = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? pricePerAdultAtBooking = null,
    Object? pricePerChildAtBooking = null,
    Object? paymentDeadline = freezed,
    Object? tourName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? members = null,
    Object? payment = freezed,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? transactionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TourBookingDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhone: null == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        specialRequests: null == specialRequests
            ? _value.specialRequests
            : specialRequests // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        pricePerAdultAtBooking: null == pricePerAdultAtBooking
            ? _value.pricePerAdultAtBooking
            : pricePerAdultAtBooking // ignore: cast_nullable_to_non_nullable
                  as double,
        pricePerChildAtBooking: null == pricePerChildAtBooking
            ? _value.pricePerChildAtBooking
            : pricePerChildAtBooking // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentDeadline: freezed == paymentDeadline
            ? _value.paymentDeadline
            : paymentDeadline // ignore: cast_nullable_to_non_nullable
                  as String?,
        tourName: null == tourName
            ? _value.tourName
            : tourName // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<BookingMemberData>,
        payment: freezed == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as PaymentData?,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourBookingDataImpl implements _TourBookingData {
  const _$TourBookingDataImpl({
    required this.id,
    this.customerName = '',
    this.customerPhone = '',
    this.specialRequests = '',
    this.status = 'PENDING',
    this.totalPrice = 0,
    this.pricePerAdultAtBooking = 0,
    this.pricePerChildAtBooking = 0,
    this.paymentDeadline,
    this.tourName = '',
    this.startDate = '',
    this.endDate = '',
    final List<BookingMemberData> members = const [],
    this.payment,
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.transactionId,
    this.createdAt = '',
  }) : _members = members;

  factory _$TourBookingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourBookingDataImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String customerName;
  @override
  @JsonKey()
  final String customerPhone;
  @override
  @JsonKey()
  final String specialRequests;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final double totalPrice;
  @override
  @JsonKey()
  final double pricePerAdultAtBooking;
  @override
  @JsonKey()
  final double pricePerChildAtBooking;
  @override
  final String? paymentDeadline;
  @override
  @JsonKey()
  final String tourName;
  @override
  @JsonKey()
  final String startDate;
  @override
  @JsonKey()
  final String endDate;
  final List<BookingMemberData> _members;
  @override
  @JsonKey()
  List<BookingMemberData> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final PaymentData? payment;
  // Additional fields from GET /api/v1/bookings/{id}
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  final String? transactionId;
  @override
  @JsonKey()
  final String createdAt;

  @override
  String toString() {
    return 'TourBookingData(id: $id, customerName: $customerName, customerPhone: $customerPhone, specialRequests: $specialRequests, status: $status, totalPrice: $totalPrice, pricePerAdultAtBooking: $pricePerAdultAtBooking, pricePerChildAtBooking: $pricePerChildAtBooking, paymentDeadline: $paymentDeadline, tourName: $tourName, startDate: $startDate, endDate: $endDate, members: $members, payment: $payment, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, transactionId: $transactionId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourBookingDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.pricePerAdultAtBooking, pricePerAdultAtBooking) ||
                other.pricePerAdultAtBooking == pricePerAdultAtBooking) &&
            (identical(other.pricePerChildAtBooking, pricePerChildAtBooking) ||
                other.pricePerChildAtBooking == pricePerChildAtBooking) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline) &&
            (identical(other.tourName, tourName) ||
                other.tourName == tourName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    customerName,
    customerPhone,
    specialRequests,
    status,
    totalPrice,
    pricePerAdultAtBooking,
    pricePerChildAtBooking,
    paymentDeadline,
    tourName,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_members),
    payment,
    paymentMethod,
    paymentStatus,
    transactionId,
    createdAt,
  );

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourBookingDataImplCopyWith<_$TourBookingDataImpl> get copyWith =>
      __$$TourBookingDataImplCopyWithImpl<_$TourBookingDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourBookingDataImplToJson(this);
  }
}

abstract class _TourBookingData implements TourBookingData {
  const factory _TourBookingData({
    required final String id,
    final String customerName,
    final String customerPhone,
    final String specialRequests,
    final String status,
    final double totalPrice,
    final double pricePerAdultAtBooking,
    final double pricePerChildAtBooking,
    final String? paymentDeadline,
    final String tourName,
    final String startDate,
    final String endDate,
    final List<BookingMemberData> members,
    final PaymentData? payment,
    final String paymentMethod,
    final String paymentStatus,
    final String? transactionId,
    final String createdAt,
  }) = _$TourBookingDataImpl;

  factory _TourBookingData.fromJson(Map<String, dynamic> json) =
      _$TourBookingDataImpl.fromJson;

  @override
  String get id;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get specialRequests;
  @override
  String get status;
  @override
  double get totalPrice;
  @override
  double get pricePerAdultAtBooking;
  @override
  double get pricePerChildAtBooking;
  @override
  String? get paymentDeadline;
  @override
  String get tourName;
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  List<BookingMemberData> get members;
  @override
  PaymentData? get payment; // Additional fields from GET /api/v1/bookings/{id}
  @override
  String get paymentMethod;
  @override
  String get paymentStatus;
  @override
  String? get transactionId;
  @override
  String get createdAt;

  /// Create a copy of TourBookingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourBookingDataImplCopyWith<_$TourBookingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingMemberData _$BookingMemberDataFromJson(Map<String, dynamic> json) {
  return _BookingMemberData.fromJson(json);
}

/// @nodoc
mixin _$BookingMemberData {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get identityNumber => throw _privateConstructorUsedError;
  String get dateOfBirth => throw _privateConstructorUsedError;
  String get attendanceStatus => throw _privateConstructorUsedError;
  String get memberType => throw _privateConstructorUsedError;

  /// Serializes this BookingMemberData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingMemberData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingMemberDataCopyWith<BookingMemberData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingMemberDataCopyWith<$Res> {
  factory $BookingMemberDataCopyWith(
    BookingMemberData value,
    $Res Function(BookingMemberData) then,
  ) = _$BookingMemberDataCopyWithImpl<$Res, BookingMemberData>;
  @useResult
  $Res call({
    String id,
    String fullName,
    String identityNumber,
    String dateOfBirth,
    String attendanceStatus,
    String memberType,
  });
}

/// @nodoc
class _$BookingMemberDataCopyWithImpl<$Res, $Val extends BookingMemberData>
    implements $BookingMemberDataCopyWith<$Res> {
  _$BookingMemberDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingMemberData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? identityNumber = null,
    Object? dateOfBirth = null,
    Object? attendanceStatus = null,
    Object? memberType = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            identityNumber: null == identityNumber
                ? _value.identityNumber
                : identityNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            dateOfBirth: null == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String,
            attendanceStatus: null == attendanceStatus
                ? _value.attendanceStatus
                : attendanceStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            memberType: null == memberType
                ? _value.memberType
                : memberType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingMemberDataImplCopyWith<$Res>
    implements $BookingMemberDataCopyWith<$Res> {
  factory _$$BookingMemberDataImplCopyWith(
    _$BookingMemberDataImpl value,
    $Res Function(_$BookingMemberDataImpl) then,
  ) = __$$BookingMemberDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullName,
    String identityNumber,
    String dateOfBirth,
    String attendanceStatus,
    String memberType,
  });
}

/// @nodoc
class __$$BookingMemberDataImplCopyWithImpl<$Res>
    extends _$BookingMemberDataCopyWithImpl<$Res, _$BookingMemberDataImpl>
    implements _$$BookingMemberDataImplCopyWith<$Res> {
  __$$BookingMemberDataImplCopyWithImpl(
    _$BookingMemberDataImpl _value,
    $Res Function(_$BookingMemberDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingMemberData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? identityNumber = null,
    Object? dateOfBirth = null,
    Object? attendanceStatus = null,
    Object? memberType = null,
  }) {
    return _then(
      _$BookingMemberDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        identityNumber: null == identityNumber
            ? _value.identityNumber
            : identityNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        dateOfBirth: null == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String,
        attendanceStatus: null == attendanceStatus
            ? _value.attendanceStatus
            : attendanceStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        memberType: null == memberType
            ? _value.memberType
            : memberType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingMemberDataImpl implements _BookingMemberData {
  const _$BookingMemberDataImpl({
    this.id = '',
    this.fullName = '',
    this.identityNumber = '',
    this.dateOfBirth = '',
    this.attendanceStatus = 'NOT_CHECKED',
    this.memberType = 'ADULT',
  });

  factory _$BookingMemberDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingMemberDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String identityNumber;
  @override
  @JsonKey()
  final String dateOfBirth;
  @override
  @JsonKey()
  final String attendanceStatus;
  @override
  @JsonKey()
  final String memberType;

  @override
  String toString() {
    return 'BookingMemberData(id: $id, fullName: $fullName, identityNumber: $identityNumber, dateOfBirth: $dateOfBirth, attendanceStatus: $attendanceStatus, memberType: $memberType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingMemberDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.identityNumber, identityNumber) ||
                other.identityNumber == identityNumber) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.memberType, memberType) ||
                other.memberType == memberType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    identityNumber,
    dateOfBirth,
    attendanceStatus,
    memberType,
  );

  /// Create a copy of BookingMemberData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingMemberDataImplCopyWith<_$BookingMemberDataImpl> get copyWith =>
      __$$BookingMemberDataImplCopyWithImpl<_$BookingMemberDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingMemberDataImplToJson(this);
  }
}

abstract class _BookingMemberData implements BookingMemberData {
  const factory _BookingMemberData({
    final String id,
    final String fullName,
    final String identityNumber,
    final String dateOfBirth,
    final String attendanceStatus,
    final String memberType,
  }) = _$BookingMemberDataImpl;

  factory _BookingMemberData.fromJson(Map<String, dynamic> json) =
      _$BookingMemberDataImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String get identityNumber;
  @override
  String get dateOfBirth;
  @override
  String get attendanceStatus;
  @override
  String get memberType;

  /// Create a copy of BookingMemberData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingMemberDataImplCopyWith<_$BookingMemberDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) {
  return _PaymentData.fromJson(json);
}

/// @nodoc
mixin _$PaymentData {
  String get transactionId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get paymentUrl => throw _privateConstructorUsedError;
  String? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentDataCopyWith<PaymentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentDataCopyWith<$Res> {
  factory $PaymentDataCopyWith(
    PaymentData value,
    $Res Function(PaymentData) then,
  ) = _$PaymentDataCopyWithImpl<$Res, PaymentData>;
  @useResult
  $Res call({
    String transactionId,
    double amount,
    String paymentUrl,
    String? expiresAt,
  });
}

/// @nodoc
class _$PaymentDataCopyWithImpl<$Res, $Val extends PaymentData>
    implements $PaymentDataCopyWith<$Res> {
  _$PaymentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? amount = null,
    Object? paymentUrl = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            transactionId: null == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentUrl: null == paymentUrl
                ? _value.paymentUrl
                : paymentUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentDataImplCopyWith<$Res>
    implements $PaymentDataCopyWith<$Res> {
  factory _$$PaymentDataImplCopyWith(
    _$PaymentDataImpl value,
    $Res Function(_$PaymentDataImpl) then,
  ) = __$$PaymentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transactionId,
    double amount,
    String paymentUrl,
    String? expiresAt,
  });
}

/// @nodoc
class __$$PaymentDataImplCopyWithImpl<$Res>
    extends _$PaymentDataCopyWithImpl<$Res, _$PaymentDataImpl>
    implements _$$PaymentDataImplCopyWith<$Res> {
  __$$PaymentDataImplCopyWithImpl(
    _$PaymentDataImpl _value,
    $Res Function(_$PaymentDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? amount = null,
    Object? paymentUrl = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$PaymentDataImpl(
        transactionId: null == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentUrl: null == paymentUrl
            ? _value.paymentUrl
            : paymentUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentDataImpl implements _PaymentData {
  const _$PaymentDataImpl({
    this.transactionId = '',
    this.amount = 0,
    this.paymentUrl = '',
    this.expiresAt,
  });

  factory _$PaymentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentDataImplFromJson(json);

  @override
  @JsonKey()
  final String transactionId;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String paymentUrl;
  @override
  final String? expiresAt;

  @override
  String toString() {
    return 'PaymentData(transactionId: $transactionId, amount: $amount, paymentUrl: $paymentUrl, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentDataImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, transactionId, amount, paymentUrl, expiresAt);

  /// Create a copy of PaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentDataImplCopyWith<_$PaymentDataImpl> get copyWith =>
      __$$PaymentDataImplCopyWithImpl<_$PaymentDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentDataImplToJson(this);
  }
}

abstract class _PaymentData implements PaymentData {
  const factory _PaymentData({
    final String transactionId,
    final double amount,
    final String paymentUrl,
    final String? expiresAt,
  }) = _$PaymentDataImpl;

  factory _PaymentData.fromJson(Map<String, dynamic> json) =
      _$PaymentDataImpl.fromJson;

  @override
  String get transactionId;
  @override
  double get amount;
  @override
  String get paymentUrl;
  @override
  String? get expiresAt;

  /// Create a copy of PaymentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentDataImplCopyWith<_$PaymentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
