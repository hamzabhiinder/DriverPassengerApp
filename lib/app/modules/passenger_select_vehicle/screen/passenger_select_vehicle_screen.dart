import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_select_vehicle_controller.dart';
import '../widgets/vehicle_select_card.dart';

class PassengerSelectVehicleScreen
    extends GetView<PassengerSelectVehicleController> {
  const PassengerSelectVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 68.h,
        leadingWidth: 56.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
          child: Material(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(999.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: Get.back<void>,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.onBackgroundBright,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Vehicle',
              style: AppTypography.castoro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackgroundBright,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose your premium ride',
              style: AppTypography.geist(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.bodySecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final selected = controller.selectedIndex.value;
              final items = controller.activeVehicles;

              return ListView.builder(
                padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return VehicleSelectCard(
                    option: items[index],
                    selected: selected == index,
                    onTap: () => controller.selectVehicle(index),
                  );
                },
              );
            }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => _buildToggleBusesButton(
                    isPartyBusView: controller.rxShowPartyBuses.value,
                    onTap: controller.togglePartyBusView,
                  ),
                ),

                SizedBox(height: 16.h),

                GoldGradientCtaButton(
                  label: 'Continue',
                  onPressed: controller.onContinue,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBusesButton({
    required bool isPartyBusView,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0C0C0C),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFB88E2F).withOpacity(0.35),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isPartyBusView
                  ? Icons.group_rounded
                  : Icons.directions_bus_filled_outlined,
              color: const Color(0xFFC59341),
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isPartyBusView
                        ? 'Back to SUVs'
                        : 'VIP Party Sprinter & Buses',
                    style: AppTypography.geist(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isPartyBusView
                        ? 'View SUV options above'
                        : 'View premium group options below',
                    style: AppTypography.geist(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFC59341),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isPartyBusView
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFFC59341),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
