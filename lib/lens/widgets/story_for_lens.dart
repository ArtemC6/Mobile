part of '../lens_library.dart';

class StoryForLens extends StatefulWidget {
  const StoryForLens({super.key});

  @override
  State<StoryForLens> createState() => _StoryForLensState();
}

class _StoryForLensState extends PaginationListenerState<StoryForLens> {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
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
                      duration: const Duration(milliseconds: 200),
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

    return BlocBuilder<StoryForLensCubit, StoryForLensState>(
      builder: (context, state) {
        return state.list.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: HighlightWords().formatSpecialWord(
                        S.current.playStories,
                        mTheme,
                      ),
                    ),
                    SizedBox(
                      height: 250,
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

                              return StoryItemCard(
                                index: index,
                                item: item,
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
                    ),
                  ],
                ),
              );
      },
    );
  }

  @override
  Future<void> onFetched() async {
    if (mounted) {
      await context.read<StoryForLensCubit>().fetch();
    }
  }
}

class StoryItemCard extends StatelessWidget {
  const StoryItemCard({
    required this.index,
    required this.item,
    super.key,
  });

  final FeedModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final firstElement = index == 0;
    final image = ImageWidget(
      serverUri: '${context.read<ServerAddress>().httpUri}',
      height: 250,
      width: 141,
    ).getImageForType(item.type ?? '', item.id ?? '');

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          if (firstElement)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SearchButton(
                onPressed: () {
                  VibrationController.onPressedVibration();
                  GoRouter.of(context).push(
                    '/feed',
                    extra: Parameters(
                      tab: FeedTab.story,
                    ),
                  );
                },
              ),
            ),
          SizedBox(
            width: 141,
            child: Stack(
              children: [
                FxContainer(
                  color: mTheme.onBackground.withOpacity(0.5),
                  height: 250,
                  onTap: () {
                    VibrationController.onPressedVibration();
                    GoRouter.of(context).push(
                      '/${item.type}/${item.id}',
                    );
                  },
                  paddingAll: 0,
                  marginAll: 0,
                  clipBehavior: Clip.hardEdge,
                  child: image,
                ),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          color: mTheme.secondary.withOpacity(0.5),
                          spreadRadius: 0.7,
                          blurRadius: 7,
                        ),
                      ],
                      border: Border.all(
                        color: mTheme.secondary,
                        width: 0.5,
                      ),
                      color: FxAppTheme.theme.cardTheme.color,
                    ),
                    child: FxContainer.rounded(
                      onTap: () {
                        VibrationController.onPressedVibration();
                        GoRouter.of(context).push(
                          '/${item.type}/${item.id}',
                        );
                      },
                      color: Colors.transparent,
                      child: const Icon(Icons.play_arrow),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FxContainer(
                    borderRadius: BorderRadius.zero,
                    color: mTheme.background.withOpacity(0.7),
                    child: FxText.bodyMedium(
                      '${item.object?.name}'.toUpperCase(),
                      fontWeight: 700,
                      overflow: TextOverflow.ellipsis,
                      color: mTheme.onSurface.withOpacity(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
