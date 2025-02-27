// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/onboarding/cubit/onboarding_cubit.dart';
import 'package:voccent/onboarding/view/languages_grid_view.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';
import 'package:voccent/theme/theme_type.dart';
import 'package:voccent/widgets/shake_animated_text.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class IWantToSpeackForm extends StatefulWidget {
  const IWantToSpeackForm({super.key});

  @override
  State<IWantToSpeackForm> createState() => _IWantToSpeackFormState();
}

class _IWantToSpeackFormState extends State<IWantToSpeackForm> {
  bool isProcessingCode = false;

  final _controllerCenter = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  Path _star(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (var step = 0; step < fullAngle; step += degreesPerStep.toInt()) {
      path
        ..lineTo(
          halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step),
        )
        ..lineTo(
          halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep),
        );
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  bool _isInvalidNext = false;

  void toggleIsInvalidNext() {
    setState(() {
      _isInvalidNext = !_isInvalidNext;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final athCubit = context.read<AuthCubit>().state;

    return PopScope(
      onPopInvoked: (didPop) async {
        await context.read<AuthCubit>().logout();
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 74,
                            sigmaY: 74,
                          ),
                          child: Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(.6),
                          ),
                        ),
                      ),
                      const _AnimationBackground(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BlocProvider.value(
            value: context.read<OnboardingCubit>(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: athCubit.qrCode.isEmpty
                  ? AppBar(
                      backgroundColor: Colors.transparent,
                      leadingWidth: double.infinity,
                      elevation: 0,
                      leading: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: _isInvalidNext
                                ? AnimatedTextKit(
                                    animatedTexts: [
                                      ShakeAnimatedText(
                                        S.current.languagesToLearn,
                                        textStyle: FxTextStyle.titleLarge(
                                          color: mTheme.onPrimaryContainer,
                                          fontWeight: 900,
                                        ),
                                      ),
                                    ],
                                    pause: Duration.zero,
                                  )
                                : FxText.titleLarge(
                                    S.current.languagesToLearn,
                                    color: mTheme.onPrimaryContainer,
                                    textAlign: TextAlign.center,
                                    fontWeight: 900,
                                  ),
                          ),
                        ],
                      ),
                    )
                  : null,
              body: SafeArea(
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    if (athCubit.qrCode.isNotEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: FxContainer(
                                  width: width,
                                  color: Colors.transparent,
                                  child: LanguagesGridView(
                                    callback: (d) => context
                                        .read<OnboardingCubit>()
                                        .setLanguages(d),
                                    languagesList: Dictionary.languages,
                                    languagesSelected: state.languagesIWant,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sunny,
                                    color: mTheme.onPrimaryContainer,
                                  ),
                                  Switch.adaptive(
                                    onChanged: (bool value) {
                                      context.read<ThemeCubit>().updateTheme(
                                            value
                                                ? ThemeType.dark
                                                : ThemeType.light,
                                          );
                                    },
                                    value: context
                                            .read<ThemeCubit>()
                                            .state
                                            .theme
                                            .brightness ==
                                        Brightness.dark,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  Icon(
                                    Icons.nightlight_round,
                                    color: mTheme.onPrimaryContainer,
                                  ),
                                ],
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 550),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Center(
                                    child: FxButton.medium(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onPressed: () {
                                        if (state.languagesIWant.isEmpty) {
                                          toggleIsInvalidNext();
                                          VibrationController.errorVibration();
                                          Future.delayed(
                                            const Duration(milliseconds: 600),
                                            toggleIsInvalidNext,
                                          );
                                          return;
                                        } else {
                                          //Start Confetti
                                          _controllerCenter.play();
                                          VibrationController
                                              .onPressedVibration();
                                          Future.delayed(
                                            const Duration(seconds: 2),
                                            //Stop Confetti
                                            _controllerCenter.stop,
                                          );
                                          Future.delayed(
                                            const Duration(milliseconds: 2300),
                                            () {
                                              context
                                                  .read<AuthCubit>()
                                                  .updateUserToken(
                                                    state.username,
                                                    state.languagesICan,
                                                    state.languagesIWant,
                                                    '',
                                                  );
                                            },
                                          );
                                        }
                                      },
                                      splashColor:
                                          mTheme.onSurface.withAlpha(30),
                                      backgroundColor: mTheme.primary,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FxText.bodyLarge(
                                            S.current.genericSave,
                                            color: mTheme.onPrimary,
                                            fontWeight: 700,
                                            fontSize: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FxSpacing.height(26),
                            ],
                          ),
                          Align(
                            child: SizedBox(
                              width: 75,
                              height: 150,
                              child: ConfettiWidget(
                                confettiController: _controllerCenter,
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                shouldLoop: true,
                                colors: const [
                                  Colors.green,
                                  Colors.blue,
                                  Colors.pink,
                                  Colors.orange,
                                  Colors.purple,
                                ],
                                createParticlePath: _star,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimationBackground extends StatefulWidget {
  const _AnimationBackground();

  @override
  _AnimationBackgroundState createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<_AnimationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 11).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.black, // Experiment with different colors
      end: Colors.black,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.transparent,
                _colorAnimation.value ?? Colors.transparent,
              ],
              stops: const [0.06, 1],
              radius: 1.14 + _animation.value,
            ),
          ),
        ),
      );
}
