import 'package:json_annotation/json_annotation.dart';

part 'dp.g.dart';

@JsonSerializable()
class Dp {
  Dp({
    required this.segmentStartTest,
    required this.segmentEndTest,
    required this.segmentStartRef,
    required this.segmentEndRef,
  });

  factory Dp.fromJson(Map<String, dynamic> json) => _$DpFromJson(json);
  @JsonKey(name: 'SegmentStartTest')
  double segmentStartTest;
  @JsonKey(name: 'SegmentEndTest')
  double segmentEndTest;
  @JsonKey(name: 'SegmentStartRef')
  double segmentStartRef;
  @JsonKey(name: 'SegmentEndRef')
  double segmentEndRef;

  Map<String, dynamic> toJson() => _$DpToJson(this);
}
