import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/view/emotion_user_view.dart';

class EmotionAnalysisView extends StatelessWidget {
  const EmotionAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        // TODO(vsemenov-voc): Check user id and show Waiting to spectators
        return const EmotionUserView();
        // return context.read<HomeCubit>().state.user.id! ==
        //         state.currentPass!.userId
        //     ? const EmotionUserView()
        //     : const EmotionSpectatorView();
      },
    );
  }
}
