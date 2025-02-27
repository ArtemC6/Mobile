import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_state.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/shared_attempts.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/radius_score_widget.dart';

class AllAttemptsWidget extends StatefulWidget {
  const AllAttemptsWidget({super.key});

  @override
  State<AllAttemptsWidget> createState() => _AllAttemptsWidgetState();
}

class _AllAttemptsWidgetState extends State<AllAttemptsWidget> {
  Set<int> expandedIndices = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShareAttemptCubit>().fetchSharedAttemptsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocBuilder<ShareAttemptCubit, ShareAttemptState>(
        builder: (context, state) {
          if (state.sharedAttempts == null || state.sharedAttempts!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/search.json',
                    ),
                    FxText.titleLarge(
                      'No one has shared their attempt yet',
                      textAlign: TextAlign.center,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ],
                ),
              ),
            );
          }
          final sortedAttempts = List<SharedAttempt>.from(state.sharedAttempts!)
            ..sort((a, b) => b.totalPercent!.compareTo(a.totalPercent!));

          return ListView.builder(
            itemCount: sortedAttempts.length,
            itemBuilder: (context, index) {
              final attempt = sortedAttempts[index];
              final isShareVoice = attempt.isShareVoice ?? false;
              final createdAt = DateFormat().format(attempt.createdat!);
              final isPlaying =
                  state.playingAudioSampleTstId == attempt.audioSampleTstId;
              final totalPercent =
                  '${attempt.totalPercent?.toStringAsFixed(0)}%';
              final score = attempt.totalPercent ?? 0.0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mTheme.primary,
                        mTheme.primary.withOpacity(0.5),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3,
                        offset: const Offset(4, 8),
                      ),
                    ],
                  ),
                  child: FxContainer(
                    onTap: () {
                      setState(() {
                        if (expandedIndices.contains(index)) {
                          expandedIndices.remove(index);
                        } else {
                          expandedIndices.add(index);
                        }
                      });
                    },
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FxText.headlineMedium(
                                    '${attempt.userName}',
                                    color: mTheme.onPrimary,
                                    textAlign: TextAlign.center,
                                    fontSize: 22.5,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: 700,
                                    letterSpacing: 0,
                                  ),
                                  FxSpacing.width(10),
                                  BlocBuilder<ShareAttemptCubit,
                                      ShareAttemptState>(
                                    builder: (context, state) {
                                      return isShareVoice
                                          ? IconButton(
                                              onPressed: () => context
                                                  .read<ShareAttemptCubit>()
                                                  .playTest(
                                                    attempt.audioSampleTstId,
                                                  ),
                                              icon: isPlaying
                                                  ? Lottie.asset(
                                                      'assets/lottie/little_voice_secondary.json',
                                                      height: 50,
                                                    )
                                                  : Icon(
                                                      FeatherIcons.play,
                                                      color: mTheme.onPrimary,
                                                    ),
                                            )
                                          : Container();
                                    },
                                  ),
                                ],
                              ),
                              Divider(
                                color: mTheme.onPrimary,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: mTheme.onPrimary
                                                    .withOpacity(0.15),
                                                blurRadius: 6,
                                                spreadRadius: 6,
                                              ),
                                            ],
                                          ),
                                          width: 92,
                                          height: 92,
                                          child: RadiusScoreWidget(
                                            percent: score / 100,
                                            fillColor: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                mTheme.primary,
                                                mTheme.secondary,
                                              ],
                                            ),
                                            lineColor: mTheme.primary,
                                            freeColor: mTheme.onPrimary,
                                            lineWidth: 2,
                                            child: FxText.titleLarge(
                                              totalPercent,
                                              color: mTheme.onPrimary,
                                              fontWeight: 700,
                                              textAlign: TextAlign.center,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (expandedIndices.contains(index))
                          Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: FxText.bodyMedium(
                                      createdAt,
                                      color: mTheme.onPrimary,
                                      fontWeight: 600,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: FxButton.block(
                                      onPressed: () {
                                        GoRouter.of(context).push(
                                          '/challenge/${attempt.challengeId}/${attempt.id}',
                                        );
                                      },
                                      backgroundColor: mTheme.secondary,
                                      child: Text(S.current.genericView),
                                    ),
                                  ),
                                ],
                              ),
                              FxSpacing.height(8),
                            ],
                          ),
                        if (expandedIndices.contains(index))
                          Icon(
                            FeatherIcons.chevronUp,
                            color: mTheme.onPrimary,
                          )
                        else
                          Icon(
                            FeatherIcons.chevronDown,
                            color: mTheme.onPrimary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
