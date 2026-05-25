import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/payment/view_models/payment_view_model.dart';
import 'package:travery_frontend/utils/format_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class VNPayPaymentScreen extends StatelessWidget {
  const VNPayPaymentScreen({super.key, this.bookingData});

  final TourBookingData? bookingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, vm, child) {
          if (vm.status == PaymentStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (vm.status == PaymentStatus.failed) {
            return _buildErrorState(context, vm.errorMessage);
          }

          return _VNPayPaymentContent(vm: vm, bookingData: bookingData);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              message ?? 'Đã xảy ra lỗi',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Quay lại',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VNPayPaymentContent extends StatelessWidget {
  const _VNPayPaymentContent({required this.vm, this.bookingData});

  final PaymentViewModel vm;
  final TourBookingData? bookingData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.account_balance,
              size: 64,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Thanh toán qua VNPay',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            FormatUtils.formatCurrency(vm.totalAmount),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng nhấn nút bên dưới để tiếp tục thanh toán',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (vm.remainingSeconds > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hết hạn sau: ${vm.formattedTime}',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _openVNPay(context, vm.paymentUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF1A237E).withValues(alpha: 0.4),
              ),
              child: const Text(
                'Thanh toán ngay',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openVNPay(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);

    if (url.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Đường dẫn thanh toán không hợp lệ. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Không thể mở cổng thanh toán. Vui lòng thử lại sau.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
