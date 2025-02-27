import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'classroom_search_model.g.dart';

@JsonSerializable()
class ClassroomSearchModel extends Equatable {
  const ClassroomSearchModel({
    this.id,
    this.createdat,
    this.createdby,
    this.name,
    this.description,
    this.members,
    this.plans,
    this.rating,
    this.countRating,
    this.languageIds,
    this.userStatus,
    this.sourceLanguageGroup,
  });

  factory ClassroomSearchModel.fromJson(Map<String, dynamic> json) {
    return _$ClassroomSearchModelFromJson(json);
  }
  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'createdat')
  final DateTime? createdat;
  @JsonKey(name: 'createdby')
  final String? createdby;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'Members')
  final int? members;
  @JsonKey(name: 'Plans')
  final int? plans;
  @JsonKey(name: 'Rating')
  final double? rating;
  @JsonKey(name: 'CountRating')
  final int? countRating;
  @JsonKey(name: 'LanguageIDs')
  final List<String>? languageIds;
  @JsonKey(name: 'UserStatus')
  final String? userStatus;
  @JsonKey(name: 'SourceLanguageGroup')
  final int? sourceLanguageGroup;

  Map<String, dynamic> toJson() => _$ClassroomSearchModelToJson(this);

  bool isLoading() => id == null;

  @override
  List<Object?> get props => [
        id,
        createdat,
        createdby,
        name,
        description,
        members,
        plans,
        rating,
        countRating,
        languageIds,
        userStatus,
        sourceLanguageGroup,
      ];
}
