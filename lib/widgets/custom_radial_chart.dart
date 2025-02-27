import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomRadialChart extends StatelessWidget {
  const CustomRadialChart({
    required this.data,
    super.key,
  });
  final List<ChartData> data;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(color: mTheme.onSecondary),
            height: '200',
          ),
          series: [
            RadialBarSeries<ChartData, String>(
              dataSource: data,
              cornerStyle: CornerStyle.bothCurve,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              maximumValue: 100,
              innerRadius: '35',
              gap: '5',
              radius: '100%',
              dataLabelMapper: (ChartData data, _) => data.name,
              trackColor: const Color.fromARGB(255, 223, 222, 222),
            ),
          ],
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.name, this.color);

  final String x;
  final double y;
  final Color color;
  final String name;
}
