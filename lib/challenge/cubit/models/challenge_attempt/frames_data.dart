import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

part 'frames_data.g.dart';

@JsonSerializable()
class FramesData {
  FramesData({
    this.frames,
  });

  factory FramesData.fromJson(Map<String, dynamic> json) {
    return _$FramesDataFromJson(json);
  }
  List<Frame>? frames;

  Map<String, dynamic> toJson() => _$FramesDataToJson(this);
}
