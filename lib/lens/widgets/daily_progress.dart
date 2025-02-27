part of '../lens_library.dart';

class DailyProgress extends StatelessWidget {
  const DailyProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<LensCubit, LensState>(
      builder: (context, state) {
        final compareByDate = state.countCompareByDate;
        final maxCount = compareByDate.fold<int>(
          0,
          (previousValue, element) =>
              previousValue > element.count! ? previousValue : element.count!,
        );

        final points = <FlSpot>[];
        for (var i = 0; i < compareByDate.length; i++) {
          points.add(
            FlSpot(i.toDouble(), compareByDate[i].count?.toDouble() ?? 0),
          );
        }

        if (maxCount == 0 || compareByDate.isEmpty) return const SizedBox();

        final startDate =
            DateTime.now().subtract(Duration(days: compareByDate.length - 1));
        double determineChartHeight(int maxCount) {
          return 200;
        }

        double determineYAxisInterval(int maxCount) {
          if (maxCount == 41 || maxCount == 31 || maxCount == 21) return 7;
          if (maxCount > 100) return 30;
          if (maxCount > 90) return 40;
          if (maxCount > 70) return 30;
          if (maxCount > 60) return 25;
          if (maxCount > 50) return 15;
          if (maxCount > 30) return 10;
          if (maxCount > 20) return 5;
          if (maxCount > 10) return 2;

          return 1;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: HighlightWords().formatSpecialWord(
                  S.current.dailyProgress.toUpperCase(),
                  mTheme,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: determineChartHeight(maxCount),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: compareByDate.length.toDouble(),
                    minY: 0,
                    maxY: maxCount.toDouble(),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(drawBelowEverything: false),
                      topTitles: const AxisTitles(drawBelowEverything: false),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta titleMeta) {
                            return FxText.bodySmall(
                              '${value.toInt()}',
                              color: mTheme.onSurface.withOpacity(1),
                            );
                          },
                          interval: determineYAxisInterval(maxCount),
                          reservedSize: 28,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (double value, TitleMeta titleMeta) {
                            final date =
                                startDate.add(Duration(days: value.toInt()));
                            final locale =
                                Localizations.localeOf(context).toString();
                            final formatter = DateFormat('E', locale);
                            final dayOfWeek = formatter.format(date);

                            return FxText.bodySmall(
                              dayOfWeek.toUpperCase(),
                              color: mTheme.onSurface.withOpacity(1),
                            );
                          },
                          interval:
                              (compareByDate.length / 7).ceil().toDouble(),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: points,
                        color: mTheme.primary,
                        barWidth: 1,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            final isToday = DateTime.now()
                                    .subtract(
                                      Duration(
                                        days: compareByDate.length - 1 - index,
                                      ),
                                    )
                                    .day ==
                                DateTime.now().day;
                            return FlDotCirclePainter(
                              radius: isToday ? 3 : 0,
                              color: mTheme.primary,
                              strokeWidth: 1.5,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        shadow: Shadow(
                          color: mTheme.primary.withOpacity(0.5),
                          blurRadius: 3.5,
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: mTheme.surface,
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final textStyle = TextStyle(
                              color: mTheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                            return LineTooltipItem('${barSpot.y}', textStyle);
                          }).toList();
                        },
                      ),
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: mTheme.primary,
                              strokeWidth: 0.5,
                            ),
                            FlDotData(
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: 8,
                                color: mTheme.primary,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                            ),
                          );
                        }).toList();
                      },
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
