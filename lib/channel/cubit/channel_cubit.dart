import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/channel/cubit/models/channel_summary/channel_summary.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_object.dart';
import 'package:voccent/feed/cubit/models/feed_page.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'channel_state.dart';

class ChannelCubit extends Cubit<ChannelState> {
  ChannelCubit(
    this._client,
    this._sharedPreferences,
    this._updaterService,
  ) : super(const ChannelState());

  @override
  void emit(ChannelState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  static const itemsPerPage = 20;

  final Client _client;
  final SharedPreferences _sharedPreferences;
  final UpdaterService _updaterService;

  Future<void> fetchChannel(String channelId) async {
    final channel = FeedObject.fromJson(
      await _client
          .get(
            Uri.parse(
              '/api/v1/channel/id/$channelId',
            ),
          )
          .mapData(),
    );
    _setRecentChannel(channel: channel);
    emit(
      state.copyWith(channel: channel),
    );
    await _fetchChannelSummary(channelId);
  }

  Future<void> fetchChannelByName(String channelName) async {
    final channel = FeedObject.fromJson(
      await _client
          .get(
            Uri.parse(
              '/api/v1/channel/name/$channelName',
            ),
          )
          .mapData(),
    );
    _setRecentChannel(channel: channel);
    emit(
      state.copyWith(channel: channel),
    );
  }

  void _setRecentChannel({
    required FeedObject channel,
  }) {
    final recentChannelsJson = _sharedPreferences.getString('recent_channel');
    var recentChannels = <FeedObject>[];
    if (recentChannelsJson != null) {
      final decodedList = json.decode(recentChannelsJson) as List<dynamic>;
      recentChannels = decodedList
          .map((item) => FeedObject.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final newChannel = channel;
    recentChannels
      ..removeWhere((existingChannel) => existingChannel.id == channel.id)
      ..insert(0, newChannel);
    final updatedChannelsJson =
        json.encode(recentChannels.map((channel) => channel.toJson()).toList());
    _sharedPreferences.setString('recent_channel', updatedChannelsJson);
    _updaterService.addItemToRecent(null);
  }

  Future<void> _fetchChannelSummary(String channelId) async {
    final response = await _client
        .get(
          Uri.parse(
            'api/v1/channel_summary/id/$channelId',
          ),
        )
        .mapData();

    final channelSummary = ChannelSummary.fromJson(response);
    emit(state.copyWith(channelSummary: channelSummary));
  }

  FeedModel feedItem(int index) {
    if (state.channel == null) {
      return const FeedModel();
    }

    // Compute the starting index of the page where this challenge is located.
    // For example, if [index] is `42` and [itemsPerPage] is `20`,
    // then `index ~/ itemsPerPage` (integer division)
    // evaluates to `2`, and `2 * 20` is `40`.
    final startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    if (state.pages.containsKey(startingIndex)) {
      if (state.pages[startingIndex]!.isLoading) {
        // In the meantime, return a placeholder.
        return const FeedModel();
      } else {
        // If the corresponding page is already in memory, return immediately.
        return state.pages[startingIndex]!.items[index - startingIndex];
      }
    } else {
      // We don't have the data yet. Start fetching it.
      _loadPage(startingIndex);
      return const FeedModel();
    }
  }

  /// This method initiates fetching of the [FeedModel]
  /// at [startingIndex].
  Future<void> _loadPage(int startingIndex) async {
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
          ..[startingIndex] = await _fetchPage(startingIndex),
      ),
    );
  }

  /// It will fetch a page of items from [startingIndex].
  Future<FeedPage> _fetchPage(int startingIndex) async {
    if (state.channel?.id == null) {
      return const FeedPage(isLoading: true);
    }

    final queryParameters = <String, dynamic>{
      'channel': state.channel!.id,
      'offset': '$startingIndex',
      'limit': '$itemsPerPage',
      'recent': '1',
      'rated': '0',
      'popular': '0',
      'random': '0',
      // 'userLevel': 'B1',
    };

    if (state.tab != FeedTab.feed) {
      queryParameters['type'] = state.tab.name;
    }

    if (state.query.isNotEmpty) {
      queryParameters['q'] = state.query;
    }

    final uri = Uri.parse('/api/v1/search/feed')
        .replace(queryParameters: queryParameters);
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

  void setQuery(String query) {
    emit(
      state.copyWith(
        query: query,
        pages: {},
      ),
    );
  }

  void setTab(FeedTab tab) => emit(state.copyWith(tab: tab, pages: {}));

  void startNewFeed() {
    emit(state.copyWith(pages: {}));
  }
}
