import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voccent/widgets/dialog.dart';

class ChallengePayWall extends StatelessWidget {
  const ChallengePayWall({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
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
