import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/playlist/cubit/playlist_cubit.dart';
import 'package:voccent/playlist/cubit/playlist_translation_cubit.dart';
import 'package:voccent/playlist/widgets/playlist_manual_card.dart';
import 'package:voccent/playlist/widgets/playlist_result_bottom_bar.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final mTheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final cubit = context.read<PlaylistCubit>();
    final size = MediaQuery.of(context).size;

    return BlocSelector<PlaylistCubit, PlaylistState, PlaylistStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    size: 25,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            title: FxText.titleMedium(
              S.current.contentPlaylist.toUpperCase(),
              fontWeight: 700,
              textScaleFactor: 1.2257,
              color: mTheme.primary,
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    Share.share(
                      '$apiBaseUrl/try/playlist/${cubit.state.playlist!.id}',
                      sharePositionOrigin:
                          Rect.fromLTWH(0, 0, size.width, size.height / 2),
                    );
                  },
                  icon: const Icon(FeatherIcons.share2),
                  color: mTheme.onBackground,
                ),
              ),
            ],
          ),
          body: BlocBuilder<PlaylistCubit, PlaylistState>(
            builder: (context, state) {
              if (state.status == PlaylistStatus.initial ||
                  state.status == PlaylistStatus.loadingPlaylist) {
                return LoadingEffect.getPlaylistLoadingScreen(
                  context,
                  theme,
                );
              }

              if (state.playlist?.items?.isNotEmpty != true) {
                return Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxText.bodyMedium(
                        S.current.playlistIsEmpty,
                        fontWeight: 600,
                        color: mTheme.onBackground,
                      ),
                      FxText.bodyMedium(
                        state.errorMessage ?? '',
                      ),
                    ],
                  ),
                );
              }

              if (state.status == PlaylistStatus.loadingChallenge) {
                context.read<PlaylistTranslationCubit>().getTranslations(
                      state.playlist!.items![state.selectedChallengeIndex]
                          .challenge!,
                    );
              }

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: _Promts(playlistState: state),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: BlocConsumer<PlaylistCubit, PlaylistState>(
                          listenWhen: (previous, current) =>
                              current.errorAt != null &&
                              current.errorAt != previous.errorAt,
                          listener: (context, state) {
                            if (!context
                                .read<PlaylistCubit>()
                                .state
                                .recordingAllowed) {
                              showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    S.current.genericMicPermission,
                                  ),
                                  content: Text(
                                    S.current.genericAppNeedsMicAccess,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(S.current.genericDeny),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      onPressed: openAppSettings,
                                      child: Text(
                                        S.current.genericSettings,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return const PlaylistManualCard();
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 54,
                    left: 0,
                    right: 0,
                    child: _PlaybackButtons(
                      playlistState: state,
                    ),
                  ),
                  const PlaylistResultBottomBar(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _Promts extends StatelessWidget {
  const _Promts({
    required this.playlistState,
  });
  final PlaylistState playlistState;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlaylistCubit, PlaylistState, PlaylistStatus>(
      key: UniqueKey(),
      selector: (state) => state.status,
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;
        final playlistState = context.read<PlaylistCubit>().state;
        final totalPercent =
            playlistState.myLastAttempt?.totalPercent.toStringAsFixed(0);
        final String text;
        final IconData? iconData;

        switch (state) {
          case PlaylistStatus.analyzing:
            iconData = FeatherIcons.clock;
            text = S.current.genericAnalyzing;
          case PlaylistStatus.initial:
          case PlaylistStatus.loadingPlaylist:
          case PlaylistStatus.loadingChallenge:
            iconData = null;
            text = '';
          case PlaylistStatus.readyChallenge:
            iconData = null;
            text = '';
          case PlaylistStatus.failed:
            iconData = null;
            text = '';
          case PlaylistStatus.analyzationFailed:
            iconData = null;
            text = '';
          case PlaylistStatus.startingRecord:
            iconData = FeatherIcons.mic;
            text = S.current.genericRecording;
          case PlaylistStatus.recording:
            iconData = FeatherIcons.mic;
            text = S.current.genericRecording;
          case PlaylistStatus.playingRef:
            iconData = null;
            text = '';
          case PlaylistStatus.readyPlaylist:
            iconData = null;
            text = '';
          case PlaylistStatus.finished:
            iconData = null;
            text = '$totalPercent%';
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null)
              Icon(
                iconData,
                color: mTheme.secondary,
              ),
            if (iconData != null) FxSpacing.width(8),
            FxText.titleMedium(
              text,
              fontWeight: 700,
              textScaleFactor: 1.2257,
              color: mTheme.onSurface,
            ),
          ],
        );
      },
    );
  }
}

class _PlaybackButtons extends StatelessWidget {
  const _PlaybackButtons({
    required this.playlistState,
  });

  final PlaylistState playlistState;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isEnable = playlistState.status == PlaylistStatus.readyChallenge ||
        playlistState.status == PlaylistStatus.playingRef ||
        playlistState.status == PlaylistStatus.startingRecord ||
        playlistState.status == PlaylistStatus.recording;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isEnable
              ? () async {
                  await context.read<PlaylistCubit>().playPrev();
                }
              : null,
          child: Icon(
            FeatherIcons.skipBack,
            color: isEnable ? mTheme.secondary : mTheme.surface,
            size: 40,
          ),
        ),
        FxSpacing.width(64),
        GestureDetector(
          onTap: isEnable
              ? () async {
                  VibrationController.onPressedVibration();
                  await context.read<PlaylistCubit>().playAndPauseButton();
                }
              : null,
          child: Icon(
            playlistState.isPlaying ? FeatherIcons.pause : FeatherIcons.play,
            color: isEnable ? mTheme.secondary : mTheme.surface,
            size: 40,
          ),
        ),
        FxSpacing.width(64),
        GestureDetector(
          onTap: isEnable
              ? () async {
                  await context.read<PlaylistCubit>().playNext();
                }
              : null,
          child: Icon(
            FeatherIcons.skipForward,
            color: isEnable ? mTheme.secondary : mTheme.surface,
            size: 40,
          ),
        ),
      ],
    );
  }
}
