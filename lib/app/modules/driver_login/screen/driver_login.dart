import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controller/driver_login_controller.dart';

class DriverLoginView extends GetView<DriverLoginController> {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),

              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Driver Login',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Sign in to start your shift',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: AppColors.bodySecondary,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Email Address',
                style: AppTypography.geist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.bodySecondary,
                ),
              ),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: controller.emailController,
                hintText: 'driver@blackline.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),

              SizedBox(height: 20.h),

              Text(
                'Password',
                style: AppTypography.geist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.bodySecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => _buildTextField(
                  controller: controller.passwordController,
                  hintText: '••••••••••••••••',
                  obscureText: !controller.rxIsPasswordVisible.value,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.rxIsPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.hint,
                      size: 20.sp,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              _buildSignInButton(),

              SizedBox(height: 28.h),

              GestureDetector(
                onTap: controller.changeNumber,
                child: Text(
                  'Change Number',
                  textAlign: TextAlign.center,
                  style: AppTypography.geist(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFC59341),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autocorrect: false,
      style: AppTypography.geist(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryContainer,
        hintText: hintText,
        hintStyle: AppTypography.geist(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.hint,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          child: Icon(prefixIcon, color: AppColors.onSurface, size: 22.sp),
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Obx(() {
      final isLoading = controller.rxIsLoading.value;
      return GestureDetector(
        onTap: isLoading ? null : controller.signIn,
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
                  child: isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          'Sign In',
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
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
