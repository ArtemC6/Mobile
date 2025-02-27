part of '../lens_library.dart';

class FavoriteChallenges extends StatefulWidget {
  const FavoriteChallenges({super.key});

  @override
  State<FavoriteChallenges> createState() => _FavoriteChallengesState();
}

class _FavoriteChallengesState
    extends PaginationListenerState<FavoriteChallenges> {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final serverUri = '${context.read<ServerAddress>().httpUri}';
    final scrollToStartButton = AnimationConfiguration.staggeredList(
      position: 0,
      child: FadeInAnimation(
        duration: const Duration(
          milliseconds: 500,
        ),
        child: ValueListenableBuilder(
          valueListenable: showScrollToStartButton,
          builder: (context, value, _) => value
              ? FxContainer.rounded(
                  onTap: () {
                    VibrationController.onPressedVibration();
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Icon(
                    Icons.chevron_left,
                    color: mTheme.onSurface.withOpacity(1),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FxText.titleLarge(
              S.current.challengesYouLiked.toUpperCase(),
              fontWeight: 500,
              color: mTheme.onSurface.withOpacity(1),
            ),
          ),
          BlocBuilder<FavoriteChallengeCubit, FavoriteChallengeState>(
            builder: (context, state) {
              return state.list.isEmpty
                  ? FxText.titleMedium(
                      S.current.yourHaveNotGivenLikes,
                    )
                  : SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 8,
                            ),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.list.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = state.list[index];

                              return SizedBox(
                                width: 120,
                                child: Stack(
                                  children: [
                                    FxContainer(
                                      height: 120,
                                      onTap: () {
                                        VibrationController
                                            .onPressedVibration();
                                        GoRouter.of(context).push(
                                          '/challenge/${item.id}',
                                        );
                                      },
                                      paddingAll: 0,
                                      marginAll: 0,
                                      clipBehavior: Clip.hardEdge,
                                      child: ImageWidget(
                                        serverUri: serverUri,
                                        height: 120,
                                        width: 120,
                                      ).getImageForType(
                                        'challenge',
                                        item.id ?? '',
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: FxContainer(
                                        borderRadius: BorderRadius.zero,
                                        color:
                                            mTheme.background.withOpacity(0.7),
                                        child: FxText.bodyMedium(
                                          '${item.name}'.toUpperCase(),
                                          fontWeight: 700,
                                          overflow: TextOverflow.ellipsis,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: scrollToStartButton,
                          ),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  @override
  Future<void> onFetched() async {
    if (mounted) {
      await context.read<FavoriteChallengeCubit>().fetch();
    }
  }
}
