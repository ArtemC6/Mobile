import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:voccent/audio/stream_recorder.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/http/visible_to_user_server_exception.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'sound_receirver_mode_state.dart';

class SoundReceiverModeCubit extends Cubit<SoundReceiverModeState> {
  SoundReceiverModeCubit(
    this._client,
    this._socket,
    this._userToken,
    this._sharedPreferences,
  ) : super(const SoundReceiverModeState()) {
    _socketSubscription = _socket.dataStream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onEventsDone,
    );

    _recorderSubscription = _recorder.oggStream.listen(_sendBlob);
  }
  final Client _client;
  final WebSocket _socket;
  final UserToken _userToken;
  final _recorder = StreamRecorder();
  final SharedPreferences _sharedPreferences;

  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  late StreamSubscription<Uint8List> _recorderSubscription;

  int _num = 0;

  Future<void> activate(String code) async {
    if (code.isEmpty) {
      return;
    }
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      emit(state.copyWith(isMicGranted: false));
      return;
    }

    emit(
      state.copyWith(
        isMicGranted: true,
      ),
    );

    try {
      final response =
          await _client.get(Uri.parse('/api/v1/streamotion_stream?code=$code'));

      final data = response.mapData();

      if (state.streamId.isEmpty) {
        await _recorder.init();
      } else {
        await _recorder.startRecorder();
      }
      emit(state.copyWith(streamId: data['ID'] as String));
      await _generateTicketToken(state.streamId);
      emit(state.copyWith(isModeActive: true));
    } catch (e) {
      emit(state.copyWith(isModeActive: false));
      throw VisibleToUserServerException(
        'Unfortunately, this code is incorrect :( Please try another code',
      );
    }
  }

  Future<void> deactivate() async {
    emit(state.copyWith(isModeActive: false));

    await _recorder.stopRecorder();
    if (state.ticketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.ticketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }
  }

  Future<void> _generateTicketToken(String streamId) async {
    emit(
      state.copyWith(
        ticketToken: await _generateTicketTokenUser(streamId),
      ),
    );
  }

  Future<String> _generateTicketTokenUser(String streamId) async {
    var sessionUuid = _sharedPreferences.getString('session_uuid');
    if (sessionUuid == null) {
      sessionUuid = const Uuid().v4();
      await _sharedPreferences.setString('session_uuid', sessionUuid);
    }
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
        'SessionID': sessionUuid,
      },
      'streamotion_stream',
      streamId,
    );

    if (!map.containsKey('TicketToken')) {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _sendBlob(Uint8List data) {
    log(
      '"Voice" detected and sent SoundReceiverMode',
      name: 'SoundReceiverModeCubit',
    );

    if (state.ticketToken != null) {
      _socket.send(
        <String, dynamic>{
          'Data': <String, dynamic>{
            'Operation': 'send_file',
            'Object': {
              'Data': data,
              'Num': ++_num,
            },
          },
          'TicketToken': state.ticketToken,
          'Type': 'message',
        },
      );
    }
  }

  Future<void> _onData(Map<String, dynamic> frame) async {}
  void _onDone() {
    _socketSubscription.cancel();
  }

  void _onError(dynamic error) {
    log(error.toString(), name: 'SoundReceiverModeCubit');
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            ticketToken: await _generateTicketTokenUser(
              state.streamId,
            ),
          ),
        );
      case EventType.disconnected:
        break;
    }
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  @override
  Future<void> close() async {
    if (state.ticketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.ticketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }

    await _recorder.close();
    await _recorderSubscription.cancel();
    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    return super.close();
  }
}
