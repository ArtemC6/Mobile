import 'package:json_annotation/json_annotation.dart';

part 'capability.g.dart';

@JsonSerializable()
class Capability {
  Capability({this.id, this.name, this.type});

  factory Capability.fromJson(Map<String, dynamic> json) {
    return _$CapabilityFromJson(json);
  }

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Type')
  String? type;

  Map<String, dynamic> toJson() => _$CapabilityToJson(this);
}
