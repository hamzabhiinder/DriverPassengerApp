import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_responsive.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_navigation_drawer.dart'
    show AppNavigationDrawer;
import '../../../routes/app_routes.dart';
import '../controller/passenger_where_to_controller.dart';
import '../widgets/passenger_where_to_bottom_panel.dart';
import '../widgets/passenger_where_to_map_layer.dart';

class PassengerWhereToScreen extends GetView<PassengerWhereToController> {
  const PassengerWhereToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panelHeight =
        AppResponsive.whereToPanelHeight() +
        30.h;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      drawer: const AppNavigationDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PassengerWhereToMapLayer(),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (scaffoldContext) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(scaffoldContext).openDrawer();
                          },
                          child: Container(
                            width: 44.w,
                            height: 44.h,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.menu_rounded,
                              color: const Color(0xFFC59341),
                              size: 28.sp,
                            ),
                          ),
                        );
                      },
                    ),

                    GestureDetector(
                      onTap: controller.onRecenterMap,
                      child: Container(
                        width: 44.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.gps_fixed_rounded,
                          color: const Color(0xFFC59341),
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
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
