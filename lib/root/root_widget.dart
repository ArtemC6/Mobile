import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/audio/audio_controls.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/error_guard/cubit/error_guard_cubit.dart';
import 'package:voccent/http/authenticated_client.dart';
import 'package:voccent/http/client_token.dart';
import 'package:voccent/http/crashlytics_client.dart';
import 'package:voccent/http/error_throwing_client.dart';
import 'package:voccent/http/specific_server_client.dart';
import 'package:voccent/web_socket/web_socket.dart';

class ServerAddress {
  ServerAddress(String host) {
    httpUri = Uri.parse('https://$host');
    wsUri = Uri.parse('wss://$host/streamer/ws/main');
  }

  late final Uri httpUri;
  late final Uri wsUri;

  // generate time string xxx for image address (add into address like ?t=xxx)
  // need to reload image from server (each N minutes)
  // for example if N=5: 12:06=>12.05; 12:07=>12.05; 12:01=>12.00
  String cacheImgHash() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final dif = date.minute % 5;
    final dt = date.add(Duration(minutes: -dif));

    return base64Encode(utf8.encode(dt.toIso8601String()));
  }
}

class RootWidget extends StatefulWidget {
  RootWidget(
    String host,
    this._storage, {
    super.key,
  }) {
    _server = ServerAddress(host);
  }

  late final ServerAddress _server;
  final SharedPreferences _storage;

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  final smartLook = Smartlook.instance;

  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {
      smartLook.preferences
          .setProjectKey('83552ed651b07756a61e62f7bcdb949fa7c2cb49');
      smartLook
        ..start()
        ..trackNavigationEnter('Root a1693f0f');
    }

    if (Device.get().isPhone) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) => SmartlookRecordingWidget(
        child: BlocProvider(
          lazy: false,
          create: (context) => ErrorGuardCubit(),
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) =>
                    ClientToken(widget._server.httpUri, widget._storage),
              ),
              RepositoryProvider(
                create: (context) => WebSocket(uri: widget._server.wsUri),
              ),
              RepositoryProvider(
                create: (context) => widget._storage,
              ),
              RepositoryProvider(
                create: (context) => widget._server,
              ),
              RepositoryProvider(
                create: (context) => AudioControls()..init(),
              ),
            ],
            child: RepositoryProvider(
              create: (context) => ClientScopeClient(
                ErrorThrowingClient(
                  SpecificServerClient(
                    context.read<ServerAddress>().httpUri,
                    AuthenticatedClient(
                      context.read<ClientToken>(),
                      CrashlyticsClient(
                        RetryClient(
                          Client(),
                          when: (p0) => p0.statusCode > 401,
                          whenError: (p0, p1) => true,
                          onRetry: (p0, p1, retryCount) {
                            log('Client scope retried: `$p0`', name: 'HTTP');
                            return FirebaseAnalytics.instance.logEvent(
                              name: 'http_retry',
                              parameters: {
                                'scope': 'client',
                                'request': p0,
                                'response': p1,
                                'count': retryCount,
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: const AuthWidget(),
            ),
          ),
        ),
      );
}

class ClientScopeClient extends ErrorThrowingClient {
  ClientScopeClient(super.origin);
}
