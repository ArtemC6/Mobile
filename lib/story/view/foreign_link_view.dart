import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/view/lean_url_view.dart';
import 'package:voccent/story/widgets/passing_story_widget.dart';
import 'package:voccent/story/widgets/youtube_player_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ForeignLinkView extends StatefulWidget
    implements PassingStoryOptionsProvider {
  const ForeignLinkView({super.key});

  @override
  State<ForeignLinkView> createState() => _ForeignLinkViewState();

  @override
  bool get requiresOverlayPassButton => true;

  @override
  bool get requiresFullScreenMode => true;
}

class _ForeignLinkViewState extends State<ForeignLinkView> {
  @override
  Widget build(BuildContext context) => BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) {
          if (state.currentPass!.itemMessage == null) {
            return Center(
              child: FxText.bodyMedium('Link is empty'),
            );
          }

          final yt = YoutubePlayer.convertUrlToId(
            state.currentPass!.itemMessage ?? '',
          );

          final itemVideoStart = state.currentPass!.itemVideoStart ?? 0;
          final itemVideoEnd = state.currentPass!.itemVideoEnd ?? 0;
          final itemVideoLoop = state.currentPass!.itemVideoLoop ?? false;
          final itemVideoControls =
              state.currentPass!.itemVideoControls ?? false;

          return SafeArea(
            top: false,
            bottom: false,
            child: yt != null
                ? YoutubePlayerWidget(
                    youtubeVideoId: yt,
                    itemVideoStart: itemVideoStart,
                    itemVideoEnd: itemVideoEnd,
                    itemVideoLoop: itemVideoLoop,
                    itemVideoControls: itemVideoControls,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: LeanUrlView(
                      state.currentPass!.itemMessage!,
                    ),
                  ),
          );
        },
      );
}
