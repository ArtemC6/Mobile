import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'classroom.g.dart';

@JsonSerializable()
class Classroom extends Equatable {
  const Classroom({
    required this.id,
    this.name,
    this.description,
    this.privacy,
    this.createdby,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) =>
      _$ClassroomFromJson(json);
  Map<String, dynamic> toJson() => _$ClassroomToJson(this);

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'Privacy')
  final String? privacy;
  final String? createdby;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        privacy,
        createdby,
      ];
}
