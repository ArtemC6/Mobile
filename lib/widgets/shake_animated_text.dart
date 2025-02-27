import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ShakeAnimatedText extends AnimatedText {
  ShakeAnimatedText(
    String text, {
    super.textStyle,
    super.duration = const Duration(milliseconds: 100),
  }) : super(
          text: text,
        );
  late Animation<double> animation;

  @override
  void initAnimation(AnimationController controller) {
    animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    );
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: child,
    );
  }

  @override
  Widget completeText(BuildContext context) {
    return DefaultTextStyle(
      style: textStyle!,
      child: Text(text),
    );
  }
}
