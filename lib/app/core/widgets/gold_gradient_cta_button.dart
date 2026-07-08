import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class GoldGradientCtaButton extends StatelessWidget {
  const GoldGradientCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFB88E2F),
                Color(0xFF966C2D),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: const Color(0xFFF1D18A).withOpacity(0.3),
              width: 1.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 6.h, 6.w, 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.geist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  width: 44.w,
                  height: 44.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldRing, width: 1.5),
                  ),
                  child: const ClipOval(child: _AnimatedDoubleChevron()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedDoubleChevron extends StatefulWidget {
  const _AnimatedDoubleChevron();

  @override
  State<_AnimatedDoubleChevron> createState() => _AnimatedDoubleChevronState();
}

class _AnimatedDoubleChevronState extends State<_AnimatedDoubleChevron>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const double _travelPx = 9;
  static const Duration _loop = Duration(milliseconds: 1300);
  static const double _phaseOffset = 0.45;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _loop)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return SizedBox(
          width: 32.w,
          height: 26.h,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [_chevron(t), _chevron((t + _phaseOffset) % 1.0)],
          ),
        );
      },
    );
  }

  Widget _chevron(double t) {
    final dx = -_travelPx + (2 * _travelPx) * t;
    final opacity = (1 - (2 * t - 1).abs()).clamp(0.0, 1.0);
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.onSurface,
          size: 22.sp,
        ),
      ),
    );
  }
}
