import 'package:json_annotation/json_annotation.dart';

part 'pass.g.dart';

@JsonSerializable()
class Pass {
  const Pass({
    this.id,
    this.createdat,
    this.campusId,
    this.campusName,
    this.planId,
    this.planElementId,
    this.planName,
    this.planDescription,
    this.startAt,
    this.endAt,
    this.percent,
  });

  factory Pass.fromJson(Map<String, dynamic> json) => _$PassFromJson(json);
  @JsonKey(name: 'ID')
  final String? id;
  final DateTime? createdat;
  @JsonKey(name: 'CampusID')
  final String? campusId;
  @JsonKey(name: 'CampusName')
  final String? campusName;
  @JsonKey(name: 'PlanID')
  final String? planId;
  @JsonKey(name: 'PlanElementID')
  final String? planElementId;
  @JsonKey(name: 'PlanName')
  final String? planName;
  @JsonKey(name: 'PlanDescription')
  final String? planDescription;
  @JsonKey(name: 'StartAt')
  final DateTime? startAt;
  @JsonKey(name: 'EndAt')
  final DateTime? endAt;
  @JsonKey(name: 'Percent')
  final dynamic percent;

  Map<String, dynamic> toJson() => _$PassToJson(this);
}
