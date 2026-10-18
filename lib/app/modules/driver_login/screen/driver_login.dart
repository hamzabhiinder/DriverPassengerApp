import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/black_x_brand_header.dart';
import '../../../core/widgets/glowing_divider.dart';
import '../controller/driver_login_controller.dart';

class DriverLoginView extends GetView<DriverLoginController> {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double topInset = MediaQuery.paddingOf(context).top;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: topInset + 70.h,
            right: -160.w,
            left: 60.w,
            height: 0.36.sh,
            child: Image.asset(
              'assets/images/chauffeur_portrait.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/escalade.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.55),
                    AppColors.background.withValues(alpha: 0.92),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.28, 0.48, 0.62],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24.w,
                    8.h,
                    24.w,
                    12.h + bottomInset + keyboardInset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 8.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 4.h),
                        BlackXBrandHeader(
                          logoHeight: keyboardInset > 0 ? 100.h : 140.h,
                          compact: true,
                        ),
                        SizedBox(height: keyboardInset > 0 ? 12.h : 24.h),
                        Text(
                          'Driver Portal',
                          textAlign: TextAlign.center,
                          style: AppTypography.display(
                            color: AppColors.onBackgroundBright,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        const GlowingDivider(),
                        SizedBox(height: 12.h),
                        Text(
                          'Demo: driver@blackx.com / Driver123!',
                          textAlign: TextAlign.center,
                          style: AppTypography.label(
                            color: AppColors.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Company Email',
                            style: AppTypography.label(
                              color: AppColors.bodySecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: controller.emailController,
                          hint: 'you@blackxchauffeurs.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                        ),
                        SizedBox(height: 14.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: AppTypography.label(
                              color: AppColors.bodySecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => _buildTextField(
                            controller: controller.passwordController,
                            hint: '••••••••••••••••',
                            obscureText: !controller.rxIsPasswordVisible.value,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              icon: Icon(
                                controller.rxIsPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.hint,
                                size: AppSizes.inputIconSize,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Obx(
                              () => SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: controller.rxRememberMe.value,
                                  onChanged: (_) =>
                                      controller.toggleRememberMe(),
                                  activeColor: AppColors.goldColor,
                                  side: BorderSide(
                                    color: AppColors.goldColor
                                        .withValues(alpha: 0.6),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remember Me',
                              style: AppTypography.label(
                                color: AppColors.bodySecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Forgot Password?',
                              style: AppTypography.label(
                                fontWeight: FontWeight.w500,
                                color: AppColors.goldColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Obx(
                          () => AppPrimaryButton(
                            label: 'Sign In',
                            onPressed: controller.signIn,
                            isLoading: controller.rxIsLoading.value,
                          ),
                        ),
                        SizedBox(height: 28.h),
                        _buildSupportFooter(),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return AppInputField(
      controller: controller,
      hint: hint,
      prefixIcon: prefixIcon,
      keyboardType: keyboardType,
      obscureText: obscureText,
      suffix: suffix,
      isPill: true,
    );
  }

  Widget _buildSupportFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldColor.withValues(alpha: 0.55),
              width: 1.2.w,
            ),
          ),
          child: Icon(
            Icons.headset_mic_outlined,
            color: AppColors.goldColor,
            size: 18.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help?',
              style: AppTypography.geist(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Row(
              children: [
                Text(
                  'Driver Support',
                  style: AppTypography.geist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.goldColor,
                  size: 16.sp,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
