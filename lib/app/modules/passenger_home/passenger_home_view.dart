import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/values/app_strings.dart';
import 'passenger_home_controller.dart';

class PassengerHomeView extends GetView<PassengerHomeController> {
  const PassengerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.passengerHome)),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.comingSoon,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: controller.switchRole,
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text(AppStrings.switchRole),
            ),
          ],
        ),
      ),
    );
  }
}
