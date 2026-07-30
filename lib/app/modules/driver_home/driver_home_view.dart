import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/black_x_brand_header.dart';
import '../../core/widgets/driver_navigation_drawer.dart';
import 'driver_home_controller.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const DriverNavigationDrawer(),
      body: SafeArea(
        child: Obx(() {
          final bool isOnline = controller.rxIsOnline.value;
          return Column(
            children: [
              Expanded(
                child: isOnline
                    ? _buildOnlineBody(context)
                    : _buildOfflineBody(context),
              ),
              const _BottomNav(selectedIndex: 0),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOfflineBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _header(context),
          SizedBox(height: 6.h),
          Text(
            'Welcome back, Driver',
            style: AppTypography.castoro(
              fontSize: AppFontSize.titleSmall,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Available for Dispatch',
                style: AppTypography.geist(
                  fontSize: AppFontSize.caption,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "You're ready to receive ride requests",
            style: AppTypography.geist(
              fontSize: AppFontSize.overline,
              color: AppColors.bodySecondary.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 14.h),
          _statsRow(),
          SizedBox(height: 16.h),
          _scheduleCard(),
          SizedBox(height: 16.h),
          _sectionTitle(
            icon: Icons.insights_outlined,
            title: 'Driver Insights',
            action: 'View Map >',
          ),
          SizedBox(height: 10.h),
          _insightsRow(),
          SizedBox(height: 16.h),
          _offlinePanel(),
          SizedBox(height: 12.h),
          _upcomingOpportunities(),
        ],
      ),
    );
  }

  Widget _buildOnlineBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          SizedBox(height: 6.h),
          Text(
            'Good afternoon, Justin',
            style: AppTypography.castoro(
              fontSize: AppFontSize.titleSmall,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Online • Ready for Dispatch',
                style: AppTypography.geist(
                  fontSize: AppFontSize.caption,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: controller.toggleOnlineStatus,
                child: Text(
                  'Go Offline',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.label,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _statsRow(),
          SizedBox(height: 14.h),
          SizedBox(
            height: 170.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: controller.initialMapCenter,
                  initialZoom: 13.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.blackx.driver',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.initialMapCenter,
                        width: 40.w,
                        height: 40.h,
                        child: Icon(
                          Icons.navigation,
                          color: AppColors.goldColor,
                          size: 28.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'CURRENT DEMAND',
            style: AppTypography.geist(
              fontSize: AppFontSize.caption,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.signal_cellular_alt,
                color: const Color(0xFF4CAF50),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'High — Great time to stay online',
                style: AppTypography.geist(
                  fontSize: AppFontSize.caption,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _demandChip(Icons.flight, 'Airport Queue', '4'),
              SizedBox(width: 8.w),
              _demandChip(Icons.location_city, 'Downtown', 'High'),
              SizedBox(width: 8.w),
              _demandChip(Icons.confirmation_number_outlined, 'Events', '2'),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFB88E2F), Color(0xFF8C6239)],
              ),
              borderRadius: BorderRadius.circular(AppSizes.buttonRadiusPill),
            ),
            child: Row(
              children: [
                Icon(Icons.power_settings_new, color: Colors.black, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "You're Online — Waiting for ride requests",
                    style: AppTypography.geist(
                      fontSize: AppFontSize.caption,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          _upcomingOpportunities(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.goldColor, size: 24.sp),
        ),
        const Expanded(
          child: BlackXBrandHeader(
            logoHeight: 72,
            compact: true,
            showLuxuryTagline: false,
          ),
        ),
        SizedBox(width: 40.w),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.attach_money,
            label: "Today's Earnings",
            value: controller.rxEarnings.value,
            link: 'View breakdown >',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _statCard(
            icon: Icons.directions_car_outlined,
            label: "Today's Trips",
            value: controller.rxRidesCompleted.value,
            link: 'View trips >',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _statCard(
            icon: Icons.star_outline,
            label: 'Acceptance Rate',
            value: '98%',
            link: 'Learn more >',
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required String link,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.goldColor, size: 16.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(
              fontSize: 9,
              color: AppColors.hint,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: AppFontSize.body,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            link,
            style: AppTypography.geist(
              fontSize: 9,
              color: AppColors.goldColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({
    IconData? icon,
    required String title,
    required String action,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.goldColor, size: 16.sp),
          SizedBox(width: 6.w),
        ],
        Text(
          title,
          style: AppTypography.geist(
            fontSize: AppFontSize.body,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: AppTypography.geist(
            fontSize: AppFontSize.caption,
            color: AppColors.goldColor,
          ),
        ),
      ],
    );
  }

  Widget _scheduleCard() {
    final List<(String, String, String)> items = const [
      ('9:30 AM', 'Airport Transfer', 'San Antonio International Airport'),
      ('1:00 PM', 'Executive Ride', 'Downtown San Antonio'),
      ('6:30 PM', 'Reserved Booking', 'La Cantera Resort & Spa'),
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          _sectionTitle(
            icon: Icons.calendar_today_outlined,
            title: "Today's Schedule",
            action: 'View All >',
          ),
          SizedBox(height: 12.h),
          for (int i = 0; i < items.length; i++)
            _scheduleItem(
              time: items[i].$1,
              type: items[i].$2,
              place: items[i].$3,
              isLast: i == items.length - 1,
            ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'No more scheduled rides today...',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.overline,
                    color: AppColors.hint,
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.toggleOnlineStatus,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSizes.buttonRadiusPill,
                    ),
                    border: Border.all(
                      color: AppColors.goldColor.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Text(
                    'Go Online',
                    style: AppTypography.geist(
                      fontSize: AppFontSize.overline,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scheduleItem({
    required String time,
    required String type,
    required String place,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldColor, width: 1.5),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.2,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: AppColors.goldColor.withValues(alpha: 0.35),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 58.w,
                    child: Text(
                      time,
                      style: AppTypography.geist(
                        fontSize: AppFontSize.overline,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: AppTypography.geist(
                            fontSize: AppFontSize.label,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.geist(
                            fontSize: AppFontSize.micro,
                            color: AppColors.bodySecondary.withValues(
                              alpha: 0.75,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3A1B),
                      borderRadius: BorderRadius.circular(
                        AppSizes.buttonRadiusPill,
                      ),
                    ),
                    child: Text(
                      'CONFIRMED',
                      style: AppTypography.geist(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightsRow() {
    return Row(
      children: [
        Expanded(
          child: _insightCard(
            icon: Icons.show_chart,
            title: 'Demand',
            value: 'HIGH',
            subtitle: 'Great time to go online',
            accent: const Color(0xFF4CAF50),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _insightCard(
            icon: Icons.flight,
            title: 'Airport',
            value: 'HIGH',
            subtitle: '17 flights next hour',
            accent: const Color(0xFF2196F3),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _insightCard(
            icon: Icons.sports_basketball,
            title: 'Spurs Game',
            value: 'Today',
            subtitle: '7:30 PM • High demand',
            accent: const Color(0xFF9C27B0),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _insightCard(
            icon: Icons.music_note,
            title: 'Concert',
            value: 'Tonight',
            subtitle: 'Frost Bank 8:00 PM',
            accent: const Color(0xFFE91E63),
          ),
        ),
      ],
    );
  }

  Widget _insightCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color accent,
  }) {
    return Container(
      height: 96.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 14.sp),
          SizedBox(height: 4.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(fontSize: 9, color: accent),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(
              fontSize: AppFontSize.overline,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.geist(
              fontSize: 8,
              color: AppColors.bodySecondary.withValues(alpha: 0.7),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _offlinePanel() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.goldColor.withValues(alpha: 0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.power_settings_new,
                  color: AppColors.goldColor,
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You're Offline",
                      style: AppTypography.castoro(
                        fontSize: AppFontSize.title,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Go online to start receiving premium ride requests.',
                      style: AppTypography.geist(
                        fontSize: AppFontSize.caption,
                        color: AppColors.bodySecondary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 8.h,
            children: const [
              'Airport Transfers',
              'Hourly Service',
              'Executive Rides',
              'VIP Clients',
            ]
                .map(
                  (String label) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.goldColor,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        label,
                        style: AppTypography.geist(
                          fontSize: AppFontSize.overline,
                          color: AppColors.bodySecondary,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 14.h),
          AppPrimaryButton(
            label: 'Go Online',
            onPressed: controller.toggleOnlineStatus,
          ),
        ],
      ),
    );
  }

  Widget _upcomingOpportunities() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: AppColors.goldColor,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Opportunities',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.label,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Events and high demand times',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.micro,
                    color: AppColors.bodySecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 18.w,
            height: 18.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.goldColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '2',
              style: AppTypography.geist(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.goldColor,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _demandChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.goldColor, size: 18.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTypography.geist(fontSize: 9, color: AppColors.hint),
            ),
            Text(
              value,
              style: AppTypography.geist(
                fontSize: AppFontSize.label,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String)> items = [
      (Icons.speed, 'Dashboard'),
      (Icons.directions_car_outlined, 'Trips'),
      (Icons.attach_money, 'Earnings'),
      (Icons.person_outline, 'Account'),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0C),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    color: i == selectedIndex
                        ? AppColors.goldColor
                        : AppColors.hint,
                    size: 22.sp,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    items[i].$2,
                    style: AppTypography.geist(
                      fontSize: 10,
                      color: i == selectedIndex
                          ? AppColors.goldColor
                          : AppColors.hint,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
