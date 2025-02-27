import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voccent/widgets/dialog.dart';

class StoryPayWall extends StatelessWidget {
  const StoryPayWall({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(),
          ),
        ),
        const SubscriptionDialog(),
      ],
    );
  }
}
