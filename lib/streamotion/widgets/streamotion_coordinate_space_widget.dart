import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StreamotionCoordinateSpaceWidget extends StatelessWidget {
  const StreamotionCoordinateSpaceWidget({
    required this.noise,
    super.key,
  });

  final double noise;

  @override
  Widget build(BuildContext context) {
    return const SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderColor: Colors.transparent,
      primaryXAxis: NumericAxis(
        // isVisible: false,
        axisLine: AxisLine(color: Colors.white24, dashArray: <double>[2, 2]),
        majorGridLines: MajorGridLines(color: Colors.white10),
        labelStyle: TextStyle(color: Colors.white10),
        majorTickLines: MajorTickLines(color: Colors.white, size: 3),
        title: AxisTitle(
          text: 'Valence',
          alignment: ChartAlignment.far,
          textStyle: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        labelPosition: ChartDataLabelPosition.inside,
        minimum: -1,
        maximum: 1,
        crossesAt: 0,
      ),
      primaryYAxis: NumericAxis(
        // isVisible: false,
        axisLine: AxisLine(color: Colors.white24, dashArray: <double>[2, 2]),
        majorGridLines: MajorGridLines(color: Colors.white10),
        labelStyle: TextStyle(color: Colors.white10),
        majorTickLines: MajorTickLines(color: Colors.white, size: 3),
        title: AxisTitle(
          text: 'Arousal',
          alignment: ChartAlignment.far,
          textStyle: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        labelPosition: ChartDataLabelPosition.inside,
        minimum: -1,
        maximum: 1,
        crossesAt: 0,
      ),
    );
  }
}
