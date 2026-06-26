import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToBottomPanel extends GetView<PassengerWhereToController> {
  const PassengerWhereToBottomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: AppColors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: const Border(top: BorderSide(color: AppColors.outline, width: 1)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h + bottomSafe),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Where to?',
                      style: AppTypography.castoro(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundBright,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: controller.onRecenterMap,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onSurface,
                    ),
                    icon: Icon(Icons.my_location_rounded, size: 22.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _LocationField(
                controller: controller.pickupController,
                hint: 'Current Location',
                prefixIcon: UnconstrainedBox(
                  child: Image.asset(
                    'assets/icons/location_icon.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              _LocationField(
                controller: controller.destinationController,
                hint: 'Where would you like to go?',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: UnconstrainedBox(
                    child: Image.asset(
                      'assets/icons/plane_icon.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icon(
                        Icons.event_available,
                        color: AppColors.goldMid,
                        size: 24.sp,
                      ),
                      label: 'Schedule',
                      onTap: controller.onScheduleTap,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icon(
                        Icons.bookmark,
                        color: AppColors.goldMid,
                        size: 24.sp,
                      ),
                      label: 'Saved',
                      onTap: controller.onSavedTap,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Image.asset(
                        'assets/icons/plane_icon.png',
                        width: 24.w,
                        height: 24.w,
                        color: AppColors.goldMid,
                      ),
                      label: 'Airport',
                      onTap: controller.onAirportTap,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              GoldGradientCtaButton(
                label: 'Select Vehicle',
                onPressed: controller.onSelectVehicle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTypography.geist(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryContainer,
        hintText: hint,
        hintStyle: AppTypography.geist(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.hint,
        ),
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryContainer,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 6.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 6.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: AppTypography.geist(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
