part of 'package:voccent/lens/lens_library.dart';

class ClassroomsForLens extends StatefulWidget {
  const ClassroomsForLens({
    super.key,
  });

  @override
  State<ClassroomsForLens> createState() => _ClassroomsForLensState();
}

class _ClassroomsForLensState extends State<ClassroomsForLens> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToStartButton =
      ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.width * 0.1;

    if (currentScroll <= delta) {
      if (_showScrollToStartButton.value) {
        _showScrollToStartButton.value = false;
      }
    } else {
      if (!_showScrollToStartButton.value) {
        _showScrollToStartButton.value = true;
      }
    }
  }

  void _scrollToStart() {
    VibrationController.onPressedVibration();
    _scrollController
        .animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    )
        .then((_) {
      if (_showScrollToStartButton.value) {
        _showScrollToStartButton.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

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
          valueListenable: _showScrollToStartButton,
          builder: (context, value, _) => value
              ? FxContainer.rounded(
                  onTap: _scrollToStart,
                  child: Icon(
                    Icons.chevron_left,
                    color: mTheme.onSurface.withOpacity(1),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );

    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        return state.classroom.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightWords().formatSpecialWord(
                      S.current.practiceInClassrooms,
                      mTheme,
                    ),
                    FxSpacing.height(16),
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.classroom.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = state.classroom[index];

                              return ClassroomItemCard(
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
}

class ClassroomItemCard extends StatelessWidget {
  const ClassroomItemCard({
    required this.item,
    required this.index,
    super.key,
  });

  final ClassroomSearchModel item;
  final int index;

  static const opacity = .7;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final firstElement = index == 0;
    final cache = context.read<ServerAddress>().cacheImgHash();
    final image = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/object/classroom_picture/${item.id}?time=$cache',
      height: 120,
      width: 120,
      opacity: const AlwaysStoppedAnimation(opacity),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/Ccwhitebg.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(opacity),
        height: 120,
        width: 120,
      ),
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
                  GoRouter.of(context).push('/classroom_search');
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
                    context
                        .read<ClassroomSearchCubit>()
                        .setRecentClassroom(item.id ?? '');
                    GoRouter.of(context).push(
                      '/classroom_card/${item.id}',
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
                      '${item.name}'.toUpperCase(),
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
