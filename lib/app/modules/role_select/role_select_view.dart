import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/values/app_strings.dart';
import 'role_select_controller.dart';

class RoleSelectView extends GetView<RoleSelectController> {
  const RoleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.chooseRole, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  _RoleCard(
                    icon: Icons.directions_car_filled_rounded,
                    title: AppStrings.driver,
                    subtitle: AppStrings.driverSubtitle,
                    color: scheme.primaryContainer,
                    onTap: controller.pickDriver,
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    icon: Icons.person_pin_circle_rounded,
                    title: AppStrings.passenger,
                    subtitle: AppStrings.passengerSubtitle,
                    color: scheme.secondaryContainer,
                    onTap: controller.pickPassenger,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
