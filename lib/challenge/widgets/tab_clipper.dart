import 'dart:math' as math;
import 'package:flutter/material.dart';

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path
      ..lineTo(0, 0)
      ..arcTo(
        Rect.fromLTWH(0, 0, radius, radius),
        degreeToRadians(180),
        degreeToRadians(90),
        false,
      )
      ..arcTo(
        Rect.fromLTWH(
          ((size.width / 2) - v / 2) - radius + v * 0.04,
          0,
          radius,
          radius,
        ),
        degreeToRadians(270),
        degreeToRadians(70),
        false,
      )
      ..arcTo(
        Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160),
        degreeToRadians(-140),
        false,
      )
      ..arcTo(
        Rect.fromLTWH(
          (size.width - ((size.width / 2) - v / 2)) - v * 0.04,
          0,
          radius,
          radius,
        ),
        degreeToRadians(200),
        degreeToRadians(70),
        false,
      )
      ..arcTo(
        Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(90),
        false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final redian = (math.pi / 180) * degree;
    return redian;
  }
}
