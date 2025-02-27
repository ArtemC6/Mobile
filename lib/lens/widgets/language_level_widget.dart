part of '../lens_library.dart';

class LanguageLevelWidget extends StatelessWidget {
  const LanguageLevelWidget({required this.state, super.key});

  final LensState state;

  int _countWords(String sentence) {
    final words = sentence.split(' ');
    return words.length;
  }

  String _getFirstWord(String sentence) {
    if (_countWords(sentence) > 1) {
      final words = sentence.split(' ');
      if (words.isNotEmpty) {
        return words[0];
      } else {
        return '';
      }
    } else {
      return sentence;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final listWorkLang = context.read<HomeCubit>().state.user.worklang;
    final listStar = <CompareLevel>[];

    if (listWorkLang?.isNotEmpty ?? false) {
      for (final elementA in listWorkLang!) {
        final world = _getFirstWord(elementA.name);
        state.userCompareLevel
            .where(
              (element) => _getFirstWord(element.languageName ?? '') == world,
            )
            .forEach(listStar.add);
      }
    }

    if (listStar.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightWords().formatSpecialWord(
            S.current.languageLevel.toUpperCase(),
            mTheme,
          ),
          FxSpacing.height(16),
          SizedBox(
            height: 120,
            child: BlocBuilder<LensCubit, LensState>(
              builder: (context, state) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: listStar.length,
                  itemBuilder: (context, index) {
                    final item = listStar[index];

                    return CompareLevelAnimatedCircle(
                      lensItemCompareLevel: item,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CompareLevelAnimatedCircle extends StatelessWidget {
  const CompareLevelAnimatedCircle({
    required this.lensItemCompareLevel,
    super.key,
  });

  final CompareLevel lensItemCompareLevel;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final value = lensItemCompareLevel.value ?? 0;
    final translator = TranslateLanguageByIso3();
    final languageName =
        translator.translate('${lensItemCompareLevel.languageISO3}');

    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: 70,
              ),
              FxText.bodyLarge(
                _determineProficiencyLevel(
                  value,
                ),
                color: mTheme.onSecondary,
              ),
              SizedBox(
                width: 85,
                height: 85,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(mTheme.primary),
                ),
              ),
            ],
          ),
        ),
        FxSpacing.height(8),
        FxText.bodyMedium(
          languageName.toUpperCase(),
          color: mTheme.onSurface.withOpacity(1),
        ),
      ],
    );
  }

  String _determineProficiencyLevel(double proficiencyValue) {
    if (proficiencyValue < 20) {
      return 'A1';
    } else if (proficiencyValue < 40) {
      return 'A2';
    } else if (proficiencyValue < 60) {
      return 'B1';
    } else if (proficiencyValue < 70) {
      return 'B2';
    } else if (proficiencyValue < 80) {
      return 'C1';
    } else {
      return 'C2';
    }
  }
}
