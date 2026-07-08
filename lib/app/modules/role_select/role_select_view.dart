import 'package:driver_passenger_app/app/core/widgets/glowing_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'role_select_controller.dart';

class RoleSelectView extends GetView<RoleSelectController> {
  const RoleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 24.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Welcome to ',
                  style: AppTypography.castoro(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'BlackX',
                      style: AppTypography.castoro(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFC59341),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              GlowingDivider(
                color: const Color(0xFFC59341),
                glowColor: const Color(0xFFC59341),
              ),

              SizedBox(height: 16.h),

              Text(
                'LUXURY ON DEMAND',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 4.5,
                ),
              ),

              SizedBox(height: 28.h),

              Text(
                'Choose your experience',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurface.withValues(alpha: 0.5),
                ),
              ),

              SizedBox(height: 18.h),

              Obx(() {
                final selected = controller.rxSelectedRole.value;
                return Column(
                  children: [
                    _buildPassengerCard(
                      isActive: selected == 'passenger',
                      isAnySelected: selected != null,
                      onTap: controller.pickPassenger,
                    ),

                    SizedBox(height: 16.h),

                    _buildDriverCard(
                      isActive: selected == 'driver',
                      isAnySelected: selected != null,
                      onTap: controller.pickDriver,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldenDivider() {
    return Center(
      child: SizedBox(
        width: 180.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFC59341).withOpacity(0.25),
                    const Color(0xFFC59341).withOpacity(0.25),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.6, 1.0],
                ),
              ),
            ),
            Container(
              width: 4.w,
              height: 4.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD479),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD479),
                    blurRadius: 6,
                    spreadRadius: 1.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard({
    required bool isActive,
    required bool isAnySelected,
    required VoidCallback onTap,
  }) {
    final goldColor = const Color(0xFFB88E2F);

    final Color currentAccentColor = isActive
        ? goldColor
        : Colors.white.withOpacity(0.35);

    final Color currentTextColor = isActive
        ? Colors.white
        : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1.0 : (isAnySelected ? 0.45 : 1.0),
        child: Container(
          height: 175.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isActive
                  ? goldColor.withOpacity(0.6)
                  : Colors.white.withOpacity(0.08),
              width: 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/passenger_role_bg.png',
                        width: 170.w,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                      Container(
                        width: 170.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0C0C0C),
                              const Color(0xFF0C0C0C).withOpacity(0.0),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: currentAccentColor.withOpacity(0.4),
                                width: 1.w,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: currentAccentColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Passenger',
                                style: AppTypography.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: currentTextColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Book premium transportation',
                                style: AppTypography.geist(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isActive
                                      ? const Color(0xFFFFD479)
                                      : Colors.white.withOpacity(0.35),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildCardFeature(
                                LucideIcons.plane,
                                'Airport\nTransfers',
                                currentAccentColor,
                              ),
                              SizedBox(width: 8.w),
                              _buildVerticalDivider(),
                              SizedBox(width: 8.w),

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        color: currentAccentColor,
                                        size: 24.sp,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: currentAccentColor,
                                          size: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Events &\nOccasions',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.geist(
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.5),
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 8.w),
                              _buildVerticalDivider(),
                              SizedBox(width: 8.w),
                              _buildCardFeature(
                                LucideIcons.crown,
                                'Luxury\nChauffeurs',
                                currentAccentColor,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: currentAccentColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
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

  Widget _buildDriverCard({
    required bool isActive,
    required bool isAnySelected,
    required VoidCallback onTap,
  }) {
    const goldColor = Color(0xFFB88E2F);

    final Color currentAccentColor = isActive
        ? goldColor
        : Colors.white.withOpacity(0.35);

    final Color currentTextColor = isActive
        ? Colors.white
        : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1.0 : (isAnySelected ? 0.45 : 1.0),
        child: Container(
          height: 175.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isActive
                  ? goldColor.withOpacity(0.6)
                  : Colors.white.withOpacity(0.08),
              width: 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/driver_role_bg.png',
                        width: 170.w,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                      Container(
                        width: 170.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0C0C0C),
                              const Color(0xFF0C0C0C).withOpacity(0.0),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: currentAccentColor.withOpacity(0.4),
                                width: 1.w,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons
                                  .person_pin_rounded,
                              color: currentAccentColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Driver Partner',
                                style: AppTypography.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: currentTextColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Join the BlackX network',
                                style: AppTypography.geist(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isActive
                                      ? const Color(0xFFFFD479)
                                      : Colors.white.withOpacity(0.35),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildCardFeature(
                                Icons.monetization_on_outlined,
                                'Earn\nMore',
                                currentAccentColor,
                              ),
                              SizedBox(width: 8.w),
                              _buildVerticalDivider(),
                              SizedBox(width: 8.w),
                              _buildCardFeature(
                                LucideIcons.calendarRange,
                                'Set Your\nSchedule',
                                currentAccentColor,
                              ),
                              SizedBox(width: 8.w),
                              _buildVerticalDivider(),
                              SizedBox(width: 8.w),
                              _buildCardFeature(
                                LucideIcons.barChart,
                                'Growth\nOpportunities',
                                currentAccentColor,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: currentAccentColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
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

  Widget _buildCardFeature(IconData icon, String label, Color accentColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: accentColor, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.geist(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.5),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.w,
      height: 22.h,
      color: Colors.white.withOpacity(0.08),
    );
  }
}
