import 'dart:math';

import 'package:flutter/material.dart';

class StreamotionUtils {
  static double normalizeDistance(double distance) {
    return pow(1 - distance / sqrt(8), 2).toDouble();
  }

  static Color getPointColor(double x, double y) {
    final r = sqrt(x * x + y * y);
    var theta = atan2(y, x) - pi / 2;

    while (theta < 0) {
      theta += 2 * pi;
    }

    final hue = theta / (2 * pi);
    final saturation = r.clamp(0, 1).toDouble();

    return HSVColor.fromAHSV(1, hue * 360, saturation, 1).toColor();
  }

  static Color getPointColorAccent(double x, double y) {
    var theta = atan2(y, x) - pi / 2;

    while (theta < 0) {
      theta += 2 * pi;
    }

    final hue = theta / (2 * pi);

    return HSVColor.fromAHSV(1, hue * 360, 1, 1).toColor();
  }
}
