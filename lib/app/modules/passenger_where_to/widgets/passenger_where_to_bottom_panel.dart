import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToBottomPanel extends GetView<PassengerWhereToController> {
  const PassengerWhereToBottomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    return Material(
      color: AppColors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0C0C0C),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.bottomSheetRadius),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomSafe),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppSizes.buttonRadiusPill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Where to?',
                style: AppTypography.castoro(
                  fontSize: AppFontSize.headline,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  text: 'Luxury. ',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.label,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'On Demand.',
                      style: AppTypography.geist(
                        fontSize: AppFontSize.label,
                        fontWeight: FontWeight.w500,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _LocationField(
                controller: controller.pickupController,
                hint: 'Current Location',
                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppColors.goldColor,
                  size: AppSizes.inputIconSize.sp,
                ),
                suffixIcon: Icon(
                  Icons.gps_fixed_rounded,
                  color: AppColors.goldColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(height: 10.h),
              _LocationField(
                controller: controller.destinationController,
                hint: 'Where would you like to go?',
                prefixIcon: Icon(
                  Icons.near_me,
                  color: AppColors.goldColor,
                  size: AppSizes.inputIconSize.sp,
                ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _ShortcutTile(
                        icon: Icons.flight,
                        label: 'Airport\nTransfers',
                        subtext: 'On time,\nevery time.',
                        tint: const Color(0xFF1A2430),
                        onTap: controller.onAirportTap,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _ShortcutTile(
                        icon: Icons.watch_later_outlined,
                        label: 'Hourly\nService',
                        subtext: 'By the hour.',
                        tint: const Color(0xFF221A28),
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _ShortcutTile(
                        icon: Icons.sync_rounded,
                        label: 'Round\nTrip',
                        subtext: 'Seamless and\nreliable.',
                        tint: const Color(0xFF1A2420),
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _ShortcutTile(
                        icon: Icons.event_available_outlined,
                        label: 'Schedule\nA Ride',
                        subtext: 'Plan ahead.',
                        tint: const Color(0xFF262018),
                        onTap: controller.onScheduleTap,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const _TrustChip(
                    icon: Icons.verified_user_outlined,
                    label: 'Licensed &\nInsured',
                  ),
                  _trustDivider(),
                  const _TrustChip(
                    icon: Icons.person_outline,
                    label: 'Professional\nChauffeurs',
                  ),
                  _trustDivider(),
                  const _TrustChip(
                    icon: Icons.local_offer_outlined,
                    label: 'No Surge\nPricing',
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              AppPrimaryButton(
                label: 'Choose Vehicle',
                onPressed: controller.onSelectVehicle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trustDivider() {
    return Container(
      width: 1,
      height: 28.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }
}

class _TrustChip extends StatelessWidget {
  const _TrustChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.goldColor, size: 16),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTypography.geist(
              fontSize: AppFontSize.micro,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: controller,
      hint: hint,
      prefix: prefixIcon,
      suffix: suffixIcon,
      isPill: true,
      showBorder: false,
      fillColor: const Color(0xFF141414),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.subtext,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtext;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                tint,
                const Color(0xFF101010),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 10.h, 4.w, 6.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.goldColor.withValues(alpha: 0.65),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.goldColor,
                          size: 15.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTypography.geist(
                          fontSize: AppFontSize.micro,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldColor,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtext,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.geist(
                          fontSize: 8,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.55),
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 36.w,
                height: 2.h,
                margin: EdgeInsets.only(bottom: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSizes.buttonRadiusPill,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.goldColor.withValues(alpha: 0.35),
                      const Color(0xFFFFD479),
                      AppColors.goldColor.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldColor.withValues(alpha: 0.45),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
