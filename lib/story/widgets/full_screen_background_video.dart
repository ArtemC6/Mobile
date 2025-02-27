import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class FullScreenBackgroundVideo extends StatefulWidget {
  const FullScreenBackgroundVideo({
    required this.videoUrl,
    required this.looping,
    required this.volume,
    super.key,
  });

  final String videoUrl;
  final bool looping;
  final double volume;

  @override
  State<FullScreenBackgroundVideo> createState() =>
      _FullScreenBackgroundVideoState();
}

class _FullScreenBackgroundVideoState extends State<FullScreenBackgroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _controller.initialize().then((_) {
      {
        setState(() {});
      }
      _controller
        ..play()
        ..setLooping(widget.looping)
        ..setVolume(widget.volume)
        ..addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            context.read<StoryCubit>().skipVideo();
          }
        });
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
        return Center(
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
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
