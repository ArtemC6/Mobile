import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_frame.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/subscription/widgets/pay_wall.dart';

class EmotionChart extends StatelessWidget {
  const EmotionChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          FxText.bodyLarge(
            S.current.genericEmotion,
            fontWeight: 600,
          ),
          const SizedBox(
            height: 5,
          ),
          BlocBuilder<ChallengeCubit, ChallengeState>(
            builder: (context, state) => PayWall(
              capabilityId: '00000000-0000-0000-0000-00000000000b',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SfCircularChart(
                          series: _getDefaultPieSeries(),
                        ),
                      ),
                      SfCartesianChart(
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.top,
                        ),
                        plotAreaBorderColor: Colors.transparent,
                        primaryXAxis: const NumericAxis(
                          minimum: -1.25,
                          maximum: 1.25,
                          majorGridLines:
                              MajorGridLines(color: Colors.transparent),
                          labelFormat: ' ',
                          crossesAt: 0,
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: -1.1,
                          maximum: 1.1,
                          majorGridLines:
                              MajorGridLines(color: Colors.transparent),
                          crossesAt: 0,
                          labelFormat: ' ',
                        ),
                        series: state.attempt?.emotionData?.emotionSeries ??
                            List<ScatterSeries<EmotionFrame, double>>.empty(),
                        // plotAreaBackgroundColor: Colors.red.withOpacity(.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    final pieData = <ChartSampleData>[
      ChartSampleData(
        x: S.current.emotionContented,
        y: 1,
        text: S.current.emotionContented,
      ),
      ChartSampleData(
        x: S.current.emotionSerene,
        y: 1,
        text: S.current.emotionSerene,
      ),
      ChartSampleData(
        x: S.current.emotionNervous,
        y: 1,
        text: S.current.emotionNervous,
      ),
      ChartSampleData(
        x: S.current.emotionTense,
        y: 1,
        text: S.current.emotionTense,
      ),
      ChartSampleData(
        x: S.current.emotionAlert,
        y: 1,
        text: S.current.emotionAlert,
      ),
      ChartSampleData(
        x: S.current.emotionExcited,
        y: 1,
        text: S.current.emotionExcited,
      ),
      ChartSampleData(
        x: S.current.emotionEnthusiastic,
        y: 1,
        text: S.current.emotionEnthusiastic,
      ),
      ChartSampleData(
        x: S.current.emotionHappy,
        y: 1,
        text: S.current.emotionHappy,
      ),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData({
    this.x,
    this.y,
    this.text,
  });

  final dynamic x;
  final num? y;
  final String? text;
}
