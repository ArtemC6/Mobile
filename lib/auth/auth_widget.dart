import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/authentication_repository/authentication_repository.dart';
import 'package:voccent/home/home_view.dart';
import 'package:voccent/http/account_deleted_exception.dart';
import 'package:voccent/http/audiosample_cache_client.dart';
import 'package:voccent/http/authenticated_client.dart';
import 'package:voccent/http/client_token.dart';
import 'package:voccent/http/crashlytics_client.dart';
import 'package:voccent/http/error_catching_client.dart';
import 'package:voccent/http/error_throwing_client.dart';
import 'package:voccent/http/invalid_token_exception.dart';
import 'package:voccent/http/specific_server_client.dart';
import 'package:voccent/http/username_is_taken_exception.dart';
import 'package:voccent/http/username_required_exception.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/pushy/pushy.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/route/app_pages.dart';
import 'package:voccent/web_socket/web_socket.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    _authenticationRepository = AuthenticationRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        _authenticationRepository,
        context.read<ClientToken>(),
        context.read<ServerAddress>(),
        context.read<SharedPreferences>(),
        context.read<WebSocket>(),
      )..restoreUserFromStorage(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => UserScopeClient(
                AudiosampleCacheClient(
                  ErrorThrowingClient(
                    SpecificServerClient(
                      context.read<ServerAddress>().httpUri,
                      ErrorCatchingClient<UsernameIsTakenException>(
                        ErrorCatchingClient<UsernameRequiredException>(
                          ErrorCatchingClient<AccountDeletedException>(
                            ErrorCatchingClient<InvalidTokenException>(
                              AuthenticatedClient(
                                context.read<AuthCubit>().state.userToken,
                                CrashlyticsClient(
                                  RetryClient(
                                    Client(),
                                    when: (p0) => p0.statusCode > 401,
                                    whenError: (p0, p1) => true,
                                    onRetry: (p0, p1, retryCount) {
                                      log(
                                        'User scope retried: `$p0` `$p1`',
                                        name: 'HTTP',
                                      );
                                      return FirebaseAnalytics.instance
                                          .logEvent(
                                        name: 'http_retry',
                                        parameters: {
                                          'scope': 'user',
                                          'request': '$p0',
                                          'response': '$p1',
                                          'count': '$retryCount',
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              callback: (e) =>
                                  context.read<AuthCubit>().logout(),
                            ),
                            callback: (e) => context.read<AuthCubit>().logout(),
                          ),
                          callback: (e) => context.read<AuthCubit>().logout(),
                        ),
                        callback: (e) => context.read<AuthCubit>().logout(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            RepositoryProvider(
              create: (context) => AppPages(context.read<AuthCubit>()),
            ),
            RepositoryProvider(
              create: (_) => LocaleCubit(context.read<SharedPreferences>()),
            ),
          ],
          child: const PushyWidget(
            child: HomeView(),
          ),
        ),
      ),
    );
  }
}

class UserScopeClient extends ErrorThrowingClient {
  UserScopeClient(super.origin);
}
