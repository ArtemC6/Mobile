import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/audio/audio_io.dart';
import 'package:voccent/audio/audio_metadata.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_state.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/cubit/models/challenge_accept/challenge_accept_data.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/shared_attempts.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/web_socket/web_socket.dart';

class ShareAttemptCubit extends Cubit<ShareAttemptState> {
  ShareAttemptCubit(
    this._client,
    this._userToken,
    this._socket,
    this._challengeId,
    this._userId,
  ) : super(
          ShareAttemptState(
            noShare: true,
            shareWithAuthor: false,
            shareWithAllUsers: false,
            includeVoice: false,
            isProgress: true,
          ),
        ) {
    _socketSubscription = _socket.dataStream.listen(
      _onWebSocketDataSync,
      onDone: _onWebSocketDone,
      onError: _onWebSocketError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onSocketEventsDone,
    );
  }

  final Client _client;
  final String _challengeId;
  final String? _userId;
  final UserToken _userToken;
  final _lock = Lock();
  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;

  final _ioAudio = AudioIo();

  Future<void> init() async {
    await _initWs();
    await dataUpdate();
    emit(state.copyWith(testPlayerStatus: PlayerStatus.ready));
  }

  Future<void> dataUpdate() async {
    emit(
      state.copyWith(
        isProgress: false,
      ),
    );
    await _fetchChallengeAcceptData();
    await fetchSharedAttemptsList();
  }

  Future<Map<String, dynamic>> _fetchChallengeAcceptDataMap() async {
    final response = await _client.get(
      Uri.parse(
        '/api/v1/challenge_accept/$_challengeId',
      ),
    );

    if (!response.hasMapData()) {
      emit(
        state.copyWith(isProgress: false),
      );
      return <String, dynamic>{};
    }

    return response.mapData();
  }

  Future<void> _fetchChallengeAcceptData() async {
    final dataMap = await _fetchChallengeAcceptDataMap();
    final data = ChallengeAcceptData.fromJson(dataMap);

    if (data.shareAll != null) {
      var includeVoice = false;

      if (data.shareAll!.contains('voice')) {
        includeVoice = true;
      }

      emit(
        state.copyWith(
          noShare: false,
          shareWithAuthor: false,
          shareWithAllUsers: true,
          includeVoice: includeVoice,
        ),
      );
    }
    if (data.shareAuthor != null) {
      var includeVoice = false;

      if (data.shareAuthor!.contains('voice')) {
        includeVoice = true;
      }
      emit(
        state.copyWith(
          noShare: false,
          shareWithAuthor: true,
          shareWithAllUsers: false,
          includeVoice: includeVoice,
        ),
      );
    }
  }

  Future<String?> _fetchChallengeAcceptId() async {
    final dataMap = await _fetchChallengeAcceptDataMap();
    final data = ChallengeAcceptData.fromJson(dataMap);
    return data.id;
  }

  Future<void> fetchSharedAttemptsList() async {
    final uriString = 'api/v1/challenge_attempts/shared/$_challengeId';

    final uri = Uri.parse(uriString);
    final response = await _client.get(uri).listData();
    final items = response
        .map((e) => SharedAttempt.fromJson(e as Map<String, dynamic>))
        .toList();
    emit(
      state.copyWith(sharedAttempts: items),
    );
  }

  Future<void> fetchMyAttemptData(String? attemptId) async {
    final response = await _client
        .get(
          Uri.parse(
            'api/v1/challenge_attempt/shared/$attemptId',
          ),
        )
        .mapData();

    final attempt = SharedAttempt.fromJson(response);

    emit(state.copyWith(sharedAttempt: attempt));

    final challengeResponse = await _client
        .get(
          Uri.parse(
            '/api/v1/challenge/$_challengeId',
          ),
        )
        .mapData();

    final challenge = Challenge.fromJson(challengeResponse);

    emit(state.copyWith(challenge: challenge));
  }

  Future<void> _fetchAudiosampleTst(String? audioSampleTstId) async {
    if (audioSampleTstId == null) return;

    await _ioAudio.init();

    final tstBlob = await _client.get(
      Uri.parse('/api/v1/asset/object/audiosample/tst/$audioSampleTstId'),
    );
    final testBlob = tstBlob.bodyBytes;
    await _ioAudio.rewriteTestWithOggBlob(
      testBlob,
      metadata: AudioMetadata.fromJson(tstBlob.headers['audio-meta']),
    );
  }

  Future<void> playTest(String? audioSampleTstId) async {
    await _stopTestPlayer();
    if (state.testPlayerStatus != PlayerStatus.ready) {
      return;
    }
    if (audioSampleTstId == null) return;
    emit(
      state.copyWith(
        playingAudioSampleTstId: audioSampleTstId,
      ),
    );
    await _fetchAudiosampleTst(audioSampleTstId);
    await _ioAudio.startTestPlayer(
      whenFinished: () => emit(
        state.copyWith(
          testPlayerStatus: PlayerStatus.ready,
          playingAudioSampleTstId: '',
        ),
      ),
    );
    emit(state.copyWith(testPlayerStatus: PlayerStatus.playing));
  }

  Future<void> _stopTestPlayer() async {
    await _ioAudio.stopTestPlayer();
    emit(state.copyWith(testPlayerStatus: PlayerStatus.ready));
  }

  void toggleNoShare() {
    emit(
      state.copyWith(
        noShare: true,
        shareWithAuthor: false,
        shareWithAllUsers: false,
        includeVoice: false,
      ),
    );

    _postRequest();
  }

  void toggleShareWithAuthor() {
    emit(
      state.copyWith(
        noShare: false,
        shareWithAuthor: true,
        shareWithAllUsers: false,
        includeVoice: state.includeVoice,
      ),
    );

    _postRequest();
  }

  void toggleShareWithAllUsers() {
    emit(
      state.copyWith(
        noShare: false,
        shareWithAuthor: false,
        shareWithAllUsers: true,
        includeVoice: state.includeVoice,
      ),
    );

    _postRequest();
  }

  void toggleIncludeVoice() {
    emit(
      state.copyWith(
        noShare: state.noShare,
        shareWithAuthor: state.shareWithAuthor,
        shareWithAllUsers: state.shareWithAllUsers,
        includeVoice: !state.includeVoice,
      ),
    );

    _postRequest();
  }

  Future<void> _postRequest() async {
    final challengeAcceptId = await _fetchChallengeAcceptId();

    int shareValue;
    if (state.shareWithAllUsers == true) {
      shareValue = 1;
    } else if (state.shareWithAuthor == true) {
      shareValue = 2;
    } else {
      shareValue = 0;
    }

    final bodyMap = {
      'ID': challengeAcceptId,
      'Share': shareValue,
      'Voice': state.includeVoice,
    };

    const uri = '/api/v1/challenge_accept/share';
    await _client.post(
      Uri.parse(uri),
      body: jsonEncode(bodyMap),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  }

// WS
  Future<void> _initWs() async {
    emit(
      state.copyWith(
        challengeUserTicketToken: await _generateTicketToken(
          'challenge_attempt',
          _challengeId,
        ),
      ),
    );
  }

  Future<void> _onWebSocketDataSync(Map<String, dynamic> frame) async {
    await _lock.synchronized(() => _onWebSocketData(frame));
  }

  Future<void> _onWebSocketData(Map<String, dynamic> frame) async {
    developer.log(frame.toString(), name: 'ShareAttempt');

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
      throw Exception('f945a27a: Unexpected server response');
    }

    final shareAll = data['ShareAll'] as List<dynamic>?;
    final shareAuthor = data['ShareAuthor'] as List<dynamic>?;

    final createdby = data['createdby'];

    if (frame['Ticket'] == 'challenge_attempt' && frame['Type'] == 'message') {
      if (createdby == _userId) {
        if (shareAll == null && shareAuthor == null) {
          const includeVoice = false;
          emit(
            state.copyWith(
              noShare: true,
              shareWithAuthor: false,
              shareWithAllUsers: false,
              includeVoice: includeVoice,
            ),
          );
        }

        if (shareAuthor != null) {
          final includeVoice = shareAuthor.contains('voice');
          emit(
            state.copyWith(
              noShare: false,
              shareWithAuthor: true,
              shareWithAllUsers: false,
              includeVoice: includeVoice,
            ),
          );
        }

        if (shareAll != null) {
          final includeVoice = shareAll.contains('voice');
          emit(
            state.copyWith(
              noShare: false,
              shareWithAuthor: false,
              shareWithAllUsers: true,
              includeVoice: includeVoice,
            ),
          );
        }
      }

      await fetchSharedAttemptsList();
    }
  }

  Future<String> _generateTicketToken(
    String ticket,
    String id,
  ) async {
    final map = await _socket.request(
      {
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      id,
    );

    if (map['Type'] == 'error') {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _onWebSocketDone() {
    _socketSubscription.cancel();
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            challengeUserTicketToken: await _generateTicketToken(
              'challenge_attempt',
              _challengeId,
            ),
          ),
        );
      case EventType.disconnected:
        break;
    }
  }

  void _onSocketEventsDone() {
    _socketEventsSubscription.cancel();
  }

  Future<void> _onWebSocketError(dynamic error) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    }

    developer.log(error.toString(), name: 'ShareAttempt');
  }

  @override
  Future<void> close() async {
    if (state.challengeUserTicketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.challengeUserTicketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }
    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    await _ioAudio.close();
    return super.close();
  }
}
