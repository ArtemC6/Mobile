import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_favorite_cubit.dart';
import 'package:voccent/challenge/cubit/rating_cubit.dart';
import 'package:voccent/challenge/view/challenge_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/updater_service/updater_service.dart';

class ChallengePageById extends StatelessWidget {
  const ChallengePageById({
    required this.challengeId,
    this.nextBtnVisibility = true,
    super.key,
  });

  final String challengeId;
  final bool nextBtnVisibility;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChallengeCubit>(
          create: (_) => ChallengeCubit(
            context.read<UserScopeClient>(),
            context.read<HomeCubit>(),
            Dictionary.languages,
            context.read<LocaleCubit>().state.locale,
            context.read<UpdaterService>(),
            context.read<SharedPreferences>(),
            nextBtnVisibility: nextBtnVisibility,
          )..loadChallenge(
              challengeId,
              context.read<HomeCubit>().state.user.worklang,
            ),
        ),
        BlocProvider<RatingCubit>(
          create: (_) => RatingCubit(
            context.read<UserScopeClient>(),
          )..loadRating(challengeId),
        ),
        BlocProvider<ChallengeFavoriteCubit>(
          create: (_) => ChallengeFavoriteCubit(
            context.read<UserScopeClient>(),
          )..loadChallengeFavorite(challengeId),
        ),
      ],
      child: const ChallengeWidget(),
    );
  }
}
