import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/auto_text_control.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class FlutterColorsBorder extends StatefulWidget {
  const FlutterColorsBorder({
    required this.child,
    required this.size,
    super.key,
    this.colors = const [
      Colors.indigo,
      Colors.purple,
    ],
    this.borderWidth = 2,
    this.animation = true,
    this.animationDuration = 5,
    this.boardRadius = 5,
    this.available = true,
  });

  final Widget child;
  final Size size;
  final bool animation;
  final int animationDuration;
  final double boardRadius;
  final List<Color> colors;
  final double borderWidth;
  final bool available;

  @override
  // ignore: library_private_types_in_public_api
  _FlutterColorsBorderState createState() => _FlutterColorsBorderState();
}

class _FlutterColorsBorderState extends State<FlutterColorsBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctl;
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.animationDuration),
    );

    if (widget.animation) {
      _ctl
        ..value = 0.5
        ..repeat();
    }

    colors = widget.colors;
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.available) {
      return widget.child;
    }

    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.boardRadius),
            child: widget.child,
          ),
          CustomPaint(
            size: widget.size,
            painter: _BorderPainter(
              ctl: _ctl,
              colors: colors,
              strokeWidth: widget.borderWidth,
              boardRadius: widget.boardRadius,
            ),
          ),
        ],
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.ctl,
    required this.colors,
    required this.strokeWidth,
    this.boardRadius = 5,
  }) : super(repaint: ctl);

  final Animation<double> ctl;
  final List<Color> colors;
  final double boardRadius;
  final double strokeWidth;
  final Paint _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final stops = List<double>.generate(
      colors.length,
      (index) => index / colors.length,
    );

    final centerPos = Offset(size.width / 2, size.height / 2);

    _paint
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.miter
      ..shader = ui.Gradient.sweep(
        centerPos,
        colors,
        stops,
        TileMode.repeated,
        pi * 2 * ctl.value - pi / 2,
        pi * 2 * ctl.value + pi / 2,
      );

    canvas.drawDRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: centerPos,
          width: size.width,
          height: size.height,
        ),
        Radius.circular(boardRadius),
      ),
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: centerPos,
          width: size.width - 2,
          height: size.height - 2,
        ),
        Radius.circular(boardRadius),
      ),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) {
    return oldDelegate.ctl != ctl;
  }
}

class AnimatedCircleWidget extends StatefulWidget {
  const AnimatedCircleWidget({required this.widget, super.key});

  final Widget widget;

  @override
  // ignore: library_private_types_in_public_api
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<AnimatedCircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _animation = Tween<double>(begin: 0.80, end: 0.94).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
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
        return Transform.scale(
          scale: _animation.value,
          child: widget.widget,
        );
      },
    );
  }
}

class NumberCounter extends StatefulWidget {
  const NumberCounter({
    required this.isActivated,
    required this.xp,
    required this.isPiles,
    required this.isSideMovement,
    super.key,
  });

  final bool isActivated;
  final bool isPiles;
  final bool isSideMovement;
  final int xp;

  @override
  // ignore: library_private_types_in_public_api
  _NumberCounterState createState() => _NumberCounterState();
}

class _NumberCounterState extends State<NumberCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isStart = false;
  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.xp.toDouble(),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _currentNumber = _animation.value.toInt();
        });
      });

    _controller.forward();

    Future.delayed(
      const Duration(seconds: 1),
      () => isStart = true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final mTheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (widget.isPiles && !widget.isSideMovement && isStart)
          SizedBox(
            height: height / 25,
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 800),
              slidingBeginOffset: const Offset(0, 0.80),
              child: Icon(
                Icons.keyboard_double_arrow_up_outlined,
                size: height / 16,
                color: mTheme.onPrimary,
              ),
            ),
          )
        else
          SizedBox(
            height: height / 25,
          ),
        Container(
          margin: EdgeInsets.only(
            top: height / 28,
            bottom: height / 64,
          ),
          height: height / 7.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 42,
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 400),
                slidingBeginOffset: const Offset(0.18, 0.18),
                child: FxText.titleLarge(
                  'XP',
                  fontWeight: 800,
                  style: TextStyle(
                    fontSize: !widget.isActivated ? height / 19 : height / 24,
                    color: mTheme.primary,
                  ),
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 200),
                slidingBeginOffset: const Offset(0.18, 0.18),
                child: FxText.titleLarge(
                  '$_currentNumber',
                  fontWeight: 500,
                  style: TextStyle(
                    color: mTheme.primary,
                    fontSize: !widget.isActivated ? height / 19 : height / 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isPiles && widget.isSideMovement && isStart)
          SizedBox(
            height: height / 17,
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 800),
              slidingBeginOffset: const Offset(0, -0.80),
              child: Icon(
                Icons.keyboard_double_arrow_down_outlined,
                size: height / 16,
                color: mTheme.onPrimary,
              ),
            ),
          )
        else
          SizedBox(
            height: height / 17,
          ),
      ],
    );
  }
}

class ShrinkOnTapWidget extends StatefulWidget {
  const ShrinkOnTapWidget({
    required this.child,
    required this.shrinkScale,
    super.key,
  });

  final Widget child;
  final double shrinkScale;

  @override
  // ignore: library_private_types_in_public_api
  _ShrinkOnTapWidgetState createState() => _ShrinkOnTapWidgetState();
}

class _ShrinkOnTapWidgetState extends State<ShrinkOnTapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 240),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: widget.shrinkScale)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

class LiquidLinearProgressIndicator extends ProgressIndicator {
  LiquidLinearProgressIndicator({
    super.key,
    double super.value = 0.5,
    super.backgroundColor,
    Animation<Color>? super.valueColor,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.center,
    this.direction = Axis.horizontal,
  }) {
    if (borderWidth != null && borderColor == null ||
        borderColor != null && borderWidth == null) {
      throw ArgumentError('borderWidth and borderColor should both be set.');
    }
  }

  final double? borderWidth;
  final Color? borderColor;
  final double? borderRadius;
  final Widget? center;
  final Axis direction;

  Color _getBackgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).colorScheme.background;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).colorScheme.secondary;

  @override
  State<StatefulWidget> createState() => _LiquidLinearProgressIndicatorState();
}

class _LiquidLinearProgressIndicatorState
    extends State<LiquidLinearProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _LinearClipper(
        radius: widget.borderRadius,
      ),
      child: CustomPaint(
        painter: _LinearPainter(
          color: widget._getBackgroundColor(context),
          radius: widget.borderRadius ?? 0,
        ),
        foregroundPainter: _LinearBorderPainter(
          color: widget.borderColor ?? Colors.black,
          width: widget.borderWidth ?? 0,
          radius: widget.borderRadius ?? 0,
        ),
        child: Stack(
          children: <Widget>[
            Wave(
              value: widget.value,
              color: widget._getValueColor(context),
              direction: widget.direction,
            ),
            if (widget.center != null) Center(child: widget.center),
          ],
        ),
      ),
    );
  }
}

class _LinearPainter extends CustomPainter {
  _LinearPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_LinearPainter oldDelegate) => color != oldDelegate.color;
}

class _LinearBorderPainter extends CustomPainter {
  _LinearBorderPainter({
    required this.color,
    required this.width,
    required this.radius,
  });

  final Color color;
  final double width;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final alteredRadius = radius;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          width / 2,
          width / 2,
          size.width - width,
          size.height - width,
        ),
        Radius.circular(alteredRadius - width),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_LinearBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      radius != oldDelegate.radius;
}

class _LinearClipper extends CustomClipper<Path> {
  _LinearClipper({required this.radius});

  final double? radius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius ?? 0),
        ),
      );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Wave extends StatefulWidget {
  const Wave({
    required this.value,
    required this.color,
    required this.direction,
    super.key,
  });

  final double? value;
  final Color color;
  final Axis direction;

  @override
  // ignore: library_private_types_in_public_api
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
        child: Container(
          color: widget.color,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  _WaveClipper({
    required this.animationValue,
    required this.value,
    required this.direction,
  });

  final double animationValue;
  final double? value;
  final Axis direction;

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      final path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0, size.height)
        ..lineTo(0, 0)
        ..close();
      return path;
    }

    final path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (var i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = size.width / 80;
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
              waveHeight +
          (size.width * value!);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (var i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = size.height / 80;
      final dy = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
              waveHeight +
          (size.height - (size.height * value!));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    required this.text,
    required this.duration,
    super.key,
  });

  final String text;
  final Duration duration;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final originalPhraseLength = widget.text.length;
    final isDark = mTheme.brightness == Brightness.dark;

    return TweenAnimationBuilder<int>(
      duration: widget.duration == Duration.zero
          ? const Duration(seconds: 1)
          : widget.duration,
      tween: IntTween(begin: 0, end: originalPhraseLength),
      builder: (BuildContext context, int value, Widget? child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(ui.Radius.circular(16)),
          color: isDark ? Colors.black : Colors.white,
        ),
        child: FxText(
          softWrap: true,
          widget.text.substring(0, value.clamp(0, originalPhraseLength)),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: 0.1,
            fontSize: 38,
            fontWeight: ui.FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class AnimatedGradientContainerWithAnimatedShadow extends StatefulWidget {
  const AnimatedGradientContainerWithAnimatedShadow({
    required this.id,
    super.key,
  });

  final String id;

  @override
  AnimatedGradientContainerWithAnimatedShadowState createState() =>
      AnimatedGradientContainerWithAnimatedShadowState();
}

class AnimatedGradientContainerWithAnimatedShadowState
    extends State<AnimatedGradientContainerWithAnimatedShadow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Gradient?> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _gradientAnimation = LinearGradientTween(
      begin: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff6874E8), Color(0xffff8800)],
      ),
      end: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff6874E8), Colors.green],
      ),
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = S.current.askAi;
    final originalPhraseLength = text.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 32, right: 32),
      child: GestureDetector(
        onTap: () {
          VibrationController.onPressedVibration();
          GoRouter.of(context).push(
            '/activity_chat',
            extra: ActivityChatData(
              operationId: 'userassistant_${widget.id}',
              title: 'Voccent AI',
              imagePath: 'assets/images/Ccwhitebg.png',
              bannerPath: '',
              isVoccentAI: true,
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                decoration: BoxDecoration(
                  gradient: _gradientAnimation.value,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    width: 0.8,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: TweenAnimationBuilder<int>(
              duration: const Duration(seconds: 3),
              tween: IntTween(begin: 0, end: originalPhraseLength),
              builder: (BuildContext context, int value, Widget? child) =>
                  AutoSizeText(
                maxLines: 1,
                wrapWords: AutoTextControl.shouldWrapWords(
                  text.substring(0, value.clamp(0, originalPhraseLength)),
                ),
                text.substring(0, value.clamp(0, originalPhraseLength)),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: ui.FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinearGradientTween extends Tween<LinearGradient?> {
  LinearGradientTween({
    super.begin,
    super.end,
  });

  @override
  LinearGradient? lerp(double t) {
    if (begin == null || end == null) return null;
    return LinearGradient(
      begin: Alignment.lerp(
        begin!.begin as Alignment?,
        end!.begin as Alignment?,
        t,
      )!,
      end: Alignment.lerp(begin!.end as Alignment?, end!.end as Alignment?, t)!,
      colors: _lerpColorList(begin!.colors, end!.colors, t),
    );
  }

  List<Color> _lerpColorList(List<Color> begin, List<Color> end, double t) {
    final result = <Color>[];
    for (var i = 0; i < begin.length; i++) {
      result.add(Color.lerp(begin[i], end[i], t)!);
    }
    return result;
  }
}
