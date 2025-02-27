part of '../lens_library.dart';

class LensWidget extends StatelessWidget {
  const LensWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.refresh != current.refresh,
      listener: (context, state) async {
        VibrationController.onPressedVibration();
        final lensCubit = context.read<LensCubit>();
        final favoriteChallengeCubit = context.read<FavoriteChallengeCubit>();

        await lensCubit.refresh();
        await favoriteChallengeCubit.fetch();
      },
      child: UpgradeAlert(
        onIgnore: () {
          PackageInfo.fromPlatform().then(
            (platform) => FirebaseAnalytics.instance.logEvent(
              name: 'upgrader_ignored',
              parameters: {
                'current_version': platform.version,
              },
            ).ignore(),
          );

          return true;
        },
        onLater: () {
          PackageInfo.fromPlatform().then(
            (platform) => FirebaseAnalytics.instance.logEvent(
              name: 'upgrader_later',
              parameters: {
                'current_version': platform.version,
              },
            ).ignore(),
          );

          return true;
        },
        onUpdate: () {
          PackageInfo.fromPlatform().then(
            (platform) => FirebaseAnalytics.instance.logEvent(
              name: 'upgrader_updated',
              parameters: {
                'current_version': platform.version,
              },
            ).ignore(),
          );

          return true;
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            if (homeState.classroomFocusId.isEmpty ||
                homeState.pictureId.isEmpty) {
              return BlocBuilder<LensCubit, LensState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gamification(user: homeState.user),
                        const ClassroomsForLens(),
                        const RecentClassrooms(),
                        RecommendationsForLens(user: homeState.user),
                        const StoryForLens(),
                        const ChallengeForLens(),
                        const PlaylistForLens(),
                        const ChannelForLens(),
                        const Mixer(),
                        LanguageLevelWidget(state: state),
                        const DailyProgress(),
                        MyClassrooms(user: homeState.user),
                        const FavoriteChallenges(),
                      ].toList(),
                    ),
                  );
                },
              );
            }
            return BlocBuilder<LensCubit, LensState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClassroomsCurrentLens(user: homeState.user),
                      RecommendationsForLens(user: homeState.user),
                      if (homeState.openContent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ClassroomsForLens(),
                            const RecentClassrooms(),
                            const StoryForLens(),
                            const ChallengeForLens(),
                            const PlaylistForLens(),
                            const ChannelForLens(),
                            const Mixer(),
                            LanguageLevelWidget(state: state),
                            const DailyProgress(),
                            MyClassrooms(user: homeState.user),
                            const FavoriteChallenges(),
                          ],
                        ),
                      const OpenContentWidget(),
                    ].toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class OpenContentWidget extends StatelessWidget {
  const OpenContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<HomeCubit>().openContent(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 2,
                  top: 6,
                ),
                child: Text(
                  '${S.current.otherContentVoccent} Voccent',
                  style: TextStyle(
                    color: mTheme.onSurface.withOpacity(1),
                    fontSize: 22,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              if (!state.openContent)
                Icon(
                  Icons.arrow_drop_down,
                  color: mTheme.onSurface.withOpacity(1),
                  size: 40,
                )
              else
                Icon(
                  Icons.arrow_drop_up,
                  color: mTheme.onSurface.withOpacity(1),
                  size: 40,
                ),
              FxSpacing.height(64),
            ],
          ),
        );
      },
    );
  }
}
