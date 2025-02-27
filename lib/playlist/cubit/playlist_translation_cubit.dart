import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/cubit/models/translate.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/http/response_data.dart';

part 'playlist_translation_state.dart';

class PlaylistTranslationCubit extends Cubit<PlaylistSpellingState> {
  PlaylistTranslationCubit(
    this._client,
    this._languages,
    this.locale,
  ) : super(const PlaylistSpellingState());

  final Client _client;
  final List<Language> _languages;
  final Locale locale;

  @override
  void emit(PlaylistSpellingState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  Future<void> getTranslations(Challenge challenge) async {
    emit(
      state.copyWith(
        originalPhrase: '',
        translation: '',
      ),
    );
    String? translation = '';
    var originalPhrase = '';
    if (challenge.id != '') {
      final loc = kIsWeb ? 'en' : locale.toString();

      final localeIso3 = _languages
          .firstWhere(
            (e) =>
                e.locale!.replaceFirst(RegExp('[-]'), '_') == loc ||
                e.locale!.substring(0, 2) == loc.substring(0, 2),
            orElse: Language.new,
          )
          .iso3;

      const uri = '/api/v1/translation/object';

      final response = await _client.post(
        Uri.parse(uri),
        body: '{"ObjectID":"${challenge.id}",'
            '"ObjectType":"challenge",'
            '"LanguagesISO3To":["$localeIso3"]}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if ((json.decode(response.body) as Map<String, dynamic>)['data'] ==
          null) {
        emit(
          state.copyWith(
            originalPhrase: '',
            translation: '',
          ),
        );
        return;
      }

      final results = response.mapData()['Result'] as Map<String, dynamic>;
      final translate = response.mapData()['Translate'] as Map<String, dynamic>;

      if (results.containsKey(localeIso3)) {
        translation = Translate.fromJson(
          results[localeIso3] as Map<String, dynamic>,
        ).phrase;
      }
      originalPhrase = translate['Phrase'] as String;
    }

    emit(
      state.copyWith(
        originalPhrase: originalPhrase,
        translation: translation,
      ),
    );
  }

  void switchTranslation() {
    if (state.showTranslatedPhrase) {
      emit(state.copyWith(showTranslatedPhrase: false));
    } else {
      emit(state.copyWith(showTranslatedPhrase: true));
    }
  }
}
