import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/classroom/cubit/models/classroom.dart';
import 'package:voccent/classroom/cubit/models/confirmation.dart';

part 'classroom_object.g.dart';

@JsonSerializable()
class ClassroomObject extends Equatable {
  const ClassroomObject({
    this.classroom,
    this.confirmation,
  });

  factory ClassroomObject.fromJson(Map<String, dynamic> json) =>
      _$ClassroomObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ClassroomObjectToJson(this);

  @JsonKey(name: 'Classroom')
  final Classroom? classroom;
  @JsonKey(name: 'Confirmation')
  final Confirmation? confirmation;

  @override
  List<Object?> get props => [
        classroom,
        confirmation,
      ];
}
