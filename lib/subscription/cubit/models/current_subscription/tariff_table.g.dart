// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'tariff_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TariffTable _$TariffTableFromJson(Map<String, dynamic> json) => TariffTable(
      tariffs: (json['Tariffs'] as List<dynamic>?)
          ?.map((e) => Tariff.fromJson(e as Map<String, dynamic>))
          .toList(),
      capabilities: (json['Capabilities'] as List<dynamic>?)
          ?.map((e) => Capability.fromJson(e as Map<String, dynamic>))
          .toList(),
      values: (json['Values'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>)
              .map((e) => Value.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$TariffTableToJson(TariffTable instance) =>
    <String, dynamic>{
      'Tariffs': instance.tariffs,
      'Capabilities': instance.capabilities,
      'Values': instance.values,
    };
