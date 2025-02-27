import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/locale/cubit/locale_cubit.dart';
import 'package:voccent/mixer/cubit/mixer_cubit.dart';
import 'package:voccent/mixer/cubit/models/charts_sample_data.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/dialog.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class MixerWidget extends StatefulWidget {
  const MixerWidget({super.key});

  @override
  State<MixerWidget> createState() => _MixerWidgetState();
}

class _MixerWidgetState extends State<MixerWidget>
    with SingleTickerProviderStateMixin {
  bool _isOverlayVisible = true;
  bool _isOverlayVisibleLoading = true;
  Duration _audioSampleRefDuration = Duration.zero;

  late final _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelProgress(
        refDuration: _audioSampleRefDuration,
      ),
    ),
  );

  late final _overlayEntryLoading = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfo(
        infoText: S.current.wait,
      ),
    ),
  );

  @override
  void dispose() {
    if (!_isOverlayVisibleLoading && _overlayEntryLoading.mounted) {
      _overlayEntryLoading.remove();
    }

    if (_overlayEntry.mounted && !_isOverlayVisible) {
      _overlayEntry.remove();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: mTheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          'MIXER',
          fontWeight: 900,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      body: BlocProvider(
        create: (context) => MixerCubit(
          context.read<UserScopeClient>(),
          Dictionary.languages,
          context.read<LocaleCubit>().state.locale,
          context.read<UpdaterService>(),
        )..fetch(),
        child: BlocConsumer<MixerCubit, MixerState>(
          listenWhen: (previous, current) =>
              previous.recorderStatus != current.recorderStatus,
          listener: (context, state) {
            if (state.recorderStatus == RecorderStatus.recording &&
                _isOverlayVisible) {
              _audioSampleRefDuration = state.refDuration!;
              Overlay.of(context).insert(_overlayEntry);
              _isOverlayVisible = false;
            }

            if (state.recorderStatus != RecorderStatus.recording) {
              if (!_isOverlayVisible && _overlayEntry.mounted) {
                _overlayEntry.remove();
                _isOverlayVisible = true;
              }
            }

            if (state.recorderStatus == RecorderStatus.failed) {
              showInfoDialog(context, S.current.cancelled, null);
            }

            if (state.recorderStatus == RecorderStatus.starting ||
                state.recorderStatus == RecorderStatus.analyzing) {
              if (_isOverlayVisibleLoading && !_overlayEntryLoading.mounted) {
                Overlay.of(context).insert(_overlayEntryLoading);
                _isOverlayVisibleLoading = false;
              }
            } else {
              if (!_isOverlayVisibleLoading && _overlayEntryLoading.mounted) {
                _isOverlayVisibleLoading = true;
                _overlayEntryLoading.remove();
              }
            }
          },
          builder: (context, state) {
            if (state.refPlayerStatus == PlayerStatus.downloading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return PopScope(
              canPop: state.recorderStatus != RecorderStatus.recording &&
                  state.recorderStatus != RecorderStatus.starting &&
                  state.recorderStatus != RecorderStatus.analyzing,
              child: SafeArea(
                child: _build(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _build(BuildContext context, MixerState state) {
    final mTheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final p = state.step / (state.model?.countItems ?? 1);
    final energy = state.fingerprint?.comparePercentEnergy ?? 0;

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        ListView(
          children: [
            if (p > 0)
              PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: LinearProgressIndicator(
                  value: p,
                  backgroundColor: mTheme.surface,
                ),
              )
            else
              const SizedBox(),
            const ChartWidget(),
            ShrinkOnTapWidget(
              shrinkScale: 0.96,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: FxButton.block(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () =>
                      context.read<MixerCubit>().switchTranslation(),
                  backgroundColor: mTheme.onPrimary.withOpacity(0.95),
                  child: Row(
                    children: [
                      if (state.translationLoaded == false)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: mTheme.primary,
                          ),
                        ),
                      if (state.translationLoaded == true)
                        Icon(
                          Icons.translate,
                          color: mTheme.onSecondary,
                          size: 20,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          child: FxText.bodyLarge(
                            state.showTranslatedPhrase
                                ? state.translation
                                : state.originalPhrase,
                            color: mTheme.onSecondary,
                            fontWeight: 700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ShrinkOnTapWidget(
                    shrinkScale: 0.96,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Shimmer(
                          colorOpacity: 0.6,
                          duration: const Duration(seconds: 4),
                          interval: const Duration(milliseconds: 400),
                          enabled: state.translationLoaded != false,
                          child: FxContainer(
                            width: width / 2,
                            height: height / 17,
                            onTap: () => context.read<MixerCubit>().playRef(),
                            color: mTheme.primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FeatherIcons.volume2,
                                  color: mTheme.onPrimary,
                                  size: 24,
                                ),
                                FxSpacing.width(8),
                                FxText.bodyLarge(
                                  S.current.playlistListen,
                                  fontWeight: 700,
                                  color: mTheme.onPrimary,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ShrinkOnTapWidget(
                    shrinkScale: 0.96,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Shimmer(
                          colorOpacity: 0.6,
                          enabled: state.translationLoaded != false,
                          child: GestureDetector(
                            onLongPress: () {
                              VibrationController.onPressedVibration();
                              context.read<MixerCubit>().record();
                            },
                            onLongPressUp: () {
                              VibrationController.onPressedVibration();
                              context.read<MixerCubit>().stopRecorder();
                            },
                            child: FxContainer(
                              width: width / 2,
                              height: height / 17,
                              onTap: () {
                                if (state.recorderStatus !=
                                    RecorderStatus.analyzing) {
                                  VibrationController.onPressedVibration();
                                  context.read<MixerCubit>().record();
                                }
                                if (state.recorderStatus ==
                                    RecorderStatus.recording) {
                                  VibrationController.onPressedVibration();
                                  context.read<MixerCubit>().stopRecorder();
                                }
                              },
                              color: mTheme.secondary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        state.recorderStatus ==
                                                RecorderStatus.recording
                                            ? Icons.pause
                                            : FeatherIcons.mic,
                                        color: mTheme.onSecondary,
                                        size: 24,
                                      ),
                                      FxSpacing.width(8),
                                      FxText.bodyLarge(
                                        (state.recorderStatus ==
                                                RecorderStatus.recording)
                                            ? '${state.attemptText} '
                                            : state.attemptText,
                                        fontWeight: 700,
                                        fontSize: 14,
                                        color: mTheme.onSecondary,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ],
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  if (state.step > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: ShrinkOnTapWidget(
                          shrinkScale: 0.96,
                          child: FxButton.block(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPressed: () => context.read<MixerCubit>().prev(),
                            backgroundColor: mTheme.onPrimary.withOpacity(0.95),
                            child: Icon(
                              FeatherIcons.chevronLeft,
                              color: mTheme.onSecondary,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (state.step < (state.model?.countItems ?? 0) - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: ShrinkOnTapWidget(
                          shrinkScale: 0.96,
                          child: FxButton.block(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPressed: () => context.read<MixerCubit>().next(),
                            backgroundColor: mTheme.onPrimary.withOpacity(0.95),
                            child: Icon(
                              FeatherIcons.chevronRight,
                              color: mTheme.onSecondary,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        RiveComparisonAnimation(
          percentage: energy,
          artboard: 'confetti',
          key: ValueKey(
            energy,
          ),
        ),
      ],
    );
  }
}

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries(
    BuildContext context,
    double percent,
    double pitch,
    double energy,
    double breath,
    double total,
    double emotion,
  ) {
    final mTheme = Theme.of(context).colorScheme;

    final chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Total (${NumberFormat("##'%'").format(percent)})',
        y: percent,
        text: NumberFormat("##'%'").format(percent),
        pointColor: const Color(0xFFFF9671),
      ),
      ChartSampleData(
        x: 'Pitch (${NumberFormat("##'%'").format(pitch)})',
        y: pitch,
        text: NumberFormat("##'%'").format(pitch),
        pointColor: const Color(0xFFFF6F91),
      ),
      ChartSampleData(
        x: 'Energy (${NumberFormat("##'%'").format(energy)})',
        y: energy,
        text: NumberFormat("##'%'").format(energy),
        pointColor: const Color(0xFF845EC2),
      ),
      ChartSampleData(
        x: 'Breath (${NumberFormat("##'%'").format(breath)})',
        y: breath,
        text: NumberFormat("##'%'").format(breath),
        pointColor: const Color.fromRGBO(1, 174, 190, 1),
      ),
      ChartSampleData(
        x: 'New (${NumberFormat("##'%'").format(breath)})',
        y: emotion,
        text: NumberFormat("##'%'").format(breath),
        pointColor: Colors.amberAccent,
      ),
    ];

    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        trackColor: mTheme.onPrimary.withOpacity(0.95),
        animationDuration: 0,
        maximumValue: 100,
        innerRadius: '60',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        gap: '9.8',
        radius: '104%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final state = context.watch<MixerCubit>().state;
    final breath = state.fingerprint?.comparePercentBreath ?? 0;
    final energy = state.fingerprint?.comparePercentEnergy ?? 0;
    final pitch = state.fingerprint?.comparePercentPitch ?? 0;
    final emotion = state.emotion?.comparePercent ?? 0;

    final percent = state.fingerprint?.fingerprintDataJoinedSegments34530eeb
            .pronunciationE1cbebc6.combinedTotal ??
        0;

    final total =
        _calculateOverallScore(percent, pitch, energy, breath, emotion);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (emotion > 0)
          Container(
            padding: const EdgeInsets.only(bottom: 120),
            child: _NumberCounter(
              currentNumber: total,
            ),
          ),
        Column(
          children: [
            FxContainer(
              height: 364,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              child: SfCircularChart(
                key: GlobalKey(),
                series: _getRadialBarDefaultSeries(
                  context,
                  percent,
                  pitch,
                  energy,
                  breath,
                  total,
                  emotion,
                ),
              ),
            ),
            if (percent > 0 || pitch > 0 || energy > 0 || breath > 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        FxText(
                          '${S.current.genericEmotion} $emotion%',
                          color: mTheme.onSurface.withOpacity(1),
                          fontWeight: 700,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 34,
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9671),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FxText(
                                '${S.current.genericPronunciation} $percent%',
                                color: mTheme.onSurface.withOpacity(1),
                                fontWeight: 600,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6F91),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FxText(
                                '${S.current.genericPitch} $pitch%',
                                color: mTheme.onSurface.withOpacity(1),
                                fontWeight: 600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 34,
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FxText(
                                '${S.current.genericEnergy} $energy%',
                                color: mTheme.onSurface.withOpacity(1),
                                fontWeight: 600,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00B7FF),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FxText(
                                '${S.current.genericBreath} $breath%',
                                color: mTheme.onSurface.withOpacity(1),
                                fontWeight: 600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _NumberCounter extends StatefulWidget {
  const _NumberCounter({
    required this.currentNumber,
  });

  final double currentNumber;

  @override
  _NumberCounterState createState() => _NumberCounterState();
}

class _NumberCounterState extends State<_NumberCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.currentNumber,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _currentNumber = _animation.value.toInt();
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return FxText.bodyLarge(
      '$_currentNumber',
      fontWeight: 900,
      fontSize: 64,
      color: mTheme.onPrimary,
      overflow: TextOverflow.fade,
    );
  }
}

double _calculateOverallScore(
  double pronunciationPercent,
  double pitchPercent,
  double energyPercent,
  double breathPercent,
  double emotionPercent,
) {
  return (pronunciationPercent * 80.0 +
              pitchPercent * 6.0 +
              energyPercent * 2.0 +
              breathPercent * 2.0 +
              emotionPercent * 10.0)
          .roundToDouble() /
      100.0;
}
