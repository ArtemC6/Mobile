import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutx/flutx.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/radius_score_widget.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class InteractiveVideoPlayer extends StatefulWidget {
  const InteractiveVideoPlayer({
    required this.videoUrl,
    required this.isPlayerTurn,
    required this.volume,
    super.key,
  });

  final String videoUrl;
  final bool isPlayerTurn;
  final double volume;

  @override
  State<InteractiveVideoPlayer> createState() => _InteractiveVideoPlayerState();
}

class _InteractiveVideoPlayerState extends State<InteractiveVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  OverlayEntry? overlayEntry;
  bool isEndLoopActivated = false;
  String displayPhrase = '';

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    )..setVolume(widget.volume);

    _controller.addListener(() async {
      final storyCubit = context.read<StoryCubit>();

      final videosampleDuration = storyCubit.state.videosample?.duration != null
          ? Duration(
              milliseconds:
                  (storyCubit.state.videosample!.duration! * 1000).toInt(),
            ).inMilliseconds
          : _controller.value.duration.inMilliseconds;
      final audiosampleRefDuration =
          storyCubit.state.audiosampleRefDuration.inMilliseconds;
      final currentPosition = _controller.value.position.inMilliseconds;
      final endLoopStart = videosampleDuration - audiosampleRefDuration;
      if (mounted) {
        if (currentPosition >= videosampleDuration && !isEndLoopActivated) {
          setState(() {
            displayPhrase =
                storyCubit.state.currentPass?.originalPhrase ?? '...';
          });
          isEndLoopActivated = true;
          await _controller.setVolume(0);
          await _controller.setLooping(true);
          await _controller.seekTo(Duration(milliseconds: endLoopStart)).then(
            (value) {
              _controller
                ..setPlaybackSpeed(0.85)
                ..play();
            },
          );
          if (widget.isPlayerTurn) {
            VibrationController.onPressedVibration();
            await Future<void>.delayed(
              Duration.zero,
              () async => storyCubit.record(),
            );
          }
        } else if (isEndLoopActivated && currentPosition < endLoopStart) {
          await _controller.seekTo(Duration(milliseconds: endLoopStart)).then(
                (value) => _controller.play(),
              );
        }
      }
    });

    _controller.initialize().then((_) {
      {
        setState(() {});
      }
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final score = state.currentPass!.comparison?.total;
        return Scaffold(
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (state.recorderStatus == RecorderState.isRecording &&
                      widget.isPlayerTurn)
                    Lottie.asset(
                      'assets/lottie/recOn.json',
                      height: 70,
                      width: 70,
                    ),
                  FxSpacing.height(8),
                  if (score != null &&
                      state.recorderStatus != RecorderState.isRecording)
                    FxContainer(
                      borderRadiusAll: 50,
                      marginAll: 8,
                      paddingAll: 1,
                      color: mTheme.onSecondary.withOpacity(0.7),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: RadiusScoreWidget(
                          key: ValueKey(score),
                          percent: score / 100,
                          fillColor: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                          lineColor: mTheme.secondary,
                          freeColor: mTheme.onPrimary,
                          lineWidth: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxText.titleMedium(
                                score.toStringAsFixed(0),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (displayPhrase.isNotEmpty)
                    ColoredBox(
                      color: mTheme.onSecondary.withOpacity(0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (score != null)
                            IconButton(
                              onPressed: () {
                                VibrationController.onPressedVibration();
                                context.read<StoryCubit>().playStopTest();
                              },
                              icon: Icon(
                                Icons.play_arrow_rounded,
                                color: mTheme.onPrimary,
                                size: 35,
                              ),
                            )
                          else
                            const SizedBox(
                              width: 35,
                            ),
                          Expanded(
                            child: FxText.headlineSmall(
                              displayPhrase,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                letterSpacing: 0.2,
                                wordSpacing: 0.5,
                                color: score == null
                                    ? mTheme.onPrimary
                                    : score <= 33
                                        ? Colors.red
                                        : score <= 66
                                            ? Colors.yellow
                                            : Colors.green,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 5,
                                    color: mTheme.primaryContainer,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (score != null) FxSpacing.width(8),
                          if (score != null)
                            IconButton(
                              onPressed: () {
                                VibrationController.onPressedVibration();
                                context.read<StoryCubit>().record();
                              },
                              icon: Icon(
                                FeatherIcons.refreshCcw,
                                size: 24,
                                color: mTheme.onPrimary,
                              ),
                            )
                          else
                            const SizedBox(
                              height: 50,
                              width: 50,
                            ),
                        ],
                      ),
                    ),
                  FxSpacing.height(70),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
