import 'package:flutter/material.dart';
import 'package:voccent/widgets/animation_widget.dart';

class RecordingAnimationWrapper extends StatefulWidget {
  const RecordingAnimationWrapper({
    required this.child,
    required this.isRecording,
    required this.isLoading,
    super.key,
  });

  final Widget child;
  final bool isRecording;
  final bool isLoading;

  @override
  State<RecordingAnimationWrapper> createState() =>
      _RecordingAnimationWrapperState();
}

class _RecordingAnimationWrapperState extends State<RecordingAnimationWrapper>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant RecordingAnimationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording) {
      if (!_animationController!.isAnimating) {
        _animationController!.repeat(reverse: true);
      }
    } else {
      _animationController!.stop();
      _animationController!.reset();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final showShadow = widget.isRecording && _animationController!.isAnimating;
    return FlutterColorsBorder(
      boardRadius: 100,
      size: const Size(
        98,
        98,
      ),
      available: widget.isLoading && !widget.isRecording,
      borderWidth: 2.2,
      colors: [
        mTheme.onSecondary,
        Colors.orange,
        mTheme.onSecondary,
        Colors.orange,
      ],
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController!,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: showShadow
                    ? [
                        BoxShadow(
                          color: Colors.orange
                              .withOpacity(_opacityAnimation!.value),
                          spreadRadius: 12,
                          blurRadius: 25,
                        ),
                      ]
                    : [],
              ),
              child: widget.child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
