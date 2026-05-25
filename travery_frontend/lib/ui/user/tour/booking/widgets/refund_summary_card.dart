import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class RefundSummaryCard extends StatelessWidget {
  final String totalAmount;
  final String refundAmount;

  const RefundSummaryCard({
    super.key,
    required this.totalAmount,
    required this.refundAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Hoàn tiền',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRow('Tổng số tiền đã thanh toán', totalAmount),
          const Divider(height: 24),
          _buildRow(
            'Số tiền hoàn lại (sau khi trừ phí)',
            refundAmount,
            isRefund: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isRefund = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isRefund ? 20 : 15,
            fontWeight: isRefund ? FontWeight.bold : FontWeight.w600,
            color: isRefund ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
