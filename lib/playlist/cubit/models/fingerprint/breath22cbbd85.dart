import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

import 'package:voccent/playlist/cubit/models/fingerprint/total.dart';

part 'breath22cbbd85.g.dart';

@JsonSerializable()
class Breath22cbbd85 {
  Breath22cbbd85({required this.frames, required this.total});

  factory Breath22cbbd85.fromJson(Map<String, dynamic> json) {
    return _$Breath22cbbd85FromJson(json);
  }
  List<Frame> frames;
  List<Total> total;

  double get breath {
    final b =
        total.firstWhere((element) => element.metric == 'Breath').valueMean;

    if (b < 0) return 0;

    return b;
  }

  Map<String, dynamic> toJson() => _$Breath22cbbd85ToJson(this);
}
