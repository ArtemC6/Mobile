import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/locale/cubit/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._sharedPreferences)
      : super(LocaleState(_getSavedLocale(_sharedPreferences)));

  final SharedPreferences _sharedPreferences;

  static Locale _getSavedLocale(SharedPreferences preferences) {
    final languageCode = preferences.getString('languageCode');

    if (languageCode != null) {
      return Locale(languageCode);
    }

    return PlatformDispatcher.instance.locale;
  }

  void changeLanguage(Locale newLocale) {
    _saveLocale(newLocale);
    emit(LocaleState(newLocale));
  }

  void _saveLocale(Locale locale) {
    _sharedPreferences.setString('languageCode', locale.languageCode);
  }
}
