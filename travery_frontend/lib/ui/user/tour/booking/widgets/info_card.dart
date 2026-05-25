import 'package:flutter/material.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';

class InfoCard extends StatelessWidget {
  final List<Widget> children;

  const InfoCard({super.key, required this.children});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isBold;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal
                ? FontWeight.w900
                : (isBold ? FontWeight.bold : FontWeight.w600),
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
