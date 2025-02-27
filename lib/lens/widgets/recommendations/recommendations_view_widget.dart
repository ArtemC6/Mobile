part of 'package:voccent/lens/lens_library.dart';

class RecommendationsView extends StatelessWidget {
  const RecommendationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecommendationsWidget();
  }
}

class RecommendationsWidget extends StatefulWidget {
  const RecommendationsWidget({super.key});

  @override
  State<RecommendationsWidget> createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState
    extends PaginationListenerState<RecommendationsWidget> {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final user = context.read<HomeCubit>().state.user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: mTheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          S.current.lensRecommendations.toUpperCase(),
          fontWeight: 700,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      body: BlocBuilder<LensCubit, LensState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.recommendationsItem.length,
              itemBuilder: (context, index) {
                final item = state.recommendationsItem[index];
                return Center(
                  child: RecommendationsItemSquareCard(
                    item: item,
                    currentIndex: index,
                    items: state.recommendationsItem,
                    user: user,
                    playlist: item.playlistLensItem,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> onFetched() async {
    if (mounted) {
      await context.read<LensCubit>().fetchMoreRecommendationsItems(limit: 24);
    }
  }
}
