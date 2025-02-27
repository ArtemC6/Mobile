import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/dp.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/total.dart';

part 'pronunciation_e1cbebc6.g.dart';

@JsonSerializable()
class PronunciationE1cbebc6 {
  PronunciationE1cbebc6({
    required this.frames,
    required this.total,
    required this.dp,
  });

  factory PronunciationE1cbebc6.fromJson(Map<String, dynamic> json) {
    return _$PronunciationE1cbebc6FromJson(json);
  }
  List<Frame> frames;
  List<Total> total;
  List<Dp> dp;

  double get anMmfcc {
    final v =
        total.firstWhere((element) => element.metric == 'AnMMFCC').valueMean;

    if (v < 0) return 0;

    return v;
  }

  double get anMplp {
    final v =
        total.firstWhere((element) => element.metric == 'AnMPLP').valueMean;

    if (v < 0) return 0;

    return v;
  }

  double get combinedTotal {
    if (total.isEmpty) return 0;

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

  Map<String, dynamic> toJson() => _$PronunciationE1cbebc6ToJson(this);
}
