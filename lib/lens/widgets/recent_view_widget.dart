part of '../lens_library.dart';

class RecentViewWidget extends StatelessWidget {
  const RecentViewWidget({required this.type, super.key});
  final ItemType type;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => LensCubit(
        context.read<UserScopeClient>(),
        Dictionary.platformLanguageId(),
        context.read<HomeCubit>().state.user.currentlang ?? [],
        context.read<SharedPreferences>(),
        context.read<UpdaterService>(),
      )..getRecentItems(),
      child: Scaffold(
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
          title: () {
            switch (type) {
              case ItemType.challenge:
                return FxText.titleMedium(
                  S.current.discoveryChallenges.toUpperCase(),
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                );
              case ItemType.playlist:
                return FxText.titleMedium(
                  S.current.discoveryPlaylists.toUpperCase(),
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                );
              case ItemType.channel:
                return FxText.titleMedium(
                  S.current.discoveryChannels.toUpperCase(),
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                );
              case ItemType.story:
                return FxText.titleMedium(
                  S.current.discoveryStories.toUpperCase(),
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                );
              case ItemType.classroom:
                return FxText.titleMedium(
                  S.current.classroomCampuses.toUpperCase(),
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                );
            }
          }(),
        ),
        body: () {
          switch (type) {
            case ItemType.challenge:
              return const RecentChellenge();
            case ItemType.playlist:
              return const RecentPlaylist();
            case ItemType.channel:
              return const RecentChannel();
            case ItemType.story:
              return const RecentStory();
            case ItemType.classroom:
          }
        }(),
      ),
    );
  }
}

class RecentChellenge extends StatelessWidget {
  const RecentChellenge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serverUri = '${context.read<ServerAddress>().httpUri}';
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        if (state.recentChallenges.isEmpty) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/search.json',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.recentChallenges.length,
            itemBuilder: (context, index) {
              final challenge = state.recentChallenges[index];
              final challengeId = challenge.id;
              final challengeName = challenge.name;
              return SizedBox(
                width: 400,
                child: Stack(
                  children: [
                    FxContainer(
                      height: 400,
                      onTap: () {
                        VibrationController.onPressedVibration();
                        GoRouter.of(context).push(
                          '/challenge/$challengeId',
                        );
                      },
                      paddingAll: 0,
                      marginAll: 0,
                      clipBehavior: Clip.hardEdge,
                      child: ImageWidget(
                        serverUri: serverUri,
                        height: 400,
                        width: 400,
                      ).getImageForType(
                        'challenge',
                        challengeId,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FxContainer(
                        color: mTheme.background.withOpacity(0.7),
                        child: FxText.bodyMedium(
                          challengeName.toUpperCase(),
                          fontWeight: 700,
                          overflow: TextOverflow.ellipsis,
                          color: mTheme.onSurface.withOpacity(1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RecentStory extends StatelessWidget {
  const RecentStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serverUri = '${context.read<ServerAddress>().httpUri}';
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        if (state.recentStories.isEmpty) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/search.json',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.recentStories.length,
            itemBuilder: (context, index) {
              final story = state.recentStories[index];
              final storyId = story.id;
              final storyName = story.name;
              return SizedBox(
                width: 400,
                child: Stack(
                  children: [
                    FxContainer(
                      height: 400,
                      onTap: () {
                        VibrationController.onPressedVibration();
                        GoRouter.of(context).push(
                          '/story/$storyId',
                        );
                      },
                      paddingAll: 0,
                      marginAll: 0,
                      clipBehavior: Clip.hardEdge,
                      child: ImageWidget(
                        serverUri: serverUri,
                        height: 400,
                        width: 400,
                      ).getImageForType(
                        'story',
                        storyId,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FxContainer(
                        color: mTheme.background.withOpacity(0.7),
                        child: FxText.bodyMedium(
                          storyName.toUpperCase(),
                          fontWeight: 700,
                          overflow: TextOverflow.ellipsis,
                          color: mTheme.onSurface.withOpacity(1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RecentPlaylist extends StatelessWidget {
  const RecentPlaylist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serverUri = '${context.read<ServerAddress>().httpUri}';
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        if (state.recentPlaylists.isEmpty) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/search.json',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.recentPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = state.recentPlaylists[index];
              final itemId = playlist.id;

              final pictureId = (playlist.items?.first.challenge
                          ?.asset?['challenge_picture'] as List<dynamic>?)
                      ?.first
                      .toString() ??
                  '';
              final name = playlist.name ?? '';

              return SizedBox(
                width: 400,
                child: Stack(
                  children: [
                    FxContainer(
                      height: 400,
                      onTap: () {
                        VibrationController.onPressedVibration();
                        GoRouter.of(context).push(
                          '/playlist/$itemId',
                        );
                      },
                      paddingAll: 0,
                      marginAll: 0,
                      clipBehavior: Clip.hardEdge,
                      child: ImageWidget(
                        serverUri: serverUri,
                        height: 400,
                        width: 400,
                      ).getImageForType(
                        'playlist',
                        pictureId,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FxContainer(
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RecentChannel extends StatelessWidget {
  const RecentChannel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serverUri = '${context.read<ServerAddress>().httpUri}';
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        if (state.recentChannels.isEmpty) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/search.json',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.recentChannels.length,
            itemBuilder: (context, index) {
              final channel = state.recentChannels[index];
              final channelId = channel.id ?? '';
              final channelName = channel.name ?? '';

              return SizedBox(
                width: 400,
                child: Stack(
                  children: [
                    FxContainer(
                      height: 400,
                      onTap: () {
                        VibrationController.onPressedVibration();
                        GoRouter.of(context).push(
                          '/channel/$channelId',
                        );
                      },
                      paddingAll: 0,
                      marginAll: 0,
                      clipBehavior: Clip.hardEdge,
                      child: ImageWidget(
                        serverUri: serverUri,
                        height: 400,
                        width: 400,
                      ).getImageForType(
                        'channel',
                        '${channel.asset?.channelAvatar?[0]}',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FxContainer(
                        color: mTheme.background.withOpacity(0.7),
                        child: FxText.bodyMedium(
                          channelName.toUpperCase(),
                          fontWeight: 700,
                          overflow: TextOverflow.ellipsis,
                          color: mTheme.onSurface.withOpacity(1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
