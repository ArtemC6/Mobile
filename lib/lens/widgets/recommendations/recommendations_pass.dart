part of 'package:voccent/lens/lens_library.dart';

class RecommendationsPass extends StatelessWidget {
  const RecommendationsPass({
    required this.recommendationsData,
    super.key,
  });

  final RecommedationsData recommendationsData;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final type = recommendationsData.itemType;
    final currentIndex = recommendationsData.currentIndex;
    final itemId = recommendationsData.items[currentIndex].objectId ?? '';

    final nextItemType = currentIndex < recommendationsData.items.length - 1
        ? recommendationsData.items[currentIndex + 1].objectType
        : '';

    final Widget child;
    switch (type) {
      case RecommendationItemType.challenge:
        child = ChallengePageById(
          challengeId: itemId,
          nextBtnVisibility: false,
          key: ValueKey(itemId),
        );
      case RecommendationItemType.playlist:
        child = PlaylistPageById(
          playlistId: itemId,
          key: ValueKey(itemId),
        );
      case RecommendationItemType.story:
        child = StoryView(
          storyId: itemId,
          doneBtnVisibility: false,
          key: ValueKey(itemId),
        );
    }
    final nextRecItemType = (nextItemType == 'challenge')
        ? RecommendationItemType.challenge
        : (nextItemType == 'playlist')
            ? RecommendationItemType.playlist
            : RecommendationItemType.story;

    return Scaffold(
      backgroundColor: mTheme.background,
      body: Column(
        children: [
          Expanded(child: child),
          BlocListener<LensCubit, LensState>(
            listener: (context, state) async {
              if (state.currentIndex >= state.recommendationsItem.length - 4) {
                await context
                    .read<LensCubit>()
                    .fetchMoreRecommendationsItems(limit: 12);
              }
            },
            child: Material(
              child: SafeArea(
                top: false,
                child: FxContainer(
                  paddingAll: 0,
                  marginAll: 8,
                  color: mTheme.background,
                  child: BlocBuilder<LensCubit, LensState>(
                    builder: (context, state) {
                      final disabled = state.currentIndex + 1 >=
                          state.recommendationsItem.length - 1;
                      return FxButton.text(
                        onPressed: () {
                          VibrationController.onPressedVibration();
                          context
                              .read<LensCubit>()
                              .setIndexForRecommendationsPass(currentIndex + 1);
                          final nextItem =
                              state.recommendationsItem[currentIndex + 1];
                          GoRouter.of(context).pushReplacement(
                            '/recommedations_pass',
                            extra: RecommedationsData(
                              itemType: nextRecItemType,
                              itemId: nextItem.objectId ?? '',
                              currentIndex: currentIndex + 1,
                              items: state.recommendationsItem,
                            ),
                          );
                        },
                        disabled: disabled,
                        splashColor: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FxText.titleMedium(
                              S.current.genericNext.toUpperCase(),
                              fontWeight: 700,
                              color: disabled
                                  ? mTheme.onSurface.withOpacity(.5)
                                  : mTheme.onSurface.withOpacity(1),
                              textAlign: TextAlign.center,
                            ),
                            FxSpacing.width(16),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: disabled
                                  ? mTheme.onSurface.withOpacity(.5)
                                  : mTheme.onSurface.withOpacity(1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
