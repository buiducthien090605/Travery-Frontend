import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDanger;
  final bool isGhost;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDanger = false,
    this.isGhost = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGhost) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.inputBorder),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDanger ? AppColors.error : AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDanger
              ? AppColors.error.withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
