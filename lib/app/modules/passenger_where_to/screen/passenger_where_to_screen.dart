import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_responsive.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../controller/passenger_where_to_controller.dart';
import '../widgets/passenger_where_to_bottom_panel.dart';
import '../widgets/passenger_where_to_map_layer.dart';

class PassengerWhereToScreen extends GetView<PassengerWhereToController> {
  const PassengerWhereToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panelHeight = AppResponsive.whereToPanelHeight();

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PassengerWhereToMapLayer(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WelcomeGuestPill(),
                  _ProfileButton(
                    onPressed: () => _openProfileSheet(context),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: panelHeight,
              child: const PassengerWhereToBottomPanel(),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfileSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.onSurface,
              ),
              title: Text(
                'Switch role',
                style: AppTypography.geist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                controller.switchRole();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: AppColors.onSurfaceMuted,
              ),
              title: Text(
                'Passenger home',
                style: AppTypography.geist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                Get.toNamed<void>(AppRoutes.passengerHome);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeGuestPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Text(
          'Welcome, Guest',
          style: AppTypography.geist(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onBackgroundBright,
          ),
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(
            Icons.person_rounded,
            color: AppColors.onBackgroundBright,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
