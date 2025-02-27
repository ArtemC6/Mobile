import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/story/cubit/story_cubit.dart';

class NewStoryModeSelectionView extends StatelessWidget {
  const NewStoryModeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        if (state.modes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FxText.titleLarge(
                S.current.storyModeNoAnyMode,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Center(
          child: Container(
            constraints: const BoxConstraints.expand(height: 1200, width: 400),
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                if (state.modes.any((e) => e.type == 0))
                  _cardmode(
                    context,
                    () => context.read<StoryCubit>().chooseStoryMode(0),
                    'assets/images/action-story-mode-by-role.jpeg',
                    S.current.storyModePlayByRoles,
                  ),
                if (state.modes.any((e) => e.type == 2))
                  _cardmode(
                    context,
                    () => context.read<StoryCubit>().chooseStoryMode(2),
                    'assets/images/action-story-mode-certification.jpeg',
                    S.current.storyModeCertification,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cardmode(
    BuildContext context,
    GestureTapCallback? onTap,
    String pic,
    String title,
  ) =>
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
        child: FxCard(
          margin: const EdgeInsets.all(8),
          splashColor: Theme.of(context).splashColor,
          paddingAll: 0,
          borderRadiusAll: 16,
          clipBehavior: Clip.hardEdge,
          onTap: onTap,
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.passthrough,
            children: <Widget>[
              Image.asset(
                pic,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                color: Theme.of(context).colorScheme.background.withAlpha(200),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleMedium(
                      title,
                      textAlign: TextAlign.left,
                      fontWeight: 700,
                      textScaleFactor: 1.2257,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    FxSpacing.height(4),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
