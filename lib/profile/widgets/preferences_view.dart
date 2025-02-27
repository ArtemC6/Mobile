// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/locale/cubit/locale_state.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';
import 'package:voccent/theme/theme_type.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({required this.languagesList, super.key});
  final List<Language> languagesList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final currentLocale = localeCubit.state.locale.languageCode;
    final supportedLocales = S.delegate.supportedLocales.toString();
    final dropdownItems = languagesList
        .where(
      (language) =>
          supportedLocales.contains(language.locale!.split('-')[0]) &&
          language.locale != 'zh-CN' &&
          language.locale != 'la-LA' &&
          language.locale != 'tt-RU',
    )
        .map((language) {
      final localeData = language.locale!.split('-');

      return DropdownMenuItem<Locale>(
        value: Locale(localeData[0]),
        child: Text(
          '${language.iso2!.toUpperCase()} - ${language.name.toString().toUpperCase()}',
        ),
      );
    }).toList();
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                FeatherIcons.chevronLeft,
                size: 25,
                color: theme.colorScheme.onBackground,
              ),
            ),
            centerTitle: true,
            title: FxText.titleMedium(
              S.current.profileTabPreferences.toUpperCase(),
              fontWeight: 600,
              textScaleFactor: 1.2257,
              color: mTheme.primary,
            ),
          ),
          backgroundColor: theme.colorScheme.background,
          body: ListView(
            padding: FxSpacing.nTop(20),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                child: FxText.titleSmall(
                  S.current.preferencesTheme,
                  fontWeight: 600,
                  color: mTheme.onPrimaryContainer,
                  letterSpacing: 0.3,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FxText.bodySmall(
                      S.current.preferencesDarkTheme,
                      fontWeight: 600,
                      letterSpacing: 0,
                      color: mTheme.onBackground,
                    ),
                  ),
                  Switch.adaptive(
                    onChanged: (bool value) {
                      context.read<ThemeCubit>().updateTheme(
                            value ? ThemeType.dark : ThemeType.light,
                          );
                    },
                    value: context.read<ThemeCubit>().state.theme.brightness ==
                        Brightness.dark,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: theme.colorScheme.primary,
                  ),
                ],
              ),
              Divider(
                color: mTheme.onPrimaryContainer.withOpacity(0.5),
                thickness: 0.13,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                child: FxText.titleSmall(
                  S.current.appLanguage,
                  fontWeight: 600,
                  color: mTheme.onPrimaryContainer,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                child: FxText.titleSmall(
                  S.current.restart,
                  fontWeight: 500,
                  fontSize: 12,
                  color: mTheme.onPrimaryContainer,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: mTheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton<Locale>(
                          value: Locale(currentLocale),
                          items: dropdownItems,
                          onChanged: (Locale? selectedLanguage) {
                            if (selectedLanguage != null) {
                              localeCubit.changeLanguage(selectedLanguage);
                            } else {
                              return;
                            }
                          },
                          dropdownColor: mTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: mTheme.onPrimaryContainer,
                            letterSpacing: 0.3,
                          ),
                          icon: Icon(
                            FeatherIcons.chevronDown,
                            size: 20,
                            color: theme.colorScheme.onBackground,
                          ),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
