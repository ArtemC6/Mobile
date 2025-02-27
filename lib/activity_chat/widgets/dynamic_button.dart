import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/image_widget.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class DynamicButton extends StatelessWidget {
  const DynamicButton({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    final pattern = RegExp(r'\[(.*?),(.*?)\]');

    final matches = pattern.allMatches(text);
    if (matches.isEmpty) {
      return FxText.bodyMedium(
        text,
        color: mTheme.onSurface.withOpacity(1),
      );
    } else {
      final keyword = matches.first.group(1) ?? '';
      final id = matches.first.group(2) ?? '';

      final image = ImageWidget(
        serverUri: '${context.read<ServerAddress>().httpUri}',
        height: 200,
        width: 200,
      ).getImageForType(keyword, id);

      return InkWell(
        onTap: () {
          VibrationController.onPressedVibration();
          GoRouter.of(context).push('/$keyword/$id');
        },
        child: FxContainer(
          child: Column(
            children: [
              image,
              FxText.bodyMedium(
                text.replaceAll(pattern, 'Tap here!'),
                color: mTheme.onSurface.withOpacity(1),
              ),
            ],
          ),
        ),
      );
    }
  }
}
