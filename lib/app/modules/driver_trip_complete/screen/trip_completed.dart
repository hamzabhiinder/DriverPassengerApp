import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controller/trip_completed_controller.dart';

class TripCompletedView extends StatelessWidget {
  const TripCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripCompletedController());
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              _buildConcentricCheckmark(),

              SizedBox(height: 24.h),

              Text(
                'Trip Completed!',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Great job on this ride',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary.withOpacity(0.5),
                ),
              ),

              const Spacer(),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You Earned',
                          style: AppTypography.geist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$120',
                          style: AppTypography.geist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFC59341),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Divider(color: Colors.white.withOpacity(0.06), height: 1),
                    SizedBox(height: 12.h),
                    _buildInvoiceRow('Distance', '18.5km'),
                    _buildInvoiceRow('Duration', '25min'),
                    _buildInvoiceRow('Base Fee', '\$100'),
                    _buildInvoiceRow('Distance Fee', '\$50'),
                  ],
                ),
              ),

              const Spacer(),

              Text(
                "Today's Progress",
                style: AppTypography.castoro(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => _buildProgressStat(
                      icon: Icons.directions_car_filled_outlined,
                      value: controller.rxTodayTrips.value,
                      label: 'Trips',
                    )),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() => _buildProgressStat(
                      icon: Icons.attach_money_rounded,
                      value: controller.rxTodayEarned.value,
                      label: 'Earned',
                    )),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() => _buildProgressStat(
                      icon: Icons.power_settings_new_rounded,
                      value: controller.rxTodayOnlineHours.value,
                      label: 'Online',
                    )),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              _buildContinueButton(onTap: controller.continueDriving),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConcentricCheckmark() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFB88E2F).withOpacity(0.06), width: 1.w),
        ),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFB88E2F).withOpacity(0.12), width: 1.w),
          ),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB88E2F).withOpacity(0.2), width: 1.w),
            ),
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: const BoxDecoration(
                color: Color(0xFFB88E2F),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check_rounded,
                color: Colors.black,
                size: 38.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.geist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.bodySecondary.withOpacity(0.4),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFC59341), size: 22.sp),
          SizedBox(height: 16.h),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.geist(
              fontSize: 11.sp,
              fontWeight: FontWeight.w300,
              color: AppColors.bodySecondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB88E2F),
              Color(0xFF966C2D),
            ],
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
                  'Continue Driving',
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
                Icons.keyboard_double_arrow_right_rounded,
                color: const Color(0xFFB88E2F),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
