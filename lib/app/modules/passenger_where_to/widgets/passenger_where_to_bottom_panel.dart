import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToBottomPanel extends GetView<PassengerWhereToController> {
  const PassengerWhereToBottomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: AppColors.transparent,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 16 + bottomSafe),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Where to?',
                      style: AppTypography.castoro(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundBright,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: controller.onRecenterMap,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onSurface,
                    ),
                    icon: const Icon(Icons.my_location_rounded, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LocationField(
                controller: controller.pickupController,
                hint: 'Current Location',
                prefixIcon: UnconstrainedBox(
                  child: Image.asset(
                    'assets/icons/location_icon.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _LocationField(
                controller: controller.destinationController,
                hint: 'Where would you like to go?',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: UnconstrainedBox(
                    child: Image.asset(
                      'assets/icons/plane_icon.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _ShortcutTile(
                      icon: const Icon(
                        Icons.event_available,
                        color: AppColors.goldMid,
                        size: 26,
                      ),
                      label: 'Schedule',
                      onTap: controller.onScheduleTap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShortcutTile(
                      icon: const Icon(
                        Icons.bookmark,
                        color: AppColors.goldMid,
                        size: 26,
                      ),
                      label: 'Saved',
                      onTap: controller.onSavedTap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Image.asset(
                        'assets/icons/plane_icon.png',
                        width: 26,
                        height: 26,
                        color: AppColors.goldMid,
                      ),
                      label: 'Airport',
                      onTap: controller.onAirportTap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              GoldGradientCtaButton(
                label: 'Select Vehicle',
                onPressed: controller.onSelectVehicle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTypography.geist(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryContainer,
        hintText: hint,
        hintStyle: AppTypography.geist(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.hint,
        ),

        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
