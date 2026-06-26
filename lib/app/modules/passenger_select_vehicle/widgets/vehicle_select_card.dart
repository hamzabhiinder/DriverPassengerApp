import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/vehicle_option.dart';

class VehicleSelectCard extends StatelessWidget {
  const VehicleSelectCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final VehicleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final carWidth = (0.42.sw).clamp(120.0, 200.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: Material(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(18.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: selected ? AppColors.goldRing : AppColors.transparent,
                width: selected ? 1.5 : 0,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CategoryChip(label: option.categoryLabel),
                                SizedBox(height: 10.h),
                                Text(
                                  option.name,
                                  style: AppTypography.castoro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.onBackgroundBright,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: List.generate(
                                    option.starCount,
                                    (_) => Icon(
                                      Icons.star_rounded,
                                      size: 18.sp,
                                      color: AppColors.goldMid,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                _DetailRow(
                                  icon: Image.asset(
                                    'assets/images/luggage.png',
                                    width: 24.w,
                                    height: 24.w,
                                    color: AppColors.goldMid,
                                  ),
                                  text: option.luggageLabel,
                                  title: 'Luggage',
                                ),
                                SizedBox(height: 8.h),
                                _DetailRow(
                                  icon: Image.asset(
                                    'assets/images/person.png',
                                    width: 24.w,
                                    height: 24.w,
                                    color: AppColors.goldMid,
                                  ),
                                  text: option.passengersLabel,
                                  title: 'Passengers',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                option.priceLabel,
                                style: AppTypography.castoro(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.onBackgroundBright,
                                  height: 1.0,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Estimated Price',
                                style: AppTypography.geist(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.onSurfaceMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 12.w,
                  bottom: 12.h,
                  child: Image.asset(
                    option.imageAsset,
                    width: carWidth,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                    errorBuilder: (_, __, ___) => SizedBox(
                      width: 168.w,
                      height: 96.h,
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.onSurfaceMuted,
                        size: 48.sp,
                      ),
                    ),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: AppColors.onSurfaceMuted.withValues(alpha: 0.45),
        ),
        color: AppColors.background.withValues(alpha: 0.35),
      ),
      child: Text(
        label,
        style: AppTypography.geist(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.bodySecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
    required this.title,
  });

  final Widget icon;
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.geist(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary,
                  height: 1.35,
                ),
              ),
              Text(
                text,
                style: AppTypography.geist(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
