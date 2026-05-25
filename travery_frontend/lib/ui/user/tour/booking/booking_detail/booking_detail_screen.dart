import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/booking_detail/view_models/booking_detail_view_model.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/error_view.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/info_card.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/member_list_item.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/status_badge.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/tour_image_card.dart';
import 'package:travery_frontend/utils/format_utils.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          BookingDetailViewModel(tourService: context.read())
            ..loadBookingDetail(bookingId),
      child: _BookingDetailScreenContent(bookingId: bookingId),
    );
  }
}

class _BookingDetailScreenContent extends StatelessWidget {
  const _BookingDetailScreenContent({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Chi tiết đặt chỗ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<BookingDetailViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (viewModel.errorMessage != null) {
            return ErrorView(
              message: viewModel.errorMessage!,
              onRetry: () => viewModel.loadBookingDetail(bookingId),
            );
          }

          final detail = viewModel.bookingDetail;
          if (detail == null) {
            return const ErrorView(message: 'Không tìm thấy thông tin đặt chỗ');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(status: detail.status),
                const SizedBox(height: 20),
                TourImageCard(title: detail.tourName),
                const SizedBox(height: 24),
                InfoCard(
                  children: [
                    InfoRow(
                      label: 'Mã đặt chỗ',
                      value: '#${detail.id.substring(0, 8).toUpperCase()}',
                    ),
                    const Divider(height: 24),
                    InfoRow(label: 'Ngày khởi hành', value: detail.startDate),
                    const Divider(height: 24),
                    InfoRow(label: 'Ngày kết thúc', value: detail.endDate),
                    if (detail.specialRequests.isNotEmpty) ...[
                      const Divider(height: 24),
                      InfoRow(
                        label: 'Yêu cầu đặc biệt',
                        value: detail.specialRequests,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'DANH SÁCH KHÁCH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                ...viewModel.members.map((m) => MemberListItem(member: m)),
                const SizedBox(height: 20),
                InfoCard(
                  children: [
                    if (detail.paymentMethod.isNotEmpty) ...[
                      PriceRow(
                        label: 'Phương thức',
                        value: detail.paymentMethod == 'VNPAY'
                            ? 'VNPay'
                            : detail.paymentMethod,
                      ),
                      const Divider(height: 24),
                    ],
                    if (detail.paymentStatus.isNotEmpty) ...[
                      PriceRow(
                        label: 'Thanh toán',
                        value: _getPaymentStatusText(detail.paymentStatus),
                      ),
                      const Divider(height: 24),
                    ],
                    if (detail.transactionId != null &&
                        detail.transactionId!.isNotEmpty) ...[
                      PriceRow(
                        label: 'Mã giao dịch',
                        value:
                            '#${detail.transactionId!.substring(0, 8).toUpperCase()}',
                        isBold: true,
                      ),
                      const Divider(height: 24),
                    ],
                    PriceRow(
                      label: 'Tổng cộng',
                      value: FormatUtils.formatCurrency(detail.totalPrice),
                      isTotal: true,
                    ),
                    if (detail.pricePerAdultAtBooking > 0) ...[
                      const Divider(height: 24),
                      PriceRow(
                        label: 'Giá người lớn',
                        value: FormatUtils.formatCurrency(
                          detail.pricePerAdultAtBooking,
                        ),
                        isBold: true,
                      ),
                    ],
                    if (detail.pricePerChildAtBooking > 0) ...[
                      const Divider(height: 24),
                      PriceRow(
                        label: 'Giá trẻ em',
                        value: FormatUtils.formatCurrency(
                          detail.pricePerChildAtBooking,
                        ),
                        isBold: true,
                      ),
                    ],
                    if (detail.paymentDeadline != null &&
                        detail.paymentDeadline!.isNotEmpty) ...[
                      const Divider(height: 24),
                      PriceRow(
                        label: 'Hạn thanh toán',
                        value: detail.paymentDeadline!,
                        isBold: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<BookingDetailViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.bookingDetail == null) return const SizedBox();
          final canCancel =
              viewModel.bookingDetail!.status == 'PENDING' ||
              viewModel.bookingDetail!.status == 'PAID';
          if (viewModel.bookingDetail!.status == 'CANCELLED') {
            return const SizedBox();
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (canCancel)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push(
                        Routes.cancelConfirmation.replaceFirst(
                          ':id',
                          bookingId,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Hủy tour'),
                    ),
                  ),
                if (canCancel) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Chat hỗ trợ'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getPaymentStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ thanh toán';
      case 'PAID':
        return 'Đã thanh toán';
      case 'FAILED':
        return 'Thanh toán thất bại';
      case 'REFUNDED':
        return 'Đã hoàn tiền';
      case 'EXPIRED':
        return 'Đã hết hạn';
      default:
        return status;
    }
  }
}
