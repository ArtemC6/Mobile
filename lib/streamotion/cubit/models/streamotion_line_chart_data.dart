import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StreamotionLineChartData {
  StreamotionLineChartData({
    required this.name,
    this.spots,
    this.color,
    this.colorAccent,
  });

  final String name;
  final List<FlSpot>? spots;
  final Color? color;
  final Color? colorAccent;

  StreamotionLineChartData copyWith({
    String? name,
    List<FlSpot>? spots,
    Color? color,
    Color? colorAccent,
  }) =>
      StreamotionLineChartData(
        name: name ?? this.name,
        spots: spots ?? this.spots,
        color: color ?? this.color,
        colorAccent: colorAccent ?? this.colorAccent,
      );
}
