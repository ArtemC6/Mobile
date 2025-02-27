part of 'package:voccent/lens/lens_library.dart';

class RecommendationsItemSquareCard extends StatelessWidget {
  const RecommendationsItemSquareCard({
    required this.item,
    required this.currentIndex,
    required this.items,
    this.user,
    super.key,
    this.playlist,
  });

  final RecommendationsItem item;
  final int currentIndex;
  final List<RecommendationsItem> items;
  final User? user;
  final PlaylistLensItem? playlist;

  @override
  Widget build(BuildContext context) {
    String getItemNameForType(String? objectType) {
      switch (objectType) {
        case 'playlist':
          return '${item.playlistLensItem?.name}';
        case 'challenge':
          return '${item.challengeLensItem?.name}';
        case 'story':
          return '${item.storyLensItem?.name}';
        default:
          return '';
      }
    }

    final mTheme = Theme.of(context).colorScheme;
    final itemId = item.objectType == 'playlist'
        ? item.playlistLensItem?.pictureIdFirst
        : item.objectId;
    final image = ImageWidget(
      serverUri: '${context.read<ServerAddress>().httpUri}',
      height: 400,
      width: 400,
    ).getImageForType(item.objectType ?? '', itemId ?? '');
    final name = getItemNameForType(item.objectType);
    final itemType = (item.objectType == 'challenge')
        ? RecommendationItemType.challenge
        : (item.objectType == 'playlist')
            ? RecommendationItemType.playlist
            : RecommendationItemType.story;

    return Stack(
      children: [
        FxContainer(
          color: mTheme.onBackground.withOpacity(0.5),
          height: 400,
          onTap: () {
            VibrationController.onPressedVibration();
            context
                .read<LensCubit>()
                .setIndexForRecommendationsPass(currentIndex);
            GoRouter.of(context).push(
              '/recommedations_pass',
              extra: RecommedationsData(
                itemType: itemType,
                itemId: item.objectId ?? '',
                currentIndex: currentIndex,
                items: items,
              ),
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
              name.toUpperCase(),
              fontWeight: 700,
              overflow: TextOverflow.ellipsis,
              color: mTheme.onSurface.withOpacity(1),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
