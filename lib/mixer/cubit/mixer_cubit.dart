import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:soundpool/soundpool.dart';
import 'package:voccent/audio/audio_io.dart';
import 'package:voccent/audio/audio_metadata.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/mixer/cubit/models/mixer_model/mixer_model.dart';
import 'package:voccent/mixer/cubit/models/mixer_model/translation.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/breath22cbbd85.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint_data_joined_segments34530eeb.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/pronunciation_e1cbebc6.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/prosody_c7f1eb37.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'mixer_state.dart';

class MixerCubit extends Cubit<MixerState> {
  MixerCubit(
    this._client,
    this._languages,
    this.locale,
    this._updaterService,
  ) : super(MixerState());

  final Client _client;
  final _ioAudio = AudioIo();
  final List<Language> _languages;
  final Locale locale;
  late Soundpool _pool;
  late int _dinkSound;
  late Timer _timerStart;
  final UpdaterService _updaterService;

  @override
  Future<void> close() async {
    await _ioAudio.close();
    await _pool.release();
    await super.close();
  }

  @override
  void emit(MixerState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> fetch() async {
    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.downloading,
      ),
    );

    try {
      await _ioAudio.init();

      _pool = Soundpool.fromOptions();
      _dinkSound =
          await rootBundle.load('assets/audio/plink.mp3').then(_pool.load);
      await _pool.setVolume(soundId: _dinkSound, volume: 0.1);

      final response = await _client.get(Uri.parse('/api/v1/mixer'));

      emit(
        state.copyWith(
          model: response.hasMapData()
              ? MixerModel.fromJson(response.mapData())
              : null,
          refPlayerStatus: PlayerStatus.ready,
          testPlayerStatus: PlayerStatus.initial,
        ),
      );

      if (state.model != null) {
        final response = await _client.get(
          Uri.parse(
            '/api/v1/asset/object/audiosample/ref/${state.model!.audiosamplerefid}',
          ),
        );

        final blob = response.bodyBytes;

        await _ioAudio.rewriteRefWithOggBlob(
          blob,
          metadata: AudioMetadata.fromJson(response.headers['audio-meta']),
        );

        emit(
          state.copyWith(
            refPlayerStatus: PlayerStatus.ready,
            refDuration: await _ioAudio.refDuration() + recordingOvertime,
          ),
        );
      } else {
        emit(
          state.copyWith(
            refPlayerStatus: PlayerStatus.initial,
          ),
        );
      }

      await getTranslations(state.model?.mixerItemId ?? '');
    } catch (e) {
      emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.failed,
        ),
      );
      rethrow;
    }
  }

  void next() {
    if (state.step < (state.model?.countItems ?? 0) - 1) {
      _load(state.step + 1);
    }
  }

  void prev() {
    if (state.step > 0) {
      _load(state.step - 1);
    }
  }

  Future<void> _load(int number) async {
    if (state.refPlayerStatus == PlayerStatus.downloading) {
      return;
    }

    emit(
      state.copyWith(
        refPlayerStatus: PlayerStatus.downloading,
        noResult: true,
      ),
    );

    cleanMixer();

    try {
      final mixerResponse = await _client
          .get(
            Uri.parse(
              '/api/v1/mixer?number=$number&groupid=${state.model!.groupId}',
            ),
          )
          .mapData();

      final mixer = MixerModel.fromJson(mixerResponse);

      final audiosampleResponse = await _client.get(
        Uri.parse(
          '/api/v1/asset/object/audiosample/ref/${mixer.audiosamplerefid}',
        ),
      );
      final blob = audiosampleResponse.bodyBytes;

      await _ioAudio.rewriteRefWithOggBlob(
        blob,
        metadata:
            AudioMetadata.fromJson(audiosampleResponse.headers['audio-meta']),
      );

      emit(
        state.copyWith(
          model: mixer,
          refPlayerStatus: PlayerStatus.ready,
          testPlayerStatus: PlayerStatus.initial,
          step: number,
          refDuration: await _ioAudio.refDuration(),
        ),
      );

      await getTranslations(state.model?.mixerItemId ?? '');
    } catch (e) {
      emit(
        state.copyWith(
          refPlayerStatus: PlayerStatus.failed,
        ),
      );
      rethrow;
    }
  }

  void cleanMixer() {
    final model = state.emotion;
    model?.comparePercent = 0;

    emit(
      state.copyWith(
        emotion: model,
        fingerprint: Fingerprint(
          comparePercentPronunciation: 0,
          comparePercentPitch: 0,
          comparePercentEnergy: 0,
          comparePercentBreath: 0,
          pronunciationCompResultId: '',
          breathCompResultId: '',
          pitchCompResultId: '',
          energyCompResultId: '',
          audioSampleRefId: '',
          audioSampleTstId: '',
          error: '',
          fingerprintDataJoinedSegments34530eeb:
              FingerprintDataJoinedSegments34530eeb(
            prosodyC7f1eb37: ProsodyC7f1eb37(frames: [], total: []),
            pronunciationE1cbebc6: PronunciationE1cbebc6(
              frames: [],
              total: [],
              dp: [],
            ),
            breath22cbbd85: Breath22cbbd85(frames: [], total: []),
          ),
          xpAdd: 0,
        ),
      ),
    );
  }

  Future<void> playRef() async {
    if (state.refPlayerStatus != PlayerStatus.ready) {
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
  }

  Future<void> record() async {
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

    emit(
      state.copyWith(
        recorderStatus: RecorderStatus.recording,
        recordCount: state.recordCount + 1,
      ),
    );

    final duration = await _ioAudio.refDuration() + recordingOvertime;
    _timerStart = Timer(duration, stopRecorder);
  }

  Future<void> stopRecorder() async {
    _timerStart.cancel();
    if (state.recorderStatus == RecorderStatus.analyzing ||
        state.recorderStatus == RecorderStatus.failed) return;

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
      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          blob,
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      final audioSampleRefId = state.model!.audiosamplerefid;

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

      final emotion = EmotionData.fromJson(
        result[1]['EmotionData'] as Map<String, dynamic>,
      );

      await _pool.play(_dinkSound, rate: 0.5);

      emit(
        state.copyWith(
          emotion: emotion,
          fingerprint: fingers,
          testPlayerStatus: PlayerStatus.ready,
          recorderStatus: RecorderStatus.analyzed,
        ),
      );

      await _client.post(
        Uri.parse('/api/v1/audiosample_objectlink'),
        body: json.encode({
          'CompareRefID': audioSampleRefId,
          'ID': audiosample['ID'],
          'ObjectID': null,
          'ObjectType': 'mixer_attempt',
          'ParentObjectID': state.model!.mixerItemId,
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).mapData();
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

  void switchTranslation() {
    if (state.showTranslatedPhrase) {
      emit(state.copyWith(showTranslatedPhrase: false));
    } else {
      emit(state.copyWith(showTranslatedPhrase: true));
    }
  }

  Future<void> getTranslations(String objectId) async {
    var translation = '';
    var originalPhrase = '';

    if (objectId != '') {
      final loc = kIsWeb ? 'en' : locale.toString();

      final localeIso3 = _languages
          .firstWhere(
            (e) =>
                e.locale!.replaceFirst(RegExp('[-]'), '_') == loc ||
                e.locale!.substring(0, 2) == loc.substring(0, 2),
            orElse: Language.new,
          )
          .iso3;

      final response = await _client.post(
        Uri.parse(
          '/api/v1/translation/object',
        ),
        body: '{"ObjectID":"$objectId",'
            '"ObjectType":"mixer_item",'
            '"LanguagesISO3To":["$localeIso3"]}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if ((json.decode(response.body) as Map<String, dynamic>)['data'] ==
          null) {
        emit(
          state.copyWith(
            originalPhrase: '',
            translation: '',
            translationLoaded: true,
          ),
        );

        return;
      }

      final results = response.mapData()['Result'] as Map<String, dynamic>;
      final translate = response.mapData()['Translate'] as Map<String, dynamic>;

      if (results.containsKey(localeIso3)) {
        translation = Translation.fromJson(
          results[localeIso3] as Map<String, dynamic>,
        ).phrase;
      }
      originalPhrase = translate['Phrase'] as String;
    }

    emit(
      state.copyWith(
        originalPhrase: originalPhrase,
        translation: translation,
        translationLoaded: true,
      ),
    );
  }

  Future<void> playTest() async {
    if (state.testPlayerStatus != PlayerStatus.ready) {
      return;
    }

    await _ioAudio.startTestPlayer(
      whenFinished: () =>
          emit(state.copyWith(testPlayerStatus: PlayerStatus.ready)),
    );

    emit(state.copyWith(testPlayerStatus: PlayerStatus.playing));
  }
}
