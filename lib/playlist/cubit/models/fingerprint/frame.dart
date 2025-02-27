import 'package:json_annotation/json_annotation.dart';

part 'frame.g.dart';

@JsonSerializable()
class Frame {
  Frame({
    this.segmentStart = 0,
    this.segmentEnd = 0,
    this.breath = 0,
    this.energy = 0,
    this.pitch = 0,
    this.anMmfcc = 0,
    this.anMplp = 0,
  });

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  @JsonKey(name: 'SegmentStart', defaultValue: 0)
  double segmentStart;
  @JsonKey(name: 'SegmentEnd', defaultValue: 0)
  double segmentEnd;
  @JsonKey(name: 'Breath', defaultValue: 0)
  double breath;
  @JsonKey(name: 'Energy', defaultValue: 0)
  double energy;
  @JsonKey(name: 'Pitch', defaultValue: 0)
  double pitch;
  @JsonKey(name: 'AnMMFCC', defaultValue: 0)
  double anMmfcc;
  @JsonKey(name: 'AnMPLP', defaultValue: 0)
  double anMplp;

  Map<String, dynamic> toJson() => _$FrameToJson(this);

  double get combinedPronunciation {
    if (anMmfcc > -1 && anMplp > -1) {
      return 0.5 * anMmfcc + 0.5 * anMplp;
    } else if (anMmfcc > -1) {
      return anMmfcc;
    } else if (anMplp > -1) {
      return anMplp;
    } else {
      return 0;
    }
  }

  double get positiveEnergy {
    if (energy >= 0) {
      return energy;
    } else {
      return 0;
    }
  }

  double get positivePitch {
    if (pitch >= 0) {
      return pitch;
    } else {
      return 0;
    }
  }
}
