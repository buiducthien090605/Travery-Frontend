import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

enum ResultIconType { success, error, warning }

class ResultHeader extends StatelessWidget {
  final ResultIconType iconType;
  final String title;
  final String subtitle;

  const ResultHeader({
    super.key,
    required this.iconType,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: _backgroundColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 48, color: _iconColor),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData get _icon {
    switch (iconType) {
      case ResultIconType.success:
        return Icons.check_circle;
      case ResultIconType.error:
        return Icons.error;
      case ResultIconType.warning:
        return Icons.warning;
    }
  }

  Color get _iconColor {
    switch (iconType) {
      case ResultIconType.success:
        return AppColors.success;
      case ResultIconType.error:
        return AppColors.error;
      case ResultIconType.warning:
        return AppColors.warning;
    }
  }

  Color get _backgroundColor {
    switch (iconType) {
      case ResultIconType.success:
        return AppColors.success;
      case ResultIconType.error:
        return AppColors.error;
      case ResultIconType.warning:
        return AppColors.warning;
    }
  }
}
