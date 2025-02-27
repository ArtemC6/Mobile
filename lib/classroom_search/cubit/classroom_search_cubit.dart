import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/classroom_search/cubit/models/classroom_search_model.dart';
import 'package:voccent/classroom_search/cubit/models/classroom_search_page.dart';
import 'package:voccent/dictionary/cubit/languages_translate.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'classroom_search_state.dart';

class ClassroomSearchCubit extends Cubit<ClassroomSearchState> {
  ClassroomSearchCubit(
    this._client,
    this._sharedPreferences,
    this._updaterService,
    List<UserLanguage> userLanguages,
    List<UserLanguage> userCurrentLanguages,
    String platformLanguageId,
  ) : super(
          ClassroomSearchState(
            userLanguages: userLanguages,
            userCurrentLanguages: userCurrentLanguages,
            platformLanguageId: platformLanguageId,
          ),
        ) {
    _translateAndSetUserLanguages(userLanguages);
    loadLanguageFilter();
    _updateMembersOfClassroomSubscription = _updaterService
        .classroomMembersUpdate
        .listen((event) => startNewSearch());
  }

  @override
  void emit(ClassroomSearchState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  static const maxCacheDistance = 100;
  static const itemsPerPage = 20;

  final Client _client;
  final SharedPreferences _sharedPreferences;
  final UpdaterService _updaterService;

  StreamSubscription<Object?>? _updateMembersOfClassroomSubscription;

  void loadLanguageFilter() {
    final languageFilter = _sharedPreferences.getString(
      'search_language_filter',
    );

    if (languageFilter == null) {
      emit(
        state.copyWith(
          selectedLanguages: state.userLanguages,
          selectedLanguages_: state.userLanguages,
        ),
      );
    } else {
      final languages = json.decode(languageFilter) as List<dynamic>;
      final selectedLanguages = languages
          .map(
            (dynamic e) => UserLanguage.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      emit(
        state.copyWith(
          selectedLanguages: selectedLanguages,
          selectedLanguages_: selectedLanguages,
        ),
      );
    }
  }

  // void setLevelFilter(RangeValues values) {
  //   emit(
  //     state.copyWith(
  //       levelFrom: values.start.round(),
  //       levelTo: values.end.round(),
  //     ),
  //   );
  // }

  ClassroomSearchModel searchClassroomItem(int index) {
    // Compute the starting index of the page where this challenge is located.
    // For example, if [index] is `42` and [itemsPerPage] is `20`,
    // then `index ~/ itemsPerPage` (integer division)
    // evaluates to `2`, and `2 * 20` is `40`.
    final startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    // If the corresponding page is already in memory, return immediately.
    if (state.searchClassromPages[startingIndex]?.isLoading == false) {
      return state
          .searchClassromPages[startingIndex]!.items[index - startingIndex];
    } else if (!state.searchClassromPages.containsKey(startingIndex)) {
      // We don't have the data yet. Start fetching it.
      _loadSearchClassroomPage(startingIndex);
    }

    // In the meantime, return a placeholder.
    return const ClassroomSearchModel();
  }

  /// This method initiates fetching of the [ClassroomSearchModel]
  /// at [startingIndex].
  Future<void> _loadSearchClassroomPage(int startingIndex) async {
    if (state.searchClassromPages[startingIndex]?.isLoading ?? false) {
      // Page is already being fetched. Ignore the redundant call.
      return;
    }

    emit(
      state.copyWith(
        searchClassromPages:
            Map<int, ClassroomSearchPage>.from(state.searchClassromPages)
              ..[startingIndex] = const ClassroomSearchPage(isLoading: true),
      ),
    );

    // Store the new page.
    emit(
      state.copyWith(
        searchClassromPages:
            Map<int, ClassroomSearchPage>.from(state.searchClassromPages)
              ..[startingIndex] = await _fetchSearhClassroomPage(),
      ),
    );

    _pruneCache(startingIndex);
  }

  Future<ClassroomSearchPage> _fetchSearhClassroomPage() async {
    var sourceLanguageGroup = 0;
    var offset = 0;

    final allItems =
        state.searchClassromPages.values.expand((e) => e.items).toList();
    if (allItems.isNotEmpty) {
      sourceLanguageGroup = allItems.last.sourceLanguageGroup ?? 0;

      offset = allItems
          .where(
            (element) => element.sourceLanguageGroup == sourceLanguageGroup,
          )
          .length;
    }

    final queryParameters = <String, dynamic>{
      'offset': '$offset',
      'limit': '$itemsPerPage',
      'sourceLanguageGroup': '$sourceLanguageGroup',
    };

    const uriString = '/api/v1/search/classroom';

    if (state.query.isNotEmpty) {
      queryParameters['q'] = state.query;
    }

    if (state.selectedLanguages.isNotEmpty) {
      queryParameters['languageID'] =
          List<String>.from(state.selectedLanguages.map<String>((e) => e.id))
              .join(',');
    }

    // source languages
    if (state.platformLanguageId != '') {
      queryParameters['sourceLocaleLanguageID'] = state.platformLanguageId;
    }

    if (state.userCurrentLanguages.isNotEmpty) {
      final sourceLang = List<String>.from(
        state.userCurrentLanguages.map<String>((e) => e.id),
      ).join(',');
      queryParameters['sourceLanguageIDs'] = sourceLang;
    }

    if (state.sourceLanguages == true) {
      queryParameters['sourceLanguages'] = 'true';
    }

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await _client.get(uri).listData();

    final items = response
        .map(
          (dynamic e) =>
              ClassroomSearchModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    return ClassroomSearchPage(
      isLoading: false,
      items: items,
    );
  }

  /// Removes pages that are too far away from [startingIndex].
  void _pruneCache(int startingIndex) {
    final pages = Map<int, ClassroomSearchPage>.from(state.searchClassromPages);

    // It's bad practice to modify collections while iterating over them.
    // So instead, we'll store the keys to remove in a separate Set.
    final keysToRemove = <int>{};
    for (final key in pages.keys) {
      if ((key - startingIndex).abs() > maxCacheDistance) {
        // This page's starting index is too far away from the current one.
        // We'll remove it.
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      pages.remove(key);
    }

    emit(state.copyWith(searchClassromPages: pages));
  }

  void setQuery(String query) =>
      emit(state.copyWith(query: query, searchClassromPages: {}));

  void clearFilters() {
    emit(state.copyWithNoFilter());
    _sharedPreferences.setString(
      'search_language_filter',
      json.encode(state.selectedLanguages),
    );
  }

  void startNewSearch() {
    emit(
      state.copyWith(
        searchClassromPages: {},
        selectedLanguages: state.selectedLanguages_,
      ),
    );

    _sharedPreferences.setString(
      'search_language_filter',
      json.encode(state.selectedLanguages),
    );
  }

  void setLanguageFilter(UserLanguage language) {
    final s = List<UserLanguage>.from(state.selectedLanguages_);

    if (!s.any((e) => e.id == language.id)) {
      s.add(language);
    } else {
      s.removeWhere((e) => e.id == language.id);
    }

    emit(state.copyWith(selectedLanguages_: s));
  }

  void setAllLanguages() {
    if (state.userLanguages.length == state.selectedLanguages_.length) {
      emit(state.copyWith(selectedLanguages_: []));
    } else {
      final selectedLanguages = state.userLanguages;
      emit(state.copyWith(selectedLanguages_: selectedLanguages));
    }
  }

  void setSourceLanguages() {
    emit(state.copyWith(sourceLanguages_: !state.sourceLanguages_));
  }

  void fillFilterForm() {
    emit(state.copyWith(sourceLanguages_: state.sourceLanguages));
  }

  void applyFilterForm() {
    emit(state.copyWith(sourceLanguages: state.sourceLanguages_));
  }

  void saveSearchHistory(String query) {
    if (query.isNotEmpty) {
      var searchHistory =
          _sharedPreferences.getString('search_history')?.split(',') ?? [];

      if (searchHistory.contains(query)) {
        searchHistory.remove(query);
      }
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.take(10).toList();
      }
      _sharedPreferences.setString('search_history', searchHistory.join(','));
    }
  }

  List<String> getSearchHistory() {
    final searchHistory =
        _sharedPreferences.getString('search_history')?.split(',') ?? [];
    return searchHistory;
  }

  void clearSearchHistory() {
    _sharedPreferences.remove('search_history');
  }

  void _translateAndSetUserLanguages(List<UserLanguage> userLanguages) {
    final translatedLanguages = userLanguages.map((language) {
      final translatedName = translateLanguageById(language.id);
      return UserLanguage(
        id: language.id,
        name: translatedName ?? language.name,
      );
    }).toList();

    emit(state.copyWith(userLanguages: translatedLanguages));
  }

  void setRecentClassroom(String id) {
    final recentClassrooms =
        _sharedPreferences.getStringList('recent_classrooms_ids') ?? [];

    if (recentClassrooms.contains(id)) {
      recentClassrooms
        ..remove(id)
        ..insert(0, id);

      _sharedPreferences.setStringList(
        'recent_classrooms_ids',
        recentClassrooms,
      );
    } else {
      recentClassrooms.insert(0, id);

      _sharedPreferences.setStringList(
        'recent_classrooms_ids',
        recentClassrooms,
      );
    }
  }

  @override
  Future<void> close() {
    _updateMembersOfClassroomSubscription?.cancel();
    return super.close();
  }
}
