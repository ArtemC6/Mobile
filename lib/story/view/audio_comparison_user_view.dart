import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';
import 'package:voccent/challenge/widgets/recordihg_animation_wrapper.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/dialog.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class AudioComparisonUserView extends StatefulWidget {
  const AudioComparisonUserView({super.key});

  @override
  State<AudioComparisonUserView> createState() =>
      _AudioComparisonUserViewState();
}

class _AudioComparisonUserViewState extends State<AudioComparisonUserView>
    with SingleTickerProviderStateMixin {
  bool translationVisible = false;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final height = MediaQuery.of(context).size.height;
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
                      Container(
                        alignment: Alignment.center,
                        height: state.currentPass!.comparison?.total != null
                            ? height * 0.56
                            : height * 0.65,
                        child: AnimatedOpacity(
                          opacity: state.isNextScreen ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: TypewriterText(
                            text: text,
                            duration: state.audiosampleRefDuration >
                                    const Duration(seconds: 1)
                                ? state.audiosampleRefDuration * 0.06
                                : const Duration(seconds: 4),
                          ),
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
                if (state.currentPass!.comparison?.total != null)
                  FxContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    // color: mTheme.surface,
                    color: state.currentPass!.comparison!.total! > 70
                        ? Colors.green
                        : Colors.red,
                    onTap: () => context.read<StoryCubit>().playStopTest(),
                    bordered: true,
                    border: Border.all(
                      width: 0.7,
                      color: mTheme.onSurface.withOpacity(0.6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FxText.bodyLarge(
                            '${NumberFormat("##'%'").format(state.currentPass!.comparison!.total)} / ${state.currentPass?.comparison?.xpAdd ?? 0} XP',
                            color: mTheme.onSurface.withOpacity(1),
                            fontWeight: 900,
                            fontSize: 22,
                          ),
                        ),
                        Icon(
                          state.testPlayerStatus == PlayerState.isPlaying
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          color: mTheme.onSurface.withOpacity(1),
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                if (state.currentPass!.comparison?.total != null)
                  FxSpacing.height(32),
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
                                ? Icons.pause
                                : Icons.mic_none,
                            color: mTheme.onSecondary,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                    FxContainer(
                      onTap: () => context.read<StoryCubit>().playStopRef(),
                      color: mTheme.primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      borderColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                      bordered: true,
                      border: Border.all(
                        color: state.refPlayerStatus == PlayerState.isPlaying
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Icon(
                        state.refPlayerStatus == PlayerState.isPlaying
                            ? Icons.stop_rounded
                            : FeatherIcons.volume2,
                        color: mTheme.onPrimary,
                        size: 36,
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
