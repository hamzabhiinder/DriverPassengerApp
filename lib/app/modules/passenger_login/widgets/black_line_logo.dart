import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BlackLineLogo extends StatelessWidget {
  const BlackLineLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final ruleColor = AppColors.outline;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'BLACK LINE',
          textAlign: TextAlign.center,
          style: AppTypography.castoro(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.onBackgroundBright,
            letterSpacing: 4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Divider(height: 1, thickness: 1, color: ruleColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'CHAUFFEUR Co.',
                style: AppTypography.castoro(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onBackgroundBright,
                  letterSpacing: 2.4,
                ),
              ),
            ),
            Expanded(
              child: Divider(height: 1, thickness: 1, color: ruleColor),
            ),
          ],
        ),
      ],
    );
  }
}
