import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'emotion_frame.g.dart';

@JsonSerializable()
class EmotionFrame {
  EmotionFrame({
    required this.segmentStart,
    required this.segmentEnd,
    required this.valenceRef,
    required this.arousalRef,
    required this.valenceTest,
    required this.arousalTest,
  });

  factory EmotionFrame.fromJson(Map<String, dynamic> json) =>
      _$EmotionFrameFromJson(json);

  @JsonKey(name: 'SegmentStart')
  double segmentStart;
  @JsonKey(name: 'SegmentEnd')
  double segmentEnd;
  @JsonKey(name: 'valence_ref')
  double valenceRef;
  @JsonKey(name: 'arousal_ref')
  double arousalRef;
  @JsonKey(name: 'valence_test')
  double valenceTest;
  @JsonKey(name: 'arousal_test')
  double arousalTest;

  @JsonKey(includeToJson: false)
  double get circleValenceRef =>
      valenceRef * sqrt(1 - arousalRef * arousalRef / 2);

  @JsonKey(includeToJson: false)
  double get circleArousalRef =>
      arousalRef * sqrt(1 - valenceRef * valenceRef / 2);

  @JsonKey(includeToJson: false)
  double get circleValenceTest =>
      valenceTest * sqrt(1 - arousalTest * arousalTest / 2);

  @JsonKey(includeToJson: false)
  double get circleArousalTest =>
      arousalTest * sqrt(1 - valenceTest * valenceTest / 2);

  Map<String, dynamic> toJson() => _$EmotionFrameToJson(this);
}
