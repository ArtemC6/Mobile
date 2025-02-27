// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condition _$ConditionFromJson(Map<String, dynamic> json) => Condition(
      actDescription: json['ActDescription'] as String?,
      actId: json['ActID'] as String?,
      actName: json['ActName'] as String?,
      createdAt: json['CreatedAt'] as String?,
      vote: json['Vote'] as String?,
    );

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
      'ActDescription': instance.actDescription,
      'ActID': instance.actId,
      'ActName': instance.actName,
      'CreatedAt': instance.createdAt,
      'Vote': instance.vote,
    };
