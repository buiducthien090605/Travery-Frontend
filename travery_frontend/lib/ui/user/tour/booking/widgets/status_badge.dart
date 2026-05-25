import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _backgroundColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _statusText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  String get _statusText {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ thanh toán';
      case 'PAID':
        return 'Đã thanh toán';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'CHECKED_IN':
        return 'Đã check-in';
      case 'CHECKED_OUT':
        return 'Đã check-out';
      case 'CANCELLED':
      case 'CANCELED':
        return 'Đã hủy';
      case 'IN_PROGRESS':
        return 'Đang diễn ra';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'REFUNDED':
        return 'Đã hoàn tiền';
      case 'REFUND_PENDING':
        return 'Chờ hoàn tiền';
      case 'EXPIRED':
        return 'Đã hết hạn';
      default:
        return status;
    }
  }

  Color get _backgroundColor {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.warning;
      case 'PAID':
      case 'CONFIRMED':
        return AppColors.primary;
      case 'CHECKED_IN':
        return AppColors.primary;
      case 'CHECKED_OUT':
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
      case 'CANCELED':
        return AppColors.error;
      case 'IN_PROGRESS':
        return AppColors.primary;
      case 'REFUNDED':
        return AppColors.success;
      case 'REFUND_PENDING':
        return AppColors.warning;
      case 'EXPIRED':
        return AppColors.textHint;
      default:
        return AppColors.textSecondary;
    }
  }
}
