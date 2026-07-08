import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glowing_divider.dart';
import '../controller/splash_controller.dart';
import '../widgets/start_ride_cta_button.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 550),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: controller.showPremiumSplash.value
              ? _PremiumSplashContent(
                  key: const ValueKey('premium'),
                  bottomInset: bottomInset,
                )
              : const _BlackIntro(key: ValueKey('black')),
        ),
      ),
    );
  }
}

class _BlackIntro extends StatelessWidget {
  const _BlackIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final logoWidth = (0.85.sw).clamp(260.0, 420.0);

    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: logoWidth),

            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36.w,
                  height: 0.8.h,
                  color: AppColors.onSurface.withValues(alpha: 0.15),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'CHAUFFEUR CO.',
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      color: AppColors.onSurface.withValues(alpha: 0.45),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  width: 36.w,
                  height: 0.8.h,
                  color: AppColors.onSurface.withValues(alpha: 0.15),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            Text(
              'LUXURY ON DEMAND.',
              textAlign: TextAlign.center,
              style: AppTypography.geist(
                color: AppColors.onSurface.withValues(alpha: 0.65),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 4.5,
              ),
            ),

            SizedBox(height: 28.h),

            GlowingDivider(),
          ],
        ),
      ),
    );
  }
}

class _PremiumSplashContent extends StatelessWidget {
  const _PremiumSplashContent({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/splash_background.png',
          fit: BoxFit.contain,

          alignment: Alignment.center,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: AppColors.background),
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(
                    alpha: 0.65,
                  ),
                  AppColors.transparent,
                  AppColors.background.withValues(alpha: 0.3),
                  AppColors.background.withValues(
                    alpha: 0.95,
                  ),
                ],
                stops: const [0.0, 0.35, 0.55, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          top: 30.h,
          left: 12.w,
          right: 12.w,
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: (0.2.sw).clamp(220.0, 320.0),
              fit: BoxFit.contain,
            ),
          ),
        ),

        Positioned(
          bottom: 24.h + bottomInset,
          left: 24.w,
          right: 24.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Luxury On Demand',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  color: AppColors.onSurface,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  height: 1.15,
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: 12.h),

              Center(
                child: Container(
                  width: 52.w,
                  height: 1.2.h,
                  color: const Color(0xFFC59341),
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'Professional chauffeurs.\nPremium vehicles. Seamless booking.',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  color: AppColors.onSurface.withValues(alpha: 0.8),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                  letterSpacing: 0.15,
                ),
              ),

              SizedBox(height: 32.h),

              StartRideCtaButton(onPressed: controller.onStartRide),
            ],
          ),
        ),
      ],
    );
  }
}
