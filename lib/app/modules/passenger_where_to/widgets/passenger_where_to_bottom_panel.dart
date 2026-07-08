import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
          color: const Color(0xFF0C0C0C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.w),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h + bottomSafe),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'Where to?',
                style: AppTypography.castoro(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundBright,
                ),
              ),

              SizedBox(height: 16.h),

              _LocationField(
                controller: controller.pickupController,
                hint: 'Current Location',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: const Color(0xFFC59341),
                  size: 20.sp,
                ),
                suffixIcon: Icon(
                  Icons.gps_fixed_rounded,
                  color: const Color(0xFFC59341),
                  size: 18.sp,
                ),
              ),

              SizedBox(height: 12.h),

              _LocationField(
                controller: controller.destinationController,
                hint: 'Where would you like to go?',
                prefixIcon: Icon(
                  Icons
                      .near_me_outlined,
                  color: const Color(0xFFC59341),
                  size: 20.sp,
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.flight  ,
                      label: 'Airport\nTransfers',
                      subtext: 'On time, every time.',
                      onTap: controller.onAirportTap,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.watch_later_outlined,
                      label: 'Hourly\nService',
                      subtext: 'By the hour.',
                      onTap: () {
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.sync_rounded,
                      label: 'Round\nTrip',
                      subtext: 'Seamless and\nreliable.',
                      onTap: () {
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ShortcutTile(
                      icon:
                          Icons.event_available_outlined,
                      label: 'Schedule\nA Ride',
                      subtext: 'Plan ahead.',
                      onTap: controller.onScheduleTap,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _buildChooseVehicleButton(onTap: controller.onSelectVehicle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChooseVehicleButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: const Color(0xFFF1D18A).withOpacity(0.3),
            width: 1.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 42.w),
            Expanded(
              child: Center(
                child: Text(
                  'Choose Vehicle',
                  style: AppTypography.geist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFFB88E2F),
                size: 20.sp,
              ),
            ),
          ],
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
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;
  final Widget? suffixIcon;

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
        fillColor: const Color(0xFF141414),
        hintText: hint,
        hintStyle: AppTypography.geist(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.hint,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.subtext,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtext;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.h,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w)
                .copyWith(
                  bottom: 0.h,
                ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.goldColor, size: 24.sp),

                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTypography.geist(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                Text(
                  subtext,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.geist(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.onSurface.withValues(alpha: 0.35),
                    height: 1.2,
                  ),
                ),
                Center(
                  child: Container(
                    width: 32.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          const Color(0xFFC59341).withOpacity(0.3),
                          const Color(0xFFFFD479),
                          const Color(0xFFC59341).withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC59341).withOpacity(0.45),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        ),
                      ],
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
