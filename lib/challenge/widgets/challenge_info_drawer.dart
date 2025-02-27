import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/widgets/challenge_favorite_button.dart';
import 'package:voccent/challenge/widgets/challenge_rating_button.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';

class ChallengeInfoDrawer extends StatelessWidget {
  const ChallengeInfoDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        final apiBaseUrl = context.read<ServerAddress>().httpUri;
        final img = state.challenge?.asset != null &&
                state.challenge?.asset!['challenge_picture'] != null
            ? Image.network(
                // ignore: avoid_dynamic_calls
                '$apiBaseUrl/api/v1/asset/file/challenge_picture/${state.challenge!.asset!['challenge_picture'][0]}',
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(.7),
                height: 200,
                width: 200,
              )
            : Image.asset(
                'assets/images/Ccwhitebg.png',
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(.7),
                height: 200,
                width: 200,
              );
        return Drawer(
          backgroundColor: isDarkTheme
              ? FxAppTheme.theme.cardTheme.color
              : mTheme.background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: img),
                      const SizedBox(height: 16),
                      FxText.titleLarge(
                        state.challenge?.name ?? '',
                        color: mTheme.onSurface.withOpacity(1),
                        fontWeight: 600,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FxText.bodyLarge(
                        '${S.current.genericChannel}:',
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(context).push(
                          '/channel/${context.read<ChallengeCubit>().state.challenge!.channelId}',
                        ),
                        child: FxText.bodyLarge(
                          state.challenge?.channelName ?? '',
                          color: mTheme.onSurface.withOpacity(1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FxText.bodyLarge(
                        '${S.current.genericAuthor}:',
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                      FxText.bodyLarge(
                        state.challenge?.userName ?? '',
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChallengeRatingButton(),
                    ChallengeFavoritesButton(),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
