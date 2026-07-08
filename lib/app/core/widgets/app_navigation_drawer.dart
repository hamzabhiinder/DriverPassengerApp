import 'package:driver_passenger_app/app/core/theme/app_typography.dart'
    show AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
    this.onHomeTap,
    this.onNotificationsTap,
    this.onScheduledRidesTap,
    this.onRideHistoryTap,
    this.onSettingsTap,
    this.onTermsTap,
    this.onMyCardsTap,
    this.onLogoutTap,
    this.userName = "Justin Gutierrez",
    this.userInitials = "JG",
    this.userRating = "0.00",
  });

  final VoidCallback? onHomeTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onScheduledRidesTap;
  final VoidCallback? onRideHistoryTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onMyCardsTap;
  final VoidCallback? onLogoutTap;

  final String userName;
  final String userInitials;
  final String userRating;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.82.sw,
      backgroundColor: const Color(0xFF070707),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
              child: Row(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFC59341),
                        width: 1.5.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      userInitials,
                      style: AppTypography.geist(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFC59341),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: AppTypography.geist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: const Color(0xFFC59341),
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              userRating,
                              style: AppTypography.geist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildDivider(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home_outlined,
                      title: 'Home',
                      onTap:
                          onHomeTap ??
                          () => Get.back(),
                    ),
                    _buildDrawerItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: onNotificationsTap ?? () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Scheduled Rides',
                      onTap: onScheduledRidesTap ?? () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.directions_car_outlined,
                      title: 'Ride History',
                      onTap: onRideHistoryTap ?? () {},
                    ),

                    _buildDivider(),
                    SizedBox(height: 8.h),

                    _buildDrawerItem(
                      icon: Icons
                          .autorenew_rounded,
                      title: 'Account Settings',
                      onTap: onSettingsTap ?? () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.assignment_outlined,
                      title: 'Terms & Conditions',
                      onTap: onTermsTap ?? () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.credit_card_rounded,
                      title: 'My Cards',
                      onTap: onMyCardsTap ?? () {},
                    ),

                    _buildDivider(),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                      child: Text(
                        'App Current Version: 4.51',
                        style: AppTypography.geist(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildLogoutButton(onLogoutTap ?? () {}),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFFC59341), size: 22.sp),
      title: Text(
        title,
        style: AppTypography.geist(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: const Color(0xFFC59341),
        size: 20.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      minLeadingWidth: 20.w,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.05),
      height: 1.h,
      indent: 20.w,
      endIndent: 20.w,
    );
  }

  Widget _buildLogoutButton(VoidCallback? onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFB88E2F).withOpacity(0.35),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: const Color(0xFFC59341),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Logout Account',
                style: AppTypography.geist(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFC59341),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
