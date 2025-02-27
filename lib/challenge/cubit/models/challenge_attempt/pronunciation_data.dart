import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/dp.dart';

import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

part 'pronunciation_data.g.dart';

@JsonSerializable()
class PronunciationData {
  PronunciationData({this.frames, this.dp});

  factory PronunciationData.fromJson(Map<String, dynamic> json) {
    return _$PronunciationDataFromJson(json);
  }
  List<Frame>? frames;
  List<Dp>? dp;

  Map<String, dynamic> toJson() => _$PronunciationDataToJson(this);
}
