import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/widgets/cefr_converter.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';

class ChallengeInfoWidget extends StatelessWidget {
  const ChallengeInfoWidget({
    required this.challenge,
    super.key,
  });

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final ch = challenge.languageId != null
        ? Dictionary.languageName(challenge.languageId!)
        : '...';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FxText.bodyLarge(
                      challenge.name,
                      fontWeight: 700,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ],
              ),
              FxSpacing.height(4),
              Row(
                children: [
                  Expanded(
                    child: FxText.bodyMedium(
                      '${levelToCEFR(challenge.level)}, '
                      '$ch',
                      fontWeight: 500,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
