import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/black_x_brand_header.dart';
import '../../core/widgets/glowing_divider.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BlackXBrandHeader(
                logoHeight: 160,
                compact: true,
                showLuxuryTagline: false,
              ),
              SizedBox(height: 12.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Welcome to ',
                  style: AppTypography.castoro(
                    fontSize: AppFontSize.headline,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'BlackX',
                      style: AppTypography.castoro(
                        fontSize: AppFontSize.headline,
                        fontWeight: FontWeight.w400,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              const GlowingDivider(showCenterDot: true),
              SizedBox(height: 10.h),
              Text(
                'LUXURY ON DEMAND',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: AppFontSize.overline,
                  fontWeight: FontWeight.w500,
                  color: AppColors.goldColor,
                  letterSpacing: 4.5,
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                'Select Portal',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: AppFontSize.label,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface.withValues(alpha: 0.45),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                final String? selected = controller.rxSelectedRole.value;
                return Column(
                  children: [
                    _PortalCard(
                      title: 'Book a Ride',
                      subtitle: 'Executive transportation',
                      detail: 'Airport Transfers • Hourly • Events • And More',
                      imageAsset: 'assets/images/escalade.png',
                      icon: Icons.person_rounded,
                      features: const [
                        (LucideIcons.plane, 'Airport\nTransfers'),
                        (LucideIcons.calendar, 'Events &\nOccasions'),
                        (LucideIcons.crown, 'Luxury\nChauffeurs'),
                      ],
                      isActive: selected == 'passenger',
                      isAnySelected: selected != null,
                      onTap: controller.pickPassenger,
                    ),
                    SizedBox(height: 14.h),
                    _PortalCard(
                      title: 'Driver Portal',
                      subtitle: 'For approved BlackX chauffeurs',
                      detail:
                          'Sign in to accept premium ride requests, manage your schedule, and track your earnings.',
                      imageAsset: 'assets/images/chauffeur_portrait.png',
                      icon: Icons.person_pin_rounded,
                      inviteOnly: true,
                      features: const [
                        (Icons.drive_eta_outlined, 'Accept Ride\nRequests'),
                        (LucideIcons.calendarRange, "View Today's\nSchedule"),
                        (LucideIcons.barChart, 'Track\nEarnings'),
                      ],
                      isActive: selected == 'driver',
                      isAnySelected: selected != null,
                      onTap: controller.pickDriver,
                    ),
                  ],
                );
              }),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Expanded(child: _fadeLine(left: true)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'SERVING TOP CITIES NATIONWIDE',
                      style: AppTypography.geist(
                        fontSize: AppFontSize.micro,
                        fontWeight: FontWeight.w500,
                        color: AppColors.goldColor.withValues(alpha: 0.75),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(child: _fadeLine(left: false)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.goldColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Trusted by executives. Driven by professionals.',
                    style: AppTypography.geist(
                      fontSize: AppFontSize.overline,
                      fontWeight: FontWeight.w300,
                      color: AppColors.onSurface.withValues(alpha: 0.55),
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

  Widget _fadeLine({required bool left}) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: left ? Alignment.centerLeft : Alignment.centerRight,
          end: left ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            Colors.transparent,
            AppColors.goldColor.withValues(alpha: 0.35),
          ],
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  const _PortalCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.imageAsset,
    required this.icon,
    required this.features,
    required this.isActive,
    required this.isAnySelected,
    required this.onTap,
    this.inviteOnly = false,
  });

  final String title;
  final String subtitle;
  final String detail;
  final String imageAsset;
  final IconData icon;
  final List<(IconData, String)> features;
  final bool isActive;
  final bool isAnySelected;
  final VoidCallback onTap;
  final bool inviteOnly;

  @override
  Widget build(BuildContext context) {
    final Color accent = isActive
        ? AppColors.goldColor
        : AppColors.goldColor.withValues(alpha: 0.85);
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1.0 : (isAnySelected ? 0.55 : 1.0),
        child: Container(
          constraints: BoxConstraints(minHeight: 200.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: isActive
                  ? AppColors.goldColor.withValues(alpha: 0.75)
                  : AppColors.goldColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            child: Stack(
              children: [
                Positioned(
                  right: -50.w,
                  top: 0,
                  bottom: 0,
                  width: 0.5.sw,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
                Positioned(
                  right: 0.28.sw,
                  top: 0,
                  bottom: 0,
                  width: 0.5.sw,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // begin: Alignment.centerLeft,
                        // end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF0C0C0C),
                          const Color(0xFF0C0C0C).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 12.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accent.withValues(alpha: 0.55),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: accent, size: 18.sp),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTypography.castoro(
                                    fontSize: AppFontSize.titleSmall,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  subtitle,
                                  style: AppTypography.geist(
                                    fontSize: AppFontSize.overline,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.goldLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (inviteOnly)
                            Container(
                              margin: EdgeInsets.only(right: 4.w, top: 2.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 7.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.goldColor,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.buttonRadiusPill,
                                ),
                              ),
                              child: Text(
                                'INVITE ONLY',
                                style: AppTypography.geist(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.goldColor,
                            size: 22.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: 0.52.sw,
                        child: Text(
                          detail,
                          style: AppTypography.geist(
                            fontSize: AppFontSize.micro,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.55),
                            height: 1.35,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: 0.55.sw,
                        child: Row(
                          children: [
                            for (int i = 0; i < features.length; i++) ...[
                              if (i > 0)
                                Container(
                                  width: 1,
                                  height: 28.h,
                                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(
                                      features[i].$1,
                                      color: accent,
                                      size: 18.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      features[i].$2,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.geist(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withValues(
                                          alpha: 0.55,
                                        ),
                                        height: 1.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
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
}
