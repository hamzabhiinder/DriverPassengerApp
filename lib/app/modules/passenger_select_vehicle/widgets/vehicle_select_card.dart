import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/vehicle_option.dart';

class VehicleSelectCard extends StatelessWidget {
  const VehicleSelectCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final VehicleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? AppColors.goldRing : AppColors.transparent,
                width: selected ? 1.5 : 0,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CategoryChip(label: option.categoryLabel),
                                const SizedBox(height: 10),
                                Text(
                                  option.name,
                                  style: AppTypography.castoro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.onBackgroundBright,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    option.starCount,
                                    (_) => const Icon(
                                      Icons.star_rounded,
                                      size: 18,
                                      color: AppColors.goldMid,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  icon: Image.asset(
                                    'assets/images/luggage.png',
                                    width: 24,
                                    height: 24,
                                    color: AppColors.goldMid,
                                  ),
                                  text: option.luggageLabel,
                                  title: 'Luggage',
                                ),
                                const SizedBox(height: 8),
                                _DetailRow(
                                  icon: Image.asset(
                                    'assets/images/person.png',
                                    width: 24,
                                    height: 24,
                                    color: AppColors.goldMid,
                                  ),
                                  text: option.passengersLabel,
                                  title: 'Passengers',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                option.priceLabel,
                                style: AppTypography.castoro(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.onBackgroundBright,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Estimated Price',
                                style: AppTypography.geist(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.onSurfaceMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Image.asset(
                    option.imageAsset,
                    width: 200,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      width: 168,
                      height: 96,
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.onSurfaceMuted,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.onSurfaceMuted.withValues(alpha: 0.45),
        ),
        color: AppColors.background.withValues(alpha: 0.35),
      ),
      child: Text(
        label,
        style: AppTypography.geist(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.bodySecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
    required this.title,
  });

  final Widget icon;
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.geist(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary,
                  height: 1.35,
                ),
              ),
              Text(
                text,
                style: AppTypography.geist(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
