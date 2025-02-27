import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voccent/audio/audio_io.dart';
import 'package:voccent/audio/audio_metadata.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/story/cubit/models/comparison.dart';
import 'package:voccent/story/cubit/models/item_pass_quiz.dart';
import 'package:voccent/story/cubit/models/quiz_item_update.dart';
import 'package:voccent/story/cubit/models/skip_pause_vote.dart';
import 'package:voccent/story/cubit/models/story.dart';
import 'package:voccent/story/cubit/models/story_current_pass.dart';
import 'package:voccent/story/cubit/models/story_mode.dart';
import 'package:voccent/story/cubit/models/story_pass.dart';
import 'package:voccent/story/cubit/models/story_pass_character.dart';
import 'package:voccent/story/cubit/models/translation.dart';
import 'package:voccent/story/cubit/models/videosample.dart';
import 'package:voccent/story/cubit/models/vote.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/widgets/vibration_controller.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit(
    this._socket,
    this._userToken,
    this._client,
    this._languages,
    this._locale,
    this._updaterService,
    this._sharedPreferences,
  ) : super(const StoryState()) {
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

  static const String freeStoryId = 'c8bc7237-d3d6-4f68-a91e-8892d8693c01';

  final _lock = Lock();
  final Client _client;
  final UserToken _userToken;
  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  Timer? _conditionTimer;
  final AudioIo _audioIo = AudioIo();
  final List<Language> _languages;
  final Locale _locale;
  late Soundpool _pool;
  late int _dinkSound;
  Timer? _recorderTimer;
  final UpdaterService _updaterService;
  final SharedPreferences _sharedPreferences;

  Future<void> init(
    String? link,
    String storyId,
    String? planPassElementId, {
    bool autostart = false,
    List<UserLanguage>? listWorkLang,
  }) async {
    if (storyId == freeStoryId || await _hasAccess()) {
      await _audioIo.init();
      emit(
        state.copyWith(
          isInQuota: true,
          isAutoStart: autostart,
        ),
      );

      if (link == null || link == '') {
        await _createNewStoryPass(
          storyId,
          planPassElementId: planPassElementId,
        );
      } else {
        await _getStoryPassData(link);
      }

      _pool = Soundpool.fromOptions();
      _dinkSound =
          await rootBundle.load('assets/audio/plink.mp3').then(_pool.load);
      await _pool.setVolume(soundId: _dinkSound, volume: 0.1);

      await _initWs();
    } else {
      emit(state.copyWith(isInQuota: false));
      String workLanguagesString;
      if (listWorkLang != null && listWorkLang.isNotEmpty) {
        workLanguagesString = listWorkLang.map((e) => e.name).join(', ');
      } else {
        workLanguagesString = '';
      }

      await FirebaseAnalytics.instance.logEvent(
        name: 'PayWall',
        parameters: {
          'category': 'story',
          'workLang': workLanguagesString,
        },
      );
    }
  }

  Future<void> restart({String? planPassElementId}) async {
    emit(StoryState(storyId: state.storyId));
    await _audioIo.stopRefPlayer();
    await _audioIo.stopBackground2Player();
    await _audioIo.clearBackground2Player();

    await _createNewStoryPass(
      state.storyId!,
      continueWhereLeft: false,
      planPassElementId: planPassElementId,
    );

    await _initWs();
  }

  @override
  void emit(StoryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() async {
    await stopRecorder();
    await _audioIo.stopAll();
    await _audioIo.close();
    _socket
      ..send(
        {
          'TicketToken': state.storyPassUpdateTicketToken,
          'Type': 'remove_ticket_token',
        },
      )
      ..send(
        {
          'TicketToken': state.storyPassReadTicketToken,
          'Type': 'remove_ticket_token',
        },
      );

    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    _conditionTimer?.cancel();

    return super.close();
  }

  Future<void> _createNewStoryPass(
    String storyId, {
    bool continueWhereLeft = true,
    String? planPassElementId,
  }) async {
    final response = await _client
        .post(
          Uri.parse(
            '/api/v1/story_pass/create/$storyId'
            '?IfNotExists=$continueWhereLeft'
            '&AutoStart=${state.isAutoStart}'
            '&PlanPassElementID=${planPassElementId ?? ''}',
          ),
        )
        .mapData();

    final storyPassObj = response['StoryPass'] as Map<String, dynamic>;

    final storyPass =
        StoryPass.fromJson(storyPassObj['StoryPass'] as Map<String, dynamic>);

    final storyPassCharacters = storyPassObj['StoryPassCharacters'] != null
        ? (storyPassObj['StoryPassCharacters'] as Map<String, dynamic>).map(
            (key, dynamic value) => MapEntry(
              key,
              StoryPassCharacter.fromJson(value as Map<String, dynamic>),
            ),
          )
        : null;

    final storyObj = response['Story'] as Map<String, dynamic>;
    final story = Story.fromJson(storyObj['Story'] as Map<String, dynamic>);
    final modes = (storyObj['Modes'] as List<dynamic>?)
        ?.map((e) => StoryMode.fromJson(e as Map<String, dynamic>))
        .toList();

    _setRecentStory(story);
    emit(
      state.copyWith(
        storyPass: storyPass,
        storyPassCharacters: storyPassCharacters,
        story: story,
        storyId: storyId,
        modes: modes,
        nullSkipPauseVote: true,
      ),
    );

    if (storyPassObj['CurrentPass'] != null) {
      final currentPass = StoryCurrentPass.fromJson(
        storyPassObj['CurrentPass'] as Map<String, dynamic>,
      );
      await _emitNewCurrentPassState(currentPass);
    }
  }

  Future<void> _getStoryPassData(String link) async {
    final response =
        await _client.get(Uri.parse('/api/v1/story_pass/$link')).mapData();

    final storyPassObj = response['StoryPass'] as Map<String, dynamic>;

    final storyPass =
        StoryPass.fromJson(storyPassObj['StoryPass'] as Map<String, dynamic>);

    final storyPassCharacters =
        (storyPassObj['StoryPassCharacters'] as Map<String, dynamic>).map(
      (key, dynamic value) => MapEntry(
        key,
        StoryPassCharacter.fromJson(value as Map<String, dynamic>),
      ),
    );

    final storyObj = response['Story'] as Map<String, dynamic>;
    final story = Story.fromJson(storyObj['Story'] as Map<String, dynamic>);
    _setRecentStory(story);
    emit(
      state.copyWith(
        storyPass: storyPass,
        storyPassCharacters: storyPassCharacters,
        story: story,
        storyId: storyPass.storyParentId,
      ),
    );

    if (storyPassObj['CurrentPass'] != null) {
      final currentPass = StoryCurrentPass.fromJson(
        storyPassObj['CurrentPass'] as Map<String, dynamic>,
      );
      await _emitNewCurrentPassState(currentPass);
    }
  }

  void _setRecentStory(Story story) {
    final recentStoriesJson = _sharedPreferences.getString('recent_story');
    var recentStories = <Story>[];
    if (recentStoriesJson != null) {
      final decodedList = json.decode(recentStoriesJson) as List<dynamic>;
      recentStories = decodedList
          .map((item) => Story.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final newStory = story;
    recentStories
      ..removeWhere((existingStory) => existingStory.id == story.id)
      ..insert(0, newStory);
    final updatedStoriesJson =
        json.encode(recentStories.map((story) => story.toJson()).toList());
    _sharedPreferences.setString('recent_story', updatedStoriesJson);
  }

  Future<bool> _hasAccess() async {
    final quota = await _client
        .get(
          Uri.parse(
            '/billing/check_quota_tariff_limit/00000000-0000-0000-0000-00000000001d',
          ),
        )
        .mapData();

    final access = quota['Access'] as bool;

    if (!access && !kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(
        '44da3bd7: the user has exceeded his quota '
        'for Stories',
        StackTrace.empty,
      );
    }

    return access;
  }

  Future<void> _initWs() async {
    emit(
      state.copyWith(
        storyPassUpdateTicketToken:
            await _generateTicketToken('story_pass_update'),
        storyPassReadTicketToken: await _generateTicketToken('story_pass_read'),
      ),
    );

    if (state.storyPass.type == 3 && state.storyPass.status == 'new' ||
        state.isAutoStart) {
      startStory();
    }
  }

  Future<void> _onWebSocketDataSync(Map<String, dynamic> frame) async {
    await _lock.synchronized(() => _onWebSocketData(frame));
  }

  Future<void> _onWebSocketData(Map<String, dynamic> frame) async {
    if (frame['OperationID'] !=
        '${state.storyPass.link}_${state.storyPass.storyId}') {
      return;
    }

    log(frame.toString(), name: 'Story');

    if (frame['Data'] == null) {
      return;
    }

    if (frame['Type'] == 'error') {
      emit(state.copyWith(loading: false));

      throw Exception(frame['Data']);
    }

    final Map<String, dynamic> data;

    if (frame['Data'] is Map<String, dynamic>) {
      data = frame['Data'] as Map<String, dynamic>;
    } else if (frame['Data'] is String) {
      data = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
    } else {
      throw Exception('7e71b5e6: Unexpected server response');
    }

    if (frame['Type'] == 'watch_user_status') {
      final userStatus = Map<String, bool>.from(state.isOnlineUser);
      userStatus[data['UserID'] as String] = data['IsOnline'] as bool;
      emit(state.copyWith(isOnlineUser: userStatus));
    }

    if (frame['Ticket'] == 'story_pass_read' && frame['Type'] == 'message') {
      switch (data['Operation']) {
        case 'save_story_pass_act_item_vote':
          final v =
              SkipPauseVote.fromJson(data['Object'] as Map<String, dynamic>);

          emit(
            state.copyWith(
              skipPauseVote: state.skipPauseVote?.copyWith(
                    itemId: v.itemId,
                    vote: v.vote,
                    voteAll: v.voteAll,
                  ) ??
                  v,
            ),
          );

          return;
        case 'save_story_pass_character':
          final characterUpdate = StoryPassCharacter.fromJson(
            data['Object'] as Map<String, dynamic>,
          );

          final chars =
              Map<String, StoryPassCharacter>.from(state.storyPassCharacters);

          chars[characterUpdate.characterId!] =
              chars[characterUpdate.characterId!]!.copyWith(
            characterId: characterUpdate.characterId,
            characterName: characterUpdate.characterName,
            id: characterUpdate.id,
            storyId: characterUpdate.storyId,
            userCheck: characterUpdate.userCheck,
            userId: characterUpdate.userId,
            userName: characterUpdate.userName,
            userEmail: characterUpdate.userEmail,
          );

          emit(state.copyWith(storyPassCharacters: chars));
          return;
        case 'run_story_pass':
          final dataObject = data['Object'] as Map<String, dynamic>;

          if (dataObject['CurrentPass'] != null) {
            final currentPass = StoryCurrentPass.fromJson(
              dataObject['CurrentPass'] as Map<String, dynamic>,
            );

            await _emitNewCurrentPassState(currentPass);
          }

          if (dataObject['StoryPassCharacters'] != null) {
            final storyPassCharacters =
                (dataObject['StoryPassCharacters'] as Map<String, dynamic>).map(
              (key, dynamic value) => MapEntry(
                key,
                StoryPassCharacter.fromJson(value as Map<String, dynamic>),
              ),
            );

            emit(state.copyWith(storyPassCharacters: storyPassCharacters));
          }

          final p = StoryPass.fromJson(
            dataObject['StoryPass'] as Map<String, dynamic>,
          );

          emit(
            state.copyWith(
              storyPass: state.storyPass.copyWith(
                actId: p.actId,
                actItemId: p.actItemId,
                condition: p.condition,
                id: p.id,
                link: p.link,
                progress: p.progress,
                status: p.status,
                storyId: p.storyId,
                storyParentId: p.storyParentId,
                pause: p.pause,
                levels: p.levels,
                actItemNumber: p.actItemNumber,
                actItems: p.actItems,
                progressAct: p.progressAct,
                levelNumber: p.levelNumber,
              ),
            ),
          );

          return;
        case 'save_story_pass_choose_act_condition':
          _actConditionChosen(
            Vote.fromJson(data['Object'] as Map<String, dynamic>),
          );
          return;
        case 'audio_saved':
          await _updateAudioComparisonItem(
            Comparison.fromJson(data['Object'] as Map<String, dynamic>),
          );
          return;
        case 'quiz_saved':
          await _updateQuizItem(
            QuizItemUpdate.fromJson(data['Object'] as Map<String, dynamic>),
          );
          await Future<void>.delayed(const Duration(seconds: 3));
          return;
        case 'choose_story_pass_type':
          _storyTypeChosen(
            StoryPass.fromJson(data['Object'] as Map<String, dynamic>),
          );
          return;
        default:
      }
    }

    if (frame['Ticket'] == 'story_pass_update' && frame['Type'] == 'message') {
      if (data['Invitee'] != null) {
        emit(
          state.copyWith(
            invites: List<String>.from(state.invites)
              ..add(data['Invitee'] as String),
          ),
        );
        return;
      }
    }
  }

  Future<void> stopAll() async {
    await _audioIo.stopAll();
    await _audioIo.stopBackground2Player();
    await _audioIo.clearAll();
  }

  String? _lastItemAudiosamplerefid;

  Future<void> _emitNewCurrentPassState(StoryCurrentPass currentPass) async {
    emit(
      state.copyWith(
        status: VideoLoadingStatus.initial,
        isInteractiveVideo: false,
        isVideoOnBackground: false,
        isImageOnBackground: false,
      ),
    );
    await _audioIo.stopAll();
    await _audioIo.clearAll();

    if (currentPass.actId != state.currentPass?.actId) {
      await _audioIo.stopBackground2Player();
      await _audioIo.clearBackground2Player();
    }

    if (currentPass.type == ItemType.foreignLink) {
      await _audioIo.stopBackground2Player();
    } else if (_audioIo.background2PlayerStatus == PlayerState.isStopped) {
      await _audioIo.startBackground2Player();
    }

    await Future.wait([
      if (currentPass.actAudiosampleRefId != null)
        _audioBlob(currentPass.actAudiosampleRefId!).then(
          (b) => _audioIo.rewriteBackgroundWithOggBlob(
            b.$1,
            metadata: b.$2,
          ),
        ),
      if (currentPass.actBackgroundAudiosampleRefId != null &&
          state.currentPass?.actBackgroundAudiosampleRefId !=
              currentPass.actBackgroundAudiosampleRefId)
        _audioBlob(currentPass.actBackgroundAudiosampleRefId!).then(
          (b) async {
            await _audioIo.stopBackground2Player();
            await _audioIo.rewriteBackground2WithOggBlob(
              b.$1,
              metadata: b.$2,
            );
            await _audioIo.startBackground2Player();
          },
        ),
    ]);

    final refDuration = await _recordingDuration();

    emit(
      state.copyWith(
        currentPass: currentPass,
        quizDataToSend: const ItemPassQuiz(),
        loading: false,
        isNextScreen: false,
        refPlayerStatus: _audioIo.refPlayerStatus,
        testPlayerStatus: _audioIo.testPlayerStatus,
        highlightPlayerStatus: _audioIo.highlightPlayerStatus,
        recorderStatus: _audioIo.recorderStatus,
        audiosampleRefDuration: refDuration,
        nullSkipPauseVote: true,
      ),
    );

    if (currentPass.itemVisualType == 0) {
      emit(
        state.copyWith(
          isInteractiveVideo: false,
          isVideoOnBackground: false,
          isImageOnBackground: false,
        ),
      );
    }

    final hasVideo = currentPass.itemVideosamplerefid != null &&
        currentPass.itemVisualType == 1;

    if (hasVideo && state.currentPass?.type == ItemType.audioComparison) {
      emit(
        state.copyWith(
          isInteractiveVideo: true,
          isVideoOnBackground: false,
        ),
      );
    }
    if (hasVideo && state.currentPass?.type != ItemType.audioComparison) {
      emit(
        state.copyWith(
          isInteractiveVideo: false,
          isVideoOnBackground: true,
        ),
      );
    }
    if (hasVideo) {
      await _getVideosample(currentPass.itemVideosamplerefid);
    }

    if (currentPass.itemVisualType == 2) {
      emit(
        state.copyWith(
          isImageOnBackground: true,
        ),
      );
    }

    if (currentPass.actConditions?.isNotEmpty ?? false) {
      await _startConditionActTimer(currentPass);
    } else if (currentPass.itemPassPause != null) {
      _startTimer(currentPass.itemPassPause!);
    }
    if (currentPass.itemAudiosamplerefid != null) {
      await _audioBlob(currentPass.itemAudiosamplerefid!).then(
        (b) async {
          final i = currentPass.itemAudiosamplerefid;
          _lastItemAudiosamplerefid = i;
          await _audioIo.rewriteRefWithOggBlob(b.$1, metadata: b.$2);
          Future.delayed(const Duration(seconds: 2), () async {
            if (_lastItemAudiosamplerefid == i &&
                (await _audioIo.refDuration()).inSeconds > 0 &&
                !state.isInteractiveVideo) {
              await _audioIo.startRefPlayer(
                whenFinished: _emitAudioStatus,
              );
            }
            await _emitAudioStatus();
          });
        },
      );
    }
    await _emitCurrentPassWithTranslation();
  }

  Future<void> _voteToSkip() async {
    if (state.skipPauseVote?.weVoted ?? false) {
      return;
    }

    emit(
      state.copyWith(
        skipPauseVote: state.skipPauseVote?.copyWith(weVoted: true) ??
            SkipPauseVote(
              itemId: state.currentPass!.itemId,
              weVoted: true,
            ),
      ),
    );

    _socket.send({
      'Data': {
        'Operation': 'save_story_pass_act_item_vote',
        'Object': {
          'ItemID': state.currentPass!.itemId,
        },
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  Future<(Uint8List, AudioMetadata)> _audioBlob(String refId) async {
    final response = await _client.get(
      Uri.parse(
        '/api/v1/asset/object/audiosample/ref/$refId',
      ),
    );

    return (
      response.bodyBytes,
      AudioMetadata.fromJson(response.headers['audio-meta'])
    );
  }

  Future<void> _startConditionActTimer(StoryCurrentPass currentPass) async {
    final now = DateTime.now();

    final conditionCreatedAt =
        DateTime.parse(currentPass.actConditions![0].createdAt!);

    final diff = now.difference(conditionCreatedAt).inSeconds;
    final condition = 10 - diff;

    _startTimer(condition);
  }

  static const _oneSec = Duration(seconds: 1);

  void _startTimer(int seconds) {
    _conditionTimer?.cancel();

    emit(state.copyWith(conditionTimer: seconds));
    _conditionTimer = Timer.periodic(
      _oneSec,
      (Timer timer) {
        if (state.conditionTimer == 0) {
          timer.cancel();
        } else {
          emit(state.copyWith(conditionTimer: state.conditionTimer - 1));
        }
      },
    );
  }

  Future<void> _updateAudioComparisonItem(Comparison comparison) async {
    final b = await _audioBlob(comparison.audioId!);
    await _audioIo.rewriteTestWithOggBlob(b.$1, metadata: b.$2);

    emit(
      state.copyWith(
        currentPass: state.currentPass?.copyWith(comparison: comparison),
      ),
    );
  }

  Future<void> _updateQuizItem(QuizItemUpdate update) async {
    emit(
      state.copyWith(
        currentPass: state.currentPass!.copyWith(itemPassQuiz: update.quiz),
      ),
    );
  }

  void _actConditionChosen(Vote vote) {
    final currentPass = state.currentPass;
    final currentConditions = currentPass!.actConditions;

    if (currentPass.actConditions != null || currentPass.actId != vote.actId) {
      return;
    }

    for (var i = 0; i < currentPass.actConditions!.length; i++) {
      if (currentPass.actConditions![i].actId == vote.actIdPlus) {
        currentConditions![i] =
            currentConditions[i].copyWith(vote: vote.votePlus.toString());
      }
      if (currentPass.actConditions![i].actId == vote.actIdMinus) {
        currentConditions![i] =
            currentConditions[i].copyWith(vote: vote.voteMinus.toString());
      }
    }

    emit(
      state.copyWith(
        currentPass: currentPass.copyWith(actConditions: currentConditions),
      ),
    );
  }

  Future<String> _generateTicketToken(String ticket) async {
    final map = await _socket.request(
      {'Token': await _userToken.value(), 'Type': 'generate_ticket_token'},
      ticket,
      '${state.storyPass.link}_${state.storyPass.storyId}',
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
            storyPassUpdateTicketToken:
                await _generateTicketToken('story_pass_update'),
            storyPassReadTicketToken:
                await _generateTicketToken('story_pass_read'),
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

    log(error.toString(), name: 'Story');
  }

  Future<void> _compareAudiosamples(
    Uint8List testOgg,
    Duration testAudioDuration,
  ) async {
    try {
      if (state.currentPass?.type != ItemType.audioComparison) {
        throw Exception('Tried to compare non-audio step');
      }

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

      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          testOgg,
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      final audioSampleRefId = state.currentPass!.itemAudiosamplerefid;

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

      final emotionData = result[1];

      final emotion = EmotionData.fromJson(
        emotionData['EmotionData'] as Map<String, dynamic>,
      );

      // link audio object and expect `audio_saved` WS frame
      await _client.post(
        Uri.parse('/api/v1/audiosample_objectlink'),
        body: json.encode(
          {
            'ID': fingers.audioSampleTstId,
            'ObjectID': state.currentPass!.itemPassID,
            'ObjectType': 'story_pass_act_item',
            'CompareRefID': state.currentPass!.itemAudiosamplerefid,
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).mapData();

      await _pool.play(
        _dinkSound,
        rate: (state.currentPass?.comparison?.total ?? 0.0) / 100.0 + 0.5,
      );

      emit(
        state.copyWith(
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
              comparePronunciationPercent: fingers.comparePercentPronunciation,
              comparePitchPercent: fingers.comparePercentPitch,
              compareBreathPercent: fingers.comparePercentBreath,
              compareEnergyPercent: fingers.comparePercentEnergy,
              compareEmotionPercent: emotion.comparePercent,
              xpAdd: fingers.xpAdd,
            ),
            fingerprint: fingers,
            emotionData: emotion,
          ),
          isTestAudiosampleLinkedToItemPass: true,
          loading: false,
          isNextScreen: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          isNextScreen: false,
          isTestAudiosampleLinkedToItemPass: false,
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
              comparePronunciationPercent: 1,
              comparePitchPercent: 1,
              compareBreathPercent: 1,
              compareEnergyPercent: 1,
              compareEmotionPercent: 1,
            ),
          ),
        ),
      );

      rethrow;
    }
  }

  Future<void> _emotionAnalysis(
    Uint8List testOgg,
    Duration testAudioDuration,
  ) async {
    try {
      if (state.currentPass?.type != ItemType.emotionAnalysis) {
        throw Exception('Tried to analyze non-emotionAnalysis step');
      }

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

      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          testOgg,
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      // link audio object and expect `audio_saved` WS frame
      await _client.post(
        Uri.parse('/api/v1/audiosample_objectlink'),
        body: json.encode(
          {
            'ID': audiosample['ID'],
            'ObjectID': state.currentPass!.itemPassID,
            'ObjectType': 'story_pass_act_item',
            'CompareRefID': state.currentPass!.itemAudiosamplerefid,
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).mapData();
      unawaited(
        _client.post(
          Uri.parse('/api/v1/audiosample/analyze/emotion'),
          body: json.encode({
            'AudioSampleRefID': audiosample['ID'],
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
      await _pool.play(
        _dinkSound,
        // rate: (state.currentPass?.comparison?.total ?? 0.0) / 100.0 + 0.5,
      );

      emit(
        state.copyWith(
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
            ),
          ),
          isTestAudiosampleLinkedToItemPass: true,
          loading: false,
          isNextScreen: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          isNextScreen: false,
          isTestAudiosampleLinkedToItemPass: false,
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
              comparePronunciationPercent: 1,
              comparePitchPercent: 1,
              compareBreathPercent: 1,
              compareEnergyPercent: 1,
              compareEmotionPercent: 1,
            ),
          ),
        ),
      );

      rethrow;
    }
  }

  Future<void> _semanticAnalysis(
    Uint8List testOgg,
    Duration testAudioDuration,
  ) async {
    try {
      if (state.currentPass?.type != ItemType.semanticAnalysis) {
        throw Exception('Tried to analyze non-emotionAnalysis step');
      }

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

      uploadAsset.files.add(
        MultipartFile.fromBytes(
          'file',
          testOgg,
          contentType: MediaType.parse('audio/ogg'),
          filename: '[object Object]',
        ),
      );

      await Response.fromStream(await _client.send(uploadAsset));

      final data = await _client.post(
        Uri.parse('/api/v1/audiosample/analyze/emotion'),
        body: json.encode({
          'AudioSampleRefID': audiosample['ID'],
          'NotWait': false,
          'SemanticAnalysis': true,
          'MentalPortrait': false,
          'EmotionAnalysis': false,
          'SpeechQuality': false,
          'ObjectType': 'story_pass_act_item',
          'ObjectID': state.currentPass!.itemPassID,
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final semanticAnalysisPercent =
          (data.mapData()['SemanticAnalysisPercent'] ?? 0) as int;

      await _client.post(
        Uri.parse('/api/v1/audiosample_objectlink'),
        body: json.encode(
          {
            'ID': audiosample['ID'],
            'ObjectID': state.currentPass!.itemPassID,
            'ObjectType': 'story_pass_act_item',
            'CompareRefID': state.currentPass!.itemAudiosamplerefid,
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).mapData();

      await _pool.play(
        _dinkSound,
      );

      emit(
        state.copyWith(
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
            ),
          ),
          isTestAudiosampleLinkedToItemPass: true,
          loading: false,
          isNextScreen: false,
          semanticAnalysisPercent: semanticAnalysisPercent,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          isNextScreen: false,
          isTestAudiosampleLinkedToItemPass: false,
          currentPass: state.currentPass!.copyWith(
            comparison: Comparison(
              actId: state.currentPass!.actId,
              itemId: state.currentPass!.itemId,
              comparePronunciationPercent: 1,
              comparePitchPercent: 1,
              compareBreathPercent: 1,
              compareEnergyPercent: 1,
              compareEmotionPercent: 1,
            ),
          ),
        ),
      );

      rethrow;
    }
  }

  void startStory() {
    HapticFeedback.lightImpact(); // TODO(svic): move to UI

    _socket.send({
      'Data': {
        'Operation': 'run_story_pass',
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  void changeUserRole(String characterId) {
    _socket.send({
      'Data': {
        'Operation': 'save_story_pass_character',
        'Object': {
          'CharacterID': characterId,
          'Check': !state.storyPassCharacters[characterId]!.userCheck,
        },
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  void chooseStoryMode(int modeId) {
    _socket.send({
      'Data': {
        'Operation': 'choose_story_pass_type',
        'Object': {
          'Type': modeId,
        },
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  Future<void> sendInvite(String emailOrUsername) async {
    final updatedList = List<String>.from(state.invitedUsers)
      ..add(emailOrUsername.trim());

    emit(state.copyWith(invitedUsers: updatedList));
    _socket.send(<String, dynamic>{
      'Data': <String, dynamic>{
        'Operation': 'invite_story_pass',
        'Object': <String, dynamic>{
          'Username': emailOrUsername.trim(),
        },
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  void next() {
    if (state.loading || state.testPlayerStatus == PlayerState.isPlaying) {
      return;
    }

    HapticFeedback.lightImpact(); // TODO(svic): move to UI

    emit(
      state.copyWith(
        semanticAnalysisPercent: 0,
        isTestAudiosampleLinkedToItemPass: false,
        loading: true,
        isNextScreen: true,
      ),
    );

    if (state.currentPass!.itemPassPause != null) {
      _voteToSkip();
    } else {
      _socket.send({
        'Data': {
          'Operation': 'run_story_pass',
          'Object': state.quizDataToSend,
        },
        'TicketToken': state.storyPassUpdateTicketToken,
        'Type': 'message',
      });
    }
  }

  void chooseQuizVariant(ItemPassQuiz quizAnswer) {
    emit(state.copyWith(quizDataToSend: quizAnswer));
  }

  void chooseActCondition(String actId) {
    String? prevChoice;
    if (state.chosenAct != null) {
      prevChoice = state.chosenAct;
    }
    emit(state.copyWith(chosenAct: actId));

    _socket.send({
      'Data': {
        'Operation': 'save_story_pass_choose_act_condition',
        'Object': {
          'ActID': state.currentPass!.actId,
          'ActIDPlus': actId,
          'ActIDMinus': prevChoice,
        },
      },
      'TicketToken': state.storyPassUpdateTicketToken,
      'Type': 'message',
    });
  }

  void _storyTypeChosen(StoryPass storyPass) {
    emit(
      state.copyWith(
        storyPass: state.storyPass.copyWith(type: storyPass.type),
      ),
    );
  }

  Future<void> _emitCurrentPassWithTranslation() async {
    String? originalPhrase;
    final currentPass = state.currentPass!;

    if (currentPass.itemSpelling?.isEmpty ?? true) return;

    final originalLocale = _languages
        .firstWhere(
          (e) => e.id == currentPass.itemLanguageId,
          orElse: Language.new,
        )
        .iso3;

    final loc = kIsWeb ? 'en' : _locale.toString();

    final userLocale = _languages
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
      body: '{"ObjectID":"${currentPass.itemId}",'
          '"ObjectType":"story_act_item",'
          '"LanguagesISO3To":["$originalLocale","$userLocale"]}',
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (!response.hasMapData()) return;

    final translate = response.mapData()['Translate'] as Map<String, dynamic>;
    final languageISO3From = translate['LanguageISO3From'] as String;
    final autoShow = translate['AutoShow'] as bool;

    final results = response.mapData()['Result'] as Map<String, dynamic>;

    if (languageISO3From == originalLocale) {
      originalPhrase = currentPass.itemSpelling;
    } else {
      originalPhrase = Translation.fromJson(
        results[originalLocale] as Map<String, dynamic>,
      ).phrase;
    }

    final translatedPhrase = Translation.fromJson(
      results[userLocale] as Map<String, dynamic>,
    ).phrase;

    emit(
      state.copyWith(
        currentPass: currentPass.copyWith(
          originalPhrase: originalPhrase,
          translatedPhrase: translatedPhrase,
          autoShow: autoShow,
        ),
      ),
    );
  }

  Future<void> openLink(String url) async {
    VibrationController.onPressedVibration();
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> record() async {
    if (_audioIo.refPlayerStatus == PlayerState.isPlaying ||
        _audioIo.recorderStatus == RecorderState.isRecording ||
        state.loading) {
      return;
    }

    emit(
      state.copyWith(
        recorderError: RecorderError.success,
      ),
    );

    try {
      await _audioIo.startRecorder();
      emit(state.copyWith(recordingAllowed: true));
    } on RecordingPermissionException {
      emit(
        state.copyWith(
          recordingAllowed: false,
          recorderError: RecorderError.failed,
        ),
      );
      return;
    }

    await _emitAudioStatus();

    final duration = await _recordingDuration();

    _recorderTimer = Timer(duration, stopRecorder);
  }

  Future<Duration> _recordingDuration() async {
    if (state.currentPass?.type == ItemType.emotionAnalysis) {
      return Duration(seconds: state.currentPass!.itemRecordDuration ?? 60);
    } else if (state.currentPass?.type == ItemType.semanticAnalysis) {
      return Duration(seconds: state.currentPass!.itemRecordDuration ?? 60);
    } else {
      return await _audioIo.refDuration() + recordingOvertime;
    }
  }

  Future<void> stopRecorder() async {
    if (_recorderTimer == null) return;
    _recorderTimer!.cancel();

    if (state.loading) return;

    emit(
      state.copyWith(
        loading: true,
      ),
    );
    await _audioIo.stopRecorder();

    await _emitAudioStatus();

    if (await _audioIo.testTooShort()) {
      emit(
        state.copyWith(
          loading: false,
        ),
      );

      return;
    }

    if (!isClosed) {
      if (state.currentPass?.type == ItemType.emotionAnalysis) {
        await _emotionAnalysis(
          await _audioIo.testOggBlob(),
          await _audioIo.testDuration(),
        );
      } else if (state.currentPass?.type == ItemType.semanticAnalysis) {
        await _semanticAnalysis(
          await _audioIo.testOggBlob(),
          await _audioIo.testDuration(),
        );
      } else {
        await _compareAudiosamples(
          await _audioIo.testOggBlob(),
          await _audioIo.testDuration(),
        );
      }
    }
    _updaterService.fetchDailyProgress(null);
  }

  Future<void> playStopRef() async {
    if (_audioIo.refPlayerStatus == PlayerState.isPlaying) {
      await _audioIo.stopRefPlayer();
      await _emitAudioStatus();
      return;
    }

    await _audioIo.startRefPlayer(
      whenFinished: _emitAudioStatus,
    );

    await _emitAudioStatus();
  }

  Future<void> playStopTest() async {
    if (_audioIo.testPlayerStatus == PlayerState.isPlaying) {
      await _audioIo.stopTestPlayer();
      await _emitAudioStatus();
      return;
    }

    await _audioIo.startTestPlayer(
      whenFinished: _emitAudioStatus,
    );

    await _emitAudioStatus();
  }

  Future<void> _emitAudioStatus() async {
    final refDuration = await _recordingDuration();

    emit(
      state.copyWith(
        refPlayerStatus: _audioIo.refPlayerStatus,
        testPlayerStatus: _audioIo.testPlayerStatus,
        highlightPlayerStatus: _audioIo.highlightPlayerStatus,
        recorderStatus: _audioIo.recorderStatus,
        audiosampleRefDuration: refDuration,
        isFullRecording: true,
      ),
    );
  }

  Future<void> pause() => _audioIo.mutePlayers();
  Future<void> resume() => _audioIo.unmutePlayers();

  Future<void> muteUnmuteBackground2() {
    emit(
      state.copyWith(isback2Unmuted: !state.isback2Unmuted),
    );

    return _audioIo.muteUnmuteBackground2();
  }

  Future<void> _getVideosample(String? videosampleRefId) async {
    emit(
      state.copyWith(status: VideoLoadingStatus.loading),
    );
    final url = '/api/v1/videosample/$videosampleRefId';

    final response = await _client.get(
      Uri.parse(url),
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    final dataMap = data['data'] as Map<String, dynamic>;
    final videosample = Videosample.fromJson(dataMap);

    emit(
      state.copyWith(
        videosample: videosample,
        status: VideoLoadingStatus.finished,
      ),
    );
  }

  void skipVideo() {
    emit(
      state.copyWith(
        skipVideo: !state.skipVideo,
      ),
    );
  }
}
