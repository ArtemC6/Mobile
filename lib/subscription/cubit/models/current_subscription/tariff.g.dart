// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'tariff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tariff _$TariffFromJson(Map<String, dynamic> json) => Tariff(
      id: json['ID'] as String?,
      name: json['Name'] as String?,
      interval: json['Interval'],
      trial: json['Trial'],
      type: json['Type'] as String?,
    );

Map<String, dynamic> _$TariffToJson(Tariff instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'Interval': instance.interval,
      'Trial': instance.trial,
      'Type': instance.type,
    };
