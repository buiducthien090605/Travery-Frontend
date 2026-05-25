import 'package:flutter/material.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class MemberListItem extends StatelessWidget {
  final BookingMemberData member;

  const MemberListItem({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _memberTypeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_memberTypeIcon, color: _memberTypeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.fullName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _buildMemberTypeBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'CCCD: ${member.identityNumber.isNotEmpty ? member.identityNumber : "Chưa cung cấp"}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (member.dateOfBirth.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Ngày sinh: ${member.dateOfBirth}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildAttendanceBadge(),
        ],
      ),
    );
  }

  Widget _buildMemberTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _memberTypeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        member.memberType == 'ADULT' ? 'Người lớn' : 'Trẻ em',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _memberTypeColor,
        ),
      ),
    );
  }

  Widget _buildAttendanceBadge() {
    final statusText = _attendanceText;
    final statusColor = _attendanceColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_attendanceIcon, size: 12, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _memberTypeColor {
    return member.memberType == 'ADULT' ? AppColors.primary : AppColors.warning;
  }

  IconData get _memberTypeIcon {
    return member.memberType == 'ADULT' ? Icons.person : Icons.child_care;
  }

  String get _attendanceText {
    switch (member.attendanceStatus.toUpperCase()) {
      case 'CHECKED_IN':
      case 'PRESENT':
        return 'Có mặt';
      case 'ABSENT':
      case 'NO_SHOW':
        return 'Vắng';
      default:
        return 'Chưa điểm danh';
    }
  }

  Color get _attendanceColor {
    switch (member.attendanceStatus.toUpperCase()) {
      case 'CHECKED_IN':
      case 'PRESENT':
        return AppColors.success;
      case 'ABSENT':
      case 'NO_SHOW':
        return AppColors.error;
      default:
        return AppColors.textHint;
    }
  }

  IconData get _attendanceIcon {
    switch (member.attendanceStatus.toUpperCase()) {
      case 'CHECKED_IN':
      case 'PRESENT':
        return Icons.check_circle;
      case 'ABSENT':
      case 'NO_SHOW':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }
}
