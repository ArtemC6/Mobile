import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_state.dart';
import 'package:voccent/generated/l10n.dart';

class MyAttemptsWidget extends StatefulWidget {
  const MyAttemptsWidget({super.key});

  @override
  State<MyAttemptsWidget> createState() => _MyAttemptsWidgetState();
}

class _MyAttemptsWidgetState extends State<MyAttemptsWidget> {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChallengeCubit, ChallengeState>(
              builder: (context, state) {
                if (state.loadingMyAttempts) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                state.myAttempts.sort((a, b) {
                  final percentComparison =
                      b.totalPercent.compareTo(a.totalPercent);

                  if (percentComparison != 0) {
                    return percentComparison;
                  }

                  if (a.createdAtLocal != null && b.createdAtLocal != null) {
                    return b.createdAtLocal!.compareTo(a.createdAtLocal!);
                  }

                  return 0;
                });
                if (state.myAttempts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/search.json',
                          ),
                          FxText.titleLarge(
                            "Here's a list of your attempts. "
                            '\n'
                            'Try tackling the first one',
                            textAlign: TextAlign.center,
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ListView.builder(
                      itemCount: state.myAttempts.length,
                      itemBuilder: (context, index) {
                        final isFirstElement = index == 0;
                        final dateString =
                            '${state.myAttempts[index].createdAtLocal}';
                        final score =
                            '${state.myAttempts[index].totalPercent.round()}';

                        return ListOfMyAttempts(
                          isFirstElement: isFirstElement,
                          score: score,
                          dateString: dateString,
                          challengeCubit: context.read<ChallengeCubit>(),
                          onTap: () {
                            if (!isFirstElement) {
                              context
                                  .read<ChallengeCubit>()
                                  .deleteMyAttempts(state.myAttempts[index].id);
                              setState(() => state.myAttempts.removeAt(index));
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListOfMyAttempts extends StatelessWidget {
  const ListOfMyAttempts({
    required this.isFirstElement,
    required this.score,
    required this.dateString,
    required this.challengeCubit,
    required this.onTap,
    super.key,
  });

  final bool isFirstElement;
  final String score;
  final String dateString;
  final ChallengeCubit challengeCubit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxContainer(
            bordered: isFirstElement || false,
            borderColor: mTheme.primary,
            color: mTheme.onPrimary,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FxText.headlineSmall(
                    '${S.current.genericTotalResults} $score%',
                    color: isFirstElement ? mTheme.primary : mTheme.onSecondary,
                  ),
                ),
                if (isFirstElement) const SharingWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 4,
                      child: FxText.titleMedium(
                        dateString,
                        color: isFirstElement
                            ? mTheme.primary
                            : mTheme.onSecondary,
                      ),
                    ),
                    if (!isFirstElement)
                      IconButton(
                        onPressed: onTap,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SharingWidget extends StatelessWidget {
  const SharingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<ShareAttemptCubit, ShareAttemptState>(
      builder: (context, state) {
        return Column(
          children: [
            SwitchListTile.adaptive(
              title: FxText.bodyMedium(
                S.current.genericNotShared,
                color: mTheme.onSecondary,
              ),
              value: state.noShare,
              onChanged: (value) {
                context.read<ShareAttemptCubit>().toggleNoShare();
              },
              activeColor: mTheme.primary,
            ),
            SwitchListTile.adaptive(
              title: FxText.bodyMedium(
                S.current.genericSharedWithAuthor,
                color: mTheme.onSecondary,
              ),
              value: state.shareWithAuthor,
              onChanged: (value) {
                context.read<ShareAttemptCubit>().toggleShareWithAuthor();
              },
              activeColor: mTheme.primary,
            ),
            SwitchListTile.adaptive(
              title: FxText.bodyMedium(
                S.current.genericSharedWithAllUsers,
                color: mTheme.onSecondary,
              ),
              value: state.shareWithAllUsers,
              onChanged: (value) {
                context.read<ShareAttemptCubit>().toggleShareWithAllUsers();
              },
              activeColor: mTheme.primary,
            ),
            SwitchListTile.adaptive(
              title: FxText.bodyMedium(
                S.current.genericVoiceIncluded,
                color: mTheme.onSecondary,
              ),
              value: state.includeVoice && !state.noShare,
              onChanged: (value) {
                context.read<ShareAttemptCubit>().toggleIncludeVoice();
              },
              activeColor: mTheme.primary,
            ),
          ],
        );
      },
    );
  }
}
