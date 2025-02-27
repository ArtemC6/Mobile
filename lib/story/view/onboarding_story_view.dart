import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/story_widget.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';

class OnboardingStoryView extends StatefulWidget {
  const OnboardingStoryView({super.key});

  @override
  State<OnboardingStoryView> createState() => _OnboardingStoryViewState();
}

class _OnboardingStoryViewState extends State<OnboardingStoryView> {
  String? _storyId;
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _loadOnboardingStory(context.read<UserScopeClient>()).then(
      (value) => setState(
        () => _storyId = value,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _authCubit.didSeeOnboardingStory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_storyId == null) {
      return Container();
    }

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
          null,
          _storyId!,
          null,
          autostart: true,
          listWorkLang: context.read<HomeCubit>().state.user.worklang,
        ),
      child: const StoryWidget(doneBtnVisibility: true),
    );
  }

  Future<String?> _loadOnboardingStory(Client client) async {
    final platformLanguageId = Dictionary.platformLanguageId();

    final response = await client
        .get(
          Uri.parse(
            'api/v1/search/onboarding?sourceLocaleLanguageID=$platformLanguageId',
          ),
        )
        .listData();

    if (response.isEmpty) {
      const freeStoryId = '3386e84d-9df1-4098-aed3-b5fe6458d4d1';
      return freeStoryId;
    }

    final firstItem = response[0] as Map<String, dynamic>;
    final storyId = firstItem['ID'] as String;

    return storyId;
  }
}
