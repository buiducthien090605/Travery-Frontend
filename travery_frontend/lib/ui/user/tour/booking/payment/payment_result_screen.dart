import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/security_storage_service.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/payment/view_models/payment_view_model.dart';

class PaymentResultScreen extends StatefulWidget {
  final String? txnRef;
  final String? status;
  final String? responseCode;
  final TourBookingData? bookingData;

  const PaymentResultScreen({
    super.key,
    this.txnRef,
    this.status,
    this.responseCode,
    this.bookingData,
  });

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  late PaymentViewModel _vm;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _init();
    }
  }

  Future<void> _init() async {
    final tourService = context.read<TourService>();
    _vm = PaymentViewModel(tourService: tourService);

    // Get bookingId from navigation or pending payment
    String? bookingId;

    if (widget.bookingData != null) {
      bookingId = widget.bookingData!.id;
    }

    final securityStorage = context.read<SecurityStorageService>();
    final pendingPayment = await securityStorage.getPendingPayment();

    if (pendingPayment != null) {
      final pendingBookingId = pendingPayment['bookingId'] as String?;
      if (pendingBookingId != null && bookingId == null) {
        bookingId = pendingBookingId;
      }
    }

    if (bookingId != null) {
      // ALWAYS call API to verify payment status - NEVER trust deep link status
      await _vm.verifyPaymentStatus(bookingId);
    }

    _vm.addListener(_onVmUpdate);
    setState(() {});
  }

  void _onVmUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmUpdate);
    _vm.dispose();
    super.dispose();
  }

  void _navigateHome() async {
    final securityStorage = context.read<SecurityStorageService>();
    await securityStorage.clearPendingPayment();
    if (mounted) context.go(Routes.home);
  }

  void _navigateToSuccess() async {
    final securityStorage = context.read<SecurityStorageService>();
    await securityStorage.clearPendingPayment();
    if (mounted) {
      context.pushReplacement(Routes.bookingSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _navigateHome(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: _navigateHome,
          ),
          title: const Text(
            'Kết quả thanh toán',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    switch (_vm.confirmState) {
      case PaymentConfirmState.confirming:
        return _buildConfirmingUI();
      case PaymentConfirmState.confirmed:
        return _buildSuccessUI();
      case PaymentConfirmState.failed:
        return _buildFailedUI();
      case PaymentConfirmState.processingTimeout:
        return _buildTimeoutUI();
    }
  }

  Widget _buildConfirmingUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 6,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Đang xác nhận thanh toán',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vui lòng chờ trong giây lát...',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Hệ thống đang xác nhận với VNPay',
              style: TextStyle(fontSize: 13, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thanh toán thành công!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cảm ơn bạn đã đặt tour cùng Travery',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (_vm.txnRef != null) ...[
              const SizedBox(height: 8),
              Text(
                'Mã giao dịch: ${_vm.txnRef}',
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _navigateToSuccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xem chi tiết đặt tour',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: _navigateHome,
                child: const Text(
                  'Về trang chủ',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailedUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cancel, size: 64, color: AppColors.error),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thanh toán thất bại',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(_vm.deeplinkResponseCode ?? widget.responseCode),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _navigateHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Về trang chủ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_empty,
                size: 64,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đang xử lý thanh toán',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Thanh toán của bạn đang được xác nhận. '
                'Vui lòng kiểm tra lại sau vài phút.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  _vm.startPollingWithBackoff();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kiểm tra lại',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: _navigateHome,
                child: const Text(
                  'Về trang chủ',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(String? code) {
    if (code == null) return 'Giao dịch không thành công.';
    switch (code) {
      case '24':
        return 'Bạn đã hủy giao dịch.';
      case '51':
        return 'Tài khoản không đủ số dư.';
      case '65':
        return 'Vượt hạn mức thanh toán trong ngày.';
      case '75':
        return 'Ngân hàng đang bảo trì.';
      default:
        return 'Giao dịch không thành công (mã: $code).';
    }
  }
}
