import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';

import 'package:voccent/http/response_data.dart';
import 'package:voccent/pagination/pagination_cubit.dart';
import 'package:voccent/pagination/pagination_state.dart';

typedef PlaylistForLensState = PaginationState<FeedModel>;

class PlaylistForLensCubit extends PaginationCubit<FeedModel> {
  PlaylistForLensCubit(
    this._client,
    this.platformLanguageId,
    this.userCurrentLanguages,
    this._sharedPreferences,
  ) : super();

  final Client _client;
  final String platformLanguageId;
  final List<UserLanguage> userCurrentLanguages;
  final SharedPreferences _sharedPreferences;

  @override
  Future<List<FeedModel>> loadDataList([int offset = 0]) async {
    var sourceLanguageGroup = 0;
    var myOffset = 0;
    const uriString = '/api/v1/search/feed';

    final allItems = state.list;
    if (allItems.isNotEmpty) {
      sourceLanguageGroup = allItems.last.sourceLanguageGroup ?? 0;

      myOffset = allItems
          .where(
            (element) => element.sourceLanguageGroup == sourceLanguageGroup,
          )
          .length;
    }

    final queryParameters = <String, dynamic>{
      'offset': '$myOffset',
      'limit': '$limit',
      'recent': '0',
      'rated': '0',
      'popular': '0',
      'random': '1',
      'sourceLanguageGroup': '$sourceLanguageGroup',
      'type': 'playlist',
    };

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
// source languages
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
        .map((e) => FeedModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return items;
  }
}
