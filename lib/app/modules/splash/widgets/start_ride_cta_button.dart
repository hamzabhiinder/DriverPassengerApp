import 'package:flutter/material.dart';

import '../../../core/widgets/gold_gradient_cta_button.dart';

/// Splash “Start ride” — uses shared gold pill CTA.
class StartRideCtaButton extends StatelessWidget {
  const StartRideCtaButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GoldGradientCtaButton(
      label: 'Start Your Ride',
      onPressed: onPressed,
    );
  }
}
