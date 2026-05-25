import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/cancel_confirmation/view_models/cancel_confirmation_view_model.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/action_button.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/cancel_reason_input.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/refund_summary_card.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/result_header.dart';
import 'package:travery_frontend/ui/user/tour/booking/widgets/warning_banner.dart';

class CancelConfirmationScreen extends StatelessWidget {
  const CancelConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.viewModel,
  });

  final String bookingId;
  final CancelConfirmationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel..loadCancelData(bookingId),
      child: _CancelConfirmationScreenContent(bookingId: bookingId),
    );
  }
}

class _CancelConfirmationScreenContent extends StatefulWidget {
  const _CancelConfirmationScreenContent({required this.bookingId});

  final String bookingId;

  @override
  State<_CancelConfirmationScreenContent> createState() =>
      _CancelConfirmationScreenContentState();
}

class _CancelConfirmationScreenContentState
    extends State<_CancelConfirmationScreenContent> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xác nhận hủy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<CancelConfirmationViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (vm.errorMessage != null) {
            final error = vm.errorMessage!;
            if (error == 'BOOKING_ALREADY_CANCELLED') {
              return _buildErrorState(
                'Đã hủy trước đó',
                'Đặt tour này đã được hủy rồi.',
                ResultIconType.warning,
              );
            } else if (error == 'BOOKING_CANNOT_BE_CANCELLED') {
              return _buildErrorState(
                'Không thể hủy',
                'Đặt tour này không thể hủy vì đã được xác nhận hoặc đang thực hiện.',
                ResultIconType.error,
              );
            }
            return _buildErrorState(
              'Đã xảy ra lỗi',
              error,
              ResultIconType.error,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WarningBanner(
                  title: 'Thao tác này không thể hoàn tác',
                  subtitle:
                      'Vui lòng xem kỹ thông tin hoàn tiền và chính sách trước khi xác nhận.',
                ),
                const SizedBox(height: 24),
                RefundSummaryCard(
                  totalAmount: vm.formattedTotalAmount,
                  refundAmount: vm.formattedEstimatedRefund,
                ),
                const SizedBox(height: 32),
                CancelReasonInput(
                  controller: _reasonController,
                  onChanged: (v) => vm.updateCancelReason(v),
                ),
                const SizedBox(height: 40),
                ActionButton(
                  text: 'Xác nhận hủy',
                  onPressed: () => _handleConfirmCancel(context, vm),
                  isDanger: true,
                  isLoading: vm.isSubmitting,
                ),
                const SizedBox(height: 12),
                ActionButton(
                  text: 'Quay lại',
                  onPressed: () => Navigator.pop(context),
                  isGhost: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String title, String message, ResultIconType type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResultHeader(iconType: type, title: title, subtitle: message),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Quay lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirmCancel(
    BuildContext context,
    CancelConfirmationViewModel vm,
  ) async {
    final result = await vm.submitCancellation(widget.bookingId);
    if (!context.mounted) return;
    if (result != null) {
      context.pushReplacement(
        Routes.cancellationSuccess.replaceFirst(':id', widget.bookingId),
        extra: {'cancelData': result},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.submitErrorMessage ?? 'Đã xảy ra lỗi'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
