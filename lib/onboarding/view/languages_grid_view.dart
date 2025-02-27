import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/guide/view/categories_translate.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/language_selector/language_selector.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class LanguagesGridView extends StatefulWidget {
  const LanguagesGridView({
    required this.languagesList,
    required this.languagesSelected,
    required this.callback,
    super.key,
  });

  final List<Language> languagesList;
  final List<Language> languagesSelected;
  final SetLanguage callback;

  @override
  State<LanguagesGridView> createState() => _LanguagesGridViewState();
}

class _LanguagesGridViewState extends State<LanguagesGridView>
    with SingleTickerProviderStateMixin {
  List<Language> _languagesList = [];
  List<Language> _languagesSelected = [];

  @override
  void initState() {
    /// Show first 8 most popular languages
    final firstLanguages = widget.languagesList
        .where(
          (language) => [
            'en-US',
            'es-ES',
            'de-DE',
            'fr-FR',
            'ja-JP',
            'ko-KR',
            'zh-CN',
            'ru-RU',
            'pl-PL',
          ].contains(language.locale),
        )
        .toList();

    /// Show the rest of the languages
    final remainingLanguages = widget.languagesList
        .where(
          (language) => ![
            'en-US',
            'es-ES',
            'de-DE',
            'fr-FR',
            'ja-JP',
            'ko-KR',
            'zh-CN',
            'ru-RU',
            'pl-PL',
          ].contains(language.locale),
        )
        .toList();

    /// List of all languages
    _languagesList = [...firstLanguages, ...remainingLanguages];

    _languagesSelected = widget.languagesSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 16,
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: AnimationLimiter(
              child: Scrollbar(
                thumbVisibility: true,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: _languagesList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 450),
                      child: SlideAnimation(
                        verticalOffset: 140,
                        child: FlipAnimation(
                          child: ScaleAnimation(
                            scale: 0.7,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: _buildItemWidget(
                                  index,
                                  _languagesList.length,
                                  mTheme,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemWidget(int index, int itemCount, ColorScheme mTheme) {
    final language = _languagesList[index];
    final isSelected = _languagesSelected.any(
      (languageSelected) => languageSelected.id == language.id,
    );

    return GestureDetector(
      onTap: () {
        final langs = List<Language>.from(_languagesSelected);
        if (langs.any((e) => e.id == language.id)) {
          langs.removeWhere((e) => e.id == language.id);
        } else {
          langs.add(
            Language(
              id: language.id,
              name: language.name,
            ),
          );
        }

        setState(() => _languagesSelected = langs);

        widget.callback(
          Language(
            id: language.id,
            name: language.name,
          ),
        );
        VibrationController.onPressedVibration();
      },
      child: FlutterColorsBorder(
        boardRadius: 100,
        size: Size(
          MediaQuery.of(context).size.width,
          500,
        ),
        available: isSelected,
        borderWidth: 1,
        colors: [
          mTheme.onSecondary,
          mTheme.primary,
          mTheme.onSecondary,
          mTheme.primary,
        ],
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(2),
          child: FxButton.small(
            onPressed: () {
              final langs = List<Language>.from(_languagesSelected);
              if (langs.any((e) => e.id == language.id)) {
                langs.removeWhere((e) => e.id == language.id);
              } else {
                langs.add(
                  Language(
                    id: language.id,
                    name: language.name,
                  ),
                );
              }

              setState(() => _languagesSelected = langs);

              widget.callback(
                Language(
                  id: language.id,
                  name: language.name,
                ),
              );
              VibrationController.onPressedVibration();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: 0,
            backgroundColor: isSelected ? mTheme.primary : mTheme.onPrimary,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (language.iso2 != null)
                  FxText.displayLarge(
                    maxLines: 1,
                    language.iso2!.toUpperCase(),
                    color: mTheme.secondary.withOpacity(0.15),
                    textAlign: TextAlign.center,
                    fontSize: 90,
                    fontWeight: 900,
                    textScaleFactor: 0.82,
                  ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: language.name!
                      .split(' ')
                      .map(
                        (word) => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: FxText.bodyLarge(
                            textScaleFactor: 1,
                            fontWeight: 900,
                            fontSize: 30,
                            word.toCapitalized(),
                            color: isSelected
                                ? mTheme.onPrimary
                                : mTheme.onSecondary,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
