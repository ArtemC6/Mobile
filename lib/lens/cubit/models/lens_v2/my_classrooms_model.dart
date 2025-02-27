import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_classrooms_model.g.dart';

@JsonSerializable()
class MyClassroom extends Equatable {
  const MyClassroom({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.updatedby,
    this.name,
    this.description,
    this.members,
    this.plans,
    this.countRating,
    this.rating,
    this.autoAccept,
    this.userStatus,
    this.sourceLanguageID,
  });

  factory MyClassroom.fromJson(Map<String, dynamic> json) {
    return _$MyClassroomFromJson(json);
  }
  @JsonKey(name: 'ID')
  final String? id;

  final DateTime? createdat;

  final DateTime? updatedat;

  final String? createdby;

  final String? updatedby;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'Members')
  final int? members;
  @JsonKey(name: 'Plans')
  final int? plans;
  @JsonKey(name: 'CountRating')
  final int? countRating;
  @JsonKey(name: 'Rating')
  final double? rating;
  @JsonKey(name: 'AutoAccept')
  final bool? autoAccept;
  @JsonKey(name: 'UserStatus')
  final String? userStatus;
  @JsonKey(name: 'SourceLanguageID')
  final String? sourceLanguageID;

  Map<String, dynamic> toJson() => _$MyClassroomToJson(this);

  bool isLoading() => id == null;

  @override
  List<Object?> get props => [
        id,
        createdat,
        updatedat,
        createdby,
        updatedby,
        name,
        description,
        members,
        plans,
        countRating,
        rating,
        autoAccept,
        userStatus,
        sourceLanguageID,
      ];
}
