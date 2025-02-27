import 'package:json_annotation/json_annotation.dart';

part 'tariff.g.dart';

@JsonSerializable()
class Tariff {
  Tariff({this.id, this.name, this.interval, this.trial, this.type});

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return _$TariffFromJson(json);
  }

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Interval')
  dynamic interval;
  @JsonKey(name: 'Trial')
  dynamic trial;
  @JsonKey(name: 'Type')
  String? type;

  Map<String, dynamic> toJson() => _$TariffToJson(this);
}
