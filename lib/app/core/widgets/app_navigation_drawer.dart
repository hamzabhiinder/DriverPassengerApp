import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_passenger_app/app/core/theme/app_sizes.dart';
import 'package:driver_passenger_app/app/core/theme/app_typography.dart'
    show AppTypography;
import 'package:driver_passenger_app/app/data/services/firebase_auth_service.dart';
import 'package:driver_passenger_app/app/data/services/firestore_service.dart';
import 'package:driver_passenger_app/app/data/services/session_service.dart';
import 'package:driver_passenger_app/app/routes/app_routes.dart';
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
    final String? uid = Get.isRegistered<FirebaseAuthService>()
        ? Get.find<FirebaseAuthService>().currentUser?.uid
        : null;
    final Stream<DocumentSnapshot<Map<String, dynamic>>>? profileStream =
        uid == null || !Get.isRegistered<FirestoreService>()
        ? null
        : Get.find<FirestoreService>().watchPassengerDoc(uid);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: profileStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError || !snapshot.hasData) {
          return _drawer(
            context,
            name: userName,
            rating: userRating,
            initials: userInitials,
          );
        }
        final Map<String, dynamic> data =
            snapshot.data?.data() ?? <String, dynamic>{};
        final String name = data['displayName'] as String? ?? userName;
        final String rating =
            (data['rating'] as num?)?.toStringAsFixed(2) ?? userRating;
        return _drawer(
          context,
          name: name,
          rating: rating,
          initials: _initials(name),
        );
      },
    );
  }

  String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return userInitials;
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Widget _drawer(
    BuildContext context, {
    required String name,
    required String rating,
    required String initials,
  }) {
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
                      initials,
                      style: AppTypography.geist(
                        fontSize: 20,
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
                          name,
                          style: AppTypography.geist(
                            fontSize: 18,
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
                              rating,
                              style: AppTypography.geist(
                                fontSize: 14,
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
                      onTap: onHomeTap ??
                          () => _open(context, AppRoutes.passengerWhereTo),
                    ),
                    _buildDrawerItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: onNotificationsTap ??
                          () => _open(context, AppRoutes.passengerNotifications),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Scheduled Rides',
                      onTap: onScheduledRidesTap ??
                          () => _open(context, AppRoutes.passengerScheduledRides),
                    ),
                    _buildDrawerItem(
                      icon: Icons.directions_car_outlined,
                      title: 'Ride History',
                      onTap: onRideHistoryTap ??
                          () => _open(context, AppRoutes.passengerRideHistory),
                    ),
                    _buildDrawerItem(
                      icon: Icons.place_outlined,
                      title: 'Saved Places',
                      onTap: () => _open(context, AppRoutes.passengerSavedPlaces),
                    ),
                    _buildDrawerItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Wallet',
                      onTap: () => _open(context, AppRoutes.passengerWallet),
                    ),
                    _buildDrawerItem(
                      icon: Icons.support_agent,
                      title: 'Support',
                      onTap: () => _open(context, AppRoutes.passengerSupport),
                    ),

                    _buildDivider(),
                    SizedBox(height: 8.h),

                    _buildDrawerItem(
                      icon: Icons.autorenew_rounded,
                      title: 'Account Settings',
                      onTap: onSettingsTap ??
                          () => _open(context, AppRoutes.passengerAccount),
                    ),
                    _buildDrawerItem(
                      icon: Icons.assignment_outlined,
                      title: 'Terms & Conditions',
                      onTap: onTermsTap ??
                          () => _open(context, AppRoutes.passengerTerms),
                    ),
                    _buildDrawerItem(
                      icon: Icons.credit_card_rounded,
                      title: 'My Cards',
                      onTap: onMyCardsTap ??
                          () => _open(context, AppRoutes.passengerCards),
                    ),

                    _buildDivider(),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                      child: Text(
                        'App Current Version: 4.51',
                        style: AppTypography.geist(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildLogoutButton(onLogoutTap ?? () => _logout(context)),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String route) {
    Navigator.of(context).pop();
    if (route == AppRoutes.passengerWhereTo) {
      if (Get.currentRoute != AppRoutes.passengerWhereTo) {
        Get.offNamed<void>(AppRoutes.passengerWhereTo);
      }
      return;
    }
    Get.toNamed<void>(route);
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.of(context).pop();
    if (Get.isRegistered<SessionService>()) {
      await Get.find<SessionService>().logout();
      return;
    }
    Get.offAllNamed<void>(AppRoutes.roleSelect);
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
          fontSize: 16,
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
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
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
                  fontSize: 15,
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
