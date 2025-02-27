part of '../lens_library.dart';

class Mixer extends StatelessWidget {
  const Mixer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        return FxContainer(
          padding: const EdgeInsets.symmetric(vertical: 30),
          onTap: () async {
            VibrationController.onPressedVibration();
            if (state.mixerModel == null) {
              await Dice.fetchDice(
                context.read<UserScopeClient>(),
              ).then((dice) {
                GoRouter.of(context).push(
                  '/${dice.$2}/${dice.$1}',
                );
              });
            } else {
              await GoRouter.of(context).push('/mixer');
            }
          },
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2 - 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width / 2,
                      ),
                      child: HighlightWords().formatSpecialWord(
                        S.current.repeatDoNotForget,
                        mTheme,
                      ),
                    ),
                    FxSpacing.height(8),
                    FxText.titleMedium(
                      '${S.current.mixerAbout1}.\n'
                      '${S.current.mixerAbout2}',
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
              Lottie.asset(
                'assets/lottie/mixer.json',
                width: 160,
                height: 160,
                repeat: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
