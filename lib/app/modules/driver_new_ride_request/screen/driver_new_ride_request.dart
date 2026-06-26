import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controller/new_ride_request_controller.dart';

class NewRideRequestView extends StatelessWidget {
  const NewRideRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewRideRequestController());
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

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 115.w,
                      height: 115.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF141414),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          '${controller.rxRemainingSeconds.value}',
                          style: AppTypography.castoro(
                            fontSize: 44,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xFFFFD479,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'seconds to respond',
                      style: AppTypography.geist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.bodySecondary.withOpacity(0.5),
                      ),
                    ),
                  ],
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
                          'New Ride Request',
                          style: AppTypography.castoro(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onBackgroundBright,
                          ),
                        ),
                        Text(
                          '#BL-5678',
                          style: AppTypography.geist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.bodySecondary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: const Color(0xFFC59341),
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Johnson',
                                style: AppTypography.geist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Premium Member',
                                style: AppTypography.geist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.bodySecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    Divider(color: Colors.white.withOpacity(0.08), height: 1),
                    SizedBox(height: 20.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 4.h),
                            Icon(
                              Icons.location_on_rounded,
                              color: const Color(0xFFC59341),
                              size: 20.sp,
                            ),
                            Container(
                              width: 1.5.w,
                              height: 36.h,
                              color: const Color(0xFFC59341).withOpacity(0.3),
                            ),
                            Icon(
                              Icons.near_me_rounded,
                              color: const Color(0xFFC59341),
                              size: 20.sp,
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup Location',
                                style: AppTypography.geist(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.bodySecondary.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Current Location',
                                style: AppTypography.geist(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              Text(
                                'Destination',
                                style: AppTypography.geist(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.bodySecondary.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '12280 Westheimer Rd #5',
                                style: AppTypography.geist(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildRideStat(
                            icon: Icons.watch_later_outlined,
                            value: '5 min',
                            label: 'Away',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildRideStat(
                            icon: Icons.near_me_rounded,
                            value: '18.5km',
                            label: 'Distance',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildRideStat(
                            icon: Icons.attach_money_rounded,
                            value: '\$120.00',
                            label: 'Earning',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.declineRide,
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Decline',
                          style: AppTypography.geist(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.acceptRide,
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
                        alignment: Alignment.center,
                        child: Text(
                          'Accept',
                          style: AppTypography.geist(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC59341), size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
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
}
