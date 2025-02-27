import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/chat/cubit/chat_cubit.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/classroom_card/widgets/dialog_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/error_guard/cubit/error_guard_cubit.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/widgets/feedback_widget.dart';
import 'package:voccent/http/account_deleted_exception.dart';
import 'package:voccent/http/invalid_token_exception.dart';
import 'package:voccent/http/username_is_taken_exception.dart';
import 'package:voccent/http/visible_to_user_server_exception.dart';
import 'package:voccent/lens/cubit/lens_cubit.dart';
import 'package:voccent/lens/lens_library.dart';
import 'package:voccent/notification/cubit/notification_cubit.dart';
import 'package:voccent/notification/widgets/new_notification_widget.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/vibration_controller.dart';
import 'package:voccent/ws_status/cubit/ws_status_cubit.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isShown = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initUniLinks();
    joinQrCodeClassroom();
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        navigateToRoute(initialLink);
      }
    } catch (e) {
      // ignore
    }

    linkStream.listen(
      (String? incomingLink) {
        if (incomingLink != null) {
          navigateToRoute(incomingLink);
        }
      },
      onError: (Object err, StackTrace stack) {
        FirebaseCrashlytics.instance.recordError(err, stack);
      },
    );
  }

  void navigateToRoute(String link) {
    final uri = Uri.parse(link);

    final path = uri.path;

    final appRoutePrefixes = [
      '/',
      '/mixer',
      '/chatroom/',
      '/try/',
      '/channel/',
      '/challenge/',
      '/playlist/',
      '/story/',
      '/story-pass/',
      '/classroom/',
      '/settings/organizations',
      '/activity_chat',
    ];

    if (appRoutePrefixes.any(path.startsWith)) {
      GoRouter.of(context).push(uri.toString());
    } else {
      GoRouter.of(context).push('/');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  Future<void> joinQrCodeClassroom() async {
    final sharedPreferences = context.read<SharedPreferences>();
    final code = sharedPreferences.getString('joinCode');

    if (code == null || code.isEmpty) return;

    try {
      final classroomCardCubit = context.read<ClassroomCardCubit>();
      final homeCubit = context.read<HomeCubit>();

      await classroomCardCubit.foundBarcodeJoinCode(code);

      if (!mounted) return;

      final id = await classroomCardCubit.joinClassroomByCode(
        homeCubit.state.user,
      );

      if (mounted) {
        classroomCardCubit.setRecentClassroom(id);
        await GoRouter.of(context).push('/classroom_card/$id');
      }
    } finally {
      await sharedPreferences.remove('joinCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;

    return BlocListener<ErrorGuardCubit, ErrorGuardState>(
      listenWhen: (previous, current) =>
          current.error.runtimeType == VisibleToUserServerException &&
              current.occuredAt != previous.occuredAt ||
          current.enabled &&
              current.occuredAt != previous.occuredAt &&
              // Hide error of opening an empty path
              // like 'https://app.voccent.com'
              current.error.runtimeType != RangeError &&
              current.error.runtimeType != AccountDeletedException &&
              current.error.runtimeType != InvalidTokenException &&
              current.error.runtimeType != UsernameIsTakenException,
      listener: (context, state) {
        if (state.error is ShakeException && !_isShown) {
          setState(() => _isShown = true);
          showDialog<void>(
            context: context,
            builder: (_) => const FeedbackWidget(),
          ).then((value) {
            setState(() => _isShown = false);
          });
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 48),
              behavior: SnackBarBehavior.floating,
              content: Text(state.error.toString()),
            ),
          );
      },
      child: BlocListener<NotificationCubit, NotificationState>(
        listenWhen: (previous, current) =>
            previous.notification != current.notification,
        listener: (context, state) {
          VibrationController.errorVibration();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 110,
                ),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: NewNotificationWidget(
                  thisContext: context,
                  newNotification: state.notification,
                ),
              ),
            );
        },
        child: BlocBuilder<WsStatusCubit, WsStatusState>(
          builder: (context, wsState) => BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final user = homeState.user;

              return Scaffold(
                body: RefreshIndicator(
                  displacement: 0,
                  backgroundColor: Colors.transparent,
                  onRefresh: () async {
                    context.read<HomeCubit>().refresh();
                    await context
                        .read<HomeCubit>()
                        .fetchUser(context.read<UserScopeClient>());
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        floating: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.1,
                        leadingWidth: 200,
                        leading: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go(
                              '/streamotion',
                            );
                          },
                          child: Row(
                            children: [
                              if (homeState.pictureId.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Image.network(
                                    '$apiBaseUrl/api/v1/asset/object/organization_picture/${homeState.pictureId}?t=${DateTime.now().millisecondsSinceEpoch}',
                                    errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) =>
                                        Image.asset(
                                      'assets/images/Ccwhitebg.png',
                                      height: 55,
                                      width: 55,
                                    ),
                                    height: 55,
                                    width: 55,
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Image.asset(
                                    'assets/images/voccent.png',
                                    color: context
                                            .read<ServerAddress>()
                                            .httpUri
                                            .host
                                            .endsWith('.net')
                                        ? mTheme.secondary
                                        : null,
                                  ),
                                ),
                              if (wsState.wsLastEvent == EventType.disconnected)
                                const Icon(
                                  FeatherIcons.cloudLightning,
                                  size: 18,
                                  color: Colors.red,
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () => GoRouter.of(context).go('/feed'),
                              icon: Icon(
                                FeatherIcons.search,
                                size: 25,
                                color: mTheme.onSurface.withOpacity(1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ClassroomCardCubit>(),
                                  child: const DialogWidget(),
                                ),
                              ),
                              icon: Icon(
                                Icons.qr_code_scanner,
                                size: 25,
                                color: mTheme.onSurface.withOpacity(1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () =>
                                  GoRouter.of(context).go('/chatroom'),
                              icon: BlocBuilder<ChatCubit, ChatState>(
                                builder: (context, chatState) {
                                  if (chatState.chats.any(
                                    (element) => element.messageStatus == 'new',
                                  )) {
                                    return Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Icon(
                                          FeatherIcons.bell,
                                          size: 25,
                                          color:
                                              mTheme.onSurface.withOpacity(1),
                                        ),
                                        Positioned(
                                          bottom: 13,
                                          top: 0,
                                          left: 8,
                                          child: Lottie.asset(
                                            'assets/lottie/redCircle.json',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Icon(
                                    FeatherIcons.bell,
                                    size: 25,
                                    color: mTheme.onSurface.withOpacity(1),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () =>
                                  GoRouter.of(context).go('/profile'),
                              icon: Icon(
                                FeatherIcons.user,
                                size: 25,
                                color: mTheme.onSurface.withOpacity(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            BlocProvider(
                              create: (context) => LensCubit(
                                context.read<UserScopeClient>(),
                                Dictionary.platformLanguageId(),
                                context
                                        .read<HomeCubit>()
                                        .state
                                        .user
                                        .currentlang ??
                                    [],
                                context.read<SharedPreferences>(),
                                context.read<UpdaterService>(),
                              )
                                ..fetchRecommendationsItems()
                                ..fetchClassrooms()
                                ..getRecentItems()
                                ..mixerAvailabilityCheck()
                                ..loadUserCompareLevel()
                                ..loadUserCountCompareByDate()
                                ..fetchMyClassrooms(),
                              child: const LensView(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: _isKeyboardVisible
                    ? null
                    : AnimatedGradientContainerWithAnimatedShadow(
                        id: user.id ?? '',
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniCenterDocked,
              );
            },
          ),
        ),
      ),
    );
  }
}
