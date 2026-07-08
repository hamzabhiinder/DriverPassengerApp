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
    final carWidth = 0.5.sw;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? const Color(0xFFB88E2F) : Colors.white.withOpacity(0.06),
              width: selected ? 1.5.w : 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Stack(
              children: [
                Positioned(
                  right: 4.w,
                  bottom: 8.h,
                  child: Image.asset(
                    option.imageAsset,
                    width: carWidth,
                    height: 140.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CategoryChip(label: option.categoryLabel),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                option.priceLabel,
                                style: AppTypography.castoro(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Estimated Price',
                                style: AppTypography.geist(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.bodySecondary.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 10.h),
                      
                      Text(
                        option.name,
                        style: AppTypography.castoro(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      
                      SizedBox(height: 4.h),
                      
                      SizedBox(
                        width: 0.52.sw,
                        child: Text(
                          _getVehicleDescription(option.name),
                          style: AppTypography.geist(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.bodySecondary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 18.h),
                      
                      _buildVehicleSpecifications(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSpecifications() {
    final name = option.name.toLowerCase();
    
    if (name.contains('sprinter')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow(Icons.person_rounded, '6 â€“ 14', 'Guests'),
          SizedBox(height: 10.h),
          _buildSpecRow(Icons.business_center_rounded, 'Luggage', 'Varies'),
          SizedBox(height: 10.h),
          _buildSpecRow(Icons.ac_unit_rounded, 'Premium', 'Climate Control'),
        ],
      );
    } else if (name.contains('bus') || name.contains('party')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow(Icons.person_rounded, '12 â€“ 22', 'Guests'),
          SizedBox(height: 10.h),
          _buildSpecRow(Icons.music_note_rounded, 'Premium', 'Amenities'),
          SizedBox(height: 10.h),
          _buildSpecRow(Icons.volume_up_rounded, 'High-End', 'Sound System'),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow(Icons.person_rounded, option.passengersLabel, 'Guests'),
          SizedBox(height: 10.h),
          _buildSpecRow(Icons.business_center_rounded, option.luggageLabel, 'Luggage'),
        ],
      );
    }
  }

  Widget _buildSpecRow(IconData icon, String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: const Color(0xFFC59341),
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTypography.geist(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: AppTypography.geist(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
                color: AppColors.bodySecondary.withValues(alpha: 0.5),
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getVehicleDescription(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('sprinter')) {
      return 'Luxury group travel. Elevated experience.';
    } else if (lowerName.contains('bus') || lowerName.contains('party')) {
      return 'Big moments. Unmatched experience.';
    } else {
      return 'Premium luxury options tailored for comfort.';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: const Color(0xFFB88E2F).withOpacity(0.4),
          width: 0.8.w,
        ),
        color: const Color(0xFFB88E2F).withOpacity(0.05),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.geist(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFC59341),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}