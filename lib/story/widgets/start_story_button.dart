import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:voccent/widgets/animation_widget.dart';

class StartButton extends StatefulWidget {
  const StartButton({required this.onTap, required this.textButton, super.key});

  final VoidCallback onTap;
  final String textButton;

  @override
  State<StatefulWidget> createState() => _StartStoryButtonState();
}

class _StartStoryButtonState extends State<StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.12).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: FlutterColorsBorder(
                size: const Size(double.infinity, 72),
                colors: const [
                  Colors.white,
                  Colors.transparent,
                ],
                borderWidth: 1,
                child: Shimmer(
                  colorOpacity: 0.9,
                  duration: const Duration(seconds: 4),
                  interval: const Duration(milliseconds: 100),
                  child: FxContainer(
                    alignment: Alignment.center,
                    height: 72,
                    splashColor: mTheme.onPrimary.withAlpha(40),
                    color: mTheme.onBackground,
                    child: FxText.headlineSmall(
                      widget.textButton,
                      fontWeight: 700,
                      color: mTheme.background,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
