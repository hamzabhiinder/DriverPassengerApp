import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/values/app_strings.dart';
import 'driver_home_controller.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.driverHome)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.comingSoon, style: Theme.of(context).textTheme.bodyLarge),
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
