import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit(this._client, this._socket) : super(const AboutState()) {
    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onEventsDone,
    );
  }

  late StreamSubscription<EventType> _socketEventsSubscription;
  final Client _client;
  final WebSocket _socket;

  @override
  void emit(AboutState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  void _onSocketEvent(EventType evt) {
    emit(
      state.copyWith(
        storiesStatus: evt == EventType.connected,
        chatStatus: evt == EventType.connected,
        challengesStatus: evt == EventType.connected,
      ),
    );
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  @override
  Future<void> close() async {
    await _socketEventsSubscription.cancel();
    return super.close();
  }

  Future<void> init() async {
    _initPushy().ignore();
    _initPackageInfo().ignore();
    _initApiInfo().ignore();

    emit(
      state.copyWith(
        storiesStatus: _socket.currentState == EventType.connected,
        chatStatus: _socket.currentState == EventType.connected,
        challengesStatus: _socket.currentState == EventType.connected,
      ),
    );
  }

  Future<void> _initPushy() async {
    if (kIsWeb) {
      return;
    }

    if (await Permission.notification.isDenied) {
      emit(state.copyWith(pushyCreds: 'Denied'));
      return;
    }

    final pushy = await Pushy.register();

    emit(state.copyWith(pushyCreds: pushy));
  }

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    emit(
      state.copyWith(
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version + (kDebugMode ? 'DEBUG MODE' : ''),
        buildNumber: packageInfo.buildNumber,
      ),
    );
  }

  Future<void> _initApiInfo() async {
    await _client
        .get(Uri.parse('/api/v1/version'))
        .timeout(
          const Duration(seconds: 5),
        )
        .then((value) {
      final isOperational =
          (json.decode(value.body) as Map<String, dynamic>)['errcode'] ==
              'ret-0';

      emit(
        state.copyWith(
          challengesStatus: isOperational,
          playlistsStatus: isOperational,
        ),
      );
    }).catchError(
      (Object o) {
        emit(
          state.copyWith(
            challengesStatus: false,
            playlistsStatus: false,
          ),
        );
      },
    );
  }
}
