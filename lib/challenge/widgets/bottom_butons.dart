import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/view/result_details_view.dart';
import 'package:voccent/challenge/widgets/recordihg_animation_wrapper.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class BottomButons extends StatefulWidget {
  const BottomButons({
    super.key,
  });

  @override
  State<BottomButons> createState() => _BottomButonsState();
}

class _BottomButonsState extends State<BottomButons>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        final result = state.attempt?.totalPercent ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FxContainer.rounded(
                onTap: () {
                  VibrationController.onPressedVibration();
                  context.read<ChallengeCubit>().playRef();
                },
                paddingAll: 16,
                color: Colors.transparent,
                borderColor: mTheme.primary,
                bordered: true,
                child: Icon(
                  FeatherIcons.volume2,
                  color: mTheme.onSurface.withOpacity(1),
                ),
              ),
              if (state.challenge?.mode == 'interactive')
                GestureDetector(
                  onLongPress: () {
                    if (state.recorderStatus != RecorderStatus.analyzing) {
                      VibrationController.onPressedVibration();
                      context.read<ChallengeCubit>().record();
                    }
                  },
                  onLongPressUp: () {
                    context.read<ChallengeCubit>().stopRecorder();
                  },
                  onTap: () {
                    if (state.recorderStatus != RecorderStatus.analyzing) {
                      VibrationController.onPressedVibration();
                      context.read<ChallengeCubit>().record();
                    }
                    if (state.recorderStatus == RecorderStatus.recording) {
                      VibrationController.onPressedVibration();
                      context.read<ChallengeCubit>().stopRecorder();
                    }
                  },
                  child: RecordingAnimationWrapper(
                    isLoading: state.recorderStatus == RecorderStatus.analyzing,
                    isRecording:
                        state.recorderStatus == RecorderStatus.starting ||
                            state.recorderStatus == RecorderStatus.recording,
                    child: FxContainer.rounded(
                      paddingAll: 18,
                      color: mTheme.secondary,
                      child: (state.attemptText == S.current.genericFailed1)
                          ? Icon(
                              Icons.autorenew,
                              color: mTheme.onSecondary,
                              size: 40,
                            )
                          : Icon(
                              state.recorderStatus == RecorderStatus.recording
                                  ? Icons.stop_rounded
                                  : Icons.mic_none,
                              color: mTheme.onSecondary,
                              size: 40,
                            ),
                    ),
                  ),
                ),
              if (result == 0)
                const DisabledButton()
              else
                FxContainer.rounded(
                  color: Colors.transparent,
                  borderColor: mTheme.primary,
                  paddingAll: 12,
                  bordered: true,
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder<Widget>(
                      pageBuilder: (_, animation, secondaryAnimation) =>
                          BlocProvider.value(
                        value: context.read<ChallengeCubit>(),
                        child: const ResultDetails(),
                      ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(0, 1);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  ),
                  child: _RotatingButton(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DisabledButton extends StatelessWidget {
  const DisabledButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return FxContainer.rounded(
      color: Colors.transparent,
      borderColor: mTheme.onSurface.withOpacity(0.3),
      paddingAll: 12,
      bordered: true,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: Image.asset(
          'assets/images/voc_button.png',
          height: 30,
        ),
      ),
    );
  }
}

class _RotatingButton extends StatefulWidget {
  @override
  _RotatingButtonState createState() => _RotatingButtonState();
}

class _RotatingButtonState extends State<_RotatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: Random().nextInt(401) + 1600),
    );

    _rotationAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(_controller);

    _rotationAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: Image.asset(
                'assets/images/voc_button.png',
                height: 30,
              ),
            ),
          ),
        ],
      );
}
