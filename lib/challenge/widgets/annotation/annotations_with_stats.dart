import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/widgets/annotation/ann_energy_stat.dart';
import 'package:voccent/challenge/widgets/annotation/ann_pitch_stat.dart';
import 'package:voccent/challenge/widgets/annotation/ann_pronunciation_stat.dart';

class AnnotationsWithStats extends StatelessWidget {
  const AnnotationsWithStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      child: BlocBuilder<ChallengeCubit, ChallengeState>(
        builder: (context, state) => Stepper(
          physics: const ClampingScrollPhysics(),
          controlsBuilder: (BuildContext context, ControlsDetails details) =>
              Container(),
          currentStep: state.currentAnnotationIndex,
          onStepTapped: (pos) =>
              context.read<ChallengeCubit>().setCurrentAnnotation(pos),
          steps: state.audiosample!.annotations!
              .map(
                (e) => Step(
                  isActive: true,
                  title: FxText.bodyLarge(
                    e.transcription ?? '',
                    fontWeight: 600,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(1),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 196,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AnnEnergyStat(
                            value: state.annotationAvgEnergy(),
                          ),
                        ),
                        Expanded(
                          child: AnnPitchStat(
                            value: state.annotationAvgPitch(),
                          ),
                        ),
                        AnnPronunciationStat(
                          value: state.annotationAvgPronunciation(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
