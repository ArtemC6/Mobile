import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:voccent/audio/stream_recorder.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/streamotion/cubit/models/streamotion_model.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'streamotion_state.dart';

final Map<String, StreamotionCompareModel> secondaryEmotions = {
  'Joy': const StreamotionCompareModel(
    valence: 0.9,
    arousal: 0.9,
  ),
  'Love': const StreamotionCompareModel(
    valence: 0.7,
    arousal: 0.4,
  ),
  'Amazement': const StreamotionCompareModel(
    valence: 0.9,
    arousal: 0.7,
  ),
  'Awe': const StreamotionCompareModel(
    valence: 0.2,
    arousal: 0.8,
  ),
  'Serenity': const StreamotionCompareModel(
    valence: 0.5,
    arousal: -0.2,
  ),
  'Optimism': const StreamotionCompareModel(
    valence: 0.4,
    arousal: 0.3,
  ),
  'Trust': const StreamotionCompareModel(
    valence: 0.4,
    arousal: 0.1,
  ),
  'Interest': const StreamotionCompareModel(
    valence: 0.6,
    arousal: 0.4,
  ),
  'Anger': const StreamotionCompareModel(
    valence: -0.9,
    arousal: 0.7,
  ),
  'Fear': const StreamotionCompareModel(
    valence: -0.7,
    arousal: 0.5,
  ),
  'Disgust': const StreamotionCompareModel(
    valence: -0.7,
    arousal: 0.2,
  ),
  'Contempt': const StreamotionCompareModel(
    valence: 0.6,
    arousal: -0.6,
  ),
  'Annoyance': const StreamotionCompareModel(
    valence: -0.5,
    arousal: 0.4,
  ),
  'Sadness': const StreamotionCompareModel(
    valence: -0.7,
    arousal: -0.5,
  ),
  // HERE
  'Excitement': const StreamotionCompareModel(
    valence: 0.5,
    arousal: 0.9,
  ),
  'Tension': const StreamotionCompareModel(
    arousal: 0.9,
  ),
  'Contentment': const StreamotionCompareModel(
    valence: 0.8,
    arousal: 0.6,
  ),
  'Curiosity': const StreamotionCompareModel(
    valence: 0.4,
    arousal: 0.5,
  ),
  'Boredom': const StreamotionCompareModel(
    valence: -0.2,
    arousal: -0.4,
  ),
  'Frustration': const StreamotionCompareModel(
    valence: -0.5,
    arousal: 0.5,
  ),
  'Calmness': const StreamotionCompareModel(
    valence: 0.6,
    arousal: 0.2,
  ),
  'Relaxation': const StreamotionCompareModel(
    valence: 0.3,
    arousal: 0.1,
  ),
  'Despair': const StreamotionCompareModel(
    valence: -0.8,
    arousal: -0.3,
  ),
  'Neutral': const StreamotionCompareModel(),
  'Balanced': const StreamotionCompareModel(
    arousal: -0.2,
  ),
};

final transitions = <(String, String, String), String>{
  ('Joy', 'Frustration', 'Annoyance'): 'Jealousy',
  ('Curiosity', 'Sadness', 'Fear'): 'Guilt',
  ('Joy', 'Frustration', 'Despair'): 'Shame',
  ('Joy', 'Contentment', 'Calmness'): 'Pride',
  ('Curiosity', 'Annoyance', 'Fear'): 'Envy',
  ('Joy', 'Curiosity', 'Sadness'): 'Disappointment',
  ('Curiosity', 'Relaxation', 'Calmness'): 'Hope',
  ('Fear', 'Sadness', 'Contentment'): 'Relief',
  ('Tension', 'Calmness', 'Joy'): 'Gratitude',
  ('Annoyance', 'Frustration', 'Sadness'): 'Contempt',
  ('Annoyance', 'Anger', 'Despair'): 'Resentment',
  ('Curiosity', 'Relaxation', 'Joy'): 'Optimism',
  ('Tension', 'Sadness', 'Despair'): 'Pessimism',
  ('Joy', 'Contentment', 'Joy'): 'Euphoria',
  ('Frustration', 'Sadness', 'Despair'): 'Despair',
  // Block 1:
  ('Joy', 'Trust', 'Love'): 'Affection',
  ('Fear', 'Annoyance', 'Anger'): 'Hostility',
  ('Contentment', 'Serenity', 'Relaxation'): 'Peacefulness',
  ('Excitement', 'Joy', 'Amazement'): 'Thrill',
  ('Optimism', 'Hope', 'Curiosity'): 'Inspiration',
  ('Sadness', 'Despair', 'Disgust'): 'Repulsion',
  ('Tension', 'Excitement', 'Fear'): 'Anticipation',
  ('Amazement', 'Awe', 'Curiosity'): 'Wonder',
  ('Interest', 'Optimism', 'Trust'): 'Confidence',
  ('Sadness', 'Boredom', 'Neutral'): 'Apathy',
  ('Frustration', 'Anger', 'Contempt'): 'Scorn',
  ('Calmness', 'Serenity', 'Optimism'): 'Zen',
  ('Awe', 'Fear', 'Amazement'): 'Shock',
  ('Disgust', 'Anger', 'Contempt'): 'Revulsion',
  ('Curiosity', 'Interest', 'Optimism'): 'Intrigue',
  ('Love', 'Trust', 'Contentment'): 'Security',
  // Block 2:
  ('Fear', 'Trust', 'Interest'): 'Caution',
  ('Excitement', 'Amazement', 'Love'): 'Adoration',
  ('Despair', 'Sadness', 'Anger'): 'Melancholy',
  ('Awe', 'Interest', 'Curiosity'): 'Fascination',
  ('Tension', 'Optimism', 'Excitement'): 'Eagerness',
  ('Relaxation', 'Contentment', 'Trust'): 'Complacency',
  ('Amazement', 'Excitement', 'Tension'): 'Astonishment',
  ('Disgust', 'Contempt', 'Annoyance'): 'Irritation',
  ('Balanced', 'Neutral', 'Boredom'): 'Numbness',
  ('Optimism', 'Contentment', 'Love'): 'Warmth',
  ('Serenity', 'Calmness', 'Relaxation'): 'Tranquility',
  ('Interest', 'Curiosity', 'Amazement'): 'Marvel',
  ('Fear', 'Annoyance', 'Frustration'): 'Anxiety',
  ('Excitement', 'Joy', 'Trust'): 'Glee',
  ('Serenity', 'Trust', 'Love'): 'Devotion',
  ('Anger', 'Frustration', 'Tension'): 'Irritability',
  // Block 3:
  ('Interest', 'Sadness', 'Calmness'): 'Reflectiveness',
  ('Sadness', 'Calmness', 'Sadness'): 'Melancholy',
  ('Calmness', 'Sadness', 'Love'): 'Solitude',
  ('Sadness', 'Love', 'Optimism'): 'Longing',
  ('Love', 'Optimism', 'Curiosity'): 'Infatuation',
  ('Optimism', 'Curiosity', 'Boredom'): 'Apathy',
  ('Curiosity', 'Boredom', 'Contempt'): 'Skepticism',
  ('Boredom', 'Contempt', 'Serenity'): 'Indolence',
  ('Contempt', 'Serenity', 'Neutral'): 'Detachment',
  ('Serenity', 'Neutral', 'Contempt'): 'Aloofness',
  ('Neutral', 'Contempt', 'Neutral'): 'Disinterest',
  ('Contempt', 'Neutral', 'Love'): 'Ambivalence',
  ('Neutral', 'Love', 'Neutral'): 'Neutrality',
  ('Love', 'Neutral', 'Contentment'): 'Satisfaction',
  ('Neutral', 'Contentment', 'Relaxation'): 'Lethargy',
  ('Contentment', 'Relaxation', 'Love'): 'Bliss',
  ('Relaxation', 'Love', 'Annoyance'): 'Restlessness',
  ('Love', 'Annoyance', 'Tension'): 'Conflicted',
  ('Annoyance', 'Tension', 'Love'): 'Fickleness',
  ('Tension', 'Love', 'Trust'): 'Uncertainty',
  ('Love', 'Trust', 'Contempt'): 'Insecurity',
  ('Trust', 'Contempt', 'Relaxation'): 'Doubt',
  ('Contempt', 'Relaxation', 'Sadness'): 'Pity',
  ('Relaxation', 'Sadness', 'Disgust'): 'Revulsion',
  ('Love', 'Amazement', 'Neutral'): 'Mystification',
  ('Amazement', 'Neutral', 'Amazement'): 'Bewilderment',
  ('Neutral', 'Amazement', 'Neutral'): 'Unimpressed',
  ('Amazement', 'Neutral', 'Trust'): 'Intrigue',
  ('Neutral', 'Trust', 'Contentment'): 'Resignation',
  ('Trust', 'Contentment', 'Neutral'): 'Complacency',
  ('Contentment', 'Neutral', 'Curiosity'): 'Passivity',
  ('Neutral', 'Curiosity', 'Neutral'): 'Nonchalance',
  ('Curiosity', 'Neutral', 'Frustration'): 'Impatience',
  ('Neutral', 'Frustration', 'Neutral'): 'Listlessness',
  ('Frustration', 'Neutral', 'Tension'): 'Agitation',
  ('Neutral', 'Tension', 'Disgust'): 'Irritation',
  ('Tension', 'Disgust', 'Despair'): 'Nihilism',
  ('Disgust', 'Despair', 'Contempt'): 'Cynicism',
  ('Despair', 'Contempt', 'Annoyance'): 'Misery',
  ('Contempt', 'Annoyance', 'Love'): 'Spite',
  ('Annoyance', 'Love', 'Calmness'): 'Inner Conflict',
  ('Love', 'Calmness', 'Awe'): 'Adoration',
  ('Calmness', 'Awe', 'Anger'): 'Veneration',
  ('Awe', 'Anger', 'Interest'): 'Fascination',
  ('Anger', 'Interest', 'Curiosity'): 'Inquisitiveness',
  ('Interest', 'Curiosity', 'Disgust'): 'Skepticism',
  ('Curiosity', 'Disgust', 'Neutral'): 'Apathy',
  ('Disgust', 'Neutral', 'Disgust'): 'Antipathy',
  ('Neutral', 'Disgust', 'Neutral'): 'Unconcern',
  ('Disgust', 'Neutral', 'Love'): 'Pity',
  ('Neutral', 'Love', 'Amazement'): 'Bemusement',
  ('Love', 'Amazement', 'Annoyance'): 'Confusion',
  ('Amazement', 'Annoyance', 'Amazement'): 'Perplexity',
  ('Annoyance', 'Amazement', 'Calmness'): 'Wary',
  ('Amazement', 'Calmness', 'Love'): 'Devotion',
  ('Calmness', 'Love', 'Neutral'): 'Unfazed',
  ('Love', 'Neutral', 'Excitement'): 'Fleeting Joy',
  ('Neutral', 'Excitement', 'Frustration'): 'Capriciousness',
  ('Excitement', 'Frustration', 'Love'): 'Tumult',
  ('Frustration', 'Love', 'Amazement'): 'Elation',
  ('Love', 'Amazement', 'Trust'): 'Inspiration',
  ('Amazement', 'Trust', 'Balanced'): 'Openness',
  ('Trust', 'Balanced', 'Love'): 'Affection',
  ('Balanced', 'Love', 'Neutral'): 'Platonic',
  ('Relaxation', 'Love', 'Fear'): 'Apprehension',
  ('Love', 'Fear', 'Balanced'): 'Insecurity',
  ('Fear', 'Balanced', 'Neutral'): 'Aloofness',
  ('Balanced', 'Neutral', 'Amazement'): 'Unruffled',
  ('Neutral', 'Amazement', 'Anger'): 'Irate',
  ('Amazement', 'Anger', 'Trust'): 'Vigilance',
  ('Anger', 'Trust', 'Calmness'): 'Guardedness',
  ('Trust', 'Calmness', 'Frustration'): 'Imperturbability',
  ('Calmness', 'Frustration', 'Neutral'): 'Equanimity',
  ('Neutral', 'Tension', 'Love'): 'Melancholy',
  ('Tension', 'Love', 'Fear'): 'Dread',
  ('Love', 'Fear', 'Amazement'): 'Astonishment',
  ('Fear', 'Amazement', 'Frustration'): 'Anxiety',
  ('Amazement', 'Frustration', 'Tension'): 'Overwhelm',
  ('Frustration', 'Tension', 'Amazement'): 'Stress',
  ('Tension', 'Amazement', 'Love'): 'Rapture',
  ('Amazement', 'Love', 'Disgust'): 'Revulsion',
  ('Love', 'Disgust', 'Trust'): 'Disbelief',
  ('Disgust', 'Trust', 'Relaxation'): 'Skepticism',
  ('Trust', 'Relaxation', 'Contempt'): 'Mildness',
  // WE need to use polygons to avoid so many combinations: https://github.com/voccent/mobile/issues/1291
};

class StreamotionCubit extends Cubit<StreamotionState> {
  StreamotionCubit(
    this._client,
    this._socket,
    this._userToken,
  ) : super(const StreamotionState()) {
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

  @override
  void emit(StreamotionState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  final Client _client;
  final WebSocket _socket;
  final UserToken _userToken;
  final _recorder = StreamRecorder();
  final _operationUuid = const Uuid().v4();

  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  late StreamSubscription<Uint8List> _recorderSubscription;

  int _num = 0;

  Future<void> stopRecorder() async {
    await _recorder.stopRecorder();
    emit(state.copyWith(recorderState: _recorder.recorderStatus));
    await WakelockPlus.disable();
  }

  Future<void> _onData(Map<String, dynamic> frame) async {
    if (frame['Data'] == null) {
      return;
    }

    if (frame['Data'] ==
        "Undefined tickettoken: '${state.streamotionUserTicketToken}'") {
      emit(state.copyWith(nullStreamotionUserTicketToken: true));

      await _generateTicketToken();
    }

    if (frame['Type'] == 'error') {
      // throw ServerException(frame['Data'] as String);
      return;
    }

    Map<String, dynamic> data;

    if (frame['Data'] is Map<String, dynamic>) {
      data = frame['Data'] as Map<String, dynamic>;
    } else if (frame['Data'] is String) {
      data = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
    } else {
      throw Exception('5364ebbe: Unexpected server response');
    }

    if (frame['Ticket'] == 'streamotion_user' && frame['Type'] == 'message') {
      if (data['Operation'] == 'send_file' && data['Object'] != null) {
        developer.log('Result send_file: ${data['Object']}');

        final c = StreamotionCompareModel.fromJson(
          data['Object'] as Map<String, dynamic>,
        );

        List<String>? secondaryEmotions;
        String? verdict;

        final secondaryEmotion = _secondaryEmotion(c);

        if (secondaryEmotion != state.secondaryEmotions.last) {
          secondaryEmotions = <String>[
            ...state.secondaryEmotions.skip(1),
            secondaryEmotion,
          ];

          verdict = transitions[(
                secondaryEmotions[0],
                secondaryEmotions[1],
                secondaryEmotions[2]
              )] ??
              '${secondaryEmotions[0]} '
                  '${secondaryEmotions[1]} '
                  '${secondaryEmotions[2]} ';
        }

        emit(
          state.copyWith(
            secondaryEmotions: secondaryEmotions,
            emotion: c,
            verdict: verdict,
          ),
        );
      }
    }
  }

  void showChart() => emit(state.copyWith(isChartVisible: true));
  void hideChart() => emit(state.copyWith(isChartVisible: false));

  String _secondaryEmotion(StreamotionCompareModel emotion) {
    var secondaryEm = secondaryEmotions.keys.first;
    var closestSecEm = secondaryEmotions.values.first;

    for (final em in secondaryEmotions.entries) {
      if (_distance(emotion, em.value) < _distance(emotion, closestSecEm)) {
        closestSecEm = em.value;
        secondaryEm = em.key;
      }
    }

    return secondaryEm;
  }

  double _distance(StreamotionCompareModel a, StreamotionCompareModel b) =>
      sqrt(pow(a.arousal - b.arousal, 2) + pow(a.valence - b.valence, 2));

  void _sendBlob(Uint8List data) {
    if (_socket.currentState == EventType.connected &&
        data.lengthInBytes >= vadThreshold) {
      developer.log('"Voice" detected and sent', name: 'StreamotionCubit');

      if (state.streamotionUserTicketToken != null) {
        _socket.send(
          <String, dynamic>{
            'Data': <String, dynamic>{
              'Operation': 'send_file',
              'Object': {
                'Data': data,
                'Num': ++_num,
              },
            },
            'TicketToken': state.streamotionUserTicketToken,
            'Type': 'message',
          },
        );
      }
    }
    List<Map<String, double>>? distances;

    if (data.lengthInBytes < vadThreshold) {
      distances = [
        ...state.distances.reversed.take(50).toList().reversed,
        <String, double>{
          'Joy': sqrt(8),
          'Love': sqrt(8),
          'Amazement': sqrt(8),
          'Awe': sqrt(8),
          'Serenity': sqrt(8),
          'Optimism': sqrt(8),
          'Trust': sqrt(8),
          'Interest': sqrt(8),
          'Anger': sqrt(8),
          'Fear': sqrt(8),
          'Disgust': sqrt(8),
          'Contempt': sqrt(8),
          'Annoyance': sqrt(8),
          'Sadness': sqrt(8),
          'Excitement': sqrt(8),
          'Tension': sqrt(8),
          'Contentment': sqrt(8),
          'Curiosity': sqrt(8),
          'Boredom': sqrt(8),
          'Frustration': sqrt(8),
          'Calmness': sqrt(8),
          'Relaxation': sqrt(8),
          'Neutral': sqrt(8),
          'Despair': sqrt(8),
          'Balanced': sqrt(8),
        }
      ];
    } else if (state.emotion != null) {
      distances = [
        ...state.distances.reversed.take(50).toList().reversed,
        _distancesToAnchors(state.emotion!),
      ];
    }

    emit(
      state.copyWith(
        distances: distances,
        blobLength: data.lengthInBytes,
        emotion: data.lengthInBytes < vadThreshold
            ? const StreamotionCompareModel()
            : null,
      ),
    );
  }

  Map<String, double> _distancesToAnchors(StreamotionCompareModel point) {
    final distances = <String, double>{};

    for (final em in secondaryEmotions.entries) {
      distances[em.key] = _distance(point, em.value);
    }

    return distances;
  }

  Future<void> init() async {
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      emit(state.copyWith(isMicGranted: false));
      return;
    }

    emit(state.copyWith(isMicGranted: true));

    final response = await _client.get(Uri.parse('/api/v1/streamotion/config'));

    final data = response.mapData();

    await _recorder.init(
      intervalMs: data['interval'] as int,
      rateMs: data['rate'] as int,
    );

    await _generateTicketToken();
  }

  Future<void> _generateTicketToken() async {
    var i = 0;

    while (true) {
      try {
        emit(
          state.copyWith(
            streamotionUserTicketToken:
                await _generateTicketTokenStreamotionUser('streamotion_user'),
          ),
        );
        break;
      } catch (_) {
        developer.log(
          'Error while generating ticketToken. Retrying...',
          name: 'StreamotionCubit',
        );
        if (++i > 7) {
          rethrow;
        }
      }
    }
  }

  Future<String> _generateTicketTokenStreamotionUser(String ticket) async {
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      _operationUuid,
    );

    if (!map.containsKey('TicketToken')) {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  void _onError(dynamic error) {
    developer.log(error.toString(), name: 'Streamotion_cubit');
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            streamotionUserTicketToken:
                await _generateTicketTokenStreamotionUser(
              'streamotion_user',
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
    if (state.streamotionUserTicketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.streamotionUserTicketToken,
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
