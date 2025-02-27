import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveLoadingAnimation extends StatefulWidget {
  const RiveLoadingAnimation({
    super.key,
  });

  @override
  RiveLoadingAnimationState createState() => RiveLoadingAnimationState();
}

class RiveLoadingAnimationState extends State<RiveLoadingAnimation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: RiveAnimation.asset(
        'assets/voccent-loading.riv',
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
      ),
    );
  }
}
