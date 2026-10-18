import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/session_service.dart';
import '../../modules/driver_home/driver_home_controller.dart';
import '../../routes/app_routes.dart';

class DriverNavigationDrawer extends StatelessWidget {
  const DriverNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, String)> items = [
      (Icons.dashboard_outlined, 'Dashboard', AppRoutes.driverHome),
      (Icons.event_available_outlined, 'Upcoming Trips', AppRoutes.driverTrips),
      (Icons.history, 'Trip History', AppRoutes.driverTrips),
      (Icons.attach_money, 'Earnings', AppRoutes.driverEarnings),
      (Icons.account_balance_wallet_outlined, 'Wallet & Payouts', AppRoutes.driverWallet),
      (Icons.insights_outlined, 'Performance', AppRoutes.driverPerformance),
      (Icons.folder_outlined, 'Documents', AppRoutes.driverDocuments),
      (Icons.directions_car_outlined, 'Vehicle', AppRoutes.driverVehicle),
      (Icons.support_agent, 'Support', AppRoutes.driverSupport),
      (Icons.notifications_outlined, 'Notifications', AppRoutes.driverNotifications),
      (Icons.settings_outlined, 'Settings', AppRoutes.driverSettings),
      (Icons.logout, 'Log Out', '__logout__'),
    ];
    return Drawer(
      width: 0.82.sw,
      backgroundColor: const Color(0xFF070707),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BLACKX CHAUFFEUR CO.',
                    style: AppTypography.geist(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(Icons.person, color: AppColors.goldColor, size: 28.sp),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Get.find<FirebaseAuthService>()
                                      .currentUser
                                      ?.email
                                      ?.split('@')
                                      .first ??
                                  'Driver',
                              style: AppTypography.geist(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'BlackX Chauffeur',
                              style: AppTypography.geist(
                                fontSize: 12,
                                color: AppColors.bodySecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final (IconData icon, String label, String route) = items[index];
                  final bool isLogout = route == '__logout__';
                  final bool selected = route == AppRoutes.driverHome;
                  return Container(
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: selected
                          ? const LinearGradient(
                              colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
                            )
                          : null,
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        icon,
                        color: isLogout
                            ? Colors.redAccent
                            : (selected ? Colors.black : AppColors.goldColor),
                        size: 20.sp,
                      ),
                      title: Text(
                        label,
                        style: AppTypography.geist(
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: isLogout
                              ? Colors.redAccent
                              : (selected ? Colors.black : Colors.white),
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        if (isLogout) {
                          if (Get.isRegistered<SessionService>()) {
                            await Get.find<SessionService>().logout();
                          } else {
                            Get.offAllNamed(AppRoutes.roleSelect);
                          }
                          return;
                        }
                        final int? tabIndex = switch (route) {
                          AppRoutes.driverHome => 0,
                          AppRoutes.driverTrips => 1,
                          AppRoutes.driverEarnings => 2,
                          AppRoutes.driverAccount => 3,
                          _ => null,
                        };
                        if (tabIndex != null &&
                            Get.isRegistered<DriverHomeController>()) {
                          Get.find<DriverHomeController>().selectTab(tabIndex);
                          if (Get.currentRoute != AppRoutes.driverHome) {
                            Get.offNamed(AppRoutes.driverHome);
                          }
                          return;
                        }
                        if (route == AppRoutes.driverHome) {
                          Get.offNamed(AppRoutes.driverHome);
                          return;
                        }
                        Get.toNamed(route);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
