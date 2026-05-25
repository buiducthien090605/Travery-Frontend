import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travery_frontend/data/services/api/model/booking/cancel_booking_response/cancel_booking_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/utils/core_result.dart';

class CancelConfirmationViewModel extends ChangeNotifier {
  final TourService _tourService;

  CancelConfirmationViewModel({required TourService tourService})
    : _tourService = tourService;

  TourBookingData? _bookingData;
  CancelBookingData? _cancelResult;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _submitErrorMessage;
  String _cancelReason = '';

  TourBookingData? get cancelData => _bookingData;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get submitErrorMessage => _submitErrorMessage;
  String get cancelReason => _cancelReason;
  CancelBookingData? get cancelResult => _cancelResult;

  String get formattedTotalAmount {
    if (_bookingData == null) return '0 đ';
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(_bookingData!.totalPrice);
  }

  String get formattedEstimatedRefund {
    if (_bookingData == null) return '0 đ';
    double refundPercent = 0.95;
    if (_bookingData!.status.toUpperCase() == 'PENDING') {
      refundPercent = 1.0;
    }
    final estimatedRefund = _bookingData!.totalPrice * refundPercent;
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(estimatedRefund);
  }

  String get formattedRefundAmount {
    if (_cancelResult == null) return '0 đ';
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(_cancelResult!.refundAmount);
  }

  Future<void> loadCancelData(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _tourService.getBookingDetail(bookingId);

    switch (result) {
      case Ok<TourBookingData>():
        _bookingData = result.value;
        if (_isAlreadyCancelled(result.value.status)) {
          _errorMessage = 'BOOKING_ALREADY_CANCELLED';
        } else if (_isNotCancellable(result.value.status)) {
          _errorMessage = 'BOOKING_CANNOT_BE_CANCELLED';
        }
      case Error<TourBookingData>():
        _errorMessage = 'Không thể tải thông tin. Vui lòng thử lại.';
    }

    _isLoading = false;
    notifyListeners();
  }

  bool _isAlreadyCancelled(String status) {
    final s = status.toUpperCase();
    return s == 'CANCELLED' || s == 'CANCELED';
  }

  bool _isNotCancellable(String status) {
    final s = status.toUpperCase();
    return s == 'CHECKED_IN' ||
        s == 'CHECKEDOUT' ||
        s == 'IN_PROGRESS' ||
        s == 'COMPLETED';
  }

  void updateCancelReason(String reason) {
    _cancelReason = reason;
    notifyListeners();
  }

  Future<CancelBookingData?> submitCancellation(String bookingId) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    final result = await _tourService.cancelBooking(bookingId);

    CancelBookingData? cancelData;
    switch (result) {
      case Ok<CancelBookingData>():
        _cancelResult = result.value;
        cancelData = result.value;
      case Error<CancelBookingData>():
        _submitErrorMessage = 'Không thể hủy tour. Vui lòng thử lại.';
    }

    _isSubmitting = false;
    notifyListeners();

    return cancelData;
  }
}
