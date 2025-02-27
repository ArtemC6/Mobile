// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'subscription_current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCurrent _$SubscriptionCurrentFromJson(Map<String, dynamic> json) =>
    SubscriptionCurrent(
      userId: json['UserID'] as String?,
      trial: (json['Trial'] as num?)?.toInt(),
      periodStart: json['PeriodStart'] == null
          ? null
          : DateTime.parse(json['PeriodStart'] as String),
      periodEnd: json['PeriodEnd'] == null
          ? null
          : DateTime.parse(json['PeriodEnd'] as String),
      isApproved: json['IsApproved'] as bool?,
      googlePlayProductId: json['GooglePlayProductID'] as String?,
      googlePlayPurchaseToken: json['GooglePlayPurchaseToken'] as String?,
      tariffCurrencyId: json['TariffCurrencyID'] as String?,
      source: json['Source'] as String?,
    );

Map<String, dynamic> _$SubscriptionCurrentToJson(
        SubscriptionCurrent instance) =>
    <String, dynamic>{
      'UserID': instance.userId,
      'Trial': instance.trial,
      'PeriodStart': instance.periodStart?.toIso8601String(),
      'PeriodEnd': instance.periodEnd?.toIso8601String(),
      'IsApproved': instance.isApproved,
      'GooglePlayProductID': instance.googlePlayProductId,
      'GooglePlayPurchaseToken': instance.googlePlayPurchaseToken,
      'TariffCurrencyID': instance.tariffCurrencyId,
      'Source': instance.source,
    };
