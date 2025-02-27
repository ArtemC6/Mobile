import 'package:json_annotation/json_annotation.dart';

part 'element.g.dart';

@JsonSerializable()
class Element {
  const Element({
    this.id,
    this.type,
    this.description,
    this.objectId,
    this.objectName,
    this.campusPlanId,
    this.campusId,
    this.orderNum,
    this.nextElementId,
    this.finished,
    this.percent,
  });

  factory Element.fromJson(Map<String, dynamic> json) {
    return _$ElementFromJson(json);
  }
  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'Type')
  final String? type;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'ObjectID')
  final String? objectId;
  @JsonKey(name: 'ObjectName')
  final String? objectName;
  @JsonKey(name: 'CampusPlanID')
  final String? campusPlanId;
  @JsonKey(name: 'CampusID')
  final String? campusId;
  @JsonKey(name: 'OrderNum')
  final int? orderNum;
  @JsonKey(name: 'NextElementID')
  final String? nextElementId;
  @JsonKey(name: 'Finished')
  final bool? finished;
  @JsonKey(name: 'Percent')
  final dynamic percent;

  Map<String, dynamic> toJson() => _$ElementToJson(this);
  bool isLoading() => id == null;
}
