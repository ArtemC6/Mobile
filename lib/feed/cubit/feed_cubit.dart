import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/dictionary/cubit/languages_translate.dart';
import 'package:voccent/feed/cubit/models/category.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/feed/cubit/models/feed_page.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(
    this._client,
    this._sharedPreferences,
    List<UserLanguage> userLanguages,
    List<UserLanguage> userCurrentLanguages,
    String platformLanguageId,
  ) : super(
          FeedState(
            userLanguages: userLanguages,
            userCurrentLanguages: userCurrentLanguages,
            platformLanguageId: platformLanguageId,
          ),
        ) {
    _translateAndSetUserLanguages(userLanguages);
    _loadLanguageFilter();
  }

  @override
  void emit(FeedState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  static const itemsPerPage = 20;

  final Client _client;
  final SharedPreferences _sharedPreferences;

  Future<void> loadFilters() async {
    _loadLanguageFilter();
    if (state.categories.isEmpty) {
      await _fetchCategoryTree();
    }
  }

  Future<void> _fetchCategoryTree() async {
    final response =
        await _client.get(Uri.parse('/api/v1/category/tree')).listData();

    final categoryTree = response
        .map(
          (dynamic e) => Category.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    emit(
      state.copyWith(
        categories: categoryTree,
      ),
    );
  }

  void _loadLanguageFilter() {
    final languageFilter = _sharedPreferences.getString(
      'search_language_filter',
    );

    if (languageFilter == null) {
      emit(state.copyWith(selectedLanguages: state.userLanguages));
    } else {
      final languages = json.decode(languageFilter) as List<dynamic>;
      final selectedLanguages = languages
          .map(
            (dynamic e) => UserLanguage.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      emit(state.copyWith(selectedLanguages: selectedLanguages));
    }
  }

  void setPeriodFilter(FeedPeriodFilter period) {
    final now = DateTime.now();

    switch (period) {
      case FeedPeriodFilter.whenever:
        emit(
          state.copyWith(
            period: period,
          ),
        );

      case FeedPeriodFilter.today:
        final today = DateTime(now.year, now.month, now.day);
        emit(
          state.copyWith(
            period: period,
            customPeriodFrom: today,
            customPeriodTo: now,
          ),
        );

      case FeedPeriodFilter.yesterday:
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        emit(
          state.copyWith(
            period: period,
            customPeriodFrom: yesterday,
            customPeriodTo: now,
          ),
        );

      case FeedPeriodFilter.last7days:
        emit(
          state.copyWith(
            period: period,
            customPeriodFrom: DateTime.now().subtract(const Duration(days: 7)),
            customPeriodTo: now,
          ),
        );

      case FeedPeriodFilter.last30days:
        emit(
          state.copyWith(
            period: period,
            customPeriodFrom: DateTime.now().subtract(const Duration(days: 30)),
            customPeriodTo: now,
          ),
        );

      case FeedPeriodFilter.customPeriod:
        break;
    }
  }

  void setCustomPeriodFrom(DateTime value) {
    emit(
      state.copyWith(
        period: FeedPeriodFilter.customPeriod,
        customPeriodFrom: value,
      ),
    );
  }

  void setCustomPeriodTo(DateTime value) {
    emit(
      state.copyWith(
        period: FeedPeriodFilter.customPeriod,
        customPeriodTo: value,
      ),
    );
  }

  void setLevelFilter(RangeValues values) {
    emit(
      state.copyWith(
        levelFrom: values.start.round(),
        levelTo: values.end.round(),
      ),
    );
  }

  void setStoryTypeFilter(int value) {
    emit(
      state.copyWith(
        storyModeType: value,
      ),
    );
  }

  FeedModel feedItem(int index) {
    // Compute the starting index of the page where this challenge is located.
    // For example, if [index] is `42` and [itemsPerPage] is `20`,
    // then `index ~/ itemsPerPage` (integer division)
    // evaluates to `2`, and `2 * 20` is `40`.
    final startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    // If the corresponding page is already in memory, return immediately.
    if (state.pages[startingIndex]?.isLoading == false) {
      return state.pages[startingIndex]!.items[index - startingIndex];
    } else if (!state.pages.containsKey(startingIndex)) {
      // We don't have the data yet. Start fetching it.
      _loadPage(startingIndex);
    }

    // In the meantime, return a placeholder.
    return const FeedModel();
  }

  /// This method initiates fetching of the [FeedModel]
  /// at [startingIndex].
  Future<void> _loadPage(int startingIndex) async {
    if (state.pages[startingIndex]?.isLoading ?? false) {
      // Page is already being fetched. Ignore the redundant call.
      return;
    }

    emit(
      state.copyWith(
        pages: Map<int, FeedPage>.from(state.pages)
          ..[startingIndex] = const FeedPage(isLoading: true),
      ),
    );

    // Store the new page.
    emit(
      state.copyWith(
        pages: Map<int, FeedPage>.from(state.pages)
          ..[startingIndex] = await _fetchPage(),
      ),
    );

    // We shouldn't prune cache as we always fetch next pages only (PR #848)
    // _pruneCache(startingIndex);
  }

  Future<FeedPage> _fetchPage() async {
    var sourceLanguageGroup = 0;
    var offset = 0;

    final allItems = state.pages.values.expand((e) => e.items).toList();
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
      'recent': '0',
      'rated': '0',
      'popular': '0',
      'random': '1',
      'sourceLanguageGroup': '$sourceLanguageGroup',
    };

    const uriString = '/api/v1/search/feed';

    if (state.tab != FeedTab.feed) {
      queryParameters['type'] = state.tab.name;
    }

    if (state.query.isNotEmpty) {
      queryParameters['q'] = state.query;
    }

    if (state.selectedCategory != null) {
      queryParameters['cat'] = state.selectedCategory;
    }

    if (state.selectedLanguages.isNotEmpty) {
      queryParameters['languageID'] =
          List<String>.from(state.selectedLanguages.map<String>((e) => e.id))
              .join(',');
    }

    if (state.author.isNotEmpty) {
      queryParameters['author'] = state.author;
    }

    if (state.period != FeedPeriodFilter.whenever) {
      final f = DateFormat('yyyy/MM/dd');

      if (state.customPeriodFrom != null) {
        queryParameters['after'] = f.format(state.customPeriodFrom!);
      }
      if (state.customPeriodTo != null) {
        queryParameters['before'] = f.format(state.customPeriodTo!);
      }
    }

    if (state.levelFrom != 1) {
      queryParameters['levelMin'] = state.levelFrom.toString();
    }

    if (state.levelTo != 100) {
      queryParameters['levelMax'] = state.levelTo.toString();
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

    if (state.storyModeType != -1) {
      queryParameters['modeType'] = state.storyModeType.toString();
    }

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await _client.get(uri).listData();
    final items = response
        .map(
          (dynamic e) => FeedModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    return FeedPage(
      isLoading: false,
      items: items,
    );
  }

  // /// Removes pages that are too far away from [startingIndex].
  // void _pruneCache(int startingIndex) {
  //   final pages = Map<int, FeedPage>.from(state.pages);

  //   // It's bad practice to modify collections while iterating over them.
  //   // So instead, we'll store the keys to remove in a separate Set.
  //   final keysToRemove = <int>{};
  //   for (final key in pages.keys) {
  //     if ((key - startingIndex).abs() > maxCacheDistance) {
  //       // This page's starting index is too far away from the current one.
  //       // We'll remove it.
  //       keysToRemove.add(key);
  //     }
  //   }

  //   for (final key in keysToRemove) {
  //     pages.remove(key);
  //   }

  //   emit(state.copyWith(pages: pages));
  // }

  void setQuery(String query) => emit(state.copyWith(query: query, pages: {}));

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

  void setTab(FeedTab tab) => emit(state.copyWith(tab: tab, pages: {}));

  void clearFilters() => emit(state.copyWithNoFilter());

  void startNewFeed() {
    emit(state.copyWith(pages: {}));

    if (state.selectedLanguages.length == 1) {
      FirebaseAnalytics.instance.logEvent(
        name: 'searchByLanguage',
        parameters: {
          'event_category': 'Search',
          'event_label':
              'Search filter by language ${state.selectedLanguages[0].name}',
        },
      );
    } else if (state.selectedLanguages.length > 1) {
      FirebaseAnalytics.instance.logEvent(
        name: 'searchByLanguage',
        parameters: {
          'event_category': 'Search',
          'event_label': 'Search filter by multiple languages',
        },
      );
    }

    if (state.selectedCategory != null) {
      FirebaseAnalytics.instance.logEvent(
        name: 'searchByCategory',
        parameters: {
          'event_category': 'Search',
          'event_label': 'Search filter by category ${state.selectedCategory!}',
        },
      );
    }

    if (state.author != '') {
      FirebaseAnalytics.instance.logEvent(
        name: 'searchByAuthor',
        parameters: {
          'event_category': 'Search',
          'event_label': 'Search filter by author ${state.author}',
        },
      );
    }

    if (state.period != FeedPeriodFilter.whenever) {
      if (state.period == FeedPeriodFilter.customPeriod) {
        FirebaseAnalytics.instance.logEvent(
          name: 'searchByPeriodRange',
          parameters: {
            'event_category': 'Search',
            'event_label': '''
                Search filter by period range 
                ${state.customPeriodFrom} - ${state.customPeriodTo}
                ''',
          },
        );
      } else {
        FirebaseAnalytics.instance.logEvent(
          name: 'searchByPeriodDate',
          parameters: {
            'event_category': 'Search',
            'event_label': 'Search filter by period date ${state.periodString}',
          },
        );
      }
    }

    if (state.levelFrom > 1 || state.levelTo < 100) {
      FirebaseAnalytics.instance.logEvent(
        name: 'searchByLevel',
        parameters: {
          'event_category': 'Search',
          'event_label':
              'Search filter by level ${state.levelFrom} - ${state.levelTo}',
        },
      );
    }

    _sharedPreferences.setString(
      'search_language_filter',
      json.encode(state.selectedLanguages),
    );
  }

  void setAuthorFilter(String value) => emit(state.copyWith(author: value));

  void setCategoryFilter(String category) =>
      emit(state.copyWith(selectedCategory: category));

  void setLanguageFilter(UserLanguage language) {
    final s = List<UserLanguage>.from(state.selectedLanguages);

    if (!s.any((e) => e.id == language.id)) {
      s.add(language);
    } else {
      s.removeWhere((e) => e.id == language.id);
    }

    emit(state.copyWith(selectedLanguages: s));
  }

  void setPurchaseOfQuota() {
    FirebaseAnalytics.instance.logEvent(
      name: 'purchaseOfQuota',
      parameters: {
        'category': 'Story',
      },
    );
  }

  void setAllLanguages() {
    if (state.userLanguages.length == state.selectedLanguages.length) {
      emit(state.copyWith(selectedLanguages: []));
    } else {
      final selectedLanguages = state.userLanguages;
      emit(state.copyWith(selectedLanguages: selectedLanguages));
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
}
