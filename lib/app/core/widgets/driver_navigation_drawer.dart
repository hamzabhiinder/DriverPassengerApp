import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../routes/app_routes.dart';

class DriverNavigationDrawer extends StatelessWidget {
  const DriverNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, bool)> items = [
      (Icons.dashboard_outlined, 'Dashboard', true),
      (Icons.event_available_outlined, 'Upcoming Trips', false),
      (Icons.history, 'Trip History', false),
      (Icons.attach_money, 'Earnings', false),
      (Icons.account_balance_wallet_outlined, 'Wallet & Payouts', false),
      (Icons.insights_outlined, 'Performance', false),
      (Icons.folder_outlined, 'Documents', false),
      (Icons.directions_car_outlined, 'Vehicle', false),
      (Icons.support_agent, 'Support', false),
      (Icons.notifications_outlined, 'Notifications', false),
      (Icons.settings_outlined, 'Settings', false),
      (Icons.logout, 'Log Out', false),
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
                        backgroundImage: const AssetImage(
                          'assets/images/chauffeur_portrait.png',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'James Anderson',
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
                            Row(
                              children: [
                                Icon(Icons.star, color: AppColors.goldColor, size: 14.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '4.98',
                                  style: AppTypography.geist(
                                    fontSize: 12,
                                    color: AppColors.goldColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(color: AppColors.goldColor.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      'VERIFIED DRIVER',
                      style: AppTypography.geist(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final bool isLogout = item.$2 == 'Log Out';
                  final bool selected = item.$3;
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
                        item.$1,
                        color: isLogout
                            ? Colors.redAccent
                            : (selected ? Colors.black : AppColors.goldColor),
                        size: 20.sp,
                      ),
                      title: Text(
                        item.$2,
                        style: AppTypography.geist(
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: isLogout
                              ? Colors.redAccent
                              : (selected ? Colors.black : Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (isLogout) {
                          Get.offAllNamed(AppRoutes.roleSelect);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.headset_mic_outlined, color: AppColors.goldColor, size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Need Assistance?',
                          style: AppTypography.geist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "We're here 24/7.",
                      style: AppTypography.geist(
                        fontSize: 11,
                        color: AppColors.bodySecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.goldColor),
                        foregroundColor: AppColors.goldColor,
                        minimumSize: Size(double.infinity, 36.h),
                      ),
                      child: const Text('Contact Support'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
              child: Text(
                'Version 2.4.1',
                style: AppTypography.geist(
                  fontSize: 11,
                  color: AppColors.hint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
