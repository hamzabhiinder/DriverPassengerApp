import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

/// Soft gold glow line used under titles (Welcome, etc.).
/// Sizes come from [AppSizes.glowingDividerWidth] / [AppSizes.glowingDividerHeight].
class GlowingDivider extends StatelessWidget {
  const GlowingDivider({
    super.key,
    this.width = AppSizes.glowingDividerWidth,
    this.height = AppSizes.glowingDividerHeight,
    this.color = AppColors.goldColor,
    this.showCenterDot = false,
  });

  final double width;
  final double height;
  final Color color;
  final bool showCenterDot;

  @override
  Widget build(BuildContext context) {
    final Widget line = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadiusPill),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.55),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                color.withValues(alpha: 0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
    if (!showCenterDot) {
      return line;
    }
    return SizedBox(
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          line,
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 6,
                  spreadRadius: 1.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
