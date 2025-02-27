import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  const Category({
    this.id = '',
    this.name = '',
    this.fullName = '',
    this.objectID = '',
    this.children = const <Category>[],
    this.orderNum = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @JsonKey(name: 'ID')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'FullName')
  final String fullName;

  @JsonKey(name: 'ObjectID')
  final String objectID;

  @JsonKey(name: 'Children')
  final List<Category> children;

  @JsonKey(name: 'OrderNum')
  final int orderNum;
}
