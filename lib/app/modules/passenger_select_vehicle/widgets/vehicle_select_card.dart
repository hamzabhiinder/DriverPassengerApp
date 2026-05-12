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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
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
                                  style: AppTypography.geist(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onBackgroundBright,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                                const SizedBox(height: 10),
                                _DetailRow(
                                  icon: Icons.work_outline_rounded,
                                  text: option.luggageLabel,
                                ),
                                const SizedBox(height: 6),
                                _DetailRow(
                                  icon: Icons.groups_2_outlined,
                                  text: option.passengersLabel,
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
                                style: AppTypography.geist(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onBackgroundBright,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Estimated Price',
                                style: AppTypography.geist(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
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
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    option.imageAsset,
                    width: 168,
                    height: 96,
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
        border: Border.all(color: AppColors.onSurfaceMuted.withValues(alpha: 0.45)),
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
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.goldMid),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.geist(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.bodySecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
