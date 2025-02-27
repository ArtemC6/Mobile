part of 'package:voccent/lens/lens_library.dart';

class RecommendationsForLens extends StatelessWidget {
  const RecommendationsForLens({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 1.5,
                ),
                child: HighlightWords().formatSpecialWord(
                  S.current.smartRecommendations,
                  mTheme,
                ),
              ),
              FxSpacing.width(8),
              TitleButton(
                text: S.current.genericMore,
                onPressed: () {
                  VibrationController.onPressedVibration();
                  Navigator.of(context).push(
                    PageRouteBuilder<Widget>(
                      pageBuilder: (_, animation, secondaryAnimation) =>
                          BlocProvider.value(
                        value: context.read<LensCubit>(),
                        child: const RecommendationsView(),
                      ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(0, 1);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
              ),
            ],
          ),
          FxSpacing.height(16),
          BlocBuilder<LensCubit, LensState>(
            builder: (context, state) {
              if (state.recommendationsItem.isEmpty) {
                return LoadingEffect.getRecomendationsLoading(
                  Theme.of(context),
                  context,
                );
              }
              return Wrap(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsetsDirectional.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
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
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
