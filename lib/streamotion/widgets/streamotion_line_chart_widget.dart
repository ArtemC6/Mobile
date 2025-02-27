import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:voccent/streamotion/cubit/models/streamotion_line_chart_data.dart';
import 'package:voccent/streamotion/cubit/streamotion_cubit.dart';
import 'package:voccent/streamotion/widgets/streamotion_utils.dart';

class StreamotionLineChartWidget extends StatelessWidget {
  const StreamotionLineChartWidget({
    required this.state,
    super.key,
  });

  final StreamotionState state;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    var charts = [
      // Basic charts we can really feel (extremes):
      StreamotionLineChartData(name: 'Anger'),
      StreamotionLineChartData(name: 'Curiosity'),
      StreamotionLineChartData(name: 'Frustration'),
      StreamotionLineChartData(name: 'Sadness'),
      StreamotionLineChartData(name: 'Relaxation'),
    ];

    charts = charts
        .asMap()
        .map((index, data) {
          final spots = state.distances
              .asMap()
              .map((distanceIndex, distance) {
                final normalizedDistance =
                    StreamotionUtils.normalizeDistance(distance[data.name]!);
                final spot = FlSpot(
                  distanceIndex.toDouble(),
                  normalizedDistance,
                );
                return MapEntry(distanceIndex, spot);
              })
              .values
              .toList();
          final model = secondaryEmotions[data.name];
          Color? color;
          Color? colorAccent;
          if (model != null) {
            if (data.color == null) {
              color = StreamotionUtils.getPointColor(
                model.valence,
                model.arousal,
              );
            }
            if (data.colorAccent == null) {
              colorAccent = StreamotionUtils.getPointColorAccent(
                model.valence,
                model.arousal,
              );
            }
          }
          return MapEntry(
            index,
            data.copyWith(
              spots: spots,
              color: color,
              colorAccent: colorAccent,
            ),
          );
        })
        .values
        .toList();

    if (charts.any((chart) => chart.spots != null && chart.spots!.isNotEmpty)) {
      charts.sort((chartA, chartB) {
        final maxA = chartA.spots
                ?.reduce((curr, next) => curr.y > next.y ? curr : next)
                .y ??
            0;
        final maxB = chartB.spots
                ?.reduce((curr, next) => curr.y > next.y ? curr : next)
                .y ??
            0;
        return maxB
            .compareTo(maxA); // For descending order based on max y value
      });
    }

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              // gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 50,
              minY: 0,
              maxY: 1,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipBgColor: Colors.black54,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      final chart = charts[lineBarSpot.barIndex];
                      return LineTooltipItem(
                        '${chart.name}: ${(lineBarSpot.y * 100).toInt()}%',
                        TextStyle(
                          color: chart.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          backgroundColor: Colors.black.withOpacity(
                            0.7,
                          ), // Background color for the text
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: charts.map((chart) {
                final color = chart.color ?? mTheme.primary;
                final colorAccent = chart.colorAccent ?? mTheme.primary;
                return LineChartBarData(
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        color,
                        colorAccent,
                      ].map((c) => c.withOpacity(0.3)).toList(),
                    ),
                  ),
                  spots: chart.spots ?? const [FlSpot.zero],
                  isCurved: true,
                  curveSmoothness: 0.8,
                  preventCurveOvershootingThreshold: 1,
                  preventCurveOverShooting: true,
                  dotData: const FlDotData(show: false),
                  barWidth: 1.2,
                  gradient: LinearGradient(
                    colors: [
                      color,
                      colorAccent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                );
              }).toList(),
            ),
            duration: Duration.zero,
          ),
        ),
      ],
    );
  }
}
