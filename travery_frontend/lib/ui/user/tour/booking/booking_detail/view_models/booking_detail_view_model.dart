import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/utils/core_result.dart';

class BookingDetailViewModel extends ChangeNotifier {
  final TourService _tourService;

  BookingDetailViewModel({required TourService tourService})
    : _tourService = tourService;

  TourBookingData? _bookingDetail;
  TourBookingData? get bookingDetail => _bookingDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadBookingDetail(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _tourService.getBookingDetail(bookingId);

    switch (result) {
      case Ok<TourBookingData>():
        _bookingDetail = result.value;
      case Error<TourBookingData>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  String get formattedDate {
    if (_bookingDetail == null) return 'N/A';
    final start = _bookingDetail!.startDate;
    if (start.isEmpty) return 'N/A';
    return start;
  }

  String get formattedPrice {
    if (_bookingDetail == null) return 'N/A';
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(_bookingDetail!.totalPrice);
  }

  String get formattedGuestCount {
    if (_bookingDetail == null) return 'N/A';
    final guests = _bookingDetail!.members.length;
    return '$guests ${guests == 1 ? 'Khách' : 'Khách'}';
  }

  String get refundDeadlineText {
    if (_bookingDetail == null) return '';
    final deadline = _bookingDetail!.paymentDeadline ?? '';
    if (deadline.isEmpty) return '';
    return deadline;
  }

  List<BookingMemberData> get members => _bookingDetail?.members ?? [];
}
