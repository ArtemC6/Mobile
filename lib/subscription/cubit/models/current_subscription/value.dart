import 'package:json_annotation/json_annotation.dart';

part 'value.g.dart';

@JsonSerializable()
class Value {
  Value({this.int_, this.string, this.bool_});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  static const String yes = 'Yes';
  static const String all = 'All';
  static const String preview = 'Preview';

  @JsonKey(name: 'Int')
  int? int_;

  @JsonKey(name: 'String')
  String? string;

  @JsonKey(name: 'Bool')
  bool? bool_;

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
