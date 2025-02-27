import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/story/cubit/models/story_current_pass.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    required this.planPassElementId,
    super.key,
  });

  final String? planPassElementId;

  @override
  Widget build(BuildContext context) => BlocConsumer<StoryCubit, StoryState>(
        listenWhen: (previous, current) =>
            current.skipVideo != previous.skipVideo,
        listener: (context, state) {
          VibrationController.onPressedVibration();
          context.read<StoryCubit>().next();
        },
        builder: (context, state) {
          final mTheme = Theme.of(context).colorScheme;
          final movingToNextScreen = state.loading ? '...' : '';
          final userId = context.read<HomeCubit>().state.user.id;
          final characterName = state.currentPass?.itemCharacterName ?? '';
          final isPlayerTurn = userId == state.currentPass?.userId;
          final hasNext = (state.isNotEmpty
                  ? S.current.genericNext
                  : S.current.genericSkip) +
              movingToNextScreen +
              (_isPauseTimerVisible(state) ? ' (${state.conditionTimer})' : '');

          if (context.read<AuthCubit>().state.isFirstRun &&
              state.currentPass!.type == ItemType.foreignLink) {
            return const SizedBox();
          }

          String? name;

          if (!state.currentPass!.isAudioComparisonOrEmotionAnalysis ||
              state.videosample != null) {
            if (state.currentPass!.type == ItemType.singleTextInput ||
                state.currentPass!.type == ItemType.semanticAnalysis) {
              name = hasNext;
            } else {
              if (_isNextButtonVisible(userId, state)) {
                if (state.recorderStatus == RecorderState.isStopped &&
                    state.currentPass?.comparison?.total == null) {
                  if (isPlayerTurn) {
                    if (state.currentPass!.isAudioComparisonOrEmotionAnalysis &&
                        !state.isInteractiveVideo) {
                      name = hasNext;
                    } else {
                      if (state.currentPass!.type ==
                              ItemType.singleChoiceVariants ||
                          state.currentPass!.type ==
                              ItemType.multipleChoiceVariants ||
                          state.currentPass!.type ==
                              ItemType.multipleTextInputs) {
                        name = hasNext;
                      } else {
                        name = S.current.wait;
                      }
                    }
                  } else {
                    name = hasNext;
                  }
                } else if (state.recorderStatus == RecorderState.isRecording) {
                  name = S.current.speak;
                } else {
                  name = S.current.genericNext;
                }
              }
            }
          } else {
            name = hasNext;
          }

          return SafeArea(
            bottom: planPassElementId == null,
            child: Column(
              children: [
                if (_isVoteNumberVisible(state))
                  FxText.bodyLarge(
                    'Voted ${state.skipPauseVote?.vote}/${state.skipPauseVote?.voteAll}',
                    style: TextStyle(
                      fontSize: 21,
                      letterSpacing: 0.2,
                      wordSpacing: 0.5,
                      color: mTheme.onPrimary,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 5,
                          color: mTheme.primaryContainer,
                        ),
                      ],
                    ),
                  ),
                if (_isNextButtonVisible(userId, state))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        VibrationController.onPressedVibration();
                        context.read<StoryCubit>().next();
                      },
                      child: FxContainer(
                        bordered: true,
                        borderRadiusAll: 10,
                        marginAll: 10,
                        borderColor: mTheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        border: Border.all(
                          color: mTheme.onPrimary.withOpacity(0.7),
                        ),
                        color: mTheme.onSecondary.withOpacity(0.7),
                        child: FxText.bodyLarge(
                          name ?? '',
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 0.2,
                            wordSpacing: 0.5,
                            color: mTheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 3,
                                color: mTheme.onSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else if (state.currentPass?.itemCharacterName != null &&
                    userId != null &&
                    !state.loading &&
                    state.status != VideoLoadingStatus.loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FxContainer(
                      color: mTheme.onSecondary.withOpacity(0.7),
                      child: FxText(
                        S.current.waitPlayerTurn(characterName),
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 0.2,
                          wordSpacing: 0.5,
                          color: mTheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 3,
                              color: mTheme.onSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 54),
                if (state.currentPass?.type == ItemType.foreignLink)
                  const SizedBox(height: 16)
                else
                  const SizedBox(height: 4),
              ],
            ),
          );
        },
      );

  bool _isNextButtonVisible(String? userId, StoryState state) =>
      !state.loading &&
      state.status != VideoLoadingStatus.loading &&
      (userId == state.currentPass!.userId &&
              state.storyPass.condition == false ||
          (state.storyPass.pause ?? false));

  bool _isPauseTimerVisible(StoryState state) =>
      state.currentPass!.itemPassPause != null;

  bool _isVoteNumberVisible(StoryState state) =>
      state.currentPass!.itemId == state.skipPauseVote?.itemId &&
      (state.skipPauseVote?.voteAll ?? 1) > 1;
}
