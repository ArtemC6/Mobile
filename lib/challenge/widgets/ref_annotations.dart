import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class RefAnnotations extends StatefulWidget {
  const RefAnnotations({super.key});

  @override
  State<RefAnnotations> createState() => _RefAnnotationsState();
}

class _RefAnnotationsState extends State<RefAnnotations>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _currentAnnotationIndex = ValueNotifier<int>(-1);
  final _isActive = ValueNotifier<bool>(true);
  bool _isRecording = false;

  @override
  void initState() {
    final challengeState = context.read<ChallengeCubit>().state;
    final annotations = challengeState.audiosample!.annotations ?? [];

    context.read<ChallengeCubit>().stream.listen((state) {
      _isRecording = state.recorderStatus == RecorderStatus.recording;
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    )..addListener(() async {
        if (annotations.isNotEmpty) {
          try {
            final t = _animation.value;
            var index = -1;

            for (var i = 0; i < annotations.length; i++) {
              final annotation = annotations[i];

              if (t >= annotation.segmentStart! &&
                  t <= annotation.segmentEnd!) {
                index = i;
                break;
              }
            }

            if (index != _currentAnnotationIndex.value) {
              _currentAnnotationIndex.value = index;
              if (index != -1 && !_isRecording) {
                VibrationController.onPressedVibration();
              }
            }
          } catch (_) {}
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _currentAnnotationIndex.dispose();
    _isActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ChallengeCubit, ChallengeState>(
        listenWhen: (previous, current) =>
            previous.recorderStatus != current.recorderStatus ||
            previous.refPlayerStatus != current.refPlayerStatus,
        listener: (context, state) {
          _animationController.reset();
          if ((state.recorderStatus == RecorderStatus.recording ||
                  state.refPlayerStatus == PlayerStatus.playing) &&
              state.testPlayerStatus != PlayerStatus.playing &&
              _isActive.value) {
            _animation = Tween<double>(
              begin: 0,
              end: state.refDuration!.inMilliseconds.toDouble() / 1000,
            ).animate(_animationController);
            _animationController
              ..duration = state.refDuration
              ..forward();
          }
          _isActive.value = true;
        },
        builder: (context, state) {
          final mTheme = Theme.of(context).colorScheme;
          return ValueListenableBuilder<int>(
            valueListenable: _currentAnnotationIndex,
            builder: (context, currentAnnotationIndex, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _isActive,
                builder: (context, isActive, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4,
                          runSpacing: 4,
                          children: state.audiosample!.annotations!.map(
                            (e) {
                              final currentIndex =
                                  state.audiosample!.annotations!.indexOf(e);
                              final needBorder =
                                  (_currentAnnotationIndex.value ==
                                          currentIndex) &&
                                      (state.recorderStatus ==
                                              RecorderStatus.recording ||
                                          state.refPlayerStatus ==
                                              PlayerStatus.playing) &&
                                      _isActive.value &&
                                      _currentAnnotationIndex.value != -1;
                              return InkWell(
                                onTap: () {
                                  _isActive.value = false;
                                  _currentAnnotationIndex.value = currentIndex;
                                  VibrationController.onPressedVibration();
                                  Future.delayed(
                                    Duration.zero,
                                    () => context
                                        .read<ChallengeCubit>()
                                        .playRefAnnotation(e),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: needBorder
                                          ? mTheme.primary
                                          : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: mTheme.primary,
                                    boxShadow: [
                                      if (needBorder)
                                        BoxShadow(
                                          color: mTheme.primary.withOpacity(1),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                  child: FxText.titleMedium(
                                    e.transcription ?? '',
                                    color: mTheme.onPrimary,
                                    fontWeight: 600,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
}
