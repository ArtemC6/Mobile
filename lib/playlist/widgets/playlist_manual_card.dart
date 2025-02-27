// ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/playlist/cubit/playlist_cubit.dart';
import 'package:voccent/playlist/cubit/playlist_translation_cubit.dart';
import 'package:voccent/playlist/widgets/challenge_info.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/auto_text_control.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class PlaylistManualCard extends StatefulWidget {
  const PlaylistManualCard({super.key});

  @override
  State<PlaylistManualCard> createState() => _PlaylistManualCardState();
}

class _PlaylistManualCardState extends State<PlaylistManualCard> {
  late final SwiperController swipeController;

  @override
  void initState() {
    super.initState();
    swipeController = SwiperController();
  }

  @override
  void dispose() {
    swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = context.read<PlaylistCubit>().state;
    final playlist = context.read<PlaylistCubit>().state.playlist;
    final mTheme = Theme.of(context).colorScheme;
    var isSwiping = false;
    return BlocSelector<PlaylistCubit, PlaylistState, PlaylistStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, state) {
        return BlocConsumer<PlaylistCubit, PlaylistState>(
          listenWhen: (previous, current) =>
              previous.selectedChallengeIndex != current.selectedChallengeIndex,
          listener: (context, state) {
            final isAnimationDisable = (swipeController.index == 0 &&
                    state.selectedChallengeIndex ==
                        playlist!.items!.length - 1) ||
                (swipeController.index == playlist!.items!.length - 1 &&
                    state.selectedChallengeIndex == 0);
            if (swipeController.index != state.selectedChallengeIndex) {
              swipeController.move(
                state.selectedChallengeIndex,
                animation: !isAnimationDisable,
              );
            }
          },
          builder: (context, state) {
            final apiBaseUrl = context.read<ServerAddress>().httpUri;
            final blurValue = state.blur(15);
            final annotations = state.audiosample?.annotations ?? [];

            return Swiper(
              containerWidth: double.infinity,
              itemCount: playlist!.items!.length,
              onIndexChanged: (index) async {
                if (isSwiping) return;
                isSwiping = true;
                VibrationController.onPressedVibration();
                await context.read<PlaylistCubit>().swipeChallenge(index);
                isSwiping = false;
              },
              viewportFraction: 0.75,
              scale: 0.85,
              controller: swipeController,
              itemBuilder: (BuildContext context, int index) {
                final ch = playlist.items![index].challenge!;
                final img =
                    ch.asset != null && ch.asset!['challenge_picture'] != null
                        ? Image.network(
                            // NOTE: ref-2f5f6821 here if the ch.asset is empty, it means in backend we have Plyalist/items fetch value set to false.
                            '$apiBaseUrl/api/v1/asset/file/challenge_picture/'
                            // ignore: avoid_dynamic_calls
                            '${ch.asset!['challenge_picture'][0]}',
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(.4),
                            errorBuilder: (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) {
                              return Image.asset(
                                'assets/images/Ccwhitebg.png',
                                fit: BoxFit.cover,
                                opacity: const AlwaysStoppedAnimation(.4),
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(.4),
                          );
                return Padding(
                  padding: const EdgeInsets.only(top: 75, bottom: 150),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child:
                                  SizedBox(width: double.infinity, child: img),
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: blurValue,
                                sigmaY: blurValue,
                              ),
                              child: Container(color: Colors.transparent),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              _Counter(
                                index: index,
                                itemCount:
                                    playlistState.playlist!.items!.length,
                              ),
                              ChallengeInfoWidget(challenge: ch),
                              Divider(
                                color: mTheme.onSurface.withOpacity(0.5),
                              ),
                              FxSpacing.height(8),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (state.selectedChallengeIndex == index)
                                      Expanded(
                                        child: BlocBuilder<
                                            PlaylistTranslationCubit,
                                            PlaylistSpellingState>(
                                          builder: (context, state) {
                                            return Column(
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    state.translation,
                                                    style: TextStyle(
                                                      color: mTheme.onSurface
                                                          .withOpacity(1),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 24,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    minFontSize: 10,
                                                    wrapWords: AutoTextControl
                                                        .shouldWrapWords(
                                                      state.translation,
                                                    ),
                                                  ),
                                                ),
                                                FxSpacing.height(8),
                                                Expanded(
                                                  flex: 2,
                                                  child: AutoSizeText(
                                                    state.originalPhrase,
                                                    style: TextStyle(
                                                      color: mTheme.onSurface
                                                          .withOpacity(1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 64,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    minFontSize: 10,
                                                    wrapWords: AutoTextControl
                                                        .shouldWrapWords(
                                                      state.originalPhrase,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    if (state.selectedChallengeIndex == index)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: annotations.map(
                                                  (e) {
                                                    return state.status ==
                                                            PlaylistStatus
                                                                .loadingChallenge
                                                        ? FxText.titleMedium(
                                                            '',
                                                          )
                                                        : FxContainer(
                                                            paddingAll: 4,
                                                            marginAll: 0,
                                                            bordered:
                                                                e.transcription !=
                                                                    '',
                                                            color: Colors
                                                                .transparent,
                                                            borderColor: mTheme
                                                                .secondary,
                                                            child: FxText
                                                                .bodyLarge(
                                                              e.transcription ??
                                                                  '',
                                                              color: mTheme
                                                                  .secondary,
                                                              fontWeight: 600,
                                                              maxLines: 1,
                                                            ),
                                                          );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.index,
    required this.itemCount,
  });

  final int index;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          '${index + 1} / $itemCount',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: mTheme.onSurface,
          ),
        ),
      ),
    );
  }
}
