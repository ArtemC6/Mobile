// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      tariffId: json['TariffID'] as String?,
      tariffCurrencyId: json['TariffCurrencyID'] as String?,
      tariffName: json['TariffName'] as String?,
      tariffInterval: json['TariffInterval'] as String?,
      tariffPrice: (json['TariffPrice'] as num?)?.toDouble(),
      tariffTrial: (json['TariffTrial'] as num?)?.toInt(),
      tariffType: json['TariffType'] as String?,
      currencyCode: json['CurrencyCode'] as String?,
      currencySign: json['CurrencySign'] as String?,
      tariffOrderNum: (json['TariffOrderNum'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'TariffID': instance.tariffId,
      'TariffCurrencyID': instance.tariffCurrencyId,
      'TariffName': instance.tariffName,
      'TariffInterval': instance.tariffInterval,
      'TariffPrice': instance.tariffPrice,
      'TariffTrial': instance.tariffTrial,
      'TariffType': instance.tariffType,
      'CurrencyCode': instance.currencyCode,
      'CurrencySign': instance.currencySign,
      'TariffOrderNum': instance.tariffOrderNum,
    };
