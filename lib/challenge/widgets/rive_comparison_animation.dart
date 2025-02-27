import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveComparisonAnimation extends StatefulWidget {
  const RiveComparisonAnimation({
    required this.percentage,
    required this.artboard,
    super.key,
  });

  final double? percentage;
  final String artboard;

  @override
  RiveComparisonAnimationState createState() => RiveComparisonAnimationState();
}

class RiveComparisonAnimationState extends State<RiveComparisonAnimation> {
  SMIInput<double>? percent;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);

    percent = controller.findInput<double>('result')! as SMINumber;
    percent?.value = widget.percentage ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percentage == null) {
      return Container();
    } else {
      return IgnorePointer(
        child: RiveAnimation.asset(
          'assets/resultanim.riv',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          onInit: _onRiveInit,
          artboard: widget.artboard,
        ),
      );
    }
  }
}
