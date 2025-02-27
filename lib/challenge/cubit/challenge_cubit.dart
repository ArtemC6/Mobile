import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/audio/audio_io.dart';
import 'package:voccent/audio/audio_metadata.dart';
import 'package:voccent/challenge/cubit/models/audiosample/annotation.dart';
import 'package:voccent/challenge/cubit/models/audiosample/audiosample.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/challenge_attempt.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/challenge/cubit/models/my_attempt/my_attempt.dart';
import 'package:voccent/challenge/cubit/models/translate.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit(
    this._client,
    this._homeCubit,
    this._languages,
    this.locale,
    this._updaterService,
    this._sharedPreferences, {
    bool nextBtnVisibility = true,
  }) : super(
          ChallengeState(
            nextBtnVisible: nextBtnVisibility,
          ),
        );

  final Client _client;
  final HomeCubit _homeCubit;

  final _ioAudio = AudioIo();
  final List<Language> _languages;
  late final Soundpool _pool;

  late int _dinkSound;
  late String refAudioFilePath;
  late String testAudioFilePath;
  final Locale locale;
  Timer _timer = Timer(
    const Duration(seconds: 1),
    () {},
  );

  final Lock _lock = Lock();

  final UpdaterService _updaterService;
  final SharedPreferences _sharedPreferences;

  @override
  void emit(ChallengeState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  Future<void> loadChallenge(
    String id,
    List<UserLanguage>? listWorkLang,
  ) async {
    emit(
      state.copyWith(
        originalPhrase: '',
        translation: '',
      ),
    );

    _pool = Soundpool.fromOptions();
    _dinkSound =
        await rootBundle.load('assets/audio/plink.mp3').then(_pool.load);
    await _pool.setVolume(soundId: _dinkSound, volume: 0.1);
    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.downloading,
      ),
    );
    try {
      unawaited(getTranslations(id));
      final response = await _client
          .get(
            Uri.parse(
              '/api/v1/challenge/$id',
            ),
          )
          .mapData();

      final challenge = Challenge.fromJson(response);

      await init(challenge, listWorkLang);
      _setRecentChallenge(challenge);
    } catch (e) {
      emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.failed,
        ),
      );
      rethrow;
    }
  }

  Future<void> loadRandomChallenge(List<UserLanguage>? listWorkLang) async {
    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.downloading,
        originalPhrase: '',
        translation: '',
      ),
    );

    try {
      final queryParameters = <String, dynamic>{
        'limit': '1',
        'recent': '0',
        'rated': '0',
        'popular': '0',
        'random': '1',
        'type': 'challenge',
        'languageID': state.challenge!.languageId,
      };

      queryParameters['channel'] = state.challenge!.channelId;

      var challenge = state.challenge!;
      var offset = state.offset;

      do {
        queryParameters['offset'] = offset.toString();

        final uri = Uri.parse('/api/v1/search/feed')
            .replace(queryParameters: queryParameters);

        final feedResponse = await _client.get(uri).listData();

        final items = feedResponse
            .map(
              (dynamic e) => FeedModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();

        if (items.isEmpty) break;

        final challengeResponse = await _client
            .get(
              Uri.parse(
                '/api/v1/challenge/${items.first.id}',
              ),
            )
            .mapData();

        challenge = Challenge.fromJson(challengeResponse);
        _setRecentChallenge(challenge);

        offset++;
      } while (challenge.id == state.challenge?.id);

      emit(state.copyWith(offset: offset));
      unawaited(getTranslations(challenge.id));
      await init(challenge, listWorkLang);
    } catch (e) {
      emit(
        state.copyWith(refPlayerStatus: PlayerStatus.failed),
      );
      rethrow;
    }
  }

  void _setRecentChallenge(
    Challenge challenge,
  ) {
    final recentChallengesJson =
        _sharedPreferences.getString('recent_challenge');
    var recentChallenges = <Challenge>[];
    if (recentChallengesJson != null) {
      final decodedList = json.decode(recentChallengesJson) as List<dynamic>;
      recentChallenges = decodedList
          .map((item) => Challenge.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    final newChallenge = challenge;
    recentChallenges
      ..removeWhere((existingChallenge) => existingChallenge.id == challenge.id)
      ..insert(0, newChallenge);
    final updatedChallengesJson = json.encode(
      recentChallenges.map((challenge) => challenge.toJson()).toList(),
    );
    _sharedPreferences.setString('recent_challenge', updatedChallengesJson);
    _updaterService.addItemToRecent(null);
  }

  Future<void> init(
    Challenge challenge,
    List<UserLanguage>? listWorkLang,
  ) async {
    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.downloading,
      ),
    );

    final Audiosample audiosample;
    final Uint8List refBlob;

    try {
      if (await _hasAccess()) {
        emit(state.copyWith(isInQuota: true));

        if (_ioAudio.isInited) {
          await _ioAudio.stopRefPlayer();
        } else {
          await _ioAudio.init();
        }

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

        refBlob = response.bodyBytes;

        await _ioAudio.rewriteRefWithOggBlob(
          refBlob,
          metadata: AudioMetadata.fromJson(response.headers['audio-meta']),
        );

        refAudioFilePath = await _saveRefAudioToFile(refBlob);

        unawaited(
          FirebaseAnalytics.instance.logSelectContent(
            contentType: 'challenge',
            itemId: challenge.id,
          ),
        );

        emit(
          ChallengeState(
            originalPhrase: state.originalPhrase,
            translation: state.translation,
            offset: state.offset,
            isInQuota: true,
            audiosample: audiosample,
            refDuration: await _ioAudio.refDuration() + recordingOvertime,
            challenge: challenge,
            refPlayerStatus: PlayerStatus.ready,
            rating: challenge.rating.round(),
            actualChallengeReference: refBlob,
            nextBtnVisible: state.nextBtnVisible,
          ),
        );
      } else {
        emit(state.copyWith(isInQuota: false));
        await FirebaseAnalytics.instance.logEvent(
          name: 'PayWall',
          parameters: {
            'category': 'challenge',
            'workLang': listWorkLang?.map((e) => e.name).toList(),
          },
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.failed,
        ),
      );
      rethrow;
    }
  }

  Future<bool> _hasAccess() async {
    final quota = await _client
        .get(
          Uri.parse(
            '/billing/check_quota_tariff_limit/00000000-0000-0000-0000-000000000006',
          ),
        )
        .mapData();

    final access = quota['Access'] as bool;

    if (!access && !kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(
        '44da3bd7: the user has exceeded his quota '
        'for Challenges',
        StackTrace.current,
      );
    }

    return access;
  }

  Future<void> getTranslations(String id) async {
    String? translation = '';
    var originalPhrase = '';

    final loc = kIsWeb ? 'en' : locale.toString();

    final localeIso3 = _languages
        .firstWhere(
          (e) =>
              e.locale!.replaceFirst(RegExp('[-]'), '_') == loc ||
              e.locale!.substring(0, 2) == loc.substring(0, 2),
          orElse: Language.new,
        )
        .iso3;

    const uri = '/api/v1/translation/object';

    final response = await _client.post(
      Uri.parse(uri),
      body: '{"ObjectID":"$id",'
          '"ObjectType":"challenge",'
          '"LanguagesISO3To":["$localeIso3"]}',
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if ((json.decode(response.body) as Map<String, dynamic>)['data'] == null) {
      emit(
        state.copyWith(
          originalPhrase: '',
          translation: '',
        ),
      );
      return;
    }

    final results = response.mapData()['Result'] as Map<String, dynamic>;
    final translate = response.mapData()['Translate'] as Map<String, dynamic>;

    if (results.containsKey(localeIso3)) {
      translation = Translate.fromJson(
        results[localeIso3] as Map<String, dynamic>,
      ).phrase;
    }
    originalPhrase = translate['Phrase'] as String;

    emit(
      state.copyWith(
        originalPhrase: originalPhrase,
        translation: translation,
      ),
    );
  }

  Future<void> playRef() async {
    if (state.refPlayerStatus != PlayerStatus.ready &&
        state.refPlayerStatus != PlayerStatus.playing) {
      return;
    }

    await _ioAudio.startRefPlayer(
      whenFinished: () => emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.ready,
        ),
      ),
    );

    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.playing,
      ),
    );

    if (!state.challenge!.isViewed) {
      _client
          .post(Uri.parse('/api/v1/challenge/upview/${state.challenge!.id}'))
          .ignore();

      emit(state.copyWith(challenge: state.challenge!.viewedCopy()));
    }
  }

  Future<void> _stopRefPlayer() async {
    await _ioAudio.stopRefPlayer();
    emit(state.copyWith(refPlayerStatus: PlayerStatus.ready));
  }

  Future<void> record() async {
    await _lock.synchronized(_record);
  }

  Future<void> _record() async {
    if (state.refPlayerStatus != PlayerStatus.ready ||
        state.recorderStatus != RecorderStatus.initial &&
            state.recorderStatus != RecorderStatus.analyzed &&
            state.recorderStatus != RecorderStatus.failed &&
            state.recorderStatus != RecorderStatus.ready) {
      return;
    }

    emit(state.copyWith(recorderStatus: RecorderStatus.starting));

    try {
      await _ioAudio.startRecorder();
      emit(state.copyWith(recordingAllowed: true));
    } on RecordingPermissionException {
      emit(
        state.copyWith(
          recordingAllowed: false,
          recorderStatus: RecorderStatus.failed,
        ),
      );

      return;
    }

    final duration = await _ioAudio.refDuration() + recordingOvertime;

    emit(
      state.copyWith(
        recorderStatus: RecorderStatus.recording,
        recordCount: state.recordCount + 1,
      ),
    );

    _timer = Timer(duration, stopRecorder);
  }

  Future<void> stopRecorder() async {
    _timer.cancel();
    if (state.recorderStatus == RecorderStatus.failed ||
        state.recorderStatus == RecorderStatus.analyzing) return;

    emit(
      state.copyWith(recorderStatus: RecorderStatus.analyzing),
    );

    await _ioAudio.stopRecorder();

    if (await _ioAudio.testTooShort()) {
      emit(
        state.copyWith(
          recorderStatus: RecorderStatus.failed,
        ),
      );

      return;
    }

    try {
      final audiosample = await _client.post(
        Uri.parse('/api/v1/audiosample'),
        body: '{"Label":"LABEL: 6999f4fe", '
            '"IsRef":false,"IsPublic":true,"TypeID":"tst"}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).mapData();

      final uploadAsset = MultipartRequest('post', Uri.parse('/api/v1/asset'));

      uploadAsset.fields.addAll({
        'object_id': audiosample['ID'] as String,
        'file_type': 'audiosample',
        'meta': '',
      });

      final blob = await _ioAudio.testOggBlob();
      testAudioFilePath = await _saveTestAudioToFile(blob);
      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          blob,
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      final audioSampleRefId = state.challenge!.audioSampleRefID;

      final result = await Future.wait([
        _client.post(
          Uri.parse('/api/v1/audiosample/compare/fingerprint'),
          body: json.encode({
            'AudioSampleRefID': audioSampleRefId,
            'AudioSampleTstID': audiosample['ID'],
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ).mapData(),
        _client.post(
          Uri.parse('/api/v1/audiosample/compare/emotion'),
          body: json.encode({
            'AudioSampleRefID': audioSampleRefId,
            'AudioSampleTstID': audiosample['ID'],
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ).mapData(),
      ]);

      final fingers = Fingerprint.fromJson(result[0]);

      final hglBodyValue = result[0]['HglBody'] as String;
      final audioBytes = base64Decode(hglBodyValue);
      final audioData = Uint8List.fromList(audioBytes);

      await _ioAudio.rewriteHighlightWithOggBlob(audioData);

      final emotionData = result[1];

      final myAttempt = MyAttempt.fromJson(
        await _client.post(
          Uri.parse('/api/v1/challenge_attempt/${state.challenge!.id}'),
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

      final attempt = ChallengeAttempt.fromFingerprint(
        myAttempt,
        fingers,
        EmotionData.fromJson(
          emotionData['EmotionData'] as Map<String, dynamic>,
        ),
      );

      if (myAttempt.xpTotal != null && myAttempt.xpFactorCurrent != null) {
        _homeCubit.updateXp(myAttempt.xpTotal!, myAttempt.xpFactorCurrent!);
      }

      await _pool.play(_dinkSound, rate: myAttempt.totalPercent / 100.0 + 0.5);
      emit(
        state.copyWith(
          attempt: attempt,
          myAttempts: List<MyAttempt>.from(state.myAttempts)..add(myAttempt),
          testPlayerStatus: PlayerStatus.ready,
          highlightPlayerStatus: PlayerStatus.ready,
          recorderStatus: RecorderStatus.analyzed,
        ),
      );
      _updaterService.fetchDailyProgress(null);
    } catch (e) {
      emit(
        state.copyWith(
          recorderStatus: RecorderStatus.failed,
        ),
      );
      rethrow;
    }
  }

  Future<String> _saveRefAudioToFile(Uint8List audioData) async {
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/refaudio.ogg';
    final file = await File(audioPath).create();
    await file.writeAsBytes(audioData);
    return file.path;
  }

  Future<String> _saveTestAudioToFile(Uint8List audioData) async {
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/testaudio.ogg';
    final file = await File(audioPath).create();
    await file.writeAsBytes(audioData);
    return file.path;
  }

  Future<void> playTest() async {
    if (state.testPlayerStatus != PlayerStatus.ready &&
        state.testPlayerStatus != PlayerStatus.playing) {
      return;
    }

    await _ioAudio.startTestPlayer(
      whenFinished: () =>
          emit(state.copyWith(testPlayerStatus: PlayerStatus.ready)),
    );
    emit(state.copyWith(testPlayerStatus: PlayerStatus.playing));
  }

  Future<void> playHighlight() async {
    if (state.highlightPlayerStatus != PlayerStatus.ready &&
        state.highlightPlayerStatus != PlayerStatus.playing) {
      return;
    }

    await _ioAudio.startHighlightPlayer(
      whenFinished: () =>
          emit(state.copyWith(highlightPlayerStatus: PlayerStatus.ready)),
    );
    emit(state.copyWith(highlightPlayerStatus: PlayerStatus.playing));
  }

  Future<void> _stopTestPlayer() async {
    await _ioAudio.stopTestPlayer();
    emit(state.copyWith(testPlayerStatus: PlayerStatus.ready));
  }

  Future<void> loadMyAttempts() async {
    if (state.loadedMyAttempts) {
      return;
    }

    try {
      emit(state.copyWith(loadingMyAttempts: true));

      final response = await _client
          .get(
            Uri.parse(
              '/api/v1/challenge_attempts/my/${state.challenge!.id}',
            ),
          )
          .listData();

      final attempts = response
          .map(
            (dynamic e) => MyAttempt.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      emit(
        state.copyWith(
          myAttempts: attempts,
          loadedMyAttempts: true,
          loadingMyAttempts: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadedMyAttempts: false,
          loadingMyAttempts: false,
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteMyAttempts(String id) async {
    try {
      await _client.delete(
        Uri.parse(
          '/api/v1/challenge_attempt/$id',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMyAttempt(int index) async {
    emit(
      state.copyWith(
        testPlayerStatus: PlayerStatus.downloading,
        recorderStatus: RecorderStatus.analyzing,
        nullChallengeAttempt: true,
      ),
    );
    try {
      final attempt = state.myAttempts[index];

      final response = await _client
          .get(
            Uri.parse(
              '/api/v1/challenge_attempt/${attempt.id}',
            ),
          )
          .mapData();

      final wholeAttempt = ChallengeAttempt.fromJson(response);

      final tstBlob = await _client.get(
        Uri.parse(
          '/api/v1/asset/object/audiosample/tst/${attempt.audioSampleTestId}',
        ),
      );
      final testBlob = tstBlob.bodyBytes;
      await _ioAudio.rewriteTestWithOggBlob(
        testBlob,
        metadata: AudioMetadata.fromJson(tstBlob.headers['audio-meta']),
      );

      emit(
        state.copyWith(
          attempt: wholeAttempt,
          testPlayerStatus: PlayerStatus.ready,
          recorderStatus: RecorderStatus.analyzed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.failed,
        ),
      );
      rethrow;
    }
  }

  void setCurrentAnnotation(int index) {
    emit(state.copyWith(currentAnnotationIndex: index));
  }

  var _syncRefCounter = 0;
  var _syncTestCounter = 0;

  static const annotationStartDrift = 0.0;
  static const annotationEndDrift = -0.08;
  static const annotationStartSensitivity = 0.1;

  Future<void> playRefAnnotation(Annotation a) async {
    await _stopRefPlayer();

    final double start = max(a.segmentStart! + annotationStartDrift, 0);
    final double end = max(a.segmentEnd! + annotationEndDrift, 0);

    await playRef();

    if (start > annotationStartSensitivity) {
      await _ioAudio.seekToRefPlayer(
        Duration(
          milliseconds: (start * 1000.0).toInt(),
        ),
      );
    }
    final c = ++_syncRefCounter;
    await Future<void>.delayed(
      Duration(
        milliseconds: ((end - start) * 1000.0).toInt(),
      ),
      () {
        if (c == _syncRefCounter) _stopRefPlayer();
      },
    );
  }

  Future<void> playTestAnnotation(Annotation a) async {
    await _stopTestPlayer();

    final startRef = a.segmentStart!;
    final endRef = a.segmentEnd!;

    final startTest = max(
      state.attempt!.pronunciationData!.dp!
              .firstWhere((element) => element.segmentEndRef > startRef)
              .segmentStartTest +
          annotationStartDrift,
      0,
    );

    final endTest = max(
      state.attempt!.pronunciationData!.dp!
              .firstWhere(
                (element) => element.segmentEndRef > endRef,
                orElse: () => state.attempt!.pronunciationData!.dp!.last,
              )
              .segmentEndTest +
          annotationEndDrift,
      0,
    );

    await playTest();

    if (startTest > annotationStartSensitivity) {
      await _ioAudio.seekToTestPlayer(
        Duration(
          milliseconds: (startTest * 1000.0).toInt(),
        ),
      );
    }

    final c = ++_syncTestCounter;
    await Future<void>.delayed(
      Duration(
        milliseconds: ((endTest - startTest) * 1000.0).toInt(),
      ),
      () {
        if (c == _syncTestCounter) _stopTestPlayer();
      },
    );
  }

  Future<void> clearAttempt() async {
    if (state.actualChallengeReference != null) {
      await _ioAudio.rewriteRefWithOggBlob(state.actualChallengeReference!);
    }

    emit(
      state.copyWith(
        nullChallengeAttempt: true,
        recorderStatus: RecorderStatus.ready,
      ),
    );
  }

  Future<void> playDuet() async {
    final annotations = state.audiosample?.annotations;
    if (annotations != null) {
      for (final annotation in annotations) {
        emit(state.copyWith(playBothAudios: true));

        await Future.wait([
          playTestAnnotation(annotation),
          playRefAnnotation(annotation),
        ]);
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      emit(state.copyWith(playBothAudios: false));
    }
  }

  void switchTranslation() {
    if (state.showTranslatedPhrase) {
      emit(state.copyWith(showTranslatedPhrase: false));
    } else {
      emit(state.copyWith(showTranslatedPhrase: true));
    }
  }

  Future<String?> createVideoWithRef(String backgroundPath) async {
    final tempDir = await getTemporaryDirectory();
    final refAudioPath = refAudioFilePath;
    final waveformRefOutput = '${tempDir.path}/waveformRef.mp4';

    final waveformRefCommand =
        '-i $refAudioPath -i $backgroundPath -filter_complex '
        '"[0:a]showwaves=mode=cline:s=280x220:colors=#6874E8,'
        'format=yuva420p,colorchannelmixer=aa=1[sw];'
        '[1:v]scale=480:900[bg];[bg][sw]overlay=x=100:y=520[out]" '
        '-map "[out]" -map 0:a -c:a aac -b:a 192k -c:v '
        'libx264 -threads 8 $waveformRefOutput';
    await FFmpegKit.execute('-y $waveformRefCommand');

    return waveformRefOutput;
  }

  Future<String?> createVideoWithTest(
    String backgroundPath,
  ) async {
    final tempDir = await getTemporaryDirectory();
    final testAudioPath = testAudioFilePath;
    final waveformTestOutput = '${tempDir.path}/waveformTest.mp4';

    final waveformTestCommand =
        '-i $testAudioPath -i $backgroundPath -filter_complex '
        '"[0:a]showwaves=mode=cline:s=280x220:colors=#ff8800,format=yuva420p,'
        'colorchannelmixer=aa=1[sw];[1:v]scale=480:900[bg];[bg]'
        '[sw]overlay=x=100:y=520[out]" -map "[out]" -map 0:a -c:a aac '
        '-b:a 192k -c:v libx264 -threads 8 $waveformTestOutput';

    await FFmpegKit.execute('-y $waveformTestCommand');

    return waveformTestOutput;
  }

  Future<String?> createVideoWithResult(
    String percent,
    String backgroundPath,
  ) async {
    final tempDir = await getTemporaryDirectory();

    final audioData = await rootBundle.load('assets/audio/plink.mp3');
    final audioBytes = audioData.buffer.asUint8List();
    final audioPath = '${tempDir.path}/plink.mp3';
    final audioFile = File(audioPath);
    await audioFile.writeAsBytes(audioBytes);

    final fontData = await rootBundle.load('assets/fonts/Roboto-Black.ttf');
    final fontBytes = fontData.buffer.asUint8List();
    final fontPath = '${tempDir.path}/Roboto-Black.ttf';
    final fontFile = File(fontPath);
    await fontFile.writeAsBytes(fontBytes);
    const fontSize = '78';
    const fontColor = 'black';

    final resultOutput = '${tempDir.path}/result.mp4';

    final resultVideoCommand =
        '-i $audioPath -i $backgroundPath -t 5 -filter_complex '
        '"[1:v]scale=480:900[bg];[bg]drawtext=text_shaping=1:'
        "text='$percent\\\\%':"
        'fontfile=$fontPath:fontsize=$fontSize:'
        "fontcolor=$fontColor:x=(w-text_w)/2:y=600:enable='"
        'between(t,0,5)\'[out]" -map "[out]" -map 0:a -c:a aac '
        '-b:a 192k -c:v libx264 -threads 8 $resultOutput';

    await FFmpegKit.execute('-y $resultVideoCommand');
    return resultOutput;
  }

  Future<String?> createVideoForShare() async {
    final tempDir = await getTemporaryDirectory();
    final data =
        await rootBundle.load('assets/images/challenge-complete-bg.jpg');
    final bytes = data.buffer.asUint8List();
    final backgroundPath = '${tempDir.path}/challenge-complete-bg.jpg';
    final imgFile = File(backgroundPath);
    await imgFile.writeAsBytes(bytes);

    final percent = switch (state.attempt?.totalPercent) {
      final notNullValue? => notNullValue.toStringAsFixed(0),
      _ => ''
    };

    final results = await Future.wait([
      createVideoWithRef(backgroundPath),
      createVideoWithTest(backgroundPath),
      createVideoWithResult(percent, backgroundPath),
    ]);

    final ref = results[0];
    final test = results[1];
    final result = results[2];

    final combinedOutput = '${tempDir.path}/voccent.mp4';

    final combineCommand = '-y -i $ref -i $test -i $result -filter_complex '
        '"[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" '
        '-map "[v]" -map "[a]" $combinedOutput';

    await FFmpegKit.execute(combineCommand);

    return combinedOutput;
  }

  @override
  Future<void> close() async {
    if (state.recorderStatus == RecorderStatus.recording) {
      await stopRecorder();
    }

    await _pool.release();
    await _ioAudio.close();
    await super.close();
  }
}
