import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_state.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/widgets/custom_radial_chart.dart';

class MyAttemptPage extends StatelessWidget {
  const MyAttemptPage({
    required this.challengeId,
    required this.attemptId,
    super.key,
  });

  final String challengeId;
  final String attemptId;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;

    return BlocProvider(
      create: (context) => ShareAttemptCubit(
        context.read<UserScopeClient>(),
        context.read<AuthCubit>().state.userToken,
        context.read<WebSocket>(),
        challengeId,
        context.read<HomeCubit>().state.user.id,
      )..fetchMyAttemptData(attemptId),
      child: BlocBuilder<ShareAttemptCubit, ShareAttemptState>(
        builder: (context, state) {
          final img = state.challenge?.asset != null &&
                  state.challenge?.asset!['challenge_picture'] != null
              ? Image.network(
                  // ignore: avoid_dynamic_calls
                  '$apiBaseUrl/api/v1/asset/file/challenge_picture/${state.challenge!.asset!['challenge_picture'][0]}',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(.4),
                )
              : Image.asset(
                  'assets/images/Ccwhitebg.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(.4),
                );
          final isPlaying = state.testPlayerStatus == PlayerStatus.playing;

          final attempt = state.sharedAttempt;
          final isShareVoice = attempt?.isShareVoice ?? false;
          final totalPercent =
              '${attempt?.totalPercent?.toStringAsFixed(0) ?? ''}%';
          final pronunciation = attempt?.pronunciationPercent ?? 0;
          final pronunciationString = '${pronunciation.toStringAsFixed(0)}%';
          final pitch = attempt?.pitchPercent ?? 0;
          final picthString = '${pitch.toStringAsFixed(0)}%';
          final energy = attempt?.energyPercent ?? 0;
          final energyString = '${energy.toStringAsFixed(0)}%';
          final breath = attempt?.breathPercent ?? 0;
          final breathString = '${breath.toStringAsFixed(0)}%';
          final emotion = attempt?.emotionPercent ?? 0;
          final emotionString = '${emotion.toStringAsFixed(0)}%';
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(color: mTheme.background.withOpacity(1)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: img,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      FeatherIcons.chevronLeft,
                      size: 25,
                      color: mTheme.onBackground,
                    ),
                  ),
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Share.share(
                          '$apiBaseUrl/challenge/$challengeId/$attemptId',
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
                      color: mTheme.onBackground,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const _ChallengeInfo(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FxText.headlineMedium(
                                '${S.current.genericTotalResults} '
                                '$totalPercent',
                                color: mTheme.onSurface.withOpacity(1),
                                fontWeight: 600,
                              ),
                              if (isShareVoice)
                                IconButton(
                                  onPressed: () => context
                                      .read<ShareAttemptCubit>()
                                      .playTest(
                                        attempt?.audioSampleTstId,
                                      ),
                                  icon: isPlaying
                                      ? Lottie.asset(
                                          'assets/lottie/little_voice_secondary.json',
                                          height: 50,
                                        )
                                      : Icon(
                                          FeatherIcons.play,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                )
                              else
                                Container(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: FxContainer(
                            color: mTheme.onPrimary.withOpacity(0.7),
                            child: CustomRadialChart(
                              data: [
                                ChartData(
                                  '${S.current.genericPronunciation} '
                                  '$pronunciationString',
                                  pronunciation,
                                  S.current.genericPronunciation,
                                  const Color(0xFFFF9671),
                                ),
                                ChartData(
                                  '${S.current.genericPitch} $picthString',
                                  pitch,
                                  S.current.genericPitch,
                                  const Color(0xFFFF6F91),
                                ),
                                ChartData(
                                  '${S.current.genericEnergy} $energyString',
                                  energy,
                                  S.current.genericEnergy,
                                  const Color(0xFF845EC2),
                                ),
                                ChartData(
                                  '${S.current.genericBreath} $breathString',
                                  breath,
                                  S.current.genericBreath,
                                  const Color.fromRGBO(1, 174, 190, 1),
                                ),
                                ChartData(
                                  '${S.current.genericEmotion} $emotionString',
                                  emotion,
                                  S.current.genericEmotion,
                                  const Color.fromARGB(255, 165, 45, 250),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChallengeInfo extends StatelessWidget {
  const _ChallengeInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareAttemptCubit, ShareAttemptState>(
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        FxText.titleLarge(
                          state.challenge?.name ?? '',
                          fontWeight: 700,
                          color: mTheme.onSurface.withOpacity(1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    FxSpacing.height(8),
                    Row(
                      children: [
                        FxText.bodyMedium(
                          '${S.current.genericChannel}: ',
                          fontWeight: 300,
                          color: mTheme.onSurface.withOpacity(1),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                        FxText.bodyMedium(
                          state.challenge?.channelName ?? '',
                          fontWeight: 600,
                          color: mTheme.onSurface.withOpacity(1),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          decoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                    FxSpacing.height(4),
                    Row(
                      children: [
                        Expanded(
                          child: FxText.bodyMedium(
                            // ignore: lines_longer_than_80_chars
                            '${S.current.genericAuthor}: ${state.challenge?.userName ?? ''}',
                            fontWeight: 300,
                            color: mTheme.onSurface.withOpacity(1),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
