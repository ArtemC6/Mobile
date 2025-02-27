import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_frame.dart';
import 'package:voccent/generated/l10n.dart';

part 'emotion_data.g.dart';

@JsonSerializable()
class EmotionData {
  EmotionData({
    required this.frames,
    required this.comparePercent,
  }) {
    emotionSeries = <ScatterSeries<EmotionFrame, double>>[
      ScatterSeries<EmotionFrame, double>(
        dataSource: [frames.first],
        xValueMapper: (frame, _) => frame.valenceRef,
        yValueMapper: (frame, _) => frame.arousalRef,
        color: const Color(0xffff8800),
        borderColor: Colors.black,
        markerSettings: const MarkerSettings(
          height: 12,
          width: 12,
          shape: DataMarkerType.rectangle,
        ),
        name: S.current.filterAuthor,
      ),
      ScatterSeries<EmotionFrame, double>(
        dataSource: [frames.first],
        xValueMapper: (frame, _) => frame.valenceTest,
        yValueMapper: (frame, _) => frame.arousalTest,
        color: const Color(0xff6874E8),
        borderColor: Colors.white,
        markerSettings: const MarkerSettings(
          height: 16,
          width: 16,
          shape: DataMarkerType.diamond,
          color: Color(0xff6874E8),
        ),
        name: S.current.genericYou,
      ),
    ];
  }

  factory EmotionData.fromJson(Map<String, dynamic> json) {
    return _$EmotionDataFromJson(json);
  }

  List<EmotionFrame> frames;
  @JsonKey(name: 'ComparePercent')
  double comparePercent;

  Map<String, dynamic> toJson() => _$EmotionDataToJson(this);
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<ScatterSeries<EmotionFrame, double>> emotionSeries;
}
