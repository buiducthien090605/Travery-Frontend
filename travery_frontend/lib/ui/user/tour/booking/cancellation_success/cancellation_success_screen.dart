import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travery_frontend/data/services/api/model/booking/cancel_booking_response/cancel_booking_response.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/error_view.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/info_card.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/result_header.dart';

class CancellationSuccessScreen extends StatefulWidget {
  final String bookingId;
  final CancelBookingData? cancelData;

  const CancellationSuccessScreen({
    super.key,
    required this.bookingId,
    this.cancelData,
  });

  @override
  State<CancellationSuccessScreen> createState() =>
      _CancellationSuccessScreenState();
}

class _CancellationSuccessScreenState extends State<CancellationSuccessScreen> {
  CancelBookingData? _cancelData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cancelData = widget.cancelData;
    if (_cancelData != null) {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.go(Routes.home),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _cancelData == null
          ? ErrorView(
              message: _errorMessage ?? 'Không có thông tin hủy tour',
              onRetry: () => context.go(Routes.home),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final data = _cancelData!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const ResultHeader(
            iconType: ResultIconType.success,
            title: 'Hủy tour thành công!',
            subtitle: 'Yêu cầu hủy tour của bạn đã được xác nhận.',
          ),
          const SizedBox(height: 32),
          InfoCard(
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text(
                    'Thông tin hoàn tiền',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRow(
                'Mã đặt chỗ',
                '#${widget.bookingId.length >= 8 ? widget.bookingId.substring(0, 8).toUpperCase() : widget.bookingId.toUpperCase()}',
              ),
              const Divider(height: 24),
              _buildRow(
                'Số tiền hoàn lại',
                _formatCurrency(data.refundAmount),
                isPrice: true,
              ),
              const Divider(height: 24),
              _buildRow(
                'Phương thức hoàn tiền',
                _getRefundMethodText(data.refundMethod),
              ),
              const Divider(height: 24),
              _buildRow(
                'Trạng thái hoàn tiền',
                _getRefundStatusText(data.refundStatus),
              ),
              if (data.processedAt.isNotEmpty) ...[
                const Divider(height: 24),
                _buildRow(
                  'Thời gian xử lý',
                  _formatProcessedAt(data.processedAt),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: AppColors.primary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tiền sẽ được hoàn về đúng phương thức thanh toán bạn đã sử dụng trong 3-5 ngày làm việc.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => context.go(Routes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.home),
              label: const Text(
                'Về trang chủ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
            fontSize: isPrice ? 20 : 14,
            color: isPrice ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatProcessedAt(String processedAt) {
    try {
      final dateTime = DateTime.parse(processedAt);
      final formatter = DateFormat('dd/MM/yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (_) {
      return processedAt;
    }
  }

  String _getRefundMethodText(String method) {
    switch (method.toUpperCase()) {
      case 'VNPAY':
        return 'VNPay';
      case 'CASH':
        return 'Tiền mặt';
      case 'BANK_TRANSFER':
        return 'Chuyển khoản';
      default:
        return method.isNotEmpty ? method : 'VNPay';
    }
  }

  String _getRefundStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Đang xử lý';
      case 'PROCESSING':
        return 'Đang hoàn tiền';
      case 'COMPLETED':
        return 'Đã hoàn tiền';
      case 'FAILED':
        return 'Hoàn tiền thất bại';
      default:
        return status.isNotEmpty ? status : 'Đang xử lý';
    }
  }
}
