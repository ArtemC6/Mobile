import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/auth/cubit/user_status.dart';
import 'package:voccent/chat/cubit/chat_cubit.dart';
import 'package:voccent/error_guard/cubit/error_guard_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/locale/cubit/locale_state.dart';
import 'package:voccent/notification/cubit/notification_cubit.dart';
import 'package:voccent/route/app_pages.dart';
import 'package:voccent/subscription/cubit/subscription_cubit.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/ws_status/cubit/ws_status_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => UpdaterService(),
        dispose: (context, value) => value.dispose(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              lazy: false,
              create: (context) {
                if (context.read<AuthCubit>().state.userStatus ==
                    UserStatus.authenticated) {
                  return HomeCubit(
                    context.read<SharedPreferences>(),
                    context.read<UpdaterService>(),
                  )..fetchUser(
                      context.read<UserScopeClient>(),
                    );
                }

                return HomeCubit(
                  context.read<SharedPreferences>(),
                  context.read<UpdaterService>(),
                );
              },
            ),
            BlocProvider<NotificationCubit>(
              create: (context) {
                final cubit = NotificationCubit(
                  context.read<AuthCubit>().state.userToken,
                  context.read<WebSocket>(),
                  context.read<UpdaterService>(),
                );

                return cubit;
              },
            ),
            BlocProvider<ChatCubit>(
              create: (context) {
                final cubit = ChatCubit(
                  context.read<UserScopeClient>(),
                  context.read<WebSocket>(),
                  context.read<AuthCubit>().state.userToken,
                )..init(context.read<HomeCubit>().state.user);

                return cubit;
              },
            ),
            BlocProvider<WsStatusCubit>(
              create: (context) => WsStatusCubit(context.read<WebSocket>()),
            ),
            BlocProvider<SubscriptionCubit>(
              lazy: false,
              create: (context) {
                final s = SubscriptionCubit();

                if (context.read<AuthCubit>().state.userStatus ==
                    UserStatus.authenticated) {
                  s.loadProducts(context.read<UserScopeClient>());
                }

                return s;
              },
            ),
            BlocProvider<ThemeCubit>(
              create: (context) =>
                  ThemeCubit(context.read<SharedPreferences>())..init(),
            ),
            BlocProvider<LocaleCubit>(
              create: (context) =>
                  LocaleCubit(context.read<SharedPreferences>()),
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthCubit, AuthState>(
                listenWhen: (previous, current) =>
                    previous.userStatus != UserStatus.authenticated &&
                    current.userStatus == UserStatus.authenticated,
                listener: (context, state) => _loadUserData(context),
              ),
              BlocListener<HomeCubit, HomeState>(
                listenWhen: (previous, current) =>
                    previous.user != current.user,
                listener: (context, state) {
                  context.read<ChatCubit>().init(state.user);

                  if ((state.user.credId?.endsWith('@voccent.com') ?? false) ||
                      state.user.credId == 'wildneuro@gmail.com') {
                    context.read<ErrorGuardCubit>().enableUi();
                  } else {
                    context.read<ErrorGuardCubit>().disableUi();
                  }
                },
              ),
            ],
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return BlocBuilder<LocaleCubit, LocaleState>(
                  builder: (context, localeState) {
                    final router = context.read<AppPages>().router;
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      theme: themeState.theme,
                      locale: localeState.locale,
                      routeInformationProvider: router.routeInformationProvider,
                      routeInformationParser: router.routeInformationParser,
                      routerDelegate: router.routerDelegate,
                      localizationsDelegates: const [
                        S.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: S.delegate.supportedLocales,
                      builder: (context, child) => Scaffold(body: child),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

  void _loadUserData(BuildContext context) {
    if (!kIsWeb) {
      context
          .read<SubscriptionCubit>()
          .loadProducts(context.read<UserScopeClient>());
    }

    context.read<HomeCubit>().fetchUser(context.read<UserScopeClient>());
  }
}
