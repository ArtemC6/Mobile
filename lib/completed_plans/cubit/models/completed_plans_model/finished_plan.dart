import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/element.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/pass.dart';

part 'finished_plan.g.dart';

@JsonSerializable()
class FinishedPlan {
  const FinishedPlan({this.pass, this.elements});

  factory FinishedPlan.fromJson(Map<String, dynamic> json) {
    return _$FinishedPlanFromJson(json);
  }
  @JsonKey(name: 'Pass')
  final Pass? pass;
  @JsonKey(name: 'Elements')
  final List<Element>? elements;

  Map<String, dynamic> toJson() => _$FinishedPlanToJson(this);
  bool isLoading() => pass == null;
}
