import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_pass_model.g.dart';

@JsonSerializable()
class PlanPassPassModel {
  PlanPassPassModel({
    this.id,
    this.campusId,
    this.planId,
    this.planElementId,
    this.planName,
    this.planDescription,
  });

  factory PlanPassPassModel.fromJson(Map<String, dynamic> json) =>
      _$PlanPassPassModelFromJson(json);

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'CampusID')
  String? campusId;
  @JsonKey(name: 'PlanID')
  String? planId;
  @JsonKey(name: 'PlanElementID')
  String? planElementId;
  @JsonKey(name: 'PlanName')
  String? planName;
  @JsonKey(name: 'PlanDescription')
  String? planDescription;

  Map<String, dynamic> toJson() => _$PlanPassPassModelToJson(this);
}

@JsonSerializable()
class PlanPassElementModel {
  PlanPassElementModel({
    this.id,
    this.type,
    this.description,
    this.other,
    this.objectId,
    this.objectName,
    this.campusPlanId,
    this.campusId,
    this.orderNum,
    this.nextElementId,
  });

  factory PlanPassElementModel.fromJson(Map<String, dynamic> json) {
    return _$PlanPassElementModelFromJson(json);
  }

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Type')
  String? type;
  @JsonKey(name: 'Description')
  String? description;
  @JsonKey(name: 'Other')
  String? other;
  @JsonKey(name: 'ObjectID')
  String? objectId;
  @JsonKey(name: 'ObjectName')
  String? objectName;
  @JsonKey(name: 'CampusPlanID')
  dynamic campusPlanId;
  @JsonKey(name: 'CampusID')
  dynamic campusId;
  @JsonKey(name: 'OrderNum')
  int? orderNum;
  @JsonKey(name: 'NextElementID')
  dynamic nextElementId;

  Map<String, dynamic> toJson() => _$PlanPassElementModelToJson(this);
}

@JsonSerializable()
class PlanPassModel extends Equatable {
  const PlanPassModel({
    this.pass,
    this.elements,
  });

  factory PlanPassModel.fromJson(Map<String, dynamic> json) {
    return _$PlanPassModelFromJson(json);
  }

  @JsonKey(name: 'Pass')
  final PlanPassPassModel? pass;
  @JsonKey(name: 'Elements')
  final List<PlanPassElementModel>? elements;

  Map<String, dynamic> toJson() => _$PlanPassModelToJson(this);

  @override
  List<Object?> get props => [
        pass,
        elements,
      ];
}
