import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_typography.dart';

/// Primary gold CTA — height comes from [AppSizes.buttonHeight].
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.buttonHeight,
    this.showArrow = true,
    this.isLoading = false,
    this.isPill = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool showArrow;
  final bool isLoading;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    final double radius =
        isPill ? AppSizes.buttonRadiusPill : AppSizes.buttonRadius;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFB88E2F), Color(0xFF8C6239)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            SizedBox(width: showArrow ? AppSizes.buttonIconSize : 12),
            Expanded(
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        label,
                        textAlign: TextAlign.center,
                        style: AppTypography.button(color: Colors.black),
                      ),
              ),
            ),
            if (showArrow)
              Container(
                width: AppSizes.buttonIconSize,
                height: AppSizes.buttonIconSize,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.goldColor,
                  size: 18,
                ),
              )
            else
              const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

/// Outlined secondary / social button — height from [AppSizes.buttonHeight].
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.height = AppSizes.buttonHeight,
    this.isPill = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;
  final double height;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    final double radius =
        isPill ? AppSizes.buttonRadiusPill : AppSizes.buttonRadius;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: leading == null ? null : Center(child: leading),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.button(color: Colors.white).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}
