// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Total _$TotalFromJson(Map<String, dynamic> json) => Total(
      metric: json['Metric'] as String,
      valueMean: (json['ValueMean'] as num?)?.toDouble() ?? 0,
      valueStd: (json['ValueStd'] as num?)?.toDouble() ?? 0,
      xxValueMeanSum: (json['XxValueMeanSum'] as num?)?.toDouble() ?? 0,
      xxValueStdSum: (json['XxValueStdSum'] as num?)?.toDouble() ?? 0,
      xxCount: (json['XxCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TotalToJson(Total instance) => <String, dynamic>{
      'Metric': instance.metric,
      'ValueMean': instance.valueMean,
      'ValueStd': instance.valueStd,
      'XxValueMeanSum': instance.xxValueMeanSum,
      'XxValueStdSum': instance.xxValueStdSum,
      'XxCount': instance.xxCount,
    };
