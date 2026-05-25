import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class CancelReasonInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CancelReasonInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lý do hủy (tùy chọn)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Chia sẻ lý do của bạn để chúng tôi cải thiện dịch vụ...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
