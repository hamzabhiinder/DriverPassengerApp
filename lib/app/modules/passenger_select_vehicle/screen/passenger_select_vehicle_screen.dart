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

  static const _flowStepIndex = 1;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

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
              final items = controller.vehicles;
              return ListView.builder(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
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
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 12.h + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GoldGradientCtaButton(
                  label: 'Continue',
                  onPressed: controller.onContinue,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
