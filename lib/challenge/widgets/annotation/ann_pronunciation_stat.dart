import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/generated/l10n.dart';

class AnnPronunciationStat extends StatelessWidget {
  const AnnPronunciationStat({
    required this.value,
    super.key,
  });
  final double value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FxText.bodyLarge(
          S.current.genericPronunciation,
          textAlign: TextAlign.center,
          fontWeight: 500,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 4,
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xff87a0e5).withOpacity(0.6),
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Row(
              children: <Widget>[
                BlocBuilder<ChallengeCubit, ChallengeState>(
                  builder: (context, state) => Container(
                    width: 70 * (state.annotationAvgPronunciation()) / 100,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff87a0e5),
                          const Color(0xff87a0e5).withOpacity(0.5),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: BlocBuilder<ChallengeCubit, ChallengeState>(
            builder: (context, state) => FxText.bodyLarge(
              '${state.annotationAvgPronunciation().toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              fontWeight: 600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
            ),
          ),
        ),
      ],
    );
  }
}
