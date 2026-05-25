import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travery_frontend/data/services/api/model/booking/cancel_booking_response/cancel_booking_response.dart';

class CancellationSuccessViewModel extends ChangeNotifier {
  CancellationSuccessViewModel();

  CancelBookingData? _successData;
  bool _isLoading = false;
  String? _errorMessage;

  CancelBookingData? get successData => _successData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get formattedRefundAmount {
    if (_successData == null) return '0 đ';
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(_successData!.refundAmount);
  }

  String get formattedProcessedAt {
    if (_successData == null || _successData!.processedAt.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(_successData!.processedAt);
      final formatter = DateFormat('dd/MM/yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (_) {
      return _successData!.processedAt;
    }
  }

  void setData(CancelBookingData data) {
    _successData = data;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }
}
