import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/language_selector/languages_list_view.dart';

typedef SetLanguage = void Function(Language language);

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.languagesList,
    required this.languagesSelected,
    required this.callback,
    super.key,
  });

  final List<Language> languagesList;
  final List<Language> languagesSelected;
  final SetLanguage callback;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isFieldEmpty = languagesSelected.isEmpty;

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => LanguagesListView(
            languagesList: languagesList,
            languagesSelected: languagesSelected,
            callback: callback,
          ),
        ),
      ),
      child: FxContainer(
        color: Colors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.all(7),
        bordered: true,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: mTheme.onSecondary.withOpacity(0.45),
          width: 0.8,
        ),
        child: Wrap(
          children: languagesSelected.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final language = entry.value;
              return Padding(
                padding: const EdgeInsets.all(4),
                child: FxContainer(
                  padding: const EdgeInsets.all(1),
                  color: Colors.transparent,
                  child: FxText.titleMedium(
                    index != languagesSelected.length - 1
                        ? '${language.name},'
                        : '${language.name}',
                    color: mTheme.onSecondary,
                  ),
                ),
              );
            },
          ).toList()
            ..add(
              Padding(
                padding: const EdgeInsets.all(2),
                child: isFieldEmpty
                    ? Row(
                        children: [
                          Icon(
                            FeatherIcons.plusCircle,
                            color: mTheme.secondary,
                            size: 25,
                          ),
                          FxSpacing.width(8),
                          FxText.bodyMedium(
                            S.current.filterSelectLanguages,
                          ),
                        ],
                      )
                    : Icon(
                        FeatherIcons.plusCircle,
                        color: mTheme.secondary,
                        size: 25,
                      ),
              ),
            ),
        ),
      ),
    );
  }
}
