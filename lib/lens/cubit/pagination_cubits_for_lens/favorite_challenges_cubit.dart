import 'package:http/http.dart';

import 'package:voccent/http/response_data.dart';
import 'package:voccent/lens/cubit/models/favorite_challenge/favorite_challenge.dart';
import 'package:voccent/pagination/pagination_cubit.dart';
import 'package:voccent/pagination/pagination_state.dart';

typedef FavoriteChallengeState = PaginationState<FavoriteChallenge>;

class FavoriteChallengeCubit extends PaginationCubit<FavoriteChallenge> {
  FavoriteChallengeCubit(
    this._client,
  ) : super();

  final Client _client;

  @override
  Future<List<FavoriteChallenge>> loadDataList([int offset = 0]) async {
    final uriString = 'api/v1/challenges/favorited?limit=$limit&offset=$offset';

    final uri = Uri.parse(uriString);
    final response = await _client.get(uri).listData();
    final items = response
        .map((e) => FavoriteChallenge.fromJson(e as Map<String, dynamic>))
        .toList();

    return items;
  }
}
