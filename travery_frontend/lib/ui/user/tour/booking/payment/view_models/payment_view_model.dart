import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_payment_response/create_payment_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/utils/core_result.dart';

enum PaymentStatus {
  idle,
  loading,
  pending,
  processing,
  success,
  failed,
  expired,
}

enum PaymentConfirmState { confirming, confirmed, failed, processingTimeout }

class PaymentViewModel extends ChangeNotifier {
  PaymentViewModel({required TourService tourService})
    : _tourService = tourService;

  final TourService _tourService;

  bool _disposed = false;

  String? _bookingId;
  String? get bookingId => _bookingId;

  String? _txnRef;
  String? get txnRef => _txnRef;

  TourBookingData? _bookingData;
  TourBookingData? get bookingData => _bookingData;

  String _paymentUrl = '';
  String get paymentUrl => _paymentUrl;

  DateTime? _expiresAt;
  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;

  PaymentStatus _status = PaymentStatus.idle;
  PaymentStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Deep link state
  PaymentConfirmState _confirmState = PaymentConfirmState.confirming;
  PaymentConfirmState get confirmState => _confirmState;

  String? _deeplinkResponseCode;

  Timer? _countdownTimer;
  Timer? _pollingTimer;
  int _pollAttempt = 0;

  // Fast polling delays in seconds: 1, 1, 2, 2, 3, 3, 5, 5, 5, 5
  static const List<int> _pollDelays = [1, 1, 2, 2, 3, 3, 5, 5, 5, 5];
  static const int _maxPollAttempts = 10;

  void _setStatus(PaymentStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _setStatus(PaymentStatus.failed);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Verify payment status by calling API - NEVER trust deep link status
  Future<void> verifyPaymentStatus(String bookingId) async {
    _bookingId = bookingId;
    _setStatus(PaymentStatus.loading);
    notifyListeners();

    final result = await _tourService.getBookingDetail(bookingId);

    switch (result) {
      case Ok<TourBookingData>():
        _bookingData = result.value;
        _txnRef = result.value.payment?.transactionId;
        _processBookingStatus(result.value.status);
      case Error<TourBookingData>():
        _setError(result.error.toString());
    }
  }

  void _processBookingStatus(String status) {
    final upperStatus = status.toUpperCase();

    // Payment success states
    if (upperStatus == 'PAID' ||
        upperStatus == 'CONFIRMED' ||
        upperStatus == 'CHECKED_IN' ||
        upperStatus == 'IN_PROGRESS') {
      _confirmState = PaymentConfirmState.confirmed;
      _setStatus(PaymentStatus.success);
      return;
    }

    // Payment failed/cancelled states
    if (upperStatus == 'CANCELLED') {
      _confirmState = PaymentConfirmState.failed;
      _setStatus(PaymentStatus.failed);
      return;
    }

    // Still pending - show waiting state
    if (upperStatus == 'PENDING') {
      _confirmState = PaymentConfirmState.confirming;
      _setStatus(PaymentStatus.pending);
      return;
    }

    // Default - treat as pending confirmation
    _confirmState = PaymentConfirmState.confirming;
    _setStatus(PaymentStatus.processing);
  }

  Future<void> initFromBookingId(String bookingId) async {
    _bookingId = bookingId;
    _setStatus(PaymentStatus.loading);
    notifyListeners();

    final result = await _tourService.getBookingDetail(bookingId);

    switch (result) {
      case Ok<TourBookingData>():
        _bookingData = result.value;
        _txnRef = result.value.payment?.transactionId;
        if (result.value.payment != null &&
            result.value.payment!.paymentUrl.isNotEmpty) {
          _paymentUrl = result.value.payment!.paymentUrl;
          if (result.value.payment!.expiresAt != null) {
            _expiresAt = DateTime.tryParse(result.value.payment!.expiresAt!);
            _startCountdown();
          }
          _setStatus(PaymentStatus.pending);
        } else {
          // No payment URL yet, wait for user to create payment
          _setStatus(PaymentStatus.pending);
        }
      case Error<TourBookingData>():
        _setError(result.error.toString());
    }
  }

  Future<void> initPayment(TourBookingData bookingData) async {
    _bookingData = bookingData;
    _bookingId = bookingData.id;
    _txnRef = bookingData.payment?.transactionId;
    _setStatus(PaymentStatus.loading);
    notifyListeners();

    if (bookingData.payment != null &&
        bookingData.payment!.paymentUrl.isNotEmpty) {
      _paymentUrl = bookingData.payment!.paymentUrl;
      if (bookingData.payment!.expiresAt != null) {
        _expiresAt = DateTime.tryParse(bookingData.payment!.expiresAt!);
        _startCountdown();
      }
      _setStatus(PaymentStatus.pending);
    } else {
      await _createPayment();
    }
  }

  Future<void> _createPayment() async {
    if (_bookingId == null) return;

    final result = await _tourService.createPayment(_bookingId!);

    switch (result) {
      case Ok<PaymentResponseData>():
        _paymentUrl = result.value.paymentUrl;
        if (result.value.expiresAt != null) {
          _expiresAt = DateTime.tryParse(result.value.expiresAt!);
          _startCountdown();
        }
        _setStatus(PaymentStatus.pending);
      case Error<PaymentResponseData>():
        _setError(result.error.toString());
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    if (_expiresAt == null) return;

    _updateRemainingSeconds();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingSeconds();
      if (_remainingSeconds <= 0) {
        _countdownTimer?.cancel();
        _stopPolling();
        _setStatus(PaymentStatus.expired);
      }
    });
  }

  void _updateRemainingSeconds() {
    if (_expiresAt == null) return;
    final now = DateTime.now().toUtc();
    final diff = _expiresAt!.toUtc().difference(now);
    _remainingSeconds = diff.inSeconds.clamp(0, 999999);
    notifyListeners();
  }

  /// Called when a deep link arrives. Sets initial confirm state.
  void onDeepLinkArrived({
    required String txnRef,
    required String status,
    required String? responseCode,
  }) {
    _deeplinkResponseCode = responseCode;
    _txnRef = txnRef;

    if (status == 'failed') {
      _confirmState = PaymentConfirmState.failed;
      _setStatus(PaymentStatus.failed);
    } else {
      _confirmState = PaymentConfirmState.confirming;
      _setStatus(PaymentStatus.processing);
    }
    notifyListeners();
  }

  Future<void> startPollingWithBackoff() async {
    _pollAttempt = 0;
    await _pollOnce();
  }

  Future<void> _pollOnce() async {
    if (_pollAttempt >= _maxPollAttempts) {
      _confirmState = PaymentConfirmState.processingTimeout;
      _setStatus(PaymentStatus.expired);
      notifyListeners();
      return;
    }

    if (_bookingId == null) {
      _confirmState = PaymentConfirmState.processingTimeout;
      notifyListeners();
      return;
    }

    final delay = _pollDelays[_pollAttempt];
    await Future.delayed(Duration(seconds: delay));
    _pollAttempt++;

    if (_disposed) return;

    final result = await _tourService.getBookingDetail(_bookingId!);

    if (_disposed) return;

    switch (result) {
      case Ok<TourBookingData>():
        _bookingData = result.value;
        final bookingStatus = result.value.status.toUpperCase();
        if (bookingStatus == 'PAID' ||
            bookingStatus == 'CONFIRMED' ||
            bookingStatus == 'IN_PROGRESS' ||
            bookingStatus == 'COMPLETED') {
          _confirmState = PaymentConfirmState.confirmed;
          _setStatus(PaymentStatus.success);
          notifyListeners();
          return;
        }
        if (bookingStatus == 'CANCELLED') {
          _confirmState = PaymentConfirmState.failed;
          _setStatus(PaymentStatus.failed);
          notifyListeners();
          return;
        }
      case Error<TourBookingData>():
        break;
    }

    if (!_disposed) {
      _pollOnce();
    }
  }

  /// Old polling for the VNPayPaymentScreen (polling while user is on payment screen)
  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_status == PaymentStatus.expired ||
          _status == PaymentStatus.success ||
          _status == PaymentStatus.failed) {
        _pollingTimer?.cancel();
        return;
      }
      if (_disposed) return;
      await _checkBookingStatus();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _checkBookingStatus() async {
    if (_bookingId == null) return;

    final result = await _tourService.getBookingDetail(_bookingId!);

    switch (result) {
      case Ok<TourBookingData>():
        _bookingData = result.value;
        if (_isPaymentSuccess(result.value)) {
          _stopPolling();
          _countdownTimer?.cancel();
          _setStatus(PaymentStatus.success);
        }
      case Error<TourBookingData>():
        break;
    }
  }

  bool _isPaymentSuccess(TourBookingData data) {
    final status = data.status.toUpperCase();
    return status == 'CONFIRMED' ||
        status == 'PAID' ||
        status == 'IN_PROGRESS' ||
        status == 'COMPLETED';
  }

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get statusText {
    switch (_status) {
      case PaymentStatus.idle:
        return 'Đang khởi tạo...';
      case PaymentStatus.loading:
        return 'Đang tạo thanh toán...';
      case PaymentStatus.pending:
        return 'Đang chờ thanh toán';
      case PaymentStatus.processing:
        return 'Đang xác nhận thanh toán...';
      case PaymentStatus.success:
        return 'Thanh toán thành công';
      case PaymentStatus.failed:
        return 'Thanh toán thất bại';
      case PaymentStatus.expired:
        return 'Đã hết hạn';
    }
  }

  String get confirmStateText {
    switch (_confirmState) {
      case PaymentConfirmState.confirming:
        return 'Đang xác nhận thanh toán...';
      case PaymentConfirmState.confirmed:
        return 'Xác nhận thành công!';
      case PaymentConfirmState.failed:
        return 'Thanh toán thất bại';
      case PaymentConfirmState.processingTimeout:
        return 'Đang xử lý...';
    }
  }

  String? get deeplinkResponseCode => _deeplinkResponseCode;

  double get totalAmount => _bookingData?.totalPrice ?? 0;
  String get bookingCode => _bookingId ?? '';
  String get tourName => _bookingData?.tourName ?? '';

  @override
  void dispose() {
    _disposed = true;
    _countdownTimer?.cancel();
    _stopPolling();
    super.dispose();
  }
}
