import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    super.key,
  });
  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: gradient.createShader,
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
