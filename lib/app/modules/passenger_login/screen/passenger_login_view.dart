import 'package:driver_passenger_app/app/core/widgets/glowing_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controller/passenger_login_controller.dart';

class PassengerLoginView extends GetView<PassengerLoginController> {
  const PassengerLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),

              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 140.w,
                  fit: BoxFit.contain,
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Welcome to ',
                  style: AppTypography.castoro(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'BlackX',
                      style: AppTypography.castoro(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: const Color(
                          0xFFC59341,
                        ), // Golden brand highlight
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),
              GlowingDivider(
                color: const Color(0xFFC59341),

                glowColor: const Color(0xFFC59341).withOpacity(0.5),
              ),
              SizedBox(height: 8.h),

              // 3. Spaced Subtitle
              Text(
                'LUXURY ON DEMAND',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                  letterSpacing: 8.0,
                ),
              ),

              SizedBox(height: 36.h),

              // 4. Large Primary Welcome Title
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),

              SizedBox(height: 8.h),

              GlowingDivider(
                color: const Color(0xFFC59341),
                glowColor: const Color(0xFFC59341).withOpacity(0.5),
              ),

              SizedBox(height: 18.h),

              // Input instructions subtext
              Text(
                'Enter your phone number to continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurface.withValues(alpha: 0.8),
                ),
              ),

              SizedBox(height: 50.h),

              // 5. Custom Pill Phone Input Field (Placeholder updated)
              _buildCustomPhoneInputField(),

              SizedBox(height: 18.h),

              // 6. Security Disclaimer Row
              Row(
                children: [
                  SizedBox(width: 8.w),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: const Color(0xFFB88E2F),
                        size: 26.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: const Color(0xFFB88E2F),
                          size: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      "We'll send you a one-time PIN code\nto secure sign you in.",
                      style: AppTypography.geist(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.bodySecondary.withValues(alpha: 0.5),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // 7. Gold Gradient CTA Continue Button with double right arrow
              _buildContinueButton(),

              SizedBox(height: 48.h),

              // 8. Footer Contact Support element flanked by fading lines
              _buildFooterSupportRow(),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  // Glowing center gold line divider
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

  // Phone input pill container
  Widget _buildCustomPhoneInputField() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(999.r), // Pill shape border radius
        border: Border.all(
          color: const Color(0xFFB88E2F).withOpacity(0.35),
          width: 1.w,
        ),
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
            color: const Color(0xFFB88E2F), // Dropdown arrow colored gold
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
                hintText: '+971 50 123 4567', // Exact mockup placeholder
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

  // Continue CTA Button (concontaining custom double right arrows >>)
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
                    .keyboard_double_arrow_right_rounded, // Double arrow matches exactly
                color: const Color(0xFFB88E2F),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Support elements flanked by fading dividers
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
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB88E2F).withOpacity(0.4),
                  width: 1.w,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.headset_mic_outlined,
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
