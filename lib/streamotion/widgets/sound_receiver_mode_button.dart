import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class SoundReceiverModeButton extends StatelessWidget {
  const SoundReceiverModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () {
          VibrationController.onPressedVibration();
          GoRouter.of(context).go(
            '/soundreceivermode',
          );
        },
        icon: Icon(
          Icons.record_voice_over,
          size: 30,
          color: mTheme.primary,
        ),
      ),
    );
  }
}
