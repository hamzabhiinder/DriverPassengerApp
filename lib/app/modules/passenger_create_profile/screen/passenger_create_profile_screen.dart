import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/black_x_brand_header.dart';
import '../../../core/widgets/glowing_divider.dart';
import '../controller/passenger_create_profile_controller.dart';

class PassengerCreateProfileScreen
    extends GetView<PassengerCreateProfileController> {
  const PassengerCreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final double top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hero: city skyline + Escalade grille (mockup top band)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.34.sh + top,
            child: Image.asset(
              'assets/images/create_profile_header.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/escalade.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: AppColors.background),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.38.sh + top,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.35),
                    AppColors.background.withValues(alpha: 0.55),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 20.h + bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BlackXBrandHeader(
                    logoHeight: 200,
                    compact: true,
                    showLuxuryTagline: false,
                  ),
                  SizedBox(height: 20.h),
                  const _ProfileStepper(currentStep: 3),
                  SizedBox(height: 28.h),
                  Text(
                    'Create Your Profile',
                    textAlign: TextAlign.center,
                    style: AppTypography.castoro(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const GlowingDivider(),
                  SizedBox(height: 8.h),
                  Text(
                    "Let's get you set up.",
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: AppColors.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    'FIRST NAME',
                    style: AppTypography.geist(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hint,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _nameField(
                    controller: controller.firstNameController,
                    hint: 'Enter your first name',
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'LAST NAME',
                    style: AppTypography.geist(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hint,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _nameField(
                    controller: controller.lastNameController,
                    hint: 'Enter your last name',
                  ),
                  SizedBox(height: 28.h),
                  _buildContinueButton(),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.12),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Text(
                          'OR',
                          style: AppTypography.geist(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.hint,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.12),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _socialButton(
                    label: 'Continue with Google',
                    leading: _GoogleMark(size: 20.sp),
                    onTap: controller.continueWithGoogle,
                  ),
                  SizedBox(height: 12.h),
                  _socialButton(
                    label: 'Continue with Apple',
                    leading: Icon(Icons.apple, color: Colors.white, size: 22.sp),
                    onTap: controller.continueWithApple,
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.hint,
                          size: 13.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'Your information is secure and will only be used to enhance your experience.',
                          textAlign: TextAlign.center,
                          style: AppTypography.geist(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: AppColors.bodySecondary.withValues(alpha: 0.55),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameField({
    required TextEditingController controller,
    required String hint,
  }) {
    return AppInputField(
      controller: controller,
      hint: hint,
      prefixIcon: Icons.person_outline,
      borderColor: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildContinueButton() {
    return AppPrimaryButton(
      label: 'Continue',
      onPressed: controller.continueToApp,
      showArrow: false,
    );
  }

  Widget _socialButton({
    required String label,
    required Widget leading,
    required VoidCallback onTap,
  }) {
    return AppSecondaryButton(
      label: label,
      onPressed: onTap,
      leading: leading,
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final Paint blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18
      ..strokeCap = StrokeCap.butt;
    final Paint green = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18;
    final Paint yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18;
    final Paint red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18;
    final Rect arc = Rect.fromLTWH(s * 0.12, s * 0.12, s * 0.76, s * 0.76);
    canvas.drawArc(arc, -0.2, 1.6, false, blue);
    canvas.drawArc(arc, 1.4, 0.9, false, green);
    canvas.drawArc(arc, 2.3, 0.8, false, yellow);
    canvas.drawArc(arc, 3.1, 1.0, false, red);
    final Paint bar = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(s * 0.48, s * 0.42, s * 0.40, s * 0.16),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProfileStepper extends StatelessWidget {
  const _ProfileStepper({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        children: [
          for (int i = 1; i <= 4; i++) ...[
            if (i > 1)
              Expanded(
                child: Container(
                  height: 2.h,
                  color: i <= currentStep
                      ? AppColors.goldColor
                      : Colors.white.withValues(alpha: 0.18),
                ),
              ),
            _stepCircle(i),
          ],
        ],
      ),
    );
  }

  Widget _stepCircle(int step) {
    final bool isDone = step < currentStep;
    final bool isCurrent = step == currentStep;
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? AppColors.goldColor : Colors.transparent,
        border: Border.all(
          color: isDone || isCurrent
              ? AppColors.goldColor
              : Colors.white.withValues(alpha: 0.28),
          width: 1.8,
        ),
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check_rounded, color: Colors.black, size: 16.sp)
            : Text(
                '$step',
                style: AppTypography.geist(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: isCurrent
                      ? AppColors.goldColor
                      : Colors.white.withValues(alpha: 0.35),
                ),
              ),
      ),
    );
  }
}
