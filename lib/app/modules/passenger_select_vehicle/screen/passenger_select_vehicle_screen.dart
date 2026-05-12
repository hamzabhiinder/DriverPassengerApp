import 'package:flutter/material.dart';
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
        toolbarHeight: 72,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: Material(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(999),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: Get.back<void>,
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.onBackgroundBright,
                  size: 18,
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
            const SizedBox(height: 2),
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
              // Read Rx here (not only inside itemBuilder) so GetX tracks the subscription.
              final selected = controller.selectedIndex.value;
              final items = controller.vehicles;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
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
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GoldGradientCtaButton(
                  label: 'Continue',
                  onPressed: controller.onContinue,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
