import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Pill CTA with gold gradient and circular chevron affordance (shared UI).
class GoldGradientCtaButton extends StatelessWidget {
  const GoldGradientCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.goldDeep,
                AppColors.goldMid,
                AppColors.goldLight,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 6, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldRing, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
