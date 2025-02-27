// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'count_compare_by_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountCompareByDate _$CountCompareByDateFromJson(Map<String, dynamic> json) =>
    CountCompareByDate(
      date: json['Date'] as String?,
      count: (json['Count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CountCompareByDateToJson(CountCompareByDate instance) =>
    <String, dynamic>{
      'Date': instance.date,
      'Count': instance.count,
    };
