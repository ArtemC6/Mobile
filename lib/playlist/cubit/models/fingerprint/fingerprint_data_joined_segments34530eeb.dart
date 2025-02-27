import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/playlist/cubit/models/fingerprint/breath22cbbd85.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/pronunciation_e1cbebc6.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/prosody_c7f1eb37.dart';

part 'fingerprint_data_joined_segments34530eeb.g.dart';

@JsonSerializable()
class FingerprintDataJoinedSegments34530eeb {
  FingerprintDataJoinedSegments34530eeb({
    required this.pronunciationE1cbebc6,
    required this.prosodyC7f1eb37,
    required this.breath22cbbd85,
  });

  factory FingerprintDataJoinedSegments34530eeb.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$FingerprintDataJoinedSegments34530eebFromJson(json);
  }
  @JsonKey(name: 'pronunciation_e1cbebc6')
  PronunciationE1cbebc6 pronunciationE1cbebc6;
  @JsonKey(name: 'prosody_c7f1eb37')
  ProsodyC7f1eb37 prosodyC7f1eb37;
  @JsonKey(name: 'breath_22cbbd85')
  Breath22cbbd85 breath22cbbd85;

  Map<String, dynamic> toJson() {
    return _$FingerprintDataJoinedSegments34530eebToJson(this);
  }
}
