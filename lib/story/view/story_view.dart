import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/story_widget.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';

class StoryView extends StatelessWidget {
  const StoryView({
    required this.storyId,
    this.storyLink,
    this.planPassElementId,
    this.autostart = false,
    this.doneBtnVisibility = true,
    super.key,
  });

  final String storyId;
  final String? storyLink;
  final String? planPassElementId;
  final bool autostart;
  final bool doneBtnVisibility;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit(
        context.read<WebSocket>(),
        context.read<AuthCubit>().state.userToken,
        context.read<UserScopeClient>(),
        Dictionary.languages,
        context.read<LocaleCubit>().state.locale,
        context.read<UpdaterService>(),
        context.read<SharedPreferences>(),
      )..init(
          storyLink,
          storyId,
          planPassElementId,
          autostart: autostart,
          listWorkLang: context.read<HomeCubit>().state.user.worklang,
        ),
      child: StoryWidget(
        planPassElementId: planPassElementId,
        doneBtnVisibility: doneBtnVisibility,
      ),
    );
  }
}
