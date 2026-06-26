import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppResponsive {
  static const Size designSize = Size(390, 844);

  static bool get isCompact => 1.sw < 360;

  static bool get isNarrow => 1.sw < 400;

  static double whereToPanelHeight() {
    final width = 1.sw;
    final height = 1.sh;
    final widthFactor = width < 360 ? 0.48 : (width < 400 ? 0.52 : 0.56);
    final maxByHeight = height * 0.58;
    final target = height * widthFactor;
    return target.clamp(280.0, math.min(520.0, maxByHeight));
  }
}
