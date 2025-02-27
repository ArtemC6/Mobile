import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/models/story_pass_character.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    this.doneBtnVisibility,
    super.key,
  });
  final bool? doneBtnVisibility;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDark = mTheme.brightness == Brightness.dark;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  child: BlocBuilder<StoryCubit, StoryState>(
                    builder: (context, state) => Image.network(
                      '${context.read<ServerAddress>().httpUri}/api/v1/asset/object/'
                      'story_picture/${state.story!.id}',
                      fit: BoxFit.cover,
                      errorBuilder: (p0, p1, p2) => ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 70,
                          sigmaY: 70,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey.withOpacity(
                              0.38,
                            ),
                            BlendMode.saturation,
                          ),
                          child: Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120, left: 8, right: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  color: isDark ? Colors.black : Colors.white,
                ),
                child: FxText.displayMedium(
                  S.current.storyResult,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: 600,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCharacterResults(context, state),
                ),
              ),
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (doneBtnVisibility ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        height: 72,
                        child: FloatingActionButton.extended(
                          elevation: 0,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            VibrationController.onPressedVibration();
                            Navigator.of(context).pop();
                          },
                          label: FxText.headlineSmall(
                            'OK',
                            fontWeight: 700,
                            color: mTheme.background,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          backgroundColor: mTheme.onBackground,
                        ),
                      ),
                    FxSpacing.height(16),
                  ],
                ),
              ],
            ),
          ],
        ),
        const RiveComparisonAnimation(
          percentage: 80,
          artboard: 'confetti',
        ),
      ],
    );
  }

  List<Widget> _buildCharacterResults(
    BuildContext context,
    StoryState state,
  ) {
    final characters = state.storyPassCharacters;
    final total = _total(characters).toStringAsFixed(0);
    final result = <Widget>[];
    final mTheme = Theme.of(context).colorScheme;
    final isDark = mTheme.brightness == Brightness.dark;

    for (final element in characters.values) {
      result.add(_buildSingleResult(element, mTheme, isDark));
    }

    final average = Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: isDark ? Colors.black : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.displayMedium(
              '${S.current.storyAverage} $total %',
              color: Colors.green,
              fontWeight: 600,
            ),
          ],
        ),
      ),
    );

    result.add(average);

    return result;
  }

  double _total(Map<String, StoryPassCharacter>? storyPassCharacters) {
    var chNum = 0;
    var storyFinishedTotal = 0.0;
    if (storyPassCharacters?.isNotEmpty ?? false) {
      storyPassCharacters!.forEach((key, value) {
        if ((storyPassCharacters[key]!.percent ?? 0.0) > 0.0) {
          storyFinishedTotal += storyPassCharacters[key]!.percent!;
          chNum++;
        }
      });

      if (chNum > 0) {
        storyFinishedTotal /= chNum;
        storyFinishedTotal = (storyFinishedTotal * 100).roundToDouble() / 100;
      }

      return storyFinishedTotal;
    } else {
      return 0;
    }
  }

  Widget _buildSingleResult(
    StoryPassCharacter character,
    ColorScheme mTheme,
    bool isDark,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            color: isDark ? Colors.black : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.titleMedium(
                          character.characterName ?? '',
                          color: mTheme.primary,
                          fontWeight: 600,
                          textScaleFactor: 1.3500,
                          overflow: TextOverflow.fade,
                        ),
                        FxSpacing.height(6),
                        FxText.titleMedium(
                          character.userName ?? '',
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: 600,
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.width(16),
                  FxText.titleMedium(
                    (character.percent ?? 0.0) > 0.0
                        ? '${character.percent!.toStringAsFixed(0)}%'
                        : '-',
                    color: (character.percent ?? 0.0) == 0.0
                        ? Colors.grey
                        : character.percent! > 65
                            ? Colors.green
                            : Colors.red,
                    fontWeight: 700,
                    textScaleFactor: 1.1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
