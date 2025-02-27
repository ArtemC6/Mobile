import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/auto_text_control.dart';
import 'package:voccent/widgets/loading_animation_widget.dart';

class ChallengePhraseWidget extends StatelessWidget {
  const ChallengePhraseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        return FxContainer(
          paddingAll: 0,
          marginAll: 8,
          onTap: () {
            context.read<ChallengeCubit>().switchTranslation();
          },
          color: Colors.transparent,
          child: Column(
            children: [
              if (state.originalPhrase.isEmpty)
                LoadingAnimationWidget(
                  emojis: false,
                  color: mTheme.onSurface.withOpacity(1),
                  loadingText: FxText.bodyLarge(
                    S.current.loading,
                    color: mTheme.onSurface.withOpacity(1),
                    fontWeight: 700,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Center(
                      child: AutoSizeText(
                        wrapWords: AutoTextControl.shouldWrapWords(
                          state.showTranslatedPhrase
                              ? state.translation
                              : state.originalPhrase,
                        ),
                        state.showTranslatedPhrase
                            ? state.translation
                            : state.originalPhrase,
                        style: TextStyle(
                          color: mTheme.onSurface.withOpacity(1),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                        minFontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
