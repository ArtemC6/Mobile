import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Name')
  String? name;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
