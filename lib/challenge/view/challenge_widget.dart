import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_favorite_cubit.dart';
import 'package:voccent/challenge/cubit/rating_cubit.dart';
import 'package:voccent/challenge/widgets/attempts/attempts_view.dart';
import 'package:voccent/challenge/widgets/bottom_butons.dart';
import 'package:voccent/challenge/widgets/challenge_favorite_button.dart';
import 'package:voccent/challenge/widgets/challenge_info.dart';
import 'package:voccent/challenge/widgets/challenge_info_drawer.dart';
import 'package:voccent/challenge/widgets/challenge_pay_wall.dart';
import 'package:voccent/challenge/widgets/challenge_phrase_widget.dart';
import 'package:voccent/challenge/widgets/challenge_result_bar.dart';
import 'package:voccent/challenge/widgets/ref_annotations.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/challenge/widgets/test_annotations.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/dialog.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class ChallengeWidget extends StatefulWidget {
  const ChallengeWidget({super.key});

  @override
  State<ChallengeWidget> createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOverlayVisible = true;
  bool _isOverlayVisibleLoading = true;
  Duration _audioSampleRefDuration = Duration.zero;

  late final _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelProgress(
        refDuration: _audioSampleRefDuration,
      ),
    ),
  );
  late final _overlayEntryLoading = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfo(
        infoText: S.current.wait,
      ),
    ),
  );

  @override
  void dispose() {
    if (!_isOverlayVisibleLoading && _overlayEntryLoading.mounted) {
      _overlayEntryLoading.remove();
    }

    if (_overlayEntry.mounted && !_isOverlayVisible) {
      _overlayEntry.remove();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    ///hide if small screen
    final shouldShowChallengeInfo = size.height > 667;

    final apiBaseUrl = context.read<ServerAddress>().httpUri;

    return BlocConsumer<ChallengeCubit, ChallengeState>(
      listenWhen: (previous, current) =>
          previous.attempt?.id != current.attempt?.id ||
          previous.attempt == null && current.attempt != null ||
          previous.recorderStatus != current.recorderStatus,
      listener: (context, state) {
        if (state.recordingAllowed == false) {
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  onPressed: openAppSettings,
                  child: Text(S.current.genericSettings),
                ),
              ],
            ),
          );
        }
        if (state.recorderStatus == RecorderStatus.recording &&
            _isOverlayVisible) {
          _audioSampleRefDuration = state.refDuration!;
          Overlay.of(context).insert(_overlayEntry);
          _isOverlayVisible = false;
        }

        if (state.recorderStatus != RecorderStatus.recording) {
          if (!_isOverlayVisible && _overlayEntry.mounted) {
            _overlayEntry.remove();
            _isOverlayVisible = true;
          }

          final result = state.attempt?.totalPercent;
          final xpAdd = state.attempt?.xpAdd ?? 0;

          if (result != null &&
              state.recorderStatus != RecorderStatus.analyzing &&
              state.recorderStatus != RecorderStatus.starting &&
              state.recorderStatus != RecorderStatus.failed) {
            showInfoDialog(
              context,
              result <= 33
                  ? S.current.genericFairResult
                  : result <= 66
                      ? S.current.genericGoodResult
                      : S.current.genericExcellentResult,
              '${result.toInt()}% / $xpAdd XP',
            );
          }
        }

        if (state.recorderStatus == RecorderStatus.failed) {
          showInfoDialog(
            context,
            S.current.cancelled,
            null,
          );
        }

        if (state.recorderStatus == RecorderStatus.starting ||
            state.recorderStatus == RecorderStatus.analyzing) {
          if (_isOverlayVisibleLoading && !_overlayEntryLoading.mounted) {
            Overlay.of(context).insert(_overlayEntryLoading);
            _isOverlayVisibleLoading = false;
          }
        } else {
          if (!_isOverlayVisibleLoading && _overlayEntryLoading.mounted) {
            _isOverlayVisibleLoading = true;
            _overlayEntryLoading.remove();
          }
        }
      },
      builder: (context, state) {
        final img = state.challenge?.asset != null &&
                state.challenge?.asset!['challenge_picture'] != null
            ? Image.network(
                // ignore: avoid_dynamic_calls
                '$apiBaseUrl/api/v1/asset/file/challenge_picture/${state.challenge!.asset!['challenge_picture'][0]}',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(.15),
              )
            : Image.asset(
                'assets/images/Ccwhitebg.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(.15),
              );

        final result = state.attempt?.totalPercent.toInt() ?? 0;
        final blurValue = state.blur(15);
        if (state.refPlayerStatus == PlayerStatus.initial ||
            state.refPlayerStatus == PlayerStatus.downloading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return PopScope(
          canPop: state.recorderStatus != RecorderStatus.recording &&
              state.recorderStatus != RecorderStatus.starting &&
              state.recorderStatus != RecorderStatus.analyzing,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  FeatherIcons.chevronLeft,
                  size: 25,
                  color: mTheme.onSurface.withOpacity(1),
                ),
              ),
              centerTitle: true,
              title: FxText.titleMedium(
                S.current.contentChallenge.toUpperCase(),
                fontWeight: 900,
                textScaleFactor: 1.2257,
                color: mTheme.primary,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Share.share(
                      '$apiBaseUrl/try/challenge/'
                      '${state.challenge?.id}',
                      sharePositionOrigin: Rect.fromLTWH(
                        0,
                        0,
                        size.width,
                        size.height / 2,
                      ),
                    );
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(FeatherIcons.share2),
                  ),
                  color: mTheme.onSurface.withOpacity(1),
                ),
                IconButton(
                  icon: const Icon(FeatherIcons.moreVertical),
                  color: mTheme.onSurface.withOpacity(1),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ],
            ),
            endDrawer: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                color: isDarkTheme
                    ? FxAppTheme.theme.cardTheme.color
                    : mTheme.onPrimary.withOpacity(0.75),
                child: const ChallengeInfoDrawer(),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FxContainer(
                        marginAll: 0,
                        paddingAll: 0,
                        height: size.height * 0.65,
                        borderRadiusAll: 16,
                        child: Column(
                          children: [
                            if (shouldShowChallengeInfo)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: ChallengeInfo(),
                              ),
                            Expanded(
                              child: FxContainer(
                                paddingAll: 0,
                                marginAll: 0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: img,
                                            ),
                                          ),
                                          BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: blurValue,
                                              sigmaY: blurValue,
                                            ),
                                            child: Container(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Expanded(
                                          child: ChallengePhraseWidget(),
                                        ),
                                        if (state.audiosample?.annotations !=
                                            null)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: RefAnnotations(),
                                          )
                                        else
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: SizedBox.shrink(),
                                          ),
                                        const ChallengeResultBar(),
                                        if (state.attempt != null)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: TestAnnotations(),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: ChallengeFavoritesButton(),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: AttemptsView(),
                                  ),
                                  if (state.attempt != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () =>
                                            _onShareGeneratedVideo(context),
                                        icon: Icon(
                                          Icons.video_call,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  if (state.attempt != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          context
                                              .read<ChallengeCubit>()
                                              .playTest();
                                        },
                                        icon: Icon(
                                          Icons.record_voice_over_outlined,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  if (state.attempt != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          context
                                              .read<ChallengeCubit>()
                                              .playHighlight();
                                        },
                                        icon: Icon(
                                          Icons.highlight,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  if (state.attempt != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          context
                                              .read<ChallengeCubit>()
                                              .playDuet();
                                        },
                                        icon: Icon(
                                          Icons.people_alt,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  const Expanded(child: SizedBox()),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      context
                                          .read<ChallengeCubit>()
                                          .switchTranslation();
                                    },
                                    icon: Icon(
                                      Icons.translate,
                                      color: mTheme.onSurface.withOpacity(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: BottomButons(),
                    ),
                    if (state.nextBtnVisible) const _NextButton(),
                  ],
                ),
                if (result > 70)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset(
                      'assets/lottie/medal.json',
                      width: 300,
                      height: 300,
                      repeat: false,
                    ),
                  ),
                if (result > 50)
                  const RiveComparisonAnimation(
                    percentage: 80,
                    artboard: 'confetti',
                  ),
                if (!state.isInQuota) const ChallengePayWall(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        final disabled = state.recorderStatus == RecorderStatus.analyzing ||
            state.recorderStatus == RecorderStatus.recording;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: FxButton.text(
            onPressed: () {
              VibrationController.onPressedVibration();
              final r = context.read<RatingCubit>();
              final f = context.read<ChallengeFavoriteCubit>();
              context
                  .read<ChallengeCubit>()
                  .loadRandomChallenge(
                    context.read<HomeCubit>().state.user.worklang,
                  )
                  .then(
                (_) {
                  r.loadRating(state.challenge!.id);
                  f.loadChallengeFavorite(
                    state.challenge!.id,
                  );
                },
              );
            },
            disabled: disabled,
            splashColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.titleMedium(
                  S.current.genericNext.toUpperCase(),
                  fontWeight: 700,
                  color: disabled
                      ? mTheme.onSurface.withOpacity(.5)
                      : mTheme.onSurface.withOpacity(1),
                  textAlign: TextAlign.center,
                ),
                FxSpacing.width(16),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: disabled
                      ? mTheme.onSurface.withOpacity(.5)
                      : mTheme.onSurface.withOpacity(1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FxText.bodyLarge(S.current.genericDownloading),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.onBackground.withAlpha(50),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _onShareGeneratedVideo(
  BuildContext context,
) async {
  _showLoadingDialog(context);
  final navigator = Navigator.of(context);

  final size = MediaQuery.sizeOf(context);
  final path = await context.read<ChallengeCubit>().createVideoForShare() ?? '';
  final file = XFile(path, mimeType: 'voccent/mp4');

  await Share.shareXFiles(
    [file],
    sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2.5),
  );
  navigator.pop();
}
