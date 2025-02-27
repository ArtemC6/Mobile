part of '../lens_library.dart';

class ChallengeForLens extends StatefulWidget {
  const ChallengeForLens({super.key});

  @override
  State<ChallengeForLens> createState() => _ChallengeForLensState();
}

class _ChallengeForLensState extends PaginationListenerState<ChallengeForLens> {
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

    return BlocBuilder<ChallengeForLensCubit, ChallengeForLensState>(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 2,
                            ),
                            child: HighlightWords().formatSpecialWord(
                              S.current.practicePhrases,
                              mTheme,
                            ),
                          ),
                          FxSpacing.width(8),
                          TitleButton(
                            text: S.current.genericRecents,
                            onPressed: () {
                              VibrationController.onPressedVibration();
                              GoRouter.of(context).push(
                                '/recent',
                                extra: ItemType.challenge,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
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

                              return ChallengeCard(
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
      await context.read<ChallengeForLensCubit>().fetch();
    }
  }
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    required this.item,
    required this.index,
    super.key,
  });

  final FeedModel item;
  final int index;
  static const opacity = .7;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final firstElement = index == 0;

    final image = ImageWidget(
      serverUri: '${context.read<ServerAddress>().httpUri}',
      height: 120,
      width: 120,
    ).getImageForType(
      item.type ?? '',
      item.id ?? '',
    );

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
                      tab: FeedTab.challenge,
                    ),
                  );
                },
              ),
            ),
          SizedBox(
            width: 120,
            child: Stack(
              children: [
                FxContainer(
                  color: mTheme.onBackground.withOpacity(0.5),
                  height: 120,
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
