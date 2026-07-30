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
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12.h),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 115.w,
                      height: 115.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.goldColor.withValues(alpha: 0.5),
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.rxRemainingSeconds.value}',
                              style: AppTypography.castoro(
                                fontSize: 36,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFFD479),
                              ),
                            ),
                            Text(
                              'SECONDS TO\nRESPOND',
                              textAlign: TextAlign.center,
                              style: AppTypography.geist(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.goldColor,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Text(
                        'Request expires in ${controller.rxRemainingSeconds.value} seconds.',
                        style: AppTypography.geist(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: AppColors.bodySecondary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

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
                            fontSize: 14,
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
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.goldColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999.r),
                                  border: Border.all(
                                    color: AppColors.goldColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: AppColors.goldColor, size: 10.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'BLACKX VIP MEMBER',
                                      style: AppTypography.geist(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.goldColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.goldColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.flight, color: AppColors.goldColor, size: 14.sp),
                              SizedBox(width: 4.w),
                              Text(
                                'Airport Transfer',
                                style: AppTypography.geist(
                                  fontSize: 10,
                                  color: AppColors.goldColor,
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
                                  fontSize: 10,
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Pickup ETA: 5 min',
                                style: AppTypography.geist(
                                  fontSize: 11,
                                  color: AppColors.goldColor,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              Text(
                                'Destination',
                                style: AppTypography.geist(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.bodySecondary.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '12280 Westheimer Rd #5, Houston, TX 77077',
                                style: AppTypography.geist(
                                  fontSize: 15,
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
                            icon: Icons.attach_money_rounded,
                            value: '\$120.00',
                            label: 'Earnings',
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                            value: '18.5 mi',
                            label: 'Distance',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Trip Notes',
                        style: AppTypography.geist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    ...[
                      'Hotel pickup at Grand Hyatt',
                      'Client has 2 checked bags',
                      'Meet at valet entrance',
                    ].map(
                      (note) => Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Text(
                          '• $note',
                          style: AppTypography.geist(
                            fontSize: 12,
                            color: AppColors.bodySecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote, color: AppColors.goldColor, size: 16.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'Please ensure vehicle is clean and provide water. Thank you!',
                            style: AppTypography.geist(
                              fontSize: 12,
                              color: AppColors.bodySecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: AppColors.goldColor, size: 14.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'Acceptance Rate: This trip counts toward your acceptance score.',
                            style: AppTypography.geist(
                              fontSize: 10,
                              color: AppColors.bodySecondary.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.declineRide,
                      child: Container(
                        height: 64.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Decline',
                              style: AppTypography.geist(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              'Trip will be offered to another driver',
                              textAlign: TextAlign.center,
                              style: AppTypography.geist(
                                fontSize: 9,
                                color: AppColors.hint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.acceptRide,
                      child: Container(
                        height: 64.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Accept',
                              style: AppTypography.geist(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Trip will be assigned to you',
                              textAlign: TextAlign.center,
                              style: AppTypography.geist(
                                fontSize: 9,
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
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
}
