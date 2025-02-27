import 'package:flutter/material.dart';
import 'package:flutx/themes/app_theme.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class StreamotionChatButton extends StatelessWidget {
  const StreamotionChatButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 107, 121, 255).withAlpha(150),
                spreadRadius: 0.5,
                blurRadius: 5,
              ),
            ],
            border: Border.all(
              color: const Color.fromARGB(255, 107, 121, 255),
              width: 0.5,
            ),
            color: isDarkTheme
                ? FxAppTheme.theme.cardTheme.color
                : mTheme.onPrimary,
          ),
          child: FxContainer(
            paddingAll: 16,
            marginAll: 0,
            onTap: () async {
              VibrationController.onPressedVibration();
              await GoRouter.of(context).push(
                '/streamotion',
              );
            },
            color: Colors.transparent,
            child: const StreamotionButton(),
          ),
        ),
      ),
    );
  }
}

class StreamotionButton extends StatefulWidget {
  const StreamotionButton({super.key});

  @override
  StreamotionButtonState createState() => StreamotionButtonState();
}

class StreamotionButtonState extends State<StreamotionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
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
        return Opacity(
          opacity: _animation.value,
          child: RichText(
            text: TextSpan(
              text: 'Streamotion'.toUpperCase(),
              style: TextStyle(
                color: const Color.fromARGB(255, 107, 121, 255),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                    color:
                        const Color.fromARGB(255, 107, 121, 255).withAlpha(150),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
