import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/challenge/cubit/models/rating/rating.dart';
import 'package:voccent/http/response_data.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit(this._client) : super(const RatingState());

  final Client _client;

  @override
  void emit(RatingState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  Future<void> loadRating(String challengeId) async {
    emit(state.copyWith(challengeId: challengeId, loadingRating: true));

    final response =
        await _client.get(Uri.parse('/api/v1/rating/${state.challengeId}'));

    final rating =
        response.hasMapData() ? Rating.fromJson(response.mapData()) : null;

    emit(
      state.copyWith(
        rating: rating?.score ?? 0,
        loadingRating: false,
      ),
    );
  }

  Future<void> updateRating(double rating) async {
    if (state.loadingRating) {
      return;
    }

    emit(state.copyWith(loadingRating: true));

    try {
      await _client.post(
        Uri.parse(
          '/api/v1/rating/challenge/${state.challengeId}',
        ),
        body: '{"Score":${rating.round()}}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      emit(
        state.copyWith(
          loadingRating: false,
          rating: rating,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          rating: 0,
          loadingRating: false,
        ),
      );
      rethrow;
    }
  }
}
