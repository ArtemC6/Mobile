import 'package:json_annotation/json_annotation.dart';

part 'total.g.dart';

@JsonSerializable()
class Total {
  Total({
    required this.metric,
    required this.valueMean,
    required this.valueStd,
    required this.xxValueMeanSum,
    required this.xxValueStdSum,
    required this.xxCount,
  });

  factory Total.fromJson(Map<String, dynamic> json) => _$TotalFromJson(json);
  @JsonKey(name: 'Metric')
  String metric;
  @JsonKey(name: 'ValueMean', defaultValue: 0)
  double valueMean;
  @JsonKey(name: 'ValueStd', defaultValue: 0)
  double valueStd;
  @JsonKey(name: 'XxValueMeanSum', defaultValue: 0)
  double xxValueMeanSum;
  @JsonKey(name: 'XxValueStdSum', defaultValue: 0)
  double xxValueStdSum;
  @JsonKey(name: 'XxCount', defaultValue: 0)
  int xxCount;

  Map<String, dynamic> toJson() => _$TotalToJson(this);
}
