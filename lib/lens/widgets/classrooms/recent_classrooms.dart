part of 'package:voccent/lens/lens_library.dart';

class RecentClassrooms extends StatelessWidget {
  const RecentClassrooms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        return const RecentClassroomCard();
      },
    );
  }
}

class RecentClassroomCard extends StatelessWidget {
  const RecentClassroomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final cache = context.read<ServerAddress>().cacheImgHash();
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        return (state.recentClassrooms.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FxText.labelSmall(
                        S.current.genericRecentlyViewed.toUpperCase(),
                        fontWeight: 600,
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recentClassrooms.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final itemId = state.recentClassrooms[index];

                          return SizedBox(
                            width: 50,
                            child: Stack(
                              children: [
                                FxContainer(
                                  height: 50,
                                  color: mTheme.onBackground,
                                  onTap: () {
                                    VibrationController.onPressedVibration();
                                    GoRouter.of(context).push(
                                      '/classroom_card/$itemId',
                                    );
                                  },
                                  paddingAll: 0,
                                  marginAll: 0,
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    '${context.read<ServerAddress>().httpUri}'
                                    '/api/v1/asset/object/classroom_picture/$itemId?time=$cache',
                                    height: 60,
                                    width: 60,
                                    opacity: const AlwaysStoppedAnimation(.7),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/Ccwhitebg.png',
                                      fit: BoxFit.cover,
                                      opacity: const AlwaysStoppedAnimation(.7),
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
