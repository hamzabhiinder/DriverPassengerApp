import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class BlackXBrandHeader extends StatelessWidget {
  const BlackXBrandHeader({
    super.key,
    this.logoHeight,
    this.showLuxuryTagline = true,
    this.compact = false,
  });

  final double? logoHeight;
  final bool showLuxuryTagline;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double height = logoHeight ?? (compact ? 88.h : 120.h);
    return Stack(
      alignment: Alignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: height,
          fit: BoxFit.contain,
        ),
        // SizedBox(height: compact ? 4.h : 8.h),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _line(),
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 10.w),
        //       child: Text(
        //         'CHAUFFEUR CO.',
        //         style: AppTypography.geist(
        //           color: AppColors.onSurface.withValues(alpha: 0.65),
        //           fontSize: compact ? 9.sp : 10.sp,
        //           fontWeight: FontWeight.w400,
        //           letterSpacing: 3,
        //         ),
        //       ),
        //     ),
        //     _line(),
        //   ],
        // ),
       
        if (showLuxuryTagline) ...[
          // SizedBox(height: compact ? 10.h : 14.h),
          Positioned(
            bottom: 10,
            child: Text(
              'LUXURY ON DEMAND',
              textAlign: TextAlign.center,
              style: AppTypography.geist(
                color: AppColors.goldColor,
                fontSize: height*0.05,
                fontWeight: FontWeight.w500,
                letterSpacing: compact ? 3.5 : 4.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _line() {
    return Container(
      width: 36.w,
      height: 0.8.h,
      color: AppColors.onSurface.withValues(alpha: 0.2),
    );
  }
}
