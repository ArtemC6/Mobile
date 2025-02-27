import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/theme/app_theme.dart';
import 'package:voccent/theme/theme_type.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._storage) : super(ThemeState(AppTheme.theme));

  final SharedPreferences _storage;

  void init() {
    AppTheme.init();

    final themeType = _storage.getString('theme_mode') == ThemeType.dark.name
        ? ThemeType.dark
        : ThemeType.light;

    _changeTheme(themeType);

    emit(ThemeState(AppTheme.theme));
  }

  Future<void> updateTheme(ThemeType themeType) async {
    _changeTheme(themeType);

    emit(ThemeState(AppTheme.theme));

    await FirebaseAnalytics.instance
        .setUserProperty(name: 'theme_mode', value: themeType.name);

    await _storage.setString(
      'theme_mode',
      themeType == ThemeType.light ? ThemeType.light.name : ThemeType.dark.name,
    );
  }

  void _changeTheme(ThemeType themeType) {
    AppTheme.themeType = themeType;
    AppTheme.theme = AppTheme.getTheme(themeType);
    AppTheme.changeFxTheme(themeType);

    final sysStyle = themeType == ThemeType.light
        ? SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarIconBrightness: Brightness.light,
          );

    SystemChrome.setSystemUIOverlayStyle(
      sysStyle.copyWith(
        systemNavigationBarColor: AppTheme.theme.colorScheme.surface,
      ),
    );
  }
}
