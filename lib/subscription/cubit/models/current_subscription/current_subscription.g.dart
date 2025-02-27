// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'current_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentSubscription _$CurrentSubscriptionFromJson(Map<String, dynamic> json) =>
    CurrentSubscription(
      price: json['Price'] == null
          ? null
          : Price.fromJson(json['Price'] as Map<String, dynamic>),
      tariffTable: json['TariffTable'] == null
          ? null
          : TariffTable.fromJson(json['TariffTable'] as Map<String, dynamic>),
      subscriptionExists: json['SubscriptionExists'] as bool?,
      subscriptionCurrent: json['SubscriptionCurrent'] == null
          ? null
          : SubscriptionCurrent.fromJson(
              json['SubscriptionCurrent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentSubscriptionToJson(
        CurrentSubscription instance) =>
    <String, dynamic>{
      'Price': instance.price,
      'TariffTable': instance.tariffTable,
      'SubscriptionExists': instance.subscriptionExists,
      'SubscriptionCurrent': instance.subscriptionCurrent,
    };
