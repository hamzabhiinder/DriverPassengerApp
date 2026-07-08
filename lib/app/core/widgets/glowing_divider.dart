import 'package:driver_passenger_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlowingDivider extends StatelessWidget {
  const GlowingDivider({
    super.key,
    this.color = AppColors.onSurface,
    this.glowColor = Colors.white,
    this.width = 220,
    this.height = 4,
    this.dotSize = 6,
  });

  final Color color;
  final Color glowColor;
  final double width;
  final double height;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
            ),
          ),
          Container(
            width: dotSize.w,
            height: dotSize.h,
            decoration: BoxDecoration(
              color: glowColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 6.r,
                  spreadRadius: 1.5.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
