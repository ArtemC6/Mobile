import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/interactive_video_player.dart';
import 'package:voccent/story/widgets/passing_story_widget.dart';

class InteractiveVideoView extends StatefulWidget
    implements PassingStoryOptionsProvider {
  const InteractiveVideoView({super.key});

  @override
  State<InteractiveVideoView> createState() => _InteractiveVideoViewState();

  @override
  bool get requiresOverlayPassButton => true;

  @override
  bool get requiresFullScreenMode => true;
}

class _InteractiveVideoViewState extends State<InteractiveVideoView> {
  @override
  Widget build(BuildContext context) => BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) {
          final userId = context.read<HomeCubit>().state.user.id;
          final isPlayerTurn = userId == state.currentPass?.userId;
          final apiBaseUrl = context.read<ServerAddress>().httpUri;

          if (state.status == VideoLoadingStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SafeArea(
              top: false,
              bottom: false,
              child: InteractiveVideoPlayer(
                videoUrl:
                    '$apiBaseUrl/api/v1/asset/object/videosample/ref/${state.currentPass?.itemVideosamplerefid}',
                isPlayerTurn: isPlayerTurn,
                volume: (state.videosample?.volume ?? 100) / 100,
              ),
            );
          }
        },
      );
}
