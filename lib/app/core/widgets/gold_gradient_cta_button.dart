import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import 'app_primary_button.dart';

/// Backwards-compatible alias that uses centralized [AppSizes].
class GoldGradientCtaButton extends StatelessWidget {
  const GoldGradientCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.buttonHeight,
    this.showArrow = true,
  });

  final String label;
  final VoidCallback onPressed;
  final double height;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
      height: height,
      showArrow: showArrow,
    );
  }
}
