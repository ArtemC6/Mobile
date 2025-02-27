import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/about/cubit/about_cubit.dart';
import 'package:voccent/about/widgets/about_widget.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/activity_chat/view/activity_chat_view.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/auth/cubit/user_status.dart';
import 'package:voccent/auth/view/login_view.dart';
import 'package:voccent/challenge/view/challenge_page.dart';
import 'package:voccent/challenge/widgets/attempts/my_attempt_page.dart';
import 'package:voccent/channel/view/channel_content_page.dart';
import 'package:voccent/channel/view/channel_page.dart';
import 'package:voccent/chat/widgets/chat_widget.dart';
import 'package:voccent/chat/widgets/single_chat_screen.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/classroom_card/widgets/classroom_card.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/classroom_search/widgets/classroom_page.dart';
import 'package:voccent/completed_plan/cubit/completed_plan_cubit.dart';
import 'package:voccent/completed_plan/view/single_plan_screen.dart';
import 'package:voccent/completed_plans/widgets/completed_plans_view.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/view/feed_view.dart';
import 'package:voccent/guide/view/guide_view.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/widgets/home_widget.dart';
import 'package:voccent/lens/cubit/lens_cubit.dart';
import 'package:voccent/lens/lens_library.dart';
import 'package:voccent/mixer/view/mixer_view.dart';
import 'package:voccent/onboarding/i_want_to_speak_view.dart';
import 'package:voccent/organizations/widgets/organizations_view.dart';
import 'package:voccent/plan_pass/cubit/plan_pass_cubit.dart';
import 'package:voccent/plan_pass/plan_pass_data.dart';
import 'package:voccent/plan_pass/widgets/plan_step.dart';
import 'package:voccent/playlist/view/playlist_page.dart';
import 'package:voccent/profile/widgets/profile_editor_view.dart';
import 'package:voccent/profile/widgets/profile_view.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/route/navigation_fallback_web_view.dart';
import 'package:voccent/sound_receiver_mode/widgets/sound_receiver_mode_widget.dart';
import 'package:voccent/story/view/onboarding_story_view.dart';
import 'package:voccent/story/view/story_view.dart';
import 'package:voccent/streamotion/cubit/streamotion_cubit.dart';
import 'package:voccent/streamotion/widgets/streamotion.dart';
import 'package:voccent/subscription/widgets/subscription_widget.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';

class AppPages {
  AppPages(this._authCubit);

  static const String loginRouteName = 'login';
  static const String onboardingRouteName = 'onboarding';
  static const String onboardingStoryRouteName = 'onboardingstory';
  final AuthCubit _authCubit;

  late final router = GoRouter(
    observers: [MyNavObserver()],
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        name: loginRouteName,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const LoginView(),
        ),
      ),
      GoRoute(
        name: onboardingRouteName,
        path: '/onboarding',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const IWantToSpeakView(),
        ),
      ),
      GoRoute(
        name: 'root',
        path: '/',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: BlocProvider(
            create: (context) => ClassroomCardCubit(
              context.read<WebSocket>(),
              context.read<AuthCubit>().state.userToken,
              context.read<UserScopeClient>(),
              context.read<SharedPreferences>(),
              context.read<UpdaterService>(),
            ),
            child: const HomeWidget(),
          ),
        ),
        routes: [
          GoRoute(
            name: 'guide',
            path: 'guide',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const GuideView(),
            ),
          ),
          GoRoute(
            name: 'chats',
            path: 'chatroom',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const ChatWidget(),
            ),
            routes: [
              GoRoute(
                name: 'chatroom',
                path: ':chatId',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: SingleChatScreen(state.pathParameters['chatId']!),
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'activitychat',
            path: 'activity_chat',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: ActivityChatView(
                activityChatData: state.extra as ActivityChatData?,
              ),
            ),
          ),
          GoRoute(
            name: 'settingsorgs',
            path: 'settings/organizations',
            redirect: (context, state) => '/profile/organizations',
          ),
          GoRoute(
            name: 'profile',
            path: 'profile',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const ProfileView(),
            ),
            routes: [
              GoRoute(
                name: 'subscriptions',
                path: 'subscriptions',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: const SubscriptionWidget(),
                ),
              ),
              GoRoute(
                name: 'editor',
                path: 'editor',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: const ProfileEditorView(),
                ),
              ),
              GoRoute(
                name: 'about',
                path: 'about',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => AboutCubit(
                      context.read<UserScopeClient>(),
                      context.read<WebSocket>(),
                    )..init(),
                    child: const AboutWidget(),
                  ),
                ),
              ),
              GoRoute(
                name: 'organizations',
                path: 'organizations',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: const OrganizationsView(),
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'feed',
            path: 'feed',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: FeedView(
                parameters: state.extra as Parameters?,
              ),
            ),
          ),
          GoRoute(
            name: 'mixer',
            path: 'mixer',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const MixerWidget(),
            ),
          ),
          GoRoute(
            name: 'dice',
            path: 'dice',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const HomeWidget(),
            ),
          ),
          GoRoute(
            name: 'streamotion',
            path: 'streamotion',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => StreamotionCubit(
                  context.read<UserScopeClient>(),
                  context.read<WebSocket>(),
                  context.read<AuthCubit>().state.userToken,
                )..init(),
                child: const Streamotion(),
              ),
            ),
          ),
          GoRoute(
            name: 'soundreceivermode',
            path: 'soundreceivermode',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const SoundReceirverModeWidget(),
            ),
          ),
          GoRoute(
            name: 'trychannel',
            path: 'try/c/:channelName',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: ChannelPage(
                channelName: state.pathParameters['channelName'],
              ),
            ),
          ),
          GoRoute(
            name: 'trychallange',
            path: 'try/challenge/:challengeId',
            redirect: (context, state) =>
                '/challenge/${state.pathParameters['challengeId']}',
          ),
          GoRoute(
            name: 'tryplaylist',
            path: 'try/playlist/:playlistId',
            redirect: (context, state) =>
                '/playlist/${state.pathParameters['playlistId']}',
          ),
          GoRoute(
            name: 'channel',
            path: 'channel/:channelId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: ChannelPage(channelId: state.pathParameters['channelId']),
            ),
            routes: [
              GoRoute(
                name: 'channelcontent',
                path: 'content',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: ChannelContentPage(state.pathParameters['channelId']!),
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'challenge',
            path: 'challenge/:challengeId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: ChallengePageById(
                challengeId: state.pathParameters['challengeId']!,
              ),
            ),
            routes: [
              GoRoute(
                name: 'attempt',
                path: ':attemptId',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: MyAttemptPage(
                    attemptId: state.pathParameters['attemptId']!,
                    challengeId: state.pathParameters['challengeId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'playlist',
            path: 'playlist/:playlistId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: PlaylistPageById(
                playlistId: state.pathParameters['playlistId']!,
              ),
            ),
          ),
          GoRoute(
            name: 'storypass',
            path: 'story-pass/:storyId',
            redirect: (context, state) {
              if (state.uri.queryParameters['l'] != null) {
                return '/story/${state.pathParameters['storyId']}?l=${state.uri.queryParameters['l']}';
              }

              return '/story/${state.pathParameters['storyId']}';
            },
          ),
          GoRoute(
            name: 'trystorypass',
            path: 'try/story-pass/:storyId',
            redirect: (context, state) {
              if (state.uri.queryParameters['l'] != null) {
                return '/story/${state.pathParameters['storyId']}?l=${state.uri.queryParameters['l']}';
              }

              return '/story/${state.pathParameters['storyId']}';
            },
          ),
          GoRoute(
            name: 'story',
            path: 'story/:storyId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: StoryView(
                storyId: state.pathParameters['storyId']!,
                storyLink: state.uri.queryParameters['l'],
                autostart: bool.parse(
                  state.uri.queryParameters['autostart'] ?? 'false',
                ),
              ),
            ),
          ),
          GoRoute(
            name: onboardingStoryRouteName,
            path: 'onboardingstory',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const OnboardingStoryView(),
            ),
          ),
          GoRoute(
            name: 'classroom',
            path: 'classroom/:classroomId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => ClassroomCardCubit(
                  context.read<WebSocket>(),
                  context.read<AuthCubit>().state.userToken,
                  context.read<UserScopeClient>(),
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                )
                  ..setCode(
                    state.pathParameters['classroomId'],
                    null,
                  )
                  ..fetchClassroom(
                    context.read<HomeCubit>().state.user,
                  ),
                child: const ClassroomCard(),
              ),
            ),
          ),
          GoRoute(
            name: 'classroomsearch',
            path: 'classroom_search',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => ClassroomSearchCubit(
                  context.read<UserScopeClient>(),
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                  context.read<HomeCubit>().userLanguages(),
                  context.read<HomeCubit>().state.user.currentlang ?? [],
                  Dictionary.platformLanguageId(),
                ),
                child: const ClassroomPage(),
              ),
            ),
          ),
          GoRoute(
            name: 'classroomcard',
            path: 'classroom_card/:classroomId',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => ClassroomCardCubit(
                  context.read<WebSocket>(),
                  context.read<AuthCubit>().state.userToken,
                  context.read<UserScopeClient>(),
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                )
                  ..setCode(
                    state.pathParameters['classroomId'],
                    null,
                  )
                  ..fetchClassroom(
                    context.read<HomeCubit>().state.user,
                  ),
                child: const ClassroomCard(),
              ),
            ),
          ),
          GoRoute(
            name: 'joinclassroomwithcode',
            path: 'classroom/join/:code',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => ClassroomCardCubit(
                  context.read<WebSocket>(),
                  context.read<AuthCubit>().state.userToken,
                  context.read<UserScopeClient>(),
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                )
                  ..setCode(
                    null,
                    state.pathParameters['code'],
                  )
                  ..fetchClassroom(
                    context.read<HomeCubit>().state.user,
                  ),
                child: const ClassroomCard(),
              ),
            ),
          ),
          GoRoute(
            name: 'planpass',
            path: 'plan_pass/:planId/:cplanId/:continue',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => PlanPassCubit(
                  context.read<UpdaterService>(),
                  client: context.read<UserScopeClient>(),
                  user: context.read<HomeCubit>().state.user,
                  planId: state.pathParameters['planId'] ?? '',
                  cplanId: state.pathParameters['cplanId'] ?? '',
                  kontinue: state.pathParameters['continue']! == 'true',
                )..fetchPlanPass(),
                child: PlanStep(
                  planPassData: state.extra as PlanPassData?,
                ),
              ),
            ),
          ),
          GoRoute(
            name: 'completedplans',
            path: 'completedplans',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: const CompletedPlansView(),
            ),
            routes: [
              GoRoute(
                name: 'completedplan',
                path: ':passId',
                pageBuilder: (context, state) => MaterialPage<void>(
                  name: state.name,
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => CompletedPlanCubit(
                      client: context.read<UserScopeClient>(),
                    )..fetchCompletedPlan(state.pathParameters['passId']!),
                    child: const SinglePlanScreen(),
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'recent',
            path: 'recent',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: RecentViewWidget(
                type: state.extra! as ItemType,
              ),
            ),
          ),
          GoRoute(
            name: 'recommedations_pass',
            path: 'recommedations_pass',
            pageBuilder: (context, state) => MaterialPage<void>(
              name: state.name,
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => LensCubit(
                  context.read<UserScopeClient>(),
                  Dictionary.platformLanguageId(),
                  context.read<HomeCubit>().state.user.currentlang ?? [],
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                ),
                child: RecommendationsPass(
                  recommendationsData: state.extra! as RecommedationsData,
                ),
              ),
            ),
          ),
        ],
      ),
    ],

    // redirect to the login page if the user is not logged in
    redirect: redirect,

    // changes on the listenable will cause the router to refresh it's
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),

    errorPageBuilder: (context, state) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(
          Exception('Tried to open unsupported location `${state.uri}`'),
          StackTrace.current,
        );
      }

      return MaterialPage<void>(
        key: state.pageKey,
        child: NavigationFallbackWebView(
          context.read<ServerAddress>().httpUri.toString() +
              state.uri.toString(),
        ),
      );
    },
  );

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    // if the user is not logged in, they need to login
    final loggedIn = _authCubit.state.userStatus == UserStatus.authenticated;
    final loggingIn =
        state.matchedLocation == router.namedLocation(loginRouteName) ||
            state.matchedLocation == router.namedLocation(onboardingRouteName);

    // bundle the location the user is coming
    // from into a query parameter
    const homeloc = '/';
    final fromloc = state.uri.toString() == homeloc ? '' : state.uri.toString();
    if (!loggedIn) {
      return loggingIn
          ? null
          : router.namedLocation(
              loginRouteName,
              queryParameters: {if (fromloc.isNotEmpty) 'from': fromloc},
            );
    }

    if (_authCubit.state.isFirstRun) {
      return router.namedLocation(onboardingStoryRouteName);
    }

    // if the user is logged in, send them
    // where they were going before
    // (or home if they weren't going anywhere)
    if (loggingIn) return state.uri.queryParameters['from'] ?? homeloc;

    // no need to redirect at all
    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class MyNavObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'nav did push ${_str(route, previousRoute)}',
      name: 'app_pages',
    );

    FirebaseCrashlytics.instance.log(
      'nav did push ${_str(route, previousRoute)}',
    );

    FirebaseAnalytics.instance
        .logScreenView(screenName: route.settings.name ?? 'unnamed');
    Smartlook.instance
        .trackNavigationExit(previousRoute?.settings.name ?? 'unnamed');
    Smartlook.instance.trackNavigationEnter(route.settings.name ?? 'unnamed');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'nav did pop ${_str(route, previousRoute)}',
      name: 'app_pages',
    );

    FirebaseCrashlytics.instance.log(
      'nav did pop ${_str(route, previousRoute)}',
    );

    FirebaseAnalytics.instance
        .logScreenView(screenName: route.settings.name ?? 'unnamed');
    Smartlook.instance
        .trackNavigationExit(previousRoute?.settings.name ?? 'unnamed');
    Smartlook.instance.trackNavigationEnter(route.settings.name ?? 'unnamed');
  }

  String _str(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      'from (${previousRoute?.settings.name}: '
      '${previousRoute?.settings.arguments})'
      ' to (${route.settings.name}: '
      '${route.settings.arguments})';
}
