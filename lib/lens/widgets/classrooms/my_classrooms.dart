part of 'package:voccent/lens/lens_library.dart';

class MyClassrooms extends StatefulWidget {
  const MyClassrooms({
    required this.user,
    super.key,
  });

  final User user;

  @override
  State<MyClassrooms> createState() => _MyClassroomsState();
}

class _MyClassroomsState extends State<MyClassrooms> {
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
        final isEmpty = state.myClassrooms.isEmpty ||
            state.myClassrooms.every(
              (item) => item.userStatus == 'canceled',
            );
        if (isEmpty) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.titleLarge(
                        S.current.myClassrooms.toUpperCase(),
                        fontWeight: 500,
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                      TitleButton(
                        text:
                            S.current.achievementsCompletedPlans.toLowerCase(),
                        onPressed: () {
                          VibrationController.onPressedVibration();
                          GoRouter.of(context).push('/completedplans');
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
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 8,
                        ),
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.myClassrooms.length,
                        itemBuilder: (context, index) {
                          final item = state.myClassrooms[index];

                          if (item.userStatus == 'canceled') {
                            return const SizedBox.shrink();
                          } else {
                            return MyClassroomSquareCard(
                              classroom: item,
                              user: widget.user,
                            );
                          }
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
        }
      },
    );
  }
}
