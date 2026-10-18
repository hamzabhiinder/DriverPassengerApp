import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import 'passenger_home_controller.dart';

class PassengerHomeView extends GetView<PassengerHomeController> {
  const PassengerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Rider home',
          style: AppTypography.geist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text(
            'Book, track, and manage every ride.',
            style: AppTypography.geist(fontSize: 14, color: AppColors.bodySecondary),
          ),
          SizedBox(height: 16.h),
          AppPrimaryButton(
            label: 'Book a ride',
            onPressed: controller.openWhereTo,
          ),
          SizedBox(height: 16.h),
          _tile(Icons.event_available_outlined, 'Schedule a ride', controller.openSchedule),
          _tile(Icons.calendar_today_outlined, 'Scheduled rides', controller.openScheduledRides),
          _tile(Icons.history, 'Ride history', controller.openHistory),
          _tile(Icons.notifications_none, 'Notifications', controller.openNotifications),
          _tile(Icons.place_outlined, 'Saved places', controller.openSavedPlaces),
          _tile(Icons.account_balance_wallet_outlined, 'Wallet', controller.openWallet),
          _tile(Icons.credit_card, 'My cards', controller.openCards),
          _tile(Icons.support_agent, 'Support', controller.openSupport),
          _tile(Icons.settings_outlined, 'Account settings', controller.openAccount),
          _tile(Icons.assignment_outlined, 'Terms & conditions', controller.openTerms),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: controller.switchRole,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.goldColor,
              side: BorderSide(color: AppColors.goldColor),
              minimumSize: Size(double.infinity, 48.h),
            ),
            child: const Text('Switch role'),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.goldColor),
      title: Text(
        label,
        style: AppTypography.geist(fontSize: 15, color: Colors.white),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.goldColor),
      onTap: onTap,
    );
  }
}
