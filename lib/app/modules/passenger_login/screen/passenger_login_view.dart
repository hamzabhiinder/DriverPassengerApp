import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glowing_divider.dart' show GlowingDivider;
import '../controller/passenger_login_controller.dart';

class PassengerLoginView extends GetView<PassengerLoginController> {
  const PassengerLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 130.h,
            right: 0,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/passenger_role_bg.png',
                  width: 1.sw,
                  height: 280.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
                Container(
                  width: 1.sw,
                  height: 280.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.background,
                        AppColors.background.withOpacity(0.0),
                        AppColors.background.withOpacity(0.0),
                        AppColors.background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.2, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                24.w,
                16.h,
                24.w,
                16.h + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),

                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 120.w,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    'LUXURY ON DEMAND',
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.goldRing.withValues(alpha: 0.45),
                      letterSpacing: 4.0,
                    ),
                  ),

                  SizedBox(
                    height: 140.h,
                  ),
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: AppTypography.castoro(
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onBackgroundBright,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  GlowingDivider(
                    color: AppColors.goldMid,
                    glowColor: AppColors.goldRing,
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    'Enter your phone number to continue',
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.bodySecondary.withValues(alpha: 0.5),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  _buildCustomPhoneInputField(),

                  SizedBox(height: 18.h),

                  Row(
                    children: [
                      SizedBox(width: 8.w),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: const Color(0xFFB88E2F),
                            size: 30.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.h),
                            child: Icon(
                              Icons.lock_outline,
                              color: const Color(0xFFB88E2F),
                              size: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          "We'll send you a one-time PIN code\nto securely sign you in.",
                          style: AppTypography.geist(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.bodySecondary.withValues(
                              alpha: 0.5,
                            ),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 28.h),

                  _buildContinueButton(),

                  SizedBox(height: 48.h),

                  _buildFooterSupportRow(),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenDivider() {
    return Center(
      child: SizedBox(
        width: 130.w,
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
              width: 3.w,
              height: 3.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD479),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD479),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomPhoneInputField() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(
            0xFFB88E2F,
          ).withOpacity(0.35),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB88E2F).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          Icon(
            Icons.phone_outlined,
            color: const Color(0xFFB88E2F),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            '+1',
            style: AppTypography.geist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Container(
            width: 1.w,
            height: 20.h,
            color: Colors.white.withOpacity(0.12),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              autocorrect: false,
              style: AppTypography.geist(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: '(555) 123-4567',
                hintStyle: AppTypography.geist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.25),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: controller.sendOtp,
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
                  'Continue',
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
                Icons
                    .arrow_forward_rounded,
                color: const Color(0xFFB88E2F),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSupportRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white.withOpacity(0.08)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB88E2F).withOpacity(0.4),
                  width: 1.w,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.headset_mic,
                color: const Color(0xFFB88E2F),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: AppTypography.geist(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Contact Support',
                      style: AppTypography.geist(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFC59341),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFFC59341),
                      size: 14.sp,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 16.w),

        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.08), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
