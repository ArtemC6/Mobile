import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streamotion_model.g.dart';

@JsonSerializable()
class StreamotionCompareModel extends Equatable {
  const StreamotionCompareModel({
    this.num,
    this.valence = 0,
    this.arousal = 0,
  });

  factory StreamotionCompareModel.fromJson(Map<String, dynamic> json) {
    return _$StreamotionCompareModelFromJson(json);
  }

  @JsonKey(name: 'Num')
  final int? num;
  @JsonKey(name: 'Valence')
  final double valence;
  @JsonKey(name: 'Arousal')
  final double arousal;

  @JsonKey(includeToJson: false)
  double get circleValence => valence * sqrt(1 - arousal * arousal / 2);

  @JsonKey(includeToJson: false)
  double get circleArousal => arousal * sqrt(1 - valence * valence / 2);

  Map<String, dynamic> toJson() => _$StreamotionCompareModelToJson(this);

  @override
  List<Object?> get props => [
        num,
        valence,
        arousal,
      ];

  StreamotionCompareModel copyWith({
    int? num,
    double? valence,
    double? arousal,
  }) {
    return StreamotionCompareModel(
      num: num ?? this.num,
      valence: valence ?? this.valence,
      arousal: arousal ?? this.arousal,
    );
  }
}
