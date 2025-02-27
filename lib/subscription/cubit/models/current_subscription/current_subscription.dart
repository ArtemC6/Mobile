import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/subscription/cubit/models/current_subscription/price.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/subscription_current.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/tariff_table.dart';

part 'current_subscription.g.dart';

@JsonSerializable()
class CurrentSubscription {
  CurrentSubscription({
    this.price,
    this.tariffTable,
    this.subscriptionExists,
    this.subscriptionCurrent,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return _$CurrentSubscriptionFromJson(json);
  }

  @JsonKey(name: 'Price')
  Price? price;
  @JsonKey(name: 'TariffTable')
  TariffTable? tariffTable;
  @JsonKey(name: 'SubscriptionExists')
  bool? subscriptionExists;
  @JsonKey(name: 'SubscriptionCurrent')
  SubscriptionCurrent? subscriptionCurrent;

  Map<String, dynamic> toJson() => _$CurrentSubscriptionToJson(this);
}
