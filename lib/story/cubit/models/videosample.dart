import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'videosample.g.dart';

@JsonSerializable()
class Videosample extends Equatable {
  const Videosample({
    this.duration,
    this.typeId,
    this.loop,
    this.volume,
    this.objectId,
    this.objectType,
    this.id,
    this.createdby,
  });

  factory Videosample.fromJson(Map<String, dynamic> json) {
    return _$VideosampleFromJson(json);
  }
  @JsonKey(name: 'Duration')
  final double? duration;
  @JsonKey(name: 'TypeID')
  final String? typeId;
  @JsonKey(name: 'Loop')
  final bool? loop;
  @JsonKey(name: 'Volume')
  final double? volume;
  @JsonKey(name: 'ObjectID')
  final String? objectId;
  @JsonKey(name: 'ObjectType')
  final String? objectType;
  @JsonKey(name: 'ID')
  final String? id;
  final String? createdby;

  Map<String, dynamic> toJson() => _$VideosampleToJson(this);

  Videosample copyWith({
    double? duration,
    String? typeId,
    bool? loop,
    double? volume,
    String? objectId,
    String? objectType,
    String? id,
    String? createdby,
  }) {
    return Videosample(
      duration: duration ?? this.duration,
      typeId: typeId ?? this.typeId,
      loop: loop ?? this.loop,
      volume: volume ?? this.volume,
      objectId: objectId ?? this.objectId,
      objectType: objectType ?? this.objectType,
      id: id ?? this.id,
      createdby: createdby ?? this.createdby,
    );
  }

  @override
  List<Object?> get props {
    return [
      duration,
      typeId,
      loop,
      volume,
      objectId,
      objectType,
      id,
      createdby,
    ];
  }
}
