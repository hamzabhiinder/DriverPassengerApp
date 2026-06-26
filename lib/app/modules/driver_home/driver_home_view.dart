import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart' show AppColors;
import '../../core/theme/app_typography.dart' show AppTypography;
import 'driver_home_controller.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Driver Dashboard',
                          style: AppTypography.castoro(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onBackgroundBright,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => Text(
                            controller.rxIsOnline.value
                                ? 'Active & ready for rides'
                                : 'Ready to accept rides',
                            style: AppTypography.geist(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: AppColors.bodySecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _StatCard(
                        label: "Today's Earnings",
                        value: controller.rxEarnings.value,
                        fallbackIcon: Icons.attach_money_rounded,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => _StatCard(
                        label: "Rides Completed",
                        value: controller.rxRidesCompleted.value,
                        fallbackIcon: Icons.near_me_rounded,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => _StatCard(
                        label: "Hours Online",
                        value: controller.rxHoursOnline.value,
                        fallbackIcon: Icons.watch_later_outlined,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Expanded(
                child: Obx(() {
                  final isOnline = controller.rxIsOnline.value;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isOnline
                        ? _buildOnlineLayout()
                        : _buildOfflineLayout(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineLayout() {
    return Container(
      key: const ValueKey('offline_view'),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.power_settings_new_rounded,
            size: 96.sp,
            color: const Color(0xFF2E2E2E),
          ),
          SizedBox(height: 32.h),
          Text(
            "You're Offline",
            textAlign: TextAlign.center,
            style: AppTypography.castoro(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: AppColors.onBackgroundBright,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Go online to start receiving\nride requests',
            textAlign: TextAlign.center,
            style: AppTypography.geist(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: AppColors.bodySecondary,
              height: 1.4,
            ),
          ),
          const Spacer(),
          _buildGoOnlineButton(),
        ],
      ),
    );
  }

  Widget _buildGoOnlineButton() {
    return GestureDetector(
      onTap: controller.toggleOnlineStatus,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: const Color(0xFFF1D18A).withOpacity(0.3),
            width: 1.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 42.w),
            Expanded(
              child: Center(
                child: Text(
                  'Go Online',
                  style: AppTypography.geist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: const Color(0xFFB88E2F),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineLayout() {
    return Container(
      key: const ValueKey('online_view'),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC59341),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Waiting for ride request...',
                    style: AppTypography.geist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFC59341),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.toggleOnlineStatus,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    'Go Offline',
                    style: AppTypography.geist(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter:
                      controller.initialMapCenter,
                  initialZoom: 14.5,
                  minZoom: 3.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName:
                        'com.blackx.driver',
                  ),

                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.initialMapCenter,
                        width: 60.w,
                        height: 60.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFC59341,
                                ).withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFD479),
                                shape: BoxShape.circle,
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
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: _buildActionSubCard(
                  label: 'View Rides',
                  icon: Icons.location_on_rounded,
                  onTap: () {
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionSubCard(
                  label: 'Earnings',
                  icon: Icons.attach_money_rounded,
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionSubCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFC59341), size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTypography.geist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? assetPath;
  final IconData? fallbackIcon;

  const _StatCard({
    required this.label,
    required this.value,
    this.assetPath,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetPath != null && assetPath!.isNotEmpty)
            Image.asset(
              assetPath!,
              width: 22.w,
              height: 22.h,
              fit: BoxFit.contain,
              color: const Color(0xFFC59341),
            )
          else if (fallbackIcon != null)
            Icon(fallbackIcon, color: const Color(0xFFC59341), size: 22.sp),
          SizedBox(height: 12.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.bodySecondary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackgroundBright,
            ),
          ),
        ],
      ),
    );
  }
}
