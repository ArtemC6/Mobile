import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/audio/audio_controls.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/playlist/cubit/playlist_cubit.dart';
import 'package:voccent/playlist/cubit/playlist_translation_cubit.dart';
import 'package:voccent/playlist/widgets/playlist_widget.dart';
import 'package:voccent/updater_service/updater_service.dart';

class PlaylistPageById extends StatelessWidget {
  const PlaylistPageById({required this.playlistId, super.key});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistCubit>(
          create: (_) => PlaylistCubit(
            context.read<UserScopeClient>(),
            context.read<AudioControls>(),
            context.read<UpdaterService>(),
            context.read<SharedPreferences>(),
          )..loadPlaylist(playlistId),
        ),
        BlocProvider<PlaylistTranslationCubit>(
          create: (context) => PlaylistTranslationCubit(
            context.read<UserScopeClient>(),
            Dictionary.languages,
            context.read<LocaleCubit>().state.locale,
          ),
        ),
      ],
      child: const PlaylistWidget(),
    );
  }
}
