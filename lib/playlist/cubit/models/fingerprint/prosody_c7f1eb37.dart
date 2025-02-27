import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

import 'package:voccent/playlist/cubit/models/fingerprint/total.dart';

part 'prosody_c7f1eb37.g.dart';

@JsonSerializable()
class ProsodyC7f1eb37 {
  ProsodyC7f1eb37({required this.frames, required this.total});

  factory ProsodyC7f1eb37.fromJson(Map<String, dynamic> json) {
    return _$ProsodyC7f1eb37FromJson(json);
  }
  List<Frame> frames;
  List<Total> total;

  double get pitch {
    final v =
        total.firstWhere((element) => element.metric == 'Pitch').valueMean;

    if (v < 0) return 0;

    return v;
  }

  double get energy {
    final v =
        total.firstWhere((element) => element.metric == 'Energy').valueMean;

    if (v < 0) return 0;

    return v;
  }

  Map<String, dynamic> toJson() => _$ProsodyC7f1eb37ToJson(this);
}
