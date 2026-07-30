import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
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
                'Trip Completed Successfully',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Great job on this ride',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 16,
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
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.primaryContainer,
                          child: Icon(Icons.person, color: AppColors.goldColor, size: 18.sp),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Sarah Johnson',
                          style: AppTypography.geist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _buildInvoiceRow('Trip Earnings', '\$120.00'),
                    _buildInvoiceRow('Tip', '\$25.00'),
                    SizedBox(height: 8.h),
                    Divider(color: Colors.white.withOpacity(0.06), height: 1),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Earnings',
                          style: AppTypography.geist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$145.00',
                          style: AppTypography.geist(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFC59341),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _miniStat('Trip Time', '32 min'),
                        _miniStat('Distance', '18.5 km'),
                        _miniStat('Completed', '1:28 PM'),
                      ],
                    ),
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
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.bodySecondary.withOpacity(0.4),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.geist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: AppTypography.geist(
            fontSize: 10,
            color: AppColors.bodySecondary,
          ),
        ),
      ],
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.geist(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: AppColors.bodySecondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton({required VoidCallback onTap}) {
    return AppPrimaryButton(
      label: 'Return to Dashboard',
      onPressed: onTap,
      height: AppSizes.buttonHeightLarge,
    );
  }
}
