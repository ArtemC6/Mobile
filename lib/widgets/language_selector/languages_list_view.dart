import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/widgets/language_selector/language_selector.dart';

class LanguagesListView extends StatefulWidget {
  const LanguagesListView({
    required this.languagesList,
    required this.languagesSelected,
    required this.callback,
    super.key,
  });

  final List<Language> languagesList;
  final List<Language> languagesSelected;
  final SetLanguage callback;

  @override
  State<LanguagesListView> createState() => _LanguagesListViewState();
}

class _LanguagesListViewState extends State<LanguagesListView> {
  List<Language> _languagesList = [];
  List<Language> _languagesSelected = [];

  @override
  void initState() {
    _languagesList = widget.languagesList;
    _languagesSelected = widget.languagesSelected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            FeatherIcons.chevronLeft,
            size: 25,
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 3,
                    interactive: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: ListView(
                        children: _languagesList
                            .map(
                              (language) => FxButton.small(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: mTheme.primary.withOpacity(0.45),
                                    width: 0.8,
                                  ),
                                ),
                                elevation: 0,
                                backgroundColor: _languagesSelected.any(
                                  (languageSelected) =>
                                      languageSelected.id == language.id,
                                )
                                    ? mTheme.primary
                                    : Colors.transparent,
                                onPressed: () {
                                  final langs = List<Language>.from(
                                    _languagesSelected,
                                  );
                                  if (langs.any((e) => e.id == language.id)) {
                                    langs.removeWhere(
                                      (e) => e.id == language.id,
                                    );
                                  } else {
                                    langs.add(
                                      Language(
                                        id: language.id,
                                        name: language.name,
                                      ),
                                    );
                                  }

                                  setState(() {
                                    _languagesSelected = langs;
                                  });

                                  widget.callback(
                                    Language(
                                      id: language.id,
                                      name: language.name,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: FxText.bodyLarge(
                                    language.name!,
                                    color: _languagesSelected.any(
                                      (languageSelected) =>
                                          languageSelected.id == language.id,
                                    )
                                        ? mTheme.onPrimary
                                        : mTheme.onSurface,
                                    fontWeight: 600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
