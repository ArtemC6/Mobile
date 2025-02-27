part of '../lens_library.dart';

class LensView extends StatelessWidget {
  const LensView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoryForLensCubit(
            context.read<UserScopeClient>(),
            Dictionary.platformLanguageId(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            context.read<SharedPreferences>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => ChallengeForLensCubit(
            context.read<UserScopeClient>(),
            Dictionary.platformLanguageId(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            context.read<SharedPreferences>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => PlaylistForLensCubit(
            context.read<UserScopeClient>(),
            Dictionary.platformLanguageId(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            context.read<SharedPreferences>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => ChannelForLensCubit(
            context.read<UserScopeClient>(),
            Dictionary.platformLanguageId(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            context.read<SharedPreferences>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => FavoriteChallengeCubit(
            context.read<UserScopeClient>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => CompletedPlansCubit(
            client: context.read<UserScopeClient>(),
          ),
        ),
        BlocProvider(
          create: (context) => ClassroomSearchCubit(
            context.read<UserScopeClient>(),
            context.read<SharedPreferences>(),
            context.read<UpdaterService>(),
            context.read<HomeCubit>().userLanguages(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            Dictionary.platformLanguageId(),
          ),
        ),
      ],
      child: const LensWidget(),
    );
  }
}
