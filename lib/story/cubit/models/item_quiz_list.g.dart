// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'item_quiz_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemQuizList _$ItemQuizListFromJson(Map<String, dynamic> json) => ItemQuizList(
      id: json['ID'] as String?,
      orderNum: (json['OrderNum'] as num?)?.toInt(),
      variant: json['Variant'] as String?,
    );

Map<String, dynamic> _$ItemQuizListToJson(ItemQuizList instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'OrderNum': instance.orderNum,
      'Variant': instance.variant,
    };
