import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/subscription/cubit/models/current_subscription/capability.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/tariff.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/value.dart';

part 'tariff_table.g.dart';

@JsonSerializable()
class TariffTable {
  TariffTable({this.tariffs, this.capabilities, this.values});

  factory TariffTable.fromJson(Map<String, dynamic> json) {
    return _$TariffTableFromJson(json);
  }

  @JsonKey(name: 'Tariffs')
  List<Tariff>? tariffs;
  @JsonKey(name: 'Capabilities')
  List<Capability>? capabilities;
  @JsonKey(name: 'Values')
  List<List<Value>>? values;

  Map<String, dynamic> toJson() => _$TariffTableToJson(this);
}
