import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:voccent/theme/app_theme.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    required this.image,
    required this.onPressed,
    required this.text,
    super.key,
  });

  final Widget image;
  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.lightTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Shimmer(
          colorOpacity: 0.88,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: FxButton.large(
              padding: const EdgeInsets.symmetric(vertical: 14),
              borderRadiusAll: 14,
              soft: true,
              onPressed: onPressed,
              backgroundColor: Colors.white.withOpacity(0.96),
              elevation: 10,
              shadowColor: theme.hintColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: image,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: FxText.titleMedium(
                      text,
                      color: Colors.black,
                      fontWeight: 700,
                      fontSize: 23.5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
