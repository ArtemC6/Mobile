import 'package:json_annotation/json_annotation.dart';

part 'subscription_current.g.dart';

@JsonSerializable()
class SubscriptionCurrent {
  SubscriptionCurrent({
    this.userId,
    this.trial,
    this.periodStart,
    this.periodEnd,
    this.isApproved,
    this.googlePlayProductId,
    this.googlePlayPurchaseToken,
    this.tariffCurrencyId,
    this.source,
  });

  factory SubscriptionCurrent.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionCurrentFromJson(json);
  }

  @JsonKey(name: 'UserID')
  String? userId;
  @JsonKey(name: 'Trial')
  int? trial;
  @JsonKey(name: 'PeriodStart')
  DateTime? periodStart;
  @JsonKey(name: 'PeriodEnd')
  DateTime? periodEnd;
  @JsonKey(name: 'IsApproved')
  bool? isApproved;
  @JsonKey(name: 'GooglePlayProductID')
  String? googlePlayProductId;
  @JsonKey(name: 'GooglePlayPurchaseToken')
  String? googlePlayPurchaseToken;
  @JsonKey(name: 'TariffCurrencyID')
  String? tariffCurrencyId;
  @JsonKey(name: 'Source')
  String? source;

  Map<String, dynamic> toJson() => _$SubscriptionCurrentToJson(this);
}
