import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glowing_divider.dart';
import '../controller/passenger_login_controller.dart';

class PassengerOtpScreenView extends GetView<PassengerLoginController> {
  const PassengerOtpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final boxWidth = 54.w;
    final boxHeight = 62.h;

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
                  width: 120.w,
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

              SizedBox(height: 38.h),

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
                glowColor: const Color(0xFFC59341),
                color: Color(0xFFC59341).withOpacity(0.25),
              ),

              SizedBox(height: 8.h),

              Text(
                'Enter the 4-digit code\nwe sent to your phone',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+1 (555) 123-4567',
                    style: AppTypography.geist(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: controller.changeNumber,
                    child: Icon(
                      Icons.edit_outlined,
                      color: const Color(0xFFC59341),
                      size: 14.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: _OtpBox(
                      index: index,
                      width: boxWidth,
                      height: boxHeight,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              _buildContinueButton(),

              SizedBox(height: 24.h),

              _buildOrDivider(),

              SizedBox(height: 16.h),

              GestureDetector(
                onTap: controller.changeNumber,
                child: Text(
                  'Change Number',
                  textAlign: TextAlign.center,
                  style: AppTypography.geist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFC59341),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              _buildFooterSupportRow(),

              SizedBox(height: 48.h),

              _buildResendSection(),

              SizedBox(height: 12.h),
            ],
          ),
        ),
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

  Widget _buildOrDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80.w,
          height: 0.5.h,
          color: Colors.white.withOpacity(0.1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'OR',
            style: AppTypography.geist(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        Container(
          width: 80.w,
          height: 0.5.h,
          color: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: controller.verify,
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
                Icons.arrow_forward_rounded,
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

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          "Didn't receive a code?",
          textAlign: TextAlign.center,
          style: AppTypography.geist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resend in ',
              style: AppTypography.geist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            Text(
              '00:28',
              style: AppTypography.geist(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC59341),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OtpBox extends GetView<PassengerLoginController> {
  const _OtpBox({
    required this.index,
    required this.width,
    required this.height,
  });

  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: const Color(0xFFB88E2F),
        style: AppTypography.geist(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF0F0F0F),
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          isDense: true,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.12),
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Color(0xFFB88E2F), width: 1.5.w),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            controller.focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
