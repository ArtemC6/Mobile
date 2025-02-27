import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comparison.g.dart';

@JsonSerializable()
class Comparison extends Equatable {
  const Comparison({
    this.actId,
    this.audioId,
    this.compareEmotionPercent,
    this.compareBreathPercent,
    this.compareEnergyPercent,
    this.comparePercent,
    this.comparePitchPercent,
    this.comparePronunciationPercent,
    this.itemId,
    this.xpAdd,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) =>
      _$ComparisonFromJson(json);
  Map<String, dynamic> toJson() => _$ComparisonToJson(this);

  @JsonKey(name: 'ActID')
  final String? actId;
  @JsonKey(name: 'AudioID')
  final String? audioId;
  @JsonKey(name: 'CompareEmotionPercent')
  final double? compareEmotionPercent;
  @JsonKey(name: 'CompareBreathPercent')
  final double? compareBreathPercent;
  @JsonKey(name: 'CompareEnergyPercent')
  final double? compareEnergyPercent;
  @JsonKey(name: 'ComparePercent')
  final double? comparePercent;
  @JsonKey(name: 'ComparePitchPercent')
  final double? comparePitchPercent;
  @JsonKey(name: 'ComparePronunciationPercent')
  final double? comparePronunciationPercent;
  @JsonKey(name: 'ItemID')
  final String? itemId;
  @JsonKey(name: 'XPAdd')
  final int? xpAdd;

  @override
  List<Object?> get props => [actId, itemId];

  double? get total {
    if (comparePronunciationPercent == null ||
        comparePitchPercent == null ||
        compareEnergyPercent == null ||
        compareBreathPercent == null) {
      return null;
    }

    return (comparePronunciationPercent! * 80.0 +
                comparePitchPercent! * 6.0 +
                compareEnergyPercent! * 2.0 +
                compareBreathPercent! * 2.0 +
                (compareEmotionPercent ?? 0) * 10.0)
            .round() /
        100.0;
  }
}
