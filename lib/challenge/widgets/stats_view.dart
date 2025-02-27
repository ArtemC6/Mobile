import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/challenge_attempt.dart';
import 'package:voccent/mixer/cubit/models/charts_sample_data.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 6,
          ),
          FxText.bodyLarge(
            'Similarity',
            fontWeight: 600,
            color: mTheme.onSurface.withOpacity(1),
          ),
          const SizedBox(
            height: 6,
          ),
          BlocBuilder<ChallengeCubit, ChallengeState>(
            builder: (context, state) => Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SfCircularChart(
                      key: GlobalKey(),
                      series:
                          _getRadialBarDefaultSeries(state.attempt, context),
                    ),
                    _NumberCounter(
                      currentNumber: double.parse(
                        NumberFormat('##')
                            .format(state.attempt?.totalPercent ?? 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
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
                                  'Pronunciation'
                                  // ignore: lines_longer_than_80_chars
                                  ' ${state.attempt?.totalPercent.toStringAsFixed(1)}%',
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
                                  'Pitch ${state.attempt?.pitchPercent}%',
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
                            width: 20,
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
                                    color: const Color(0xFF845EC2),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                FxText(
                                  'Energy ${state.attempt?.energyPercent}%',
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
                                    color: const Color.fromRGBO(1, 174, 190, 1),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                FxText(
                                  'Breath '
                                  '${state.attempt?.pronunciationPercent}%',
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
          ),
        ],
      ),
    );
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries(
    ChallengeAttempt? attempt,
    BuildContext context,
  ) {
    final mTheme = Theme.of(context).colorScheme;

    final chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Total (${NumberFormat("##'%'").format(attempt?.totalPercent)})',
        y: attempt?.totalPercent,
        text: NumberFormat("##'%'").format(attempt?.totalPercent),
        pointColor: const Color(0xFFFF9671),
      ),
      ChartSampleData(
        x: 'Pitch (${NumberFormat("##'%'").format(attempt?.pitchPercent)})',
        y: attempt?.pitchPercent,
        text: NumberFormat("##'%'").format(attempt?.pitchPercent),
        pointColor: const Color(0xFFFF6F91),
      ),
      ChartSampleData(
        x: 'Energy (${NumberFormat("##'%'").format(attempt?.energyPercent)})',
        y: attempt?.energyPercent,
        text: NumberFormat("##'%'").format(attempt?.energyPercent),
        pointColor: const Color(0xFF845EC2),
      ),
      ChartSampleData(
        x: 'Breath '
            '(${NumberFormat("##'%'").format(attempt?.pronunciationPercent)},)',
        y: attempt?.pronunciationPercent,
        text: NumberFormat("##'%'").format(attempt?.pronunciationPercent),
        pointColor: const Color.fromRGBO(1, 174, 190, 1),
      ),
    ];

    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        trackColor: mTheme.onPrimary.withOpacity(0.95),
        maximumValue: 100,
        innerRadius: '60',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        gap: '9.8',
        radius: '106%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String,
      ),
    ];
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
    return FxText.displayLarge(
      fontSize: 70,
      fontWeight: 700,
      overflow: TextOverflow.fade,
      '$_currentNumber',
    );
  }
}
