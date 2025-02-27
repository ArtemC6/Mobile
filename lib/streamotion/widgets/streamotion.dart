import 'dart:async';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/streamotion/cubit/models/streamotion_model.dart';
import 'package:voccent/streamotion/cubit/streamotion_cubit.dart';
import 'package:voccent/streamotion/widgets/sound_receiver_mode_button.dart';
import 'package:voccent/streamotion/widgets/streamotion_coordinate_space_widget.dart';
import 'package:voccent/streamotion/widgets/streamotion_emotion_chart.dart';
import 'package:voccent/streamotion/widgets/streamotion_floating_cloud.dart';
import 'package:voccent/streamotion/widgets/streamotion_line_chart_widget.dart';
import 'package:voccent/subscription/widgets/pay_wall.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const double leftPositioned = 2.2;
const double topPositioned = 2.6;

class Streamotion extends StatefulWidget {
  const Streamotion({super.key});

  @override
  State<Streamotion> createState() => _StreamotionState();
}

class _StreamotionState extends State<Streamotion> {
  bool isThemeDark = false;

  static const noise = 0.05;

  @override
  void initState() {
    WakelockPlus.enable();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Streamotion',
    );
    super.initState();
  }

  @override
  void deactivate() {
    context.read<StreamotionCubit>().stopRecorder();
    super.deactivate();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final user = context.read<HomeCubit>().state.user;

    return BlocBuilder<StreamotionCubit, StreamotionState>(
      builder: (context, state) {
        if (state.streamotionUserTicketToken == null) {
          if (state.isMicGranted) {
            return const Scaffold(body: _LoadingWidget());
          } else {
            return const Scaffold(body: _MicNotGrantedWidget());
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
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
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FxText.titleMedium(
                    S.current.emotionEmotions.toUpperCase(),
                    fontWeight: 700,
                    textScaleFactor: 1.46,
                    color: mTheme.primary,
                  ),
                  const _TimerStreamMotion(),
                ],
              ),
              actions: [
                if (user.credId?.endsWith('@voccent.com') ?? false)
                  const SoundReceiverModeButton(),
              ],
            ),
            body: _PayWallWidget(
              noise: noise,
              state: state,
            ),
          );
        }
      },
    );
  }
}

class _PayWallWidget extends StatelessWidget {
  const _PayWallWidget({
    required this.noise,
    required this.state,
  });

  final double noise;
  final StreamotionState state;

  @override
  Widget build(BuildContext context) {
    return PayWall(
      capabilityId: '00000000-0000-0000-0000-000000000015',
      child: GestureDetector(
        // onTapDown: (details) => context.read<StreamotionCubit>().showChart(),
        // onTapUp: (details) => context.read<StreamotionCubit>().hideChart(),
        child: ColoredBox(
          color: Colors.black,
          child: _ContentWidget(
            noise: noise,
            streamotionState: state,
          ),
        ),
      ),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({
    required this.noise,
    required this.streamotionState,
  });

  final double noise;
  final StreamotionState streamotionState;

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final currentEmotion = StreamController<StreamotionCompareModel>();
  late final currentEmotionStream = currentEmotion.stream.asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Builder(
              builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                final minEdge = min(screenHeight, screenWidth);
                return SizedBox(
                  width: minEdge,
                  height: minEdge,
                  child: StreamotionFloatingCloud(
                    displayingEmotionSink: currentEmotion.sink,
                    noise: widget.noise,
                    emotion: widget.streamotionState.emotion,
                    stackBelowWidget: Stack(
                      children: [
                        if (widget.streamotionState.isChartVisible)
                          IgnorePointer(
                            child: StreamotionCoordinateSpaceWidget(
                              noise: widget.noise,
                            ),
                          ),
                        StreamotionEmotionChart(
                          secondaryEmotions,
                          currentEmotionStream,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 22,
                  ),
                  child: FxText(
                    softWrap: true,
                    widget.streamotionState.verdict,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.1,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // Onboarding message
                if (widget.streamotionState.verdict.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Text(
                          'Streamotion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        Text(
                          // ignore: lines_longer_than_80_chars
                          'Express yourself freely in your natural voice.\n'
                          "We'll analyze your tone to provide insights.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                StreamotionLineChartWidget(
                  state: widget.streamotionState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _MicNotGrantedWidget extends StatelessWidget {
  const _MicNotGrantedWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FxText.titleMedium('Please allow access to the microphone'),
    );
  }
}

class _TimerStreamMotion extends StatefulWidget {
  const _TimerStreamMotion();

  @override
  _TimerStreamMotionState createState() => _TimerStreamMotionState();
}

class _TimerStreamMotionState extends State<_TimerStreamMotion> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _seconds ~/ 3600;
    final minutes = (_seconds % 3600) ~/ 60;
    final seconds = _seconds % 60;

    final formattedTime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}"
        ":${seconds.toString().padLeft(2, '0')}";

    return FxText(
      formattedTime,
      style: const TextStyle(fontSize: 24, color: Colors.white),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
