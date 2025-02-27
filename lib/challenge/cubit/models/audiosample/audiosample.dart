import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/challenge/cubit/models/audiosample/annotation.dart';

part 'audiosample.g.dart';

@JsonSerializable()
class Audiosample {
  Audiosample({
    this.label,
    this.isRef,
    this.isPublic,
    this.isShared,
    this.typeId,
    this.annotations,
    this.id,
  }) {
    annotations?.sort(
      (a, b) => a.segmentStart!.compareTo(b.segmentStart!),
    );
  }

  factory Audiosample.fromJson(Map<String, dynamic> json) {
    return _$AudiosampleFromJson(json);
  }

  @JsonKey(name: 'Label')
  String? label;
  @JsonKey(name: 'IsRef')
  bool? isRef;
  @JsonKey(name: 'IsPublic')
  dynamic isPublic;
  @JsonKey(name: 'IsShared')
  dynamic isShared;
  @JsonKey(name: 'TypeID')
  String? typeId;
  @JsonKey(name: 'Annotations')
  List<Annotation>? annotations;
  @JsonKey(name: 'ID')
  String? id;

  Map<String, dynamic> toJson() => _$AudiosampleToJson(this);
}
