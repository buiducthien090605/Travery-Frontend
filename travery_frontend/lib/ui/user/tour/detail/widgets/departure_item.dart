import 'package:flutter/material.dart';
import 'package:travery_frontend/data/seed_models/tour_instance/tour_instance.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class DepartureItem extends StatelessWidget {
  final TourInstance instance;
  final bool isSelected;
  final VoidCallback? onTap;

  const DepartureItem({
    super.key,
    required this.instance,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText();
    final statusColor = _getStatusColor();
    final canBook =
        instance.status != TourInstanceStatus.FULL &&
        instance.status != TourInstanceStatus.CANCELLED &&
        instance.status != TourInstanceStatus.POSTPONED &&
        instance.status != TourInstanceStatus.COMPLETED;

    return GestureDetector(
      onTap: canBook ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (canBook
                      ? AppColors.inputBorder
                      : AppColors.textHint.withValues(alpha: 0.3)),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_formatDate(instance.startDate)} - ${_formatDate(instance.endDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: canBook
                          ? (isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary)
                          : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Còn ${instance.availableSlots} chỗ',
                    style: TextStyle(
                      fontSize: 12,
                      color: instance.availableSlots > 5
                          ? AppColors.success
                          : (instance.availableSlots > 0
                                ? AppColors.warning
                                : AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateStr;
    } catch (_) {
      return dateStr;
    }
  }

  String _getStatusText() {
    switch (instance.status) {
      case TourInstanceStatus.PLANNING:
        return 'Sắp mở';
      case TourInstanceStatus.OPEN:
        return 'Mở bán';
      case TourInstanceStatus.FULL:
        return 'Đã đầy';
      case TourInstanceStatus.IN_PROGRESS:
        return 'Đang đi';
      case TourInstanceStatus.COMPLETED:
        return 'Hoàn thành';
      case TourInstanceStatus.CANCELLED:
        return 'Đã hủy';
      case TourInstanceStatus.POSTPONED:
        return 'Tạm hoãn';
    }
  }

  Color _getStatusColor() {
    switch (instance.status) {
      case TourInstanceStatus.PLANNING:
        return AppColors.warning;
      case TourInstanceStatus.OPEN:
        return AppColors.success;
      case TourInstanceStatus.FULL:
        return AppColors.error;
      case TourInstanceStatus.IN_PROGRESS:
        return AppColors.primary;
      case TourInstanceStatus.COMPLETED:
        return AppColors.success;
      case TourInstanceStatus.CANCELLED:
        return AppColors.error;
      case TourInstanceStatus.POSTPONED:
        return AppColors.warning;
    }
  }
}
