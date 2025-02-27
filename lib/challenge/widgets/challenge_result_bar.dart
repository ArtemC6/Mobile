import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/widgets/annotation/ann_energy_stat.dart';
import 'package:voccent/challenge/widgets/annotation/ann_pitch_stat.dart';
import 'package:voccent/challenge/widgets/annotation/ann_pronunciation_stat.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/score_widget_without_background.dart';

class ChallengeResultBar extends StatelessWidget {
  const ChallengeResultBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    const height = 100.00;
    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        final result = state.attempt?.totalPercent.round() ?? 0;

        final color = result <= 33
            ? Colors.red
            : result <= 66
                ? Colors.yellow
                : Colors.green;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            () {
              switch (state.recorderStatus) {
                case RecorderStatus.initial:
                  return const SizedBox(height: height);

                case RecorderStatus.ready:
                  return const SizedBox(height: height);
                case RecorderStatus.starting:
                case RecorderStatus.recording:
                  return SizedBox(
                    height: height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FeatherIcons.mic,
                          color: mTheme.secondary,
                        ),
                        FxSpacing.width(8),
                        FxText.bodyLarge(
                          S.current.genericRecording,
                          fontWeight: 700,
                          fontSize: 14,
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                      ],
                    ),
                  );
                case RecorderStatus.analyzing:
                  return SizedBox(
                    height: height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FeatherIcons.clock,
                          color: mTheme.secondary,
                        ),
                        FxSpacing.width(8),
                        FxText.bodyLarge(
                          S.current.genericAnalyzing,
                          fontWeight: 700,
                          fontSize: 14,
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                      ],
                    ),
                  );
                case RecorderStatus.analyzed:
                  return Column(
                    children: [
                      if (state.attempt?.xpAdd != null &&
                          state.attempt?.xpAdd != 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                          child: SizedBox(
                            height: 94,
                            width: 94,
                            child: RadiusScoreWidgetWithoutBackground(
                              key: ValueKey(result),
                              percent: result / 100,
                              lineColor: Colors.amberAccent,
                              freeColor: Colors.amberAccent.withOpacity(0.1),
                              lineWidth: 1,
                              child: FxText.bodyLarge(
                                '${state.attempt?.xpAdd ?? 0} XP',
                                color: Colors.amberAccent,
                                fontWeight: 700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 18, 18, 18),
                            child: SizedBox(
                              height: 64,
                              width: 64,
                              child: RadiusScoreWidgetWithoutBackground(
                                key: ValueKey(result),
                                percent: result / 100,
                                lineColor: color,
                                freeColor: mTheme.onPrimary.withOpacity(0.1),
                                lineWidth: 1,
                                child: FxText.bodyLarge(
                                  '$result%',
                                  color: mTheme.onSurface.withOpacity(1),
                                  fontWeight: 700,
                                ),
                              ),
                            ),
                          ),
                          AnnEnergyStat(
                            value: state.attempt!.energyPercent,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AnnPitchStat(
                              value: state.attempt!.pitchPercent,
                            ),
                          ),
                          AnnPronunciationStat(
                            value: state.attempt!.pronunciationPercent ?? 0,
                          ),
                        ],
                      ),
                    ],
                  );
                case RecorderStatus.failed:
                  return const SizedBox(height: height);
              }
            }(),
          ],
        );
      },
    );
  }
}
