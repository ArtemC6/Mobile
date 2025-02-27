import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable()
class Price {
  Price({
    this.tariffId,
    this.tariffCurrencyId,
    this.tariffName,
    this.tariffInterval,
    this.tariffPrice,
    this.tariffTrial,
    this.tariffType,
    this.currencyCode,
    this.currencySign,
    this.tariffOrderNum,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  @JsonKey(name: 'TariffID')
  String? tariffId;
  @JsonKey(name: 'TariffCurrencyID')
  String? tariffCurrencyId;
  @JsonKey(name: 'TariffName')
  String? tariffName;
  @JsonKey(name: 'TariffInterval')
  String? tariffInterval;
  @JsonKey(name: 'TariffPrice')
  double? tariffPrice;
  @JsonKey(name: 'TariffTrial')
  int? tariffTrial;
  @JsonKey(name: 'TariffType')
  String? tariffType;
  @JsonKey(name: 'CurrencyCode')
  String? currencyCode;
  @JsonKey(name: 'CurrencySign')
  String? currencySign;
  @JsonKey(name: 'TariffOrderNum')
  int? tariffOrderNum;

  Map<String, dynamic> toJson() => _$PriceToJson(this);
}
