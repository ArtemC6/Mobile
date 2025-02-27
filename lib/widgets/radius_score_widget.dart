import 'dart:math';

import 'package:flutter/material.dart';

class RadiusScoreWidget extends StatefulWidget {
  const RadiusScoreWidget({
    required this.child,
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
    super.key,
  });

  final Widget child;
  final double percent;
  final Gradient fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  @override
  // ignore: library_private_types_in_public_api
  _RadiusScoreWidgetState createState() => _RadiusScoreWidgetState();
}

class _RadiusScoreWidgetState extends State<RadiusScoreWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: widget.percent).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _MyPainter(
                percent: _animation.value,
                fillColor: widget.fillColor,
                lineColor: widget.lineColor,
                freeColor: widget.freeColor,
                lineWidth: widget.lineWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.5),
              child: Center(child: widget.child),
            ),
          ],
        );
      },
    );
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter({
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });

  final double percent;

  final Gradient fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculateArcsRect(size);
    drawBackground(canvas, size);
    drawFreeArc(canvas, arcRect);
    drawFelledArc(canvas, arcRect);
  }

  void drawFelledArc(Canvas canvas, Rect arcRect) {
    const padding = 1.0;
    final paddedArcRect = arcRect.deflate(padding);

    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = lineWidth + 2 * padding
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      paddedArcRect,
      -pi / 2,
      pi * 2 * percent,
      false,
      outerPaint,
    );

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      paddedArcRect,
      -pi / 2,
      pi * 2 * percent,
      false,
      innerPaint,
    );
  }

  void drawFreeArc(Canvas canvas, Rect arcRect) {
    const padding = 1.0;
    final paddedArcRect = arcRect.deflate(padding);

    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = lineWidth + 2 * padding;
    canvas.drawArc(
      paddedArcRect,
      pi * 2 * percent - (pi / 2),
      pi * 2 * (1.0 - percent),
      false,
      outerPaint,
    );

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = freeColor
      ..strokeWidth = lineWidth;
    canvas.drawArc(
      paddedArcRect,
      pi * 2 * percent - (pi / 2),
      pi * 2 * (1.0 - percent),
      false,
      innerPaint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = fillColor.createShader(Offset.zero & size);
    canvas.drawOval(Offset.zero & size, paint);
  }

  Rect calculateArcsRect(Size size) {
    const linesMargin = 3;
    final offset = lineWidth / 2 + linesMargin;
    final arcRect = Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
