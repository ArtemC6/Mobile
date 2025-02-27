import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/http/response_data.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(
    this._client,
    this._sharedPreferences,
  ) : super(
          const OnboardingState(),
        );

  final Client _client;

  final SharedPreferences _sharedPreferences;

  Future<void> load(BuildContext context) async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    final sharedPreferences = context.read<SharedPreferences>();
    final authCubit = context.read<AuthCubit>();

    await _client
        .get(
          Uri.parse(
            '/api/v1/user/available/$email',
          ),
        )
        .boolData();

    emit(
      state.copyWith(
        username: email,
      ),
    );

    final code = sharedPreferences.getString('joinCode');
    if (code != null && code.isNotEmpty) {
      await authCubit.updateUserToken(
        email,
        [Dictionary.platformLanguage()],
        Dictionary.languages
            .where((e) => e.id == '00000000-0000-0000-0000-000000000001')
            .toList(),
        code,
      );
    }
  }

  void setLanguagesICan() {
    final languagesICan = List<Language>.from(state.languagesICan);

    final languageICan = Dictionary.platformLanguage();

    languagesICan.add(languageICan);

    emit(state.copyWith(languagesICan: languagesICan));
  }

  void setLanguages(Language language) {
    setLanguagesICan();
    final languagesIWant = List<Language>.from(state.languagesIWant);

    if (languagesIWant.any((e) => e.id == language.id)) {
      languagesIWant.removeWhere((e) => e.id == language.id);
    } else {
      languagesIWant.add(language);
    }

    emit(state.copyWith(languagesIWant: languagesIWant));

    final userLang = languagesIWant
        .map(
          (e) => e.toUserLanguage(),
        )
        .toList();

    _sharedPreferences.setString(
      'search_language_filter',
      json.encode(userLang),
    );
  }
}
