import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/black_x_brand_header.dart';
import '../controller/splash_controller.dart';
import '../widgets/start_ride_cta_button.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
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
    return const ColoredBox(
      color: AppColors.background,
      child: Center(
        child: BlackXBrandHeader(
          logoHeight: 140,
          compact: true,
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
    final SplashController controller = Get.find<SplashController>();
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-bleed Escalade night hero (mockup After)
        Image.asset(
          'assets/images/splash_escalade_night.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/escalade.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const ColoredBox(color: AppColors.background),
          ),
        ),
        // Top fade for logo readability
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 0.28.sh,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.75),
                  AppColors.background.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom fade so headline + CTA sit on solid black like mockup
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 0.48.sh,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.55),
                  AppColors.background.withValues(alpha: 0.92),
                  AppColors.background,
                ],
                stops: const [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),
        ),
        // Brand lockup — X / BLACK X / CHAUFFEUR CO. (no luxury tagline on splash)
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12.h,
          left: 24.w,
          right: 24.w,
          child: const BlackXBrandHeader(
            logoHeight: 200,
            showLuxuryTagline: false,
            compact: true,
          ),
        ),
        // Lower content matching mockup
        Positioned(
          left: 24.w,
          right: 24.w,
          bottom: 28.h + bottomInset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Luxury On Demand',
                textAlign: TextAlign.center,
                style: AppTypography.display(
                  color: AppColors.onBackgroundBright,
                  // fontSize: 33,
                  fontWeight: FontWeight.w400,
                  
                ),
              ),
              SizedBox(height: 14.h),
              Center(
                child: Container(
                  width: 48.w,
                  height: 1.5.h,
                  color: AppColors.goldColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Professional chauffeurs.\nPremium vehicles. Seamless booking.',
                textAlign: TextAlign.center,
                style: AppTypography.label(
                  color: AppColors.onSurface.withValues(alpha: 0.85),
                  
                ),
              ),
              SizedBox(height: 28.h),
              StartRideCtaButton(onPressed: controller.onStartRide),
            ],
          ),
        ),
      ],
    );
  }
}
