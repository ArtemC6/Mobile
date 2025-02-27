import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/challenge/cubit/models/challenge_favorite/challenge_favorite.dart';
import 'package:voccent/http/response_data.dart';

part 'challenge_favorite_state.dart';

class ChallengeFavoriteCubit extends Cubit<ChallengeFavoriteState> {
  ChallengeFavoriteCubit(this._client) : super(const ChallengeFavoriteState());

  final Client _client;

  @override
  void emit(ChallengeFavoriteState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  Future<void> loadChallengeFavorite(String challengeId) async {
    emit(
      state.copyWith(challengeFavoriteStatus: ChallengeFavoriteStatus.loading),
    );

    try {
      final response = await _client
          .get(Uri.parse('/api/v1/favorite/object/challenge/$challengeId'))
          .mapData();

      final challengeFavorite = ChallengeFavorite.fromJson(response);

      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.ready,
          isChallengeFavorite: challengeFavorite.isFavorite,
          challengeId: challengeId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.failed,
        ),
      );
      rethrow;
    }
  }

  Future<void> updateFavorite() async {
    if (state.challengeId == null ||
        state.challengeFavoriteStatus == ChallengeFavoriteStatus.loading) {
      return;
    }

    if (state.isChallengeFavorite) {
      await removeFromFavorites();
    } else {
      await addToFavorites();
    }
  }

  Future<void> addToFavorites() async {
    emit(
      state.copyWith(challengeFavoriteStatus: ChallengeFavoriteStatus.loading),
    );

    try {
      await _client.post(
        Uri.parse(
          '/api/v1/favorite/challenge/${state.challengeId}',
        ),
      );

      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.ready,
          isChallengeFavorite: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.failed,
        ),
      );
      rethrow;
    }
  }

  Future<void> removeFromFavorites() async {
    emit(
      state.copyWith(challengeFavoriteStatus: ChallengeFavoriteStatus.loading),
    );

    try {
      await _client.delete(
        Uri.parse(
          '/api/v1/favorite/challenge/${state.challengeId}',
        ),
      );

      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.ready,
          isChallengeFavorite: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          challengeFavoriteStatus: ChallengeFavoriteStatus.failed,
        ),
      );
      rethrow;
    }
  }
}
