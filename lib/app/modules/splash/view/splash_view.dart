import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.5,
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
          'assets/images/car_image.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
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
                  AppColors.background.withValues(alpha: 0.45),
                  AppColors.transparent,
                  AppColors.background.withValues(alpha: 0.2),
                  AppColors.background.withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.35, 0.55, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Elevate Your',
                  textAlign: TextAlign.center,
                  style: AppTypography.castoro(
                    color: AppColors.onSurface,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    height: 1.05,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Travel',
                  textAlign: TextAlign.center,
                  style: AppTypography.castoro(
                    color: AppColors.onSurface,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    height: 1.05,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Begin Your Premium Journey.',
                  textAlign: TextAlign.center,
                  style: AppTypography.geist(
                    color: AppColors.onSurface.withValues(alpha: 0.92),
                    fontSize: 21,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 28),
                StartRideCtaButton(onPressed: controller.onStartRide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
