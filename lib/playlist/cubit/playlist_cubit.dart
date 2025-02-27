import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:voccent/audio/audio_controls.dart';
import 'package:voccent/audio/audio_io.dart';
import 'package:voccent/audio/audio_metadata.dart';
import 'package:voccent/challenge/cubit/models/audiosample/audiosample.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/challenge/cubit/models/my_attempt/my_attempt.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/server_exception.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/playlist/cubit/models/playlist.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit(
    this._client,
    this._controls,
    this._updaterService,
    this._sharedPreferences,
  ) : super(const PlaylistState());

  final Client _client;
  final _ioAudio = AudioIo();
  final AudioControls _controls;

  late StreamSubscription<void> _playSub;
  late StreamSubscription<void> _pauseSub;
  late StreamSubscription<void> _skipToPreviousSub;
  late StreamSubscription<void> _skipToNextSub;

  late Soundpool _pool;
  late int _dinkSound;

  bool _stopRecordRequested = false;
  bool _didUsePlaybackButtons = false;

  final UpdaterService _updaterService;
  final SharedPreferences _sharedPreferences;

  @override
  void emit(PlaylistState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  Future<void> loadPlaylist(String id) async {
    try {
      await _ioAudio.init();

      _playSub = _controls.playEventStream
          .listen((event) async => playAndPauseButton());
      _pauseSub = _controls.pauseEventStream
          .listen((event) async => playAndPauseButton());
      _skipToNextSub =
          _controls.skipToNextEventStream.listen((event) async => playNext());
      _skipToPreviousSub = _controls.skipToPreviousEventStream
          .listen((event) async => playPrev());

      _controls.playbackState.add(
        PlaybackState(
          controls: [],
          systemActions: {},
          processingState: AudioProcessingState.loading,
        ),
      );

      _pool = Soundpool.fromOptions();
      _dinkSound =
          await rootBundle.load('assets/audio/plink.mp3').then(_pool.load);
      await _pool.setVolume(soundId: _dinkSound, volume: 0.1);

      emit(
        state.copyWith(
          status: PlaylistStatus.loadingPlaylist,
        ),
      );

      final response = await _client
          .get(
            Uri.parse(
              '/api/v1/playlist/$id',
            ),
          )
          .mapData();

      final playlist = Playlist.fromJson(response);
      _setRecentPlaylist(playlist: playlist);

      unawaited(
        FirebaseAnalytics.instance.logSelectContent(
          contentType: 'playlist',
          itemId: playlist.id,
        ),
      );

      emit(
        state.copyWith(
          playlist: playlist,
          status: PlaylistStatus.readyPlaylist,
        ),
      );

      if (playlist.items?.isNotEmpty ?? false) {
        await _loadChallenge(playlist.items!.first.challenge!);
      }
    } catch (e) {
      _controls.playbackState.add(
        PlaybackState(
          controls: [],
          systemActions: {},
          processingState: AudioProcessingState.error,
        ),
      );

      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlaylistStatus.failed,
        ),
      );

      rethrow;
    }
  }

  void _setRecentPlaylist({
    required Playlist playlist,
  }) {
    final recentPlaylistsJson = _sharedPreferences.getString('recent_playlist');
    var recentPlaylists = <Playlist>[];
    if (recentPlaylistsJson != null) {
      final decodedList = json.decode(recentPlaylistsJson) as List<dynamic>;
      recentPlaylists = decodedList
          .map((item) => Playlist.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final newPlaylist = playlist;
    recentPlaylists
      ..removeWhere((existingPlaylist) => existingPlaylist.id == playlist.id)
      ..insert(0, newPlaylist);
    final updatedPlaylistsJson = json
        .encode(recentPlaylists.map((playlist) => playlist.toJson()).toList());
    _sharedPreferences.setString('recent_playlist', updatedPlaylistsJson);
    _updaterService.addItemToRecent(null);
  }

  Future<void> _loadChallenge(Challenge challenge) async {
    _controls.playbackState.add(
      PlaybackState(
        controls: [],
        systemActions: {},
        processingState: AudioProcessingState.loading,
      ),
    );

    emit(
      state.copyWith(
        status: PlaylistStatus.loadingChallenge,
      ),
    );

    final Audiosample audiosample;

    try {
      audiosample = Audiosample.fromJson(
        await _client
            .get(
              Uri.parse(
                '/api/v1/audiosample/${challenge.audioSampleRefID}',
              ),
            )
            .mapData(),
      );

      final response = await _client.get(
        Uri.parse(
          '/api/v1/asset/object/audiosample/ref/${challenge.audioSampleRefID}',
        ),
      );

      final blob = response.bodyBytes;

      await _ioAudio.stopRefPlayer();
      await _ioAudio.rewriteRefWithOggBlob(
        blob,
        metadata: AudioMetadata.fromJson(response.headers['audio-meta']),
      );

      _controls.mediaItem.add(
        MediaItem(
          id: challenge.id,
          title: challenge.name,
        ),
      );

      _controls.playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: {
            MediaAction.skipToPrevious,
            MediaAction.play,
            MediaAction.skipToNext,
          },
          processingState: AudioProcessingState.ready,
        ),
      );

      emit(
        state.copyWith(
          refDuration: await _ioAudio.refDuration() + recordingOvertime,
        ),
      );
    } catch (e) {
      _controls.playbackState.add(
        PlaybackState(
          controls: [],
          systemActions: {},
          processingState: AudioProcessingState.error,
        ),
      );

      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlaylistStatus.failed,
        ),
      );

      rethrow;
    }

    emit(
      state.copyWith(
        audiosample: audiosample,
        status: PlaylistStatus.readyChallenge,
      ),
    );

    if (state.isAutoplay) {
      await _startRef();
    }
  }

  Future<void> _startRef() async {
    _upviewCurrentChallenge();
    emit(state.copyWith(isPlaying: true));
    var onFinish = () => emit(state.copyWith(status: PlaylistStatus.finished));

    final mode =
        state.playlist!.items![state.selectedChallengeIndex].challenge!.mode;

    if (mode == 'interactive' || mode == '') {
      onFinish = () async => _record();
    } else {
      onFinish = () async => playNext();
    }

    await _ioAudio.startRefPlayer(whenFinished: onFinish);

    emit(state.copyWith(status: PlaylistStatus.playingRef));

    _controls.playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.skipToPrevious,
          MediaAction.pause,
          MediaAction.skipToNext,
        },
        processingState: AudioProcessingState.ready,
        playing: true,
      ),
    );
  }

  Future<void> _stopRef() async {
    await _ioAudio.stopRefPlayer();

    emit(state.copyWith(status: PlaylistStatus.readyChallenge));

    _controls.playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.skipToPrevious,
          MediaAction.play,
          MediaAction.skipToNext,
        },
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  void _upviewCurrentChallenge() {
    final challenge =
        state.playlist!.items![state.selectedChallengeIndex].challenge!;

    if (!challenge.isViewed) {
      _client
          .post(Uri.parse('/api/v1/challenge/upview/${challenge.id}'))
          .ignore();

      emit(
        state.copyWith(
          playlist: state.playlist!
              .copyWithViewedChallenge(state.selectedChallengeIndex),
        ),
      );
    }
  }

  Future<void> _record() async {
    _controls.playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.skipToPrevious,
          MediaAction.pause,
          MediaAction.skipToNext,
        },
        processingState: AudioProcessingState.ready,
      ),
    );

    emit(state.copyWith(status: PlaylistStatus.startingRecord));

    try {
      await _ioAudio.startRecorder();

      emit(state.copyWith(recordingAllowed: true));
    } on RecordingPermissionException catch (e) {
      emit(
        state.copyWith(
          recordingAllowed: false,
          status: PlaylistStatus.failed,
          errorMessage: e.message,
        ),
      );

      rethrow;
    }
    if (_stopRecordRequested) {
      _stopRecordRequested = false;
      await _ioAudio.stopRecorder();
      return;
    }
    emit(
      state.copyWith(
        status: PlaylistStatus.recording,
        recordCount: state.recordCount + 1,
      ),
    );

    final recordCountCopy = state.recordCount;
    final duration = await _ioAudio.refDuration() + recordingOvertime;

    await Future<void>.delayed(
      duration,
      () async {
        if (state.recordCount == recordCountCopy &&
            state.status == PlaylistStatus.recording) {
          await _stopRecorderWithAnalysis();
        }
      },
    );
  }

  Future<void> _stopRecorderWithAnalysis() async {
    if (state.status == PlaylistStatus.analyzing ||
        state.status == PlaylistStatus.failed) return;

    emit(
      state.copyWith(
        status: PlaylistStatus.analyzing,
      ),
    );

    await _ioAudio.stopRecorder();

    _controls.playbackState.add(
      PlaybackState(
        controls: [],
        systemActions: {},
        processingState: AudioProcessingState.loading,
      ),
    );

    try {
      final audiosampleResponse = await _client.post(
        Uri.parse('/api/v1/audiosample'),
        body: '{"Label":"LABEL: 6999f4fe", '
            '"IsRef":false,"IsPublic":true,"TypeID":"tst"}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final audiosample = audiosampleResponse.mapData();
      final uploadAsset = MultipartRequest('post', Uri.parse('/api/v1/asset'));

      uploadAsset.fields.addAll({
        'object_id': audiosample['ID'] as String,
        'file_type': 'audiosample',
        'meta': '',
      });

      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          await _ioAudio.testOggBlob(),
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      final audioSampleRefId = state.playlist!
          .items![state.selectedChallengeIndex].challenge!.audioSampleRefID;

      final fingerprintResponse = await _client.post(
        Uri.parse('/api/v1/audiosample/compare/fingerprint'),
        body: json.encode({
          'AudioSampleRefID': audioSampleRefId,
          'AudioSampleTstID': audiosample['ID'],
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final emotionResponse = await _client.post(
        Uri.parse('/api/v1/audiosample/compare/emotion'),
        body: json.encode({
          'AudioSampleRefID': audioSampleRefId,
          'AudioSampleTstID': audiosample['ID'],
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final result = [
        fingerprintResponse.mapData(),
        emotionResponse.mapData(),
      ];

      final fingers = Fingerprint.fromJson(result[0]);

      final emotionData = result[1];

      final hglBodyValue = result[0]['HglBody'] as String;
      final audioBytes = base64Decode(hglBodyValue);
      final audioData = Uint8List.fromList(audioBytes);

      await _ioAudio.rewriteHighlightWithOggBlob(audioData);

      final myAttempt = MyAttempt.fromJson(
        await _client.post(
          Uri.parse(
            '/api/v1/challenge_attempt/${state.playlist!.items![state.selectedChallengeIndex].challenge!.id}',
          ),
          body: json.encode({
            'PronunciationCompResultID': fingers.pronunciationCompResultId,
            'PitchCompResultID': fingers.pitchCompResultId,
            'EnergyCompResultID': fingers.energyCompResultId,
            'BreathCompResultID': fingers.breathCompResultId,
            'EmotionCompResultID': emotionData['EmotionID'].toString(),
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ).mapData(),
      );

      _controls.playbackState.add(
        PlaybackState(
          controls: [MediaControl.skipToPrevious, MediaControl.skipToNext],
          systemActions: {MediaAction.skipToPrevious, MediaAction.skipToNext},
          processingState: AudioProcessingState.completed,
        ),
      );

      emit(
        state.copyWith(
          status: PlaylistStatus.finished,
          fingerprint: fingers,
          emotion: EmotionData.fromJson(
            emotionData['EmotionData'] as Map<String, dynamic>,
          ),
          myAttempts: List<MyAttempt>.from(state.myAttempts)..add(myAttempt),
        ),
      );

      await _pool.play(_dinkSound, rate: myAttempt.totalPercent / 100.0 + 0.5);
      if (state.isAutoplay) {
        if (myAttempt.totalPercent < 50) {
          await _ioAudio.startHighlightPlayer(
            whenFinished: _startRef,
          );
        } else {
          final n = state.selectedChallengeIndex;
          await Future<void>.delayed(
            const Duration(milliseconds: 3000),
            () async {
              if (n == state.selectedChallengeIndex) await playNext();
            },
          );
        }
      }
      _updaterService.fetchDailyProgress(null);
    } on ServerException catch (e) {
      _controls.playbackState.add(
        PlaybackState(
          controls: [MediaControl.play],
          systemActions: {MediaAction.play},
          processingState: AudioProcessingState.error,
        ),
      );

      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlaylistStatus.analyzationFailed,
        ),
      );
      if (state.isAutoplay) {
        await _startRef();
      }
    }
  }

  Future<void> _stopRecord() async {
    if (state.status == PlaylistStatus.startingRecord) {
      _stopRecordRequested = true;
    } else {
      await _ioAudio.stopRecorder();
    }

    emit(state.copyWith(status: PlaylistStatus.readyChallenge));

    _controls.playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.skipToPrevious,
          MediaAction.play,
          MediaAction.skipToNext,
        },
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  Future<void> playPrev() async {
    _didUsePlaybackButtons = true;
    if (state.status == PlaylistStatus.playingRef) {
      await _stopRef();
    }
    if (state.status == PlaylistStatus.startingRecord ||
        state.status == PlaylistStatus.recording) {
      await _stopRecord();
    }
    var index = state.selectedChallengeIndex;

    if (index > 0) {
      index -= 1;
    } else {
      index = state.playlist!.items!.length - 1;
    }

    emit(
      state.copyWith(
        selectedChallengeIndex: index,
        status: PlaylistStatus.initial,
      ),
    );

    final challenge =
        await _loadChallenge(state.playlist!.items![index].challenge!);
    return challenge;
  }

  Future<void> playNext() async {
    _didUsePlaybackButtons = true;
    if (state.status == PlaylistStatus.playingRef) {
      await _stopRef();
    }
    if (state.status == PlaylistStatus.startingRecord ||
        state.status == PlaylistStatus.recording) {
      await _stopRecord();
    }
    var index = state.selectedChallengeIndex;

    if (index < state.playlist!.items!.length - 1) {
      index += 1;
    } else {
      index = 0;
    }

    emit(
      state.copyWith(
        selectedChallengeIndex: index,
        status: PlaylistStatus.initial,
        nullChallengeAttempt: true,
      ),
    );
    final challenge =
        await _loadChallenge(state.playlist!.items![index].challenge!);
    return challenge;
  }

  Future<void> swipeChallenge(int index) async {
    if (state.status == PlaylistStatus.playingRef) {
      await _stopRef();
    }
    if (state.status == PlaylistStatus.startingRecord ||
        state.status == PlaylistStatus.recording) {
      await _stopRecord();
    }

    emit(
      state.copyWith(
        selectedChallengeIndex: index,
        nullChallengeAttempt: true,
      ),
    );
    if (_didUsePlaybackButtons == false) {
      final challenge =
          await _loadChallenge(state.playlist!.items![index].challenge!);
      return challenge;
    }
    _didUsePlaybackButtons = false;
  }

  Future<void> playAndPauseButton() async {
    if (state.status == PlaylistStatus.readyChallenge) {
      emit(state.copyWith(isAutoplay: true));
      await _startRef();
    } else if (state.status == PlaylistStatus.playingRef) {
      emit(state.copyWith(isPlaying: false));
      await _stopRef();
    } else if (state.status == PlaylistStatus.startingRecord ||
        state.status == PlaylistStatus.recording) {
      await _stopRecord();
      emit(state.copyWith(isPlaying: false));
    }
  }

  @override
  Future<void> close() async {
    await _pool.release();
    if (state.status == PlaylistStatus.playingRef) {
      await _stopRef();
    }
    if (state.status == PlaylistStatus.startingRecord ||
        state.status == PlaylistStatus.recording) {
      await _stopRecord();
    }

    await _ioAudio.close();

    {
      await _playSub.cancel();
      await _pauseSub.cancel();
      await _skipToPreviousSub.cancel();
      await _skipToNextSub.cancel();
      await _controls.stop();
    }

    _controls.playbackState.add(
      PlaybackState(
        controls: [],
        systemActions: {},
      ),
    );

    return super.close();
  }
}
