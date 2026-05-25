import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_tour_booking_response.freezed.dart';
part 'create_tour_booking_response.g.dart';

@freezed
class CreateTourBookingResponse with _$CreateTourBookingResponse {
  const factory CreateTourBookingResponse({required TourBookingData data}) =
      _CreateTourBookingResponse;

  factory CreateTourBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateTourBookingResponseFromJson(json);
}

@freezed
class TourBookingData with _$TourBookingData {
  const factory TourBookingData({
    required String id,
    @Default('') String customerName,
    @Default('') String customerPhone,
    @Default('') String specialRequests,
    @Default('PENDING') String status,
    @Default(0) double totalPrice,
    @Default(0) double pricePerAdultAtBooking,
    @Default(0) double pricePerChildAtBooking,
    String? paymentDeadline,
    @Default('') String tourName,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default([]) List<BookingMemberData> members,
    PaymentData? payment,
    // Additional fields from GET /api/v1/bookings/{id}
    @Default('') String paymentMethod,
    @Default('') String paymentStatus,
    String? transactionId,
    @Default('') String createdAt,
  }) = _TourBookingData;

  factory TourBookingData.fromJson(Map<String, dynamic> json) =>
      _$TourBookingDataFromJson(json);
}

@freezed
class BookingMemberData with _$BookingMemberData {
  const factory BookingMemberData({
    @Default('') String id,
    @Default('') String fullName,
    @Default('') String identityNumber,
    @Default('') String dateOfBirth,
    @Default('NOT_CHECKED') String attendanceStatus,
    @Default('ADULT') String memberType,
  }) = _BookingMemberData;

  factory BookingMemberData.fromJson(Map<String, dynamic> json) =>
      _$BookingMemberDataFromJson(json);
}

@freezed
class PaymentData with _$PaymentData {
  const factory PaymentData({
    @Default('') String transactionId,
    @Default(0) double amount,
    @Default('') String paymentUrl,
    String? expiresAt,
  }) = _PaymentData;

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);
}
