import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/story/cubit/story_cubit.dart';

class EmotionSpectatorView extends StatelessWidget {
  const EmotionSpectatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
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
                child: FxText.displayMedium(
                  'Waiting',
                  textAlign: TextAlign.center,
                  color: mTheme.onSurface.withOpacity(1),
                  fontWeight: 700,
                  fontSize: 46,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
