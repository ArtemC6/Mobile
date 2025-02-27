import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/notification/cubit/models/notification/notification.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(
    this._userToken,
    this._socket,
    this._updaterService,
  ) : super(
          const NotificationState(user: User()),
        ) {
    _generateTokenSubscription =
        _updaterService.tokenGenerate.listen(_generateTicketToken);
    _socketSubscription = _socket.dataStream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onEventsDone,
    );
  }
  final UserToken _userToken;
  final WebSocket _socket;
  final UpdaterService _updaterService;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  StreamSubscription<User>? _generateTokenSubscription;

  Future<void> _onData(Map<String, dynamic> frame) async {
    if (frame['Ticket'] == 'system_notification') {
      log(frame.toString(), name: 'Notifications');
      if (frame['Data'] == null) {
        return;
      }

      if (frame['Type'] == 'error') {
        throw Exception(frame['Data'] as String);
      }

      final Map<String, dynamic> data;
      if (frame['Data'] is Map<String, dynamic>) {
        data = frame['Data'] as Map<String, dynamic>;
      } else if (frame['Data'] is String) {
        data = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
      } else {
        throw Exception('err1234: (Notifications) Unexpected server response');
      }
      if (frame['Type'] == 'message') {
        switch (data['Operation'] as String) {
          case 'new_notification':
            final dataObject = data['Object'] as Map<String, dynamic>;
            final notification = NewNotification.fromJson(
              dataObject['ChatMessage'] as Map<String, dynamic>,
            );
            emit(state.copyWith(notification: notification));
        }
      }
    }
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  Future<void> _onError(dynamic error) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    }

    log(error.toString(), name: 'Notifications');
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        await FirebaseCrashlytics.instance
            .log('w2e334er: (Notifications) WS status connected');
        await _generateTicketToken(state.user);
        await FirebaseCrashlytics.instance
            .log('12wwe34e: (Notifications) generated new tokens');
      case EventType.disconnected:
        await FirebaseCrashlytics.instance
            .log('756rtey4: (Notifications) WS status disconnected :(');
    }
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  Future<void> _generateTicketToken(
    User user,
  ) async {
    emit(state.copyWith(user: user));
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      'system_notification',
      user.id ?? '',
    );

    if (map['Type'] == 'error') {
      throw Exception(map['Data']);
    }
    emit(
      state.copyWith(
        systemNotificationTiketToken: map['TicketToken'] as String,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _generateTokenSubscription?.cancel();
    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    return super.close();
  }
}
