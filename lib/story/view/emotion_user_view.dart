import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/widgets/recordihg_animation_wrapper.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/dialog.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class EmotionUserView extends StatefulWidget {
  const EmotionUserView({super.key});

  @override
  State<EmotionUserView> createState() => _EmotionUserViewState();
}

class _EmotionUserViewState extends State<EmotionUserView>
    with SingleTickerProviderStateMixin {
  bool translationVisible = false;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final text = (translationVisible
                ? state.currentPass!.translatedPhrase
                : state.currentPass!.originalPhrase) ??
            '...';

        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: state.currentPass!.comparison?.total != null ? 134 : 82,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.currentPass!.translatedPhrase != null &&
                            state.currentPass!.originalPhrase != null ||
                        text != '...')
                      AnimatedOpacity(
                        opacity: !state.isNextScreen ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: TypewriterText(
                          text: text,
                          duration: state.audiosampleRefDuration * 0.06,
                        ),
                      )
                    else
                      FxText.displayMedium(
                        text,
                        textAlign: TextAlign.center,
                        color: mTheme.onSurface.withOpacity(1),
                        fontWeight: 700,
                        fontSize: 38,
                      ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (state.isTestAudiosampleLinkedToItemPass)
                  FxContainer(
                    color: mTheme.surface,
                    onTap: () => context.read<StoryCubit>().playStopTest(),
                    bordered: true,
                    border: Border.all(
                      width: 0.5,
                      color: mTheme.onSurface.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: FxText.bodyLarge(
                            'Play',
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                        ),
                        Icon(
                          Icons.play_arrow_rounded,
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FxContainer(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      padding: const EdgeInsets.all(14),
                      color: Colors.black,
                      borderColor: Colors.white,
                      border: Border.all(
                        color: translationVisible
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      bordered: true,
                      onTap: () => setState(
                        () => translationVisible = !translationVisible,
                      ),
                      child: const Icon(
                        Icons.translate,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (state.recorderStatus != RecorderState.isRecording) {
                          showInfoWaitDialog(context);
                          VibrationController.onPressedVibration();
                          context.read<StoryCubit>().record();
                        } else {
                          context.read<StoryCubit>().stopRecorder();
                          VibrationController.onPressedVibration();
                        }
                      },
                      onLongPress: () {
                        if (state.refPlayerStatus == PlayerState.isPlaying) {
                          showInfoWaitDialog(context);
                        } else {
                          VibrationController.onPressedVibration();
                          context.read<StoryCubit>().record();
                        }
                      },
                      onLongPressUp: () {
                        if (state.refPlayerStatus != PlayerState.isPlaying) {
                          context.read<StoryCubit>().stopRecorder();
                          VibrationController.onPressedVibration();
                        }
                      },
                      child: RecordingAnimationWrapper(
                        isRecording:
                            state.recorderStatus == RecorderState.isRecording,
                        isLoading: state.loading,
                        child: FxContainer(
                          color: mTheme.secondary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            state.recorderStatus == RecorderState.isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_none,
                            color: mTheme.onSecondary,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(110),
              ],
            ),
          ],
        );
      },
    );
  }
}
