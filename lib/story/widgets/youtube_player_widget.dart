import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  YoutubePlayerWidget({
    required this.youtubeVideoId,
    required this.itemVideoStart,
    required this.itemVideoEnd,
    required this.itemVideoLoop,
    required this.itemVideoControls,
  }) : super(key: ValueKey(youtubeVideoId));

  final String youtubeVideoId;
  final int itemVideoStart;
  final int itemVideoEnd;
  final bool itemVideoLoop;
  final bool itemVideoControls;

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeVideoId,
      flags: YoutubePlayerFlags(
        hideControls: !widget.itemVideoControls,
        startAt: widget.itemVideoStart,
        endAt: widget.itemVideoEnd,
        loop: widget.itemVideoLoop,
      ),
    )..addListener(() {
        if (widget.itemVideoLoop) {
          final position = _controller.value.position.inSeconds;

          if (position >= widget.itemVideoEnd) {
            _controller.seekTo(Duration(seconds: widget.itemVideoStart));
          }
        } else if (_controller.value.playerState == PlayerState.ended) {
          _controller.pause();
          context.read<StoryCubit>().next();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: YoutubePlayer(
                controller: _controller,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  RemainingDuration(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if ((state.currentPass!.autoShow ?? false) ||
                    !state.isVideoOnBackground)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.currentPass!.translatedPhrase != null &&
                            state.currentPass!.originalPhrase != null)
                          AnimatedOpacity(
                            opacity: state.isNextScreen ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: TypewriterText(
                              text: state.currentPass!.originalPhrase ?? '',
                              duration: state.audiosampleRefDuration >
                                      const Duration(seconds: 1)
                                  ? state.audiosampleRefDuration * 0.06
                                  : const Duration(seconds: 4),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 28,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
