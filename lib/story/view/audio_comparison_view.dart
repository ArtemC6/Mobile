import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/view/audio_comparison_spectator_view.dart';
import 'package:voccent/story/view/audio_comparison_user_view.dart';
import 'package:voccent/story/view/interactive_video_view.dart';

class AudioComparisonView extends StatelessWidget {
  const AudioComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return state.isInteractiveVideo
            ? const InteractiveVideoView()
            : context.read<HomeCubit>().state.user.id! ==
                    state.currentPass!.userId
                ? const AudioComparisonUserView()
                : const AudioComparisonSpectatorView();
      },
    );
  }
}
