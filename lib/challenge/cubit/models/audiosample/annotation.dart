import 'package:json_annotation/json_annotation.dart';

part 'annotation.g.dart';

@JsonSerializable()
class Annotation {
  Annotation({
    this.segmentStart,
    this.segmentEnd,
    this.transcription,
    this.description,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return _$AnnotationFromJson(json);
  }

  @JsonKey(name: 'SegmentStart')
  double? segmentStart;
  @JsonKey(name: 'SegmentEnd')
  double? segmentEnd;
  @JsonKey(name: 'Transcription')
  String? transcription;
  @JsonKey(name: 'Description')
  String? description;

  Map<String, dynamic> toJson() => _$AnnotationToJson(this);
}
