import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/classroom_search/cubit/models/classroom_search_model.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_object.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/lens/cubit/models/lens_v2/compare_level.dart';
import 'package:voccent/lens/cubit/models/lens_v2/count_compare_by_date.dart';
import 'package:voccent/lens/cubit/models/lens_v2/my_classrooms_model.dart';
import 'package:voccent/lens/cubit/models/lens_v2/recommendations_item.dart';
import 'package:voccent/mixer/cubit/models/mixer_model/mixer_model.dart';
import 'package:voccent/playlist/cubit/models/playlist.dart';
import 'package:voccent/story/cubit/models/story.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'lens_state.dart';

class LensCubit extends HydratedCubit<LensState> {
  LensCubit(
    this._client,
    this.platformLanguageId,
    this.userCurrentLanguages,
    this._sharedPreferences,
    this._updaterService,
  ) : super(
          const LensState(),
        ) {
    _recentClassroomsRefreshSubscription = _updaterService.recentClassroomUpdate
        .listen((event) => getRecentItems());
    _recentChallengesRefreshSubscription =
        _updaterService.recentItemAdded.listen((event) => getRecentItems());
    _fetchMyClassroomsSubscription = _updaterService.myClassroomsFetch
        .listen((event) => fetchMyClassrooms());
    _updateDailyProgressSubscription = _updaterService.dailyProgressFetch
        .listen((event) => loadUserCountCompareByDate());
  }
  @override
  LensState? fromJson(Map<String, dynamic> json) {
    return LensState(
      classroom: (json['classroom'] as List)
          .map((e) => ClassroomSearchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentClassrooms: List<String>.from(json['recentClassrooms'] as List),
      recommendationsItem: (json['lensItem'] as List)
          .map((e) => RecommendationsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(LensState state) {
    return {
      'classroom': state.classroom.map((model) => model.toJson()).toList(),
      'recentClassrooms': state.recentClassrooms,
      'lensItem':
          state.recommendationsItem.map((item) => item.toJson()).toList(),
    };
  }

  @override
  void emit(LensState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  final Client _client;
  final String platformLanguageId;
  final List<UserLanguage> userCurrentLanguages;
  final SharedPreferences _sharedPreferences;
  final UpdaterService _updaterService;

  StreamSubscription<String>? _recentClassroomsRefreshSubscription;
  StreamSubscription<Object?>? _recentChallengesRefreshSubscription;
  StreamSubscription<Object?>? _fetchMyClassroomsSubscription;
  StreamSubscription<Object?>? _updateDailyProgressSubscription;

  Future<void> getData() async {
    await fetchClassrooms();
    getRecentItems();
    await fetchRecommendationsItems();
    await mixerAvailabilityCheck();
    await loadUserCountCompareByDate();
    await loadUserCompareLevel();
    await fetchMyClassrooms();
  }

  Future<void> refresh() async {
    emit(
      state.copyWith(
        refresh: true,
      ),
    );
    await getData().then(
      (value) => emit(
        state.copyWith(refresh: false),
      ),
    );
  }

  Future<void> fetchClassrooms() async {
    final queryParameters = <String, dynamic>{
      'limit': '100',
      'sourceLanguageGroup': '0',
    };
    const uriString = '/api/v1/search/classroom';

    final languageFilter = _sharedPreferences.getString(
      'search_language_filter',
    );
    if (languageFilter != null) {
      final languages = json.decode(languageFilter) as List<dynamic>;
      final selectedLanguages = languages
          .map(
            (dynamic e) => UserLanguage.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      queryParameters['languageID'] =
          List<String>.from(selectedLanguages.map<String>((e) => e.id))
              .join(',');
    }

    if (platformLanguageId != '') {
      queryParameters['sourceLocaleLanguageID'] = platformLanguageId;
    }
    final sourceLang = List<String>.from(
      userCurrentLanguages.map<String>((e) => e.id),
    ).join(',');
    queryParameters['sourceLanguageIDs'] = sourceLang;

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await _client.get(uri).listData();
    final items = response
        .map((e) => ClassroomSearchModel.fromJson(e as Map<String, dynamic>))
        .toList();

    emit(
      state.copyWith(
        classroom: items,
      ),
    );
  }

  Future<void> fetchRecommendationsItems() async {
    emit(
      state.copyWith(
        recommendationsItem: [],
        currentIndex: 0,
      ),
    );
    await fetchMoreRecommendationsItems(limit: 12);
  }

  Future<void> fetchMoreRecommendationsItems({required int limit}) async {
    final response = await _client
        .get(
          Uri.parse(
            'api/v1/recommendation/user?Limit=$limit&GroupID=${state.groupId}',
          ),
        )
        .mapData();

    var lensItem = <RecommendationsItem>[];
    if (response['List'] != null) {
      lensItem = (response['List'] as List<dynamic>)
          .map(
            (dynamic e) =>
                RecommendationsItem.fromJson(e as Map<String, dynamic>),
          )
          .cast<RecommendationsItem>()
          .toList();
    }
    var groupId = state.groupId;
    if (response['GroupID'] != null) {
      groupId = response['GroupID'] as String;
    }
    final updatedItems =
        List<RecommendationsItem>.from(state.recommendationsItem)
          ..addAll(lensItem);

    emit(
      state.copyWith(
        recommendationsItem: updatedItems,
        groupId: groupId,
      ),
    );
  }

  void setIndexForRecommendationsPass(int currentIndex) {
    emit(
      state.copyWith(
        currentIndex: currentIndex,
      ),
    );
  }

  Future<void> mixerAvailabilityCheck() async {
    final response = await _client.get(Uri.parse('/api/v1/mixer'));

    emit(
      state.copyWith(
        mixerModel: response.hasMapData()
            ? MixerModel.fromJson(response.mapData())
            : null,
      ),
    );
  }

  Future<void> loadUserCountCompareByDate() async {
    final response = await _client.get(
      Uri.parse(
        '/api/v1/statistics/user/user_count_compare_by_date',
      ),
    );

    final jsonData = json.decode(response.body) as Map<String, dynamic>;

    final listData = jsonData['List'] as List<dynamic>;
    final listOfCompare = listData
        .map((e) => CountCompareByDate.fromJson(e as Map<String, dynamic>))
        .toList();

    emit(
      state.copyWith(
        countCompareByDate: listOfCompare,
      ),
    );
  }

  Future<void> loadUserCompareLevel() async {
    final response = await _client.get(
      Uri.parse('/api/v1/statistics/user/user_compare_level'),
    );

    final jsonData = json.decode(response.body) as Map<String, dynamic>;

    if (jsonData['List'] != null) {
      final userCompareLevel = (jsonData['List'] as List<dynamic>)
          .map(
            (dynamic e) => CompareLevel.fromJson(e as Map<String, dynamic>),
          )
          .cast<CompareLevel>()
          .toList();

      emit(
        state.copyWith(
          userCompareLevel: userCompareLevel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          userCompareLevel: [],
        ),
      );
    }
  }

  void getRecentItems() {
    final recentClassrooms = _sharedPreferences.getStringList(
      'recent_classrooms_ids',
    );

    emit(
      state.copyWith(
        recentClassrooms: recentClassrooms,
      ),
    );

    final recentChallengesJson = _sharedPreferences.getString(
      'recent_challenge',
    );
    var recentChallenges = <Challenge>[];
    if (recentChallengesJson != null) {
      final decodedList = json.decode(recentChallengesJson) as List<dynamic>;
      recentChallenges = decodedList
          .map((item) => Challenge.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    emit(
      state.copyWith(
        recentChallenges: recentChallenges,
      ),
    );
    final recentStoriesJson = _sharedPreferences.getString(
      'recent_story',
    );
    var recentStories = <Story>[];
    if (recentStoriesJson != null) {
      final decodedList = json.decode(recentStoriesJson) as List<dynamic>;
      recentStories = decodedList
          .map((item) => Story.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    emit(
      state.copyWith(
        recentStories: recentStories,
      ),
    );
    final recentPlaylistsJson = _sharedPreferences.getString('recent_playlist');

    var recentPlaylists = <Playlist>[];

    if (recentPlaylistsJson != null) {
      final decodedList = json.decode(recentPlaylistsJson) as List<dynamic>;
      recentPlaylists = decodedList
          .map((item) => Playlist.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    emit(
      state.copyWith(
        recentPlaylists: recentPlaylists,
      ),
    );
    final recentChannelsJson = _sharedPreferences.getString('recent_channel');
    var recentChannels = <FeedObject>[];

    if (recentChannelsJson != null) {
      final decodedList = json.decode(recentChannelsJson) as List<dynamic>;
      recentChannels = decodedList
          .map((item) => FeedObject.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    emit(
      state.copyWith(
        recentChannels: recentChannels,
      ),
    );
  }

  Future<void> fetchMyClassrooms() async {
    const uriString = '/api/v1/classroom/user';
    final uri = Uri.parse(uriString);
    final response = await _client.get(uri);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;

    final classroomsData = responseBody['data'] as List?;

    final myClassrooms = classroomsData?.map(
      (dynamic e) {
        final classroom =
            (e as Map<String, dynamic>)['Classroom'] as Map<String, dynamic>;
        return MyClassroom.fromJson(classroom);
      },
    ).toList();

    emit(
      state.copyWith(
        myClassrooms: myClassrooms,
      ),
    );
  }

  @override
  Future<void> close() {
    _recentClassroomsRefreshSubscription?.cancel();
    _recentChallengesRefreshSubscription?.cancel();
    _fetchMyClassroomsSubscription?.cancel();
    _updateDailyProgressSubscription?.cancel();
    return super.close();
  }
}
