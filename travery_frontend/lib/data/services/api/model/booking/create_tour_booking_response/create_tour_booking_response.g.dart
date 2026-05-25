// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tour_booking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTourBookingResponseImpl _$$CreateTourBookingResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CreateTourBookingResponseImpl(
  data: TourBookingData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CreateTourBookingResponseImplToJson(
  _$CreateTourBookingResponseImpl instance,
) => <String, dynamic>{'data': instance.data};

_$TourBookingDataImpl _$$TourBookingDataImplFromJson(
  Map<String, dynamic> json,
) => _$TourBookingDataImpl(
  id: json['id'] as String,
  customerName: json['customerName'] as String? ?? '',
  customerPhone: json['customerPhone'] as String? ?? '',
  specialRequests: json['specialRequests'] as String? ?? '',
  status: json['status'] as String? ?? 'PENDING',
  totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
  pricePerAdultAtBooking:
      (json['pricePerAdultAtBooking'] as num?)?.toDouble() ?? 0,
  pricePerChildAtBooking:
      (json['pricePerChildAtBooking'] as num?)?.toDouble() ?? 0,
  paymentDeadline: json['paymentDeadline'] as String?,
  tourName: json['tourName'] as String? ?? '',
  startDate: json['startDate'] as String? ?? '',
  endDate: json['endDate'] as String? ?? '',
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => BookingMemberData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  payment: json['payment'] == null
      ? null
      : PaymentData.fromJson(json['payment'] as Map<String, dynamic>),
  paymentMethod: json['paymentMethod'] as String? ?? '',
  paymentStatus: json['paymentStatus'] as String? ?? '',
  transactionId: json['transactionId'] as String?,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$$TourBookingDataImplToJson(
  _$TourBookingDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'specialRequests': instance.specialRequests,
  'status': instance.status,
  'totalPrice': instance.totalPrice,
  'pricePerAdultAtBooking': instance.pricePerAdultAtBooking,
  'pricePerChildAtBooking': instance.pricePerChildAtBooking,
  'paymentDeadline': instance.paymentDeadline,
  'tourName': instance.tourName,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'members': instance.members,
  'payment': instance.payment,
  'paymentMethod': instance.paymentMethod,
  'paymentStatus': instance.paymentStatus,
  'transactionId': instance.transactionId,
  'createdAt': instance.createdAt,
};

_$BookingMemberDataImpl _$$BookingMemberDataImplFromJson(
  Map<String, dynamic> json,
) => _$BookingMemberDataImpl(
  id: json['id'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  identityNumber: json['identityNumber'] as String? ?? '',
  dateOfBirth: json['dateOfBirth'] as String? ?? '',
  attendanceStatus: json['attendanceStatus'] as String? ?? 'NOT_CHECKED',
  memberType: json['memberType'] as String? ?? 'ADULT',
);

Map<String, dynamic> _$$BookingMemberDataImplToJson(
  _$BookingMemberDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'identityNumber': instance.identityNumber,
  'dateOfBirth': instance.dateOfBirth,
  'attendanceStatus': instance.attendanceStatus,
  'memberType': instance.memberType,
};

_$PaymentDataImpl _$$PaymentDataImplFromJson(Map<String, dynamic> json) =>
    _$PaymentDataImpl(
      transactionId: json['transactionId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paymentUrl: json['paymentUrl'] as String? ?? '',
      expiresAt: json['expiresAt'] as String?,
    );

Map<String, dynamic> _$$PaymentDataImplToJson(_$PaymentDataImpl instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'paymentUrl': instance.paymentUrl,
      'expiresAt': instance.expiresAt,
    };
